/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

// [Start windowBrightness_srart]

import { window } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;

@Entry
@Component
struct Index {
  @State brightnessValue: number = 0.5;
  @State keepScreenOn: boolean = false;
  @State statusText: string = 'Adjust window brightness or keep-screen-on.';

  private currentWindow?: window.Window = undefined;

  aboutToAppear(): void {
    void this.initWindow();
  }

  // 获取当前应用窗口，后续通过 Window 对象设置窗口亮度和常亮状态。
  private async initWindow(): Promise<void> {
    try {
      const hostContext = this.getUIContext().getHostContext();
      if (!hostContext) {
        throw new Error('Host context is unavailable.');
      }

      const context = hostContext as common.UIAbilityContext;
      this.currentWindow = await window.getLastWindow(context);

      const windowId = this.currentWindow.getWindowProperties().id;
      this.statusText = `window ready, id=${windowId}`;
      hilog.info(DOMAIN, 'windowBrightness', this.statusText);
    } catch (err) {
      this.statusText = `initWindow failed: ${JSON.stringify(err)}`;
      hilog.error(DOMAIN, 'windowBrightness', this.statusText);
    }
  }

  // 调用接口前确认窗口对象已初始化。
  private async ensureWindow(): Promise<boolean> {
    if (!this.currentWindow) {
      await this.initWindow();
    }

    if (!this.currentWindow) {
      this.statusText = 'current window is unavailable.';
      return false;
    }

    return true;
  }

  // 设置当前窗口亮度，取值范围为 0 到 1；传入 -1 可恢复为系统屏幕亮度。
  private async applyBrightness(): Promise<void> {
    if (!await this.ensureWindow()) {
      return;
    }

    try {
      await this.currentWindow!.setWindowBrightness(this.brightnessValue);
      this.statusText = `setWindowBrightness(${this.brightnessValue.toFixed(2)}) success`;
      hilog.info(DOMAIN, 'windowBrightness', this.statusText);
    } catch (err) {
      this.statusText = `setWindowBrightness failed: ${JSON.stringify(err)}`;
      hilog.error(DOMAIN, 'windowBrightness', this.statusText);
    }
  }

  // 设置当前窗口在前台时是否保持屏幕常亮。
  private async applyKeepScreenOn(value: boolean): Promise<void> {
    if (!await this.ensureWindow()) {
      return;
    }

    try {
      this.keepScreenOn = value;
      await this.currentWindow!.setWindowKeepScreenOn(value);
      this.statusText = `setWindowKeepScreenOn(${value}) success`;
      hilog.info(DOMAIN, 'windowBrightness', this.statusText);
    } catch (err) {
      this.statusText = `setWindowKeepScreenOn failed: ${JSON.stringify(err)}`;
      hilog.error(DOMAIN, 'windowBrightness', this.statusText);
    }
  }

  build() {
    Column({ space: 16 }) {
      Text('Brightness and Keep Screen On')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .textAlign(TextAlign.Start)

      Text(`Brightness: ${this.brightnessValue.toFixed(2)}`)
        .width('100%')
        .fontSize(16)
        .textAlign(TextAlign.Start)

      Slider({
        value: this.brightnessValue,
        min: 0,
        max: 1,
        step: 0.01
      })
        .width('100%')
        .showTips(true)
        .onChange((value: number) => {
          this.brightnessValue = value;
        })

      Button('Apply Brightness')
        .width('100%')
        .onClick(() => {
          void this.applyBrightness();
        })

      Row() {
        Text(`Keep screen on: ${this.keepScreenOn}`)
          .layoutWeight(1)
          .fontSize(16)

        Toggle({ type: ToggleType.Switch, isOn: this.keepScreenOn })
          .onChange((value: boolean) => {
            void this.applyKeepScreenOn(value);
          })
      }
      .width('100%')

      Text(this.statusText)
        .width('100%')
        .fontSize(14)
        .textAlign(TextAlign.Start)
    }
    .width('100%')
    .height('100%')
    .padding(20)
    .alignItems(HorizontalAlign.Start)
  }
}
// [End windowBrightness_srart]