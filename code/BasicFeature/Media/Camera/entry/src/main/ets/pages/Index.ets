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

import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import cameraDemo from 'libentry.so';
import Logger from '../model/Logger';
import { mainDialog } from '../Dialog/MainDialog';
import { dividerPage } from '../views/DividerPage';
import { settingDialog } from '../Dialog/SettingDialog';
import { CountdownPage } from '../views/CountdownPage';
import { FlashingLightPage } from '../views/FlashingLightPage';
import { SlidePage } from '../views/SlidePage';
import { modeSwitchPage } from '../views/ModeSwitchPage';
import { focusPage } from '../views/FocusPage';
import { FocusAreaPage } from '../views/FocusAreaPage';
import { Constants } from '../common/Constants';
import DisplayCalculator from '../common/DisplayCalculator';
import display from '@ohos.display';
import * as Common from '../common/Constants'
import { SettingDataObj } from '../common/Constants'
import common from '@ohos.app.ability.common'

const TAG: string = 'UI indexPage';

@Entry
@Component
struct Index {
  // XComponentController
  private mXComponentController: XComponentController = new XComponentController();
  // surfaceID value
  @State surfaceId: string = '';
  // Entrance confirmation network pop-up
  private mainDialogController: CustomDialogController = new CustomDialogController({
    builder: mainDialog(),
    autoCancel: false,
    customStyle: true
  });
  // Select mode
  @State modelBagCol: string = 'photo';
  // Exposure area
  @State focusPointBol: boolean = false;
  // Finger click coordinates in the exposure area
  @State focusPointVal: Array<number> = [0, 0];
  // Display where scale, focal length value, and focus box cannot coexist
  @State exposureBol: boolean = true;
  // Exposure value
  @State exposureNum: number = 0;
  // Countdown, photography, and video recording
  @State countdownNum: number = 0;
  // Front and rear cameras
  @State cameraDeviceIndex: number = 0;
  @State xComponentWidth: number = 384;
  @State xComponentHeight: number = 450;
  private deviceType: string = '';
  private screenHeight: number = 0;
  private screenWidth: number = 0;
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
  private appContext: common.Context = getContext(this);
  // Set Popup Box
  private settingDialogController: CustomDialogController = new CustomDialogController({
    builder: settingDialog({
      referenceLineBol: $referenceLineBol,
      surfaceId: this.surfaceId,
      cameraDeviceIndex: this.cameraDeviceIndex
    }),
    autoCancel: false,
    customStyle: true
  });
  // REFERENCE LINE
  @State referenceLineBol: boolean = false;
  @StorageLink('defaultAspectRatio') @Watch('initXComponentSize') defaultAspectRatio: number = Constants.MIN_ASPECT_RATIO;
  @State onShow: boolean = false;
  atManager = abilityAccessCtrl.createAtManager();

  // Entry initialization function
  async aboutToAppear() {
    await this.requestPermissionsFn();
    let mDisplay = display.getDefaultDisplaySync();
    this.screenWidth = px2vp(mDisplay.width);
    this.screenHeight = px2vp(mDisplay.height);
    this.initXComponentSize();
  }

  initXComponentSize(): void {
    let defaultSize = DisplayCalculator.calcSurfaceDisplaySize(this.screenWidth, this.screenHeight, this.defaultAspectRatio);
    this.xComponentWidth = defaultSize.width;
    this.xComponentHeight = defaultSize.height;
  }

  async aboutToDisAppear() {
    await cameraDemo.releaseCamera();
  }

  // Obtain permissions
  async requestPermissionsFn() {
    Logger.info(TAG, `requestPermissionsFn entry`);
    try {
      this.atManager.requestPermissionsFromUser(this.appContext, [
        'ohos.permission.CAMERA',
        'ohos.permission.MICROPHONE',
        'ohos.permission.READ_MEDIA',
        'ohos.permission.WRITE_MEDIA'
      ]).then(() => {
        Logger.info(TAG, `request Permissions success!`);
        this.onShow = true;
      })
    } catch (err) {
      Logger.info(TAG, `requestPermissionsFromUser call Failed! error: ${err.code}`);
    }
  }

  async onPageShow() {
    Logger.info(TAG, `onPageShow App`);
    if (this.surfaceId && this.onShow) {
      Logger.error(TAG, `initCamera start`);
      cameraDemo.initCamera(this.surfaceId, this.settingDataObj.focusMode, this.cameraDeviceIndex);
      Logger.error(TAG, `initCamera end`);
    }
  }

  onPageHide() {
    Logger.info(TAG, `onPageHide App`);
    cameraDemo.releaseCamera();
  }

  build() {
    Stack() {
      if (this.onShow) {
        // general appearance of a picture
        XComponent({
          id: 'componentId',
          type: 'surface',
          controller: this.mXComponentController
        })
          .onLoad(async () => {
            Logger.info(TAG, 'onLoad is called');
            this.surfaceId = this.mXComponentController.getXComponentSurfaceId();
            Logger.info(TAG, `onLoad surfaceId: ${this.surfaceId}`);
            Logger.error(TAG, `initCamera start`);
            cameraDemo.initCamera(this.surfaceId, this.settingDataObj.focusMode, this.cameraDeviceIndex);
            let device = Common.cameraDeviceIndex;
            device = this.cameraDeviceIndex;
            Logger.error(TAG, `initCamera end`);
          })
          .backgroundColor(Color.Blue)
          .width('100%')
          .height('70%')

        // REFERENCE LINE
        dividerPage({ referenceLineBol: this.referenceLineBol });
        // Set icon
        Button() {
          Image($r('app.media.icon_camera_setting'))
            .width('120px').height('120px')
        }
        .width('120px')
        .height('120px')
        .backgroundColor('rgba(255,255,255,0.20)')
        .borderRadius('40px')
        .position({ x: '80%', y: '3%' })
        .id('CameraSettings')
        .onClick(() => {
          // Open the settings pop-up box
          this.settingDialogController.open()
        });
        // Exposure frame and focus frame
        focusPage({
          focusPointBol: $focusPointBol,
          focusPointVal: $focusPointVal,
          exposureBol: $exposureBol,
          exposureNum: $exposureNum
        });
        // Exposure focusing finger click area
        FocusAreaPage({
          focusPointBol: $focusPointBol,
          focusPointVal: $focusPointVal,
          exposureBol: $exposureBol,
          exposureNum: $exposureNum,
          xComponentWidth: this.xComponentWidth,
          xComponentHeight: this.xComponentHeight
        });
        // CountDown
        CountdownPage({ countdownNum: $countdownNum });
        // FlashLight
        FlashingLightPage();
        // Slide
        SlidePage();
        // Reverse camera_Multiple workstations_Take photos_Video
        modeSwitchPage({
          surfaceId: this.surfaceId,
          cameraDeviceIndex: $cameraDeviceIndex,
          countdownNum: $countdownNum
        });
      }
    }
    .height('100%')
    .width('100%')
    .backgroundColor(Color.Black)
  }
}