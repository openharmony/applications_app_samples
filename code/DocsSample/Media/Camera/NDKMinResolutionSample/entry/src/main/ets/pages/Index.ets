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
import { VideoRatePage } from '../views/VideoRatePage';
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
import { ResolutionService, ResolutionSize } from '../common/ResolutionService';
import common from '@ohos.app.ability.common'
import { GridLine } from '../views/GridLine';
import { GridLinePage } from '../views/GridLinePage';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { camera } from '@kit.CameraKit';

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
  // Front and rear cameras
  @State cameraDeviceIndex: number = 0;
  @State videoId: string = '';
  @State mSurfaceId: string = '';
  @State videoTrigger: number = 0;
  @State photoTrigger: number = 0;
  @State sceneMode: camera.SceneMode = camera.SceneMode.NORMAL_PHOTO;
  @State isGridLineVisible: boolean = false;
  @State xComponentWidth: number = 384;
  @State xComponentHeight: number = 450;
  private deviceType: string = '';
  private screenHeight: number = 0;
  private screenWidth: number = 0;
  private photoBuffer: ArrayBuffer | undefined;
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
  // REFERENCE LINE
  @State referenceLineBol: boolean = false;
  @StorageLink('defaultAspectRatio') @Watch('initXComponentSize') defaultAspectRatio: number =
    Constants.MIN_ASPECT_RATIO;
  @State onShow: boolean = false;


  @StorageProp ('previewHeight') previewHeight: string = '70%';
  @StorageLink('photoResolution') @Watch('onPhotoResChanged') photoRes: ResolutionSize = { width: this.screenWidth, height: 2000 };
  @StorageLink('videoResolution') @Watch('onVideoResChanged') videoRes: ResolutionSize = { width: this.screenWidth, height: 2000 };
  @StorageLink('photoResolutionLabel') photoResLabel: string = '';
  @StorageLink('videoResolutionLabel') videoResLabel: string = '';

  @State photoResOptions: Array<SelectOption> = [];
  @State videoResOptions: Array<SelectOption> = [];
  @State photoResSelectedIndex: number = 0;
  @State videoResSelectedIndex: number = 0;

  onPhotoResChanged() {
    this.updateXComponentSize(this.photoRes);
  }

  onVideoResChanged() {
    this.updateXComponentSize(this.videoRes);
  }

  updateXComponentSize(size: ResolutionSize): void {
    let defaultSize = DisplayCalculator.calcSurfaceDisplaySize(this.screenWidth, this.screenHeight,
      this.defaultAspectRatio);

    const ratio = ResolutionService.detectAspectLabelBySize(size);
    console.info(`updateXComponentSize: ${ratio}`);
    if (ratio == '1:1') {
      this.xComponentWidth = defaultSize.width;
      this.xComponentHeight = this.xComponentWidth;
    } else if (ratio == '4:3') {
      this.xComponentWidth = defaultSize.width;
      this.xComponentHeight = this.xComponentWidth / 3 * 4;
    } else if (ratio == '16:9') {
      this.xComponentWidth = defaultSize.width;
      this.xComponentHeight = this.xComponentWidth / 9 *16;
    } else if (ratio == '20:9') {
      this.xComponentWidth = defaultSize.width;
      this.xComponentHeight = defaultSize.height;
    }
    console.info(`updateXComponentSize width ${this.xComponentWidth}` + `updateXComponentSize height ${this.xComponentHeight}`);
  }

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
    let defaultSize =
      DisplayCalculator.calcSurfaceDisplaySize(this.screenWidth, this.screenHeight, this.defaultAspectRatio);
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
      if (this.sceneMode == camera.SceneMode.NORMAL_VIDEO) {
        this.videoTrigger++;
      } else {
        this.photoTrigger++;
      }
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
            cameraDemo.initCamera(this.surfaceId, this.videoId, this.mSurfaceId,
              this.sceneMode, this.settingDataObj.focusMode, this.cameraDeviceIndex)
            let device = Common.cameraDeviceIndex;
            device = this.cameraDeviceIndex;
            Logger.error(TAG, `initCamera end`);

            console.log(`index previewHeight ` + this.photoRes.width);
            console.log(`index previewHeight ` + this.photoRes.height);
            try {
              console.log(`[Photo Resolutions] not supported by the device`);
              const photoLabels: string[] = ResolutionService.getPhotoResolutionLabels();
              console.log(`[Video Resolutions] not supported by the device`);
              const videoLabels: string[] = ResolutionService.getVideoResolutionLabels();

              this.photoResOptions = photoLabels.map((label: string) => ({ value: label } as SelectOption));
              this.videoResOptions = videoLabels.map((label: string) => ({ value: label } as SelectOption));

              if (photoLabels.length > 0) {
                if (this.photoResLabel) {
                  const index = photoLabels.indexOf(this.photoResLabel);
                  this.photoResSelectedIndex = index >= 0 ? index : 0;
                } else {
                  this.photoResSelectedIndex = 0;
                  this.photoResLabel = photoLabels[0];
                  const size = ResolutionService.parseLabel(photoLabels[0]);
                  if (size) {
                    this.photoRes = { width: size.width, height: size.height };
                  }
                }
              }

              if (videoLabels.length > 0) {
                if (this.videoResLabel) {
                  const index = videoLabels.indexOf(this.videoResLabel);
                  this.videoResSelectedIndex = index >= 0 ? index : 0;
                } else {
                  this.videoResSelectedIndex = 0;
                  this.videoResLabel = videoLabels[0];
                  const size = ResolutionService.parseLabel(videoLabels[0]);
                  if (size) {
                    this.videoRes = { width: size.width, height: size.height };
                  }
                }
              }
            } catch (err) {
              Logger.error(TAG, `Init get resolution failed.`);
            }
            this.photoTrigger++;
          })
          .backgroundColor(Color.Black)
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
        // Video Rate
        VideoRatePage()
        // FlashLight
        FlashingLightPage();
        // Slide
        SlidePage();
        //GridLine
        GridLinePage({
          isGridLineVisible: this.isGridLineVisible
        }
        );
        // Reverse camera_Multiple workstations_Take photos_Video
        modeSwitchPage({
          surfaceId: this.surfaceId,
          cameraDeviceIndex: $cameraDeviceIndex,
          videoId: this.videoId,
          sceneMode: this.sceneMode,
          videoTrigger: this.videoTrigger,
          photoTrigger: this.photoTrigger,
          mSurfaceId: this.mSurfaceId
        });

        Row({ space: 24 }) {
          Column() {
            Text('照片分辨率')
              .width(100)
              .height(25)
              .backgroundColor(Color.White)
              .textAlign(TextAlign.Center)
            if (this.photoResOptions.length > 0) {
              Select(this.photoResOptions)
                .selected(this.photoResSelectedIndex)
                .value(this.photoResOptions[this.photoResSelectedIndex].value)
                .backgroundColor('#fff')
                .font({ size: '10vp' })
                .onSelect(async (index, value) => {
                  this.photoResSelectedIndex = index;
                  const ret = ResolutionService.applyPhotoResolution(value);
                  this.photoTrigger++;
                  Logger.info(TAG, `apply photoResolution: ${value}`, value);
                  const size = ResolutionService.parseLabel(value);
                  if (size) {
                    this.photoRes = { width: size.width, height: size.height };
                    this.photoResLabel = value;
                  }
                  if (ret != 0) {
                    Logger.error(TAG, `set photoResolution failed, previewResolution:${value}`, value);
                  }
                });
            }
          }
        }
        .margin({ left: 24 })
        .alignItems(VerticalAlign.Top)
        .justifyContent(FlexAlign.Start)
        .position({x:'40%',y:'3%' })

        Row({ space: 24 }) {
          Column() {
            Text('视频分辨率')
              .width(100)
              .height(25)
              .backgroundColor(Color.White)
              .textAlign(TextAlign.Center)
            if (this.videoResOptions.length > 0) {
              Select(this.videoResOptions)
                .selected(this.videoResSelectedIndex)
                .value(this.videoResOptions[this.videoResSelectedIndex].value)
                .backgroundColor('#fff')
                .font({ size: '10vp' })
                .onSelect(async (index, value) => {
                  this.videoResSelectedIndex = index;
                  const ret = ResolutionService.applyVideoResolution(value);
                  this.videoTrigger++;
                  Logger.info(TAG, `apply videoResolution: ${value}`, value);
                  const size = ResolutionService.parseLabel(value);
                  if (size) {
                    this.videoRes = { width: size.width, height: size.height };
                    this.videoResLabel = value;
                  }
                  if (ret != 0) {
                    Logger.error(TAG, `set videoResolution failed, previewResolution:${value}`, value);
                  }
                });
            }
          }
        }
        .margin({ left: 24 })
        .alignItems(VerticalAlign.Top)
        .justifyContent(FlexAlign.Start)
        .position({x:'67%',y:'3%' })

        if (this.isGridLineVisible) {
          GridLine();
        }
      }
    }
    .height('100%')
    .width('100%')
    .backgroundColor(Color.Black)
  }


}