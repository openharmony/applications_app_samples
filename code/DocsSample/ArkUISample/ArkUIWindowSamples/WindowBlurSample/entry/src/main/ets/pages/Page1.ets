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
// [Start window_blur_effect]
// pages/page1.ets
import { window } from '@kit.ArkUI';

@Entry
@Component
struct SliderDemo {
  // [StartExclude window_blur_effect]
  @State blurValue: number = 0;
  @State backdropBlurValue: number = 0;
  @State columnBg: Color = Color.Orange;

  setColumnBg() {
    this.columnBg = Color.Orange;
  }
  // [EndExclude window_blur_effect]

  // 设置窗口内容的模糊半径
  setBlur(val: number) {
    this.setColumnBg();
    const floatWindowObj = AppStorage.get<window.Window>('floatWindow');
    floatWindowObj?.setBlur(val);
  }
  // 设置窗口背景的模糊半径
  setBackdropBlur(val: number) {
    this.columnBg = Color.Transparent;
    const floatWindowObj = AppStorage.get<window.Window>('floatWindow');
    floatWindowObj?.setWindowBackgroundColor('#00FFFFFF');
    floatWindowObj?.setBackdropBlur(val);
  }

  build() {
    // [StartExclude window_blur_effect]
    Column({ space: 5 }) {
      Text(`Blur: ${this.blurValue} px`)
        .fontSize(16)
      Slider({
        value: this.blurValue,
        min: 0,
        max: 100,
        step: 1
      })
        .onChange((val: number) => {
          this.blurValue = val;
          this.setBlur(val);
        })
      Text(`BackdropBlur: ${this.backdropBlurValue} px`)
        .fontSize(16)
      Slider({
        value: this.backdropBlurValue,
        min: 0,
        max: 100,
        step: 1
      })
        .onChange((val: number) => {
          this.backdropBlurValue = val;
          this.setBackdropBlur(val);
        })
    }
    .padding(20)
    .width('100%')
    .height('100%')
    .backgroundColor(this.columnBg)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    // [EndExclude window_blur_effect]
  }
}
// [End window_blur_effect]
