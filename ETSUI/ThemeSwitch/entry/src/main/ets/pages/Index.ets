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

import display from '@ohos.display'
import mediaQuery from '@ohos.mediaquery'
import { MainPage } from './components/MainPage'
import { TabTitleModel } from '../models/HomeModel'
import { getTabTitleData } from '../mocks/HomeData'
import { getTheme } from '../utils/ThemeGet'

const SCREEN_RATIO: number = 0.5 // 设备的屏幕宽高比
const TABLE_INDEX_HOME: number = 0 // tabBar切换的索引
const TABLE_INDEX_PRODUCT: number = 1 // tabBar切换的索引
const TABLE_INDEX_CART: number = 2 // tabBar切换的索引
const TABLE_INDEX_ME: number = 3 // tabBar切换的索引
const RATIO: number = 1.3 // 适配到设备上放大的倍数
const OPACITY: number = 0.6 // 默认的透明度
const OPACITY_MATCH: number = 1 // 索引匹配时的透明度

@Entry
@Component
struct NavigationHomePage {
  private controller: TabsController = new TabsController()
  private listener = mediaQuery.matchMediaSync('screen and (min-aspect-ratio: 1.5) or (orientation: landscape)')
  @StorageLink('theme') theme: number = -1 // 初始主题theme值
  @State tabsIndex: number = 0 // tabs索引
  @State isLand: boolean = false
  @State tabTitleData: Array<TabTitleModel> = getTabTitleData(this.theme)
  @State ratio: number = 1 // 适配屏幕所需要乘的比例，默认为1
  onPortrait(mediaQueryResult) {
    this.isLand = mediaQueryResult.matches
  }

  @Builder TabBarBuilder(index: number) {
    Flex({ justifyContent: FlexAlign.SpaceBetween }) {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Image(this.tabsIndex === this.tabTitleData[index].id ? getTabTitleData(this.theme)[index].selectedUri :
        getTabTitleData(this.theme)[index].uri)
          .width('50%')
          .height('50%')
          .objectFit(ImageFit.Contain)
        Text(this.tabTitleData[index].title)
          .margin(4)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .opacity(this.tabsIndex == this.tabTitleData[index].id ? OPACITY_MATCH : OPACITY)
          .fontWeight(this.tabsIndex === this.tabTitleData[index].id ? FontWeight.Bold : FontWeight.Normal)
          .fontColor(this.tabsIndex === this.tabTitleData[index].id ? Color.Red : getTheme(this.theme).DEFAULT_COLOR)
      }
      .width('100%')
      .onClick(() => {
        this.tabsIndex = this.tabTitleData[index].id
        this.controller.changeIndex(this.tabTitleData[index].id)
      })
    }
  }

  aboutToAppear() {
    this.listener.on('change', this.onPortrait.bind(this))
    display.getAllDisplay((err, data) => {
      let aspect = data[0].width / data[0].height
      if (aspect === SCREEN_RATIO) {
        this.ratio = RATIO
      }
    })
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End, controller: this.controller }) {
        TabContent() {
          MainPage({ ratio: this.ratio, isLand: this.isLand })
        }
        .tabBar(this.TabBarBuilder(TABLE_INDEX_HOME))

        TabContent().tabBar(this.TabBarBuilder(TABLE_INDEX_PRODUCT))
        TabContent().tabBar(this.TabBarBuilder(TABLE_INDEX_CART))
        TabContent().tabBar(this.TabBarBuilder(TABLE_INDEX_ME))
      }
      .barHeight(60)
      .scrollable(false)
      .barMode(BarMode.Fixed)
      .onChange((index: number) => {
        this.tabsIndex = index
      })
      .backgroundColor(getTheme(this.theme).BACKGROUND_COLOR)
    }
  }
}