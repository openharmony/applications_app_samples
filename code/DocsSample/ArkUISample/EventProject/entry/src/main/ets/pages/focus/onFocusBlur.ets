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
 
import { KeyCode } from '@kit.InputKit';

// [Start focus_dynamic_reflect]
@Entry
@Component
export struct OnFocusBlur {
  @State oneButtonColor: Color = Color.Gray;
  @State twoButtonColor: Color = Color.Gray;
  @State threeButtonColor: Color = Color.Gray;

  build() {
    NavDestination() {
      Column({ space: 12 }) {

        Column({ space: 20 }) {
          // 通过外接键盘的上下键可以让焦点在三个按钮间移动，按钮获焦时颜色变化，失焦时变回原背景色
          Button('First Button')
            .width(260)
            .height(70)
            .backgroundColor(this.oneButtonColor)
            .fontColor(Color.Black)
              // 监听第一个组件的获焦事件，获焦后改变颜色
            .onFocus(() => {
              this.oneButtonColor = Color.Green;
            })
              // 监听第一个组件的失焦事件，失焦后改变颜色
            .onBlur(() => {
              this.oneButtonColor = Color.Gray;
            })

          Button('Second Button')
            .width(260)
            .height(70)
            .backgroundColor(this.twoButtonColor)
            .fontColor(Color.Black)
              // 监听第二个组件的获焦事件，获焦后改变颜色
            .onFocus(() => {
              this.twoButtonColor = Color.Green;
            })
              // 监听第二个组件的失焦事件，失焦后改变颜色
            .onBlur(() => {
              this.twoButtonColor = Color.Grey;
            })

          Button('Third Button')
            .width(260)
            .height(70)
            .backgroundColor(this.threeButtonColor)
            .fontColor(Color.Black)
              // 监听第三个组件的获焦事件，获焦后改变颜色
            .onFocus(() => {
              this.threeButtonColor = Color.Green;
            })
              // 监听第三个组件的失焦事件，失焦后改变颜色
            .onBlur(() => {
              this.threeButtonColor = Color.Gray;
            })
        }.width('100%').margin({ top: 20 })

      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.Focus_OnFocusBlur_title'))
  }
}
// [End focus_dynamic_reflect]