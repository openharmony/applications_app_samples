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
// [Start window_shadow_radius]
// pages/page1.ets
import { window } from '@kit.ArkUI';

@Entry
@Component
struct SliderDemo {
  // [StartExclude window_shadow_radius]
  @State shadowRadiusValue: number = 0;
  // [EndExclude window_shadow_radius]

  // 设置窗口边缘阴影的模糊半径
  setShadowRadius(val: number) {
    const floatWindowObj = AppStorage.get<window.Window>('floatWindow');
    floatWindowObj?.setWindowShadowRadius(val);
  }

  build() {
    // [StartExclude window_shadow_radius]
    Column({ space: 5 }) {
      Text(`Shadow Radius: ${this.shadowRadiusValue} px`)
        .fontSize(16)
      Slider({
        value: this.shadowRadiusValue,
        min: 0,
        max: 100,
        step: 1
      })
        .onChange((val: number) => {
          this.shadowRadiusValue = val;
          this.setShadowRadius(val);
        })
    }
    .padding(20)
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Orange)
    .justifyContent(FlexAlign.Center)      // 垂直居中
    .alignItems(HorizontalAlign.Center)    // 水平居中
    // [EndExclude window_shadow_radius]
  }
}
// [End window_shadow_radius]
