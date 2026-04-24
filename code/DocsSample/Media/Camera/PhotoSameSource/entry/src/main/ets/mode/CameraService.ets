/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 ("the License");
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

import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { image } from '@kit.ImageKit';
// [Start import_module]
import { camera } from '@kit.CameraKit';
import { media } from '@kit.MediaKit';
import { BusinessError } from '@kit.BasicServicesKit';
// [End import_module]
import { JSON } from '@kit.ArkTS';
import { fileIo } from '@kit.CoreFileKit';
import { GlobalContext } from '../common/utils/GlobalContext';
import Logger from '../common/utils/Logger';
import { Constants } from '../common/Constants';
import { Context } from '@kit.AbilityKit';
import call from '@ohos.telephony.call';

const TAG: string = 'CameraService';

export class SliderValue {
  public min: number = 1;
  public max: number = 6;
  public step: number = 0.1;
}

class CameraService {
  private cameraManager: camera.CameraManager | undefined = undefined;
  private cameras: Array<camera.CameraDevice> | Array<camera.CameraDevice> = [];
  private cameraInput: camera.CameraInput | undefined = undefined;
  private previewOutput: camera.PreviewOutput | undefined = undefined;
  private photoOutput: camera.PhotoOutput | undefined = undefined;
  private videoOutput: camera.VideoOutput | undefined = undefined;
  private avRecorder: media.AVRecorder | undefined = undefined;
  private session: camera.PhotoSession | camera.VideoSession | undefined = undefined;
  private context: Context | undefined = undefined;
  private surfaceId: string = '';
  private cameraDeviceIndex: number = 0;
  private curCameraDevice: camera.CameraDevice | undefined = undefined;
  private isRecording: boolean = false;
  public frameStartFlag: number = 0;
  private callback: (pixelMap: image.PixelMap, url: string) => void = () => {
  };
  // 推荐拍照分辨率之一
  private photoProfileObj: camera.Profile = {
    format: 2000,
    size: {
      width: Constants.X_COMPONENT_SURFACE_WIDTH,
      height: Constants.X_COMPONENT_SURFACE_HEIGHT
    }
  };
  // 推荐预览分辨率之一
  private previewProfileObj: camera.Profile = {
    format: 1003,
    size: {
      width: Constants.X_COMPONENT_SURFACE_WIDTH,
      height: Constants.X_COMPONENT_SURFACE_HEIGHT
    }
  };
  // 推荐录像分辨率之一
  private videoProfileObj: camera.VideoProfile = {
    format: 1003,
    size: {
      width: Constants.X_COMPONENT_SURFACE_WIDTH,
      height: Constants.X_COMPONENT_SURFACE_HEIGHT
    },
    frameRateRange: {
      min: 30,
      max: 60
    }
  };
  private curSceneMode: camera.SceneMode = camera.SceneMode.NORMAL_PHOTO;

  constructor() {
  }

  setCallback(callback: (pixelMap: image.PixelMap, url: string) => void) {
    this.callback = callback;
  }

  setSceneMode(sceneMode: camera.SceneMode): void {
    this.curSceneMode = sceneMode;
  }

  getSceneMode(): camera.SceneMode {
    return this.curSceneMode;
  }

  getPreviewProfile(cameraOutputCapability: camera.CameraOutputCapability): camera.Profile | undefined {
    let previewProfiles = cameraOutputCapability.previewProfiles;
    if (previewProfiles.length < 1) {
      return undefined;
    }
    let index = previewProfiles.findIndex((previewProfile: camera.Profile) => {
      return previewProfile.size.width === this.previewProfileObj.size.width &&
        previewProfile.size.height === this.previewProfileObj.size.height &&
        previewProfile.format === this.previewProfileObj.format;
    });
    if (index === -1) {
      return undefined;
    }
    return previewProfiles[index];
  }

  // [Start camera_getPhotoOutput]
  getPhotoOutput(cameraManager: camera.CameraManager,
    cameraOutputCapability: camera.CameraOutputCapability): camera.PhotoOutput | undefined {
    let photoProfilesArray: camera.Profile[] = cameraOutputCapability.photoProfiles;
    if (!photoProfilesArray || photoProfilesArray.length === 0) {
      console.error('photoProfilesArray is null or []');
    }
    let photoOutput: camera.PhotoOutput | undefined = undefined;
    try {
      this.photoProfileObj = photoProfilesArray[0]
      photoOutput = cameraManager.createPhotoOutput(photoProfilesArray[0]);
    } catch (error) {
      let err = error as BusinessError;
      console.error(`Failed to createPhotoOutput. error: ${err}`);
    }
    return photoOutput;
}
  // [End camera_getPhotoOutput]

  getVideoProfile(cameraOutputCapability: camera.CameraOutputCapability): camera.VideoProfile | undefined {
    let videoProfiles = cameraOutputCapability.videoProfiles;
    if (videoProfiles.length < 1) {
      return undefined;
    }
    for (let i = 0; i < videoProfiles.length; i++) {
      console.info(TAG, `getVideoProfile:` + JSON.stringify(videoProfiles[i]));
    }
    let index = videoProfiles.findIndex((videoProfile: camera.VideoProfile) => {
      return videoProfile.size.width === this.videoProfileObj.size.width &&
        videoProfile.size.height === this.videoProfileObj.size.height &&
        videoProfile.format === this.videoProfileObj.format &&
        videoProfile.frameRateRange.min <= Constants.MAX_VIDEO_FRAME &&
        videoProfile.frameRateRange.max <= Constants.MAX_VIDEO_FRAME;
    });
    if (index === -1) {
      return undefined;
    }
    return videoProfiles[index];
  }

  isSupportedSceneMode(cameraManager: camera.CameraManager, cameraDevice: camera.CameraDevice): boolean {
    let sceneModes = cameraManager.getSupportedSceneModes(cameraDevice);
    if (sceneModes === undefined) {
      return false;
    }
    let index = sceneModes.findIndex((sceneMode: camera.SceneMode) => {
      return sceneMode === this.curSceneMode;
    });
    if (index === -1) {
      return false;
    }
    return true;
  }

  /**
   * 初始化相机功能
   * @param surfaceId - Surface 的 ID
   * @param cameraDeviceIndex - 相机设备索引
   * @returns 无返回值
   */
  async initCamera(surfaceId: string, cameraDeviceIndex: number, context: Context | undefined): Promise<void> {
    Logger.debug(TAG, `initCamera cameraDeviceIndex: ${cameraDeviceIndex}`);
    this.context = context;
    this.surfaceId = surfaceId;
    this.cameraDeviceIndex = cameraDeviceIndex;
    try {
      await this.releaseCamera();
      // 获取相机管理器实例
      this.cameraManager = this.getCameraManagerFn();
      if (this.cameraManager === undefined) {
        Logger.error(TAG, 'cameraManager is undefined');
        return;
      }
      // 获取支持指定的相机设备对象
      this.cameras = this.getSupportedCamerasFn(this.cameraManager);
      if (this.cameras.length < 1 || this.cameras.length < cameraDeviceIndex + 1) {
        return;
      }
      this.curCameraDevice = this.cameras[cameraDeviceIndex];
      let isSupported = this.isSupportedSceneMode(this.cameraManager, this.curCameraDevice);
      if (!isSupported) {
        Logger.error(TAG, 'The current scene mode is not supported.');
        return;
      }
      let cameraOutputCapability =
        this.cameraManager.getSupportedOutputCapability(this.curCameraDevice, this.curSceneMode);
      let previewProfile = this.getPreviewProfile(cameraOutputCapability);
      if (previewProfile === undefined) {
        Logger.error(TAG, 'The resolution of the current preview stream is not supported.');
        return;
      }
      this.previewProfileObj = previewProfile;
      // 创建previewOutput输出对象
      this.previewOutput = this.createPreviewOutputFn(this.cameraManager, this.previewProfileObj, surfaceId);
      if (this.previewOutput === undefined) {
        Logger.error(TAG, 'Failed to create the preview stream.');
        return;
      }
      // 监听预览事件
      this.previewOutputCallBack(this.previewOutput);
      if (this.curSceneMode === camera.SceneMode.NORMAL_PHOTO) {
        let photoOutput = this.getPhotoOutput(this.cameraManager, cameraOutputCapability);
        this.photoOutput = photoOutput;
        if (this.photoOutput === undefined) {
          Logger.error(TAG, 'Failed to create the photo stream.');
          return;
        }
      } else if (this.curSceneMode === camera.SceneMode.NORMAL_VIDEO) {
        let videoProfile = this.getVideoProfile(cameraOutputCapability);
        if (videoProfile === undefined) {
          Logger.error(TAG, 'The resolution of the current video stream is not supported.');
          return;
        }
        this.videoProfileObj = videoProfile;
        // [Start camera_video_getVideoSurface]
        this.avRecorder = await this.createAVRecorder();
        if (this.avRecorder === undefined) {
          Logger.error(TAG, 'Failed to create the avRecorder.');
          return;
        }
        await this.prepareAVRecorder();
        let videoSurfaceId = await this.avRecorder.getInputSurface();
        // [End camera_video_getVideoSurface]
        // 创建videoOutPut输出对象
        this.videoOutput = this.createVideoOutputFn(this.cameraManager, this.videoProfileObj, videoSurfaceId);
        if (this.videoOutput === undefined) {
          Logger.error(TAG, 'Failed to create the video stream.');
          return;
        }
      }
      // 创建cameraInput输出对象
      this.cameraInput = this.createCameraInputFn(this.cameraManager, this.curCameraDevice);
      if (this.cameraInput === undefined) {
        Logger.error(TAG, 'Failed to create the camera input.');
        return;
      }
      // 打开相机
      let isOpenSuccess = await this.cameraInputOpenFn(this.cameraInput);
      if (!isOpenSuccess) {
        Logger.error(TAG, 'Failed to open the camera.');
        return;
      }
      // 镜头状态回调
      this.onCameraStatusChange(this.cameraManager);
      // 监听CameraInput的错误事件
      this.onCameraInputChange(this.cameraInput, this.curCameraDevice);
      // 会话流程
      await this.sessionFlowFn(this.cameraManager, this.cameraInput, this.previewOutput, this.photoOutput,
        this.videoOutput);
    } catch (error) {
      console.error(TAG, `initCamera fail: ${error.code}`);
    }
  }

  /**
   * 获取可变焦距范围
   */
  getZoomRatioRange(): Array<number> {
    let zoomRatioRange: number[] = [];
    if (this.session !== undefined) {
      try {
        zoomRatioRange = this.session.getZoomRatioRange();
      } catch (error) {
        console.error(`getZoomRatioRange failed.`);
      }
    }
    return zoomRatioRange;
  }

  /**
   * 变焦
   */
  setZoomRatioFn(zoomRatio: number): void {
    Logger.info(TAG, `setZoomRatioFn value ${zoomRatio}`);
    // 获取支持的变焦范围
    try {
      let zoomRatioRange = this.getZoomRatioRange();
      Logger.info(TAG, `getZoomRatioRange success: ${JSON.stringify(zoomRatioRange)}`);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `getZoomRatioRange fail: ${err.code}`);
    }

    try {
      this.session?.setZoomRatio(zoomRatio);
      Logger.info(TAG, 'setZoomRatioFn success');
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `setZoomRatioFn fail: ${err.code}`);
    }
  }

  // [Start camera_capture]
  capture(captureLocation?: camera.Location): void {
    let captureLocationDefault: camera.Location = {
      latitude: 0,
      longitude: 0,
      altitude: 0
    };
    if (captureLocation != undefined) {
      captureLocationDefault = captureLocation;
    }
    let settings: camera.PhotoCaptureSetting = {
      quality: camera.QualityLevel.QUALITY_LEVEL_HIGH,  // 设置图片质量高。
      // 设置图片旋转角度的camera.ImageRotation.ROTATION_0是通过说明中获取拍照角度的getPhotoRotation方法获取的值进行设置。
      rotation: camera.ImageRotation.ROTATION_0,
      location: captureLocation,  // 设置图片地理位置。
      mirror: false  // 设置镜像使能开关(默认关)。
    };
    try {
      if (this.photoOutput == undefined) {
        console.info(`photoOutput is undefined.`);
        return;
      }
      this.photoOutput.capture(settings, (err: BusinessError) => {
        if (err) {
          console.error(`Failed to capture the photo. error: ${err}`);
          return;
        }
        console.info('Callback invoked to indicate the photo capture request success.');
      });
    } catch (error) {
      console.error(`capture call failed. error: ${error}`);
    }
  }
  // [End camera_capture]

  async saveCameraPhoto(asset: photoAccessHelper.PhotoAsset) {
    Logger.info('saveCameraPhoto');
    if (this.context == undefined) {
      Logger.error(TAG, 'context is nullptr');
    }
    try {
      let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(this.context);
      let assetChangeRequest: photoAccessHelper.MediaAssetChangeRequest =
        new photoAccessHelper.MediaAssetChangeRequest(asset);
      assetChangeRequest.saveCameraPhoto();
      await phAccessHelper.applyChanges(assetChangeRequest);
      Logger.info('apply saveCameraPhoto successfully');
    } catch (err) {
      Logger.error(`apply saveCameraPhoto failed with error: ${err.code}, ${err.message}`);
    }
  }

  /**
   * 释放会话及其相关参数
   */
  async releaseCamera(): Promise<void> {
    Logger.info(TAG, 'releaseCamera is called');
    try {
      await this.previewOutput?.release();
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `previewOutput release fail: error: ${err.code}`);
    } finally {
      this.previewOutput = undefined;
    }
    try {
      await this.photoOutput?.release();
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `photoOutput release fail: error: ${err.code}`);
    } finally {
      this.photoOutput = undefined;
    }
    try {
      await this.avRecorder?.release();
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `avRecorder release fail: error: ${err.code}`);
    } finally {
      this.avRecorder = undefined;
    }

    try {
      await this.videoOutput?.release();
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `videoOutput release fail: error: ${err.code}`);
    } finally {
      this.videoOutput = undefined;
    }
    try {
      await this.session?.release();
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `captureSession release fail: error: ${err.code}`);
    } finally {
      this.session = undefined;
    }
    try {
      await this.cameraInput?.close();
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `cameraInput close fail: error: ${err.code}`);
    } finally {
      this.cameraInput = undefined;
    }
    this.offCameraStatusChange();
    Logger.info(TAG, 'releaseCamera success');
  }

  /**
   * 获取相机管理器实例
   */
  getCameraManagerFn(): camera.CameraManager | undefined {
    if (this.cameraManager) {
      return this.cameraManager;
    }
    let cameraManager: camera.CameraManager | undefined = undefined;
    try {
      cameraManager = camera.getCameraManager(GlobalContext.get().getCameraSettingContext());
      console.info(TAG, `getCameraManager success: ${cameraManager}`);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `getCameraManager failed: ${err.code}`);
    }
    return cameraManager;
  }

  /**
   * 获取支持指定的相机设备对象
   */
  getSupportedCamerasFn(cameraManager: camera.CameraManager): Array<camera.CameraDevice> {
    let supportedCameras: camera.CameraDevice[] = [];
    try {
      supportedCameras = cameraManager.getSupportedCameras();
      Logger.info(TAG, `getSupportedCameras success: ${this.cameras}, length: ${this.cameras?.length}`);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `getSupportedCameras failed: ${err.code}`);
    }
    return supportedCameras;
  }

  /**
   * 创建previewOutput输出对象
   */
  createPreviewOutputFn(cameraManager: camera.CameraManager, previewProfileObj: camera.Profile,
    surfaceId: string): camera.PreviewOutput | undefined {
    let previewOutput: camera.PreviewOutput | undefined = undefined;
    try {
      previewOutput = cameraManager.createPreviewOutput(previewProfileObj, surfaceId);
      Logger.info(TAG, `createPreviewOutput success: ${previewOutput}`);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `createPreviewOutput failed: ${err.code}`);
    }
    return previewOutput;
  }

  /**
   * 创建photoOutPut输出对象
   */
  createPhotoOutputFn(cameraManager: camera.CameraManager,
    photoProfileObj: camera.Profile): camera.PhotoOutput | undefined {
    let photoOutput: camera.PhotoOutput | undefined = undefined;
    try {
      photoOutput = cameraManager.createPhotoOutput(photoProfileObj);
      Logger.info(TAG, `createPhotoOutputFn success: ${photoOutput}`);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `createPhotoOutputFn failed: ${err.code}`);
    }
    return photoOutput;
  }

  /**
   * 创建videoOutPut输出对象
   */
  // [Start camera_video_createAVRecorder]
  createVideoOutputFn(cameraManager: camera.CameraManager, videoProfileObj: camera.VideoProfile,
    surfaceId: string): camera.VideoOutput | undefined {
    let videoOutput: camera.VideoOutput | undefined = undefined;
    try {
      videoOutput = cameraManager.createVideoOutput(videoProfileObj, surfaceId);
      Logger.info(TAG, `createVideoOutputFn success: ${videoOutput}`);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `createVideoOutputFn failed: ${err.code}`);
    }
    return videoOutput;
  }
  // [End camera_video_createAVRecorder]

  /**
   * 创建cameraInput输出对象
   */
  createCameraInputFn(cameraManager: camera.CameraManager,
    cameraDevice: camera.CameraDevice): camera.CameraInput | undefined {
    Logger.info(TAG, 'createCameraInputFn is called.');
    let cameraInput: camera.CameraInput | undefined = undefined;
    try {
      cameraInput = cameraManager.createCameraInput(cameraDevice);
      Logger.info(TAG, 'createCameraInputFn success');
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `createCameraInputFn failed: ${err.code}`);
    }
    return cameraInput;
  }

  /**
   * 打开相机
   */
  async cameraInputOpenFn(cameraInput: camera.CameraInput): Promise<boolean> {
    let isOpenSuccess = false;
    try {
      await cameraInput.open();
      isOpenSuccess = true;
      Logger.info(TAG, 'cameraInput open success');
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `createCameraInput failed : ${err.code}`);
    }
    return isOpenSuccess;
  }

  /**
   * 会话流程
   */
  // [Start camera_quality_prioritization]
  async sessionFlowFn(cameraManager: camera.CameraManager, cameraInput: camera.CameraInput,
    previewOutput: camera.PreviewOutput, photoOutput: camera.PhotoOutput | undefined,
    videoOutput: camera.VideoOutput | undefined): Promise<void> {
    try {
      // 创建CaptureSession实例
      if (this.curSceneMode === camera.SceneMode.NORMAL_PHOTO) {
        this.session = cameraManager.createSession(this.curSceneMode) as camera.PhotoSession;
      } else if (this.curSceneMode === camera.SceneMode.NORMAL_VIDEO) {
        this.session = cameraManager.createSession(this.curSceneMode) as camera.VideoSession;
      }
      if (this.session === undefined) {
        return;
      }
      this.onSessionErrorChange(this.session);
      this.onSystemPressureLevelChange(this.session);
      // 开始配置会话
      this.session.beginConfig();
      // 把CameraInput加入到会话
      this.session.addInput(cameraInput);
      // 把previewOutput加入到会话
      this.session.addOutput(previewOutput);
      if (this.curSceneMode === camera.SceneMode.NORMAL_PHOTO) {
        if (photoOutput === undefined) {
          return;
        }
        // 拍照监听事件
        this.photoOutputCallBack(photoOutput);
        // 把photoOutPut加入到会话
        this.session.addOutput(photoOutput);
      } else if (this.curSceneMode === camera.SceneMode.NORMAL_VIDEO) {
        if (videoOutput === undefined) {
          return;
        }
        // 把photoOutPut加入到会话
        this.videoOutputCallback(videoOutput);
        this.session.addOutput(videoOutput);
      }

      // 提交配置信息
      await this.session.commitConfig();
      if (this.curSceneMode === camera.SceneMode.NORMAL_VIDEO) {
        this.setVideoStabilizationFn(this.session as camera.VideoSession, camera.VideoStabilizationMode.MIDDLE);
      }
      this.updateSliderValue();
      if (this.session != undefined) {
        this.configuringSession(this.session);
      }
      // 开始会话工作
      await this.session.start();
      Logger.info(TAG, 'sessionFlowFn success');
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `sessionFlowFn fail : ${err.code}`);
    }
  }

  setVideoStabilizationFn(session: camera.VideoSession, videoStabilizationMode: camera.VideoStabilizationMode): void {
    try {
      // 查询是否支持指定的视频防抖模式
      let isVideoStabilizationModeSupported: boolean =
        session.isVideoStabilizationModeSupported(videoStabilizationMode);
      if (isVideoStabilizationModeSupported) {
        session.setVideoStabilizationMode(videoStabilizationMode);
      }
      Logger.info(TAG, 'setVideoStabilizationFn success');
    } catch (error) {
      console.error(`setVideoStabilizationFn failed, err: ${error.code}`);
    }
  }

  /**
   * 更新滑动条数据
   */
  updateSliderValue(): void {
    let zoomRatioRange = this.getZoomRatioRange();
    if (zoomRatioRange.length !== 0) {
      let zoomRatioMin = zoomRatioRange[0];
      let zoomRatioMax = zoomRatioRange[1] > Constants.ZOOM_RADIO_MAX ? Constants.ZOOM_RADIO_MAX : zoomRatioRange[1];
      let sliderStep =
        zoomRatioRange[1] > Constants.ZOOM_RADIO_MAX ? Constants.ZOOM_RADIO_MAX_STEP : Constants.ZOOM_RADIO_MIN_STEP;
      AppStorage.set<SliderValue>('sliderValue', {
        min: zoomRatioMin,
        max: zoomRatioMax,
        step: sliderStep
      });
    }
  }

  /**
   *  监听拍照回图事件
   */
  // [Start camera_photoAvailable]
  setPhotoOutputCb(photoOutput: camera.PhotoOutput, context: Context) {
    // 设置回调之后，调用photoOutput的capture方法，就会将拍照的buffer回传到回调中。
    photoOutput.on('photoAvailable', (errCode: BusinessError, photo: camera.Photo): void => {
      console.info('getPhoto start');
      if (errCode || photo === undefined) {
        console.error('getPhoto failed, err: ${errCode}');
        return;
      }
        // 如需要在图库中看到所保存的图片、视频资源，请使用用户无感的安全控件创建媒体资源。
        this.mediaLibSavePhotoSingle(context, photo.main)
    });
  }

  mediaLibSavePhotoSingle(context: Context, imageObj: image.Image) {
    imageObj.getComponent(image.ComponentType.JPEG, async (errCode: BusinessError, component: image.Component) => {
      if (errCode || component === undefined) {
        Logger.error('getComponent failed');
        return;
      }
      const buffer: ArrayBuffer = component.byteBuffer;
      if (!buffer) {
        Logger.error('byteBuffer is null');
        return;
      }
      let photoType: photoAccessHelper.PhotoType = photoAccessHelper.PhotoType.IMAGE;
      let extension: string = 'jpg';
      let options: photoAccessHelper.CreateOptions = {
        title: 'testPhoto'
      }
      let assetChangeRequest: photoAccessHelper.MediaAssetChangeRequest =
        photoAccessHelper.MediaAssetChangeRequest.createAssetRequest(context, photoType, extension, options);
      assetChangeRequest.addResource(photoAccessHelper.ResourceType.IMAGE_RESOURCE, buffer)
      assetChangeRequest.saveCameraPhoto();
      let accessHelper: photoAccessHelper.PhotoAccessHelper =
        photoAccessHelper.getPhotoAccessHelper(context);
      await accessHelper.applyChanges(assetChangeRequest);
      let imageSource = image.createImageSource(buffer);
      let pixelmap = imageSource.createPixelMapSync();
      this.callback(pixelmap, assetChangeRequest.getAsset().uri);
      accessHelper.release();
      // buffer处理结束后需要释放该资源，如果未正确释放资源会导致后续拍照获取不到buffer。
      imageObj.release();
    });
  }
  // [End camera_photoAvailable]
  // [Start photo_asset_available]
  onPhotoOutputPhotoAssetAvailable(photoOutput: camera.PhotoOutput, context: Context): void {
    photoOutput.on('photoAssetAvailable', (err: BusinessError, photoAsset: photoAccessHelper.PhotoAsset) => {
      if (err) {
        console.error(`photoAssetAvailable error: ${err}.`);
        return;
      }
      console.info('photoOutPutCallBack photoAssetAvailable');
      // 开发者可通过photoAsset调用媒体库相关接口，自定义处理图片。
      // 处理方式一：调用媒体库落盘接口保存一阶段图，二阶段图就绪后媒体库会主动帮应用替换落盘图片。
      let accessHelper: photoAccessHelper.PhotoAccessHelper =
        photoAccessHelper.getPhotoAccessHelper(this.context);
      this.mediaLibSavePhoto(photoAsset, accessHelper);
      // 处理方式二：调用媒体库接口请求图片并注册一阶段图或二阶段图buffer回调，自定义使用。
      this.mediaLibRequestBuffer(photoAsset, context, this.callback);
    });
  }

  async mediaLibSavePhoto(photoAsset: photoAccessHelper.PhotoAsset,
    phAccessHelper: photoAccessHelper.PhotoAccessHelper): Promise<void> {
    try {
      let assetChangeRequest: photoAccessHelper.MediaAssetChangeRequest =
        new photoAccessHelper.MediaAssetChangeRequest(photoAsset);
      assetChangeRequest.saveCameraPhoto();
      await phAccessHelper.applyChanges(assetChangeRequest);
      phAccessHelper.release().catch(() => {
        console.error(`release failed.`);
      });
    } catch (error) {
      Logger.error(`apply saveCameraPhoto failed with error: ${error.code}, ${error.message}`);
    }
  }

  async mediaLibRequestBuffer(photoAsset: photoAccessHelper.PhotoAsset, context: Context,
    callback: (pixelMap: image.PixelMap, url: string) => void) {
    class MediaDataHandler implements photoAccessHelper.MediaAssetDataHandler<ArrayBuffer> {
      onDataPrepared(data: ArrayBuffer) {
        if (data === undefined) {
          Logger.error('Error occurred when preparing data');
          return;
        }
        let imageSource = image.createImageSource(data);
        imageSource.createPixelMap().then((pixelMap: image.PixelMap) => {
          callback(pixelMap, photoAsset.uri);
        }).catch((err: BusinessError) => {
          Logger.error(`createPixelMap err:${err.code}`);
        })
      }
    }

    let requestOptions: photoAccessHelper.RequestOptions = {
      deliveryMode: photoAccessHelper.DeliveryMode.FAST_MODE,
    }
    const handler = new MediaDataHandler();
    try {
      await photoAccessHelper.MediaAssetManager.requestImageData(context, photoAsset, requestOptions, handler);
    } catch (error) {
      console.error(`requestImageData failed, err: ${error.code}`);
    }
  }
  // [End photo_asset_available]
  /**
   * 监听拍照事件
   */
  photoOutputCallBack(photoOutput: camera.PhotoOutput): void {
    try {
      // [Start capture_start_with_info]
      // 监听拍照开始
      photoOutput.on('captureStartWithInfo', (err: BusinessError, captureStartInfo: camera.CaptureStartInfo): void => {
        Logger.info(TAG, `photoOutputCallBack captureStartWithInfo success: ${JSON.stringify(captureStartInfo)}`);
      });
      // [End capture_start_with_info]
      // 监听拍照帧输出捕获
      photoOutput.on('frameShutter', (err: BusinessError, frameShutterInfo: camera.FrameShutterInfo): void => {
        Logger.info(TAG, `photoOutputCallBack frameShutter captureId:
          ${frameShutterInfo.captureId}, timestamp: ${frameShutterInfo.timestamp}`);
      });
      // [Start capture_end]
      // 监听拍照结束
      photoOutput.on('captureEnd', (err: BusinessError, captureEndInfo: camera.CaptureEndInfo): void => {
        Logger.info(TAG, `photoOutputCallBack captureEnd captureId:
          ${captureEndInfo.captureId}, frameCount: ${captureEndInfo.frameCount}`);
      });
      // [End capture_end]
      // [Start capture_ready]
      photoOutput.on('captureReady', (err: BusinessError) => {
        if (err !== undefined && err.code !== 0) {
          return;
        }
        console.info(`photo capture ready`);
      });
      // [End capture_ready]
      // [Start photoOutput_error]
      // 监听拍照异常
      photoOutput.on('error', (data: BusinessError): void => {
        Logger.info(TAG, `photoOutPut data: ${JSON.stringify(data)}`);
      });
      // [End photoOutput_error]
      if (this.context != undefined) {
        this.onPhotoOutputPhotoAssetAvailable(photoOutput, this.context);
      }
    } catch (err) {
      Logger.error(TAG, 'photoOutputCallBack error');
    }
  }

  /**
   * 监听预览事件
   */
  previewOutputCallBack(previewOutput: camera.PreviewOutput): void {
    Logger.info(TAG, 'previewOutputCallBack is called');
    try {
      // [Start camera_video_frameStart]
      previewOutput.on('frameStart', (): void => {
        Logger.debug(TAG, 'Preview frame started');
        AppStorage.setOrCreate('frameStart', ++this.frameStartFlag);
      });
      // [End camera_video_frameStart]
      // [Start camera_video_frameEnd]
      previewOutput.on('frameEnd', (): void => {
        Logger.debug(TAG, 'Preview frame ended');
      });
      // [End camera_video_frameEnd]
      // [Start camera_video_error]
      previewOutput.on('error', (previewOutputError: BusinessError): void => {
        Logger.info(TAG, `Preview output previewOutputError: ${JSON.stringify(previewOutputError)}`);
      });
      // [End camera_video_error]
    } catch (err) {
      Logger.error(TAG, 'previewOutputCallBack error');
    }
  }

  /**
   * 监听录像事件
   */

  videoOutputCallback(videoOutput: camera.VideoOutput): void {
    Logger.info(TAG, 'VideoOutputCallback is called');
    try {
      videoOutput.on('frameStart', (err: BusinessError) => {
        if (err !== undefined && err.code !== 0) {
          return;
        }
        console.info('Video frame started');
      });
      videoOutput.on('frameEnd', (err: BusinessError) => {
        if (err !== undefined && err.code !== 0) {
          return;
        }
        console.info('Video frame ended');
      });
      videoOutput.on('error', (error: BusinessError) => {
        console.error(`Video output error code: ${error.code}`);
      });
    } catch (err) {
      Logger.error(TAG, `videoOutputCallback error`);
    }

  }
  /**
   * 注册相机状态变化的回调函数
   * @param err - 错误信息（如果有）
   * @param cameraStatusInfo - 相机状态信息
   * @returns 无返回值
   */
  registerCameraStatusChange(err: BusinessError, cameraStatusInfo: camera.CameraStatusInfo): void {
    Logger.info(TAG, `cameraId: ${cameraStatusInfo.camera.cameraId},status: ${cameraStatusInfo.status}`);
  }

  /**
   * 监听相机状态变化
   * @param cameraManager - 相机管理器对象
   * @returns 无返回值
   */
  onCameraStatusChange(cameraManager: camera.CameraManager): void {
    Logger.info(TAG, 'onCameraStatusChange is called');
    try {
      cameraManager.on('cameraStatus', this.registerCameraStatusChange);
    } catch (error) {
      Logger.error(TAG, 'onCameraStatusChange error');
    }
  }

  /**
   * 停止监听相机状态变化
   * @returns 无返回值
   */
  offCameraStatusChange(): void {
    Logger.info(TAG, 'offCameraStatusChange is called');
    this.cameraManager?.off('cameraStatus', this.registerCameraStatusChange);
  }

  /**
   * 监听相机输入变化
   * @param cameraInput - 相机输入对象
   * @param cameraDevice - 相机设备对象
   * @returns 无返回值
   */
  onCameraInputChange(cameraInput: camera.CameraInput, cameraDevice: camera.CameraDevice): void {
    Logger.info(TAG, `onCameraInputChange is called`);
    try {
      cameraInput.on('error', cameraDevice, (cameraInputError: BusinessError): void => {
        Logger.info(TAG, `onCameraInputChange cameraInput error code: ${cameraInputError.code}`);
      });
    } catch (error) {
      Logger.error(TAG, 'onCameraInputChange error');
    }
  }

  /**
   * 监听捕获会话错误变化
   * @param session - 相机捕获会话对象
   * @returns 无返回值
   */
  onSessionErrorChange(session: camera.PhotoSession | camera.VideoSession): void {
    try {
      session.on('error', (captureSessionError: BusinessError): void => {
        Logger.info(TAG,
          'onCaptureSessionErrorChange captureSession fail: ' + JSON.stringify(captureSessionError.code));
      });
    } catch (error) {
      Logger.error(TAG, 'onCaptureSessionErrorChange error');
    }
  }

  /**
   * 监听系统压力
   * @param session - 相机捕获会话对象
   * @returns 无返回值
   */
  // [Start system_pressure_level]
  onSystemPressureLevelChange(session: camera.PhotoSession | camera.VideoSession): void {
    try {
      session.on('systemPressureLevelChange', (error: BusinessError, sysPressureLevel: camera.SystemPressureLevel): void => {
        Logger.info(TAG, 'onSystemPressureLevelChange on, curLevel: ' + JSON.stringify(sysPressureLevel));
        if (error != undefined && error.code != 0) {
          Logger.error(TAG, 'onSystemPressureLevelChange return error: ' + JSON.stringify(error.code));
        }
      })
    } catch (error) {
      Logger.error(TAG, 'register systemPressureLevelChange failed: ' + JSON.stringify(error.code));
    }
  }
  // [End system_pressure_level]

  // 动态拍照能力
  // [Start camera_moving_photo_support]
  isMovingPhotoSupported(): boolean {
    let isSupported: boolean = false;
    try {
      if (this.photoOutput == undefined) {
        console.error(`photoOutput is nullptr.`);
        return false;
      }
      isSupported = this.photoOutput.isMovingPhotoSupported();
    } catch (error) {
      // 失败返回错误码error.code并处理。
      let err = error as BusinessError;
      console.error(`The isMovingPhotoSupported call failed. error code: ${err.code}`);
    }
    return isSupported;
  }
  // [End camera_moving_photo_support]
  // [Start camera_moving_photo_enable]
  enableMovingPhoto(enable: boolean): void {
    try {
      if (this.photoOutput != undefined) {
        console.info(TAG, `enableMovingPhoto: ${enable}`);
        this.photoOutput.enableMovingPhoto(enable);
      }
    } catch (error) {
      // 失败返回错误码error.code并处理。
      let err = error as BusinessError;
      console.error(`The enableMovingPhoto call failed. error code: ${err.code}`);
    }
  }
  // [End camera_moving_photo_enable]

  async createAVRecorder(): Promise<media.AVRecorder | undefined> {
    let avRecorder: media.AVRecorder | undefined = undefined;
    try {
      avRecorder = await media.createAVRecorder();
    } catch (error) {
      Logger.error(TAG, `createAVRecorder error: ${error}`);
    }
    return avRecorder;
  }

  initFd(): number {
    Logger.info(TAG, 'initFd is called');
    if (this.context == undefined) {
      Logger.error(TAG, 'context is nullptr');
      return 0;
    }
    let filesDir = this.context.filesDir;
    let filePath = filesDir + `/${Date.now()}.mp4`;
    AppStorage.setOrCreate<string>('filePath', filePath);
    try {
      let file: fileIo.File = fileIo.openSync(filePath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
      return file.fd;
    } catch (error) {
      console.error(`initFd failed, err: ${error.code}`);
      return -1;
    }
  }

  // [Start camera_video_createAVRecorder]
  async prepareAVRecorder(): Promise<void> {
    Logger.info(TAG, 'prepareAVRecorder is called');
    let fd = this.initFd();
    let videoConfig: media.AVRecorderConfig = {
      audioSourceType: media.AudioSourceType.AUDIO_SOURCE_TYPE_MIC,
      videoSourceType: media.VideoSourceType.VIDEO_SOURCE_TYPE_SURFACE_YUV,
      profile: {
        audioBitrate: Constants.AUDIO_BITRATE,
        audioChannels: Constants.AUDIO_CHANNELS,
        audioCodec: media.CodecMimeType.AUDIO_AAC,
        audioSampleRate: Constants.AUDIO_SAMPLE_RATE,
        fileFormat: media.ContainerFormatType.CFT_MPEG_4,
        videoBitrate: Constants.VIDEO_BITRATE,
        videoCodec: media.CodecMimeType.VIDEO_AVC,
        videoFrameWidth: this.videoProfileObj.size.width,
        videoFrameHeight: this.videoProfileObj.size.height,
        videoFrameRate: this.videoProfileObj.frameRateRange.max
      },
      url: `fd://${fd.toString()}`,
      rotation: this.curCameraDevice?.cameraOrientation
    };
    Logger.info(TAG, `prepareAVRecorder videoConfig: ${JSON.stringify(videoConfig)}`);
    await this.avRecorder?.prepare(videoConfig).catch((err: BusinessError): void => {
      Logger.error(TAG, `prepareAVRecorder prepare err: ${err.code}`);
    });
  }
  // [End camera_video_createAVRecorder]

  /**
   * 启动录制
   */
  // [Start camera_video_start]
  async startVideo(): Promise<void> {
    Logger.info(TAG, 'startVideo is called');
    try {
      await this.videoOutput?.start();
      await this.avRecorder?.start();
      this.isRecording = true;
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `startVideo err: ${err.code}`);
    }
    Logger.info(TAG, 'startVideo End of call');
  }
  // [End camera_video_end]

  /**
   * 停止录制
   */
  // [Start camera_video_stop]
  async stopVideo(): Promise<void> {
    Logger.info(TAG, 'stopVideo is called');
    if (!this.isRecording) {
      Logger.info(TAG, 'not in recording');
      return;
    }
    try {
      if (this.avRecorder) {
        await this.avRecorder.stop();
      }
      if (this.videoOutput) {
        await this.videoOutput.stop();
      }
      this.isRecording = false;
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `stopVideo err: ${err.code}`);
    }
    Logger.info(TAG, 'stopVideo End of call');
  }// [End camera_video_stop]

  /**
   * 闪关灯
   */
  // [Start camera_flash]
  hasFlashFn(flashMode: camera.FlashMode): void {
    try {
      // 检测是否有闪关灯
      let hasFlash = this.session?.hasFlash();
      Logger.debug(TAG, `hasFlash success, hasFlash: ${hasFlash}`);
      // 检测闪光灯模式是否支持
      let isFlashModeSupported = this.session?.isFlashModeSupported(flashMode);
      Logger.debug(TAG, `isFlashModeSupported success, isFlashModeSupported: ${isFlashModeSupported}`);
      // 设置闪光灯模式
      if (isFlashModeSupported) {
        this.session?.setFlashMode(flashMode);
      }
    } catch (error) {
      console.error(`hasFlashFn failed, err: ${error.code}`);
    }
  }
  // [End camera_flash]
  /**
   * 焦点
   */
  // [Start camera_focus_point]
  setFocusPoint(point: camera.Point): void {
    try {
      // 设置焦点
      this.session?.setFocusPoint(point);
      Logger.info(TAG, `setFocusPoint success point: ${JSON.stringify(point)}`);
      // 获取当前的焦点
      let nowPoint: camera.Point | undefined = undefined;
      nowPoint = this.session?.getFocusPoint();
      Logger.info(TAG, `getFocusPoint success, nowPoint: ${JSON.stringify(nowPoint)}`);
    } catch (error) {
      console.error(`setFocusPoint failed, err: ${error.code}`);
    }
  }
  // [End camera_focus_point]
  /**
   * 曝光区域
   */
  // [Start camera_metering_point]
  isMeteringPoint(point: camera.Point): void {
    try {
      // 获取当前曝光模式
      let exposureMode: camera.ExposureMode | undefined = undefined;
      exposureMode = this.session?.getExposureMode();
      Logger.info(TAG, `getExposureMode success, exposureMode: ${exposureMode}`);
      this.session?.setMeteringPoint(point);
      let exposurePoint: camera.Point | undefined = undefined;
      exposurePoint = this.session?.getMeteringPoint();
      Logger.info(TAG, `getMeteringPoint exposurePoint: ${JSON.stringify(exposurePoint)}`);
    } catch (error) {
      console.error(`isMeteringPoint failed, err: ${error.code}`);
    }
  }
  // [End camera_metering_point]

  /**
   * 曝光补偿
   */
  isExposureBiasRange(exposureBias: number): void {
    try {
      Logger.debug(TAG, `setExposureBias value ${exposureBias}`);
      // 查询曝光补偿范围
      let biasRangeArray: Array<number> | undefined = [];
      biasRangeArray = this.session?.getExposureBiasRange();
      Logger.debug(TAG, `getExposureBiasRange success, biasRangeArray: ${JSON.stringify(biasRangeArray)}`);
      // 设置曝光补偿
      this.session?.setExposureBias(exposureBias);
    } catch (error) {
      console.error(`isExposureBiasRange failed, err: ${error.code}`);
    }
  }

  // [Start camera_param_config]
  configuringSession(photoSession: camera.PhotoSession | camera.VideoSession): void {
    // 判断设备是否支持闪光灯。
    let flashStatus: boolean = false;
    try {
      flashStatus = photoSession.hasFlash();
    } catch (error) {
      let err = error as BusinessError;
      console.error(`Failed to hasFlash. error: ${err}`);
    }
    console.info(`Returned with the flash light support status: ${flashStatus}`);
    if (flashStatus) {
      // 判断是否支持关闭闪光灯模式。
      let flashModeStatus: boolean = false;
      try {
        flashModeStatus = photoSession?.isFlashModeSupported(camera.FlashMode.FLASH_MODE_CLOSE);
      } catch (error) {
        let err = error as BusinessError;
        console.error(`Failed to check whether the flash mode is supported. error: ${err}`);
      }
      if (flashModeStatus) {
        // 设置闪光灯模式关闭。
        try {
          photoSession?.setFlashMode(camera.FlashMode.FLASH_MODE_CLOSE);
        } catch (error) {
          let err = error as BusinessError;
          console.error(`Failed to set the flash mode. error: ${err}`);
        }
      }
    }
    // 判断是否支持连续自动变焦模式。
    let focusModeStatus: boolean = false;
    try {
      focusModeStatus = photoSession?.isFocusModeSupported(camera.FocusMode.FOCUS_MODE_CONTINUOUS_AUTO);
    } catch (error) {
      let err = error as BusinessError;
      console.error(`Failed to check whether the focus mode is supported. error: ${err}`);
    }
    if (focusModeStatus) {
      // 设置连续自动变焦模式。
      try {
        photoSession?.setFocusMode(camera.FocusMode.FOCUS_MODE_CONTINUOUS_AUTO);
      } catch (error) {
        let err = error as BusinessError;
        console.error(`Failed to set the focus mode. error: ${err}`);
      }
    }
    // 获取相机支持的可变焦距比范围。
    let zoomRatioRange: number[] = [];
    try {
      zoomRatioRange = photoSession?.getZoomRatioRange();
    } catch (error) {
      let err = error as BusinessError;
      console.error(`Failed to get the zoom ratio range. error: ${err}`);
    }
    if (zoomRatioRange.length <= 0 ) {
      return;
    }
    // 设置可变焦距比。
    try {
      photoSession?.setZoomRatio(zoomRatioRange[0]);
    } catch (error) {
      let err = error as BusinessError;
      console.error(`Failed to set the zoom ratio value. error: ${err}`);
    }
  }
  // [End camera_param_config]
}

export default new CameraService();