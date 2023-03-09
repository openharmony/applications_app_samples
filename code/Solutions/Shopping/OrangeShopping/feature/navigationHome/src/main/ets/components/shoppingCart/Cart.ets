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

import { ProductDataModel } from '../../model/GoodsModel'
import { PRODUCT_DATA } from '../../mock/ProductsData'

@Component
export struct Cart {
  @StorageProp('curBp') curBp: string = 'sm'
  @Link shoppingCartGoodsListToCart: ProductDataModel[]

  build() {
    Column() {
      Row() {
        Toggle({ type: ToggleType.Checkbox })
          .width(20)
          .aspectRatio(1)
          .selectedColor($r('app.color.red'))

        Image($r('app.media.shop_user'))
          .width(24)
          .aspectRatio(1)
          .objectFit(ImageFit.Contain)
          .margin({ left: 12, right: 8 })
        Text($r('app.string.shopping_self_support'))
          .fontSize(14)
          .fontWeight(400)
          .fontColor(Color.Black)
      }
      .width('100%')

      ForEach(this.shoppingCartGoodsListToCart ? this.shoppingCartGoodsListToCart : [], item => {
        Row() {
          Toggle({ type: ToggleType.Checkbox })
            .width(20)
            .selectedColor($r('app.color.red'))
            .aspectRatio(1)
          Image(PRODUCT_DATA[item].uri)
            .width(70)
            .height(80)
            .objectFit(ImageFit.Contain)
            .margin({ left: 12, right: 16 })

          Column() {
            Text(PRODUCT_DATA[item].title)
              .fontSize(14)
              .fontWeight(400)
              .width('100%')

            Text(PRODUCT_DATA[item].info)
              .width('100%')
              .fontSize(12)
              .opacity(0.6)
              .margin({ top: 12 })

            Row() {
              Text(PRODUCT_DATA[item].price)
                .fontSize(16)
                .fontColor($r('app.color.red2'))
                .fontWeight(FontWeight.Medium)
              Blank()
              Row() {
                Image($r('app.media.reduce'))
                  .width(24)
                  .height(24)
                  .objectFit(ImageFit.Contain)
                Text(`${1}`)
                  .margin({ left: 10, right: 10 })
                  .fontSize(12)
                Image($r('app.media.add'))
                  .width(24)
                  .height(24)
                  .objectFit(ImageFit.Contain)
              }
              .margin({ right: 12 })
            }
            .width('100%')
            .margin({ top: 12 })
          }
          .flexGrow(1)
          .flexShrink(1)
          .margin({ top: 20 })
        }
        .width('100%')
      }, item => item.toString())
    }
    .width('100%')
    .backgroundColor($r('app.color.white'))
    .borderRadius(16)
    .padding({ top: 12, bottom: 12 })
  }
}