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

import Http from '@ohos/http';
import { PRODUCT_DATA } from '../../mock/ProductsData';
import { GoodResponse, Info, ProductDataModel } from '../../model/GoodsModel';
import { Products_Data } from '../../mock/ProductsData';
import { DynamicLoader } from '../../common/DynamicLoader';

@Component
export struct GoodsList {
  @State getDataFromHttp: boolean = false;
  @Consume('pageStack') pageStack: NavPathStack;
  private url: string = '';
  private option: Object = new Object();
  @State productsData: GoodResponse = Products_Data;
  @State active: boolean = false;

  async aboutToAppear() {
    Http.setUrl(this.url);
    Http.setOptions(this.option);
    this.getDataFromHttp = false;
    let info = await Http.request();
    if (info.responseCode === 200 && info.result !== undefined) {
      this.getDataFromHttp = true;
      this.productsData = JSON.parse(info.result.toString());
    }
  }

  build() {
    GridRow({
      gutter: {
        x: vp2px(8),
        y: vp2px(8)
      },
    }) {
      ForEach(this.getDataFromHttp ? this.productsData.data.records : PRODUCT_DATA, (item: Info | ProductDataModel) => {
        GridCol({
          span: {
            sm: 6,
            md: 6,
            lg: 4
          }
        }) {
          Column() {

            // 方案二：使用router跳转页面，配合共享元素动画
            Image(item.uri)
              .id('goods' + item.id)
              .width('70%')
              .aspectRatio(1)
              .clip(true)
              .objectFit(ImageFit.Contain)
              .margin({ bottom: 12 })
              .sharedTransition('goods' + item.id, { duration: 600, curve: Curve.Linear, delay: 100 })

            Column() {
              Text(item.title)
                .width('100%')
                .fontSize(14)

              Text(item.info)
                .width('100%')
                .fontSize(12)
                .fontColor("#858184")
                .margin({
                  top: 6
                })

              Text(item.price as Resource)
                .fontColor($r('app.color.pink'))
                .fontSize(16)
                .margin({
                  top: 6
                })
                .offset({
                  x: -3
                }) // 因为￥是中文字符，上面的xx是中文字符，占的宽度不一样，所以需要对齐，添加offset

              Column() {
                Text(item.labels)
                  .fontSize(10)
                  .fontColor($r('app.color.white'))
              }
              .borderRadius(6)
              .padding({
                left: 6,
                right: 6,
                top: 4,
                bottom: 4
              })
              .backgroundColor($r('app.color.pink'))
              .margin({
                top: 6
              })
            }
            .alignItems(HorizontalAlign.Start)
          }
          .borderRadius(10)
          .padding(12)
          .backgroundColor($r('app.color.white'))

          // 方案二：使用正常router跳转，配合共享元素动画
          .onClick(() => {
            // 动态加载组件
            DynamicLoader.getInstance().fire('DetailPage').then(()=>{
              this.active = true;
              this.pageStack.pushPathByName('DetailPage', item);
            })
          })
        }
      }, (item: Info | ProductDataModel): string => item.id.toString())
    }
    .padding({
      left: 12,
      right: 12
    })
    .onAreaChange((oldValue: Area, newArea: Area) => {
      AppStorage.setOrCreate('listHeight', newArea.height as number);
    })
  }
}
