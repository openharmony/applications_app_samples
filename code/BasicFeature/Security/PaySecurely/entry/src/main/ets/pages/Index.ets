/*
* Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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

import { MerchantServer } from '@ohos/cloud';
import common from '@ohos.app.ability.common';

interface ProductInfo {
  id: string,
  name: string,
  price: string,
  img: string,
}

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State products: ProductInfo[] = [];
  private context = getContext(this) as common.UIAbilityContext;

  aboutToAppear() {
    this.products = MerchantServer.getInstance().getProducts();
  }

  build() {
    List() {
      ForEach(this.products, (item: ProductInfo, index: number) => {
        ListItem() {
          Column(){
            Row() {
              Image($r('app.media.product'))
                .height(70)
                .aspectRatio(1)
                .margin({left: 16})
              Column() {
                Text(item.name)
                  .margin({top: 21})
                  .fontSize(16)
                Text(item.price)
                  .margin({top: 3})
                  .fontColor($r('app.color.red'))
                  .fontSize(16)
                  .fontWeight(900)
              }
              .margin({left: 16})
              .height(90)
              .width('100%')
              .alignItems(HorizontalAlign.Start)
            }
            .backgroundColor(Color.White)

            Divider()
              .margin({left: 16, right: 16})
              .backgroundColor(Color.Black)
              .strokeWidth(0.5)
              .opacity(0.05)
          }

        }
        .id(`main_list_item_${index}`)
        .onClick(async () => {
          let orderString = await MerchantServer.getInstance().placeAnOrder(item);
          this.context.startAbility({
            bundleName: 'com.samples.pay',
            moduleName: 'paySDK',
            abilityName: 'PaySDKAbility',
            parameters: {
              'orderString': orderString,
            },
          });
        })

      }, (item: ProductInfo, index: number) => JSON.stringify(item) + index)
    }
    .backgroundColor($r('app.color.normal_background'))
    .borderRadius(16)
    .padding(12)
    .height('100%')
    .width('100%')
  }
}