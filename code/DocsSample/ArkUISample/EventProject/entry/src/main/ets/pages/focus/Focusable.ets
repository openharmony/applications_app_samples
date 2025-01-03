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

@Entry
@Component
export struct FocusableExample {
  @State textFocusable: boolean = true;
  @State textEnabled: boolean = true;
  @State color1: Color = Color.Yellow;
  @State color2: Color = Color.Yellow;
  @State color3: Color = Color.Yellow;

  build() {
    NavDestination() {
      Column({ space: 12 }) {

        Text($r('app.string.Focus_Focusable_text'))
          .fontSize(14)
          .fontColor('#666')
        Column({ space: 5 }) {
          Text('Default Text')    // 第一个Text组件未设置focusable属性，默认不可获焦
            .borderColor(this.color1)
            .borderWidth(2)
            .width(300)
            .height(70)
            .onFocus(() => {
              this.color1 = Color.Blue;
            })
            .onBlur(() => {
              this.color1 = Color.Yellow;
            })
          Divider()

          Text('focusable: ' + this.textFocusable)    // 第二个Text设置了focusable初始为true，focusableOnTouch为true
            .borderColor(this.color2)
            .borderWidth(2)
            .width(300)
            .height(70)
            .focusable(this.textFocusable)
            .focusOnTouch(true)
            .onFocus(() => {
              this.color2 = Color.Blue;
            })
            .onBlur(() => {
              this.color2 = Color.Yellow;
            })

          Text('enabled: ' + this.textEnabled)    // 第三个Text设置了focusable为true，enabled初始为true
            .borderColor(this.color3)
            .borderWidth(2)
            .width(300)
            .height(70)
            .focusable(true)
            .enabled(this.textEnabled)
            .focusOnTouch(true)
            .onFocus(() => {
              this.color3 = Color.Blue;
            })
            .onBlur(() => {
              this.color3 = Color.Yellow;
            })

          Divider()

          Row() {
            Button('Button1')
              .width(140).height(70)
            Button('Button2')
              .width(160).height(70)
          }

          Divider()
          Button('Button3')
            .width(300).height(70)

          Divider()
        }.width('100%').justifyContent(FlexAlign.Center)
        .onKeyEvent((e) => {
          // 绑定onKeyEvent，在该Column组件获焦时，按下'F'键，可将第二个Text的focusable置反
          if (e.keyCode === 2022 && e.type === KeyType.Down) {
            this.textFocusable = !this.textFocusable;
          }
          // 绑定onKeyEvent，在该Column组件获焦时，按下'G'键，可将第三个Text的enabled置反
          if (e.keyCode === 2023 && e.type === KeyType.Down) {
            this.textEnabled = !this.textEnabled;
          }
        })

      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.Focus_Focusable_title'))
  }
}