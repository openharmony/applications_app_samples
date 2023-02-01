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

import router from '@ohos.router';
import { NavDataModel, SearchTextModel, SwiperModel, TitleBarModel } from '../../model/homeModel'
import { navData, findSearchTextData, swiperData, titleBarData } from '../../data/homeData'
import { Core1 } from './core1'
import { Boutique } from './boutique'
import { GoodsList } from './goodsList'

class navNum implements IDataSource {
  totalCount(): number {
    return this.num
  }

  getData(index: number): any {
    return index
  }

  registerDataChangeListener(listener: DataChangeListener) {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener)
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener) {
    const pos = this.listeners.indexOf(listener)
    if (pos >= 0) {
      this.listeners.splice(pos, 1)
    }
  }

  num: number = 19
  listeners: DataChangeListener[] = []
}

class mainTabsTitle implements IDataSource {
  totalCount(): number {
    return this.num
  }

  getData(index: number): any {
    return index
  }

  registerDataChangeListener(listener: DataChangeListener) {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener)
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener) {
    const pos = this.listeners.indexOf(listener)
    if (pos >= 0) {
      this.listeners.splice(pos, 1)
    }
  }

  num: number = 4
  listeners: DataChangeListener[] = []
}

@Component
export struct MainPage {
  @State navData: Array<NavDataModel> = navData
  @State searchData: Array<SearchTextModel> = findSearchTextData
  @State tabsIndex: number = 0
  @State swiperData: Array<SwiperModel> = swiperData
  navNum: navNum = new navNum()
  mainTabsTitle: mainTabsTitle = new mainTabsTitle()
  controller: TabsController = new TabsController()
  @State titleBarData: Array<TitleBarModel> = titleBarData
  @State ListIndex: number = 0
  @Prop num: number
  @Prop ratio: number
  @Prop swiperWidth: number

  build() {
    Column() {
      Row() {
        Column() {
          Image('/resources/icon/scan.png')
            .width(30 * this.ratio)
            .aspectRatio(1)
            .objectFit(ImageFit.Contain)
        }
        .padding({ top: 5, bottom: 5 })

        Row() {
          Image('/resources/icon/search.png')
            .width(25 * (this.ratio + 0.2))
            .aspectRatio(1)
            .objectFit(ImageFit.Contain)
          Swiper() {
            Column() {
              Text(this.searchData[0].searchText)
                .fontSize(14 * (this.ratio + 0.2))
                .lineHeight(23 * (this.ratio + 0.2))
            }
            .height(25 * (this.ratio + 0.2))
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .onClick(() => {
              router.push({
                url: 'pages/search/searchPage',
                params: {
                  message: this.searchData[0].searchText,
                  num: this.num,
                  ratio: this.ratio,
                  swiperWidth: this.swiperWidth
                }
              })
            })

            Column() {
              Text(this.searchData[1].searchText)
                .fontSize(14 * (this.ratio + 0.2))
                .lineHeight(23 * (this.ratio + 0.2))
            }
            .height(25 * (this.ratio + 0.2))
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .onClick(() => {
              router.push({
                url: 'pages/search/searchPage',
                params: {
                  message: this.searchData[1].searchText,
                  num: this.num,
                  ratio: this.ratio,
                  swiperWidth: this.swiperWidth
                }
              })
            })

            Column() {
              Text(this.searchData[2].searchText)
                .fontSize(14 * (this.ratio + 0.2))
                .lineHeight(23 * (this.ratio + 0.2))
            }
            .height(25 * (this.ratio + 0.2))
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .onClick(() => {
              router.push({
                url: 'pages/search/searchPage',
                params: {
                  message: this.searchData[2].searchText,
                  num: this.num,
                  ratio: this.ratio,
                  swiperWidth: this.swiperWidth
                }
              })
            })
          }
          .key('searchInput')
          .width('65%')
          .autoPlay(true)
          .loop(true)
          .vertical(true)
          .indicator(false)
          .interval(2000)

          Image('/resources/icon/camera.png')
            .width(25 * (this.ratio + 0.2))
            .aspectRatio(1)
            .objectFit(ImageFit.Contain)
        }
        .border({ width: 2, color: Color.Orange, radius: 20 })
        .width('70%')
        .padding(5)
        .justifyContent(FlexAlign.SpaceAround)
        .alignItems(VerticalAlign.Center)

        Column() {
          Image('/resources/icon/barcode.png')
            .width(30 * this.ratio)
            .aspectRatio(1)
            .objectFit(ImageFit.Contain)
        }
        .padding({ top: 5, bottom: 5 })
      }
      .width('100%')
      .padding(5)
      .justifyContent(FlexAlign.SpaceAround)
      .alignItems(VerticalAlign.Center)

      Scroll() {
        Column() {
          Row() {
            List() {
              LazyForEach(this.navNum, item => {
                ListItem() {
                  Text(this.navData[item].navData)
                    .fontColor(this.navData[item].navData == '首页' ? Color.Blue : Color.Black)
                    .fontWeight(this.navData[item].navData == '首页' ? FontWeight.Bold : FontWeight.Normal)
                    .fontSize(19 * this.ratio)
                    .margin({ left: 5, right: 8 })
                    .lineHeight(30 * this.ratio)
                }
                .height(30 * this.ratio)
              }, item => item.toString())
            }
            .height(30 * this.ratio)
            .width('85%')
            .listDirection(Axis.Horizontal)

            Row() {
              Image('/resources/icon/nav_classification.png')
                .width(20 * this.ratio)
                .aspectRatio(1)
                .objectFit(ImageFit.Contain)
              Text('分类')
                .fontSize(15 * this.ratio)
            }
            .justifyContent(FlexAlign.SpaceAround)
            .alignItems(VerticalAlign.Center)
            .height(30 * this.ratio)
            .width('15%')
          }
          .margin({ bottom: 0, left: 5, right: 5 })

          Swiper() {
            Image(this.swiperData[0].img)
              .width('100%')
              .height('100%')
              .objectFit(ImageFit.Contain)
              .border({ radius: 10 * this.ratio })
            Image(this.swiperData[1].img)
              .width('100%')
              .height('100%')
              .objectFit(ImageFit.Contain)
              .border({ radius: 10 * this.ratio })
            Image(this.swiperData[2].img)
              .width('100%')
              .height('100%')
              .objectFit(ImageFit.Contain)
              .border({ radius: 10 * this.ratio })
          }
          .key('carousel')
          .autoPlay(true)
          .loop(true)
          .width('93%')
          .aspectRatio(2.6)

          Column() {
            Core1({ ratio: this.ratio })
          }

          Column() {
            Boutique({ ratio: this.ratio })
          }
          .margin({ top: 10 })

          Row() {
            LazyForEach(this.mainTabsTitle, item => {
              Column() {
                Text(this.titleBarData[item].title)
                  .fontSize(15 * this.ratio)
                  .margin(3)
                  .fontColor(this.tabsIndex == item ? Color.Orange : Color.Black)
              }
              .width('20%')
              .padding({ top: 5, bottom: 5 })
              .onClick(() => {
                this.tabsIndex = item
                this.controller.changeIndex(item)
              })
            }, item => item.toString())
          }
          .justifyContent(FlexAlign.SpaceAround)
          .alignItems(VerticalAlign.Center)
          .height('7%')
          .zIndex(2)
          .backgroundColor(Color.White)

          Column() {
            Tabs({ controller: this.controller }) {
              TabContent() {
                GoodsList({ ListIndex: $ListIndex, ratio: $ratio })
              }.tabBar('全部')

              TabContent() {
                GoodsList({ ListIndex: $ListIndex, ratio: $ratio })
              }.tabBar('直播')

              TabContent() {
                GoodsList({ ListIndex: $ListIndex, ratio: $ratio })
              }.tabBar('便宜好货')

              TabContent() {
                GoodsList({ ListIndex: $ListIndex, ratio: $ratio })
              }.tabBar('洋淘')
            }
            .barWidth(0)
            .barHeight(0)
            .height('93%')
            .scrollable(false)
          }
          .width('100%')
        }
      }
      .width('100%')
      .scrollBar(BarState.Off)
    }
  }
}