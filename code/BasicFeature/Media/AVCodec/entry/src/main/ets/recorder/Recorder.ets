/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { camera } from '@kit.CameraKit';
import { fileIo } from '@kit.CoreFileKit';
import { display } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import recorder from 'librecorder.so';
import Logger from '../common/utils/Logger';
import { dateTime } from '../common/utils/DateTimeUtils';
import { CommonConstants as Const } from '../common/CommonConstants';
import { CameraDataModel } from '../model/CameraDateModel';
import { encoderProfileCameraCheck, previewProfileCameraCheck } from '../common/utils/CameraCheck';
import { colorSpaceManager } from '@kit.ArkGraphics2D';

const TAG: string = 'Sample_Recorder';

const context = AppStorage.get('context') as UIContext;
const params: CameraDataModel = context.getRouter().getParams() as CameraDataModel;

let cameraInput: camera.CameraInput;
let xComponentPreviewOutput: camera.PreviewOutput;
let encoderVideoOutput: camera.VideoOutput;
let videoSession: camera.VideoSession;

async function releaseCamera() {
  // 停止录像输出流
  encoderVideoOutput.stop((err: BusinessError) => {
    if (err) {
      Logger.error(TAG, `Failed to stop the encoder video output. error: ${JSON.stringify(err)}`);
      return;
    }
    Logger.info(TAG, 'Callback invoked to indicate the encoder video output stop success.');
  })
  // 停止当前会话
  videoSession.stop();
  // 关闭文件fd
  fileIo.close(params.outputfd);
  // 释放相机输入流
  cameraInput.close();
  // 释放预览输出流
  xComponentPreviewOutput.release();
  // 释放录像输出流
  encoderVideoOutput.release();
  // 释放会话
  videoSession.release();
}

function getPreviewProfile(previewProfiles: camera.Profile[] | undefined,
  size: camera.Size): undefined | camera.Profile {
  if (previewProfiles) {
    let previewProfile: undefined | camera.Profile = previewProfiles.find((profile: camera.Profile) => {
      return profile.format === camera.CameraFormat.CAMERA_FORMAT_YCRCB_P010 &&
        profile.size.width === size.width && profile.size.height == size.height
    });
    return previewProfile;
  }
  return undefined;
}

// 查询是否支持视频防抖。HDR录像需要支持视频防抖。
function isVideoStabilizationModeSupported(session: camera.VideoSession, mode: camera.VideoStabilizationMode): boolean {
  let isSupported: boolean = false;
  try {
    isSupported = session.isVideoStabilizationModeSupported(mode);
  } catch (error) {
    // 失败返回错误码error.code并处理
    let err = error as BusinessError;
    Logger.error(`The isVideoStabilizationModeSupported call failed. error code: ${err.code}`);
  }
  return isSupported;
}

// 设置视频防抖。
function setVideoStabilizationMode(session: camera.VideoSession): boolean {
  let mode: camera.VideoStabilizationMode = camera.VideoStabilizationMode.AUTO;
  // 查询是否支持视频防抖
  let isSupported: boolean = isVideoStabilizationModeSupported(session, mode);
  if (isSupported) {
    Logger.info(TAG, `setVideoStabilizationMode: ${mode}`);
    // 设置视频防抖
    session.setVideoStabilizationMode(mode);
    let activeVideoStabilizationMode = session.getActiveVideoStabilizationMode();
    Logger.info(TAG, `activeVideoStabilizationMode: ${activeVideoStabilizationMode}`);
  } else {
    Logger.info(TAG, `videoStabilizationMode: ${mode} is not support`);
  }
  return isSupported;
}

// 查询支持的色彩空间。
function getSupportedColorSpaces(session: camera.VideoSession): colorSpaceManager.ColorSpace[] {
  let colorSpaces: colorSpaceManager.ColorSpace[] = [];
  try {
    colorSpaces = session.getSupportedColorSpaces();
  } catch (error) {
    let err = error as BusinessError;
    Logger.error(TAG, `The getSupportedColorSpaces call failed. error code: ${err.code}`);
  }
  return colorSpaces;
}

// 设置色彩空间。
function setColorSpaceBeforeCommitConfig(session: camera.VideoSession, isHdr: number): void {
  let colorSpace: colorSpaceManager.ColorSpace =
    isHdr ? colorSpaceManager.ColorSpace.BT2020_HLG_LIMIT : colorSpaceManager.ColorSpace.BT709_LIMIT;
  let colorSpaces: colorSpaceManager.ColorSpace[] = getSupportedColorSpaces(session);
  let isSupportedColorSpaces = colorSpaces.indexOf(colorSpace) >= 0;
  if (isSupportedColorSpaces) {
    Logger.info(TAG, `setColorSpace: ${colorSpace}`);
    session.setColorSpace(colorSpace);
    let activeColorSpace: colorSpaceManager.ColorSpace = session.getActiveColorSpace();
    Logger.info(TAG, `activeColorSpace: ${activeColorSpace}`);
  } else {
    Logger.info(TAG, `colorSpace: ${colorSpace} is not support`);
  }
}

@Entry
@Component
export struct Recorder {
  private START_RECORDER: string = '开始录制';
  private STOP_RECORDER: string = '停止录制';
  @State isRecorderTimeTextHide: boolean = true;
  @State buttonText: string = this.START_RECORDER;
  @State buttonEnabled: boolean = true;
  @State videoRecorderTimeText: string = '00:00';
  @State fov: number = 1;
  private xComponentSurfaceId: string = '-1';
  private cameraWidth: number = Const.DEFAULT_WIDTH;
  private cameraHeight: number = Const.DEFAULT_HEIGHT;
  private xComponentController: XComponentController = new XComponentController();
  private display = display.getDefaultDisplaySync();
  private heightPx = (this.display.width * this.cameraWidth / this.cameraHeight) + 'px';
  private timer: number = Const.DEFAULT_VALUE;
  private seconds: number = Const.DEFAULT_VALUE;
  private isReleased: boolean = false;
  private isBack: boolean = false;
  private range: number[] = [];

  onBackPress() {
    this.isBack = true;
  }

  onPageHide() {
    this.release();
    if (!this.isBack) {
      this.getUIContext().getRouter().back();
    }
  }

  setTimer() {
    this.buttonEnabled = false;
    setTimeout(async () => {
      this.buttonEnabled = true;
    }, 1300);
  }

  async release(): Promise<void> {
    if (!this.isReleased) {
      this.isReleased = true;
      clearInterval(this.timer);
      this.seconds = 0;
      this.videoRecorderTimeText = '00:00';
      recorder.stopNative()
        .then(async (data) => {
          if (data.code == 0) {
            await releaseCamera();
            this.buttonText == this.START_RECORDER;
          }
        })
    }
  }

  getRecordTime(): void {
    this.timer = setInterval(() => {
      this.seconds += 1;
      this.videoRecorderTimeText = dateTime(this.seconds);
    }, 1000);
  }

  async createRecorder(): Promise<void> {
    releaseCamera();
    // Create the CameraManager object.
    let cameraManager = camera.getCameraManager(this.getUIContext().getHostContext());
    if (!cameraManager) {
      Logger.error(TAG, 'camera.getCameraManager error');
      return;
    }

    // Get supported camera devices.
    let cameraDevices: camera.CameraDevice[] = cameraManager.getSupportedCameras();
    if (cameraDevices !== undefined && cameraDevices.length <= 0) {
      Logger.error(TAG, 'cameraManager.getSupportedCameras error!');
      return;
    }

    // 获取支持的模式类型
    let sceneModes: camera.SceneMode[] = cameraManager.getSupportedSceneModes(cameraDevices[0]);
    let isSupportVideoMode: boolean = sceneModes.indexOf(camera.SceneMode.NORMAL_VIDEO) >= 0;
    if (!isSupportVideoMode) {
      Logger.error('video mode not support');
      return;
    }

    let encoderProfile: undefined | camera.VideoProfile = encoderProfileCameraCheck(cameraManager, params);
    if (!encoderProfile) {
      Logger.error(TAG, 'encoderProfile is not found!');
      return;
    }

    // The preview stream of XComponent.
    let xComponentPreviewProfile: camera.Profile | undefined = previewProfileCameraCheck(cameraManager, params);
    if (xComponentPreviewProfile === undefined) {
      Logger.error(TAG, 'XComponentPreviewProfile is not found');
      return;
    }

    //Create the encoder output object
    encoderVideoOutput = cameraManager.createVideoOutput(encoderProfile, params.surfaceId);
    if (encoderVideoOutput === undefined) {
      Logger.error(TAG, 'encoderVideoOutput is undefined');
      return;
    }
    Logger.info(TAG, 'encoderVideoOutput  success');

    // Create a preview stream output object
    xComponentPreviewOutput = cameraManager.createPreviewOutput(xComponentPreviewProfile, this.xComponentSurfaceId);
    if (xComponentPreviewOutput === undefined) {
      Logger.error(TAG, 'XComponentPreviewOutput is undefined');
      return;
    }

    // Create the cameraInput object.
    try {
      cameraInput = cameraManager.createCameraInput(cameraDevices[0]);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `Failed to createCameraInput. error: ${JSON.stringify(err)}`);
    }
    if (cameraInput === undefined) {
      Logger.error(TAG, 'cameraInput is undefined');
      return;
    }

    // Turn on the camera.
    try {
      await cameraInput.open();
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `Failed to open cameraInput. error: ${JSON.stringify(err)}`);
    }

    // Session flow.
    try {
      videoSession = cameraManager.createSession(camera.SceneMode.NORMAL_VIDEO) as camera.VideoSession;
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `Failed to create the session instance. error: ${JSON.stringify(err)}`);
    }
    if (videoSession === undefined) {
      Logger.error(TAG, 'videoSession is undefined');
      return;
    }

    // Start Configuring the session.
    try {
      videoSession.beginConfig();
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `Failed to beginConfig. error: ${JSON.stringify(err)}`);
    }

    // Add CameraInput to the session.
    try {
      videoSession.addInput(cameraInput);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `Failed to add cameraInput. error: ${JSON.stringify(err)}`);
    }

    // Add the XComponent preview stream to the session.
    try {
      videoSession.addOutput(xComponentPreviewOutput);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `Failed to add XcomponentPreviewOutput. error: ${JSON.stringify(err)}`);
    }

    // Add the encoder video stream to the session.
    try {
      videoSession.addOutput(encoderVideoOutput);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `Failed to add encoderVideoOutput. error: ${JSON.stringify(err)}`);
    }

    // Submit configuration information.
    try {
      await videoSession.commitConfig();
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `videoSession commitConfig error: ${JSON.stringify(err)}`);
    }

    // 设置视频防抖
    if (setVideoStabilizationMode(videoSession)) {
      // 设置色彩空间
      setColorSpaceBeforeCommitConfig(videoSession, params.isHDRVivid);
    }

    // Session start.
    try {
      await videoSession.start();
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `videoSession start error: ${JSON.stringify(err)}`);
    }
  }

  build() {
    Column() {
      Stack() {
        XComponent({
          id: 'recorderXComponent',
          type: XComponentType.SURFACE,
          controller: this.xComponentController
        })
          .onLoad(() => {
            this.xComponentSurfaceId = this.xComponentController.getXComponentSurfaceId();
            this.createRecorder();
          })
          .width(Const.FULL_SIZE)
          .height(this.heightPx)
          .gesture(
            PinchGesture()
              .onActionUpdate((event: GestureEvent) => {
                if (videoSession) {
                  let currentFov = this.fov * event.scale;
                  if (currentFov > this.range[1]) {
                    currentFov = this.range[1];
                  }
                  if (currentFov < this.range[0]) {
                    currentFov = this.range[0];
                  }
                  videoSession.setZoomRatio(currentFov);
                }
              })
              .onActionEnd((event: GestureEvent) => {
                if (videoSession) {
                  this.fov = videoSession.getZoomRatio();
                }
              })
          )

        if (!this.isRecorderTimeTextHide) {
          Text(this.videoRecorderTimeText)
            .fontFamily('HarmonyHeilTi-Light')
            .width(100)
            .height(40)
            .fontSize(27)
            .fontColor(Color.White)
            .margin({ bottom: 500 })
        }

        Button(this.buttonText)
          .onClick(() => {
            if (this.buttonText == this.START_RECORDER) {
              this.buttonText = this.STOP_RECORDER;
              this.setTimer()
              // 启动录像输出流
              encoderVideoOutput.start((err: BusinessError) => {
                if (err) {
                  Logger.error(TAG, `Failed to start the encoder video output. error: ${JSON.stringify(err)}`)
                  return
                }
                Logger.info(TAG, 'Callback invoked to indicate the encoder video output start success.')
              });
              recorder.startNative();
              this.isRecorderTimeTextHide = false;
              this.getRecordTime();
            } else {
              this.buttonEnabled = false;
              this.isBack = true
              this.release();
              this.getUIContext().getRouter().back();
            }
          })
          .enabled(this.buttonEnabled)
          .margin({ top: 500 })
      }
    }
    .justifyContent(FlexAlign.SpaceEvenly)
    .height(Const.FULL_SIZE)
  }
}