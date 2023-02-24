/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import { TitleBarModel } from '../../models/HomeModel'
import { titleBarData } from '../../mocks/HomeData'
import { GoodsList } from './GoodsList'
import { SwiperComponent } from './Swiper'
import { TITLE_BAR_DATA } from '../../mocks/ProductsData'
import { getTheme } from '../../utils/ThemeGet'

@Component
export struct HomePageContent {
  private controller: TabsController = new TabsController()
  @Prop isLand: boolean
  @Prop ratio: number
  @StorageLink('theme') theme: number = -1 // 初始主题theme值
  @State tabsIndex: number = 0 // tabs索引
  @State titleBarData: Array<TitleBarModel> = titleBarData
  @StorageLink('listHeight') listHeight: number = 100
  @StorageLink('curBp') curBp: string = 'sm'

  build() {
    Column() {
      SwiperComponent()
        .width('100%')

      Row() {
        ForEach(TITLE_BAR_DATA, item => {
          Column({ space: 6 }) {
            Text(item.title)
              .fontSize(16)
              .fontWeight(400)
              .fontColor(this.tabsIndex === item.id ? getTheme(this.theme).NAV_SELECTED_COLOR :
              getTheme(this.theme).DEFAULT_COLOR)
            Text(item.content)
              .fontSize(12)
              .fontWeight(400)
              .opacity(this.tabsIndex === item.id ? 1 : 0.6)
              .fontColor(this.tabsIndex === item.id ? getTheme(this.theme).NAV_SELECTED_COLOR :
              getTheme(this.theme).DEFAULT_COLOR)
          }
          .onClick(() => {
            this.tabsIndex = item.id
            this.controller.changeIndex(item.id)
          })
        }, item => item.id.toString())
      }
      .width('100%')
      .padding({ top: 12, bottom: 12, left: 20, right: 20 })
      .justifyContent(FlexAlign.SpaceBetween)
      .backgroundColor(getTheme(this.theme).BACKGROUND_COLOR)

      // 主页下半部分商品展示--全部、精选、新品、实惠
      Tabs({ controller: this.controller }) {
        TabContent() {
          GoodsList()
        }

        TabContent() {
          GoodsList()
        }

        TabContent() {
          GoodsList()
        }

        TabContent() {
          GoodsList()
        }
      }
      .height(this.listHeight + 12)
      .barWidth(0)
      .barHeight(0)
      .scrollable(false)
      .backgroundColor(getTheme(this.theme).MAIN_BACKGROUND_COLOR)
    }
  }
}