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

import { TAB_TITLE_DATA } from '../mock/ProductsData'
import { MainPage } from '../components/home/MainPage'
import { NewProduct } from '../components/home/NewProduct'
import { ShopCart } from '../components/home/ShopCart'
import { User } from '../components/user/User'

AppStorage.Link('isUpdateDialogOpen') || AppStorage.SetOrCreate('isUpdateDialogOpen', false)

@Entry
@Component
export struct NavigationHomePage {
  @State tabsIndex: number = AppStorage.Get('nowIndex') || 0
  @StorageProp('curBp') curBp: string = 'sm'
  private url: string
  private controller: TabsController = new TabsController()

  @Builder TabBarBuilder(index: number) {
    Column() {
      Image(this.getTabBarImage(index))
        .width(24)
        .height(24)
        .objectFit(ImageFit.Contain)
      Text(TAB_TITLE_DATA[index].title)
        .fontSize(10)
        .fontWeight(500)
        .margin({ top: 4 })
        .opacity(this.tabsIndex === index ? 1 : 0.6)
        .fontWeight(this.tabsIndex === index ? 500 : 400)
        .fontColor(this.tabsIndex === index ? $r('app.color.pink') : Color.Black)
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
    .onClick(() => {
      this.controller.changeIndex(index)
    })
  }

  build() {
    Column() {
      Tabs({
        barPosition: this.curBp === 'sm' ? BarPosition.End : BarPosition.Start,
        index: this.tabsIndex,
        controller: this.controller
      }) {
        TabContent() {
          MainPage({ url: this.url })
        }.tabBar(this.TabBarBuilder(0))

        TabContent() {
          NewProduct({ url: this.url })
        }.tabBar(this.TabBarBuilder(1))

        TabContent() {
          ShopCart({ url: this.url })
        }.tabBar(this.TabBarBuilder(2))

        TabContent() {
          User()
        }.tabBar(this.TabBarBuilder(3))
      }
      .scrollable(false)
      .vertical(this.curBp === 'sm' ? false : true)
      .barMode(BarMode.Fixed)
      .barWidth(this.curBp === 'sm' ? '100%' : 56)
      .barHeight(this.curBp === 'sm' ? 56 : '100%')
      .onChange((index: number) => {
        this.tabsIndex = index
      })
    }
    .backgroundColor($r('app.color.divider'))
  }

  getTabBarImage(index: number) {
    if (this.tabsIndex === index) {
      return TAB_TITLE_DATA[index].selectedUri
    }
    return TAB_TITLE_DATA[index].uri
  }
}