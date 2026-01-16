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

// [Start Special_Characters_Display_Incorrectly]
@Entry
@Component
export struct SpecialCharactersDisplayIncorrectlyExample {
  @State message: string = '昵称\ud808\ude6d';

  build() {
    NavDestination() {
      Column() {
        Row({ space: 20 }) {
          Text('昵称')
            .borderWidth(1)
            .height(20)

          Text(this.message)
            .height(20)
            .borderWidth(1)

          Text(this.message)
            .height(20)
            .borderWidth(1)
            .halfLeading(true)
            .lineHeight(16)
        }
        .padding(20)
      }
      .justifyContent(FlexAlign.Center)
      .height('100%')
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.Special_Characters_Display_Incorrectly'))
  }
}

// [End Special_Characters_Display_Incorrectly]