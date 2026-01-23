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

import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import cameraDemo from 'libentry.so';
import Logger from '../model/Logger';
import { mainDialog } from '../Dialog/MainDialog';
import { dividerPage } from '../views/DividerPage';
import { HdrVideoPage } from '../views/HdrVideoPage';
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
import common from '@ohos.app.ability.common'
import { WhiteBalancePage } from '../views/WhiteBalancePage';
import { GridLinePage } from '../views/GridLinePage';
import { GridLine } from '../views/GridLine';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { fileIo } from '@kit.CoreFileKit';

const TAG: string = 'CameraSample';

@Entry
@Component
struct Index {
  // XComponentController
  private mXComponentController: XComponentController = new XComponentController();
  // surfaceID value
  @State surfaceId: string = '';
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
  //HDR video
  @Provide isHdrVideo: boolean = false;
  @Provide isVideoMode: boolean = false;
  @State videoId: string = '';
  @State videoTrigger: number = 0;
  // Front and rear cameras
  @State cameraDeviceIndex: number = 0;
  @State xComponentWidth: number = 384;
  @State xComponentHeight: number = 450;
  @State isGridLineVisible: boolean = false;
  @State isMacro: boolean  = false;
  @State isControlCenter: boolean = false;
  @State textContent: string = '相机控制器关闭';
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
        'ohos.permission.MEDIA_LOCATION',
        'ohos.permission.MICROPHONE',
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
      if (this.isVideoMode) {
        cameraDemo.setIsVideo(true);
        this.videoTrigger++;
      } else {
        cameraDemo.setIsVideo(false);
        cameraDemo.initCamera(this.surfaceId, this.videoId, this.settingDataObj.focusMode, this.cameraDeviceIndex);
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
            if (this.isVideoMode) {
              cameraDemo.setIsVideo(true);
            } else {
              cameraDemo.setIsVideo(false);
            }
            cameraDemo.initCamera(this.surfaceId, this.videoId, this.settingDataObj.focusMode, this.cameraDeviceIndex);
            let device = Common.cameraDeviceIndex;
            device = this.cameraDeviceIndex;5
            Logger.error(TAG, `setBufferCb start`);
            cameraDemo.setBufferCb((buffer: ArrayBuffer): void => {
              Logger.info(TAG, `onLoad surfaceId: ${buffer}`);
              this.photoBuffer = buffer.slice(0);
              this.savePicture()
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
        // Video Rate
        VideoRatePage()
        if (this.isVideoMode) {
          // HdrVideoPage
          HdrVideoPage({
            videoTrigger: this.videoTrigger
          });
        }
        // FlashLight
        FlashingLightPage();
        //WhiteBalance
        WhiteBalancePage();
        // Slide
        SlidePage();
        //GridLine
        GridLinePage({
          isGridLineVisible: this.isGridLineVisible
        });
        Row() {
          SymbolGlyph(this.isMacro
          ? $r('sys.symbol.camera_macro_circle_fill')
          : $r('sys.symbol.camera_macro_slash_circle'))
            .onClick(() => {
              this.isMacro = !this.isMacro;
              cameraDemo.enableMacro(this.isMacro);
            })
            .width('100px')
            .height('100px')
            .fontSize(22)
            .fontColor([Color.White])
        }
        .position({ x: '90%', y: '2.5%' })

        Row() {
          Text(this.textContent)
            .onClick(() => {
              this.isControlCenter = !this.isControlCenter;
              this.textContent = this.isControlCenter ? '相机控制器开启' : '相机控制器关闭';
              cameraDemo.enableControlCenter(this.isControlCenter);
            })
            .fontColor(Color.White)
            .width('500px')
            .height('100px')
        }
        .position({ x: '5%', y: '9%' })
        // Reverse camera_Multiple workstations_Take photos_Video
        modeSwitchPage({
          surfaceId: this.surfaceId,
          cameraDeviceIndex: $cameraDeviceIndex,
          videoId: this.videoId,
          videoTrigger: this.videoTrigger
        });
        if (this.isGridLineVisible) {
          GridLine();
        }
      }
    }
    .height('100%')
    .width('100%')
    .backgroundColor(Color.Black)
  }

  //保存图片
  async savePicture() {
    let fileName = `${Date.now()}`;
    let photoType: photoAccessHelper.PhotoType = photoAccessHelper.PhotoType.IMAGE;
    let extension: string = 'jpg';
    let options: photoAccessHelper.CreateOptions = {
      title: fileName
    }
    let accessHelper: photoAccessHelper.PhotoAccessHelper | undefined;
    let context = this.getUIContext().getHostContext()!;
    if (!accessHelper) {
      accessHelper = photoAccessHelper.getPhotoAccessHelper(context);
      Logger.info(TAG, 'getPhotoAccessHelper succcess');
    }
    let imgPhotoUri: string = await accessHelper.createAsset(photoType, extension, options);
    //指定待保存到媒体库的位于应用沙箱的图片uri
    let srcFileUris: Array<string> = [
      imgPhotoUri
    ];
    // 指定待保存照片的创建选项,包括文件后缀和照片类型,标题和照片子类型可选
    let photoCreationConfigs: Array<photoAccessHelper.PhotoCreationConfig> = [
      {
        title: fileName, //可选
        fileNameExtension: 'jpg',
        photoType: photoAccessHelper.PhotoType.IMAGE,
        subtype: photoAccessHelper.PhotoSubtype.DEFAULT, //可选
      }
    ];
    // 基于弹窗授权的方式获取媒体库的目标uri
    let desFileUris: string[] = await accessHelper.showAssetsCreationDialog(srcFileUris, photoCreationConfigs);
    // 将来源于应用沙箱的照片内容写入媒体库的目标uri
    let desFile: fileIo.File = await fileIo.open(desFileUris[0], fileIo.OpenMode.WRITE_ONLY);
    await fileIo.write(desFile.fd, this.photoBuffer);

    fileIo.closeSync(desFile);
    Logger.info(TAG,'create asset by dialog successfully');
    Logger.info(TAG, 'savePicture end');
  }
}