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
// [Start Content_Transition]

@Entry
@Component
export struct ContentTransition {
  private static readonly INITIAL_SCORE: number = 98;
  @State number: number = ContentTransition.INITIAL_SCORE;
  @State numberTransition: NumericTextTransition =
    new NumericTextTransition({ flipDirection: FlipDirection.DOWN, enableBlur: false });
  build() {
    NavDestination() {
      Column() {
        Text(this.number + '')
          .borderWidth(1)
          .fontSize(40)
          .contentTransition(this.numberTransition)
        Button('chang number')
          .onClick(() => {
            this.number++
          })
          .margin(10)
      }
      .width('100%')
      .height('100%')
    }
    // [StartExclude Content_Transition]
    .backgroundColor('#f1f 2f3')
    .title($r('app.string.Set_digital_flip_effect'))
    // [EndExclude Content_Transition]
  }
}

// [End Content_Transition]