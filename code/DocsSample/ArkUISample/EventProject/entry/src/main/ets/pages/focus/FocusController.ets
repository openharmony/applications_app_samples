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
import { ColorMetrics, LengthMetrics } from '@kit.ArkUI';

@Entry
@Component
export struct FocusControl {
  @State btColor: string = '#ff2787d9';
  @State btColor2: string = '#ff2787d9';

  build() {
    NavDestination() {
      Column({ space: 12 }) {

        Column({ space: 20 }) {
          Column({ space: 5 }) {
            Button('Button')
              .width(200)
              .height(70)
              .fontColor(Color.White)
              .focusOnTouch(true)
              .backgroundColor(this.btColor)
              .onFocus(() => {
                this.btColor = '#ffd5d5d5';
              })
              .onBlur(() => {
                this.btColor = '#ff2787d9';
              })
              .id('testButton')

            Button('Button')
              .width(200)
              .height(70)
              .fontColor(Color.White)
              .focusOnTouch(true)
              .backgroundColor(this.btColor2)
              .onFocus(() => {
                this.btColor2 = '#ffd5d5d5';
              })
              .onBlur(() => {
                this.btColor2 = '#ff2787d9';
              })
              .id('testButton2')

            Divider()
              .vertical(false)
              .width('80%')
              .backgroundColor('#ff707070')
              .height(10)

            Button('FocusController.requestFocus')
              .width(200).height(70).fontColor(Color.White)
              .onClick(() => {
                this.getUIContext().getFocusController().requestFocus('testButton');
              })
              .backgroundColor('#ff2787d9')

            Button('focusControl.requestFocus')
              .width(200).height(70).fontColor(Color.White)
              .onClick(() => {
                focusControl.requestFocus('testButton2');
              })
              .backgroundColor('#ff2787d9')

            Button('clearFocus')
              .width(200).height(70).fontColor(Color.White)
              .onClick(() => {
                this.getUIContext().getFocusController().clearFocus();
              })
              .backgroundColor('#ff2787d9')
          }
        }
        .width('100%')
        .height('100%')

      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.Focus_FocusController_title'))
  }
}