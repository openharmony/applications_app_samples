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

import { TITLE_BAR_DATA } from '../../mock/ProductsData'
import { GoodsList } from '../good/GoodsList'
import { SwiperComponent } from './Swiper'

@Component
export struct HomePageContent {
  @State tabsIndex: number = 0
  private url: string
  private controller: TabsController = new TabsController()
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
              .fontColor(Color.Black)
            Text(item.content)
              .fontSize(12)
              .fontWeight(400)
              .opacity(this.tabsIndex === item.id ? 1 : 0.6)
              .fontColor(this.tabsIndex === item.id ? $r('app.color.pink') : Color.Black)
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

      // 主页下半部分商品展示--全部、精选、新品、实惠
      Tabs({ controller: this.controller }) {
        TabContent() {
          GoodsList({ url: this.url })
        }

        TabContent() {
          GoodsList({ url: this.url })
        }

        TabContent() {
          GoodsList({ url: this.url })
        }

        TabContent() {
          GoodsList({ url: this.url })
        }
      }
      .height(this.listHeight + 12)
      .barWidth(0)
      .barHeight(0)
      .scrollable(false)
    }
  }
}