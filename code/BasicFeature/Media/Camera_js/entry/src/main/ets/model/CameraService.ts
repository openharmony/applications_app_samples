/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
// @ts-nocheck
import camera from '@ohos.multimedia.camera';
import image from '@ohos.multimedia.image';
import media from '@ohos.multimedia.media';
import { BusinessError } from '@ohos.base';
import Logger from '../model/Logger';
import { Constants } from '../common/Constants';
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import fs from '@ohos.file.fs';
import { GlobalContext } from '../common/GlobalContext';
import type { CameraConfig } from '../common/CameraConfig';
import colorSpaceManager from '@ohos.graphics.colorSpaceManager';

const cameraSize = {
  width: 1280,
  height: 720
};

enum PhotoOrientation {
  ORIENTATION_0 = 0,
  ORIENTATION_1,
  ORIENTATION_2,
  ORIENTATION_3
}

enum CaptureMode {
  OLD_CAPTURE = 0,
  NEW_CAPTURE,
  NEW_DEFERRED_PHOTO
}

enum CameraMode {
  NORMAL = 0,
  VIDEO,
  PORTRAIT,
  SUPER_STAB,
  NIGHT
}

function mockInterface(): void {
  if (!camera.SceneFeatureType) {
    camera.SceneFeatureType = { MOON_CAPTURE_BOOST: 0 };
  }
  if (!camera.SceneMode) {
    camera.SceneMode = {
      NORMAL_PHOTO: 1,
      NORMAL_VIDEO: 2,
      PORTRAIT_PHOTO: 3,
      NIGHT_PHOTO: 4
    };
  }
}

const TAG: string = 'CameraService';

class CameraService {
  private captureMode: CaptureMode = CaptureMode.OLD_CAPTURE;
  private cameraManager: camera.CameraManager | undefined = undefined;
  private cameras: Array<camera.CameraDevice> | undefined = undefined;
  private sceneModes: Array<camera.SceneMode> | undefined = undefined;
  private cameraOutputCapability: camera.CameraOutputCapability | undefined = undefined;
  private cameraInput: camera.CameraInput | undefined = undefined;
  private previewOutput: camera.PreviewOutput | undefined = undefined;
  private photoOutPut: camera.PhotoOutput | undefined = undefined;
  private photoSession: camera.PhotoSession | undefined = undefined;
  private videoSession: camera.VideoSession | undefined = undefined;
  private portraitSession: camera.PortraitPhotoSession | undefined = undefined;
  private nightSession: camera.NightPhotoSession | undefined = undefined;
  private mReceiver: image.ImageReceiver | undefined = undefined;
  private fileAsset: photoAccessHelper.PhotoAsset | undefined = undefined;
  private fd: number = -1;
  private videoRecorder: media.AVRecorder | undefined = undefined;
  private videoOutput: camera.VideoOutput | undefined = undefined;
  private handleTakePicture: (photoUri: string) => void | undefined = undefined;
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
      videoFrameRate: Constants.VIDEO_FRAME_30
    },
    url: '',
    rotation: 270
  };
  private videoProfiles: Array<camera.VideoProfile>;
  private videoProfileObj: camera.VideoProfile = {
    format: 1003,
    size: {
      width: 1920,
      height: 1080
    },
    frameRateRange: {
      min: Constants.VIDEO_FRAME_30,
      max: Constants.VIDEO_FRAME_30
    }
  };
  private defaultProfile: camera.Profile = {
    format: 1003,
    size: {
      width: 1920,
      height: 1080
    }
  };
  private photoProfileObj: camera.Profile = {
    format: 1003,
    size: {
      width: 1920,
      height: 1080
    }
  };
  private previewProfileObj: camera.Profile = {
    format: 1003,
    size: {
      width: 1920,
      height: 1080
    }
  };
  private photoRotationMap = {
    rotation0: 0,
    rotation90: 90,
    rotation180: 180,
    rotation270: 270,
  };
  private videoOutputStatus: boolean = false;
  private colorEffect: camera.ColorEffectType | undefined = undefined;
  private cameraMode: number = 0;
  private accessHelper: photoAccessHelper.PhotoAccessHelper;
  private globalContext: GlobalContext = GlobalContext.get();
  private isFirstRecord = true;
  private isMoonCaptureBoostSupported: Boolean = false;

  constructor() {
    mockInterface();
    this.accessHelper = photoAccessHelper.getPhotoAccessHelper(this.globalContext.getCameraSettingContext());
    // image capacity
    let imageCapacity = 8;
    try {
      this.mReceiver = image.createImageReceiver(cameraSize.width, cameraSize.height, image.ImageFormat.JPEG, imageCapacity);
      Logger.debug(TAG, `createImageReceiver value: ${this.mReceiver}`);
      // debug版本可能监听进不来
      this.mReceiver.on('imageArrival', (): void => {
        Logger.debug(TAG, 'imageArrival start');
        this.mReceiver.readNextImage((errCode: BusinessError, imageObj: image.Image): void => {
          Logger.info(TAG, 'readNextImage start');
          Logger.info(TAG, `err: ${JSON.stringify(errCode)}`);
          if (errCode || imageObj === undefined) {
            Logger.error(TAG, 'readNextImage failed');
            return;
          }
          imageObj.getComponent(image.ComponentType.JPEG, (errCode: BusinessError, component: image.Component): void => {
            Logger.debug(TAG, 'getComponent start');
            Logger.info(TAG, `err: ${JSON.stringify(errCode)}`);
            if (errCode || component === undefined) {
              Logger.info(TAG, 'getComponent failed');
              return;
            }
            let buffer: ArrayBuffer;
            if (component.byteBuffer) {
              buffer = component.byteBuffer;
            } else {
              Logger.error(TAG, 'component byteBuffer is undefined');
            }
            this.savePicture(buffer, imageObj);
          });
        });
      });
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `savePicture err: ${JSON.stringify(err)}`);
    }
  }

  /**
   * 读取图像
   */
  async savePicture(buffer: ArrayBuffer, img: image.Image): Promise<void> {
    try {
      Logger.info(TAG, 'savePicture start');
      let fileName = `${Date.now()}.jpg`;
      let fileAsset = await this.accessHelper.createAsset(fileName);
      let imgPhotoUri: string = fileAsset.uri;
      const fd = await fileAsset.open('rw');
      await fs.write(fd, buffer);
      await fileAsset.close(fd);
      await img.release();
      Logger.info(TAG, 'savePicture End');
      if (this.handleTakePicture) {
        this.handleTakePicture(imgPhotoUri);
      }
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `savePicture err: ${JSON.stringify(err)}`);
    }
  }

  /**
   * 判断两浮点数是否相等
   */
  withinErrorMargin(left: number, right: number): boolean {
    // 底数
    let baseNumber = 2;
    // 指数
    let indexNumber = 2;
    return Math.abs(left - right) < Number.EPSILON * Math.pow(baseNumber, indexNumber);
  }

  switchProfiles(profiles: camera.CameraOutputCapability): void {
    let previewProfiles: Array<camera.Profile> = profiles.previewProfiles;
    let videoProfiles: Array<camera.Profile> = profiles.videoProfiles;
    let photoProfiles: Array<camera.Profile> = profiles.photoProfiles;
    let isValidProfiles = true;
    if (!previewProfiles || previewProfiles.length < 1) {
      isValidProfiles = false;
    }
    if (isValidProfiles && (!photoProfiles || photoProfiles.length < 1)) {
      isValidProfiles = false;
    }
    if (isValidProfiles && this.cameraMode !== CameraMode.PORTRAIT && (!videoProfiles || videoProfiles.length < 1)) {
      isValidProfiles = false;
    }
    if (!isValidProfiles) {
      Logger.error('Profile is invalid');
      return;
    }
    let defaultAspectRatio: number = AppStorage.get<number>('defaultAspectRatio');
    let previewProfileObj: camera.Profile;
    let photoProfileObj: camera.Profile;
    const deviceType = AppStorage.get<string>('deviceType');
    switch (this.cameraMode) {
      case CameraMode.PORTRAIT:
        previewProfileObj = previewProfiles.find((profile: camera.Profile) => {
          return profile.size.height === this.defaultProfile.size.height &&
            profile.size.width === this.defaultProfile.size.width;
        });
        Logger.info(`previewProfileObj: ${JSON.stringify(previewProfileObj)}`);
        this.previewProfileObj = previewProfileObj;
        photoProfileObj = photoProfiles.find((profile: camera.Profile) => {
          return profile.size.height === this.defaultProfile.size.height &&
            profile.size.width === this.defaultProfile.size.width;
        });
        Logger.info(`photoProfileObj: ${JSON.stringify(photoProfileObj)}`);
        this.photoProfileObj = photoProfileObj;
        break;
      case CameraMode.SUPER_STAB:
        previewProfileObj = previewProfiles.find((profile: camera.Profile) => {
          return profile.size.height === this.defaultProfile.size.height &&
            profile.size.width === this.defaultProfile.size.width;
        });
        Logger.info(`previewProfileObj: ${JSON.stringify(previewProfileObj)}`);
        this.previewProfileObj = previewProfileObj;
        photoProfileObj = photoProfiles.find((profile: camera.Profile) => {
          return profile.size.height === this.defaultProfile.size.height &&
            profile.size.width === this.defaultProfile.size.width;
        });
        Logger.info(`photoProfileObj: ${JSON.stringify(photoProfileObj)}`);
        this.photoProfileObj = photoProfileObj;
        this.videoProfileObj = {
          format: 1003,
          size: {
            width: 1920,
            height: 1080
          },
          frameRateRange: {
            min: 60,
            max: 60
          }
        };
        let videoProfileObj = videoProfiles.find((profile: camera.VideoProfile) => {
          return profile.size.height === this.videoProfileObj.size.height &&
            profile.size.width === this.videoProfileObj.size.width &&
            profile.frameRateRange.min === this.videoProfileObj.frameRateRange.min &&
            profile.frameRateRange.max === this.videoProfileObj.frameRateRange.max;
        });
        Logger.info(`videoProfileObj: ${JSON.stringify(videoProfileObj)}`);
        if (!videoProfileObj) {
          Logger.error('videoProfileObj not supported');
        }
        break;
      case CameraMode.NIGHT:
        previewProfileObj = previewProfiles.find((profile: camera.Profile) => {
          return profile.size.height === this.defaultProfile.size.height &&
            profile.size.width === this.defaultProfile.size.width;
        });
        Logger.info(`previewProfileObj: ${JSON.stringify(previewProfileObj)}`);
        this.previewProfileObj = previewProfileObj;
        photoProfileObj = photoProfiles.find((profile: camera.Profile) => {
          return profile.size.height === this.defaultProfile.size.height &&
            profile.size.width === this.defaultProfile.size.width;
        });
        Logger.info(`photoProfileObj: ${JSON.stringify(photoProfileObj)}`);
        this.photoProfileObj = photoProfileObj;
        break;
      case CameraMode.NORMAL:
      case CameraMode.VIDEO:
      default:
        for (let index = profiles.previewProfiles.length - 1; index >= 0; index--) {
          const previewProfile = profiles.previewProfiles[index];
          if (this.withinErrorMargin(defaultAspectRatio, previewProfile.size.width / previewProfile.size.height)) {
            if (previewProfile.size.width <= Constants.PHOTO_MAX_WIDTH &&
              previewProfile.size.height <= Constants.PHOTO_MAX_WIDTH) {
              let previewProfileTemp = {
                format: deviceType === Constants.DEFAULT ? previewProfile.format : this.defaultProfile.format,
                size: {
                  width: previewProfile.size.width,
                  height: previewProfile.size.height
                }
              };
              this.previewProfileObj = previewProfileTemp;
              Logger.debug(TAG, `previewProfileObj: ${JSON.stringify(this.previewProfileObj)}`);
              break;
            }
          }
        }
        for (let index = profiles.photoProfiles.length - 1; index >= 0; index--) {
          const photoProfile = profiles.photoProfiles[index];
          if (this.withinErrorMargin(defaultAspectRatio, photoProfile.size.width / photoProfile.size.height)) {
            if (photoProfile.size.width <= Constants.PHOTO_MAX_WIDTH &&
              photoProfile.size.height <= Constants.PHOTO_MAX_WIDTH) {
              let photoProfileTemp = {
                format: photoProfile.format,
                size: {
                  width: photoProfile.size.width,
                  height: photoProfile.size.height
                }
              };
              this.photoProfileObj = photoProfileTemp;
              Logger.debug(TAG, `photoProfileObj: ${JSON.stringify(this.photoProfileObj)}`);
              break;
            }
          }
        }
    }
    if (deviceType === Constants.DEFAULT) {
      let cameraConfig = this.globalContext.getObject('cameraConfig') as CameraConfig;
      for (let index = this.videoProfiles.length - 1; index >= 0; index--) {
        const videoProfileObj = this.videoProfiles[index];
        if (this.withinErrorMargin(defaultAspectRatio, videoProfileObj.size.width / videoProfileObj.size.height)) {
          if (videoProfileObj.size.width <= Constants.VIDEO_MAX_WIDTH &&
            videoProfileObj.size.height <= Constants.VIDEO_MAX_WIDTH) {
            let videoProfileTemp = {
              format: videoProfileObj.format,
              size: {
                width: videoProfileObj.size.width,
                height: videoProfileObj.size.height
              },
              frameRateRange: {
                min: Constants.VIDEO_FRAME_30,
                max: Constants.VIDEO_FRAME_30
              }
            };
            if ((cameraConfig.videoFrame === 0 ? Constants.VIDEO_FRAME_15 : Constants.VIDEO_FRAME_30) ===
            videoProfileObj.frameRateRange.min) {
              videoProfileTemp.frameRateRange.min = videoProfileObj.frameRateRange.min;
              videoProfileTemp.frameRateRange.max = videoProfileObj.frameRateRange.max;
              this.videoProfileObj = videoProfileTemp;
              Logger.info(TAG, `videoProfileObj: ${JSON.stringify(this.videoProfileObj)}`);
              break;
            }
            Logger.info(TAG, `videoProfileTemp: ${JSON.stringify(videoProfileTemp)}`);
            this.videoProfileObj = videoProfileTemp;
          }
        }
      }
    }
  }

  setCameraMode(cameraMode: number): void {
    this.cameraMode = cameraMode;
  }

  initProfile(cameraDeviceIndex: number): void {
    let profiles;
    if (this.cameraMode === CameraMode.PORTRAIT) {
      profiles = this.cameraManager.getSupportedOutputCapability(this.cameras[cameraDeviceIndex], camera.SceneMode.PORTRAIT_PHOTO);
    } else {
      profiles = this.cameraManager.getSupportedOutputCapability(this.cameras[cameraDeviceIndex]);
    }
    this.videoProfiles = profiles.videoProfiles;
    this.switchProfiles(profiles);
  }

  /**
   * 初始化
   */
  async initCamera(surfaceId: string, cameraDeviceIndex: number): Promise<void> {
    try {
      this.isFirstRecord = true;
      // 获取传入摄像头
      Logger.debug(TAG, `initCamera cameraDeviceIndex: ${cameraDeviceIndex}`);
      await this.releaseCamera();
      // 获取相机管理器实例
      this.getCameraManagerFn();
      if (this.cameraMode === CameraMode.PORTRAIT || this.cameraMode === CameraMode.NIGHT) {
        this.getModeManagerFn();
      }
      // 获取支持指定的相机设备对象
      this.getSupportedCamerasFn();
      if (this.cameraMode === CameraMode.PORTRAIT || this.cameraMode === CameraMode.NIGHT) {
        this.getSupportedModeFn(cameraDeviceIndex);
      }
      this.initProfile(cameraDeviceIndex);
      // 创建previewOutput输出对象
      this.createPreviewOutputFn(this.previewProfileObj, surfaceId);
      // 监听预览事件
      this.previewOutputCallBack();
      if (this.cameraMode === CameraMode.SUPER_STAB || this.cameraMode === CameraMode.VIDEO) {
        await this.createAVRecorder();
        await this.createVideoOutput();
        // 监听录像事件
        this.onVideoOutputChange();
      }
      // 创建photoOutPut输出对象
      let mSurfaceId = await this.mReceiver.getReceivingSurfaceId();
      this.createPhotoOutputFn(this.photoProfileObj, mSurfaceId);
      // 拍照监听事件
      this.photoOutPutCallBack();
      // 创建cameraInput输出对象
      this.createCameraInputFn(this.cameras[cameraDeviceIndex]);
      // 打开相机
      await this.cameraInputOpenFn();
      // 镜头状态回调
      this.onCameraStatusChange();
      // 监听CameraInput的错误事件
      this.onCameraInputChange();
      // 会话流程
      if (this.cameraMode === CameraMode.PORTRAIT) {
        await this.portraitSessionFlowFn();
      } else if (this.cameraMode === CameraMode.NIGHT) {
        await this.nightSessionFlowFn();
      } else if (this.cameraMode === CameraMode.VIDEO) {
        await this.videoSessionFlowFn();
      } else {
        await this.photoSessionFlowFn();
      }
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `initCamera fail: ${JSON.stringify(err)}`);
    }
  }

  isVideoFrameSupportedFn(videoFrame: number): boolean {
    let videoProfile: camera.VideoProfile | undefined = this.videoProfiles.find((videoProfile: camera.VideoProfile) => {
      return videoProfile.size.height === this.videoProfileObj.size.height &&
        videoProfile.size.width === this.videoProfileObj.size.width &&
        videoProfile.format === this.videoProfileObj.format &&
        videoProfile.frameRateRange.min === videoFrame &&
        videoProfile.frameRateRange.max === videoFrame;
    });
    return videoProfile === undefined ? false : true;
  }

  /**
   * 是否支持摄像头切换
   */
  isCameraSwitchSupportedFn(): boolean {
    return this.cameraManager.getSupportedCameras().length > 1;
  }

  /**
   * 曝光
   */
  isExposureModeSupportedFn(aeMode: camera.ExposureMode): boolean {
    // 检测曝光模式是否支持
    let isSupported: boolean = false;
    let session: camera.PortraitPhotoSession | camera.Session | camera.NightPhotoSession = this.getSession();
    if (!session) {
      return isSupported;
    }
    isSupported = session.isExposureModeSupported(aeMode);
    Logger.info(TAG, `isExposureModeSupported success, isSupported: ${isSupported}`);
    return isSupported;
  }

  setExposureMode(aeMode: camera.ExposureMode): void {
    let session: camera.PortraitPhotoSession | camera.Session | camera.NightPhotoSession = this.getSession();
    if (!session) {
      return;
    }
    session.setExposureMode(aeMode);
    let exposureMode: camera.ExposureMode | undefined = undefined;
    exposureMode = session.getExposureMode();
    Logger.info(TAG, `getExposureMode success, exposureMode: ${exposureMode}`);
  }

  /**
   * 曝光区域
   */
  isMeteringPoint(point: camera.Point): void {
    // 获取当前曝光模式
    let session: camera.PortraitPhotoSession | camera.Session | camera.NightPhotoSession = this.getSession();
    if (!session) {
      return;
    }
    let exposureMode: camera.ExposureMode | undefined = undefined;
    exposureMode = session.getExposureMode();
    Logger.info(TAG, `getExposureMode success, exposureMode: ${exposureMode}`);
    session.setMeteringPoint(point);
    let exposurePoint: camera.Point | undefined = undefined;
    exposurePoint = session.getMeteringPoint();
    Logger.info(TAG, `getMeteringPoint exposurePoint: ${JSON.stringify(exposurePoint)}`);
  }

  /**
   * 曝光补偿
   */
  isExposureBiasRange(exposureBias: number): void {
    Logger.debug(TAG, `setExposureBias value ${exposureBias}`);
    // 查询曝光补偿范围
    let session: camera.PortraitPhotoSession | camera.Session | camera.NightPhotoSession = this.getSession();
    if (!session) {
      return;
    }
    let biasRangeArray: Array<number> = [];
    biasRangeArray = session.getExposureBiasRange();
    Logger.debug(TAG, `getExposureBiasRange success, biasRangeArray: ${JSON.stringify(biasRangeArray)}`);
    // 设置曝光补偿
    session.setExposureBias(exposureBias);
  }

  /**
   * 是否支持对应对焦模式
   */
  isFocusModeSupported(focusMode: camera.FocusMode): boolean {
    let session: camera.PortraitPhotoSession | camera.Session | camera.NightPhotoSession = this.getSession();
    if (!session) {
      return false;
    }
    return session.isFocusModeSupported(focusMode);
  }

  /**
   * 对焦模式
   */
  isFocusMode(focusMode: camera.FocusMode): void {
    // 检测对焦模式是否支持
    let isSupported = this.isFocusModeSupported(focusMode);
    Logger.info(TAG, `isFocusModeSupported isSupported: ${JSON.stringify(isSupported)}`);
    // 设置对焦模式
    if (!isSupported) {
      return;
    }
    let session: camera.PortraitPhotoSession | camera.Session | camera.NightPhotoSession = this.getSession();
    if (!session) {
      return;
    }
    session.setFocusMode(focusMode);
  }

  /**
   * 焦点
   */
  isFocusPoint(point: camera.Point): void {
    // 设置焦点
    let session: camera.PortraitPhotoSession | camera.Session | camera.NightPhotoSession = this.getSession();
    if (!session) {
      return;
    }
    session.setFocusPoint(point);
    Logger.info(TAG, 'setFocusPoint success');
    // 获取当前的焦点
    let nowPoint: camera.Point | undefined = undefined;
    nowPoint = session.getFocusPoint();
    Logger.info(TAG, `getFocusPoint success, nowPoint: ${JSON.stringify(nowPoint)}`);
  }

  /**
   * 闪关灯
   */
  hasFlashFn(flashMode: camera.FlashMode): void {
    let session: camera.PortraitPhotoSession | camera.Session | camera.NightPhotoSession = this.getSession();
    if (!session) {
      return;
    }
    // 检测是否有闪关灯
    let hasFlash = session.hasFlash();
    Logger.debug(TAG, `hasFlash success, hasFlash: ${hasFlash}`);
    // 检测闪光灯模式是否支持
    let isFlashModeSupported = session.isFlashModeSupported(flashMode);
    Logger.debug(TAG, `isFlashModeSupported success, isFlashModeSupported: ${isFlashModeSupported}`);
    // 设置闪光灯模式
    session.setFlashMode(flashMode);
    // 获取当前设备的闪光灯模式
    let nowFlashMode = session.getFlashMode();
    Logger.debug(TAG, `getFlashMode success, nowFlashMode: ${nowFlashMode}`);
  }

  getSession(): camera.PortraitPhotoSession | camera.Session | camera.NightPhotoSession | undefined {
    let session: camera.PortraitPhotoSession | camera.Session | camera.NightPhotoSession = undefined;
    if (this.cameraMode === CameraMode.PORTRAIT) {
      session = this.portraitSession;
    } else if (this.cameraMode === CameraMode.NIGHT) {
      session = this.nightSession;
    } else if (this.cameraMode === CameraMode.VIDEO) {
      session = this.videoSession;
    } else {
      session = this.photoSession;
    }
    return session;
  }

  isSupportZoom() {
    let session: camera.PortraitPhotoSession | camera.Session | camera.NightPhotoSession  = this.getSession();
    let zoomRatioRange = session.getZoomRatioRange();
    return zoomRatioRange != undefined;
  }

  /**
   * 变焦
   */
  setZoomRatioFn(zoomRatio: number): void {
    Logger.info(TAG, `setZoomRatioFn value ${zoomRatio}`);
    // 获取支持的变焦范围
    let session: camera.PortraitPhotoSession | camera.Session | camera.NightPhotoSession = this.getSession();
    if (!session) {
      return;
    }
    try {
      let zoomRatioRange = session.getZoomRatioRange();
      Logger.info(TAG, `getZoomRatioRange success: ${JSON.stringify(zoomRatioRange)}`);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `getZoomRatioRange fail: ${JSON.stringify(err)}`);
    }

    try {
      session.setZoomRatio(zoomRatio);
      Logger.info(TAG, 'setZoomRatioFn success');
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `setZoomRatioFn fail: ${JSON.stringify(err)}`);
    }

    try {
      let nowZoomRatio = session.getZoomRatio();
      Logger.info(TAG, `getZoomRatio nowZoomRatio: ${JSON.stringify(nowZoomRatio)}`);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `getZoomRatio fail: ${JSON.stringify(err)}`);
    }
  }

  /**
   * 防抖
   */
  isVideoStabilizationModeSupportedFn(videoStabilizationMode: camera.VideoStabilizationMode): boolean {
    // 查询是否支持指定的视频防抖模式
    let session: camera.PortraitPhotoSession | camera.Session | camera.NightPhotoSession = this.getSession();
    let isVideoStabilizationModeSupported: boolean = session.isVideoStabilizationModeSupported(videoStabilizationMode);
    Logger.info(TAG, `isVideoStabilizationModeSupported success: ${JSON.stringify(isVideoStabilizationModeSupported)}`);
    return isVideoStabilizationModeSupported;
  }

  setVideoStabilizationMode(videoStabilizationMode: camera.VideoStabilizationMode): void {
    // 设置视频防抖
    Logger.info(TAG, `setVideoStabilizationMode: ${videoStabilizationMode}`);
    let session: camera.PortraitPhotoSession | camera.Session | camera.NightPhotoSession = this.getSession();
    session.setVideoStabilizationMode(videoStabilizationMode);
    let nowVideoStabilizationMod: camera.VideoStabilizationMode = session.getActiveVideoStabilizationMode();
    Logger.info(TAG, `getActiveVideoStabilizationMode nowVideoStabilizationMod: ${nowVideoStabilizationMod}`);
  }

  /**
   * 是否支持夜景模式
   */
  isNightModeSupportedFn(): boolean {
    let isSupportNightMode: boolean = this.sceneModes.indexOf(CameraMode.NIGHT) >= 0;
    Logger.info(TAG, `isSupportNightMode success: ${JSON.stringify(isSupportNightMode)}`);
    return isSupportNightMode;
  }

  /**
   * 是否支持人像模式
   */
  isPortraitModeSupportedFn(): boolean {
    let isSupportPortraitMode: boolean = this.sceneModes.indexOf(CameraMode.PORTRAIT) >= 0;
    Logger.info(TAG, `isSupportPortraitMode success: ${JSON.stringify(isSupportPortraitMode)}`);
    return isSupportPortraitMode;
  }

  /**
   * 是否支持镜像
   */
  isMirrorSupportedFn(): void {
    let isSupported = this.photoOutPut.isMirrorSupported();
    Logger.info(TAG, `isMirrorSupported success Bol: ${JSON.stringify(isSupported)}`);
  }

  setTakePictureCallback(callback: (photoUri: string) => void): void {
    this.handleTakePicture = callback;
  }

  /**
   * 照片方向判断
   */
  onChangeRotation(): number {
    let cameraConfig = (this.globalContext.getObject('cameraConfig') as CameraConfig);
    switch (cameraConfig.photoOrientation) {
      case PhotoOrientation.ORIENTATION_1:
        return this.photoRotationMap.rotation90;
      case PhotoOrientation.ORIENTATION_2:
        return this.photoRotationMap.rotation180;
      case PhotoOrientation.ORIENTATION_3:
        return this.photoRotationMap.rotation270;
      case PhotoOrientation.ORIENTATION_0:
      default:
        return this.photoRotationMap.rotation0;
    }
  }

  /**
   * 照片地理位置逻辑 ，后续需要靠定位实现 目前传入固定值
   */
  onChangeLocation(): {
    latitude: number,
    longitude: number,
    altitude: number
  } {
    let cameraConfig = (this.globalContext.getObject('cameraConfig') as CameraConfig);
    if (cameraConfig.locationBol) {
      return {
        // 位置信息，经纬度
        latitude: 12.9698,
        longitude: 77.7500,
        altitude: 1000
      };
    }
    return {
      latitude: 0,
      longitude: 0,
      altitude: 0
    };
  }

  /**
   * 拍照
   */
  async takePicture(mirrorBol?: boolean): Promise<void> {
    Logger.info(TAG, 'takePicture start');
    mirrorBol = mirrorBol || false;
    this.isMirrorSupportedFn();
    let cameraConfig = (this.globalContext.getObject('cameraConfig') as CameraConfig);
    let photoSettings = {
      rotation: this.onChangeRotation(),
      quality: cameraConfig.photoQuality,
      location: this.onChangeLocation(),
      mirror: cameraConfig.mirrorBol
    };
    Logger.debug(TAG, `takePicture photoSettings:${JSON.stringify(photoSettings)}`);
    await this.photoOutPut.capture(photoSettings);
    Logger.info(TAG, 'takePicture end');
  }

  async prepareAVRecorder(): Promise<void> {
    await this.initUrl();
    let deviceType = AppStorage.get<string>('deviceType');
    if (deviceType === Constants.DEFAULT) {
      this.videoConfig.videoSourceType = media.VideoSourceType.VIDEO_SOURCE_TYPE_SURFACE_ES;
    }
    if (deviceType === Constants.PHONE) {
      this.videoConfig.videoSourceType = media.VideoSourceType.VIDEO_SOURCE_TYPE_SURFACE_YUV;
      this.videoConfig.profile.videoCodec = media.CodecMimeType.VIDEO_AVC;
      this.videoConfig.rotation = this.photoRotationMap.rotation90;
    }
    if (deviceType === Constants.TABLET) {
      this.videoConfig.videoSourceType = media.VideoSourceType.VIDEO_SOURCE_TYPE_SURFACE_YUV;
    }
    this.videoConfig.profile.videoFrameWidth = this.videoProfileObj.size.width;
    this.videoConfig.profile.videoFrameHeight = this.videoProfileObj.size.height;
    this.videoConfig.profile.videoFrameRate = this.videoProfileObj.frameRateRange.max;
    Logger.info(TAG, `prepareAVRecorder deviceType: ${deviceType}, videoSourceType: ${JSON.stringify(this.videoConfig)}`);
    await this.videoRecorder.prepare(this.videoConfig).catch((err: { code?: number }): void => {
      Logger.error(TAG, `prepareAVRecorder prepare err: ${JSON.stringify(err)}`);
    });
  }

  async getAVRecorderSurfaceId(): Promise<string> {
    return await this.videoRecorder.getInputSurface();
  }

  async createAVRecorder(): Promise<void> {
    this.videoRecorder = await media.createAVRecorder();
  }

  /**
   * 配置videoOutput流
   */
  async createVideoOutput(): Promise<void> {
    Logger.info(TAG, 'createVideoOutput start');
    await this.prepareAVRecorder();
    let videoId = await this.getAVRecorderSurfaceId();
    Logger.debug(TAG, `createVideoOutput videoProfileObj: ${JSON.stringify(this.videoProfileObj)}`);
    this.videoOutput = this.cameraManager.createVideoOutput(this.videoProfileObj, videoId);
    Logger.info(TAG, 'createVideoOutput end');
  }

  /**
   * 暂停录制
   */
  async pauseVideo(): Promise<void> {
    await this.videoRecorder.pause().then((): void => {
      this.videoOutput.stop();
      this.videoOutputStatus = false;
      Logger.info(TAG, 'pauseVideo success');
    }).catch((err: BusinessError): void => {
      Logger.error(TAG, `pauseVideo failed: ${JSON.stringify(err)}`);
    });
  }

  /**
   * 恢复视频录制
   */
  async resumeVideo(): Promise<void> {
    this.videoOutput.start().then((): void => {
      this.videoOutputStatus = true;
      Logger.info(TAG, 'resumeVideo start');
      this.videoRecorder.resume().then((): void => {
        Logger.info(TAG, 'resumeVideo success');
      }).catch((err: { code?: number }): void => {
        Logger.error(TAG, `resumeVideo failed: ${JSON.stringify(err)}`);
      });
    });
  }

  /**
   * 初始化录制适配地址
   */
  async initUrl(): Promise<void> {
    let fileName = `${Date.now()}.mp4`;
    this.fileAsset = await this.accessHelper.createAsset(fileName);
    this.fd = await this.fileAsset.open('rw');
    this.videoConfig.url = `fd://${this.fd.toString()}`;
  }

  /**
   * 开始录制
   */
  async startVideo(): Promise<void> {
    try {
      Logger.info(TAG, 'startVideo begin');
      await this.videoOutput.start();
      this.videoOutputStatus = true;
      if (!this.isFirstRecord) {
        await this.prepareAVRecorder();
        await this.getAVRecorderSurfaceId();
      }
      await this.videoRecorder.start();
      this.isFirstRecord = false;
      AppStorage.setOrCreate<boolean>('isRecorder', true);
      Logger.info(TAG, 'startVideo end');
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `startVideo err: ${JSON.stringify(err)}`);
    }
  }

  async releaseVideoRecorder(): Promise<void> {
    if (this.videoRecorder) {
      try {
        await this.videoRecorder.release();
        this.videoOutputStatus = false;
        AppStorage.setOrCreate<boolean>('isRecorder', false);
      } catch (error) {
        let err = error as BusinessError;
        Logger.error(TAG, 'stopVideo err: ' + JSON.stringify(err));
      }
    }
  }

  /**
   * 停止录制
   */
  async stopVideo(): Promise<photoAccessHelper.PhotoAsset> {
    let isRecorder: boolean = AppStorage.get<boolean>('isRecorder');
    if (!isRecorder) {
      Logger.info(TAG, 'not in recording');
      return undefined;
    }
    try {
      Logger.info(TAG, 'stopVideo start');
      AppStorage.setOrCreate<boolean>('isRecorder', false);
      if (this.videoRecorder) {
        await this.videoRecorder.stop();
      }
      if (this.videoOutputStatus) {
        await this.videoOutput.stop();
        this.videoOutputStatus = false;
      }
      if (this.fileAsset) {
        await this.fileAsset.close(this.fd);
        return this.fileAsset;
      }
      return undefined;
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, 'stopVideo err: ' + JSON.stringify(err));
      return undefined;
    }
  }

  /**
   * 释放会话及其相关参数
   */
  async releaseCamera(): Promise<void> {
    Logger.info(TAG, 'releaseCamera is called');
    await this.stopVideo();
    await this.releaseVideoRecorder();
    if (this.previewOutput) {
      try {
        await this.previewOutput.stop();
        await this.previewOutput.release();
      } catch (error) {
        let err = error as BusinessError;
        Logger.error(TAG, `previewOutput release fail: error: ${JSON.stringify(err)}`);
      } finally {
        this.previewOutput = null;
      }

    }
    if (this.photoOutPut) {
      try {
        await this.photoOutPut.release();
      } catch (error) {
        let err = error as BusinessError;
        Logger.error(TAG, `photoOutPut release fail: error: ${JSON.stringify(err)}`);
      } finally {
        this.photoOutPut = null;
      }
    }
    if (this.videoOutput) {
      try {
        await this.videoOutput.release();
      } catch (error) {
        let err = error as BusinessError;
        Logger.error(TAG, `videoOutput release fail: error: ${JSON.stringify(err)}`);
      } finally {
        this.videoOutput = null;
      }
    }
    if (this.portraitSession) {
      try {
        await this.portraitSession.release();
      } catch (error) {
        let err = error as BusinessError;
        Logger.error(TAG, `portraitSession release fail: error: ${JSON.stringify(err)}`);
      } finally {
        this.portraitSession = null;
      }
    }
    if (this.nightSession) {
      try {
        await this.nightSession.release();
      } catch (error) {
        let err = error as BusinessError;
        Logger.error(TAG, `nightSession release fail: error: ${JSON.stringify(err)}`);
      } finally {
        this.nightSession = null;
      }
    }
    if (this.photoSession) {
      try {
        await this.photoSession.release();
      } catch (error) {
        let err = error as BusinessError;
        Logger.error(TAG, `photoSession release fail: error: ${JSON.stringify(err)}`);
      } finally {
        this.photoSession = null;
      }
    }
    if (this.videoSession) {
      try {
        await this.videoSession.release();
      } catch (error) {
        let err = error as BusinessError;
        Logger.error(TAG, `videoSession release fail: error: ${JSON.stringify(err)}`);
      } finally {
        this.videoSession = null;
      }
    }
    if (this.cameraInput) {
      try {
        await this.cameraInput.close();
      } catch (error) {
        let err = error as BusinessError;
        Logger.error(TAG, `cameraInput close fail: error: ${JSON.stringify(err)}`);
      } finally {
        this.cameraInput = null;
      }
    }
    Logger.info(TAG, 'releaseCamera success');
  }

  /**
   * 获取相机管理器实例
   */
  getCameraManagerFn(): void {
    if (this.cameraManager) {
      return;
    }
    try {
      this.cameraManager = camera.getCameraManager(GlobalContext.get().getCameraSettingContext());
      Logger.info(TAG, `getCameraManager success: ${this.cameraManager}`);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `getCameraManager failed: ${JSON.stringify(err)}`);
    }
  }

  getModeManagerFn(): void {
    try {
      this.cameraManager = camera.getCameraManager(GlobalContext.get().getCameraSettingContext());
      Logger.info(TAG, `getModeManagerFn success: ${this.cameraManager}`);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `getModeManagerFn failed: ${JSON.stringify(err)}`);
    }
  }

  /**
   * 获取支持指定的相机设备对象
   */
  getSupportedCamerasFn(): void {
    try {
      this.cameras = this.cameraManager.getSupportedCameras();
      Logger.info(TAG, `getSupportedCameras success: ${this.cameras}, length: ${this.cameras.length}`);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `getSupportedCameras failed: ${JSON.stringify(err)}`);
    }
  }

  getSupportedModeFn(cameraIndex: number): void {
    try {
      this.sceneModes = this.cameraManager.getSupportedSceneModes(this.cameras[cameraIndex]);
      Logger.info(TAG, `getSupportedModeFn success: ${this.sceneModes}, length: ${this.sceneModes.length}`);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `getSupportedModeFn failed: ${JSON.stringify(err)}`);
    }
  }

  /**
   * 查询相机设备在模式下支持的输出能力
   */
  async getSupportedOutputCapabilityFn(cameraDeviceIndex: number): Promise<void> {
    this.cameraOutputCapability = this.cameraManager.getSupportedOutputCapability(this.cameras[cameraDeviceIndex]);
  }

  /**
   * 创建previewOutput输出对象
   */
  createPreviewOutputFn(photoProfileObj: camera.Profile, surfaceId: string): void {
    try {
      this.previewOutput = this.cameraManager.createPreviewOutput(photoProfileObj, surfaceId);
      Logger.info(TAG, `createPreviewOutput success: ${this.previewOutput}`);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `createPreviewOutput failed: ${JSON.stringify(err)}`);
    }
  }

  /**
   * 创建photoOutPut输出对象
   */
  createPhotoOutputFn(photoProfileObj: camera.Profile, surfaceId: string): void {
    Logger.info(TAG, `createPhotoOutputFn photoProfiles: ${JSON.stringify(photoProfileObj)} ,captureMode: ${this.captureMode}, surfaceId: ${surfaceId}`);
    switch (this.captureMode) {
      case CaptureMode.OLD_CAPTURE:
        this.photoOutPut = this.cameraManager.createPhotoOutput(photoProfileObj, surfaceId);
        break;
      case CaptureMode.NEW_CAPTURE:
      case CaptureMode.NEW_DEFERRED_PHOTO:
        this.photoOutPut = this.cameraManager.createPhotoOutput(photoProfileObj);
        if (this.photoOutPut == null) {
          Logger.error(TAG, 'createPhotoOutputFn createPhotoOutput failed');
        }
        break;
    }
  }

  /**
   * 创建cameraInput输出对象
   */
  createCameraInputFn(cameraDevice: camera.CameraDevice): void {
    Logger.info(TAG, 'createCameraInputFn is called.');
    try {
      this.cameraInput = this.cameraManager.createCameraInput(cameraDevice);
    } catch (err) {

    }
  }

  /**
   * 打开相机
   */
  async cameraInputOpenFn(): Promise<void> {
    try {
      await this.cameraInput.open();
      Logger.info(TAG, 'cameraInput open success');
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `createCameraInput failed : ${JSON.stringify(err)}`);
    }
  }

  /**
   * 处理望月信息
   */
  configMoonCaptureBoost(): void {
    try {
      let session: camera.PortraitPhotoSession | camera.Session | camera.NightPhotoSession = this.getSession();
      this.isMoonCaptureBoostSupported =
      session.isSceneFeatureSupported(camera.SceneFeatureType.MOON_CAPTURE_BOOST);
      if (this.isMoonCaptureBoostSupported) {
        session.on('featureDetectionStatus', camera.SceneFeatureType.MOON_CAPTURE_BOOST,
          (error, statusObject) => {
            Logger.info(TAG,
              `on featureDetectionStatus featureType:${statusObject.featureType} detected:${statusObject.detected}`);
            if (statusObject.featureType === camera.SceneFeatureType.MOON_CAPTURE_BOOST) {
              let status = statusObject.detected;
              Logger.info(TAG, `on moonCaptureBoostStatus change:${status}`);
              AppStorage.setOrCreate('moonCaptureComponentIsShow', status);
              if (!status) {
                this.setMoonCaptureBoostEnable(status);
              }
            }
          });
      }
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `isMoonCaptureBoostSupported fail: error code ${err.code}`);
    }
  }

  /**
   * 拍照会话流程
   */
  async photoSessionFlowFn(): Promise<void> {
    try {
      Logger.info(TAG, "photoSessionFlowFn start");
      // 创建PhotoSession实例
      this.photoSession = this.cameraManager.createSession(camera.SceneMode.NORMAL_PHOTO);
      // 监听焦距的状态变化
      this.onFocusStateChange();
      // 监听拍照会话的错误事件
      this.onCaptureSessionErrorChange();
      // 开始配置会话
      this.photoSession.beginConfig();
      // 把CameraInput加入到会话
      this.photoSession.addInput(this.cameraInput);
      // 把previewOutput加入到会话
      this.photoSession.addOutput(this.previewOutput);
      // 把photoOutPut加入到会话
      this.photoSession.addOutput(this.photoOutPut);
      // hdr 拍照
      let hdrPhotoBol: boolean = (this.globalContext.getObject('cameraConfig') as CameraConfig).hdrPhotoBol;
      Logger.info(TAG, "hdrPhotoBol:" + hdrPhotoBol);
      if (hdrPhotoBol) {
        this.setColorSpace(this.photoSession, colorSpaceManager.ColorSpace.DISPLAY_P3);
      } else {
        this.setColorSpace(this.photoSession, colorSpaceManager.ColorSpace.SRGB);
      }
      // 提交配置信息
      await this.photoSession.commitConfig();
      // 开始会话工作
      await this.photoSession.start();
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `photoSessionFlowFn fail : ${JSON.stringify(err)}`);
    }
  }

  /**
   * 录像会话流程
   */
  async videoSessionFlowFn(): Promise<void> {
    try {
      Logger.info(TAG, "videoSessionFlowFn start");
      // 创建VideoSession实例
      this.videoSession = this.cameraManager.createSession(camera.SceneMode.NORMAL_VIDEO);
      // 监听焦距的状态变化
      this.onFocusStateChange();
      // 监听拍照会话的错误事件
      this.onCaptureSessionErrorChange();
      // 开始配置会话
      this.videoSession.beginConfig();
      // 把CameraInput加入到会话
      this.videoSession.addInput(this.cameraInput);
      // 把previewOutput加入到会话
      this.videoSession.addOutput(this.previewOutput);
      // 把photoOutPut加入到会话
      this.videoSession.addOutput(this.videoOutput);
      // 提交配置信息
      await this.videoSession.commitConfig();
      // hdr 录像
      let hdrVideoBol: boolean = (this.globalContext.getObject('cameraConfig') as CameraConfig).hdrVideoBol;
      Logger.info(TAG, "hdrVideoBol:" + hdrVideoBol);
      if (hdrVideoBol) {
        this.setColorSpace(this.videoSession, colorSpaceManager.ColorSpace.BT2020_HLG);
      } else {
        this.setColorSpace(this.videoSession, colorSpaceManager.ColorSpace.BT709);
      }
      // 开始会话工作
      await this.videoSession.start();
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `videoSessionFlowFn fail : ${JSON.stringify(err)}`);
    }
  }

  async portraitSessionFlowFn(sceneModeIndex?: number): Promise<void> {
    try {
      // 创建PortraitSession实例
      this.portraitSession = this.cameraManager.createSession(camera.SceneMode.PORTRAIT_PHOTO);
      // 监听焦距的状态变化
      this.onFocusStateChange();
      // 监听拍照会话的错误事件
      this.onCaptureSessionErrorChange();
      // 开始配置会话
      this.portraitSession.beginConfig();
      // 把CameraInput加入到会话
      this.portraitSession.addInput(this.cameraInput);
      // 把previewOutput加入到会话
      this.portraitSession.addOutput(this.previewOutput);
      // 把photoOutPut加入到会话
      this.portraitSession.addOutput(this.photoOutPut);
      if (this.captureMode === CaptureMode.NEW_DEFERRED_PHOTO) {
        if (this.isDeferredImageDeliverySupported(camera.DeferredDeliveryImageType.PHOTO)) {
          this.deferImageDeliveryFor(camera.DeferredDeliveryImageType.PHOTO);
          this.isDeferredImageDeliveryEnabled(camera.DeferredDeliveryImageType.PHOTO);
        }
      }

      // 提交配置信息
      await this.portraitSession.commitConfig();

      // 处理变焦条信息
      try {
        let range: Array<number> = this.portraitSession.getZoomRatioRange();
        Logger.info(TAG, `getZoomRatioRange:${range}`);
        if (range) {
          AppStorage.setOrCreate('zoomRatioMin', range[0]);
          AppStorage.setOrCreate('zoomRatioMax', range[1]);
        }
      } catch (error) {
        let err = error as BusinessError;
        Logger.error(TAG, `getZoomRatioRange fail: error code ${err.code}`);
      }
      // 开始会话工作
      await this.portraitSession.start();
      this.isFocusMode((this.globalContext.getObject('cameraConfig') as CameraConfig).focusMode);
      Logger.info(TAG, 'portraitSessionFlowFn success');
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `portraitSessionFlowFn fail : ${JSON.stringify(err)}`);
    }
  }

  async nightSessionFlowFn(sceneModeIndex?: number): Promise<void> {
    try {
      // 创建PortraitSession实例
      this.nightSession = this.cameraManager.createSession(camera.SceneMode.NIGHT_PHOTO);
      // 监听焦距的状态变化
      this.onFocusStateChange();
      // 监听拍照会话的错误事件
      this.onCaptureSessionErrorChange();
      // 开始配置会话
      this.nightSession.beginConfig();
      // 把CameraInput加入到会话
      this.nightSession.addInput(this.cameraInput);
      // 把previewOutput加入到会话
      this.nightSession.addOutput(this.previewOutput);
      // 把photoOutPut加入到会话
      this.nightSession.addOutput(this.photoOutPut);
      if (this.captureMode === CaptureMode.NEW_DEFERRED_PHOTO) {
        if (this.isDeferredImageDeliverySupported(camera.DeferredDeliveryImageType.PHOTO)) {
          this.deferImageDeliveryFor(camera.DeferredDeliveryImageType.PHOTO);
          this.isDeferredImageDeliveryEnabled(camera.DeferredDeliveryImageType.PHOTO);
        }
      }

      // 提交配置信息
      await this.nightSession.commitConfig();

      // 处理变焦条信息
      try {
        let range: Array<number> = this.nightSession.getZoomRatioRange();
        Logger.info(TAG, `getZoomRatioRange:${range}`);
        if (range) {
          AppStorage.setOrCreate('zoomRatioMin', range[0]);
          AppStorage.setOrCreate('zoomRatioMax', range[1]);
        }
      } catch (error) {
        let err = error as BusinessError;
        Logger.error(TAG, `getZoomRatioRange fail: error code ${err.code}`);
      }
      // 开始会话工作
      await this.nightSession.start();
      this.isFocusMode((this.globalContext.getObject('cameraConfig') as CameraConfig).focusMode);
      Logger.info(TAG, 'nightSessionFlowFn success');
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `nightSessionFlowFn fail : ${JSON.stringify(err)}`);
    }
  }

  setColorSpace(session: camera.PhotoSession | camera.VideoSession, colorSpace: colorSpaceManager.ColorSpace): void {
    try {
      Logger.info(TAG, `setColorSpace enter`);
      let colorSpaces: Array<colorSpaceManager.ColorSpace> = session.getSupportedColorSpaces();
      let isSupportedUseColorSpaces = colorSpaces.indexOf(colorSpace);
      if (isSupportedUseColorSpaces) {
        Logger.info(TAG, `setColorSpace ${colorSpace} start`);
        session.setColorSpace(colorSpace);
        Logger.info(TAG, `setColorSpace ${colorSpace} success`);
        return;
      }
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `setColorSpace fail : ${JSON.stringify(err)}`);
    }
  }

  setPortraitEffect(): void {
    try {
      this.portraitSession.setPortraitEffect(camera.PortraitEffect.CIRCLES);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `setPortraitEffect error code: ${err.code}`);
    }
    this.getPortraitEffect();
  }

  getPortraitEffect(): void {
    try {
      let portraitEffect = this.portraitSession.getPortraitEffect();
      Logger.info(TAG, `getPortraitEffect portraitEffect: ${portraitEffect}`);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `setPortraitEffect error code: ${err.code}`);
    }
  }

  setMoonCaptureBoostEnable(moonCaptureBoostEnable: Boolean): boolean {
    Logger.info(TAG, 'moonCaptureBoostEnable is called.');
    let session: camera.CaptureSession = this.getSession();
    if (!session) {
      return false;
    }
    try {
      session.enableSceneFeature(camera.SceneFeatureType.MOON_CAPTURE_BOOST, moonCaptureBoostEnable);
      AppStorage.setOrCreate<boolean>('moonCaptureComponentEnable', moonCaptureBoostEnable);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `setMoonCaptureBoostEnable fail: error code ${err.code}`);
      return false;
    }
    return true;
  }

  setColorEffect(colorEffect: camera.ColorEffectType): void {
    Logger.info(TAG, 'setColorEffect is called.');
    if (this.photoSession || this.videoSession || this.portraitSession || this.nightSession) {
      let res: Array<camera.ColorEffectType> | undefined = [];
      res = this.getSupportedColorEffects();
      let session: camera.PortraitPhotoSession | camera.Session | camera.NightPhotoSession = this.getSession();
      if (!session) {
        return;
      }
      for (let i = 0; i < res.length; i++) {
        if (res[i] === colorEffect) {
          Logger.info(TAG, 'setColorEffect success.');
          session.setColorEffect(colorEffect);
          this.colorEffect = colorEffect;
          return;
        }
      }
      Logger.error(TAG, `setColorEffect fail: The colorEffect ${colorEffect} was not found`);
    }
  }

  getColorEffect(): camera.ColorEffectType | undefined {
    Logger.info(TAG, 'getColorEffect is called.');
    let colorEffect: camera.ColorEffectType | undefined = undefined;
    if (this.photoSession || this.videoSession || this.portraitSession || this.nightSession) {
      let session: camera.PortraitPhotoSession | camera.Session | camera.NightPhotoSession = this.getSession();
      if (!session) {
        return colorEffect;
      }
      try {
        colorEffect = session.getColorEffect();
      } catch (error) {
        let err = error as BusinessError;
        Logger.error(TAG, `setColorEffect fail: error code ${err.code}`);
      }
    }
    return colorEffect;
  }

  getSupportedColorEffects(): Array<camera.ColorEffectType> | undefined {
    Logger.info(TAG, 'getSupportedColorEffects is called.');
    let res: Array<camera.ColorEffectType> | undefined = [];
    if (this.photoSession || this.videoSession || this.portraitSession || this.nightSession) {
      let session: camera.PortraitPhotoSession | camera.Session | camera.NightPhotoSession = this.getSession();
      if (!session) {
        return res;
      }
      res = session.getSupportedColorEffects();
      Logger.info(TAG, `getSupportedColorEffects length: ${res.length}`);
    }
    return res;
  }

  /**
   * 监听拍照事件
   */
  photoOutPutCallBack(): void {
    // 监听拍照开始
    this.photoOutPut.on('captureStart', (err: BusinessError, captureId: number): void => {
      Logger.info(TAG, `photoOutPutCallBack captureStart captureId success: ${captureId}`);
    });
    // 监听拍照帧输出捕获
    // 获取时间戳转化异常
    this.photoOutPut.on('frameShutter', (err: BusinessError, frameShutterInfo: camera.FrameShutterInfo): void => {
      Logger.info(TAG, `photoOutPutCallBack frameShutter captureId: ${frameShutterInfo.captureId}, timestamp: ${frameShutterInfo.timestamp}`);
    });
    // 监听拍照结束
    this.photoOutPut.on('captureEnd', (err: BusinessError, captureEndInfo: camera.CaptureEndInfo): void => {
      Logger.info(TAG, `photoOutPutCallBack captureEnd captureId: ${captureEndInfo.captureId}, frameCount: ${captureEndInfo.frameCount}`);
    });
    this.photoOutPut.on('error', (data: BusinessError): void => {
      Logger.info(TAG, `photoOutPut data: ${JSON.stringify(data)}`);
    });
    this.photoOutPut.on('photoAvailable', (err: BusinessError, photo: camera.Photo): void => {
      Logger.info(TAG, 'photoOutPutCallBack photoAvailable 3');
      if (err) {
        Logger.info(TAG, `photoAvailable error: ${JSON.stringify(err)}.`);
        return;
      }
      let mainImage: image.Image = photo.main;
      AppStorage.setOrCreate('mainImage', mainImage);
      mainImage.getComponent(image.ComponentType.JPEG, (errCode: BusinessError, component: image.Component): void => {
        Logger.debug(TAG, 'getComponent start');
        Logger.info(TAG, `err: ${JSON.stringify(errCode)}`);
        if (errCode || component === undefined) {
          Logger.info(TAG, 'getComponent failed');
          return;
        }
        let buffer: ArrayBuffer;
        if (component.byteBuffer) {
          buffer = component.byteBuffer;
        } else {
          Logger.error(TAG, 'component byteBuffer is undefined');
        }
        this.savePicture(buffer, mainImage);
      });
      photo.release();
    });
    this.photoOutPut.on('deferredPhotoProxyAvailable', (err: BusinessError, proxyObj: camera.DeferredPhotoProxy): void => {
      if (err) {
        Logger.info(TAG, `deferredPhotoProxyAvailable error: ${JSON.stringify(err)}.`);
        return;
      }
      Logger.info(TAG, 'photoOutPutCallBack deferredPhotoProxyAvailable');
      proxyObj.getThumbnail().then((thumbnail: image.PixelMap) => {
        AppStorage.setOrCreate('proxyThumbnail', thumbnail);
      });
      this.saveDeferredPhoto(proxyObj);
    });
  }

  /**
   * 调用媒体库方式落盘缩略图
   */
  async saveDeferredPhoto(proxyObj: camera.DeferredPhotoProxy): Promise<void> {
    try {
      // 创建 photoAsset
      let photoHelper = photoAccessHelper.getPhotoAccessHelper(this.globalContext.getCameraSettingContext());
      let fileName = Date.now() + '.jpg';
      let photoAsset = await photoHelper.createAsset(fileName);
      let imgPhotoUri: string = photoAsset.uri;
      // 将缩略图代理类传递给媒体库
      let mediaRequest: photoAccessHelper.MediaAssetChangeRequest = new photoAccessHelper.MediaAssetChangeRequest(photoAsset);
      mediaRequest.addResource(photoAccessHelper.ResourceType.PHOTO_PROXY, proxyObj);
      let res = await photoHelper.applyChanges(mediaRequest);
      this.handleTakePicture(imgPhotoUri);
      Logger.info(TAG, `saveDeferredPhoto res:${res}.`);
    } catch (err) {
      Logger.error(TAG, `Failed to saveDeferredPhoto. error: ${JSON.stringify(err)}`);
    }
  }

  /**
   * 监听预览事件
   */
  previewOutputCallBack(): void {
    Logger.info(TAG, 'previewOutputCallBack is called');
    this.previewOutput.on('frameStart', (): void => {
      Logger.debug(TAG, 'Preview frame started');
    });
    this.previewOutput.on('frameEnd', (): void => {
      Logger.debug(TAG, 'Preview frame ended');
    });
    this.previewOutput.on('error', (previewOutputError: BusinessError): void => {
      Logger.info(TAG, `Preview output previewOutputError: ${JSON.stringify(previewOutputError)}`);
    });
  }

  /**
   * 监听录像事件
   */
  onVideoOutputChange(): void {
    this.videoOutput.on('frameStart', (): void => {
      Logger.info(TAG, 'onVideoOutputChange frame started');
    });
    this.videoOutput.on('frameEnd', (): void => {
      Logger.info(TAG, 'onVideoOutputChange frame frameEnd');
    });
    this.videoOutput.on('error', (videoOutputError: BusinessError) => {
      Logger.error(TAG, `onVideoOutputChange fail: ${JSON.stringify(videoOutputError)}`);
    });
  }

  /**
   * 镜头状态回调
   */
  onCameraStatusChange(): void {
    Logger.info(TAG, 'onCameraStatusChange is called');
    this.cameraManager.on('cameraStatus', async (err: BusinessError, cameraStatusInfo: camera.CameraStatusInfo): Promise<void> => {
      Logger.info(TAG, `onCameraStatusChange cameraStatus success, cameraId: ${cameraStatusInfo.camera.cameraId}, status: ${cameraStatusInfo.status}`);
    });
  }

  /**
   * 监听CameraInput的错误事件
   */
  onCameraInputChange(): void {
    try {
      this.cameraInput.on('error', this.cameras[(this.globalContext.getObject('cameraDeviceIndex') as number)], (cameraInputError: BusinessError): void => {
        Logger.info(TAG, `onCameraInputChange cameraInput error code: ${cameraInputError.code}`);
      });
    } catch (error) {
      Logger.info(TAG, `onCameraInputChange cameraInput occur error: error`);
    }
  }

  /**
   * 监听焦距的状态变化
   */
  onFocusStateChange(): void {
    let session: camera.PortraitPhotoSession | camera.Session | camera.NightPhotoSession = this.getSession();
    if (!session) {
      return;
    }
    session.on('focusStateChange', (err: BusinessError, focusState: camera.FocusState): void => {
      Logger.info(TAG, `onFocusStateChange captureSession focusStateChange success : ${focusState}`);
    });
  }

  /**
   * 监听拍照会话的错误事件
   */
  onCaptureSessionErrorChange(): void {
    let session: camera.PortraitPhotoSession | camera.Session | camera.NightPhotoSession = this.getSession();
    if (!session) {
      return;
    }
    session.on('error', (captureSessionError: BusinessError): void => {
      Logger.info(TAG, 'onCaptureSessionErrorChange captureSession fail: ' + JSON.stringify(captureSessionError.code));
    });

  }

  setCaptureMode(mode: number): void {
    this.captureMode = mode;
  }

  getCaptureMode(): number {
    return this.captureMode;
  }

  /**
   * 查询是否支持二阶段
   */
  isDeferredImageDeliverySupported(deferredType: camera.DeferredDeliveryImageType): boolean {
    let res: boolean = this.photoOutPut.isDeferredImageDeliverySupported(deferredType);
    Logger.info(TAG, `isDeferredImageDeliverySupported deferredType:${deferredType} res: ${res}`);
    return res;
  }

  /**
   * 查询是否已使能二阶段
   */
  isDeferredImageDeliveryEnabled(deferredType: camera.DeferredDeliveryImageType): boolean {
    let res: boolean = this.photoOutPut.isDeferredImageDeliveryEnabled(deferredType);
    Logger.info(TAG, `isDeferredImageDeliveryEnabled deferredType:${deferredType} res: ${res}`);
  }

  /**
   * 使能二阶段
   */
  deferImageDeliveryFor(deferredType: camera.DeferredDeliveryImageType): void {
    Logger.info(TAG, `deferImageDeliveryFor type: ${deferredType}`);
    this.photoOutPut.deferImageDelivery(deferredType);
  }

}

export default new CameraService();