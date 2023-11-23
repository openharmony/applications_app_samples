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

import { PRODUCT_DATA, Products_Data } from '../mock/ProductsData';
import { GoodResponse, ProductDataModel } from '../model/GoodsModel';

@Component
export struct GoodsList {
  @State getDataFromHttp: boolean = false;
  @State productsData: GoodResponse = Products_Data;
  @State active: boolean = false;
  @State isShow: boolean = false;

  build() {
    GridRow({ gutter: { x: vp2px(8), y: vp2px(8) }, }) {
      ForEach(PRODUCT_DATA, (item: ProductDataModel) => {
        GridCol({ span: { sm: 6, md: 6, lg: 4 } }) {
          Column() {
            Image(item.uri)
              .id('goods' + item.id)
              .width('70%')
              .aspectRatio(1)
              .clip(true)
              .objectFit(ImageFit.Contain)
              .margin({ bottom: 12 })
            Column() {
              Text(item.title)
                .width('100%')
                .fontSize(14)

              Text(item.info)
                .width('100%')
                .fontSize(12)
                .fontColor("#858184")
                .margin({ top: 6 })

              Text(item.price)
                .fontColor($r('app.color.pink'))
                .fontSize(16)
                .margin({ top: 6 })
                .offset({ x: -3 }) // 因为￥是中文字符，上面的xx是中文字符，占的宽度不一样，所以需要对齐，添加offset

              Column() {
                Text(item.labels)
                  .fontSize(10)
                  .fontColor($r('app.color.white'))
              }
              .borderRadius(6)
              .padding({ left: 6, right: 6, top: 4, bottom: 4 })
              .backgroundColor($r('app.color.pink'))
              .margin({ top: 6 })
            }
            .alignItems(HorizontalAlign.Start)
          }
          .borderRadius(10)
          .padding(12)
          .backgroundColor($r('app.color.white'))
        }
      }, (item: ProductDataModel) => item.id.toString())
    }
    .padding({ left: 12, right: 12 })
    .onAreaChange((newArea: Area) => {
      AppStorage.setOrCreate('listHeight', newArea.height as number);
    })
  }
}
