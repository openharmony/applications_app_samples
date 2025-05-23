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
import { GoodResponse, ShopCartItemDataModel } from '../model/GoodsModel';
import { PRODUCTS_Data, SHOP_CART_ITEM_DATA } from '../mock/ProductsData';

@Component
export struct FavorGoodList {
  private url: string = '';
  @State productsData: GoodResponse = PRODUCTS_Data;

  @Builder GoodItem(shopItem: ShopCartItemDataModel) {
    Column() {
      // 这里的图片需要根据父组件宽度自适应，此处使用70%
      Image(shopItem.uri)
        .width('70%')
        .aspectRatio(1)
        .objectFit(ImageFit.Contain)
        .margin({ bottom: 12 })
      Column() {
        Text(shopItem.title)
          .width('100%')
          .fontSize(14)
        Text(shopItem.price)
          .fontColor($r('app.color.red'))
          .fontSize(16)
          .margin({ top: 6 })
          .offset({ x: -3 }) // 因为￥是中文字符，上面的xx是中文字符，占的宽度不一样，所以需要对齐，添加offset
        Column() {
          Text(shopItem.label)
            .fontSize(10)
            .fontColor($r('app.color.white'))
        }
        .borderRadius(5)
        .margin({ top: 6 })
        .padding({ left: 6, right: 6, top: 4, bottom: 4 })
        .backgroundColor($r('app.color.red'))
      }
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .borderRadius(10)
    .padding(12)
    .backgroundColor($r('app.color.white'))
    .onClick(() => {
      router.pushUrl({
        url: 'pages/Detail',
        params: { goodId: shopItem.id, goodItem: shopItem }
      });
    })
  }

  build() {
    GridRow({ gutter: { x: vp2px(8), y: vp2px(8) } }) {
      ForEach(SHOP_CART_ITEM_DATA, (item: ShopCartItemDataModel) => {
        GridCol({ span: { sm: 6, md: 6, lg: 4 } }) {
          this.GoodItem(item);
        }
      }, (item: ShopCartItemDataModel, index: number) => item.toString() + index)
    }
    .onAreaChange((oldArea: Area, newArea: Area) => {
      AppStorage.setOrCreate('goodsListHeight', newArea.height as number);
    })
  }
}