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

import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import cameraDemo from 'libentry.so';
import Logger from '../model/Logger';
import { mainDialog } from '../Dialog/MainDialog';
import { dividerPage } from '../views/DividerPage';
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
import { camera } from '@kit.CameraKit';

const TAG: string = 'UI indexPage';
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
  private preconfigTypeSelectOptions: Array<SelectOption> = [
    { 'value': 'PRECONFIG_720P' },
    { 'value': 'PRECONFIG_1080P' },
    { 'value': 'PRECONFIG_4K' },
    { 'value': 'PRECONFIG_HIGH_QUALITY' }];
  private preconfigRatioSelectOptions: Array<SelectOption> = [
    { 'value': '1:1' },
    { 'value': '4:3' },
    { 'value': '16:9' }];
  private selectedIndex = 0;
  private ratioIndex = 0;
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
  private imgUri2: string = '';
  @State imageVisibility: Visibility = Visibility.None;
  @State imageQuality: string = 'undefined';
  @State text: string = '';
  @State isHdr: boolean = false;
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
  // Countdown, photography, and video recording
  @State countdownNum: number = 0;
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
  @State videoId: string = '';
  @State mSurfaceId: string = '';
  @State videoTrigger: number = 0;
  @State photoTrigger: number = 0;
  @State sceneMode: camera.SceneMode = camera.SceneMode.NORMAL_PHOTO;
  @State preconfigMode: number = PRECONFIG_MODE_03;
  @State preconfigType: number = PRECONFIG_1080P;
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
    await this.requestPermissionsFn();
    let mDisplay = display.getDefaultDisplaySync();
    this.screenWidth = px2vp(mDisplay.width);
    this.screenHeight = px2vp(mDisplay.height);
    this.initXComponentSize();
  }

  initXComponentSize(): void {
    let defaultSize = DisplayCalculator.calcSurfaceDisplaySize(this.screenWidth, this.screenHeight,
      this.defaultAspectRatio);
    if (this.preconfigRatio == 0) {
      this.xComponentWidth = defaultSize.width;
      this.xComponentHeight = this.xComponentWidth;
    } else if (this.preconfigRatio == 1) {
      this.xComponentWidth = defaultSize.width;
      this.xComponentHeight = this.xComponentWidth / 3 * 4;
    } else if (this.preconfigRatio == 2) {
      this.xComponentWidth = defaultSize.width;
      this.xComponentHeight = this.xComponentWidth / 9 * 16;
    }
  }

  async aboutToDisAppear() {
    await cameraDemo.releaseCamera();
  }

  updateXComponentSize() {
    let defaultSize = DisplayCalculator.calcSurfaceDisplaySize(this.screenWidth, this.screenHeight,
      this.defaultAspectRatio);
    if (this.preconfigRatio == 0) {
      this.xComponentWidth = defaultSize.width;
      this.xComponentHeight = this.xComponentWidth;
    } else if (this.preconfigRatio == 1) {
      this.xComponentWidth = defaultSize.width;
      this.xComponentHeight = this.xComponentWidth / 3 * 4;
    } else if (this.preconfigRatio == 2) {
      this.xComponentWidth = defaultSize.width;
      this.xComponentHeight = this.xComponentWidth / 9 * 16;
    }
  }

  onConfigTypeChanged() {
    this.preconfigType = this.selectedIndex;
    if (this.preconfigType == 3) {
      this.isHdr = true;
    } else {
      this.isHdr = false;
    }
    Logger.info(TAG, `isHdr = ${this.isHdr}`);
    Logger.info(TAG, `onConfigTypeChanged 111: ${this.xComponentHeight} this.selectedIndex ${this.selectedIndex}`);
    this.updateXComponentSize();
    Logger.info(TAG, `onConfigTypeChanged 333: ${this.xComponentHeight} this.PreconfigType= ${this.preconfigType}`);
    if (this.sceneMode == camera.SceneMode.NORMAL_VIDEO) {
      this.videoTrigger++;
    } else {
      this.photoTrigger++;
    }
  }

  onRatioConfigChanged() {
    this.preconfigRatio = this.ratioIndex;
    Logger.info(TAG, `onRatioConfigChanged 111: ${this.xComponentHeight} this.ratioIndex ${this.ratioIndex}`);
    this.updateXComponentSize();
    Logger.info(TAG, `onRatioConfigChanged 333: ${this.xComponentHeight} this.mConfigRatio= ${this.preconfigRatio}`);
    if (this.sceneMode == camera.SceneMode.NORMAL_VIDEO) {
      this.videoTrigger++;
    } else {
      this.photoTrigger++;
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
      ]).then(() => {
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
      if (this.sceneMode == camera.SceneMode.NORMAL_VIDEO) {
        this.videoTrigger++;
      } else {
        this.photoTrigger++;
      }

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
            Logger.error(TAG, `initCamera start`);
            cameraDemo.initCamera(this.surfaceId, this.focusMode, this.cameraDeviceIndex,
              this.sceneMode, this.preconfigMode, this.preconfigType, this.preconfigRatio,
              this.photoOutputType, this.videoId, this.mSurfaceId);
            let device = Common.cameraDeviceIndex;
            device = this.cameraDeviceIndex;

            cameraDemo.requestImage((uri: string) => {
              console.info('photo image uri is ' + JSON.stringify(uri));
                this.imgUri1 = uri;
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
            this.photoTrigger++;
          })
          .backgroundColor(Color.Blue)
          .width(this.xComponentWidth)
          .height(this.xComponentHeight)

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
        // Slide
        SlidePage();
        // Reverse camera_Multiple workstations_Take photos_Video
        modeSwitchPage({
          surfaceId: this.surfaceId,
          cameraDeviceIndex: $cameraDeviceIndex,
          sceneMode: this.sceneMode,
          preconfigMode: this.preconfigMode,
          preconfigType: this.preconfigType,
          preconfigRatio: this.preconfigRatio,
          photoOutputType: this.photoOutputType,
          isMovingPhoto: this.isMovingPhoto,
          isSavingPhoto: this.isSavingPhoto,
          countdownNum: $countdownNum,
          isHdr: this.isHdr,
          videoId: this.videoId,
          videoTrigger: this.videoTrigger,
          photoTrigger: this.photoTrigger,
          mSurfaceId: this.mSurfaceId
        });

        Row({ space: 24 }) {
          Column() {
            Text('预配置类型')
              .width(100)
              .height(25)
              .backgroundColor(Color.White)
              .textAlign(TextAlign.Center)
            Select(this.preconfigTypeSelectOptions)
              .selected(this.selectedIndex)
              .value(this.preconfigTypeSelectOptions[this.selectedIndex].value)
              .backgroundColor('#fff')
              .font({ size: '10vp' })
              .onSelect(async (index, value) => {
                this.selectedIndex = index;
                this.onConfigTypeChanged();
              });
          }
        }
        .margin({ left: 24 })
        .alignItems(VerticalAlign.Top)
        .justifyContent(FlexAlign.Start)
        .position({ x: '10%', y: '3%' })

        Row({ space: 24 }) {
          Column() {
            Text('分辨率比例')
              .width(80)
              .height(24)
              .backgroundColor(Color.White)
              .textAlign(TextAlign.Center)
            Select(this.preconfigRatioSelectOptions)
              .selected(this.ratioIndex)
              .value(this.preconfigRatioSelectOptions[this.ratioIndex].value)
              .backgroundColor('#fff')
              .font({ size: '10vp' })
              .onSelect(async (index, value) => {
                this.ratioIndex = index;
                this.onRatioConfigChanged();
              });
          }
        }
        .margin({ left: 24 })
        .alignItems(VerticalAlign.Top)
        .justifyContent(FlexAlign.Start)
        .position({ x: '60%', y: '3%' })

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
            }
          })
        Image(this.imgUri1 || $r('app.media.camera_thumbnail_4x'))
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