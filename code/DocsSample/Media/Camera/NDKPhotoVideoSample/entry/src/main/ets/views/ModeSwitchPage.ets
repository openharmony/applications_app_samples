/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// Reverse camera_ Multiple workstations_ Take photos Video

import Logger from '../model/Logger';
import cameraDemo from 'libentry.so';
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import media from '@ohos.multimedia.media';
import deviceInfo from '@ohos.deviceInfo';
import { fileIo, ReadOptions, WriteOptions } from '@kit.CoreFileKit';
import { Constants, SettingDataObj } from '../common/Constants';
import common from '@ohos.app.ability.common';
import { Decimal } from '@kit.ArkTS';
import { sensor } from '@kit.SensorServiceKit';

const TAG: string = 'CameraSample';

interface PhotoRotationMap {
  rotation0: number,
  rotation90: number,
  rotation180: number,
  rotation270: number,
};

@Component
export struct modeSwitchPage {
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;
  private tag: string = 'CameraSample';
  private phAccessHelper = photoAccessHelper.getPhotoAccessHelper(this.context);
  private fd: number = -1;
  @State mSurfaceId: string = '';
  @Consume isVideoMode: boolean;
  private videoRecorder?: media.AVRecorder;
  private videoConfig: media.AVRecorderConfig = {
    audioSourceType: media.AudioSourceType.AUDIO_SOURCE_TYPE_MIC,
    videoSourceType: media.VideoSourceType.VIDEO_SOURCE_TYPE_SURFACE_YUV,
    profile: {
      audioBitrate: 48000,
      audioChannels: 2,
      audioCodec: media.CodecMimeType.AUDIO_AAC,
      audioSampleRate: 48000,
      fileFormat: media.ContainerFormatType.CFT_MPEG_4,
      videoBitrate: 512000,
      videoCodec: media.CodecMimeType.VIDEO_AVC,
      videoFrameWidth: 640,
      videoFrameHeight: 640,
      videoFrameRate: 30
    },
    url: '',
    rotation: 0
  };
  private photoRotationMap: PhotoRotationMap = {
    rotation0: 0,
    rotation90: 90,
    rotation180: 180,
    rotation270: 270,
  };
  private fileName: string = '';
  // Front and rear cameras
  @Link cameraDeviceIndex: number;
  // SurfaceID
  @Prop surfaceId: string;
  @Link videoId: string;
  @Prop @Watch('onTriggerChange') videoTrigger: number;
  //HDR video
  @Consume isHdrVideo: boolean;
  // Recording time timer
  @State timer: number = -1;
  // Select mode
  @State modelBagCol: string = 'photo';
  // Choose camera or capture
  @State @Watch('onChangeIsModeBol') isModeBol: boolean = true;

  private settingDataObj: SettingDataObj = {
    mirrorBol: false,
    videoStabilizationMode: 0,
    exposureMode: 1,
    focusMode: 2,
    photoQuality: 1,
    locationBol: false,
    photoFormat: 1,
    photoOrientation: 0,
    photoResolution: 0,
    videoResolution: 0,
    videoFrame: 0,
    referenceLineBol: false
  };

  // After pausing, click 'stop' to reset the pause to default
  onChangeIsModeBol() {
  }

  async onTriggerChange() {
    await this.getVideoSurfaceID();
    cameraDemo.initCamera(this.surfaceId, this.videoId, this.settingDataObj.focusMode, this.cameraDeviceIndex)
  }

  getRealData(data: sensor.GravityResponse): number {
    let getDeviceDegree: number = 0;
    let x = data.x;
    let y = data.y;
    let z = data.z;
    if ((x * x + y * y) * 3 < z * z) {
      return getDeviceDegree;
    } else {
      try {
        let sd: Decimal = Decimal.atan2(y, -x);
        let sc: Decimal = Decimal.round(Number(sd) / 3.141592653589 * 180);
        getDeviceDegree = 90 - Number(sc);
        getDeviceDegree = getDeviceDegree >= 0 ? getDeviceDegree % 360 : getDeviceDegree % 360 + 360;
      } catch (error) {
        let err = error as BusinessError;
        console.error(`decimal failed, error: ${err.code}`);
      }
    }
    return getDeviceDegree;
  }

  async getGravity() : Promise<number> {
    let isSupported: boolean = false;
    let data: sensor.Sensor[];
    try {
      data = await sensor.getSensorList();
    } catch (error) {
      let err = error as BusinessError;
      console.error(`getSensorList failed, error: ${err.code}`);
      return -1; // 异常场景下返回默认值
    }

    for (let i = 0; i < data.length; i++) {
      if (data[i].sensorId === sensor.SensorId.GRAVITY) {
        isSupported = true;
        break;
      }
    }
    try {
      if (isSupported === true) {
        const promise: Promise<number> = new Promise((resolve) => {
          sensor.once(sensor.SensorId.GRAVITY, (data: sensor.GravityResponse) => {
            resolve(this.getRealData(data));
          });
        })
        return promise;
      } else {
        const promise: Promise<number> = new Promise((resolve) => {
          sensor.once(sensor.SensorId.ACCELEROMETER, (data: sensor.AccelerometerResponse) => {
            resolve(this.getRealData(data as sensor.GravityResponse));
          });
        })
        return promise;
      }
    } catch (error) {
      let err = error as BusinessError;
      console.error(`gePromise failed, error: ${err.code}`);
      return -1; // 异常场景下返回默认值
    }
  }

  //创建视频文件Fd
  initFd(): number {
    Logger.info(this.tag, 'initFd is called');
    let filesDir = this.context.filesDir;
    let fileName = `${Date.now()}.mp4`;
    this.fileName = fileName;
    let filePath = filesDir + `/${fileName}`;
    let file: fileIo.File = fileIo.openSync(filePath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
    Logger.info(this.tag, `filePath =  ${filePath}`);

    return file.fd;
  }

  //获取创建Video Output所需SurfaceId
  async getVideoSurfaceID() {
    Logger.info(this.tag, `getVideoSurfaceID`);
    this.videoRecorder = await media.createAVRecorder();
    Logger.info(this.tag, `getVideoSurfaceID videoRecorder: ${this.videoRecorder}`);

    this.fd = this.initFd();
    Logger.info(this.tag, `getVideoSurfaceID fd: ${this.fd}`);

    this.videoConfig.url = `fd://${this.fd.toString()}`;
    Logger.info(this.tag, `getVideoSurfaceID videoConfig.url : ${this.videoConfig.url}`);

    if (deviceInfo.deviceType == 'default') {
      Logger.info(this.tag, `deviceType = default`);
      this.videoConfig.videoSourceType = media.VideoSourceType.VIDEO_SOURCE_TYPE_SURFACE_ES;
    }
    if (deviceInfo.deviceType == 'phone') {
      Logger.info(this.tag, `deviceType = phone`)
      this.videoConfig.videoSourceType = media.VideoSourceType.VIDEO_SOURCE_TYPE_SURFACE_YUV;
      this.videoConfig.profile.videoCodec = media.CodecMimeType.VIDEO_AVC;
    }
    if (deviceInfo.deviceType == 'tablet') {
      Logger.info(this.tag, `deviceType = tablet`);
      this.videoConfig.videoSourceType = media.VideoSourceType.VIDEO_SOURCE_TYPE_SURFACE_YUV;
    }

    //获取创建VideoOutput用的Profile，保证AVRecorder和VideoOutput的宽高以及帧率一致
    this.videoConfig.profile.videoFrameWidth = 1920;
    this.videoConfig.profile.videoFrameHeight = 1080;
    this.videoConfig.profile.isHdr = false;
    //HDR Vivid视频时的处理，videoCodec和isHdr需要注意
    if (this.isHdrVideo) {
      let aVRecorderProfile: media.AVRecorderProfile = {
        audioBitrate: 48000,
        audioChannels: 2,
        audioCodec: media.CodecMimeType.AUDIO_AAC,
        audioSampleRate: 48000,
        fileFormat: media.ContainerFormatType.CFT_MPEG_4,
        videoBitrate: 2000000,
        videoCodec: media.CodecMimeType.VIDEO_HEVC,
        videoFrameWidth: 1920,
        videoFrameHeight: 1080,
        videoFrameRate: 30,
        isHdr: true
      };
      this.videoConfig.audioSourceType = media.AudioSourceType.AUDIO_SOURCE_TYPE_MIC;
      this.videoConfig.videoSourceType = media.VideoSourceType.VIDEO_SOURCE_TYPE_SURFACE_YUV;
      this.videoConfig.profile = aVRecorderProfile;
    }
    try{
      await this.videoRecorder.prepare(this.videoConfig);
      Logger.info(this.tag, 'prepare success!');
    }catch (err) {
      Logger.error(this.tag, 'prepare failed: ' + err);
    }

    this.videoId = await this.videoRecorder.getInputSurface();
    Logger.info(this.tag, `getVideoSurfaceID videoId: ${this.videoId}`);
  }

  // 判定是拍照模式还是录像模式
  async isVideoPhotoFn() {
    if (this.modelBagCol == 'photo') {
      let deviceDegree = await this.getGravity();
      cameraDemo.takePicture(deviceDegree);
    } else if (this.modelBagCol == 'video') {
      this.isModeBol = false;
      if (this.timer) {
        clearInterval(this.timer);
      }
      // Start record
      // updateRotation
      let deviceDegree = await this.getGravity();
      Logger.info(this.tag, `startVideo deviceDegree:${deviceDegree}`);
      let videoRotation = cameraDemo.getVideoRotation(deviceDegree);
      Logger.info(this.tag, `startVideo getVideoRotation:${videoRotation}`);
      this.videoRecorder?.updateRotation(videoRotation);
      cameraDemo.startPhotoOrVideo(this.modelBagCol, this.videoId, this.mSurfaceId);
      cameraDemo.videoOutputStart();
      if (this.videoRecorder) {
        this.videoRecorder.start();
      }
    }
  }

  async aboutToAppear() {
    if (this.isVideoMode) {
      await this.getVideoSurfaceID();
    }
  }

  build() {
    if (this.isModeBol) {
      Column() {
        Text('拍照')
          .size({ width: 64, height: 28 })
          .borderRadius(14)
          .fontSize(15)
          .fontColor(Color.White)
          .onClick(() => {
            cameraDemo.releaseSession()
            cameraDemo.setIsVideo(false);
            cameraDemo.initCamera(this.surfaceId, this.videoId, this.settingDataObj.focusMode, this.cameraDeviceIndex)
            this.modelBagCol = 'photo'
            this.isVideoMode = false;
          })
      }.position({ x: '45%', y: '77%' })

      Column() {
        Text('录像')
          .fontSize(15)
          .fontColor(Color.White)
          .borderRadius(14)
          .size({ width: 64, height: 28 })
          .onClick(async () => {
            cameraDemo.releaseSession()
            cameraDemo.setIsVideo(true);
            await this.getVideoSurfaceID();
            cameraDemo.initCamera(this.surfaceId, this.videoId, this.settingDataObj.focusMode, this.cameraDeviceIndex)
            this.modelBagCol = 'video'
            this.isVideoMode = true;
          })
      }.position({ x: '60%', y: '77%' })

      // album
      Column() {
        Row() {
          if (this.modelBagCol === 'photo') {
            Image($r('app.media.camera_thumbnail_4x'))
              .objectFit(ImageFit.Auto)
              .width('170px')
              .height('170px')
              .clip(new Circle({ width: '170px', height: '170px' }))
          } else {
            Image($r('app.media.camera_thumbnail_4x'))
              .objectFit(ImageFit.Auto)
              .width('170px')
              .height('170px')
              .clip(new Circle({ width: '170px', height: '170px' }))
          }
        }.onClick(() => {
          if (deviceInfo.deviceType == 'default') {
            this.context.startAbility({
              bundleName: 'com.ohos.photos',
              abilityName: 'com.ohos.photos.MainAbility'
            })
          } else if (deviceInfo.deviceType == 'phone') {
            this.context.startAbility({
              bundleName: 'com.huawei.hmos.photos',
              abilityName: 'com.huawei.hmos.photos.MainAbility'
            })
          }

        })
      }.position({ x: '10%', y: '85%' })
      .id('Thumbnail')

      // capture video icon
      Column() {
        Row() {
          if (this.modelBagCol === 'photo') {
            Image($r('app.media.camera_take_photo_4x'))
              .width('176px')
              .height('176px')
              .onClick(() => {
                // Countdown camera recording - default camera recording
                this.isVideoPhotoFn();
              })
          } else {
            Image($r('app.media.camera_take_video_4x'))
              .width('176px')
              .height('176px')
              .onClick(() => {
                // Countdown camera recording - default camera recording
                this.isVideoPhotoFn();
              })
          }
        }
      }.position({ x: '40%', y: '85%' })
      .id('CaptureOrVideoButton')

      // Front and rear camera switching
      Column() {
        Row() {
          Image($r('app.media.camera_switch_4x'))
            .width('176px')
            .height('176px')
            .onClick(async () => {
              // Switching Cameras
              this.cameraDeviceIndex ? this.cameraDeviceIndex = 0 : this.cameraDeviceIndex = 1;
              // Clear configuration
              cameraDemo.releaseSession();
              // Start preview
              if (this.isVideoMode) {
                await this.getVideoSurfaceID();
                cameraDemo.setIsVideo(true);
              } else {
                cameraDemo.setIsVideo(false);
              }
              cameraDemo.initCamera(this.surfaceId, this.videoId,
                this.settingDataObj.focusMode, this.cameraDeviceIndex);
              cameraDemo.enableHdrVideo(this.isHdrVideo);
            })
        }
      }.position({ x: '70%', y: '85%' })
      .id('SwitchCameraButton')
    } else {
      Column() {
        Row() {
          Column() {
            // video stop button
            Image($r('app.media.camera_pause_video_4x'))
              .size({ width: 25, height: 25 })
              .width('176px')
              .height('176px')
              .id('StopVideo')
              .onClick(() => {
                if (this.timer) {
                  clearInterval(this.timer);
                }
                // Stop video
                this.stopVideo().then(async () => {
                  this.isModeBol = true;
                  try {
                    let uri = await this.phAccessHelper.createAsset(photoAccessHelper.PhotoType.VIDEO, 'mp4');
                    let videoUri = `file://${this.context.filesDir}/${this.fileName}`;
                    await this.readWriteFile(videoUri, uri);
                  } catch (err) {
                    Logger.info(this.tag, 'videoThumbnail err----------:' + JSON.stringify(err.message));
                  }
                })
              })
          }
          .width('180px')
          .height('180px')
        }
        .width('176px')
        .height('176px')
      }.position({ x: '40%', y: '85%' })
    }
  }

  //保存视频文件
  async readWriteFile(sourceUri: string, destUri: string): Promise<void> {
    try {
      // 打开文件
      let srcFile = fileIo.openSync(sourceUri, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
      let destFile = fileIo.openSync(destUri, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
      // 读取源文件内容并写入至目的文件
      let bufSize = 4096;
      let readSize = 0;
      let buf = new ArrayBuffer(bufSize);
      let readOptions: ReadOptions = {
        offset: readSize,
        length: bufSize
      };
      let readLen = fileIo.readSync(srcFile.fd, buf, readOptions);
      while (readLen > 0) {
        readSize += readLen;
        let writeOptions: WriteOptions = {
          length: readLen
        };
        fileIo.writeSync(destFile.fd, buf, writeOptions);
        readOptions.offset = readSize;
        readLen = fileIo.readSync(srcFile.fd, buf, readOptions);
      }
      // 关闭文件
      fileIo.closeSync(srcFile);
      fileIo.closeSync(destFile);
    } catch (err) {
      Logger.info(this.tag, 'readWriteFile err: ' + JSON.stringify(err));
    }
  }

  //暂停录像
  async stopVideo() {
    try {
      if (this.videoRecorder) {
        await this.videoRecorder.stop();
        await this.videoRecorder.prepare(this.videoConfig);
        await this.videoRecorder.getInputSurface();
      }
      cameraDemo.videoOutputStopAndRelease();
      Logger.info(this.tag, 'stopVideo end');
    } catch (err) {
      Logger.info(this.tag, 'stopVideo err: ' + JSON.stringify(err));
    }
    return;
  }
}