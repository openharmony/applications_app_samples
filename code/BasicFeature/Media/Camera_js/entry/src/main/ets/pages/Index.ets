/*
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
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

import display from '@ohos.display';
import Logger from '../model/Logger';
import { SettingDialog } from '../Dialog/SettingDialog';
import CameraService from '../model/CameraService';
import { CountdownPage } from '../views/CountdownPage';
import { FlashingLightPage } from '../views/FlashingLightPage';
import { FocusPage } from '../views/FocusPage';
import { SlidePage } from '../views/SlidePage';
import { DividerPage } from '../views/DividerPage';
import { FocusAreaPage } from '../views/FocusAreaPage';
import { ModeSwitchPage } from '../views/ModeSwitchPage';
import { Constants } from '../common/Constants';
import DisplayCalculator from '../common/DisplayCalculator';
import { ColorEffectComponent } from '../views/ColorEffectComponent';
import { MoonCaptureBoostComponent } from '../views/MoonCaptureBoostComponent';
import { DeferredPhotoComponent } from '../views/DeferredPhotoComponent';
import image from '@ohos.multimedia.image';
import { CameraConfig } from '../common/CameraConfig';
import { GlobalContext } from '../common/GlobalContext';

const TAG: string = 'indexPage';

let cameraConfig: CameraConfig = {
  mirrorBol: false, // 镜像使能 -> 关闭
  videoStabilizationMode: 0, // 视频防抖 -> 关闭
  exposureMode: 1, // 曝光模式 -> 自动
  focusMode: 2, // 对焦模式 -> 自动
  photoQuality: 1, // 拍照质量 -> 中
  locationBol: false, // 显示地理位置 -> 关闭
  photoFormat: 1, // 照片格式 -> JPG
  photoOrientation: 0, // 照片方向 -> 0
  photoResolution: 0, // 照片分辨率 -> 1920 * 1080
  videoResolution: 0, // 照片分辨率 -> 1920 * 1080
  videoFrame: 1, // 录像帧率 -> 30
  referenceLineBol: false // 分割线 -> 关闭
}
GlobalContext.get().setObject('cameraConfig', cameraConfig);

@Entry
@Component
struct Index {
  // XComponentCon控制器
  private mXComponentController: XComponentController = new XComponentController();
  // surfaceID值
  @State surfaceId: string = '';
  // 选择模式
  @State modelBagCol: string = 'photo';
  // 曝光区域
  @State focusPointBol: boolean = false;
  // 曝光区域手指点击坐标
  @State focusPointVal: Array<number> = [0, 0];
  // 刻度、焦距值 和 对焦框不能共存的显示
  @State exposureBol: boolean = true;
  // 曝光值
  @State exposureNum: number = 0;
  // 倒计时拍照 录像
  @State countdownNum: number = 0;
  // 相机摄像头
  @State cameraDeviceIndex: number = 0;
  @State xComponentWidth: number = 384;
  @State xComponentHeight: number = 450;
  private deviceType: string | undefined = '';
  private screenHeight: number = 0;
  private screenWidth: number = 0;

  // 设置弹框
  private settingDialogController: CustomDialogController = new CustomDialogController({
    builder: SettingDialog({
      referenceLineBol: $referenceLineBol,
      surfaceId: this.surfaceId,
      cameraDeviceIndex: this.cameraDeviceIndex
    }),
    autoCancel: false,
    customStyle: true
  });
  // 参考线
  @State referenceLineBol: boolean = false;
  @StorageLink('defaultAspectRatio') @Watch('initXComponentSize') defaultAspectRatio: number = Constants.MIN_ASPECT_RATIO;
  // 主页面是否显示
  @StorageLink('isShow') isShow: boolean = false;
  // 变焦条是否隐藏
  @StorageLink('isHiddenSlide') isHiddenSlide: boolean = false;

  aboutToAppear(): void {
    let mDisplay = display.getDefaultDisplaySync();
    this.screenWidth = px2vp(mDisplay.width);
    this.screenHeight = px2vp(mDisplay.height);
    this.deviceType = AppStorage.get<string>('deviceType');
    if (this.deviceType === Constants.TABLET) {
      this.defaultAspectRatio = Constants.MAX_ASPECT_RATIO;
    }
    this.initXComponentSize();
  }

  cancelDialog(): void {
    AppStorage.setOrCreate<boolean>('flashingBol', true);
    AppStorage.setOrCreate<boolean>('countdownBol', true);
    AppStorage.setOrCreate<boolean>('colorEffectComponentIsShow', true);
    AppStorage.setOrCreate<boolean>('deferredPhotoComponentIsShow', true);
  }

  initXComponentSize(): void {
    let defaultSize = DisplayCalculator.calcSurfaceDisplaySize(this.screenWidth, this.screenHeight, this.defaultAspectRatio);
    this.xComponentWidth = defaultSize.width;
    this.xComponentHeight = defaultSize.height;
  }

  async aboutToDisAppear(): Promise<void> {
    await CameraService.releaseCamera();
  }

  async onPageShow(): Promise<void> {
    Logger.info(TAG, 'onPageShow');
    if (this.surfaceId) {
      await CameraService.initCamera(this.surfaceId, this.cameraDeviceIndex);
    }
  }

  async onPageHide(): Promise<void> {
    Logger.info(TAG, 'onPageHide');
    let isRecorder: boolean | undefined = AppStorage.get<boolean>('isRecorder');
    if (isRecorder) {
      GlobalContext.get().apply('stopVideoFun');
    }
    await CameraService.releaseCamera();
  }

  build() {
    Stack() {
      Stack() {
        if (this.isShow) {
          // 画面
          XComponent({
            id: 'componentId',
            type: 'surface',
            controller: this.mXComponentController
          })
            .onLoad(async () => {
              Logger.info(TAG, 'onLoad is called');
              this.surfaceId = this.mXComponentController.getXComponentSurfaceId();
              Logger.info(TAG, `onLoad surfaceId: ${this.surfaceId}`);
              await CameraService.initCamera(this.surfaceId, this.cameraDeviceIndex);
              GlobalContext.get().setObject('surfaceId', this.surfaceId);
              GlobalContext.get().setObject('cameraDeviceIndex', this.cameraDeviceIndex);
            })
            .size({
              width: this.xComponentWidth.toString(),
              height: this.xComponentHeight.toString()
            })
            .margin({ bottom: Constants.SURFACE_BOTTOM_MARGIN })

          // 参考线
          DividerPage({
            referenceLineBol: this.referenceLineBol
          })

          // 曝光框和对焦框
          FocusPage({
            focusPointBol: $focusPointBol,
            focusPointVal: $focusPointVal,
            exposureBol: $exposureBol,
            exposureNum: $exposureNum
          })

          // 曝光对焦手指点击区域
          FocusAreaPage({
            focusPointBol: $focusPointBol,
            focusPointVal: $focusPointVal,
            exposureBol: $exposureBol,
            exposureNum: $exposureNum,
            xComponentWidth: this.xComponentWidth,
            xComponentHeight: this.xComponentHeight
          })

          // slide
          if (!this.isHiddenSlide) {
            SlidePage()
          }

          // 反转摄像头_多机位_拍照_摄像
          ModeSwitchPage({
            surfaceId: this.surfaceId,
            cameraDeviceIndex: $cameraDeviceIndex,
            countdownNum: $countdownNum
          })
        }
      }
      .size({ width: '100%', height: '100%' })

      Row({ space: 24 }) {
        // 设置图标
        Button() {
          Image($r('app.media.icon_camera_setting'))
            .size({
              width: '35vp',
              height: '35vp'
            })
        }
        .borderRadius('45vp')
        .width('45vp')
        .height('45vp')
        .backgroundColor('rgba(255,255,255,0.20)')
        .onClick(() => {
          Logger.info(TAG, 'icon_camera_setting onClick is called');
          this.cancelDialog();
          this.countdownNum = 0;
          // 打开设置弹框
          this.settingDialogController.open();
        })

        // 倒计时
        CountdownPage({
          countdownNum: $countdownNum
        })
        // 闪光灯
        FlashingLightPage()
        // 滤镜
        ColorEffectComponent()

        // 月亮模式
        MoonCaptureBoostComponent();

        // 分段式拍照
        DeferredPhotoComponent({
          surfaceId: this.surfaceId,
          cameraDeviceIndex: this.cameraDeviceIndex,
        })

      }
      .margin({ left: 24 })
      .alignItems(VerticalAlign.Top)
      .justifyContent(FlexAlign.Start)
      .position({ x: 0, y: 0 })
      .width('100%')
      .onClick(() => {
        this.cancelDialog();
      })
    }
    .onClick(() => {
      this.cancelDialog();
    })
    .size({ width: '100%', height: '100%' })
    .backgroundColor(Color.Black)
  }
}