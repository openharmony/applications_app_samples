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

import { Cart } from '../shoppingCart/Cart'
import { FavorGoodList } from '../shoppingCart/FavorGoodlist'
import { ProductDataModel } from '../../model/GoodsModel'

@Preview
@Component
export struct ShopCart {
  private url: string
  @StorageLink('goodsListHeight') goodsListHeight: number = 100
  @State shoppingCartGoodsList: ProductDataModel[] = AppStorage.Get('shoppingCartGoodsList')

  build() {
    Column() {
      Scroll() {
        Column() {
          Column() {
            Row() {
              Text($r('app.string.shop_cart'))
                .fontSize(24)
                .fontColor($r('app.color.blank'))
                .fontFamily('HarmonyHeiTi')

              Blank()
              Text($r('app.string.edit'))
                .fontSize(16)
                .fontFamily('HarmonyHeiTi')
                .fontColor($r('app.color.blank'))
                .opacity(0.6)
            }
            .width('100%')
            .margin({ top: 16, bottom: 12 })

            Cart({ shoppingCartGoodsListToCart: $shoppingCartGoodsList })
          }
          .width('100%')
          .padding({ right: 12 })
          .backgroundColor($r('app.color.divider'))

          Text($r('app.string.guess_you_like'))
            .fontSize(20)
            .fontColor($r('app.color.blank'))
            .padding({ top: 24, bottom: 20, left: 12 })
          FavorGoodList({ url: this.url })
        }
        .padding({ bottom: 12 })
        .alignItems(HorizontalAlign.Start)
      }
      .layoutWeight(1)
      .padding({ left: 12, right: 12 })
      .scrollBar(BarState.Off)
      .align(Alignment.Top)

      Divider()
        .color($r('app.color.divider2'))
        .height(0.5)
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.divider'))
  }
}