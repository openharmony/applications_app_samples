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

import { PRODUCT_DATA } from '../mock/GoodsMock';
import { ProductDataModel } from '../model/GoodsModel';
import { promptAction } from '@kit.ArkUI';

const GUTTER_X: number = 8; // 商品上下间隔
const GUTTER_Y: number = 8; // 商品左右间隔
const IMAGE_ASPECT_RATIO: number = 1; // 图片的宽高比
const OFFSET: number = -3; // 价格控件偏移量
const SPAN: number = 6; // 超过规定列数6时自动换行


@Component
export struct GoodsList {
  build() {
    GridRow({ gutter: { x: GUTTER_X, y: GUTTER_Y }, }) {
      // GridRow组件不支持LazyForEach方法
      ForEach(PRODUCT_DATA, (item: ProductDataModel) => {
        GridCol({ span: SPAN }) {
          ItemView({ item: item })
        }
      }, (item: ProductDataModel) => item.id.toString())
    }
    .padding({
      left: $r("app.integer.immersive_grid_row_padding"),
      right: $r("app.integer.immersive_grid_row_padding"),
      top: $r("app.integer.immersive_grid_row_padding")
    })
    .backgroundColor($r("app.color.immersive_list_bg_color"))
    // 设置列表绘制延伸至状态栏
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }
}

@Component
struct ItemView {
  @Prop item: ProductDataModel;
  @Consume navPathStack: NavPathStack;

  build() {
    Column() {
      // 此处的商品图片需要根据父组件的宽度而变化，这里使用70%
      Image(this.item.uri)
        .width('70%')
        .aspectRatio(IMAGE_ASPECT_RATIO)
        .objectFit(ImageFit.Contain)
        .margin({ bottom: $r("app.integer.immersive_goods_image_margin_bottom") })

      Column() {
        Text(this.item.title)
          .width('100%')
          .fontSize($r("app.integer.immersive_goods_font"))
          .fontColor($r('sys.color.ohos_id_color_foreground'))
        Flex({ justifyContent: FlexAlign.SpaceBetween }) {
          Text(this.item.price)
            .fontSize($r("app.integer.immersive_goods_font"))
            .offset({ x: OFFSET })// 因为￥是中文字符，上面的是中文字符，占的宽度不一样，所以需要对齐，添加offset
            .fontColor($r('sys.color.ohos_id_color_foreground'))
          Row() {
            Image($r("app.media.immersive_view"))
              .fillColor($r("app.color.immersive_view_fill_color"))
              .width($r("app.integer.immersive_view_image_width"))
              .aspectRatio(IMAGE_ASPECT_RATIO)
              .objectFit(ImageFit.Contain)

            Text(this.item.views)
              .fontSize($r("app.integer.immersive_view_font"))
              .margin({ left: $r("app.integer.immersive_view_margin_left") })
              .fontColor($r('sys.color.ohos_id_color_foreground'))
          }.alignItems(VerticalAlign.Center)
        }.margin({ top: $r("app.integer.immersive_flex_margin_top") })

      }
      .margin({ left: $r("app.integer.immersive_goods_column_padding_left") })
      .alignItems(HorizontalAlign.Start)
    }
    .onClick(() => {
      this.navPathStack.pushPathByName('goodsDetail', this.item);
    })
    .borderRadius($r("app.integer.immersive_goods_border_radius"))
    .padding($r("app.integer.immersive_column_padding"))
    .backgroundColor($r('app.color.immersive_product_bg_color'))
  }
}