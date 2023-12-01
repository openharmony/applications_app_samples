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

import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import { CustomEmitter } from '@ohos/emitter';
import { Cart } from '../shoppingCart/Cart';
import { FavorGoodList } from '../shoppingCart/FavorGoodlist';
import { ProductDataModel } from '../model/GoodsModel';

@Entry
@Component
struct ShopCart {
  private url: string = '';
  @State shoppingCartGoodsList: ProductDataModel[]
    = AppStorage.get('shoppingCartGoodsList') as ProductDataModel[];
  @StorageLink('goodsListHeight') goodsListHeight: number = 100;
  private emitterClass: CustomEmitter = new CustomEmitter();
  @State counts: number = 0;
  @State purchase: string = '';
  private context = getContext(this) as common.UIAbilityContext;

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
              Text($r('app.string.back'))
                .fontSize(16)
                .fontFamily('HarmonyHeiTi')
                .fontColor($r('app.color.blank'))
                .opacity(0.6)
                .onClick(() => {
                  router.back()
                })
            }
            .width('100%')
            .padding(12)

            Cart({ shoppingCartGoodsListToCart: $shoppingCartGoodsList })
          }
          .width('100%')
          .backgroundColor($r('app.color.divider'))

          Column() {
            Row() {
              Text(`${this.purchase}${this.counts.toString()}`)
                .fontSize(12)
                .fontColor($r('app.color.blank'))
                .fontFamily('HarmonyHeiTi')
              Blank()
              Text($r('app.string.clear_purchase_quantity'))
                .fontSize(12)
                .fontFamily('HarmonyHeiTi')
                .fontColor($r('app.color.blank'))
                .opacity(0.6)
                .onClick(() => {
                  this.emitterClass.clearListenerCounts((counts: number) => {
                    this.counts = counts;
                  })
                })
            }
            .width('100%')
            .padding(12)
          }
          .width('100%')
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

      Divider()
        .color($r('app.color.divider2'))
        .height(0.5)
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.divider'))
  }

  aboutToAppear() {
    this.emitterClass.getListenerCounts((counts: number) => {
      this.counts = counts;
    })
    this.context.resourceManager.getStringValue($r('app.string.number_of_purchases')).then((value) => {
      this.purchase = value.toString();
    })
  }
}