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

import { FavorGoodList } from './FavorGoodsList';
import { GoodsInCart } from './GoodsInCart';

@Component
export struct ShoppingCart {
  build() {
    Column() {
      Row() {
        Text($r('app.string.shopping_cart'))
          .fontSize(24)
          .fontColor(Color.Black)
          .fontFamily('HarmonyHeiTi')
        Blank()
        Text($r('app.string.shopping_cart_edit'))
          .opacity(0.6)
          .fontSize(16)
          .fontColor(Color.Black)
          .fontFamily('HarmonyHeiTi')
      }
      .width('100%')
      .margin({ top: 16, bottom: 16 })
      .padding({ right: 16, left: 16 })

      Scroll() {
        Column() {
          GoodsInCart()
          FavorGoodList()
        }
        .layoutWeight(1)
        .margin({ left: 12, right: 12 })
        .justifyContent(FlexAlign.Center)
      }
      .scrollBar(BarState.Off)
      .alignSelf(ItemAlign.Center)
      .constraintSize({ minHeight: '100%' })
    }
    .size({ width: '100%', height: '100%' })
    .alignItems(HorizontalAlign.Center)
    .backgroundColor($r('app.color.background'))
  }
}