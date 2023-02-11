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
import { addCity, City, getCityList, MyDataSource, Style } from '@ohos/common'

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

@Component
export struct CityGrid {
  @StorageLink('cityList') cities: Array<City> = []
  private cityList: MyDataSource = new MyDataSource(getCityList())

  build() {
    GridRow({ columns: { sm: 4, md: 8, lg: 12 },
      breakpoints: { reference: BreakpointsReference.WindowSize } }) {
      GridCol({
        span: { sm: 4, md: 6, lg: 8 },
        offset: { sm: 0, md: 1, lg: 2 } }) {
        GridRow({ columns: { sm: 3, md: 4, lg: 7 },
          gutter: { x: vp2px(17), y: vp2px(8) },
          breakpoints: { reference: BreakpointsReference.WindowSize } }) {
          GridCol({ span: { sm: 3, md: 4, lg: 7 } }) {
            Text($r('app.string.hot_city'))
              .width('100%')
              .fontSize(14)
              .fontWeight(FontWeight.Regular)
              .fontColor('#99000000')
              .margin({ bottom: 14 })
          }

          LazyForEach(this.cityList, (item) => {
            GridCol({ span: 1 }) {
              Column() {
                Text(item.name)
                  .fontSize(14)
                  .fontColor(this.isCityAdded(item) ? '#61000000' : '#000000')
              }
              .width('100%')
              .height(36)
              .backgroundColor(this.isCityAdded(item) ? '#05000000' : '#11000000')
              .justifyContent(FlexAlign.Center)
              .borderRadius(Style.CITY_TEXT_RADIUS)
              .onClick(() => {
                if (!this.isCityAdded(item)) {
                  addCity(item)
                  AppStorage.SetOrCreate('isRefresh', true)
                  router.back()
                }
              })
            }
          }, item => item.name)
        }
      }
    }
    .padding({ left: Style.NORMAL_PADDING, right: Style.NORMAL_PADDING })
  }

  isCityAdded(city: City) {
    let isAdded: boolean = false
    this.cities.forEach(item => {
      if (item.name === city.name) {
        isAdded = true
      }
    })
    return isAdded
  }
}