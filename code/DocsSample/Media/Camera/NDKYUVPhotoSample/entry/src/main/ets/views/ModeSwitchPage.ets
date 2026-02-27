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

import cameraDemo from 'libentry.so';
import deviceInfo from '@ohos.deviceInfo';
import { SettingDataObj } from '../common/Constants'
import common from '@ohos.app.ability.common'
import { Decimal } from '@kit.ArkTS';
import { sensor } from '@kit.SensorServiceKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { fileIo, fileUri } from '@kit.CoreFileKit';
import fs from '@ohos.file.fs';

@Component
export struct modeSwitchPage {
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;
  // Front and rear cameras
  @Link cameraDeviceIndex: number;
  // SurfaceID
  @Prop surfaceId: string;
  // Select mode
  @State modelBagCol: string = 'photo';
  // Choose camera or capture
  @State isModeBol: boolean = true;
  @State buttonWidth: string = '176px';
  @State buttonHeight: string = '176px';
  private appContext: common.Context = this.getUIContext().getHostContext()!;
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

  aboutToAppear() {
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

  async getGravity(): Promise<number> {
    let isSupported: boolean = false;
    let data: sensor.Sensor[];
    try {
      data = await sensor.getSensorList();
    } catch (error) {
      console.error(`getSensorList failed, error: ${error.code}`);
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
      console.error(`gePromise failed, error: ${error.code}`);
      return -1; // 异常场景下返回默认值
    }
  }

  getPixelMap(imageMimeType: string) {
    let filePath = this.appContext.filesDir + '/pixel_map.jpg';
    console.error('getPixelMap filePath:' + filePath);
    let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    console.error('getPixelMap fd:' + file.fd);
    cameraDemo.getPixelMap(file.fd, imageMimeType);
    let srcFileUri =  file.path;
    let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(this.appContext);
    this.saveFile(srcFileUri, phAccessHelper);
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
            cameraDemo.initCamera(this.surfaceId, this.settingDataObj.focusMode, this.cameraDeviceIndex);
            this.modelBagCol = 'photo'
          })
      }.position({ x: '45%', y: '77%' })


      // album
      Column() {
        Row() {
          if (this.modelBagCol === 'photo') {
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
      .id('Album')

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
              cameraDemo.initCamera(this.surfaceId, this.settingDataObj.focusMode, this.cameraDeviceIndex);
            })
        }
      }.position({ x: '70%', y: '85%' })
      .id('SwitchCameraButton')

      // capture video icon
      Column() {
        Row() {
          Image($r('app.media.camera_take_photo_4x'))
            .id('TakePicture')
            .width(this.buttonWidth)
            .height(this.buttonHeight)
            .onTouch(async (event?: TouchEvent) => {
              if (event) {
                if (event.type == TouchType.Down) {
                  this.buttonWidth = '160px';
                  this.buttonHeight = '160px';
                }
                if (event.type == TouchType.Up) {
                  let deviceDegree = await this.getGravity();
                  cameraDemo.startPhoto(deviceDegree);
                  this.buttonWidth = '176px';
                  this.buttonHeight = '176px';
                  let isSingle = cameraDemo.isSingle();
                  if (isSingle) {
                    await new Promise<void>(resolve => setTimeout(resolve, 1000));
                    this.getPixelMap('image/jpeg');
                  }
                }
              }
            })
        }
      }.position({ x: '40%', y: '85%' })
      .id('CaptureOrVideoButton')
    }
  }
}