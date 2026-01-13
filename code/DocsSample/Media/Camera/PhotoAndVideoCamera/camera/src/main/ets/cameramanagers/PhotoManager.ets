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

import { camera } from '@kit.CameraKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { sensor } from '@kit.SensorServiceKit';
import { Decimal } from '@kit.ArkTS';
import { image } from '@kit.ImageKit';
import { colorSpaceManager } from '@kit.ArkGraphics2D';
import { geoLocationManager } from '@kit.LocationKit';
import { Logger } from 'commons';
import OutputManager, { CreateOutputConfig, OutputType } from './OutputManager';
import CameraConstant from '../constants/CameraConstants';

const TAG_LOG = 'PhotoManager';

export class PhotoManager implements OutputManager {
  type: OutputType = OutputType.PHOTO;
  output?: camera.PhotoOutput;
  isActive: boolean = true;
  context: Context;
  isSingle: boolean = false;
  isHdr: boolean = false;
  location: geoLocationManager.Location | null = null;
  private callback: (pixelMap: image.PixelMap, url: string) => void = () => {
  };

  constructor(context: Context, isActive = true, isSingle: boolean) {
    this.context = context;
    this.isActive = isActive;
    this.isSingle = isSingle;

  }

  setIsActive(isActive: boolean) {
    this.isActive = isActive;
  }

  setCallback(callback: (pixelMap: image.PixelMap, url: string) => void) {
    this.callback = callback;
  }

  async createOutput(config: CreateOutputConfig) {
    let cameraPhotoOutput: camera.PhotoOutput | undefined = undefined;
    cameraPhotoOutput = this.createPhotoOutput(config.cameraManager, config.device, config.profile);
    if (cameraPhotoOutput) {
      this.output = cameraPhotoOutput;
      this.setPhotoOutputCallback(this.isSingle);
    }
    return cameraPhotoOutput;
  }

  // [Start create_photo_output]
  public createPhotoOutput(cameraManager: camera.CameraManager, cameraDevice: camera.CameraDevice,
    profile: camera.Profile) {
    let cameraPhotoOutput: camera.PhotoOutput | undefined = undefined;
    const cameraOutputCapability =
      cameraManager.getSupportedOutputCapability(cameraDevice, camera.SceneMode.NORMAL_PHOTO);
    let photoProfilesArray: camera.Profile[] | undefined = cameraOutputCapability?.photoProfiles;
    if (photoProfilesArray?.length) {
      try {
        const displayRatio = profile.size.width / profile.size.height;
        const profileWidth = profile.size.width;
        const PhotoProfile = photoProfilesArray
          .sort((a, b) => Math.abs(a.size.width - profileWidth) - Math.abs(b.size.width - profileWidth))
          .find(pf => {
            const pfDisplayRatio = pf.size.width / pf.size.height;
            return Math.abs(pfDisplayRatio - displayRatio) <= CameraConstant.PROFILE_DIFFERENCE &&
              pf.format === camera.CameraFormat.CAMERA_FORMAT_JPEG;
          });
        if (!PhotoProfile) {
          Logger.error(TAG_LOG, 'Failed to get photo profile');
          return;
        }
        cameraPhotoOutput = cameraManager.createPhotoOutput(PhotoProfile);
      } catch (error) {
        Logger.error(TAG_LOG, `Failed to createPhotoOutput. error: ${JSON.stringify(error)}`);
      }
    }
    this.output = cameraPhotoOutput;
    return cameraPhotoOutput;
  }

  // [End create_photo_output]

  // [Start set_photo_cb_double]
  async mediaLibSavePhoto(photoAsset: photoAccessHelper.PhotoAsset,
    phAccessHelper: photoAccessHelper.PhotoAccessHelper): Promise<void> {
    try {
      let assetChangeRequest: photoAccessHelper.MediaAssetChangeRequest =
        new photoAccessHelper.MediaAssetChangeRequest(photoAsset);
      assetChangeRequest.saveCameraPhoto();
      await phAccessHelper.applyChanges(assetChangeRequest);
      phAccessHelper.release();
    } catch (error) {
      Logger.error(TAG_LOG, `apply saveCameraPhoto failed with error: ${error.code}, ${error.message}`);
    }
  }

  async mediaLibRequestBuffer(photoAsset: photoAccessHelper.PhotoAsset, context: Context,
    callback: (pixelMap: image.PixelMap, url: string) => void) {
    class MediaDataHandler implements photoAccessHelper.MediaAssetDataHandler<ArrayBuffer> {
      onDataPrepared(data: ArrayBuffer) {
        if (data === undefined) {
          Logger.error(TAG_LOG, 'Error occurred when preparing data');
          return;
        }
        let imageSource = image.createImageSource(data);
        imageSource.createPixelMap().then((pixelMap: image.PixelMap) => {
          callback(pixelMap, photoAsset.uri);
        }).catch((err: BusinessError) => {
          Logger.error(TAG_LOG, `createPixelMap err:${err.code}`);
        })
      }
    }

    let requestOptions: photoAccessHelper.RequestOptions = {
      deliveryMode: photoAccessHelper.DeliveryMode.FAST_MODE,
    }
    const handler = new MediaDataHandler();
    await photoAccessHelper.MediaAssetManager.requestImageData(context, photoAsset, requestOptions, handler);
  }

  public setPhotoOutputCbDouble(cameraPhotoOutput: camera.PhotoOutput) {
    cameraPhotoOutput.on('photoAssetAvailable',
      async (_err: BusinessError, photoAsset: photoAccessHelper.PhotoAsset): Promise<void> => {
        let accessHelper: photoAccessHelper.PhotoAccessHelper =
          photoAccessHelper.getPhotoAccessHelper(this.context);
        this.mediaLibSavePhoto(photoAsset, accessHelper);
        this.mediaLibRequestBuffer(photoAsset, this.context, this.callback);
      });
  }

  // [End set_photo_cb_double]

  // [Start set_photo_cb_single]
  setPhotoOutputCbSingle(photoOutput: camera.PhotoOutput, context: Context) {
    photoOutput.on('photoAvailable', (errCode: BusinessError, photo: camera.Photo): void => {
      if (errCode || photo === undefined) {
        Logger.error(TAG_LOG, 'getPhoto failed');
        return;
      }
      this.mediaLibSavePhotoSingle(context, photo.main)
    });
  }
  // [End set_photo_cb_single]

  // [Start save_photo_single]
  mediaLibSavePhotoSingle(context: Context, imageObj: image.Image) {
    imageObj.getComponent(image.ComponentType.JPEG, async (errCode: BusinessError, component: image.Component) => {
      if (errCode || component === undefined) {
        Logger.error(TAG_LOG, 'getComponent failed');
        return;
      }
      const buffer: ArrayBuffer = component.byteBuffer;
      if (!buffer) {
        Logger.error(TAG_LOG, 'byteBuffer is null');
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
      imageObj.release();
    });
  }
  // [End save_photo_single]

  setPhotoOutputCallback(isSingle: boolean) {
    if (!this.output) {
      return;
    }
    if (isSingle) {
      this.output?.off('photoAssetAvailable');
      this.setPhotoOutputCbSingle(this.output, this.context);
    } else {
      this.output?.off('photoAvailable');
      this.setPhotoOutputCbDouble(this.output);
    }
  }

  preparePhoto(session: camera.Session, zoomRatio?: number, flashMode?: camera.FlashMode,
    focusMode?: camera.FocusMode) {
    const photoSession = session as camera.PhotoSession;
    this.setPhotoFlash(photoSession, flashMode);
    this.setPhotoFocus(photoSession, focusMode);
    this.setPhotoZoomRatio(photoSession, zoomRatio || 0);
  }

  // [Start set_color_space]
  setColorSpaceBeforeCommitConfig(session: camera.PhotoSession, isHdr: boolean): void {
    let colorSpace: colorSpaceManager.ColorSpace =
      isHdr ? colorSpaceManager.ColorSpace.DISPLAY_P3 : colorSpaceManager.ColorSpace.SRGB;
    let colorSpaces: Array<colorSpaceManager.ColorSpace> = [];
    try {
      colorSpaces = session.getSupportedColorSpaces();
    } catch (error) {
      Logger.error(TAG_LOG, `The getSupportedColorSpaces call failed. error code: ${error.code}`);
    }
    if (!colorSpaces.includes(colorSpace)) {
      Logger.info(TAG_LOG, `colorSpace: ${colorSpace} is not support`);
      return;
    }
    Logger.info(TAG_LOG, `setColorSpace: ${colorSpace}`);
    session.setColorSpace(colorSpace);
    try {
      let activeColorSpace: colorSpaceManager.ColorSpace = session.getActiveColorSpace();
      Logger.info(TAG_LOG, `activeColorSpace: ${activeColorSpace}`);
    } catch (error) {
      Logger.error(TAG_LOG, `getActiveColorSpace Faild: ${error.message}`);
    }
  }
  // [End set_color_space]

  public checkFlash(photoSession: camera.PhotoSession) {
    let flashModeStatus: boolean = false;
    if (photoSession.hasFlash()) {
      flashModeStatus = photoSession.isFlashModeSupported(camera.FlashMode.FLASH_MODE_AUTO);
    }
    return flashModeStatus;
  }

  public setPhotoFlash(photoSession: camera.PhotoSession, flashMode?: camera.FlashMode) {
    try {
      if (this.checkFlash(photoSession)) {
        photoSession.setFlashMode(flashMode || camera.FlashMode.FLASH_MODE_CLOSE);
      }
    } catch (error) {
      Logger.error(TAG_LOG, `Failed to hasFlash. error: ${JSON.stringify(error)}`);
    }
  }

  public setPhotoFocus(photoSession: camera.PhotoSession, focusMode?: camera.FocusMode) {
    const defaultMode = camera.FocusMode.FOCUS_MODE_CONTINUOUS_AUTO;
    try {
      let focusModeStatus: boolean = photoSession.isFocusModeSupported(focusMode || defaultMode);
      if (focusModeStatus) {
        photoSession.setFocusMode(focusMode || defaultMode);
      }
    } catch (error) {
      Logger.error(TAG_LOG,
        `Failed to check whether the focus mode is supported. error: ${JSON.stringify(error)}`);
    }
  }

  public setFocusPoint(photoSession: camera.PhotoSession, focusPoint: camera.Point): void {
    try {
      photoSession.setFocusPoint(focusPoint);
    } catch (error) {
      Logger.error(TAG_LOG, `The setFocusPoint call failed. error code: ${error.code}`);
    }
  }

  public setPhotoZoomRatio(photoSession: camera.PhotoSession, zoomRatio?: number) {
    let photoZoomRatio = 0;
    if (!zoomRatio) {
      try {
        let zoomRatioRange: number[] = photoSession.getZoomRatioRange();
        if (zoomRatioRange?.length) {
          photoZoomRatio = zoomRatioRange[0];
        }
      } catch (error) {
        Logger.error(TAG_LOG, `Failed to get the zoom ratio range. error: ${JSON.stringify(error)}`);
      }
    }
    photoSession.setZoomRatio(zoomRatio || photoZoomRatio);
  }

  getSupportedColorSpaces(session: camera.PhotoSession): Array<colorSpaceManager.ColorSpace> {
    let colorSpaces: Array<colorSpaceManager.ColorSpace> = [];
    try {
      colorSpaces = session.getSupportedColorSpaces();
    } catch (error) {
      Logger.error(TAG_LOG,`The getSupportedColorSpaces call failed. error code: ${error.code}`);
    }
    return colorSpaces;
  }

  // [Start get_photo_rotation]
  getPhotoRotation(photoOutput: camera.PhotoOutput, deviceDegree: number): camera.ImageRotation {
    let photoRotation: camera.ImageRotation = camera.ImageRotation.ROTATION_0;
    try {
      photoRotation = photoOutput.getPhotoRotation(deviceDegree);
    } catch (error) {
      Logger.error(TAG_LOG, `The photoOutput.getPhotoRotation call failed. error code: ${error.code}`);
    }
    return photoRotation;
  }

  // [End get_photo_rotation]

  // [Start capture_photo]
  public async capture(isFront: boolean) {
    const degree = await this.getPhotoDegree();
    const rotation = this.getPhotoRotation(this.output!, degree);
    let settings: camera.PhotoCaptureSetting = {
      quality: camera.QualityLevel.QUALITY_LEVEL_HIGH,
      rotation,
      mirror: isFront
    };
    this.output?.capture(settings, (err: BusinessError) => {
      if (err) {
        Logger.error(TAG_LOG, `Failed to capture the photo. error: ${JSON.stringify(err)}`);
        return;
      }
      Logger.info(TAG_LOG, 'Callback invoked to indicate the photo capture request success.');
    });
  }
  // [End capture_photo]

  private calculateDeviceDegree(x: number, y: number, z: number): number {
    let deviceDegree: number = 0;
    // Determine if the device is approaching a vertical position (perpendicular to the ground)
    if ((x * x + y * y) * 3 < z * z) {
      return deviceDegree;
    } else {
      // Calculate the inverse tangent value
      let sd: Decimal = Decimal.atan2(y, -x)
      // Convert radian values to angle values;
      let sc: Decimal = Decimal.round(Number(sd) / Math.PI * 180);
      // Adjust angle to be relative to vertical orientation
      deviceDegree = 90 - Number(sc);
      // Normalize angle to 0-360 degrees range
      deviceDegree = deviceDegree >= 0 ? deviceDegree % 360 : deviceDegree % 360 + 360;
    }
    return deviceDegree;
  }

  private getPhotoDegree() {
    const promise: Promise<number> = new Promise(resolve => {
      sensor.once(sensor.SensorId.ACCELEROMETER, (data: sensor.AccelerometerResponse) => {
        let degree = this.calculateDeviceDegree(data.x, data.y, data.z);
        resolve(degree);
      });
    })
    return promise;
  }

  // [Start is_moving_photo]
  public isMovingPhotoSupported(photoOutput: camera.PhotoOutput): boolean {
    let isSupported: boolean = false;
    try {
      isSupported = photoOutput.isMovingPhotoSupported();
    } catch (error) {
      Logger.error(TAG_LOG, `The isMovingPhotoSupported call failed. error code: ${error.code}`);
    }
    return isSupported;
  }

  // [End is_moving_photo]

  // [Start enable_moving_photo]
  public enableMovingPhoto(enabled: boolean): void {
    try {
      this.output?.enableMovingPhoto(enabled);
    } catch (error) {
      Logger.error(TAG_LOG, `The enableMovingPhoto call failed. error code: ${error.code}`);
    }
  }

  // [End enable_moving_photo]

  // [Start photo_release]
  async release() {
    await this.output?.release();
    if (this.isSingle) {
      this.output?.off('photoAvailable');
    } else {
      this.output?.off('photoAssetAvailable');
    }
    this.output = undefined;
  }
  // [End photo_release]
}
