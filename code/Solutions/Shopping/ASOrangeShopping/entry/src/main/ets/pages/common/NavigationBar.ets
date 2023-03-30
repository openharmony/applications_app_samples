/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { Home } from '../home/Home';
import { NAVIGATION_BAR_DATA } from '../../data/ComponentsData';
import { ShoppingCart } from '../shoppingcart/ShoppingCart';

@Preview
@Component
export struct NavigationBar {
  @StorageLink('tabsIndex') @Watch('indexChanged') tabsIndex: number = 0;
  @StorageProp('curBp') curBp: string = 'sm';
  private controller: TabsController = new TabsController();

  @Builder TabBarBuilder(index: number) {
    Column() {
      Image(this.getTabBarImage(index))
        .width(24)
        .height(24)
        .objectFit(ImageFit.Contain)
      Text(NAVIGATION_BAR_DATA[index].title)
        .fontSize(10)
        .margin({ top: 4 })
        .fontWeight(FontWeight.Bold)
        .opacity(this.tabsIndex === index ? 1 : 0.6)
        .fontWeight(this.tabsIndex === index ? 500 : 400)
        .fontColor(this.tabsIndex === index ? $r('app.color.pink') : Color.Black)
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
    .onClick(() => {
      this.controller.changeIndex(index);
    })
  }

  indexChanged() {
    this.controller.changeIndex(this.tabsIndex);
  }

  getTabBarImage(index: number) {
    if (this.tabsIndex === index) {
      return NAVIGATION_BAR_DATA[index].selectedUri;
    }
    return NAVIGATION_BAR_DATA[index].uri;
  }

  build() {
    Column() {
      Tabs({
        barPosition: BarPosition.End,
        index: this.tabsIndex,
        controller: this.controller
      }) {
        TabContent() {
          Home()
        }
        .tabBar(this.TabBarBuilder(0))

        TabContent() {
          ShoppingCart()
        }.tabBar(this.TabBarBuilder(1))
      }
      .scrollable(true)
      .vertical(false)
      .barHeight(56)
      .barWidth('100%')
      .onChange((index: number) => {
        this.tabsIndex = index;
      })
    }
    .backgroundColor($r("app.color.transfer"))
  }
}