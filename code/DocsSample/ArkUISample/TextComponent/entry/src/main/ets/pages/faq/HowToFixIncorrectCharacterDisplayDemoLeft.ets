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

// [Start How_To_Fix_Incorrect_Character_Display_Demo_Left]
@Entry
@Component
export struct HowToFixIncorrectCharacterDisplayDemoLeftExample {
  @State messageAr: string = '(+86)123 4567 890اللغة العربية';

  build() {
    NavDestination() {
      Column({ space: 20 }) {
        Text(this.messageAr)
          .direction(Direction.Ltr)
          .width(300)
          .height(30)
          .backgroundColor('rgb(39, 135, 217)')
      }
      .height('100%')
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.How_To_Fix_Incorrect_Character_Display_Demo_Left'))
  }
}

// [End How_To_Fix_Incorrect_Character_Display_Demo_Left]