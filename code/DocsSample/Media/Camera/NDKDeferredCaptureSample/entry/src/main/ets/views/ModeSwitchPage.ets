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

import cameraDemo from 'libentry.so';
import deviceInfo from '@ohos.deviceInfo';
import { Constants, SettingDataObj } from '../common/Constants'
import common from '@ohos.app.ability.common'
import { Decimal } from '@kit.ArkTS';
import { sensor } from '@kit.SensorServiceKit';

@Component
export struct modeSwitchPage {
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;
  @State videoId: string = '';
  @State mSurfaceId: string = '';
  @State imgUri: string = '';
  // Front and rear cameras
  @Link cameraDeviceIndex: number;
  // SurfaceID
  @Prop surfaceId: string;
  // Photo Thumbnails
  @Link imgThumbnail: string;
  // Select mode
  @State modelBagCol: string = 'photo';
  // Choose camera or capture
  @State @Watch('onChangeIsModeBol') isModeBol: boolean = true;
  @Link sceneMode: number;
  @Prop preconfigMode: number;
  @Prop preconfigType: number;
  @Prop preconfigRatio: number;
  @Prop photoOutputType: number;
  @Prop isMovingPhoto: boolean;
  @Prop isSavingPhoto: boolean;
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

  // After pausing, click 'stop' to reset the pause to default
  onChangeIsModeBol() {
  }

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
            cameraDemo.initCamera(this.surfaceId, this.settingDataObj.focusMode, this.cameraDeviceIndex,
              this.sceneMode, this.preconfigMode, this.preconfigType, this.preconfigRatio,
              this.photoOutputType, this.isMovingPhoto, this.isSavingPhoto);
            this.modelBagCol = 'photo'
          })
      }.position({ x: '45%', y: '77%' })


      // album
      Column() {
        Row() {
          if (this.modelBagCol === 'photo') {
            Image(this.imgThumbnail || $r('app.media.camera_thumbnail_4x'))
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
              cameraDemo.initCamera(this.surfaceId, this.settingDataObj.focusMode, this.cameraDeviceIndex,
                this.sceneMode, this.preconfigMode, this.preconfigType, this.preconfigRatio,
                this.photoOutputType, this.isMovingPhoto, this.isSavingPhoto);
            })
        }
      }.position({ x: '70%', y: '85%' })
      .id('SwitchCameraButton')

      // capture video icon
      Column() {
        Row() {
          if (this.modelBagCol === 'photo') {
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
                    cameraDemo.startPhotoOrVideo(this.modelBagCol, this.videoId, this.mSurfaceId, deviceDegree);
                    this.buttonWidth = '176px';
                    this.buttonHeight = '176px';
                  }
                }
              })
          }
        }
      }.position({ x: '40%', y: '85%' })
      .id('CaptureOrVideoButton')
    }
  }
}