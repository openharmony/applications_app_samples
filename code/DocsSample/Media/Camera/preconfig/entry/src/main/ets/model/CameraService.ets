/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { GlobalContext } from '../common/utils/GlobalContext';
import Logger from '../common/utils/Logger';
import { Constants } from '../common/Constants';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { camera } from '@kit.CameraKit';
import { media } from '@kit.MediaKit';
import { BusinessError, deviceInfo } from '@kit.BasicServicesKit';
import { JSON } from '@kit.ArkTS';
import { fileIo } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';
import { display } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import { Decimal } from '@kit.ArkTS';
import { util } from '@kit.ArkTS';
import { window } from '@kit.ArkUI';
import { sensor } from '@kit.SensorServiceKit';
import colorSpaceManager from '@ohos.graphics.colorSpaceManager';

const TAG = 'CameraService';

export class SliderValue {
  public min: number = 1;
  public max: number = 6;
  public step: number = 0.1
}

function getPreviewRotation(previewOutput: camera.PreviewOutput,
  imageRotation: camera.ImageRotation): camera.ImageRotation {
  let previewRotation: camera.ImageRotation = camera.ImageRotation.ROTATION_0;
  try {
    previewRotation = previewOutput.getPreviewRotation(imageRotation);
    console.log(`Preview rotation is: ${previewRotation}`);
  } catch (error) {
    // 失败返回错误码error.code并处理
    let err = error as BusinessError;
    console.error(`The previewOutput.getPreviewRotation call failed. error code:${err.code}`);
  }
  return previewRotation;
}

function setPreviewRotation(previewOutput: camera.PreviewOutput, previewRotation: camera.ImageRotation,
  isDisplayLocked: boolean): void {
  try {
    previewOutput.setPreviewRotation(previewRotation, isDisplayLocked);
  } catch (error) {
    // 失败返回错误码error.code并处理
    let err = error as BusinessError;
    console.error(`The previewOutput.setPreviewRotation call failed. error code: ${err.code}`);
  }
}

function getPhotoRotation(photoOutput: camera.PhotoOutput, deviceDegree: number): camera.ImageRotation {
  let photoRotation: camera.ImageRotation = camera.ImageRotation.ROTATION_0;
  try {
    console.log(`Photo rotation is: ${deviceDegree}`);
    photoRotation = photoOutput.getPhotoRotation(deviceDegree); //90
    console.log(`Photo rotation is: ${photoRotation}`);
  } catch (error) {
    // 失败返回错误码error.code并处理
    let err = error as BusinessError;
    console.error(`The photoOutput.getPhotoRotation call failed. error code: ${err.code}`);
  }
  return photoRotation;
}

class CameraService {
  private static readonly ROTATE_ANGLE_0: number = 0;
  private static readonly ROTATE_ANGLE_90: number = 90;
  private static readonly ROTATE_ANGLE_180: number = 180;
  private static readonly ROTATE_ANGLE_270: number = 270;
  private static readonly ROTATE_ANGLE_360: number = 360;
  private static gCameraService: CameraService | undefined = undefined;
  private cameraManager: camera.CameraManager = camera.getCameraManager(GlobalContext.get().getCameraSettingContext());
  private cameras: Array<camera.CameraDevice> | Array<camera.CameraDevice> = [];
  private cameraInput: camera.CameraInput | undefined = undefined;
  private previewOutput: camera.PreviewOutput | undefined = undefined;
  private previewOutputReceiver: camera.PreviewOutput | undefined = undefined;
  private imageReceiver: image.ImageReceiver | undefined = undefined;
  private imageReceiverSurfaceId: string = '';
  private photoOutput: camera.PhotoOutput | undefined = undefined;
  private videoOutput: camera.VideoOutput | undefined = undefined;
  private avRecorder: media.AVRecorder | undefined = undefined;
  private session: camera.PhotoSession | camera.VideoSession | undefined = undefined;
  private handlePhotoAssetCb: (photoAsset: photoAccessHelper.PhotoAsset) => void = () => {
  };
  private frameStartCallback: () => void = () => {
  };
  private curCameraDevice: camera.CameraDevice | undefined = undefined;
  private isRecording: boolean = false;
  private getDeviceDegree: number = -1;
  private photoRotation: number = 0;
  private fd: number = -1;
  private isSupported: boolean = false;
  private rect: window.Rect | undefined;
  private isHdr: boolean = false;
  private videoWidth: number = 720;
  private videoHeight: number = 720;
  private configRatioMapping: Map<number, [number, number]> = new Map([
    [1, [720, 720]],
    [(4 / 3), [960, 720]],
    [(16 / 9), [1280, 720]]
  ]);

  private configRatioMapping1080p: Map<number, [number, number]> = new Map([
    [1, [1080, 1080]],
    [(4 / 3), [1440, 1080]],
    [(16 / 9), [1920, 1080]]
  ]);

  private configRatioMapping4k: Map<number, [number, number]> = new Map([
    [1, [2160, 2160]],
    [(4 / 3), [2880, 2160]],
    [(16 / 9), [3840, 2160]]
  ]);
  // One of the recommended photo resolutions
  private photoProfileObj: camera.Profile = {
    format: 2000,
    size: {
      width: 1920,
      height: 1080
    }
  };
  // One of the recommended preview resolutions
  private previewProfileObj: camera.Profile = {
    format: 1003,
    size: {
      width: 1280,
      height: 720
    }
  };
  // One of the recommended recording resolutions
  private videoProfileObj: camera.VideoProfile = {
    format: 1003,
    size: {
      width: 1280,
      height: 720
    },
    frameRateRange: {
      min: 30,
      max: 60
    }
  };
  private curSceneMode: camera.SceneMode = camera.SceneMode.NORMAL_PHOTO;
  private isFoldable = display.isFoldable();
  private foldStatusCallback =
    (err: BusinessError, info: camera.FoldStatusInfo): void => this.registerFoldStatusChanged(err, info);
  private preFoldStatus: display.FoldStatus = display.getFoldStatus();
  private handlePhotoAvailableCb: (arrayBuffer: ArrayBuffer) => void = () => {
  };
  private reconfigWidth: number = 16;
  private reconfigHeight: number = 9;
  private reConfigType: number = 720;
  private cameraOutputCapability: camera.CameraOutputCapability | undefined;
  private pixelMapCnt: number = 0;
  private senorId: sensor.SensorId = sensor.SensorId.ACCELEROMETER;

  constructor() {
    // Get Camera Manager instance
    this.cameraManager = this.getCameraManagerFn();
  }

  async savePicture2(buffer: ArrayBuffer) {
    let context = getContext(this);
    let filedata = context.filesDir;
    let filename = display.getDefaultDisplaySync().rotation;
    let filePath = filedata + '/' + filename + '.yuv';
    Logger.info(TAG, 'savePicture packing in path = ' + filePath);
    let file = fileIo.openSync(filePath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
    fileIo.write(file.fd, buffer).then(number => {
      Logger.info(TAG, 'savePicture write data to file succeed and size is:' + number);
    }).catch((err: BusinessError) => {
      Logger.info(TAG, 'savePicture write data to file failed with error:' + err);
    }).finally(() => {
      fileIo.close(this.fd);
    })
    Logger.info(TAG, 'save image done');
  }

  getRealData(data: sensor.GravityResponse): number {
    let getDeviceDegree: number = 0;
    console.info('Succeeded in invoki e. X-coordinate component: ' + data.x);
    console.info('Succeeded in invoking once. Y-coordinate component: ' + data.y);
    console.info('Succeeded in invoking once. Z-coordinate component: ' + data.z);
    let x = data.x;
    let y = data.y;
    let z = data.z;
    if ((x * x + y * y) * 3 < z * z) {
      return getDeviceDegree;
    } else {
      let sd: Decimal = Decimal.atan2(y, -x);
      let sc: Decimal = Decimal.round(Number(sd) / 3.141592653589 * 180);
      getDeviceDegree = 90 - Number(sc);
      getDeviceDegree = getDeviceDegree >= 0 ? getDeviceDegree % 360 : getDeviceDegree % 360 + 360;
    }
    return getDeviceDegree;
  }

  async getGravity(): Promise<number> {
    let data = await sensor.getSensorList();
    for (let i = 0; i < data.length; i++) {
      if (data[i].sensorId === sensor.SensorId.GRAVITY) {
        this.isSupported = true;
        break;
      }
    }
    if (this.isSupported === true) {
      const promise: Promise<number> = new Promise((resolve, reject) => {
        sensor.once(sensor.SensorId.GRAVITY, (data: sensor.GravityResponse) => {
          resolve(this.getRealData(data));
        });
      })
      return promise;
    } else {
      const promise: Promise<number> = new Promise((resolve, reject) => {
        sensor.once(sensor.SensorId.ACCELEROMETER, (data: sensor.AccelerometerResponse) => {
          resolve(this.getRealData(data as sensor.GravityResponse));
        });
      })
      return promise;
    }
  }

  static getInstance(): CameraService {
    if (!CameraService.gCameraService) {
      CameraService.gCameraService = new CameraService();
    }
    return CameraService.gCameraService;
  }

  getCurCameraDevice(): camera.CameraDevice | undefined {
    return this.curCameraDevice;
  }

  setSavePictureCallback(callback: (photoAsset: photoAccessHelper.PhotoAsset) => void): void {
    this.handlePhotoAssetCb = callback;
  }

  setSaveSinglePhotoCallback(callback: (arrayBuffer: ArrayBuffer) => void): void {
    this.handlePhotoAvailableCb = callback;
  }

  setSceneMode(sceneMode: camera.SceneMode): void {
    this.curSceneMode = sceneMode;
  }

  is2in1(): boolean {
    return deviceInfo.deviceType == '2in1';
  }

  getSceneMode(): camera.SceneMode {
    return this.curSceneMode;
  }

  getSurfaceSize(cameraDevice: camera.CameraDevice, configRatio: number): camera.Profile | undefined {
    Logger.info(TAG, `fkr previewProfiles is ${configRatio}`);
    this.cameraOutputCapability =
      this.cameraManager.getSupportedOutputCapability(cameraDevice, this.curSceneMode);
    return this.getPreviewProfile(this.cameraOutputCapability, configRatio);
  }

  getPreviewProfile(cameraOutputCapability: camera.CameraOutputCapability,
    configRatio: number): camera.Profile | undefined {
    Logger.info(TAG, `fkr previewProfiles is false`);
    let previewProfiles = cameraOutputCapability.previewProfiles;
    if (previewProfiles.length < 1) {
      Logger.info(TAG, `previewProfiles is false`);
      return undefined;
    }
    Logger.info(TAG, `previewProfiles this.foramt: ${this.previewProfileObj.format} configRatio = ${configRatio}`);
    let optimalSize: camera.Profile | undefined;
    let minDiff = Number.MAX_VALUE;
    let mLastHeight = 0; // 初始高度为0
    // 计算屏幕的宽高比
    let targetRatio = configRatio; // FULL 1:1 4:3 16:9
    for (let i = 0; i < previewProfiles.length; i++) {
      Logger.info(TAG, `previewProfiles: ${JSON.stringify(previewProfiles[i])}`);
      if (previewProfiles[i].format !== this.previewProfileObj.format) {
        continue;
      }
      let ratio = previewProfiles[i].size.width / previewProfiles[i].size.height; //1088*1080
      // 检查宽高比是否匹配
      if (Math.abs(ratio - configRatio) > 0.2) {
        continue;
      }
      // 选择最接近的分辨率
      if (previewProfiles[i].size.height >= mLastHeight) { // 选出最大的分辨率 1080p > 720P > 480P > 320p
        optimalSize = previewProfiles[i];
        mLastHeight = previewProfiles[i].size.height;
      }
    }

    // 如果没有找到合适的分辨率，选择第一个，根据业务需要添加
    if (optimalSize === undefined) {
      minDiff = Number.MAX_VALUE;
      for (let i = 0; i < previewProfiles.length; i++) {
        if (previewProfiles[i].format !== this.previewProfileObj.format) {
          continue;
        }
        if (Math.abs(previewProfiles[i].size.height - this.reConfigType) <
          minDiff) { // this.reConfigType 作为默认值存在，等比例选择不出来则默认选择某个720P的
          optimalSize = previewProfiles[i];
          minDiff = Math.abs(previewProfiles[i].size.height - this.reConfigType);
        }
      }
    }

    Logger.info(TAG, `optimalSize: ${JSON.stringify(optimalSize)}`);
    return optimalSize;
  }

  getPhotoProfile(cameraOutputCapability: camera.CameraOutputCapability): camera.Profile | undefined {
    let photoProfiles = cameraOutputCapability.photoProfiles;
    if (photoProfiles.length < 1) {
      return undefined;
    }
    for (let i = 0; i < photoProfiles.length; i++) {
      Logger.info(TAG, `photoProfiles: ${JSON.stringify(photoProfiles[i])}`);
    }
    let index = photoProfiles.findIndex((photoProfile: camera.Profile) => {
      return photoProfile.size.width === this.photoProfileObj.size.width &&
        photoProfile.size.height === this.photoProfileObj.size.height &&
        photoProfile.format === this.photoProfileObj.format;
    })
    if (index === -1) {
      return undefined;
    }
    return photoProfiles[index];
  }

  getVideoProfile(preConfigType: camera.PreconfigType, configRatio: number): void {
    if (this.curSceneMode != camera.SceneMode.NORMAL_VIDEO) {
      return;
    }
    let configRatioMappingSelected: Map<number, [number, number]> |null= null;
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
      // 处理未找到映射的情况
    }

    Logger.error(TAG,
      `1111 this.reconfigWidth = ${this.videoWidth}, this.reconfigHeight ${this.videoHeight}, this.mConfigRatio = ${configRatio}, this.PreconfigType = ${preConfigType}`);
  }

  isSupportedSceneMode(cameraManager: camera.CameraManager, cameraDevice: camera.CameraDevice): boolean {
    let sceneModes = cameraManager.getSupportedSceneModes(cameraDevice);
    if (sceneModes === undefined) {
      return false;
    }
    let index = sceneModes.findIndex((sceneMode: camera.SceneMode) => {
      return sceneMode === this.curSceneMode;
    })
    if (index === -1) {
      return false;
    }
    return true;
  }

  selectCameraDevice(cameras: Array<camera.CameraDevice>,
    cameraPosition: camera.CameraPosition): camera.CameraDevice | undefined {
    let deviceIndex = cameras.findIndex((cameraDevice: camera.CameraDevice) => {
      return cameraPosition == cameraDevice.cameraPosition;
    })
    if (deviceIndex === -1) {
      Logger.error(TAG, 'No supported camera device found.');
      return undefined;
    }
    return cameras[deviceIndex];
  }

  /**
   * Initializing the Camera Function
   * @param surfaceId - the Surface ID
   * @param cameraPosition - Camera Device Position
   * @returns.
   */
  async initCamera(surfaceId: string, cameraPosition: camera.CameraPosition, preconfigType: camera.PreconfigType,
    configRatio: number): Promise<void> {
    Logger.info(TAG, `initCamera PreconfigType: ${preconfigType}, configRatio: ${configRatio}`);
    if (preconfigType == camera.PreconfigType.PRECONFIG_HIGH_QUALITY) {
      this.isHdr = true;
    } else {
      this.isHdr = false;
    }
    this.getVideoProfile(preconfigType, configRatio);
    try {
      await this.releaseCamera();
      if (this.cameraManager === undefined) {
        Logger.error(TAG, 'cameraManager is undefined');
        return;
      }

      Logger.info(TAG, `test deviceInfo.osFullName: ${deviceInfo.osFullName}`);
      Logger.info(TAG, `test deviceInfo.featureVersion: ${deviceInfo.featureVersion}`);
      Logger.info(TAG, `test deviceInfo.buildVersion: ${deviceInfo.buildVersion}`);
      // Obtains the object that supports the specified camera device.
      this.cameras = this.getSupportedCamerasFn(this.cameraManager);
      if (this.cameras.length < 1) {
        return;
      }
      let cameraDevice = this.selectCameraDevice(this.cameras, cameraPosition);
      if (!cameraDevice) {
        return;
      }
      let isSupported = this.isSupportedSceneMode(this.cameraManager, cameraDevice);
      if (!isSupported) {
        Logger.error(TAG, 'The current scene mode is not supported.');
        return;
      }
      let isSameDevice = cameraDevice.cameraId === this.curCameraDevice?.cameraId;
      this.curCameraDevice = cameraDevice;
      // Creates a previewOutput output object.
      this.previewOutput = this.createPreviewOutputFn(this.cameraManager, surfaceId);

      Logger.info(TAG, `previewOutput hash 222 test: ` + util.getHash(this.previewOutput));
      if (this.previewOutput === undefined) {
        Logger.error(TAG, 'Failed to create the preview stream.');
        return;
      }
      // Listening to Preview Events
      this.previewOutputCallBack(this.previewOutput);

      if (this.curSceneMode === camera.SceneMode.NORMAL_PHOTO) {
        // Creating a photoOutput Output Object
        this.photoOutput = this.createPhotoOutputFn(this.cameraManager);
        if (this.photoOutput === undefined) {
          Logger.error(TAG, 'Failed to create the photo stream.');
          return;
        }
      }
      if (this.curSceneMode === camera.SceneMode.NORMAL_VIDEO) {
        this.avRecorder = await this.createAVRecorder();
        if (this.avRecorder === undefined) {
          Logger.error(TAG, 'Failed to create the avRecorder.');
          return;
        }
        await this.prepareAVRecorder();
        AppStorage.setOrCreate<boolean>('isFirstRecording', true);
        let videoSurfaceId = await this.avRecorder.getInputSurface();
        // Creating a videoOutput Output Object
        this.videoOutput = this.createVideoOutputFn(this.cameraManager, videoSurfaceId);
        if (this.videoOutput === undefined) {
          Logger.error(TAG, 'Failed to create the video stream.');
          return;
        }
      }

      if (!isSameDevice || !this.cameraInput) {
        await this.releaseCameraInput();
        // Creates a cameraInput output object.
        this.cameraInput = this.createCameraInputFn(this.cameraManager, this.curCameraDevice);
        if (this.cameraInput === undefined) {
          Logger.error(TAG, 'Failed to create the camera input.');
          return;
        }
        // Open Camera
        let isOpenSuccess = await this.cameraInputOpenFn(this.cameraInput);
        if (!isOpenSuccess) {
          Logger.error(TAG, 'Failed to open the camera.');
          return;
        }
      }
      await this.sessionFlowFn(this.cameraManager, this.cameraInput, this.previewOutput
        , this.photoOutput,
        this.videoOutput, preconfigType, configRatio);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `initCamera fail: ${JSON.stringify(err)}`);
    }
  }

  /**
   * Obtains the supported zoom range.
   */
  getZoomRatioRange(): Array<number> {
    let zoomRatioRange: number[] = [];
    if (this.session !== undefined) {
      zoomRatioRange = this.session.getZoomRatioRange();
    }
    return zoomRatioRange;
  }

  /**
   * Set Zoom
   */
  setZoomRatioFn(zoomRatio: number): void {
    Logger.info(TAG, `setZoomRatioFn value ${zoomRatio}`);
    // Obtains the supported zoom range.
    try {
      let zoomRatioRange = this.getZoomRatioRange();
      Logger.info(TAG, `getZoomRatioRange success: ${JSON.stringify(zoomRatioRange)}`);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `getZoomRatioRange fail: ${JSON.stringify(err)}`);
    }

    try {
      this.session?.setZoomRatio(zoomRatio);
      Logger.info(TAG, 'setZoomRatioFn success');
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `setZoomRatioFn fail: ${JSON.stringify(err)}`);
    }
  }

  /**
   * Take a photo
   */
  async takePicture(): Promise<void> {
    Logger.info(TAG, 'takePicture start');
    let curCameraPosition = GlobalContext.get().getT<camera.CameraPosition>('curCameraPosition');
    let photoSettings: camera.PhotoCaptureSetting = {
      quality: camera.QualityLevel.QUALITY_LEVEL_HIGH,
      mirror: this.photoOutput?.isMirrorSupported()
    };
    let cameraDevice = this.selectCameraDevice(this.cameras, curCameraPosition);
    Logger.info(TAG, `takePicture curCameraPosition = ${cameraDevice?.cameraPosition}`);
    if (!cameraDevice) {
      return;
    }
    this.getDeviceDegree = await this.getGravity();
    this.photoRotation = getPhotoRotation(this.photoOutput!!, this.getDeviceDegree)
    photoSettings.rotation = this.photoRotation
    await this.photoOutput?.capture(photoSettings);

  }

  /**
   * Releasing a Session and Related Listening Events
   */
  async releaseCamera(): Promise<void> {
    Logger.info(TAG, 'releaseCamera is called');
    await this.releaseCameraWithOutCameraInput();
    await this.releaseCameraInput();
    Logger.info(TAG, 'releaseCamera success');
    this.photoProfileObj = {
      format: 2000,
      size: {
        width: 1920,
        height: 1080
      }
    };
    // One of the recommended preview resolutions
    this.previewProfileObj = {
      format: 1003,
      size: {
        width: 1920,
        height: 1080
      }
    };
    // One of the recommended recording resolutions
    this.videoProfileObj = {
      format: 1003,
      size: {
        width: 1920,
        height: 1080
      },
      frameRateRange: {
        min: 30,
        max: 60
      }
    };
  }

  async releaseCameraInput(): Promise<void> {
    try {
      await this.cameraInput?.close();
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `cameraInput close fail: error: ${JSON.stringify(err)}`);
    } finally {
      this.cameraInput = undefined;
    }
    this.offCameraStatusChange();
  }

  /**
   * Releasing a Session and Related Listening Events
   */
  async releaseCameraWithOutCameraInput(): Promise<void> {
    Logger.info(TAG, 'releaseCameraWithOutCameraInput is called');

    if (this.cameraInput) {
      try {
        this.session?.beginConfig();
        this.session?.removeInput(this.cameraInput);
      } catch (error) {
        let err = error as BusinessError;
        Logger.error(TAG, `session removeInput fail: error: ${JSON.stringify(err)}`);
      }
    }

    Logger.info(TAG, 'releaseCameraWithOutCameraInput is 333');
    try {
      await this.previewOutput?.release();
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `previewOutput release fail: error: ${JSON.stringify(err)}`);
    } finally {
      this.previewOutput = undefined;
    }
    try {
      await this.photoOutput?.release();
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `photoOutput release fail: error: ${JSON.stringify(err)}`);
    } finally {
      this.photoOutput = undefined;
    }
    try {
      await this.avRecorder?.release();
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `avRecorder release fail: error: ${JSON.stringify(err)}`);
    } finally {
      this.avRecorder = undefined;
      this.deleteVideoFile();
    }

    try {
      await this.videoOutput?.release();
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `videoOutput release fail: error: ${JSON.stringify(err)}`);
    } finally {
      this.videoOutput = undefined;
    }
    try {
      await this.imageReceiver?.release();
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `imageReceiver release fail: error: ${JSON.stringify(err)}`);
    } finally {
      this.imageReceiver = undefined;
    }
    try {
      await this.session?.release();
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `captureSession release fail: error: ${JSON.stringify(err)}`);
    } finally {
      this.session = undefined;
    }
    this.offCameraStatusChange();
    this.offFoldStatusChange();
    Logger.info(TAG, 'releaseCamera success');
  }

  /**
   * Get Camera Manager instance
   */
  getCameraManagerFn(): camera.CameraManager {
    return this.cameraManager;
  }

  /**
   * Obtains the object that supports the specified camera device.
   */
  getSupportedCamerasFn(cameraManager: camera.CameraManager): Array<camera.CameraDevice> {
    let supportedCameras: camera.CameraDevice[] = [];
    try {
      supportedCameras = cameraManager.getSupportedCameras();
      for (let i = 0; i < supportedCameras.length; i++) {
        Logger.info(TAG,
          `getSupportedCameras camera[${i}]: ${supportedCameras[i].cameraId},cameraPosition: ${supportedCameras[i].cameraPosition}, cameraOrientation: ${supportedCameras[i].cameraOrientation},cameraType: ${supportedCameras[i].cameraType}`);
      }
      Logger.info(TAG, `getSupportedCameras success: ${supportedCameras}, length: ${supportedCameras.length}`);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `getSupportedCameras failed: ${JSON.stringify(err)}`);
    }
    return supportedCameras;
  }

  /**
   * Creates a previewOutput output object.
   */
  createPreviewOutputFn(cameraManager: camera.CameraManager, surfaceId: string,
    previewProfileObj?: camera.Profile): camera.PreviewOutput | undefined {
    let previewOutput: camera.PreviewOutput | undefined = undefined;
    try {
      if (previewProfileObj) {
        previewOutput = cameraManager.createPreviewOutput(previewProfileObj, surfaceId);
      } else {
        previewOutput = cameraManager.createPreviewOutput(surfaceId);
      }
      Logger.info(TAG, `createPreviewOutput success: ${previewOutput}`);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `createPreviewOutput failed: ${JSON.stringify(err)}`);
    }
    return previewOutput;
  }

  /**
   * Creating a photoOutput Object
   */
  createPhotoOutputFn(cameraManager: camera.CameraManager,
    photoProfileObj?: camera.Profile): camera.PhotoOutput | undefined {
    let photoOutput: camera.PhotoOutput | undefined = undefined;
    try {
      if (photoProfileObj) {
        photoOutput = cameraManager.createPhotoOutput(photoProfileObj);
      } else {
        photoOutput = cameraManager.createPhotoOutput();
      }
      Logger.info(TAG, `createPhotoOutputFn success: ${photoOutput}`);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `createPhotoOutputFn failed: ${JSON.stringify(err)}`);
    }
    return photoOutput;
  }

  /**
   * Creating a videoOutput Object
   */
  createVideoOutputFn(cameraManager: camera.CameraManager, surfaceId: string,
    videoProfileObj?: camera.VideoProfile): camera.VideoOutput | undefined {
    let videoOutput: camera.VideoOutput | undefined = undefined;
    try {
      if (videoProfileObj) {
        videoOutput = cameraManager.createVideoOutput(videoProfileObj, surfaceId);
      } else {
        videoOutput = cameraManager.createVideoOutput(surfaceId);
      }
      Logger.info(TAG, `createVideoOutputFn success: ` + util.getHash(videoOutput));
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `createVideoOutputFn failed: ${JSON.stringify(err)}`);
    }
    return videoOutput;
  }

  /**
   * Creates a cameraInput output object.
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
      Logger.error(TAG, `createCameraInputFn failed: ${JSON.stringify(err)}`);
    }
    return cameraInput;
  }

  /**
   * Creates a cameraInput output object.
   */
  createCameraInputWithPosition(cameraManager: camera.CameraManager,
    cameraPosition: camera.CameraPosition, cameraType: camera.CameraType): camera.CameraInput | undefined {
    Logger.info(TAG, 'createCameraInputFn is called. cameraPosition: ' + cameraPosition);
    let cameraInput: camera.CameraInput | undefined = undefined;
    try {
      cameraInput = cameraManager.createCameraInput(cameraPosition, cameraType);
      Logger.info(TAG, 'createCameraInputFn success');
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `createCameraInputFn failed: ${JSON.stringify(err)}`);
    }
    return cameraInput;
  }

  /**
   * Open Camera
   */
  async cameraInputOpenFn(cameraInput: camera.CameraInput): Promise<boolean> {
    let isOpenSuccess = false;
    try {
      await cameraInput.open();
      isOpenSuccess = true;
      Logger.info(TAG, 'cameraInput open success');
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `cameraInputOpenFn failed : ${JSON.stringify(err)}`);
    }
    return isOpenSuccess;
  }

  /**
   * Session Process
   */
  async sessionFlowFn(cameraManager: camera.CameraManager, cameraInput: camera.CameraInput,
    previewOutput: camera.PreviewOutput,
    photoOutput: camera.PhotoOutput | undefined,
    videoOutput: camera.VideoOutput | undefined,
    preconfigType: camera.PreconfigType,
    configRatio?: number): Promise<void> {
    Logger.info(TAG, `sessionFlowFn enter`);
    try {
      // Creating a CaptureSession Instance
      if (this.curSceneMode === camera.SceneMode.NORMAL_PHOTO) {
        this.session = cameraManager.createSession(this.curSceneMode) as camera.PhotoSession;
      }
      if (this.curSceneMode === camera.SceneMode.NORMAL_VIDEO) {
        this.session = cameraManager.createSession(this.curSceneMode) as camera.VideoSession;
        Logger.info(TAG, `sessionFlowFn createSession`);

      }
      if (this.session === undefined) {
        return;
      }
      this.setSessionCallback(this.session);
      Logger.info(TAG, `sessionFlowFn setSessionCallback`);
      let isPreconfigSupport = false;
      let preConfigRatio: camera.PreconfigRatio = camera.PreconfigRatio.PRECONFIG_RATIO_16_9;
      if (configRatio == 1) {
        preConfigRatio = camera.PreconfigRatio.PRECONFIG_RATIO_1_1;
      } else if (configRatio == 4 / 3) {
        preConfigRatio = camera.PreconfigRatio.PRECONFIG_RATIO_4_3;
      }
      try {
        isPreconfigSupport = this.session.canPreconfig(preconfigType, preConfigRatio);
        if (!isPreconfigSupport) {
          console.error('PhotoSession canPreconfig check fail.');
          return;
        }
      } catch (error) {
        let err = error as BusinessError;
        console.error('Failed to call canPreconfig. errorCode = ' + err.code);
        return;
      }
      if (isPreconfigSupport) {
        try {
          this.session.preconfig(preconfigType, preConfigRatio);
        } catch (error) {
          let err = error as BusinessError;
          console.error('Failed to call preconfig. errorCode = ' + err.code);
          return;
        }
      }

      // Start Configuration Session
      this.session.beginConfig();
      // Add CameraInput to the session.
      Logger.info(TAG, `sessionFlowFn addInput`);
      this.session.addInput(cameraInput);
      Logger.info(TAG, `sessionFlowFn previewOutput`);
      // Add previewOutput to the session.
      this.session.addOutput(previewOutput);
      Logger.info(TAG, `sessionFlowFn previewOutputReceiver`);
      if (this.curSceneMode === camera.SceneMode.NORMAL_PHOTO) {
        if (photoOutput === undefined) {
          return;
        }
        // Photographing Listening Event
        this.photoOutputCallBack(photoOutput);
        // Add photoOutput to a session
        this.session.addOutput(photoOutput);
      }
      if (this.curSceneMode === camera.SceneMode.NORMAL_VIDEO) {
        if (videoOutput === undefined) {
          return;
        }
        // Add videoOutput to a session
        Logger.info(TAG, `sessionFlowFn videoOutput`);
        this.session.addOutput(videoOutput);
        this.videoOutputCallback(videoOutput);
      }
      // Submitting Configuration Information
      await this.session.commitConfig();
      try {
        let displayRotation = display.getDefaultDisplaySync().rotation; // 12 90  14 180 平板/手机/PC sdk版本 白名单
        let imageRotation = displayRotation * camera.ImageRotation.ROTATION_90;
        if (previewOutput == undefined) {
          return;
        }
        let previewRotation = previewOutput.getPreviewRotation(imageRotation); // buffer转度数

        Logger.info(TAG, `previewOutput hash 111 test: ` + display.getDefaultDisplaySync().orientation);
        previewOutput.setPreviewRotation(previewRotation, false);
        let initDisplayRotation = display.getDefaultDisplaySync().rotation;
        let initPreviewRotation =
          previewOutput.getPreviewRotation(initDisplayRotation * camera.ImageRotation.ROTATION_90);
        previewOutput.setPreviewRotation(initPreviewRotation, false);
      } catch (error) {
        // 失败返回错误码error.code并处理
        let err = error as BusinessError;
        console.error(`The previewOutput.getPreviewRotation call failed. error code: ${err.code}`);
      }
      this.getDeviceDegree = await this.getGravity();
      this.photoRotation = getPhotoRotation(photoOutput!!, this.getDeviceDegree)
      if (this.curSceneMode === camera.SceneMode.NORMAL_VIDEO) {
        this.setVideoStabilizationFn(this.session as camera.VideoSession, camera.VideoStabilizationMode.MIDDLE);
      }
      await this.session.start();
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `sessionFlowFn fail : ${JSON.stringify(err)}`);
    }
  }

  updateRotateForCamera(imageRotation: camera.ImageRotation) {
    if (this.previewOutput === undefined) {
      return;
    }
    let previewRotation = this.previewOutput.getPreviewRotation(imageRotation);
    // 调用getPreviewRotation使用屏幕显示旋转角度作为入参，返回值为previewRotation
    Logger.info(TAG, `GetPreviewRotation : imageRotation ${imageRotation}`);
    this.previewOutput.setPreviewRotation(previewRotation, false);
    Logger.info(TAG, `GetPreviewRotation : end ${previewRotation}`);
  }

  setVideoStabilizationFn(session: camera.VideoSession, videoStabilizationMode: camera.VideoStabilizationMode): void {
    // Queries whether the specified video stabilization mode is supported.
    let isVideoStabilizationModeSupported: boolean = session.isVideoStabilizationModeSupported(videoStabilizationMode);
    if (isVideoStabilizationModeSupported) {
      session.setVideoStabilizationMode(videoStabilizationMode);
    }
    Logger.info(TAG, 'setVideoStabilizationFn success');
  }

  videoOutputCallback(videoOutput: camera.VideoOutput) {
    videoOutput.on('frameStart', (err: BusinessError) => {
      Logger.info(TAG, 'videoOutputCallback frameStart success');
    })
    videoOutput.on('frameEnd', (err: BusinessError) => {
      Logger.info(TAG, 'videoOutputCallback frameEnd success');
    })
    videoOutput.on('error', (err: BusinessError) => {
      Logger.info(TAG, 'videoOutputCallback error success');
    })
  }

  /**
   * Listening to a Photographing Event
   */
  photoOutputCallBack(photoOutput: camera.PhotoOutput): void {
    try {
      // Monitoring and photographing start
      photoOutput.on('captureStartWithInfo', (err: BusinessError, captureStartInfo: camera.CaptureStartInfo): void => {
        Logger.info(TAG, `photoOutputCallBack captureStartWithInfo err: ${err}`);
        Logger.info(TAG, `photoOutputCallBack captureStartWithInfo success: ${JSON.stringify(captureStartInfo)}`);
      });
      // Monitors the output capture of photographing frames.
      photoOutput.on('frameShutter', (err: BusinessError, frameShutterInfo: camera.FrameShutterInfo): void => {
        Logger.info(TAG, `photoOutputCallBack frameShutter err: ${err}`);
        Logger.info(TAG,
          `photoOutputCallBack frameShutter captureId: ${frameShutterInfo.captureId}, timestamp: ${frameShutterInfo.timestamp}`);
      });
      // Monitoring and photographing end
      photoOutput.on('captureEnd', (err: BusinessError, captureEndInfo: camera.CaptureEndInfo): void => {
        Logger.info(TAG, `photoOutputCallBack captureEnd err: ${err}`);
        Logger.info(TAG,
          `photoOutputCallBack captureEnd captureId: ${captureEndInfo.captureId}, frameCount: ${captureEndInfo.frameCount}`);
      });
      // Monitoring and photographing exception
      photoOutput.on('error', (data: BusinessError): void => {
        Logger.info(TAG, `photoOutPut data: ${data}`);
      });
      if (!this.is2in1()) {
        photoOutput.on('photoAssetAvailable', (err: BusinessError, photoAsset: photoAccessHelper.PhotoAsset) => {
          Logger.info(TAG, 'photoAssetAvailable begin');
          if (photoAsset === undefined) {
            Logger.error(TAG, 'photoAsset is undefined');
            return;
          }
          this.handlePhotoAssetCb(photoAsset);
        });
      } else {
        photoOutput.on('photoAvailable', (errCode: BusinessError, photo: camera.Photo): void => {
          Logger.info(TAG, 'photoAvailable start');
          if (errCode || photo === undefined) {
            Logger.error(TAG, 'getPhoto failed');
            return;
          }
          let imageObj = photo.main;
          imageObj.getComponent(image.ComponentType.JPEG,
            (errCode: BusinessError, component: image.Component): void => {
              Logger.info(TAG, 'getComponent start');
              if (errCode || component === undefined) {
                Logger.error(TAG, 'getComponent failed');
                return;
              }
              let buffer: ArrayBuffer;
              if (component.byteBuffer) {
                buffer = component.byteBuffer;
              } else {
                Logger.error(TAG, 'byteBuffer is null');
                imageObj.release();
                return;
              }
              this.handlePhotoAvailableCb(buffer);
              imageObj.release();
            });
        });
      }

    } catch (err) {
      Logger.error(TAG, 'photoOutputCallBack error');
    }
  }

  /**
   * Listening to Preview Events
   */
  previewOutputCallBack(previewOutput: camera.PreviewOutput): void {
    Logger.info(TAG, 'previewOutputCallBack is called');
    try {
      previewOutput.on('frameStart', (err: BusinessError): void => {
        if (err !== undefined && err.code !== 0) {
          return;
        }
        this.frameStartCallback();
        Logger.debug(TAG, 'Preview frame started');
      });

      previewOutput.on('frameEnd', (err: BusinessError): void => {
        if (err !== undefined && err.code !== 0) {
          return;
        }
        Logger.debug(TAG, 'Preview frame ended');
      });
      previewOutput.on('error', (previewOutputError: BusinessError): void => {
        Logger.info(TAG, `Preview output previewOutputError: ${previewOutputError}`);
      });
    } catch (err) {
      Logger.error(TAG, 'previewOutputCallBack error');
    }
  }

  /**
   * Registers the callback function for camera status changes.
   * @param err
   * @param cameraStatusInfo
   * @returns
   */
  registerCameraStatusChange(err: BusinessError, cameraStatusInfo: camera.CameraStatusInfo) {
    Logger.info(TAG, `registerCameraStatusChange error: ${err}`);
    Logger.info(TAG, `cameraId: ${cameraStatusInfo.camera.cameraId},status: ${cameraStatusInfo.status}`);
  }

  registerFoldStatusChanged(err: BusinessError, foldStatusInfo: camera.FoldStatusInfo) {
    Logger.info(TAG, 'foldStatusChanged foldStatus: ' + foldStatusInfo.foldStatus);
    for (let i = 0; i < foldStatusInfo.supportedCameras.length; i++) {
      Logger.info(TAG,
        `foldStatusChanged camera[${i}]: ${foldStatusInfo.supportedCameras[i].cameraId},cameraPosition: ${foldStatusInfo.supportedCameras[i].cameraPosition}`);
    }
    let cameraDevice = this.getCurCameraDevice();
    if (!cameraDevice) {
      Logger.error(TAG, 'foldStatusChanged cameraDevice is undefined');
      return;
    }
    if (cameraDevice.cameraPosition == camera.CameraPosition.CAMERA_POSITION_BACK) {
      Logger.error(TAG,
        'foldStatusChanged cameraDevice connectionType CAMERA_CONNECTION_BUILT_IN and cameraPosition CAMERA_POSITION_BACK');
      return;
    }
    let deviceIndex = -1;
    if (foldStatusInfo.foldStatus === camera.FoldStatus.EXPANDED ||
      foldStatusInfo.foldStatus === camera.FoldStatus.FOLDED) {
      deviceIndex = foldStatusInfo.supportedCameras.findIndex((cameraDevice: camera.CameraDevice) => {
        return camera.CameraPosition.CAMERA_POSITION_FRONT === cameraDevice.cameraPosition;
      })
    }
    if (deviceIndex === -1) {
      Logger.error(TAG, 'No supported camera device found.');
      return;
    }
    AppStorage.setOrCreate<number>(';', foldStatusInfo.foldStatus);
  }

  onDisplayFoldStatusChange(foldStatus: display.FoldStatus): void {
    Logger.error(TAG, `onDisplayFoldStatusChange foldStatus: ${foldStatus}`);
    if ((this.preFoldStatus === display.FoldStatus.FOLD_STATUS_HALF_FOLDED &&
      foldStatus === display.FoldStatus.FOLD_STATUS_EXPANDED) ||
      (this.preFoldStatus === display.FoldStatus.FOLD_STATUS_EXPANDED &&
        foldStatus === display.FoldStatus.FOLD_STATUS_HALF_FOLDED)) {
      this.preFoldStatus = foldStatus;
      return;
    }
    this.preFoldStatus = foldStatus;
    // 获取当前打开的相机镜头，如果是后置，折叠状态不影响当前镜头的使用
    let cameraDevice = this.getCurCameraDevice();
    if (!cameraDevice) {
      return;
    }
    if (cameraDevice.cameraPosition == camera.CameraPosition.CAMERA_POSITION_BACK) {
      return;
    }
    let supportedCameras = this.getSupportedCamerasFn(this.cameraManager);
    // 如果是前置，则需要切换镜头
    let deviceIndex = supportedCameras.findIndex((cameraDevice: camera.CameraDevice) => {
      return camera.CameraPosition.CAMERA_POSITION_FRONT === cameraDevice.cameraPosition;
    })
    if (deviceIndex === -1) {
      return;
    }
    // foldStatus 变量用来控制显示XComponent组件
    AppStorage.setOrCreate<number>('foldStatus', foldStatus);
  }

  /**
   * Monitor camera status changes.
   * @param cameraManager
   * @returns
   */
  onCameraStatusChange(cameraManager: camera.CameraManager): void {
    Logger.info(TAG, 'onCameraStatusChange is called');
    cameraManager.on('cameraStatus', this.registerCameraStatusChange);
  }

  /**
   * Monitor fold status changes.
   * @param cameraManager
   * @returns
   */
  onFoldStatusChange(cameraManager: camera.CameraManager): void {
    Logger.info(TAG, 'onFoldStatusChange is called');
    cameraManager.on('foldStatusChange', this.foldStatusCallback);
  }

  /**
   * Stops monitoring camera status changes.
   * @returns
   */
  offCameraStatusChange(): void {
    Logger.info(TAG, 'offCameraStatusChange is called');
    this.cameraManager?.off('cameraStatus', this.registerCameraStatusChange);
  }

  /**
   * Stops monitoring fold status changes.
   * @returns
   */
  offFoldStatusChange(): void {
    Logger.info(TAG, 'offFoldStatusChange is called');
    this.cameraManager?.off('foldStatusChange', this.foldStatusCallback);
  }

  /**
   * Listen for camera input changes
   * @param cameraInput
   * @param cameraDevice
   * @returns
   */
  onCameraInputChange(cameraInput: camera.CameraInput, cameraDevice: camera.CameraDevice): void {
    Logger.info(TAG, `onCameraInputChange is called`);
    try {
      cameraInput.on('error', cameraDevice, (cameraInputError: BusinessError): void => {
        Logger.info(TAG, `onCameraInputChange cameraInput error code: ${cameraInputError.code}`);
        if (cameraInputError.code === camera.CameraErrorCode.SERVICE_FATAL_ERROR) {
          // SERVICE_FATAL_ERROR indicates that the camera service is dead.
          // You can restart the app or display a pop-up message.
          (getContext() as common.UIAbilityContext).terminateSelf();
        }
      });
    } catch (error) {
      Logger.error(TAG, 'onCameraInputChange error');
    }
  }

  /**
   * Monitoring session capture error changes
   * @param session
   * @returns
   */
  setSessionCallback(session: camera.PhotoSession | camera.VideoSession): void {
    try {
      session.on('error', (captureSessionError: BusinessError): void => {
        Logger.info(TAG,
          `onCaptureSessionErrorChange captureSession fail: ${captureSessionError.code}`);
      });
    } catch (error) {
      Logger.error(TAG, 'onCaptureSessionErrorChange error');
    }
  }

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
    let filesDir = getContext().filesDir;
    let fileName = `${Date.now()}.mp4`;
    AppStorage.setOrCreate<string>('fileName', fileName);
    let filePath = filesDir + `/${fileName}`;
    let file: fileIo.File = fileIo.openSync(filePath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
    Logger.info(TAG, `filePath =  ${filePath}`);
    return file.fd;
  }

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
        videoCodec: media.CodecMimeType.VIDEO_HEVC,
        videoFrameWidth: this.videoWidth,
        videoFrameHeight: this.videoHeight,
        videoFrameRate: 30,
        isHdr: this.isHdr
      },
      url: `fd://${fd.toString()}`,
      rotation: this.curCameraDevice?.cameraOrientation
    };
    this.getDeviceDegree = await this.getGravity();
    videoConfig.rotation = getVideoRotation(this.videoOutput!!, this.getDeviceDegree);
    Logger.info(TAG, `prepareAVRecorder videoConfig:${videoConfig.rotation}`);
    await this.avRecorder?.prepare(videoConfig).catch((err: BusinessError): void => {
      Logger.error(TAG, `prepareAVRecorder prepare err: ${JSON.stringify(err)}`);
    });
  }

  /**
   * Start Recording
   */
  async startVideo(): Promise<void> {
    Logger.info(TAG, 'startVideo is called');
    let isFirstRecording = AppStorage.get<boolean>('isFirstRecording');
    Logger.info(TAG, `startVideo isFirstRecording ${isFirstRecording}`);
    if (isFirstRecording) {
      this.getDeviceDegree = await this.getGravity();
      this.avRecorder?.updateRotation(getVideoRotation(this.videoOutput!!, this.getDeviceDegree));
    } else {
      await this.prepareAVRecorder();
      this.avRecorder?.getInputSurface();
    }
    try {
      await this.videoOutput?.start();
      await this.avRecorder?.start();
      this.isRecording = true;
      AppStorage.set<boolean>('isRecording', this.isRecording);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `startVideo err: ${JSON.stringify(err)}`);
    }
    AppStorage.set<boolean>('isFirstRecording', false);
    isFirstRecording = AppStorage.get<boolean>('isFirstRecording');
    Logger.info(TAG, 'startVideo End of call');
  }

  /**
   * Stop Recording
   */
  async stopVideo(): Promise<void> {
    Logger.info(TAG, 'stopVideo is called');
    if (!this.isRecording) {
      Logger.info(TAG, 'not in recording');
      return;
    }
    try {
      await this.avRecorder?.stop();
      await this.videoOutput?.stop();
      this.isRecording = false;
      AppStorage.set<boolean>('isRecording', this.isRecording);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `stopVideo err: ${JSON.stringify(err)}`);
    }
    Logger.info(TAG, 'stopVideo End of call');
  }

  getIsRecording(): boolean {
    return this.isRecording;
  }

  deleteVideoFile(): void {
    let fileName = AppStorage.get<string>('fileName');
    if (fileName === undefined) {
      return;
    }
    Logger.info(TAG, `filePath: ${fileName}`)
    Logger.info(TAG, `filesDir: ${getContext().filesDir}`)
    try {
      let filePath = `${getContext().filesDir}/${fileName}`;
      fileIo.unlinkSync(filePath);
    } catch (err) {
      Logger.error(TAG, `deleteVideoFile failed, error code: ${err.code}`)
    }
  }

  generateSnapshotImg(): undefined | image.PixelMap {
    let surfaceId = GlobalContext.get().getT<string>('xComponentSurfaceId');
    try {
      Logger.info(TAG, 'createPixelMapFromSurface start');
      let screenshotPixelMap: image.PixelMap = image.createPixelMapFromSurfaceSync(surfaceId, {
        size: { height: this.previewProfileObj?.size.height, width: this.previewProfileObj?.size.width },
        x: 0,
        y: 0
      });
      Logger.info(TAG, 'createPixelMapFromSurface end');
      if (this.curCameraDevice?.cameraPosition === camera.CameraPosition.CAMERA_POSITION_BACK) {
        screenshotPixelMap.rotateSync(90);
      } else {
        screenshotPixelMap.rotateSync(270);
      }
      return screenshotPixelMap;
    } catch (err) {
      Logger.info(TAG, `createPixelMapFromSurface err. ${JSON.stringify(err)}.`);
      return undefined;
    }
  }

  setFrameStartCallback(callback: () => void) {
    this.frameStartCallback = callback;
  }
}

function getVideoRotation(videoOutput: camera.VideoOutput, deviceDegree: number): camera.ImageRotation {
  let videoRotation: camera.ImageRotation = camera.ImageRotation.ROTATION_0;
  try {
    videoRotation = videoOutput.getVideoRotation(deviceDegree);
    console.log(`Video rotation is: ${videoRotation}`);
  } catch (error) {
    // 失败返回错误码error.code并处理
    let err = error as BusinessError;
    console.error(`The videoOutput.getVideoRotation call failed. error code: ${err.code}`);
  }
  return videoRotation;
}


export default CameraService.getInstance();