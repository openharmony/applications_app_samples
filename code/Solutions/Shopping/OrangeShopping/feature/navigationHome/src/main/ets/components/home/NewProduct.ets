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

import { GoodsList } from '../good/GoodsList'
import { NEW_PRODUCT_TITLE_BAR_DATA, SWIPER_DATA } from '../../mock/ProductsData'

@Component
export struct NewProduct {
  @State tabsIndex: number = 0
  @StorageProp('curBp') curBp: string = 'md'
  private url: string
  private controller: TabsController = new TabsController()

  build() {
    Column() {
      Scroll() {
        Column() {
          Swiper() {
            ForEach(SWIPER_DATA, item => {
              Navigator({ target: 'pages/detail' }) {
                Image(item.img)
                  .objectFit(ImageFit.Cover)
                  .width('100%')
                  .borderRadius({ bottomLeft: 12, bottomRight: 12, topLeft: 0, topRight: 0 })
              }
            }, item => item.id.toString())
          }
          .width('100%')
          .height(186)
          .autoPlay(true)
          .itemSpace(10)
          .displayCount(this.curBp === 'sm' ? 1 : this.curBp === 'md' ? 2 : 3)
          // 这里的导航点需要位于swiper的右下角，此处使用right:24
          .indicatorStyle({ right: 24, selectedColor: $r('app.color.point'), color: $r('app.color.point_selected') })

          Row() {
            ForEach(NEW_PRODUCT_TITLE_BAR_DATA, item => {
              Column() {
                Text(item.title)
                  .fontSize(16)
                  .fontColor($r('app.color.blank'))
                  .opacity(this.tabsIndex == item.id ? 1 : 0.6)
                  .fontWeight(this.tabsIndex == item.id ? 500 : 400)
              }
              .justifyContent(FlexAlign.Center)
              .align(Alignment.Center)
              .onClick(() => {
                this.tabsIndex = item.id
                this.controller.changeIndex(item.id)
              })
            }, item => item.id.toString())

            Row() {
              Image($r('app.media.line_navclass'))
                .width(2)
                .height(16)
                .objectFit(ImageFit.Contain)
              Image($r('app.media.new_navclass'))
                .width(16)
                .height(16)
                .objectFit(ImageFit.Contain)
                .margin({ left: 4 })
              Text($r('app.string.classification'))
                .fontSize(16)
                .opacity(0.6)
                .fontColor($r('app.color.blank'))
                .margin({ left: 2 })
            }
          }
          .width('100%')
          .padding({ left: 12, right: 12, bottom: 16, top: 16 })
          .justifyContent(FlexAlign.SpaceBetween)

          GoodsList({ url: this.url })
        }
        .padding({ bottom: 12 })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)

      Divider()
        .color($r('app.color.divider2'))
        .height(0.5)
    }
    .width('100%')
    .height('100%')
  }
}