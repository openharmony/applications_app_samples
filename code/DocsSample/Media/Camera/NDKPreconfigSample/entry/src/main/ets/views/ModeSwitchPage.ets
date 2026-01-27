/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import image from '@ohos.multimedia.image';
import media from '@ohos.multimedia.media';
import deviceInfo from '@ohos.deviceInfo';
import { fileIo, ReadOptions, WriteOptions } from '@kit.CoreFileKit';
import { Constants, SettingDataObj } from '../common/Constants'
import common from '@ohos.app.ability.common'
import { promptAction, router } from '@kit.ArkUI';
import { Decimal } from '@kit.ArkTS';
import { sensor } from '@kit.SensorServiceKit';
import { camera } from '@kit.CameraKit';

import { BusinessError } from '@kit.BasicServicesKit';

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

// scene mode
const NORMAL_PHOTO: number = 1;
const NORMAL_VIDEO: number = 2;
const SECURE_PHOTO: number = 12;

@Component
export struct modeSwitchPage {
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;
  private tag: string = 'sample modeSwitchPage:';
  private fileAsset?: photoAccessHelper.PhotoAsset;
  private fd: number = -1;
  @Link videoId: string;
  @Link mSurfaceId: string;
  @Prop @Watch('onTriggerChange') videoTrigger: number;
  @Prop @Watch('onPhotoChange') photoTrigger: number;
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
      videoFrameRate: 30,
      isHdr: false
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
  private phAccessHelper = photoAccessHelper.getPhotoAccessHelper(this.context);
  @State imgUri: string = '';
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
  @Link sceneMode: camera.SceneMode;
  @Prop preconfigMode: number;
  @Prop preconfigType: number;
  @Prop preconfigRatio: number;
  @Prop photoOutputType: number;
  @Prop isMovingPhoto: boolean;
  @Prop isSavingPhoto: boolean;
  @Prop isHdr: boolean;
  @State buttonWidth: string = '176px';
  @State buttonHeight: string = '176px';
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
  private  videoWidth: number = 1080;
  private  videoHeight: number = 1080;
  private configRatioMapping: Map<number, [number, number]> = new Map([
    [0, [720, 720]],
    [1, [960, 720]],
    [2, [1280, 720]]
  ]);

  private configRatioMapping1080p: Map<number, [number, number]> = new Map([
    [0, [1080, 1080]],
    [1, [1440, 1080]],
    [2, [1920, 1080]]
  ]);

  private configRatioMapping4k: Map<number, [number, number]> = new Map([
    [0, [2160, 2160]],
    [1, [2880, 2160]],
    [2, [3840, 2160]]
  ]);

  // After pausing, click 'stop' to reset the pause to default
  onChangeIsModeBol() {
  }

  async onTriggerChange() {
    await this.getVideoSurfaceID();
    cameraDemo.initCamera(this.surfaceId, this.settingDataObj.focusMode, this.cameraDeviceIndex,
      this.sceneMode, this.preconfigMode, this.preconfigType, this.preconfigRatio,
      this.photoOutputType, this.videoId, this.mSurfaceId);
  }

  async onPhotoChange() {
    await this.getPhotoSurfaceID();
    cameraDemo.initCamera(this.surfaceId, this.settingDataObj.focusMode, this.cameraDeviceIndex,
      this.sceneMode, this.preconfigMode, this.preconfigType, this.preconfigRatio,
      this.photoOutputType, this.videoId, this.mSurfaceId);
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

  async getVideoSurfaceID() {
    this.videoRecorder = await media.createAVRecorder();
    this.getVideoProfile(this.preconfigType, this.preconfigRatio);
    this.fd = this.initFd();
    this.videoConfig.url = `fd://${this.fd}`;
    if (deviceInfo.deviceType == 'default') {
      this.videoConfig.videoSourceType = media.VideoSourceType.VIDEO_SOURCE_TYPE_SURFACE_ES;
    }
    if (deviceInfo.deviceType == 'phone') {
      this.videoConfig.videoSourceType = media.VideoSourceType.VIDEO_SOURCE_TYPE_SURFACE_YUV;
      this.videoConfig.profile.videoCodec = media.CodecMimeType.VIDEO_AVC;
      if (this.cameraDeviceIndex == 1) {
        this.videoConfig.rotation = this.photoRotationMap.rotation270;
      } else {
        this.videoConfig.rotation = this.photoRotationMap.rotation90;
      }
    }
    if (deviceInfo.deviceType == 'tablet') {
      this.videoConfig.videoSourceType = media.VideoSourceType.VIDEO_SOURCE_TYPE_SURFACE_YUV;
    }

    this.videoConfig.profile.isHdr = this.isHdr;
    Logger.info(this.tag, `isHdr = ${this.isHdr}`);
    if (this.isHdr) {
      this.videoConfig.profile.videoBitrate = 2000000;
      this.videoConfig.profile.videoCodec = media.CodecMimeType.VIDEO_HEVC;
    }
    this.videoConfig.profile.videoFrameWidth = this.videoWidth;
    this.videoConfig.profile.videoFrameHeight = this.videoHeight;
    try{
      await this.videoRecorder.prepare(this.videoConfig);
    }catch (err) {
      Logger.error(this.tag, 'videoRecorder.prepare failed: ' + err);
    }

    this.videoId = await this.videoRecorder.getInputSurface();
    Logger.info(this.tag, `js videoId = ${this.videoId}`);
  }

  getVideoProfile(preConfigType: number, configRatio: number) {
    Logger.info(this.tag, `111 this.reconfigWith = ${this.videoWidth}, this.reconfigHeight = ${this.videoHeight},
      this.preConfigType = ${preConfigType},this.configRatio = ${configRatio}`);
    let configRatioMappingSelected: Map<number, [number, number]> | null = null;
    switch (preConfigType) {
      case 0: // 720p
        configRatioMappingSelected = this.configRatioMapping;
        break;
      case 1: // 1080p
        configRatioMappingSelected = this.configRatioMapping1080p;
        break;
      case 2: // 4k
      case 3:
        configRatioMappingSelected = this.configRatioMapping4k;
        break;
      default:
        break;
    }
    let videoSize = configRatioMappingSelected?.get(configRatio);
    if (videoSize) {
      this.videoWidth = videoSize[0];
      this.videoHeight = videoSize[1];
    } else {
      Logger.error(this.tag, `getVideoProfile failed.`);
    }
    Logger.info(this.tag, `222 this.reconfigWith = ${this.videoWidth}, this.reconfigHeight = ${this.videoHeight},
      this.preConfigType = ${preConfigType},this.configRatio = ${configRatio}`);
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

  //保存视频文件
  async readWriteFile(sourceUri: string, destUri: string): Promise<void> {
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
  }

  async savePicture(buffer: ArrayBuffer, img: image.Image) {
    let fileName = `${Date.now()}`;
    let photoType: photoAccessHelper.PhotoType = photoAccessHelper.PhotoType.IMAGE;
    let extension: string = 'jpg';
    let options: photoAccessHelper.CreateOptions = {
      title: fileName
    }
    let accessHelper: photoAccessHelper.PhotoAccessHelper | undefined;
    if (!accessHelper) {
      accessHelper = photoAccessHelper.getPhotoAccessHelper(this.context);
      Logger.info(this.tag, 'getPhotoAccessHelper succcess');
    }
    let imgPhotoUri: string = await accessHelper.createAsset(photoType, extension, options);
    //指定待保存到媒体库的位于应用沙箱的图片uri
    let srcFileUris: string[] = [
      imgPhotoUri
    ];
    // 指定待保存照片的创建选项,包括文件后缀和照片类型,标题和照片子类型可选
    let photoCreationConfigs: photoAccessHelper.PhotoCreationConfig[] = [
      {
        title: fileName, //可选
        fileNameExtension: 'jpg',
        photoType: photoAccessHelper.PhotoType.IMAGE,
        subtype: photoAccessHelper.PhotoSubtype.DEFAULT, //可选
      }
    ];
    // 基于弹窗授权的方式获取媒体库的目标uri
    let desFileUris: string[] = await accessHelper.showAssetsCreationDialog(srcFileUris, photoCreationConfigs);
    // 将来源于应用沙箱的照片内容写入媒体库的目标uri
    let desFile: fileIo.File = await fileIo.open(desFileUris[0], fileIo.OpenMode.WRITE_ONLY);
    await fileIo.write(desFile.fd, buffer.slice(0));

    fileIo.closeSync(desFile);
    Logger.info(this.tag,'create asset by dialog successfully');
    Logger.info(this.tag, 'savePicture end');
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
    if (this.modelBagCol == 'photo') {
      let deviceDegree = await this.getGravity();
      cameraDemo.takePicture(deviceDegree);
    } else if (this.modelBagCol == 'video') {
      this.isModeBol = false;
      if (this.timer) {
        clearInterval(this.timer);
      }

      // Start record
      cameraDemo.startPhotoOrVideo(this.modelBagCol, this.videoId, this.mSurfaceId);
      cameraDemo.videoOutputStart();

      if (this.videoRecorder) {
        this.videoRecorder.start();
      } else {
        Logger.error(this.tag, 'ERROR: videoRecorder is null!');
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
          .onClick(async () => {
            this.modelBagCol = 'photo';
            this.sceneMode = camera.SceneMode.NORMAL_PHOTO;
            cameraDemo.releaseSession();
            await this.getPhotoSurfaceID();
            // sceneMode : 1 (NORMAL_PHOTO)
            cameraDemo.initCamera(this.surfaceId, this.settingDataObj.focusMode, this.cameraDeviceIndex,
              this.sceneMode, this.preconfigMode, this.preconfigType, this.preconfigRatio,
              this.photoOutputType, this.videoId, this.mSurfaceId);
          })
      }.position({ x: '45%', y: '77%' })

      Column() {
        Text('录像')
          .fontSize(15)
          .fontColor(Color.White)
          .borderRadius(14)
          .size({ width: 64, height: 28 })
          .onClick(async () => {
            this.modelBagCol = 'video';
            this.sceneMode = camera.SceneMode.NORMAL_VIDEO;
            cameraDemo.releaseSession();
            await this.getVideoSurfaceID();
            // sceneMode : 2 (NORMAL_VIDEO)
            cameraDemo.initCamera(this.surfaceId, this.settingDataObj.focusMode, this.cameraDeviceIndex,
              this.sceneMode, this.preconfigMode, this.preconfigType, this.preconfigRatio,
              this.photoOutputType, this.videoId, this.mSurfaceId);
          })
      }.position({ x: '60%', y: '77%' })

      // album
      Column() {
        Row() {
          if (this.modelBagCol === 'photo') {
            Image(this.imgThumbnail || $r('app.media.camera_thumbnail_4x'))
              .objectFit(ImageFit.Auto)
              .width('170px')
              .height('170px')
              .clip(new Circle({ width: '170px', height: '170px' }))
          } else {
            Image(this.videoThumbnail || $r('app.media.camera_thumbnail_4x'))
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
      .id('Album')

      // capture video icon
      Column() {
        Row() {
          if (this.modelBagCol === 'photo') {
            Image($r('app.media.camera_take_photo_4x'))
              .width(this.buttonWidth)
              .height(this.buttonHeight)
              .onClick(() => {
                // Countdown camera recording - default camera recording
                this.countTakeVideoFn();
              })

          } else {
            Image($r('app.media.camera_take_video_4x'))
              .width('176px')
              .height('176px')
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
            .width('176px')
            .height('176px')
            .onClick(async () => {
              // Switching Cameras
              this.cameraDeviceIndex ? this.cameraDeviceIndex = 0 : this.cameraDeviceIndex = 1;
              // Clear configuration
              cameraDemo.releaseSession();
              if (this.sceneMode == camera.SceneMode.NORMAL_VIDEO) {
                await this.getVideoSurfaceID();
              } else {
                await this.getPhotoSurfaceID();
              }
              // Start preview
              cameraDemo.initCamera(this.surfaceId, this.settingDataObj.focusMode, this.cameraDeviceIndex,
                this.sceneMode, this.preconfigMode, this.preconfigType, this.preconfigRatio,
                this.photoOutputType, this.videoId, this.mSurfaceId);
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
          .width('176px')
          .height('176px')
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
              .width('176px')
              .height('176px')
              .id('StopVideo')
              .onClick(() => {
                if (this.timer) {
                  clearInterval(this.timer);
                }
                // Stop video
                this.stopVideo().then(async (fileAsset: photoAccessHelper.PhotoAsset | undefined) => {
                  this.videoRecodeTime = 0;
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

  async stopVideo() {
    try {
      if (this.videoRecorder) {
        await this.videoRecorder.stop();
        await this.videoRecorder.prepare(this.videoConfig);
        await this.videoRecorder.getInputSurface();
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