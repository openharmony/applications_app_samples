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

// Frame rate setting page
import cameraDemo from 'libentry.so';
import Logger from '../model/Logger';

const TAG: string = 'CameraSample';

@Component
export struct VideoRatePage {
  // Page state: true=显示主按钮, false=显示选项面板
  @State showOptions: boolean = false;
  // Current frame rate: 0=15FPS, 1=30FPS
  @State currentFrameRate: number = 0;

  // Get current frame rate text
  getCurrentFrameRateText(): string {
    return this.currentFrameRate === 0 ? '15 fps' : '30 fps';
  }

  // Apply frame rate setting
  applyFrameRateSetting(frameRate: number) {
    this.currentFrameRate = frameRate;
    this.showOptions = false;

    // 调用Native方法设置帧率
    const fpsValue = frameRate === 0 ? 15 : 30;
    Logger.info(TAG, `Setting frame rate to: ${fpsValue}FPS`);

    // 调用NDK侧接口
    if (cameraDemo) {
      cameraDemo.setFrameRate(fpsValue, fpsValue);
    } else {
      Logger.info(TAG, `Simulated: Frame rate set to ${fpsValue}FPS`);
    }
  }

  build() {
    Column() {
      // 主按钮
      Text(this.getCurrentFrameRateText())
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
          // 15FPS选项
          Text('15 fps')
            .fontSize(16)
            .fontColor(this.currentFrameRate === 0 ? '#FFFFFF' : '#CCCCCC')
            .backgroundColor(Color.Transparent)
            .borderRadius('20px')
            .textAlign(TextAlign.Center)
            .width('100%')
            .height('40px')
            .onClick(() => {
              this.applyFrameRateSetting(0);
            })
            .margin({ bottom: '8px' })

          // 30FPS选项
          Text('30 fps')
            .fontSize(16)
            .fontColor(this.currentFrameRate === 1 ? '#FFFFFF' : '#CCCCCC')
            .borderRadius('20px')
            .textAlign(TextAlign.Center)
            .width('100%')
            .height('40px')
            .onClick(() => {
              this.applyFrameRateSetting(1);
            })
        }
        .backgroundColor('rgba(0,0,0,0.3)')
        .borderRadius('25px')
        .padding({ top: '12px', bottom: '12px' })
        .margin({ top: '8px' })  // 与主按钮的间距
        .width('160px')
        .height('120px')
        .alignItems(HorizontalAlign.Center)
        .zIndex(999)
        .shadow({ radius: 10, color: '#00000030', offsetX: 0, offsetY: 2 })
      }
    }
    .position({ x: '5%', y: '3%' })
    .id('FrameRateButton')
  }
}