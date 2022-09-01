/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import router from '@ohos.router'
import CityGrid from './addCity/CityGrid'
import Style from '../util/Style'

@Entry
@Component
struct AddCity {
  build() {
    Column() {
      Row() {
        Image($r('app.media.icon_back'))
          .width(24)
          .margin({ left: 26 })
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            router.back()
          })
        Text($r('app.string.add_city'))
          .fontSize(20)
          .margin({ left: Style.NORMAL_MARGIN })
      }
      .width('100%')
      .height(56)

      Scroll() {
        CityGrid()
      }
      .layoutWeight(1)
      .margin({ top: 18 })
      .scrollBar(BarState.Off)
    }
    .height('100%')
    .backgroundColor('#F1F3F5')
  }
}