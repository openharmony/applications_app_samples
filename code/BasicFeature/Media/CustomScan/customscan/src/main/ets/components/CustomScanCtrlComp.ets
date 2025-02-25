/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { BreakpointConstants } from '../common/constants/BreakpointConstants';
import CommonConstants from '../common/constants/CommonConstants';
import CustomScanViewModel, { ScanResults } from '../viewmodel/CustomScanViewModel';
import { MaskLayer } from './MaskLayer';
import { ScanLine } from './ScanLine';
import { CodeLayout } from './CommonCodeLayout';
import { ScanSize, XComponentSize } from '../model/ScanSize';
import { PromptTone } from '../model/PromptTone';
import { common } from '@kit.AbilityKit';

/**
 * 扫码控制组件
 */
@Component
export default struct CustomScanCtrlComp {
  @StorageLink('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;
  @Consume('subPageStack') subPageStack: NavPathStack;
  // 自定义扫码vm实例
  @Consume('customScanVM') customScanVM: CustomScanViewModel;
  @State scanSize: ScanSize = ScanSize.getInstance();
  @State xComponentSize: XComponentSize = this.scanSize.xComponentSize;
  // 相机闪光灯开启状态
  @State isCameraLightOpen: boolean = false;
  // 识别音效播放器
  @State avPlayer: PromptTone = PromptTone.getInstance(getContext(this) as common.UIAbilityContext)

  aboutToAppear() {
    // 注册闪光灯状态回调
    this.customScanVM.regCameraLightUpdateListener((isOpen: boolean) => {
      this.isCameraLightOpen = isOpen;
    })
  }

  build() {
    Stack() {
      Column() {
        Row() {
          // 自定义图库按钮
          Image($r('app.media.custom_scan_picture'))
            .width(CommonConstants.SCAN_CTRL_BTN_CLOSE_SIZE)
            .height(CommonConstants.SCAN_CTRL_BTN_CLOSE_SIZE)
            .fillColor(Color.White)
            .backgroundColor(Color.Gray)
            .alignSelf(ItemAlign.Start)
            .margin({
              top: $r('app.integer.custom_scan_btn_scan_close_margin_top'),
              right: $r('app.integer.custom_scan_btn_scan_close_margin_left')
            })
            .padding($r('app.integer.custom_scan_btn_scan_close_padding'))
            .clip(new Circle({
              width: CommonConstants.SCAN_CTRL_BTN_CLOSE_SIZE,
              height: CommonConstants.SCAN_CTRL_BTN_CLOSE_SIZE
            }))
            .onClick(async () => {
              // 识别图库照片
              const detectResult = await this.customScanVM.detectFromPhotoPicker();
              if (!detectResult) {
                return;
              }

              // 二维码识别结果展示
              this.subPageStack.pushPathByName(CommonConstants.SUB_PAGE_DETECT_BARCODE, detectResult, true);
            })
        }
        .width('100%')
        .direction(Direction.Rtl)

        Column() {
          this.ScanLineBuilder()
        }.layoutWeight(1)

        // 扫描二维码文案
        Text($r('app.string.custom_scan_text_put_code_to_scan'))
          .height($r('app.string.custom_scan_text_scan_height'))
          .fontSize($r('app.integer.custom_scan_text_scan_font_size'))
          .fontColor(Color.White)
          .margin({ top: $r('app.integer.custom_scan_text_scan_margin_top') })

        // 闪光灯按钮，启动相机流后才能使用
        Image($r('app.media.custom_scan_camera_light'))
          .width(CommonConstants.SCAN_CTRL_BTN_LIGHT_SIZE)
          .height(CommonConstants.SCAN_CTRL_BTN_LIGHT_SIZE)
          .fillColor(this.isCameraLightOpen ? Color.Yellow : Color.White)
          .onClick(() => {
            this.customScanVM.updateFlashLightStatus();
          })

        Blank().height($r('app.string.custom_scan_10_percent'))
      }

      this.CodeLayoutBuilder();
    }
    .width('100%')
    .height('100%')
  }

  /**
   * 扫描动画
   * @returns {void}
   */
  @Builder
  ScanLineBuilder() {
    if (this.customScanVM.isScanLine) {
      Column() {
        ScanLine()
          .constraintSize({
            minHeight: 100
          })
      }
      .justifyContent(FlexAlign.Center)
      .width('100%')
    }
  }

  @Builder
  CodeLayoutBuilder() {
    // 扫描到二维码后展示二维码位置
    if (this.customScanVM.isScanned) {
      MaskLayer()
      Column() {
        CodeLayout({
          xComponentSize: this.xComponentSize,
          navHeight: this.scanSize.navHeight,
          scanResults: this.customScanVM.scanResult,
          avPlayer: this.avPlayer
        })
      }
    }
  }
}
