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
import { CustomEmitter } from '@ohos/emitter';
import { EventsDialog } from '../components/EventsDialog';
import { PRODUCT_DATA } from '../mock/ProductsData';
import { ProductDataModel } from '../model/GoodsModel';
import emitter from '@ohos.events.emitter';

class GoodsListInner {
  id: number = 0
}

class GoodsList {
  data: GoodsListInner = {
    id: 0
  }
}

@Entry
@Component
struct Index {
  @StorageLink('shoppingCartGoodsList') shoppingCartGoodsList: GoodsList[] = [];
  private emitterClass: CustomEmitter = new CustomEmitter();
  eventsDialogController: CustomDialogController = new CustomDialogController({
    builder: EventsDialog(),
    customStyle: true
  });

  aboutToAppear() {
    this.emitterClass.showEventsDialog(() => {
      this.eventsDialogController.open();
    })
    this.emitterClass.setShoppingCartGoodsList((eventData: emitter.EventData) => {
      if (eventData.data) {
        this.shoppingCartGoodsList.push(eventData.data.id);
        AppStorage.setOrCreate('shoppingCartGoodsList', this.shoppingCartGoodsList);
      }
    });
    this.emitterClass.deleteShoppingCartGoodsList((eventData: emitter.EventData) => {
      if (eventData.data) {
        this.shoppingCartGoodsList.splice(eventData.data.id, 1);
        AppStorage.setOrCreate('shoppingCartGoodsList', this.shoppingCartGoodsList);
      }
    });
  }

  build() {
    Scroll() {
      Column() {
        GridRow({ gutter: { x: vp2px(8), y: vp2px(8) }, }) {
          ForEach(PRODUCT_DATA, (item: ProductDataModel, index: number) => {
            GridCol({ span: { sm: 6, md: 6, lg: 4 } }) {
              Column() {
                // 此处的商品图片需要根据父组件的宽度而变化，这里使用70%
                Image(item.uri)
                  .width('70%')
                  .aspectRatio(1)
                  .objectFit(ImageFit.Contain)
                  .margin({ bottom: 12 })

                Column() {
                  Text(item.title)
                    .id(index.toString())
                    .width('100%')
                    .fontSize(14)

                  Text(item.info)
                    .width('100%')
                    .fontSize(14)
                    .margin({ top: 6 })

                  Text(item.price)
                    .fontColor($r('app.color.pink'))
                    .fontSize(16)
                    .margin({ top: 6 })
                    .offset({ x: -3 }) // 因为￥是中文字符，上面的xx是中文字符，占的宽度不一样，所以需要对齐，添加offset

                  Column() {
                    Text(item.label)
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
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/Detail',
                  params: { goodId: item.id, goodItem: item }
                })
              })
            }
          })
        }
        .margin({ left: 12, right: 12 })
        .onAreaChange((oldArea: Area, newArea: Area) => {
          AppStorage.setOrCreate('listHeight', newArea.height as number);
        })
      }
    }
    .backgroundColor('#F1F3F5')
  }
}