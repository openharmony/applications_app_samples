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

// [Start quick_start]
import { display, window } from '@kit.ArkUI';

@Entry
@Component
struct SpecificSceneSetOrientationIndex {
  mainWindow: window.Window = AppStorage.get('mainWindow_SetOrientation') as window.Window;

  setOrientationByDisplay() {
    try {
      // ① 获取当前默认 Display
      const disp = display.getDefaultDisplaySync();
      const displayOrientation = disp.orientation; // 当前屏幕方向（0/1/2/3）

      console.info("Current display orientation = " + displayOrientation);

      // ② 将 displayOrientation 转换为 windowOrientation
      let windowOrientation: number =
        this.mainWindow.convertOrientationAndRotation(
          window.RotationInfoType.DISPLAY_ORIENTATION,
          window.RotationInfoType.WINDOW_ORIENTATION,
          displayOrientation
        );

      // ③ 根据 windowOrientation 映射到 window.Orientation
      let orientation: window.Orientation = window.Orientation.UNSPECIFIED;

      switch (windowOrientation) {
        case 0:
          orientation = window.Orientation.PORTRAIT;
          break;
        case 1:
          orientation = window.Orientation.LANDSCAPE_INVERTED;
          break;
        case 2:
          orientation = window.Orientation.PORTRAIT_INVERTED;
          break;
        case 3:
          orientation = window.Orientation.LANDSCAPE;
          break;
        default:
          throw new Error("Invalid orientation value");
      }

      // ④ 设置窗口方向
      this.mainWindow.setPreferredOrientation(orientation, (err) => {
        if (err && err.code) {
          console.error("setPreferredOrientation failed: " + JSON.stringify(err));
        }
      });

    } catch (exception) {
      console.error("Exception in setOrientationByDisplay: " + JSON.stringify(exception));
    }
  }

  build() {
    Column() {
      Text("Lock the display orientation")
        .fontSize(17)

      Button('Set orientation from display')
        .onClick(() => {
          console.info('Click: Set orientation from display');
          this.setOrientationByDisplay();
        })
        .margin({ top: 20 })
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .height('100%')
    .width('100%')
  }
}
// [End quick_start]