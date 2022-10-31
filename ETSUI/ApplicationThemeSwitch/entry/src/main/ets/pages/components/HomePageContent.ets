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

import { TitleBarModel } from '../../models/HomeModel'
import { titleBarData } from '../../mocks/HomeData'
import { getTheme } from '../../utils/ThemeGet'
import { GoodsList } from './GoodsList'
import { SwiperComponent } from './Swiper'

const OPACITY: number = 0.6 // 透明度

@Component
export struct homePageContent {
  private controller: TabsController = new TabsController()
  @Prop isLand: boolean
  @Prop ratio: number
  @StorageLink('theme') theme: number = -1 // 初始主题theme值
  @State tabsIndex: number = 0 // tabs索引
  @State titleBarData: Array<TitleBarModel> = titleBarData

  build() {
    Scroll() {
      Column() {
        // 页面上边 swiper 轮播部分
        SwiperComponent({ ratio: this.ratio, isLand: this.isLand })
          .width('100%')
          .height('30%')
        Flex({ justifyContent: FlexAlign.SpaceAround, alignItems: ItemAlign.Center }) {
          ForEach(this.titleBarData, item => {
            Column() {
              Text(item.title)
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor(this.tabsIndex === item.id ? getTheme(this.theme).NAV_SELECTED_COLOR :
                getTheme(this.theme).DEFAULT_COLOR)
              Text(item.content)
                .fontSize(16)
                .opacity(OPACITY)
                .fontColor(this.tabsIndex === item.id ? getTheme(this.theme).NAV_SELECTED_COLOR :
                getTheme(this.theme).DEFAULT_COLOR)
            }
            .width('20%')
            .onClick(() => {
              this.tabsIndex = item.id
              this.controller.changeIndex(item.id)
            })
          }, item => item.toString())
        }
        .backgroundColor(getTheme(this.theme).BACKGROUND_COLOR)
        .margin({ top: 8, bottom: 8 })
        .padding({ top: 10 * this.ratio, bottom: 10 * this.ratio })

        // 主页下半部分商品展示--全部、精选、新品、实惠
        Tabs({ controller: this.controller }) {
          TabContent() {
            GoodsList({ isLand: this.isLand, ratio: this.ratio })
          }

          TabContent() {
            GoodsList({ isLand: this.isLand, ratio: this.ratio })
          }

          TabContent() {
            GoodsList({ isLand: this.isLand, ratio: this.ratio })
          }

          TabContent() {
            GoodsList({ isLand: this.isLand, ratio: this.ratio })
          }
        }
        .barWidth(0)
        .barHeight(0)
        .height('56%')
        .scrollable(false)
      }
    }
    .backgroundColor(getTheme(this.theme).MAIN_BACKGROUND_COLOR)
  }
}