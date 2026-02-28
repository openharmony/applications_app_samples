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

// [Start import_interface]
import { camera } from '@kit.CameraKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { dataSharePredicates } from '@kit.ArkData';
import { image } from '@kit.ImageKit';
// [End import_interface]
import { sensor } from '@kit.SensorServiceKit';
import { Decimal } from '@kit.ArkTS';
import { geoLocationManager } from '@kit.LocationKit';
import { Logger } from 'commons';
import OutputManager, { CreateOutputConfig, OutputType } from './OutputManager';
import CameraConstant from '../constants/CameraConstants';
import { fileIo as fs } from '@kit.CoreFileKit';
import { fileIo } from '@kit.CoreFileKit';

const TAG_LOG = 'PhotoManager';

export class PhotoManager implements OutputManager {
  public type: OutputType = OutputType.PHOTO;
  public output?: camera.PhotoOutput;
  public isActive: boolean = true;
  public context: Context;
  public isSingle: boolean = false;
  public isHdr: boolean = false;
  public location: geoLocationManager.Location | null = null;
  public surfaceId?: string;
  public srcFileUri: string = '';
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
      this.surfaceId = config.surfaceId;
      this.output = cameraPhotoOutput;
      this.setPhotoOutputCallback(this.isSingle);
    }
    return cameraPhotoOutput;
  }

  // [Start get_full_outputCapability]
  getFullOutputCapability(cameraManager: camera.CameraManager, cameraDevice: camera.CameraDevice,
    sceneMode: camera.SceneMode): camera.CameraOutputCapability | undefined {
    let cameraOutputCapability = cameraManager.getSupportedFullOutputCapability(cameraDevice, sceneMode);
    if (!cameraOutputCapability) {
      console.error('cameraManager.getSupportedFullOutputCapability error');
      return undefined;
    }
    console.info(`outputCapability: ` + JSON.stringify(cameraOutputCapability));
    // 以NORMAL_PHOTO模式为例，需要添加预览流、拍照流。
    // previewProfiles属性为获取当前设备支持的预览输出流。
    let previewProfilesArray: camera.Profile[] = cameraOutputCapability.previewProfiles;
    if (!previewProfilesArray) {
      console.error('createOutput previewProfilesArray == null || undefined');
    }
    // photoProfiles属性为获取当前设备支持的拍照输出流。
    let photoProfilesArray: camera.Profile[] = cameraOutputCapability.photoProfiles;
    if (!photoProfilesArray) {
      console.error('createOutput photoProfilesArray == null || undefined');
    }
    // 查询photoProfilesArray中是否包含支持YUV格式的拍照输出流。
    let isSupportYuv: boolean = false;
    for (let index = 0; index < photoProfilesArray.length; index++) {
      if (photoProfilesArray[index].format === camera.CameraFormat.CAMERA_FORMAT_YUV_420_SP) {
        isSupportYuv = true;
        break;
      }
    }
    if (!isSupportYuv) {
      console.error('cameraManager.getSupportedFullOutputCapability error, yuv is not supported');
    }
    return cameraOutputCapability;
}
  // [End get_full_outputCapability]

  // [Start create_photo_output]
  public createPhotoOutput(cameraManager: camera.CameraManager, cameraDevice: camera.CameraDevice,
    profile: camera.Profile) {
    let cameraPhotoOutput: camera.PhotoOutput | undefined = undefined;
    const cameraOutputCapability = this.getFullOutputCapability(cameraManager, cameraDevice,
      camera.SceneMode.NORMAL_PHOTO);
    let photoProfilesArray: camera.Profile[] | undefined = cameraOutputCapability?.photoProfiles;
    if (photoProfilesArray?.length) {
      try {
        const displayRatio = profile.size.width / profile.size.height;
        const profileWidth = profile.size.width;
        // 获取当前设备支持的拍照输出流中，支持YUV格式的拍照输出流。
        let photoProfile = photoProfilesArray
          .sort((a, b) => Math.abs(a.size.width - profileWidth) - Math.abs(b.size.width - profileWidth))
          .find(pf => {
            const pfDisplayRatio = pf.size.width / pf.size.height;
            return Math.abs(pfDisplayRatio - displayRatio) <= CameraConstant.PROFILE_DIFFERENCE &&
              pf.format === camera.CameraFormat.CAMERA_FORMAT_YUV_420_SP;
          });
        Logger.info(TAG_LOG, `getProfile output profile:${JSON.stringify(photoProfile)}`);
        // 如果photoProfilesArray中不包含支持YUV格式的拍照输出流，则使用photoProfilesArray中的第一个输出流。
        if (!photoProfile) {
          photoProfile = photoProfilesArray[0];
        }
        // 创建拍照输出流。
        cameraPhotoOutput = cameraManager.createPhotoOutput(photoProfile);
      } catch (error) {
        Logger.error(TAG_LOG, `Failed to createPhotoOutput. error: ${JSON.stringify(error)}`);
      }
    }
    this.output = cameraPhotoOutput;
    return cameraPhotoOutput;
  }

  // [End create_photo_output]

  // [Start set_photo_cb_double]
  // 保存图片。
  async mediaLibSavePhoto(photoAsset: photoAccessHelper.PhotoAsset,
    phAccessHelper: photoAccessHelper.PhotoAccessHelper): Promise<void> {
    try {
      let assetChangeRequest: photoAccessHelper.MediaAssetChangeRequest =
        new photoAccessHelper.MediaAssetChangeRequest(photoAsset);
      Logger.info(TAG_LOG, `saveCameraPhoto E`);
      await assetChangeRequest.saveCameraPhoto();
      await phAccessHelper.applyChanges(assetChangeRequest);
      Logger.info(TAG_LOG, `saveCameraPhoto X`);
      await phAccessHelper.release();
    } catch (error) {
      Logger.error(TAG_LOG, `apply saveCameraPhoto failed with error: ${error.code}, ${error.message}`);
    }
  }

  async mediaLibRequestBuffer(photoAsset: photoAccessHelper.PhotoAsset, context: Context,
    callback: (pixelMap: image.PixelMap, url: string) => void) {
    // 获取图片pixelmap信息。
    try {
      Logger.info(TAG_LOG, 'quickRequestImage E');

      class MediaDataHandler implements photoAccessHelper.QuickImageDataHandler<image.Picture> {
        onDataPrepared(data: image.Picture, imageSource: image.ImageSource, map: Map<string, string>) {
          if (data === undefined) {
            Logger.error(TAG_LOG, 'Error occurred when preparing data');
            return;
          }
          Logger.info(TAG_LOG, 'QuickImageDataHandler request picture success');
          Logger.info(TAG_LOG, `photoAssetAvailable callabck uri:${photoAsset.uri}`);
          imageSource.createPixelMap().then((pixelMap: image.PixelMap) => {
            callback(pixelMap, photoAsset.uri);
          }).catch((err: BusinessError) => {
            Logger.error(TAG_LOG, `createPixelMap err:${err.code}`);
          })
        }
      }

      let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      let fetchOptions: photoAccessHelper.FetchOptions = {
        fetchColumns: [],
        predicates: predicates
      };

      let requestOptions: photoAccessHelper.RequestOptions = {
        deliveryMode: photoAccessHelper.DeliveryMode.BALANCE_MODE,
      }

      const handler = new MediaDataHandler();
      let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
      phAccessHelper.getAssets(fetchOptions, async (err, fetchResult) => {
        let photoAsset: photoAccessHelper.PhotoAsset = await fetchResult.getFirstObject();
        await photoAccessHelper.MediaAssetManager.quickRequestImage(context, photoAsset, requestOptions, handler);
        Logger.info(TAG_LOG, 'quickRequestImage X');
      })
    } catch (error) {
      Logger.error(TAG_LOG, `mediaLibRequestBuffer failed with error: ${error.code}, ${error.message}`);
    }
  }


  public setPhotoOutputCbDouble(cameraPhotoOutput: camera.PhotoOutput) {
    Logger.info(TAG_LOG, 'setPhotoOutputCbDouble ...');
    cameraPhotoOutput.on('photoAssetAvailable',
      async (_err: BusinessError, photoAsset: photoAccessHelper.PhotoAsset): Promise<void> => {
        try {
          Logger.info(TAG_LOG, `on photoAssetAvailable callabck uri:${photoAsset.uri}`);
          let accessHelper: photoAccessHelper.PhotoAccessHelper =
            photoAccessHelper.getPhotoAccessHelper(this.context);
          await this.mediaLibRequestBuffer(photoAsset, this.context, this.callback);
          await this.mediaLibSavePhoto(photoAsset, accessHelper);
        } catch(_err) {
          Logger.error(TAG_LOG, `photoAssetAvailable err:${_err.code}`);
        }
      });
  }

  // [End set_photo_cb_double]

  // [Start set_photo_cb_single]
  setPhotoOutputCbSingle(photoOutput: camera.PhotoOutput, context: Context) {
    // 设置回调之后，调用photoOutput的capture方法，就会将拍照的pixelMap回传到回调中。
    photoOutput.onCapturePhotoAvailable((capturePhoto: camera.CapturePhoto): void => {
      if (capturePhoto === undefined) {
        Logger.error(TAG_LOG, 'getPhoto failed');
        return;
      }

      Logger.info(TAG_LOG, 'photoAvailable success');
      this.mediaLibSavePhotoSingle(context, capturePhoto.main)
    });
  }
  
  async mediaLibSavePhotoSingle(context: Context, imageObj: image.Image | image.Picture) {
    let picture: image.Picture = imageObj as image.Picture;
    Logger.info(TAG_LOG, 'picture GetMainPixelmap E');
    await this.GetMainPixelmap(context, picture);
    Logger.info(TAG_LOG, 'picture GetMainPixelmap X');

    Logger.info(TAG_LOG, 'picture Release E');
    await this.Release(picture);
    Logger.info(TAG_LOG, 'picture Release X');
  }

  async packToFileFromPixelMap(context : Context, pixelMap : image.PixelMap) {
    const imagePackerApi = image.createImagePacker();
    let packOpts : image.PackingOption = { format: 'image/jpeg', quality: 95 };
    const path : string = context.cacheDir + '/pixel_map.jpg';
    let file = fs.openSync(path, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
    try {
      await imagePackerApi.packToFile(pixelMap, file.fd, packOpts);
      this.srcFileUri = file.path;
    } catch (error) {
      Logger.error(TAG_LOG, `Failed to pack the pixelMap to file. And the errorcode: ${error.code} ,error.message: ${error.message}`);
    }
  }

  async saveFile(srcFileUri: string, phAccessHelper: photoAccessHelper.PhotoAccessHelper){
    try {
      // 指定待保存到媒体库的位于应用沙箱的图片uri。
      let srcFileUris: string[] = [
        srcFileUri
      ];
      // 指定待保存照片的创建选项，包括文件后缀和照片类型，标题和照片子类型可选。
      let photoCreationConfigs: photoAccessHelper.PhotoCreationConfig[] = [
        {
          title: 'test', // 可选。
          fileNameExtension: 'jpg',
          photoType: photoAccessHelper.PhotoType.IMAGE,
          subtype: photoAccessHelper.PhotoSubtype.DEFAULT, // 可选。
        }
      ];
      // 基于弹窗授权的方式获取媒体库的目标uri。
      let desFileUris: string[] = await phAccessHelper.showAssetsCreationDialog(srcFileUris, photoCreationConfigs);
      // 将来源于应用沙箱的照片内容写入媒体库的目标uri。
      let desFile: fileIo.File = await fileIo.open(desFileUris[0], fileIo.OpenMode.WRITE_ONLY);
      let srcFile: fileIo.File = await fileIo.open(srcFileUri, fileIo.OpenMode.READ_ONLY);
      await fileIo.copyFile(srcFile.fd, desFile.fd);
      fileIo.closeSync(srcFile);
      fileIo.closeSync(desFile);
      console.info('create asset by dialog successfully');
    } catch (err) {
      console.error(`failed to create asset by dialog successfully errCode is: ${err.code}, ${err.message}`);
    }
  }

  // 获取拍照的主图的pixelMap。
  async GetMainPixelmap(context: Context, pictureObj : image.Picture) {
    let funcName = 'getMainPixelmap';
    if (pictureObj != null) {
      let mainPixelmap: image.PixelMap = pictureObj.getMainPixelmap();
      if (mainPixelmap != null) {
        // 编码。
        await this.packToFileFromPixelMap(context, mainPixelmap);
        // 保存。
        let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
        this.saveFile(this.srcFileUri, phAccessHelper);

        this.callback(mainPixelmap, '');
        mainPixelmap.getImageInfo().then((imageInfo: image.ImageInfo) => {
          if (imageInfo != null) {
            Logger.info(TAG_LOG, 'GetMainPixelmap information height:' + imageInfo.size.height + ' width:' + imageInfo.size.width +
              ' pixelFormat:' + imageInfo.pixelFormat + ' isHdr:' + imageInfo.isHdr);
          }
        }).catch((error: BusinessError) => {
          Logger.error(TAG_LOG, `Failed error.code: ${error.code} ,error.message: ${error.message}`);
        });
      } else {
        Logger.error(TAG_LOG, 'PictureObj getMainPixelmap is null');
      }
    } else {
      Logger.error(TAG_LOG, 'PictureObj is null');
    }
  }

  // 释放资源。
  async Release(pictureObj : image.Picture) {
    let funcName = 'Release';
    if (pictureObj != null) {
      pictureObj.release();
      if (pictureObj.getMainPixelmap() == null) {
        Logger.info(TAG_LOG, 'PictureObj release Success !');
      } else {
        Logger.error(TAG_LOG, 'PictureObj release Failed !');
      }
    } else {
      Logger.error(TAG_LOG, 'PictureObj is null');
    }
  }

  // [End set_photo_cb_single]

  // [Start set_capture_ready_cb]
  captureReadyCallback(err: BusinessError): void {
    if (err !== undefined && err.code !== 0) {
      Logger.error(TAG_LOG, `Callback Error, errorCode: ${err.code}`);
      return;
    }
    Logger.info(TAG_LOG, `photo capture ready`);
  }

  registerPhotoOutputCaptureReady(photoOutput: camera.PhotoOutput): void {
    Logger.info(TAG_LOG, `register PhotoOutput Capture Ready...`);
    photoOutput.on('captureReady', this.captureReadyCallback);
  }

  unregisterPhotoOutputCaptureReady(photoOutput: camera.PhotoOutput): void {
    Logger.info(TAG_LOG, `unregister PhotoOutput Capture Ready...`);
    photoOutput.off('captureReady');
  }
  // [End set_capture_ready_cb]

  // [Start set_capture_start_cb]
  onPhotoOutputCaptureStart(photoOutput: camera.PhotoOutput): void {
    photoOutput.on('captureStartWithInfo', (err: BusinessError, captureStartInfo: camera.CaptureStartInfo) => {
      if (err !== undefined && err.code !== 0) {
        return;
      }
      console.info(`photo capture started, captureId : ${captureStartInfo.captureId}`);
    });
  }
  // [End set_capture_start_cb]

  // [Start set_capture_end_cb]
  onPhotoOutputCaptureEnd(photoOutput: camera.PhotoOutput): void {
    photoOutput.on('captureEnd', (err: BusinessError, captureEndInfo: camera.CaptureEndInfo) => {
      if (err !== undefined && err.code !== 0) {
        return;
      }
      console.info(`photo capture end, captureId : ${captureEndInfo.captureId}`);
      console.info(`frameCount : ${captureEndInfo.frameCount}`);
    });
  }
  // [End set_capture_end_cb]

  // [Start set_photo_error_cb]
  onPhotoOutputError(photoOutput: camera.PhotoOutput): void {
    photoOutput.on('error', (error: BusinessError) => {
      console.error(`Photo output error code: ${error.code}`);
    });
  }
  // [End set_photo_error_cb]

  setPhotoOutputCallback(isSingle: boolean) {
    Logger.info(TAG_LOG, `setPhotoOutputCallback is single:${isSingle}`);
    if (!this.output) {
      return;
    }
    if (isSingle) {
      this.output?.off('photoAssetAvailable');
      this.registerPhotoOutputCaptureReady(this.output);
      this.setPhotoOutputCbSingle(this.output, this.context);
    } else {
      this.output?.offCapturePhotoAvailable();
      this.registerPhotoOutputCaptureReady(this.output);
      this.setPhotoOutputCbDouble(this.output);
    }
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
    Logger.info(TAG_LOG, 'capture start.');
    const degree = await this.getPhotoDegree();
    let rotation = this.getPhotoRotation(this.output!, degree);
    Logger.info(TAG_LOG, `rotation: ${rotation}.`);
    let settings: camera.PhotoCaptureSetting = {
      quality: camera.QualityLevel.QUALITY_LEVEL_HIGH,  // 设置图片质量。
      rotation,  // 设置图片旋转角度。
      mirror: isFront  // 设置镜像使能开关。
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

  // [Start photo_release]
  async release() {
    await this.output?.release();
    if (this.isSingle) {
      this.output?.offCapturePhotoAvailable();
      this.output?.off('captureReady');
    } else {
      this.output?.off('photoAssetAvailable');
    }
    this.output = undefined;
  }
  // [End photo_release]
}
