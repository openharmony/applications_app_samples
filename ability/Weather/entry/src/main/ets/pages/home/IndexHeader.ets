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

import Style from '../../util/Style'

@Component
export default struct IndexHeader {
  @Prop currentWeather: number

  build() {
    Column() {
      Row() {
        Text($r('app.string.Hangzhou_city'))
          .fontColor(Color.White)
          .fontWeight(FontWeight.Regular)
          .fontSize(18)
        Image($r('app.media.icon_location'))
          .size({ width: 16, height: 16 })
          .objectFit(ImageFit.Contain)
      }

      Row() {
        Text(`${this.currentWeather}`)
          .fontColor(Color.White)
          .fontWeight(Style.BIG_FONT_WEIGHT)
          .fontSize(96)
        Text($r('app.string.du'))
          .fontColor(Color.White)
          .fontWeight(FontWeight.Regular)
          .fontSize(35)
          .margin({ bottom: 36 })
      }
      .margin({ top: 4 })
      .padding({ left: 35 })

      Row() {
        Text($r('app.string.highest_temperature'))
          .fontColor(Color.White)
          .fontWeight(FontWeight.Medium)
          .fontSize(16)
        Text($r('app.string.lowest_temperature'))
          .fontColor('#99FFFFFF')
          .fontWeight(FontWeight.Medium)
          .fontSize(16)
      }
      .margin({ top: 6 })

      Row() {
        Text($r('app.string.weather_type'))
          .fontColor(Color.White)
          .fontWeight(FontWeight.Medium)
          .fontSize(16)
        Text($r('app.string.air'))
          .fontColor(Color.White)
          .fontWeight(FontWeight.Medium)
          .fontSize(16)
        Text($r('app.string.air_quality'))
          .fontColor(Color.White)
          .fontWeight(FontWeight.Medium)
          .fontSize(16)
      }
      .margin({ top: 6 })

      Row() {
        Image($r('app.media.icon_message'))
          .width(24)
          .height(24)
          .objectFit(ImageFit.Contain)
        Text($r('app.string.airTips'))
          .fontColor(Color.White)
          .fontSize(12)
          .margin({ left: 8 })
      }
      .width('100%')
      .margin({ top: 48 })
    }
    .width('100%')
    .margin({ top: 30 })
  }
}