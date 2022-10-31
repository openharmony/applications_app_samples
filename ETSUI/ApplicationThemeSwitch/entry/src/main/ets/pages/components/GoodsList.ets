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

import { ProductDataModel, GoodResponse } from '../../models/HomeModel'
import { productData, goodResponse } from '../../mocks/HomeData'
import { getTheme } from '../../utils/ThemeGet'

const RATIO: number = 1 // 当前组件的宽高比

@Component
export struct GoodsList {
  @Prop isLand: boolean
  @Prop ratio: number
  @StorageLink('theme') theme: number = -1 // 初始主题theme值
  @State flag: boolean = false
  @State productData: Array<ProductDataModel> = productData
  @State goodResponse: GoodResponse = goodResponse

  build() {
    Column() {
      Grid() {
        ForEach(this.flag ? this.goodResponse.data.records : this.productData, item => {
          GridItem() {
            Column() {
              Image(item.detail.uri)
                .aspectRatio(RATIO)
                .objectFit(ImageFit.Contain)
                .margin({ top: 20, bottom: 20, left: 100, right: 100 })

              Column() {
                Text(item.detail.title)
                  .width('100%')
                  .fontSize(18)
                  .fontColor(getTheme(this.theme).DEFAULT_COLOR)
                  .margin({ bottom: 5 })

                Text(item.detail.info)
                  .width('100%')
                  .fontSize(18)
                  .fontColor(getTheme(this.theme).DEFAULT_COLOR)

                Text(item.detail.price)
                  .fontColor($r('app.color.detail_main_color'))
                  .fontSize(20)
                  .margin({ top: 10 })
                  .fontColor(getTheme(this.theme).DEFAULT_COLOR)

                Column() {
                  Text(item.detail.labels)
                    .fontSize(14)
                    .fontColor(getTheme(this.theme).DEFAULT_COLOR)
                }
                .borderRadius(5)
                .padding({ left: 6, right: 6, top: 4, bottom: 4 })
                .margin({ top: 10, bottom: 16 })
                .backgroundColor($r('app.color.detail_main_color'))
              }
              .alignItems(HorizontalAlign.Start)
            }
            .width('100%')
            .backgroundColor(getTheme(this.theme).BACKGROUND_COLOR)
          }
          .backgroundColor(getTheme(this.theme).BACKGROUND_COLOR)
          .borderRadius(10)
          .margin({ top: 3, left: 3 })
          .height(this.isLand ? '100%' : undefined)
          .padding({ top: 10, bottom: 10, left: 25, right: 25 })
        }, item => item.toString())
      }
      .rowsGap(16)
      .columnsGap(16)
      .columnsTemplate(this.isLand ? '1fr 1fr 1fr' : '1fr 1fr')
    }
    .width('100%')
    .height('100%')
    .margin({ bottom: 20 })
    .padding({ left: 25, right: 25, bottom: 150 })
  }
}