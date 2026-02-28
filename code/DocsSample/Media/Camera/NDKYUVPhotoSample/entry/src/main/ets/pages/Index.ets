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

import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';
import cameraDemo from 'libentry.so';

import Logger from '../model/Logger';
import { mainDialog } from '../Dialog/MainDialog';
import { dividerPage } from '../views/DividerPage';
import { FlashingLightPage } from '../views/FlashingLightPage';
import { SlidePage } from '../views/SlidePage';
import { modeSwitchPage } from '../views/ModeSwitchPage';
import { focusPage } from '../views/FocusPage';
import { FocusAreaPage } from '../views/FocusAreaPage';
import { YUVPhotoPage } from '../views/YUVPhotoPage';

import { Constants } from '../common/Constants';
import DisplayCalculator from '../common/DisplayCalculator';
import display from '@ohos.display';
import * as Common from '../common/Constants'
import { SettingDataObj } from '../common/Constants'
import common from '@ohos.app.ability.common'


const TAG: string = 'UI indexPage';
// scene mode
const NORMAL_PHOTO: number = 1;

@Entry
@Component
struct Index {
  // XComponentController
  private mXComponentController: XComponentController = new XComponentController();
  // surfaceID value
  @State surfaceId: string = '';
  @State imgThumbnail: string = '';
  private pendingThumbnail: string = '';
  @State imageVisibility: Visibility = Visibility.None;
  @State imageQuality: string = 'undefined';
  @State text: string = '';
  private textIndex: number = 0;
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
  // Front and rear cameras
  @State cameraDeviceIndex: number = 0;
  @State xComponentWidth: number = 384;
  @State xComponentHeight: number = 450;
  private deviceType: string = '';
  private screenHeight: number = 0;
  private screenWidth: number = 0;
  private curPixelMap: PixelMap | undefined;
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
  private appContext: common.Context = this.getUIContext().getHostContext()!;
  // Set Popup Box
  @State focusMode: number = this.settingDataObj.focusMode;
  @State leftTextColor: Color = Color.White;
  @State middleTextColor: Color = Color.Orange;
  @State rightTextColor: Color = Color.White;

  // REFERENCE LINE
  @State referenceLineBol: boolean = false;
  @StorageLink('defaultAspectRatio') @Watch('initXComponentSize') defaultAspectRatio: number = Constants.MIN_ASPECT_RATIO;
  @State onShow: boolean = false;
  atManager = abilityAccessCtrl.createAtManager();

  // Entry initialization function
  async aboutToAppear() {
    let context = this.appContext as common.UIAbilityContext;
    await this.requestCameraPermission(context);
    await this.requestPermissionsFn();
    let mDisplay = display.getDefaultDisplaySync();
    this.screenWidth = px2vp(mDisplay.width);
    this.screenHeight = px2vp(mDisplay.height);
    this.initXComponentSize();
  }

  initXComponentSize(): void {
    let defaultSize = DisplayCalculator.calcSurfaceDisplaySize(this.screenWidth, this.screenHeight,
      this.defaultAspectRatio);
    this.xComponentWidth = defaultSize.width;
    this.xComponentHeight = defaultSize.height;
  }

  async aboutToDisAppear() {
    if (cameraDemo == null) { Logger.error(TAG, 'releaseCamera 跳过：cameraDemo 为空'); return; }
    await cameraDemo.releaseCamera();
  }


  async requestCameraPermission(context: common.UIAbilityContext) {
    const atManager = abilityAccessCtrl.createAtManager();
    const permissions: Permissions[] = ['ohos.permission.CAMERA'];
    try {
      const result = await atManager.requestPermissionsFromUser(context, permissions);
      if (result.authResults[0] === 0) {
        console.log('用户已授权***********************************');
      } else {
        console.log('用户拒绝***********************************');
      }
    } catch (err) {
      console.error(`申请失败***********************************: ${JSON.stringify(err)}`);
    }
  }


  // Obtain permissions
  async requestPermissionsFn() {
    Logger.info(TAG, `requestPermissionsFn entry`);
    try {
      this.atManager.requestPermissionsFromUser(this.appContext, [
        'ohos.permission.CAMERA',
        'ohos.permission.MICROPHONE',
        'ohos.permission.READ_MEDIA',
        'ohos.permission.WRITE_MEDIA',
        'ohos.permission.MEDIA_LOCATION'
      ]).then((data) => {
        let grantStatus: number[] = data.authResults;
        Logger.error(TAG, grantStatus.toString() +'*******************************************');

        Logger.info(TAG, `request Permissions success!`);
        this.onShow = true;
      })
    } catch (err) {
      Logger.info(TAG, `requestPermissionsFromUser call Failed! error: ${err.code}`);
    }
  }

  async onPageShow() {
    Logger.info(TAG, `onPageShow App1`);
    if (this.surfaceId && this.onShow) {

      Logger.error(TAG, `initCamera start1`);
      cameraDemo.initCamera(this.surfaceId, this.settingDataObj.focusMode, this.cameraDeviceIndex);

      Logger.error(TAG, `initCamera end1`);
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
            if (cameraDemo == null) {
              Logger.error(TAG, 'cameraDemo 为空');
            }
            Logger.info(TAG, `cameraDemo 加载状态：${cameraDemo == null ? 'NULL/UNDEFINED' : 'OK'}`);
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
        // YUVPhoto
        YUVPhotoPage();
        // FlashLight
        FlashingLightPage();
        // Slide
        SlidePage();
        // Reverse camera_Multiple workstations_Take photos_Video
        modeSwitchPage({
          surfaceId: this.surfaceId,
          cameraDeviceIndex: $cameraDeviceIndex,
        });
      }
    }
    .height('100%')
    .width('100%')
    .backgroundColor(Color.Black)
  }
}