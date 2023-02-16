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

import router from '@ohos.router'
import { Information } from '../components/Information'
import { Choice } from '../components/Choice'
import { Valuation } from '../components/Valuation'
import { BottomNavigation } from '../components/BottomNavigation'
import { ProductDataModel } from '../model/GoodsModel'

@Entry
@Component
struct DetailPage {
  @State isPanel: boolean = false
  @State goodDetailData: ProductDataModel = router.getParams()['goodItem']
  @State currentLocation: string = ''
  @State swiperList: Array<number> = [0,0,0,0]
  @State recommend: string = ''
  @State commodity: string = ''
  @State swiperIndex: number = 0
  @StorageProp('curBp') curBp: string = 'md'
  private scroller: Scroller = new Scroller()

  build() {
    Stack({ alignContent: Alignment.BottomStart }) {
      Scroll(this.scroller) {
        Column({ space: 12 }) {
          Stack({ alignContent: Alignment.BottomEnd }) {
            Swiper() {
              ForEach(this.swiperList, item => {
                Column() {
                  Image(this.goodDetailData.uri)
                    .width('100%')
                    .aspectRatio(1)
                }
                .width('100%')
              })
            }
            .height(300)
            .index(this.swiperIndex)
            .indicator(false)
            .onChange((index: number) => {
              this.swiperIndex = index
            })

            Row() {
              Text(`${this.swiperIndex + 1}/${this.swiperList.length + 1}`)
                .fontSize(12)
                .fontColor($r('app.color.white'))
            }
            .width(46)
            .height(24)
            .borderRadius(12)
            .justifyContent(FlexAlign.Center)
            .backgroundColor($r('app.color.background'))
            .margin({ right: 16, bottom: 16 })
          }
          .width('100%')
          .height(300)
          .backgroundColor($r('app.color.white'))

          Column() {
            Information()
              .margin({ top: 12 })
            Choice()
              .margin({ top: 12 })
            Valuation()
              .margin({ top: 12 })
          }
          .padding({ left: 12, right: 12 })
        }
        .width('100%')
      }
      .width('100%')
      .align(Alignment.Top)
      .scrollBar(BarState.Off)
      .padding({ bottom: this.curBp === 'sm' ? 86 : 106 })

      BottomNavigation({ goodItemData: $goodDetailData })

      Image($r('app.media.back'))
        .width(32)
        .aspectRatio(1)
        .position({ x: 20, y: 20 })
        .onClick(() => {
          router.back()
        })
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.divider'))
  }

  aboutToAppear() {
    let context: Context = getContext(this)
    this.currentLocation = context.resourceManager.getStringSync($r('app.string.address').id)
    this.recommend = context.resourceManager.getStringSync($r('app.string.recommend').id)
    this.commodity = context.resourceManager.getStringSync($r('app.string.commodity').id)
  }
}