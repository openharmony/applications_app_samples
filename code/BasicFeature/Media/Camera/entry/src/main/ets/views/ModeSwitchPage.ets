/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import DateTimeUtil from '../model/DateTimeUtil';
import Logger from '../model/Logger';
import cameraDemo from 'libentry.so';
import mediaLibrary from '@ohos.multimedia.mediaLibrary';
import image from '@ohos.multimedia.image';
import media from '@ohos.multimedia.media';
import MediaUtils from '../model/MediaUtils';
import deviceInfo from '@ohos.deviceInfo';
import fileio from '@ohos.fileio';
import { SettingDataObj } from '../common/Constants'
import common from '@ohos.app.ability.common'

let context = getContext(this) as common.UIAbilityContext;

interface CameraSize {
  WIDTH: number,
  HEIGHT: number
};

interface PhotoSettings {
  quality: number, // Photo quality
  rotation: number, // Photo direction
  mirror: boolean, // Mirror Enable
  latitude: number, // geographic location
  longitude: number, // geographic location
  altitude: number // geographic location
};

interface PhotoRotationMap {
  rotation0: number,
  rotation90: number,
  rotation180: number,
  rotation270: number,
};

@Component
export struct modeSwitchPage {
  private tag: string = 'sample modeSwitchPage:';
  private mediaUtil = MediaUtils.getInstance();
  private fileAsset?: mediaLibrary.FileAsset;
  private fd: number = -1;
  @State videoId: string = '';
  @State mSurfaceId: string = '';
  private cameraSize: CameraSize = {
    WIDTH: 1280,
    HEIGHT: 720
  };
  private photoSettings: PhotoSettings = {
    quality: 0,
    rotation: 0,
    mirror: false,
    latitude: 12.9698,
    longitude: 77.7500,
    altitude: 1000
  };
  private mReceiver?: image.ImageReceiver;
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
      videoFrameHeight: 480,
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
  // Front and rear cameras
  @Link cameraDeviceIndex: number;
  // SurfaceID
  @Prop surfaceId: string;
  // Countdown value
  @Link countdownNum: number;
  // Countdown timer
  @State countTimerInt: number = -1;
  @State countTimerOut: number = -1;
  // Photo Thumbnails
  @State imgThumbnail: string = '';
  // Recording time
  @State videoRecodeTime: number = 0;
  // Recording time timer
  @State timer: number = -1;
  // Time Manager
  @State dateTimeUtil: DateTimeUtil = new DateTimeUtil();
  // Select mode
  @State modelBagCol: string = 'photo';
  // Choose camera or capture
  @State @Watch('onChangeIsModeBol') isModeBol: boolean = true;
  // Video Thumbnails
  // private videoThumbnail?: image.PixelMap;
  @State videoThumbnail: image.PixelMap | undefined | null = undefined;
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

  // Countdown capture and video
  countTakeVideoFn() {
    if (this.countdownNum) {
      // Clear Countdown
      if (this.countTimerOut) {
        clearTimeout(this.countTimerOut);
      }
      if (this.countTimerInt) {
        clearInterval(this.countTimerInt);
      }
      // Turn on timer
      this.countTimerOut = setTimeout(() => {
        // Determine whether it is in video or photo mode
        this.isVideoPhotoFn();
      }, this.countdownNum * 1000)
      // Turn on timer
      this.countTimerInt = setInterval(() => {
        this.countdownNum--;
        if (this.countdownNum === 0) {
          clearInterval(this.countTimerInt);
        }
      }, 1000)
    } else {
      this.isVideoPhotoFn();
    }
  }

  async getVideoSurfaceID() {
    Logger.info(this.tag, `getVideoSurfaceID`);
    this.videoRecorder = await media.createAVRecorder();
    Logger.info(this.tag, `getVideoSurfaceID videoRecorder: ${this.videoRecorder}`);

    this.fileAsset = await this.mediaUtil.createAndGetUri(mediaLibrary.MediaType.VIDEO);
    Logger.info(this.tag, `getVideoSurfaceID fileAsset: ${this.fileAsset}`);

    this.fd = await this.mediaUtil.getFdPath(this.fileAsset);
    Logger.info(this.tag, `getVideoSurfaceID fd: ${this.fd}`);

    this.videoConfig.url = `fd://${this.fd}`;
    Logger.info(this.tag, `getVideoSurfaceID videoConfig.url : ${this.videoConfig.url}`);

    if (deviceInfo.deviceType == 'default') {
      Logger.info(this.tag, `deviceType = default`);
      this.videoConfig.videoSourceType = media.VideoSourceType.VIDEO_SOURCE_TYPE_SURFACE_ES;
    }
    if (deviceInfo.deviceType == 'phone') {
      Logger.info(this.tag, `deviceType = phone`)
      this.videoConfig.videoSourceType = media.VideoSourceType.VIDEO_SOURCE_TYPE_SURFACE_YUV;
      this.videoConfig.profile.videoCodec = media.CodecMimeType.VIDEO_MPEG4;
      if (this.cameraDeviceIndex == 1) {
        this.videoConfig.rotation = this.photoRotationMap.rotation270;
      } else {
        this.videoConfig.rotation = this.photoRotationMap.rotation90;
      }
    }
    if (deviceInfo.deviceType == 'tablet') {
      Logger.info(this.tag, `deviceType = tablet`);
      this.videoConfig.videoSourceType = media.VideoSourceType.VIDEO_SOURCE_TYPE_SURFACE_YUV;
    }

    this.videoConfig.profile.videoFrameWidth = cameraDemo.getVideoFrameWidth();
    this.videoConfig.profile.videoFrameHeight = cameraDemo.getVideoFrameHeight();
    this.videoConfig.profile.videoFrameRate = cameraDemo.getVideoFrameRate();

    await this.videoRecorder.prepare(this.videoConfig);
    this.videoId = await this.videoRecorder.getInputSurface();
    Logger.info(this.tag, `getVideoSurfaceID videoId: ${this.videoId}`);
  }

  createImageReceiver() {
    try {
      this.mReceiver = image.createImageReceiver(this.cameraSize.WIDTH, this.cameraSize.HEIGHT, 2000, 8);
      Logger.info(this.tag, `createImageReceiver value: ${this.mReceiver} `);
      this.mReceiver.on('imageArrival', () => {
        Logger.info(this.tag, 'imageArrival start');
        if (this.mReceiver) {
          this.mReceiver.readNextImage((err, image) => {
            Logger.info(this.tag, 'readNextImage start');
            if (err || image === undefined) {
              Logger.error(this.tag, 'readNextImage failed ');
              return;
            }
            image.getComponent(4, (errMsg, img) => {
              Logger.info(this.tag, 'getComponent start');
              if (errMsg || img === undefined) {
                Logger.info(this.tag, 'getComponent failed ');
                return;
              }
              let buffer = new ArrayBuffer(2048);
              if (img.byteBuffer) {
                buffer = img.byteBuffer;
              } else {
                Logger.error(this.tag, 'img.byteBuffer is undefined');
              }
              this.savePicture(buffer, image);
            })
          })
        }
      })
    } catch {
      Logger.info(this.tag, 'savePicture err');
    }
  }

  // Read Image
  async savePicture(buffer: ArrayBuffer, img: image.Image) {
    try {
      Logger.info(this.tag, 'savePicture start');
      let imgFileAsset = await this.mediaUtil.createAndGetUri(mediaLibrary.MediaType.IMAGE);
      let imgPhotoUri = imgFileAsset.uri;
      Logger.info(this.tag, `photoUri = ${imgPhotoUri}`);
      let imgFd = await this.mediaUtil.getFdPath(imgFileAsset);
      Logger.info(this.tag, `fd = ${imgFd}`);
      await fileio.write(imgFd, buffer);
      await imgFileAsset.close(imgFd);
      await img.release();
      Logger.info(this.tag, 'save image End');
      // problem
      if (this.handleTakePicture) {
        this.handleTakePicture(imgPhotoUri);
      }
    } catch (err) {
      Logger.info(this.tag, 'savePicture err' + JSON.stringify(err.message));
    }
  }

  async getPhotoSurfaceID() {
    if (this.mReceiver) {
      Logger.info(this.tag, 'imageReceiver has been created');
    } else {
      this.createImageReceiver();
    }
    if (this.mReceiver) {
      this.mSurfaceId = await this.mReceiver.getReceivingSurfaceId();
    }
    if (this.mSurfaceId) {
      Logger.info(this.tag, `createImageReceiver mSurfaceId: ${this.mSurfaceId} `);
    } else {
      Logger.info(this.tag, `Get mSurfaceId failed `);
    }
  }

  // Determine the video or photo mode
  async isVideoPhotoFn() {
    await this.getPhotoSurfaceID();

    if (this.modelBagCol == 'photo') {
      cameraDemo.startPhotoOrVideo(this.modelBagCol, this.videoId, this.mSurfaceId);
    } else if (this.modelBagCol == 'video') {
      this.isModeBol = false;
      if (this.timer) {
        clearInterval(this.timer);
      }
      // Start record
      await this.getVideoSurfaceID();
      cameraDemo.startPhotoOrVideo(this.modelBagCol, this.videoId, this.mSurfaceId);
      cameraDemo.videoOutputStart();
      if (this.videoRecorder) {
        this.videoRecorder.start();
      }
    }
  }

  aboutToAppear() {
  }

  handleTakePicture = (thumbnail: string) => {
    this.imgThumbnail = thumbnail;
    Logger.info(this.tag, `takePicture end , thumbnail: ${this.imgThumbnail}`);
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
            cameraDemo.initCamera(this.surfaceId, this.settingDataObj.focusMode, this.cameraDeviceIndex)
            this.modelBagCol = 'photo'
          })
      }.position({ x: '45%', y: '77%' })

      Column() {
        Text('录像')
          .fontSize(15)
          .fontColor(Color.White)
          .borderRadius(14)
          .size({ width: 64, height: 28 })
          .onClick(() => {
            cameraDemo.releaseSession()
            cameraDemo.initCamera(this.surfaceId, this.settingDataObj.focusMode, this.cameraDeviceIndex)
            this.modelBagCol = 'video'
          })
      }.position({ x: '60%', y: '77%' })

      // album
      Column() {
        Row() {
          if (this.modelBagCol === 'photo') {
            Text(this.imgThumbnail || 'app.media.camera_thumbnail_4x')
              .width('1px')
              .height('1px')
              .borderRadius('1px')
              .id('ThumbnailText')
            Image(this.imgThumbnail || $r('app.media.camera_thumbnail_4x'))
              .objectFit(ImageFit.Fill)
              .width('200px')
              .height('200px')
          } else {
            Image(this.videoThumbnail || $r('app.media.camera_thumbnail_4x'))
              .objectFit(ImageFit.Fill)
              .width('200px')
              .height('200px')
          }
        }.onClick(() => {
          if (deviceInfo.deviceType == 'default') {
            context.startAbility({
              bundleName: 'com.ohos.photos',
              abilityName: 'com.ohos.photos.MainAbility'
            })
          } else if (deviceInfo.deviceType == 'phone') {
            context.startAbility({
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
              .width('200px')
              .height('200px')
              .onClick(() => {
                // Countdown camera recording - default camera recording
                this.countTakeVideoFn();
              })
          } else {
            Image($r('app.media.camera_take_video_4x'))
              .width('200px')
              .height('200px')
              .onClick(() => {
                // Countdown camera recording - default camera recording
                this.countTakeVideoFn();
              })
          }
        }
      }.position({ x: '40%', y: '85%' })
      .id('CaptureOrVideoButton')

      // Front and rear camera switching
      Column() {
        Row() {
          Image($r('app.media.camera_switch_4x'))
            .width('200px')
            .height('200px')
            .onClick(async () => {
              // Switching Cameras
              this.cameraDeviceIndex ? this.cameraDeviceIndex = 0 : this.cameraDeviceIndex = 1;
              // Clear configuration
              cameraDemo.releaseSession();
              // Start preview
              cameraDemo.initCamera(this.surfaceId, this.settingDataObj.focusMode, this.cameraDeviceIndex);
            })
        }
      }.position({ x: '70%', y: '85%' })
      .id('SwitchCameraButton')
    } else {
      Column() {
        Row() {
          Text().size({ width: 12, height: 12 }).backgroundColor($r('app.color.theme_color')).borderRadius(6)
          Text(this.dateTimeUtil.getVideoTime(this.videoRecodeTime))
            .fontSize(30)
            .fontColor(Color.White)
            .margin({ left: 8 })
        }.offset({ x: -580, y: -180 })
      }.position({ x: 120, y: 450 })

      Column() {
        // Video capture button
        Image($r('app.media.camera_take_photo_4x'))
          .width('200px')
          .height('200px')
          .onClick(() => {
            cameraDemo.takePictureWithSettings(this.photoSettings);
          })
      }.position({ x: '10%', y: '85%' })
      .id('VideoCaptureButton')

      Column() {
        Row() {
          Column() {
            // video stop button
            Image($r('app.media.camera_pause_video_4x'))
              .size({ width: 25, height: 25 })
              .width('200px')
              .height('200px')
              .id('StopVideo')
              .onClick(() => {
                if (this.timer) {
                  clearInterval(this.timer);
                }
                // Stop video
                this.stopVideo().then(async (fileAsset: mediaLibrary.FileAsset | undefined) => {
                  this.videoRecodeTime = 0;
                  this.isModeBol = true;
                  try {
                    // Get video thumbnail
                      fileAsset !== undefined ? this.videoThumbnail = await fileAsset.getThumbnail() : Logger.info(this.tag, 'fileAsset is undefined')
                  } catch (err) {
                    Logger.info(this.tag, 'videoThumbnail err----------:' + JSON.stringify(err.message));
                  }
                })
              })
          }
          .width('180px')
          .height('180px')
        }
        .width('200px')
        .height('200px')
      }.position({ x: '40%', y: '85%' })
    }
  }

  async stopVideo() {
    try {
      if (this.videoRecorder) {
        await this.videoRecorder.stop();
        await this.videoRecorder.release();
      }
      cameraDemo.videoOutputStopAndRelease();
      if (this.fileAsset) {
        await this.fileAsset.close(this.fd);
        return this.fileAsset;
      }
      Logger.info(this.tag, 'stopVideo end');
    } catch (err) {
      Logger.info(this.tag, 'stopVideo err: ' + JSON.stringify(err));
    }
    return;
  }
}