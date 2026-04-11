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
import { window } from '@kit.ArkUI';

@Entry
@Component
struct SpecificSceneSetOrientationIndex {
  @State displayOrientation: number = 0;
  mainWindow: window.Window = AppStorage.get('mainWindow_SetOrientation') as window.Window;

  options: SelectOption[] = [
    { value: 'PORTRAIT', icon: '' },
    { value: 'LANDSCAPE', icon: '' },
    { value: 'PORTRAIT_INVERTED', icon: '' },
    { value: 'LANDSCAPE_INVERTED', icon: '' },
  ];
  setOrientation(displayOrientation: number) {
    try {
      let windowOrientation: number = this.mainWindow.convertOrientationAndRotation(
        window.RotationInfoType.DISPLAY_ORIENTATION,
        window.RotationInfoType.WINDOW_ORIENTATION,
        displayOrientation
      );
      let orientation: window.Orientation = window.Orientation.UNSPECIFIED; // 设置窗口方向旋转模式
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
          throw new Error('Invalid input value');
      }
      try {
        this.mainWindow.setPreferredOrientation(orientation, (err) => {
          if (err.code) {
            return;
          }
        });
      } catch (exception) {
        throw new Error(exception);
      }
    } catch (exception) {
      throw new Error(exception);
    }
  }

  build() {
    Column() {
      Text('lock display Orientation')
        .fontSize(17)

      Row() {
        Select(this.options)
          .selected(0)
          .onSelect((_index: number, value: string) => {
            this.displayOrientation = _index;
          })
        Button('Set the display orientation')
          .onClick(() => {
            console.info('demo click Create and Show Specific Window');
            this.setOrientation(this.displayOrientation);
          })
      }
      .justifyContent(FlexAlign.Center)   // Row内部居中
      .alignItems(VerticalAlign.Center)
    }
    .justifyContent(FlexAlign.Center)     // Column内部垂直居中
    .alignItems(HorizontalAlign.Center)   // Column内部水平居中
    .height('100%')
    .width('100%')
  }
}
// [End quick_start]