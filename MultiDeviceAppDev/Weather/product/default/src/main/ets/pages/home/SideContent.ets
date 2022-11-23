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

import { City, getSideBg, MyDataSource, Style } from '@ohos/common'

@Component
export default struct SideContent {
  @StorageLink('cityList') @Watch('cityListChange') cities: Array<City> = []
  @StorageLink('swiperIndex') swiperIndex: number = 0
  private cityList: MyDataSource = new MyDataSource(this.cities)
  @Link showSideBar: boolean

  @Builder header() {
    Row() {
      Blank()
      Image($r('app.media.icon_subarea'))
        .size({ width: 24, height: 24 })
        .objectFit(ImageFit.Contain)
        .onClick(() => {
          this.showSideBar = !this.showSideBar
        })
    }
    .width('100%')

    Text($r('app.string.weather'))
      .fontColor(Color.White)
      .fontSize(30)
      .fontWeight(FontWeight.Medium)
      .width('100%')
    Search({ placeholder: '搜索城市（中文/拼音）', icon: '/common/images/icon_search.svg' })
      .placeholderFont({ size: 16 })
      .placeholderColor('#60FFFFFF')
      .width('100%')
      .backgroundColor('#26FFFFFF')
      .margin({ top: 4 })
      .borderRadius(45)
  }

  build() {
    Column({ space: Style.NORMAL_SPACE }) {
      this.header()
      List({ space: 12 }) {
        LazyForEach(this.cityList, (item, index) => {
          ListItem() {
            CityItem({cityInfo: item, index: index})
          }
          .onClick(() => {
            this.swiperIndex = index
            AppStorage.SetOrCreate('swiperIndex', index)
          })
        }, item => item.name)
      }
      .margin({ top: 8 })
      .width('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .padding(Style.NORMAL_PADDING)
    .backgroundColor('#55000000')
  }

  cityListChange() {
    this.cityList['dataArray'] = this.cities
    this.cityList.notifyDataReload()
  }
}

@Component
struct CityItem {
  private cityInfo: City
  private index: number
  @StorageLink('swiperIndex') swiperIndex: number = 0

  build() {
    Row() {
    Text(this.cityInfo.name)
      .fontColor(Color.White)
      .fontSize(24)
    if (this.index === 0) {
      Image($r('app.media.icon_location'))
        .size({ width: 16, height: 16 })
        .objectFit(ImageFit.Contain)
    }
    Blank()
    Column() {
      Row() {
        Text(this.cityInfo.temp)
          .fontColor(Color.White)
          .fontWeight(Style.BIG_FONT_WEIGHT)
          .fontSize(54)
        Text($r('app.string.du'))
          .fontColor(Color.White)
          .fontSize(20)
          .margin({ bottom: 28 })
      }

      Text(this.cityInfo.weather)
        .fontColor(Color.White)
        .fontSize(14)
    }
  }
  .width('100%')
  .height(100)
  .alignItems(VerticalAlign.Center)
  .padding(Style.NORMAL_PADDING)
  .border({
    radius: Style.NORMAL_RADIUS,
    width: 1,
    color: this.swiperIndex === this.index ? '#BBFFFFFF' : '#116ACD'
  })
  .alignItems(VerticalAlign.Center)
  .backgroundImageSize(ImageSize.Cover)
  .backgroundImage(getSideBg(this.cityInfo.weather))
  }
}
