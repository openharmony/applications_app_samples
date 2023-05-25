/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import camera from '@ohos.multimedia.camera';
import media from '@ohos.multimedia.media';
import { dateTime } from '../utils/DateTimeUtils';
import Logger from '../utils/Logger';
import SaveCameraAsset from '../utils/SaveCameraAsset';

const TAG: string = 'Sample_VideoRecorder';

@Entry
@Component
struct VideoRecording {
  private surfaceId: string = '';
  xcomponentController: XComponentController = new XComponentController();
  private videoRecorder: media.AVRecorder;
  private cameraManager: camera.CameraManager;
  private cameras: any = undefined;
  private cameraInput: camera.CameraInput;
  private captureSession: camera.CaptureSession;
  private previewOutput: camera.PreviewOutput;
  private videoOutput: camera.VideoOutput;
  private videoOutSurfaceId: string = '';
  private fdPath: string = undefined;
  @State videoRecorderTimeText: string = '00:00';
  private seconds: number = 0;
  private timer: number = 0;
  private cameraIndex: number = 0;
  @State videoResolution: object = { 'frameWidth': 1280, 'frameHeight': 720};
  @State framerate: number = 30; // set default video framerate 30
  @State videoCodecType: string = 'video/avc';
  private recorderState: string = 'free';
  @State isStartRecording: boolean = false;
  @State isPauseRecording: boolean = false;
  private mSaveCameraAsset: SaveCameraAsset = new SaveCameraAsset(TAG);
  private mFileAssetId: number = 0;
  private cameraOutputCapability: camera.CameraOutputCapability = undefined;
  private videoProfiles: any = undefined;
  private previewProfiles: any = undefined;

  private avProfile = {
    audioBitrate: 200000, // set audioBitrate according to device ability
    audioChannels: 2, // set audioChannels, valid value 1-8
    audioCodec: media.CodecMimeType.AUDIO_AAC, // set audioCodec, AUDIO_AAC is the only choice
    audioSampleRate: 48000, // set audioSampleRate according to device ability
    fileFormat: media.ContainerFormatType.CFT_MPEG_4, // set fileFormat, for video is mp4
    videoBitrate: 300000, // set videoBitrate according to device ability
    videoCodec: media.CodecMimeType.VIDEO_AVC, // set videoCodec, avc or mpeg4 can be selected
    videoFrameWidth: 640, // set videoFrameWidth according to device ability
    videoFrameHeight: 480, // set videoFrameHeight according to device ability
    videoFrameRate: 30 // set videoFrameRate according to device ability
  }
  private avConfig = {
    audioSourceType: media.AudioSourceType.AUDIO_SOURCE_TYPE_MIC,
    videoSourceType: media.VideoSourceType.VIDEO_SOURCE_TYPE_SURFACE_YUV,
    profile: this.avProfile,
    url: 'fd://',
    rotation: 90, // rotation angle, 0,90,180,270 can be selected
    location: { latitude: 30, longitude: 130 } // the location you recorde
  }

  aboutToAppear(): void {
    Logger.info(TAG, 'aboutToAppear');
  }

  aboutToDisappear(): void {
    Logger.info(TAG, 'aboutToDisappear called');
    this.releaseCamera();
  }

  onPageShow(): void {
    console.info(TAG, 'onPageShow called');
    this.enterInit();
  }

  onPageHide(): void {
    console.info(TAG, 'onPageHide called');
    this.stopRecordingProcess();
  }

  async failureCallback(error): Promise<void> {
    Logger.info(TAG, 'case failureCallback called,errMessage is ' + error.message);
  }

  async catchCallback(error): Promise<void> {
    Logger.info(TAG, 'case catchCallback called,errMessage is ' + error.message);
  }

  // show recording time
  getRecordTime(): void {
    this.timer = setInterval(() => {
      this.seconds += 1;
      this.videoRecorderTimeText = dateTime(this.seconds);
    }, 1000)
  }

  // get recording file fd
  async getFileFd(): Promise<void> {
    Logger.info(TAG, 'getFileFd called');
    this.mFileAssetId = await this.mSaveCameraAsset.createVideoFd();
    this.fdPath = 'fd://' + this.mFileAssetId.toString();
    this.avConfig.url = this.fdPath;
    Logger.info(TAG, 'fdPath is: ' + this.fdPath);
    Logger.info(TAG, 'getFileFd done');
  }

  // get camera ability
  async initCamera(): Promise<void> {
    Logger.info(TAG, 'init camera called');
    if (this.cameraManager) {
      Logger.info(TAG, 'cameraManager already exits');
      return;
    }
    Logger.info(TAG, '[camera] case to get cameraManager');
    this.cameraManager = camera.getCameraManager(globalThis.abilityContext);
    if (this.cameraManager) {
      Logger.info(TAG, '[camera] case getCameraManager success');
    } else {
      Logger.info(TAG, '[camera] case getCameraManager failed');
      return;
    }
    this.cameras = this.cameraManager.getSupportedCameras();
    if (this.cameras) {
      Logger.info(TAG, '[camera] case getCameras success');
    } else {
      Logger.info(TAG, '[camera] case getCameras failed');
    }
    this.cameraOutputCapability = this.cameraManager.getSupportedOutputCapability(this.cameras[this.cameraIndex]);
    this.videoProfiles = this.cameraOutputCapability.videoProfiles;
    Logger.info(TAG, 'init camera done');
  }

  // create camera input
  async createCameraInput(): Promise<void> {
    Logger.info(TAG, 'createCameraInput called');
    this.cameraInput = this.cameraManager.createCameraInput(this.cameras[this.cameraIndex]);
    if (this.cameraInput) {
      Logger.info(TAG, '[camera] case createCameraInput success');
    } else {
      Logger.info(TAG, '[camera] case createCameraInput failed');
      return;
    }
    await this.cameraInput.open().then(() => {
      Logger.info(TAG, '[camera] case cameraInput.open() called');
    }, this.failureCallback).catch(this.catchCallback);
  }

  // create camera preview
  async createPreviewOutput(): Promise<void> {
    Logger.info(TAG, 'createPreviewOutput called');
    this.previewProfiles = this.cameraOutputCapability.previewProfiles;
    this.previewProfiles[0].size.height = this.videoResolution['frameHeight'];
    this.previewProfiles[0].size.width = this.videoResolution['frameWidth'];
    if (this.previewProfiles[0].format === camera.CameraFormat.CAMERA_FORMAT_YUV_420_SP) {
      Logger.info(TAG, '[camera] case format is VIDEO_SOURCE_TYPE_SURFACE_YUV');
      this.avConfig.videoSourceType = media.VideoSourceType.VIDEO_SOURCE_TYPE_SURFACE_YUV;
    } else {
      Logger.info(TAG, '[camera] case format is VIDEO_SOURCE_TYPE_SURFACE_ES');
      this.avConfig.videoSourceType = media.VideoSourceType.VIDEO_SOURCE_TYPE_SURFACE_ES;
    }
    this.previewOutput = this.cameraManager.createPreviewOutput(this.previewProfiles[0], this.surfaceId);
    if (!this.previewOutput) {
      Logger.info(TAG, 'create previewOutput failed!');
    }
    Logger.info(TAG, 'createPreviewOutput done');
  }

  // create camera capture session
  async createCaptureSession(): Promise<void> {
    Logger.info(TAG, 'createCaptureSession called');
    this.captureSession = this.cameraManager.createCaptureSession();
    if (!this.captureSession) {
      Logger.info(TAG, 'createCaptureSession failed!');
      return
    }
    this.captureSession.beginConfig();
    this.captureSession.addInput(this.cameraInput);
    this.captureSession.addOutput(this.previewOutput);
    await this.captureSession.commitConfig().then(() => {
      Logger.info(TAG, 'case commitConfig success');
    }, this.failureCallback).catch(this.catchCallback);
  }

  // start captureSession
  async startCaptureSession(): Promise<void> {
    Logger.info(TAG, 'startCaptureSession called');
    if (!this.captureSession) {
      Logger.info(TAG, 'CaptureSession does not exists!');
      return
    }
    await this.captureSession.start().then(() => {
      Logger.info(TAG, 'case start captureSession success');
    }, this.failureCallback).catch(this.catchCallback);
  }

  // remove previous videoOutput
  async removeVideoOutput(): Promise<void> {
    Logger.info(TAG, 'removeVideoOutput called');
    if (this.videoOutput) {
      Logger.info(TAG, 'videoOutput already exits, remove it');
      this.captureSession.removeOutput(this.videoOutput);
      Logger.info(TAG, 'remove videoOutput done');
    }
    Logger.info(TAG, 'removeVideoOutput done');
  }

  // create video output
  async createVideoOutput(): Promise<void> {
    Logger.info(TAG, 'createVideoOutput called');
    if (this.videoRecorder) {
      this.videoProfiles[this.cameraIndex].size.height = this.videoResolution['frameHeight'];
      this.videoProfiles[this.cameraIndex].size.width = this.videoResolution['frameWidth'];
      this.videoOutput = this.cameraManager.createVideoOutput(this.videoProfiles[this.cameraIndex], this.videoOutSurfaceId);
      if (!this.videoOutput) {
        Logger.info(TAG, '[camera] case create videoOutPut fail!!!');
        return;
      } else {
        Logger.info(TAG, '[camera] case create videoOutPut done, videoOutPut is not null');
      }
    } else {
      Logger.info(TAG, 'videoRecorder is null, createVideoOutput failed');
      return;
    }
  }

  // add video output into CaptureSession
  async restartVideoOutput(): Promise<void> {
    Logger.info(TAG, 'restartVideoOutput called');
    await this.captureSession.stop().then(() => {
      Logger.info(TAG, 'case stop captureSession success');
    }, this.failureCallback).catch(this.catchCallback);
    this.captureSession.beginConfig();
    await this.removeVideoOutput();
    await this.createVideoOutput();
    this.captureSession.addOutput(this.videoOutput);
    await this.captureSession.commitConfig().then(() => {
      Logger.info(TAG, 'case commitConfig success');
    }, this.failureCallback).catch(this.catchCallback);
    await this.startCaptureSession();
    if (this.videoOutput) {
      await this.videoOutput.start().then(() => {
        Logger.info(TAG, '[camera] case videoOutput start success');
      }, this.failureCallback).catch(this.catchCallback);
    } else {
      Logger.info(TAG, 'videoOutput is null!!!');
      return;
    }
  }

  // start videoOutput
  async startVideoOutput(): Promise<void> {
    Logger.info(TAG, 'startVideoOutput called');
    if (this.videoOutput) {
      await this.videoOutput.start().then(() => {
        Logger.info(TAG, '[camera] case videoOutput start success');
      }, this.failureCallback).catch(this.catchCallback);
    } else {
      Logger.info(TAG, 'videoOutput is null!!!');
      return;
    }
  }

  // stop videoOutput
  async stopVideoOutput(): Promise<void> {
    Logger.info(TAG, 'stopVideoOutput called');
    if (this.videoOutput) {
      await this.videoOutput.stop().then(() => {
        Logger.info(TAG, '[camera] case videoOutput stop success');
      }, this.failureCallback).catch(this.catchCallback);
    } else {
      Logger.info(TAG, 'videoOutput is null!!!');
      return;
    }
  }

  // release camera
  async releaseCameraInput(): Promise<void> {
    Logger.info(TAG, 'releaseCameraInput called');
    if (this.cameraInput) {
      this.cameraInput = null;
    }
    Logger.info(TAG, 'releaseCameraInput done');
  }

  // release preview
  async releasePreviewOutput(): Promise<void> {
    Logger.info(TAG, 'releasePreviewOutput called');
    if (this.previewOutput) {
      await this.previewOutput.release().then(() => {
        Logger.info('[camera] case main previewOutput release called');
      }, this.failureCallback).catch(this.catchCallback);
      this.previewOutput = null;
    }
    Logger.info(TAG, 'releasePreviewOutput done');
  }

  // release video output
  async releaseVideoOutput(): Promise<void> {
    Logger.info(TAG, 'releaseVideoOutput called');
    if (this.videoOutput) {
      await this.videoOutput.release().then(() => {
        Logger.info('[camera] case main videoOutput release called');
      }, this.failureCallback).catch(this.catchCallback);
      this.videoOutput = null;
    }
    Logger.info(TAG, 'releaseVideoOutput done');
  }

  // stop captureSession
  async stopCaptureSession(): Promise<void> {
    Logger.info(TAG, 'stopCaptureSession called');
    if (this.captureSession) {
      await this.captureSession.stop().then(() => {
        Logger.info('[camera] case main captureSession stop success');
      }, this.failureCallback).catch(this.catchCallback);
    }
    Logger.info(TAG, 'stopCaptureSession done');
  }

  // release captureSession
  async releaseCaptureSession(): Promise<void> {
    Logger.info(TAG, 'releaseCaptureSession called');
    if (this.captureSession) {
      await this.captureSession.release().then(() => {
        Logger.info('[camera] case main captureSession release success');
      }, this.failureCallback).catch(this.catchCallback);
      this.captureSession = null;
    }
    Logger.info(TAG, 'releaseCaptureSession done');
  }

  // clear camera environment
  async releaseCamera(): Promise<void> {
    Logger.info(TAG, 'releaseCamera called');
    await this.stopCaptureSession();
    await this.releaseCameraInput();
    await this.releasePreviewOutput();
    await this.releaseVideoOutput();
    await this.releaseCaptureSession();
    Logger.info(TAG, 'releaseCamera done');
  }

  // set callback on
  setCallback(): void {
    Logger.info('case callback');
    this.videoRecorder.on('stateChange', (state, reason) => {
      Logger.info('case state has changed, new state is' + state);
      switch (state) {
        case 'idle':
          this.recorderState = 'idle';
          break;
        case 'prepared':
          this.recorderState = 'prepared';
          break;
        case 'started':
          this.recorderState = 'started';
          this.getRecordTime();
          this.isStartRecording = true;
          this.isPauseRecording = false;
          break;
        case 'paused':
          this.recorderState = 'paused';
          clearInterval(this.timer);
          this.isPauseRecording = true;
          break;
        case 'stopped':
          this.recorderState = 'stopped';
          this.isStartRecording = false;
          break;
        case 'released':
          this.recorderState = 'released';
          break;
        case 'error':
          Logger.info('case error state!!!');
          this.recorderState = 'error';
          break;
        default:
          Logger.info('case start is unknown');
          break;
      }
    });
    this.videoRecorder.on('error', (err) => {
      Logger.info(TAG, 'case avRecorder.on(error) called, errMessage is ' + err.message);
    });
  }

  async createVideoRecorder(): Promise<void> {
    await media.createAVRecorder().then((recorder) => {
      Logger.info(TAG, 'case createAVRecorder called');
      if (typeof (recorder) !== 'undefined') {
        this.videoRecorder = recorder;
      } else {
        Logger.info(TAG, 'case create avRecorder failed!!!');
        return
      }
    }, this.failureCallback).catch(this.catchCallback);
    this.setCallback();
  }

  async prepareVideoRecorder(): Promise<void> {
    Logger.info(TAG, 'case prepareVideoRecorder in');
    if (this.videoCodecType === 'video/mpeg4') {
      this.avConfig.profile.videoCodec = media.CodecMimeType.VIDEO_MPEG4;
    } else {
      this.avConfig.profile.videoCodec = media.CodecMimeType.VIDEO_AVC;
    }
    this.avConfig.profile.videoFrameHeight = this.videoResolution['frameHeight'];
    this.avConfig.profile.videoFrameWidth = this.videoResolution['frameWidth'];
    this.avConfig.profile.videoFrameRate = this.framerate;
    await this.videoRecorder.prepare(this.avConfig).then(() => {
      Logger.info(TAG, 'case prepare AVRecorder called');
    }, this.failureCallback).catch(this.catchCallback);
    Logger.info(TAG, 'case prepareVideoRecorder out');
  }

  async getInputSurface(): Promise<void> {
    Logger.info(TAG, 'case getInputSurface in');
    await this.videoRecorder.getInputSurface().then((outPutSurface) => {
      Logger.info('case getInputSurface called');
      if (!outPutSurface) {
        Logger.error(TAG, 'case getInputSurface ID is none');
        return
      }
      this.videoOutSurfaceId = outPutSurface;
      Logger.info(TAG, 'case outPutSurface surfaceID is: ${this.videoOutSurfaceId}');
    }, this.failureCallback).catch(this.catchCallback);
    Logger.info(TAG, 'case getInputSurface out');
  }

  async startVideoRecording(): Promise<void> {
    Logger.info(TAG, 'case startVideoRecording called');
    await this.videoRecorder.start().then(() => {
      Logger.info(TAG, 'case start VideoRecorder called');
    }, this.failureCallback).catch(this.catchCallback);
  }

  async pauseVideoRecording(): Promise<void> {
    Logger.info(TAG, 'case pauseVideoRecording called');
    await this.videoRecorder.pause().then(() => {
      Logger.info(TAG, 'case pause VideoRecorder called');
    }, this.failureCallback).catch(this.catchCallback);
  }

  async resumeVideoRecording(): Promise<void> {
    Logger.info(TAG, 'case resumeVideoRecording called');
    await this.videoRecorder.resume().then(() => {
      Logger.info(TAG, 'case resume VideoRecorder called');
    }, this.failureCallback).catch(this.catchCallback);
  }

  async stopVideoRecording(): Promise<void> {
    Logger.info(TAG, 'case stopVideoRecording called');
    await this.videoRecorder.stop().then(() => {
      Logger.info(TAG, 'case stop VideoRecorder called');
    }, this.failureCallback).catch(this.catchCallback);
  }

  async resetVideoRecording(): Promise<void> {
    await this.videoRecorder.reset().then(() => {
      Logger.info(TAG, 'case resetVideoRecording called');
    }, this.failureCallback).catch(this.catchCallback);
  }

  async releaseVideoRecorder(): Promise<void> {
    if (this.videoRecorder) {
      this.videoRecorder.off('stateChange');
      this.videoRecorder.off('error');
      await this.videoRecorder.release().then(() => {
        Logger.info(TAG, 'case releaseVideoRecorder called');
      }, this.failureCallback).catch(this.catchCallback);
      this.videoRecorder = undefined;
    }
  }

  // close file fd
  async closeFd(): Promise<void> {
    Logger.info(TAG, 'case closeFd called');
    if (this.fdPath) {
      await this.mSaveCameraAsset.VideoPrepareFile.close(this.mFileAssetId);
      this.mFileAssetId = undefined;
      this.fdPath = undefined;
      Logger.info(TAG, 'case closeFd done');
    }
  }

  // init camera
  async enterInit(): Promise<void> {
    Logger.info(TAG, 'enterInit called');
    await this.initCamera(); // 获取设备相机信息
    await this.createCameraInput(); // 打开相机
    await this.createPreviewOutput(); // 预览流
    await this.createCaptureSession(); // 会话，保存一次相机运行需要的所有资源，并向相机设备申请完成相机功能
    await this.startCaptureSession(); // 开启会话
    Logger.info(TAG, 'exit enterInit');
  }

  // start button process
  async startRecordingProcess(): Promise<void> {
    Logger.info(TAG, 'startRecording called');
    await this.createVideoRecorder();
    await this.getFileFd();
    await this.prepareVideoRecorder();
    await this.getInputSurface();
    await this.restartVideoOutput();
    await this.startVideoRecording();
    Logger.info(TAG, 'startRecording done');
  }

  // pause button process
  async pauseRecordingProcess(): Promise<void> {
    Logger.info(TAG, 'pauseRecording called');
    if (this.recorderState === 'started') {
      Logger.info(TAG, 'current state is started, to pause');
      await this.pauseVideoRecording();
      await this.stopVideoOutput();
    }
    Logger.info(TAG, 'pauseRecording done');
  }

  // resume button process
  async resumeRecordingProcess(): Promise<void> {
    Logger.info(TAG, 'resumeRecording called');
    if (this.recorderState === 'paused') {
      Logger.info(TAG, 'current state is paused, to resume');
      await this.startVideoOutput();
      await this.resumeVideoRecording();
    }
    Logger.info(TAG, 'resumeRecording done');
  }

  // stop button process
  async stopRecordingProcess(): Promise<void> {
    Logger.info(TAG, 'stopRecording called');
    if (this.recorderState === 'started' || this.recorderState === 'paused') {
      await this.stopVideoRecording();
    }
    await this.resetVideoRecording();
    await this.releaseVideoRecorder();
    await this.stopVideoOutput();
    this.videoOutput = undefined;
    await this.closeFd();
    clearInterval(this.timer);
    this.isStartRecording = false;
    this.isPauseRecording = false;
    this.seconds = 0;
    this.videoRecorderTimeText = '00:00';
    Logger.info(TAG, 'stopRecording done');
  }


  build() {
    Column() {
      Row() {
        Stack({ alignContent: Alignment.Center }) {
          XComponent({
            id: 'xcomponent1',
            type: 'surface',
            controller: this.xcomponentController
          })
            .onLoad(() => {
              this.xcomponentController.setXComponentSurfaceSize({ surfaceWidth: 1920, surfaceHeight: 1080 })
              this.surfaceId = this.xcomponentController.getXComponentSurfaceId()
              Logger.info(TAG, '[VideoRecorder] surfaceId: ' + this.surfaceId)
              Logger.info(TAG, 'XComponent1 loaded');
              this.enterInit();
            })
            .width('100%').height('100%')
          Text(this.videoRecorderTimeText)
            .fontFamily('HarmonyHeiTi-Light')
            .width(70)
            .height(40)
            .fontSize(27)
            .fontColor('white')
            .margin({ left: 155, top: 18, right: 135, bottom: 707})
          if (!this.isStartRecording) {
            Image($r('app.media.ic_setting'))
              .width(40)
              .height(40)
              .margin({ left: 12, top: 12, right: 308, bottom: 704})
              .onClick(() => {
                if (this.settingDialog !== undefined) {
                  Logger.info(TAG, 'to open setting dialog');
                  this.settingDialog.open()
                }
              })
              .id('videoSetting')
            Image($r('app.media.ic_red_circle'))
              .width(12)
              .height(12)
              .margin({ left: 136, top: 25, right: 212, bottom: 715})
            Image($r('app.media.take_video_normal'))
              .width(86)
              .height(86)
              .margin({ left: 132, top: 612, right: 132, bottom: 72})
              .onClick(() => this.startRecordingProcess())
              .id('videoStart')
          }
          else {
            Image($r('app.media.ic_circle_open'))
              .width(120)
              .height(56)
              .margin({ left: 120, top: 632, right: 120, bottom: 92})
            Image($r('app.media.ic_stop'))
              .width(16)
              .height(16)
              .margin({ left: 146, top: 652, right: 198, bottom: 112})
              .onClick(() => this.stopRecordingProcess())
              .id('videoStop')
            if (!this.isPauseRecording) {
              Image($r('app.media.ic_red_circle'))
                .width(12)
                .height(12)
                .margin({ left: 136, top: 25, right: 212, bottom: 715})
              Image($r('app.media.ic_pause'))
                .width(14)
                .height(15)
                .margin({ left: 200, top: 652, right: 146, bottom: 113})
                .onClick(() => this.pauseRecordingProcess())
                .id('videoPause')
            } else {
              Image($r('app.media.ic_small_pause'))
                .width(14)
                .height(14)
                .margin({ left: 136, top: 25, right: 212, bottom: 715})
              Image($r('app.media.ic_continue'))
                .width(16)
                .height(16)
                .margin({ left: 198, top: 651, right: 144, bottom: 111})
                .onClick(() => this.resumeRecordingProcess())
                .id('videoResume')
            }
          }
        }.width('100%').height('100%')
      }
    }
  }

  onCancel() {
    Logger.info(TAG, 'Callback when the cancel button is clicked')
  }

  onAccept() {
    Logger.info(TAG, 'Callback when the confirm button is clicked')
  }

  existApp() {
    Logger.info(TAG, 'Click the callback in the blank area')
  }

  settingDialog: CustomDialogController = new CustomDialogController({
    builder: CustomDialogSetting({
      cancel: this.onCancel,
      confirm: this.onAccept,
      videoResolution: $videoResolution,
      videoFrameRate: $framerate,
      videoCodec: $videoCodecType,
    }),
    cancel: this.existApp,
    autoCancel: false,
    alignment: DialogAlignment.Bottom,
    customStyle: true
  })
}


@CustomDialog
struct CustomDialogSetting {
  @Link videoResolution: Object
  @Link videoFrameRate: number
  @Link videoCodec: string
  controller: CustomDialogController
  cancel: () => void
  confirm: () => void
  @State currentVideoResolution: Object = { 'frameWidth': 1280, 'frameHeight': 720 }
  @State currentVideoResolutionText: string = '[16:9]720p'
  @State currentVideoFramerate: number = 30
  @State currentVideoCodec: string = 'video/avc'
  private initVideoResolution: Object = this.videoResolution
  private initVideoFramerate: number = this.videoFrameRate
  private initVideoCodec: string = this.videoCodec
  @State videoResolutionList: Array<Object> = [
    { 'itemValue': '16:9 (720p)', 'value': { 'frameWidth': 1280, 'frameHeight': 720 } },
    { 'itemValue': '16:9 (1080p)', 'value': { 'frameWidth': 1920, 'frameHeight': 1080 } },
  ]
  @State videoFrameRateList: Array<Object> = [
    { 'itemValue': '30fps', 'value': 30 },
  ]
  @State videoCodecList: Array<Object> = [
    { 'itemValue': 'video/avc', 'value': 'video/avc' },
    { 'itemValue': 'video/mpeg4', 'value': 'video/mpeg4' },
  ]

  build() {
    Column() {
      Column() {
        Text($r('app.string.video_parameter'))
          .fontFamily('HarmonyHeiTi-Medium')
          .fontSize(20)
          .width(288)
          .height(26)
          .margin({ left: 24, top: 16, right: 24 })
        Column() {
          List({ space: 10 }) {
            ForEach(this.videoResolutionList, (item, index) => {
              ListItem() {
                Row() {
                  Text($r('app.string.video_resolution'))
                    .fontSize(16)
                  Text(item.itemValue.toString())
                    .fontSize(16)
                    .width(160)
                    .fontFamily('HarmonyHeiTi-Medium')
                  Radio({ value: item.value.toString(), group: 'radioGroup' })
                    .checked(item.value['frameWidth'] == this.initVideoResolution['frameWidth'])
                    .height(24)
                    .onChange((isChecked: boolean) => {
                      if (isChecked) {
                        Logger.info(TAG, item.itemValue + ' resolution is clicked')
                        this.currentVideoResolution = item.value;
                        this.currentVideoResolutionText = item.itemValue;
                      }
                    })
                }.margin({ left: 0, right: 39 })
              }
            })
          }.listDirection(Axis.Vertical)
          .divider({ strokeWidth: 0.5, color: '#EEEEEE', startMargin: 0, endMargin: 0 })
        }.margin({ left: 24, right: 24, top: 16 })
      }.alignItems(HorizontalAlign.Start)
      Row() {
        Button($r('app.string.button_cancel'))
          .onClick(() => {
            this.videoResolution = this.initVideoResolution
            this.videoFrameRate = this.initVideoFramerate
            this.videoCodec = this.initVideoCodec
            this.controller.close()
            this.cancel()
          })
          .backgroundColor($r('app.color.button_background'))
          .fontColor($r('app.color.button_color'))
          .fontFamily('HarmonyHeiTi-Medium')
          .fontSize(16)
          .id('videoCancel')
          .layoutWeight(1)
        Divider()
          .vertical(true)
          .height(24)
          .color($r('app.color.divider_color'))
          .opacity(0.6)
          .margin({ left: 8, right: 8 })
        Button($r('app.string.button_confirm'))
          .onClick(() => {
            this.videoResolution = this.currentVideoResolution
            this.videoFrameRate = this.currentVideoFramerate
            this.videoCodec = this.currentVideoCodec
            this.controller.close()
            this.confirm()
          })
          .backgroundColor($r('app.color.button_background'))
          .fontColor($r('app.color.button_color'))
          .fontFamily('HarmonyHeiTi-Medium')
          .fontSize(16)
          .id('videoConfirm')
          .layoutWeight(1)
      }
      .width(300)
      .height(40)
      .margin({left: 24, right: 24, top: 12, bottom: 16})
    }
    .margin({left: 12, right: 12, bottom: 12})
    .backgroundColor($r('app.color.button_background'))
    .borderRadius(32)
    .alignItems(HorizontalAlign.Center)
  }
}