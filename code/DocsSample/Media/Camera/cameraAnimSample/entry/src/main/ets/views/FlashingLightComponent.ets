/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 ("the License");
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

import { camera } from '@kit.CameraKit';
import Logger from '../common/utils/Logger';
import CameraService from '../mode/CameraService';

const TAG: string = 'FlashingLightComponent';

interface WhiteBalance {
  auto: string;
  manual: string;
  cloudy: string;
  white: string;
  fluorescence: string;
  sunlight: string;
}

// 闪关灯页面
@Component
export struct FlashingLightComponent {
  // 闪光灯模式
  @Link @Watch('flashModeChange') flashMode: camera.FlashMode;
  @State flashIconResource: Resource = $r('app.media.ic_camera_public_flash_off');

  @State isControlEnable: boolean = false;
  @State isMacroEnable: boolean = false;

  // Page judgment
  @State showOptions: boolean = false;
  @State firstBol: boolean = true;
  // WhiteBalance mode
  @State whiteBalanceNum: number = 0;
  private whiteBalance: WhiteBalance = {
    auto: '自动',
    manual: '手动',
    cloudy: '阴天',
    white: '白炽光',
    fluorescence: '荧光',
    sunlight: '日光'
  };

  // Apply white balance setting
  applyWhiteBalanceSetting(whiteBalance: number) {
    this.whiteBalanceNum = whiteBalance;
    this.showOptions = false;

    CameraService.setWhiteBalanceMode(whiteBalance);
    console.info(`white balance set to ${whiteBalance}`);
  }

  // Return to selected image
  getTextDefault() {
    if (this.whiteBalanceNum == 0) {
      return this.whiteBalance.auto;
    }
    if (this.whiteBalanceNum == 1) {
      return this.whiteBalance.cloudy;
    }
    if (this.whiteBalanceNum == 2) {
      return this.whiteBalance.white;
    }
    if (this.whiteBalanceNum == 3) {
      return this.whiteBalance.fluorescence;
    }
    if (this.whiteBalanceNum == 4) {
      return this.whiteBalance.sunlight;
    }
    if (this.whiteBalanceNum == 5) {
      return this.whiteBalance.manual;
    }
    return;
  }


  flashModeChange(): void {
    switch (this.flashMode) {
      case camera.FlashMode.FLASH_MODE_OPEN:
        this.flashIconResource = $r('app.media.ic_camera_public_flash_on');
        break;
      case camera.FlashMode.FLASH_MODE_AUTO:
        this.flashIconResource = $r('app.media.ic_camera_public_flash_auto');
        break;
      case camera.FlashMode.FLASH_MODE_ALWAYS_OPEN:
        this.flashIconResource = $r('app.media.flash_always_on');
        break;
      case camera.FlashMode.FLASH_MODE_CLOSE:
      default:
        this.flashIconResource = $r('app.media.ic_camera_public_flash_off');
    }
  }

  build() {
    Row() {
      Row() {
        Button() {
          Image(this.flashIconResource)
            .width($r('app.string.200px'))
            .height($r('app.string.200px'))
            .fillColor($r('app.color.white'))
        }
        .width($r('app.string.200px'))
        .height($r('app.string.200px'))
        .backgroundColor($r('app.color.flash_background_color'))
        .borderRadius($r('app.string.50px'))
        .onClick(() => {
          this.flashMode = (this.flashMode + 1) % 4;
          Logger.info(TAG, `flashMode: ${this.flashMode}`);
          CameraService.hasFlashFn(this.flashMode);
        })
      }

      Button() {
        Text('相机控制器')
      }
      .width(80)
      .height(60)
      .backgroundColor($r(this.isControlEnable? 'app.color.white' : 'app.color.flash_background_color'))
      .onClick(() => {
        if (CameraService.isControlCenterSupport()) {
          this.isControlEnable = !this.isControlEnable;
          CameraService.enableControlCenter(this.isControlEnable);
        } else {
          this.isControlEnable = false;
        }
      })
      .position({x: '20%', y: '0%'})

      Button() {
        Text('微距')
      }
      .width(60)
      .height(60)
      .backgroundColor($r(this.isMacroEnable? 'app.color.white' : 'app.color.flash_background_color'))
      .onClick(() => {
        if (CameraService.isMacroSupport()) {
          this.isMacroEnable = !this.isMacroEnable;
          CameraService.enableMacro(this.isMacroEnable);
        } else {
          this.isMacroEnable = false;
        }
      })
      .position({x: '50%', y: '0%'})

      // WhiteBalanceMode
      Column() {
        // 主按钮
        Text('白平衡')
          .fontSize(16)
          .fontColor('#FFFFFF')
          .backgroundColor(Color.Transparent)
          .borderRadius('20px')
          .textAlign(TextAlign.Center)
          .width('20%')
          .height('40px')
          .onClick(() => {
            this.showOptions = !this.showOptions;
          })
        // 选项面板 - 垂直排列在主按钮下方
        if (this.showOptions) {
          Column() {
            Text('自动')
              .fontSize(16)
              .fontColor(this.whiteBalanceNum === 0 ? '#FFFFFF' : '#CCCCCC')
              .backgroundColor(Color.Transparent)
              .borderRadius('20px')
              .textAlign(TextAlign.Center)
              .margin({ top: '2px' })
              .width('100%')
              .height('60px')
              .onClick(() => {
                this.firstBol = !this.firstBol;
                this.applyWhiteBalanceSetting(0);
              })
              .margin({ bottom: '8px' })

            Text('阴天')
              .fontSize(16)
              .fontColor(this.whiteBalanceNum === 1 ? '#FFFFFF' : '#CCCCCC')
              .borderRadius('20px')
              .textAlign(TextAlign.Center)
              .margin({ top: '2px' })
              .width('100%')
              .height('60px')
              .onClick(() => {
                this.firstBol = !this.firstBol;
                this.applyWhiteBalanceSetting(1);
              })

            Text('白炽光')
              .fontSize(16)
              .fontColor(this.whiteBalanceNum === 2 ? '#FFFFFF' : '#CCCCCC')
              .borderRadius('20px')
              .textAlign(TextAlign.Center)
              .margin({ top: '2px' })
              .width('100%')
              .height('60px')
              .onClick(() => {
                this.firstBol = !this.firstBol;
                this.applyWhiteBalanceSetting(2);
              })

            Text('荧光')
              .fontSize(16)
              .fontColor(this.whiteBalanceNum === 3 ? '#FFFFFF' : '#CCCCCC')
              .borderRadius('20px')
              .textAlign(TextAlign.Center)
              .margin({ top: '2px' })
              .width('100%')
              .height('60px')
              .onClick(() => {
                this.firstBol = !this.firstBol;
                this.applyWhiteBalanceSetting(3);
              })

            Text('日光')
              .fontSize(16)
              .fontColor(this.whiteBalanceNum === 4 ? '#FFFFFF' : '#CCCCCC')
              .borderRadius('20px')
              .textAlign(TextAlign.Center)
              .margin({ top: '2px' })
              .width('100%')
              .height('60px')
              .onClick(() => {
                this.firstBol = !this.firstBol;
                this.applyWhiteBalanceSetting(4);
              })

            Text('手动')
              .fontSize(16)
              .fontColor(this.whiteBalanceNum === 5 ? '#FFFFFF' : '#CCCCCC')
              .borderRadius('20px')
              .textAlign(TextAlign.Center)
              .margin({ top: '2px' })
              .width('100%')
              .height('60px')
              .onClick(() => {
                this.firstBol = !this.firstBol;
                this.applyWhiteBalanceSetting(5);
              })
          }
          .backgroundColor('rgba(0,0,0,0.3)')
          .borderRadius('25px')
          .padding({ top: '12px', bottom: '12px' })
          .margin({ top: '8px' })  // 与主按钮的间距
          .width('160px')
          .height('300px')
          .alignItems(HorizontalAlign.Center)
          .zIndex(999)
          .shadow({ radius: 10, color: '#00000030', offsetX: 0, offsetY: 2 })
        }
      }
      .position({ x: '70%', y: '2.5%' })
      .id('WhiteBalanceButton')
    }
  }
}