/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { TitleBar } from '../../../../common/TitleBar'

@Extend(Text) function leftTitleStyle() {
  .fontColor($r('app.color.sub_title_color'))
  .fontSize(14)
  .height(22)
  .alignSelf(ItemAlign.Start)
  .margin({ left: 12, top: 12 })
}

@Extend(Column) function cardStyle() {
  .backgroundColor(Color.White)
  .borderRadius(24)
  .width('100%')
  .padding(15)
}

@Entry
@Component
struct RatingSample {
  @State rating: number = 1
  @State indicator: boolean = false
  @State stars: number = 5

  build() {
    Column() {
      TitleBar({ title: $r('app.string.rating_name') })
      Text($r('app.string.normal_display'))
        .leftTitleStyle()
      Column() {
        Rating({ rating: this.rating, indicator: this.indicator })
          .stars(this.stars)
          .stepSize(0.5)
          .onChange((value: number) => {
            this.rating = value
          })
      }
      .cardStyle()
      .width('100%')

      Text($r('app.string.normal_options'))
        .leftTitleStyle()
      Column() {
        Row() {
          Text($r('app.string.rating_options_indicator'))
            .leftTitleStyle()
            .width('50%')
          Blank()
          Toggle({ type: ToggleType.Switch, isOn: this.indicator })
            .onChange((isOn) => {
              this.indicator = isOn
            })
        }.width('100%')
        .height(50)

        Row() {
          Text($r('app.string.rating_options_value'))
            .leftTitleStyle()
            .width('50%')
          Blank()
          Counter() {
            Text(this.rating.toString())
          }
          .onInc(() => {
            if (this.rating < this.stars)
              this.rating += 0.5 // 评分0.5
          })
          .onDec(() => {
            if (this.rating > 0)
              this.rating -= 0.5
          })
        }.width('100%')
        .height(50)

        Row() {
          Text($r('app.string.rating_options_stars'))
            .leftTitleStyle()
            .width('50%')
          Blank()
          Counter() {
            Text(this.stars.toString())
          }
          .onInc(() => {
            if (this.stars <= 8) // 总分为8
              this.stars++
          })
          .onDec(() => {
            if (this.stars > 1)
              this.stars--
          })
        }.width('100%')
        .height(50)
      }
      .cardStyle()
      .width('100%')

    }.height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_light_gray'))
    .padding({ left: 20, right: 20 })
  }
}
