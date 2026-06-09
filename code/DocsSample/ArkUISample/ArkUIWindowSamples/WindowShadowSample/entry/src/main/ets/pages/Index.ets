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
// [Start windowShadowSample]
// Index.ets
import { BusinessError } from '@kit.BasicServicesKit';
import { window } from '@kit.ArkUI';

let subWindowClass: window.Window | undefined = undefined;

@Entry
@Component
struct Index {
  // [StartExclude windowShadowSample]
  @State prompt: string = 'Tap the button to show a shadowed subwindow.';
  // [EndExclude windowShadowSample]

  build() {
    // [StartExclude windowShadowSample]
    Column({ space: 24 }) {
      Text('Window Shadow')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .fontColor('#182431')

      Text(this.prompt)
        .fontSize(16)
        .fontColor('#5A6677')

      Button('Show')
        .width(120)
        .height(48)
        .fontSize(16)
        .onClick(() => {
          this.showShadowSubWindow();
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#DDE4EC')
    // [EndExclude windowShadowSample]
  }

  private async showShadowSubWindow(): Promise<void> {
    let windowStage = AppStorage.get<window.WindowStage>('windowStage');
    if (!windowStage) {
      this.prompt = 'WindowStage is unavailable.';
      return;
    }

    try {
      if (!subWindowClass) {
        subWindowClass = await windowStage.createSubWindow('shadowSubWindow');
        await subWindowClass.moveWindowTo(220, 240);
        await subWindowClass.resize(800, 600);
        // 设置窗口边缘阴影：模糊半径为48px，半透明黑色，向右下方偏移20px。
        subWindowClass.setShadow(48, '#B0000000', 20, 20);
        await subWindowClass.setUIContent('pages/SubWindow');
      }
      await subWindowClass.showWindow();
      this.prompt = 'The subwindow is displayed with a shadow.';
    } catch (exception) {
      let err = exception as BusinessError;
      this.prompt = `Failed to set shadow: ${err.code}`;
      console.error(`Failed to show shadow subwindow. Cause code: ${err.code}, message: ${err.message}`);
    }
  }
}
// [End windowShadowSample]
