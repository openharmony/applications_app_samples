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
import { City, getSideBg, MyDataSource, Style } from '@ohos/common'

@Entry
@Component
struct CityList {
  @StorageLink('cityList') cities: Array<City> = []
  @StorageLink('curBp') curBp: string = 'lg'
  private cityList: MyDataSource = new MyDataSource(this.cities)

  getOffsetMD(index) {
    if (index === 0) { return 1 }
    if (index % 2 === 0) { return 2 }
    return 0
  }

  getOffsetLG(index) {
    if (index === 0) { return 2 }
    if (index % 2 === 0) { return 4 }
    return 0
  }

  @Builder CityInfo(item, index) {
    Row() {
      Text(item.name)
        .fontColor(Color.White)
        .fontSize(20)
      if (index === 0) {
        Image($r('app.media.icon_location'))
          .size({ width: 16, height: 16 })
          .objectFit(ImageFit.Contain)
      }
      Blank()
      Column() {
        Row() {
          Text(item.temp)
            .fontColor(Color.White)
            .fontWeight(Style.BIG_FONT_WEIGHT)
            .fontSize(38)
          Text($r('app.string.du'))
            .fontColor(Color.White)
            .fontSize(16)
            .margin({ bottom: 22 })
        }

        Text(item.weather)
          .fontColor(Color.White)
          .fontSize(12)
      }
    }
    .width('100%')
    .height(80)
    .alignItems(VerticalAlign.Center)
    .padding(Style.NORMAL_PADDING)
    .borderRadius(Style.NORMAL_RADIUS)
    .alignItems(VerticalAlign.Center)
    .backgroundImageSize(ImageSize.Cover)
    .backgroundImage(getSideBg(item.weather))
  }

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
        Text($r('app.string.manage_city'))
          .fontSize(20)
          .margin({ left: Style.NORMAL_MARGIN })
      }
      .width('100%')
      .height(56)

      Scroll() {
        GridRow({ columns: { sm: 4, md: 8, lg: 12 }, gutter: { x: Style.GRID_GUTTER, y: Style.GRID_GUTTER }}) {
          LazyForEach(this.cityList, (item, index) => {
            GridCol({ span: {sm: 4, md: 3, lg: 4},
              offset: {sm: 0, md: this.getOffsetMD(index), lg: this.getOffsetLG(index)}}) {
              this.CityInfo(item, index)
            }
          }, item => item.name)
        }
      }
      .layoutWeight(1)
      .margin({ top: 12 })
      .scrollBar(BarState.Off)
      .padding({ left: Style.NORMAL_PADDING, right: Style.NORMAL_PADDING })

      Column() {
        Image($r('app.media.icon_add'))
          .width(24)
          .height(24)
          .objectFit(ImageFit.Contain)
        Text($r('app.string.add_city'))
          .fontSize(10)
      }
      .justifyContent(FlexAlign.Center)
      .padding({ bottom: this.curBp === 'lg' ? Style.ADD_CITY_BOTTOM_LG : Style.ADD_CITY_BOTTOM })
      .onClick(() => {
        router.push({ url: 'pages/AddCity' })
      })
    }
    .height('100%')
    .backgroundColor('#F1F3F5')
  }

  onPageShow() {
    this.cityList['dataArray'] = this.cities
    this.cityList.notifyDataReload()
  }
}