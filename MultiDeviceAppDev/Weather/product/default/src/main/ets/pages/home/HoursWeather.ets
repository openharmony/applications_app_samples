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

import { Forecast, getHoursData, MyDataSource, Style } from '@ohos/common'

@Preview
@Component
export default struct HoursWeather {
  private hoursData: Forecast[] = getHoursData(0)
  @StorageLink('curBp') curBp: string = 'lg'
  @State hoursDataResource: MyDataSource = new MyDataSource(this.hoursData)

  @Builder HoursWeatherItem(hoursItem, itemWidth) {
    Column() {
      Text(`${hoursItem.desc}${hoursItem.date}`)
        .fontSize(12)
        .fontColor(Color.White)
      Row() {
        Image(hoursItem.icon)
          .width(28)
          .height(28)
          .objectFit(ImageFit.Contain)
      }
      .margin({ top: 25 })
      .justifyContent(FlexAlign.Center)

      Text(hoursItem.degree)
        .fontSize(14)
        .fontColor(Color.White)
        .margin({ top: 16 })
      Text(hoursItem.win)
        .fontSize(12)
        .fontColor(Color.White)
        .margin({ top: 16 })
      Text(hoursItem.winSpeed)
        .fontSize(12)
        .fontColor(Color.White)
        .margin({ top: 5 })
    }
    .width(itemWidth)
    .padding({ top: 18, bottom: 18 })
  }

  build() {
    List() {
      LazyForEach(this.hoursDataResource, (hoursItem) => {
        ListItem() {
          this.HoursWeatherItem(hoursItem,
            this.curBp === 'lg' ? Style.WEATHER_ITEM_WIDTH + 2 : Style.WEATHER_ITEM_WIDTH)
        }
      }, item => `${item.desc}${item.date}:00`)
    }
    .width('100%')
    .height(Style.CARD_HEIGHT)
    .borderRadius(Style.NORMAL_RADIUS)
    .backgroundColor(Style.CARD_BACKGROUND_COLOR)
    .listDirection(Axis.Horizontal)
  }

  aboutToAppear() {
    this.hoursDataResource['dataArray'] = this.hoursData
  }
}