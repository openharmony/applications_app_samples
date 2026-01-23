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
import { MovingPhotoPage } from '../views/MovingPhotoPage';

import { Constants } from '../common/Constants';
import DisplayCalculator from '../common/DisplayCalculator';
import display from '@ohos.display';
import * as Common from '../common/Constants'
import { SettingDataObj } from '../common/Constants'
import common from '@ohos.app.ability.common'
import deviceInfo from '@ohos.deviceInfo';
import { BusinessError } from '@kit.BasicServicesKit'
import { promptAction, router } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';

const TAG: string = 'UI indexPage';
// scene mode
const NORMAL_PHOTO: number = 1;
const NORMAL_VIDEO: number = 2;
const SECURE_PHOTO: number = 12;
// preconfig mode
const PRECONFIG_MODE_01: number = 1;
const PRECONFIG_MODE_02: number = 2;
const PRECONFIG_MODE_03: number = 3;
// preconfig type
const PRECONFIG_720P: number = 0;
const PRECONFIG_1080P: number = 1;
const PRECONFIG_4K: number = 2;
const PRECONFIG_HIGH_QUALITY: number = 3;
// preconfig ratio
const PRECONFIG_RATIO_1_1: number = 0;
const PRECONFIG_RATIO_4_3: number = 1;
const PRECONFIG_RATIO_16_9: number = 2;
// photo output type
const PHOTO_OUTPUT_TYPE_01: number = 1;
const PHOTO_OUTPUT_TYPE_02: number = 2;
const PHOTO_OUTPUT_TYPE_03: number = 3;
const PHOTO_OUTPUT_TYPE_04: number = 4;

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
  private imgUri1: string = '';
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
  @State sceneMode: number = NORMAL_PHOTO;
  @State preconfigMode: number = PRECONFIG_MODE_01;
  @State preconfigType: number = PRECONFIG_720P;
  @State preconfigRatio: number = PRECONFIG_RATIO_1_1;
  @State photoOutputType: number = PHOTO_OUTPUT_TYPE_01;
  @State isMovingPhoto: boolean = false;
  @State isSavingPhoto: boolean = true;
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
    const permissions: Array<Permissions> = ['ohos.permission.CAMERA'];
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
      cameraDemo.initCamera(this.surfaceId, this.settingDataObj.focusMode, this.cameraDeviceIndex,
        this.sceneMode, this.preconfigMode, this.preconfigType, this.preconfigRatio,
        this.photoOutputType, this.isMovingPhoto, this.isSavingPhoto);

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
            cameraDemo.initCamera(this.surfaceId, this.settingDataObj.focusMode, this.cameraDeviceIndex,
              this.sceneMode, this.preconfigMode, this.preconfigType, this.preconfigRatio,
              this.photoOutputType, this.isMovingPhoto, this.isSavingPhoto);
            let device = Common.cameraDeviceIndex;
            device = this.cameraDeviceIndex;

            cameraDemo.requestImage((uri: string) => {
              console.info('photo image uri is ' + JSON.stringify(uri));
              this.imgUri1 = uri;
              this.pendingThumbnail = uri;
              this.imageVisibility = Visibility.Visible;
            });
            cameraDemo.requestImageQuality((mediaQuality: string) => {
              console.info('photo image mediaQuality is ' + JSON.stringify(mediaQuality));
              if (mediaQuality == 'fast') {
                this.imageQuality = '低质量图片';
              } else {
                this.imageQuality = '高质量图片';
              }
            });
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
        // MovingPhoto
        MovingPhotoPage();
        // FlashLight
        FlashingLightPage();
        // Slide
        SlidePage();
        // Reverse camera_Multiple workstations_Take photos_Video
        modeSwitchPage({
          surfaceId: this.surfaceId,
          cameraDeviceIndex: $cameraDeviceIndex,
          sceneMode: $sceneMode,
          preconfigMode: this.preconfigMode,
          preconfigType: this.preconfigType,
          preconfigRatio: this.preconfigRatio,
          photoOutputType: this.photoOutputType,
          isMovingPhoto: this.isMovingPhoto,
          isSavingPhoto: this.isSavingPhoto,
          imgThumbnail:$imgThumbnail,
        });

        Text('取消')
          .width('20%')
          .height('5%')
          .position({x: 0, y: 0})
          .textAlign(TextAlign.Center)
          .fontColor(Color.Black)
          .backgroundColor(this.leftTextColor)
          .visibility(this.imageVisibility)
          .onTouch((event?: TouchEvent) => {
            if (event) {
              if (event.type == TouchType.Down) {
                this.leftTextColor = Color.Gray
              }
              if (event.type == TouchType.Up) {
                this.imageVisibility = Visibility.None;
                cameraDemo.changeRequestDiscardCameraPhoto();
                this.leftTextColor = Color.White
              }
            }
          })
        Text('图片质量：' + this.imageQuality)
          .width('60%')
          .height('5%')
          .position({x: '20%', y: 0})
          .textAlign(TextAlign.Center)
          .fontColor(Color.Black)
          .backgroundColor(this.middleTextColor)
          .visibility(this.imageVisibility)
        Text('保存')
          .width('20%')
          .height('5%')
          .position({x: '80%', y: 0})
          .textAlign(TextAlign.Center)
          .fontColor(Color.Black)
          .backgroundColor(this.rightTextColor)
          .visibility(this.imageVisibility)
          .onTouch((event?: TouchEvent) => {
            if (event) {
              if (event.type == TouchType.Down) {
                this.rightTextColor = Color.Gray
              }
              if (event.type == TouchType.Up) {
                this.imageVisibility = Visibility.None;
                cameraDemo.changeRequestSaveCameraPhoto();
                this.rightTextColor = Color.White
              }
              this.imgThumbnail = this.pendingThumbnail;
            }
          })
        Image(this.imgUri1 || $r('app.media.camera_thumbnail_4x'))
          .id('Thumbnail')
          .objectFit(ImageFit.Fill)
          .width('100%')
          .height('95%')
          .position({x: 0, y: '5%'})
          .visibility(this.imageVisibility)
      }
    }
    .height('100%')
    .width('100%')
    .backgroundColor(Color.Black)
  }
}