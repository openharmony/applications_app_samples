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

import GoodsInfo from '../../model/GoodsModel';

import { GOODS_DATA_ROOT } from '../../data/GoodsData';
import { logger } from '../../utils/Logger';
import { ShoppingDataUtil } from '../../utils/ShoppingDataUtil';

@Preview
@Component
export struct GoodsInCart {
  @StorageProp('curBp') curBp: string = 'sm';
  @StorageLink('goods_data_update') @Watch('onUpdate') updateTime: number = 0;
  private shoppingDataUtil: ShoppingDataUtil;
  private context: Context = getContext(this);
  @State goodsListInCart: Array<GoodsInfo> = [];

  onUpdate() {
    this.shoppingDataUtil.getGoodsList().then(list => {
      this.goodsListInCart = list;
      logger.info('goods list in cart : ' + list.toString());
    })
  }

  aboutToAppear() {
    this.shoppingDataUtil = new ShoppingDataUtil(this.context);
    this.onUpdate();
  }

  build() {
    Column() {
      Row() {
        CheckboxGroup({ group: 'goodsInCart' })
          .width(16)
          .aspectRatio(1)
          .selectedColor($r('app.color.pink'))

        Text($r('app.string.shopping_self_support'))
          .fontSize(14)
          .fontWeight(400)
          .fontColor(Color.Black)
      }
      .margin(12)
      .width('100%')

      ForEach(this.goodsListInCart ? this.goodsListInCart : [], (item: GoodsInfo) => {
        Row() {
          Checkbox({ name: item.title, group: 'goodsInCart' })
            .width(16)
            .aspectRatio(1)
            .selectedColor($r('app.color.pink'))

          Image(GOODS_DATA_ROOT + item.imageUrl)
            .width(65)
            .height(70)
            .objectFit(ImageFit.Contain)
            .margin({ left: 12, right: 16 })

          Column() {
            Text(item.title)
              .fontSize(14)
              .fontWeight(400)
              .textOverflow({ overflow: TextOverflow.Ellipsis })

            Text(item.introduction)
              .fontSize(12)
              .opacity(0.6)
              .margin({ top: 6 })
              .textOverflow({ overflow: TextOverflow.Ellipsis })

            Text(item.price)
              .fontSize(16)
              .fontColor($r('app.color.pink'))
              .fontWeight(FontWeight.Medium)
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(2)

          Blank()

          Row() {
            Image($r('app.media.reduce'))
              .width(20)
              .height(20)
              .objectFit(ImageFit.Auto)
              .onClick(() => {
                this.shoppingDataUtil.changeGoods(item.id, item.count - 1);
              })
            Text(`${item.count}`)
              .fontSize(14)
              .margin({ left: 10, right: 10 })
            Image($r('app.media.add'))
              .width(20)
              .height(20)
              .objectFit(ImageFit.Auto)
              .onClick(() => {
                this.shoppingDataUtil.changeGoods(item.id, item.count + 1);
              })
          }
          .height(80)
          .layoutWeight(1)
          .margin({ left: 6, top: 12, bottom: 12 })
        }
        .width('100%')
        .padding({ left: 12, right: 12 })
      })
    }
    .width('100%')
    .borderRadius(16)
    .margin(12)
    .backgroundColor($r('app.color.white'))
  }
}