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

import mediaQuery from '@ohos.mediaquery';
import display from '@ohos.display';
import { TabTitleModel } from '../model/homeModel'
import { tabTitleData } from '../data/homeData'
import { MainPage } from './homePage/main'
import { VisitPage } from './homePage/visitPage'
import { Information } from './homePage/informance'
import { ShopCart } from './homePage/shopCart'
import { User } from './homePage/User'

let portraitIndex = null
let timer = null

class tabTitle implements IDataSource {
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

  num: number = 5
  listeners: DataChangeListener[] = []
}

@Entry
@Component
struct Index {
  @State device: string = ''
  @State tabsIndex: number = 0
  @State tabTittleData: Array<TabTitleModel> = tabTitleData
  @State idx: number = 0
  tabTitle: tabTitle = new tabTitle()
  controller: TabsController = new TabsController()
  @State widthNum: number = 100
  @State ratio: number = 1
  @State swiperWidth: number = 60
  listener = mediaQuery.matchMediaSync('(orientation:landscape)')

  aboutToAppear() {
    display.getAllDisplay((err, data) => {
      let aspect = data[0].width / data[0].height
      if (aspect == 0.5625) {
        this.ratio = 1
      }
    })
    portraitIndex = this.onPortrait.bind(this)
    this.listener.on('change', portraitIndex)
  }

  async onPortrait(mediaQueryResult) {
    let result = mediaQueryResult.matches
    if (result) {
      this.widthNum = 45
      this.swiperWidth = 30
    } else {
      this.widthNum = 100
      this.swiperWidth = 60
    }
  }

  build() {
    Column() {
      Column() {
        Tabs({ barPosition: BarPosition.Start, controller: this.controller, index: this.tabsIndex }) {
          TabContent() {
            MainPage({ num: this.widthNum, ratio: this.ratio, swiperWidth: this.swiperWidth })
          }.tabBar({ text: this.tabTittleData[0].title })

          TabContent() {
            VisitPage({ ratio: this.ratio })
          }.tabBar({ text: this.tabTittleData[0].title })

          TabContent() {
            Information({ ratio: this.ratio })
          }.tabBar({ text: this.tabTittleData[0].title })

          TabContent() {
            ShopCart({ ratio: this.ratio })
          }.tabBar({ text: this.tabTittleData[0].title })

          TabContent() {
            User({ num: this.widthNum, ratio: this.ratio })
          }.tabBar({ text: this.tabTittleData[0].title })
        }
        .barWidth(400)
        .barHeight(0)
        .scrollable(false)
        .animationDuration(200)
        .height('92%')

        Column() {
          Row() {
            LazyForEach(this.tabTitle, item => {
              Column() {
                Image(this.tabsIndex == item ? this.tabTittleData[item].selectedUri : this.tabTittleData[item].uri)
                  .width(25 * this.ratio)
                  .aspectRatio(1)
                  .objectFit(ImageFit.Contain)
                Text(this.tabTittleData[item].title)
                  .fontSize(15 * this.ratio)
                  .margin(1)
                  .fontColor(this.tabsIndex == item ? Color.Orange : Color.Black)
              }
              .width('20%')
              .alignItems(HorizontalAlign.Center)
              .justifyContent(FlexAlign.Center)
              .onClick(() => {
                clearTimeout(timer)
                timer = setTimeout(() => {
                  this.tabsIndex = item
                  this.controller.changeIndex(item)
                }, 200)
              })
            }, item => item.toString())
          }
          .height('8%')
          .justifyContent(FlexAlign.SpaceAround)
          .alignItems(VerticalAlign.Center)
        }
        .width('100%')
      }
      .width(`${this.widthNum}%`)
      .backgroundColor(Color.White)
      .border({ width: this.widthNum === 45 ? 1 : 0 })
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
  }

  PageTransition() {
    PageTransitionEnter({ duration: 0 })
      .opacity(1)
    PageTransitionExit({ duration: 0 })
      .opacity(1)
  }
}