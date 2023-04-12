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

import { getWeekWeatherData, MyDataSource, WeekWeather, Style } from '@ohos/common'

@Preview
@Component
export default struct MultidayWeather {
  private weekData: WeekWeather[] = getWeekWeatherData(0)
  @State weekDataResource: MyDataSource = new MyDataSource(this.weekData)

  build() {
    List() {
      LazyForEach(this.weekDataResource, (item, index) => {
        ListItem() {
          DayWeatherItem({weatherInfo: item, index: index})
            .opacity(index === 0 ? 0.6 : 1)
            .width(Style.WEATHER_ITEM_WIDTH)
            .padding({ top: 16, bottom: 13 })
        }
      }, item => item.week)
    }
    .width('100%')
    .height(Style.CARD_HEIGHT)
    .listDirection(Axis.Horizontal)
    .borderRadius(Style.NORMAL_RADIUS)
    .backgroundColor(Style.CARD_BACKGROUND_COLOR)
  }

  aboutToAppear() {
    this.weekDataResource['dataArray'] = this.weekData
  }
}

@Component
struct DayWeatherItem {
  private index: number;
  private weatherInfo: WeekWeather;

  build() {
    Column() {
      Text(this.index === 0 ? $r('app.string.yestoday') : this.index === 1 ? $r('app.string.today') : this.weatherInfo.week)
        .fontSize(12)
        .fontColor(Color.White)
      Text(this.weatherInfo.date)
        .fontSize(10)
        .fontColor(Color.White)
        .margin({ top: 4 })
      Row() {
        Image(this.weatherInfo.icon)
          .width(28)
          .height(28)
          .objectFit(ImageFit.Contain)
      }
      .margin({ top: 8 })
      .justifyContent(FlexAlign.Center)

      Text(this.weatherInfo.weather)
        .fontSize(12)
        .fontColor(Color.White)
        .margin({ top: 8 })
      Text(`${this.weatherInfo.min}°-${this.weatherInfo.max}°`)
        .fontSize(14)
        .fontColor(Color.White)
        .margin({ top: 16 })
      Text(this.weatherInfo.airLevel)
        .fontSize(10)
        .fontColor(Color.White)
        .margin({ top: 19 })
        .backgroundColor('#24FFFFFF')
        .width(26)
        .height(16)
        .textAlign(TextAlign.Center)
        .borderRadius(11)
    }
  }
}