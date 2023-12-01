/*
* Copyright (c) 2022 Huawei Device Co., Ltd.
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
import { ProductDataModel } from '../model/GoodsModel';

@CustomDialog
struct HasSubscriberDialog {
  hasSubscriber?: CustomDialogController;

  build() {
    Column() {
      Text($r('app.string.purchase_successful'))
        .fontSize(16)
        .textAlign(TextAlign.Center)
        .fontColor($r('app.color.blank'))
        .fontFamily('HarmonyHeiTi')
        .fontWeight(500)
        .height('6.8%')
        .margin('1.3%')
      Text($r('app.string.determine_popup'))
        .fontSize(16)
        .fontColor($r('app.color.blue'))
        .textAlign(TextAlign.Center)
        .fontFamily('HarmonyHeiTi')
        .fontWeight(500)
        .onClick(() => {
          if (this.hasSubscriber != undefined) {
            this.hasSubscriber.close();
          }
        })
        .padding('1.3%')
    }
    .margin('2.1%')
  }
}

@Component
export struct BottomNavigation {
  @StorageProp('curBp') curBp: string = 'md';
  @Link goodItemData: ProductDataModel;
  private emitterClass: CustomEmitter = new CustomEmitter();
  hasSubscriberForEvent: CustomDialogController | null = new CustomDialogController({
    builder: HasSubscriberDialog(),
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: -15 },
    cornerRadius: 24
  })

  build() {
    Row() {
      Row() {
        Column() {
          Image($r('app.media.home'))
            .width(22)
            .height(22)
          Text($r('app.string.home_page'))
            .fontColor($r('app.color.blank'))
            .fontSize(10)
            .opacity(0.6)
            .margin({ top: 4 })
        }
        .width(74)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/Index'
          })
        })

        Column() {
          Image($r('app.media.cart'))
            .width(22)
            .height(22)
          Text($r('app.string.shopping_cart'))
            .fontColor($r('app.color.blank'))
            .fontSize(10)
            .opacity(0.6)
            .margin({ top: 4 })
        }
        .width(74)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/ShopCart'
          })
        })
      }
      .justifyContent(this.curBp === 'sm' ? FlexAlign.SpaceEvenly : FlexAlign.Start)
      .layoutWeight(1)

      Row() {
        Row() {
          Text($r('app.string.add_to_cart'))
            .fontColor($r('app.color.white'))
            .fontSize(this.curBp === 'sm' ? 16 : 20)
        }
        .alignItems(VerticalAlign.Center)
        .padding({ left: 20, right: 20 })
        .onClick(() => {
          this.emitterClass.addGoods(this.goodItemData.id)
        })

        Row() {
          Text($r('app.string.buy_now'))
            .fontColor($r('app.color.white'))
            .fontSize(this.curBp === 'sm' ? 16 : 20)
            .onClick(() => {
              if (this.hasSubscriberForEvent != null) {
                this.emitterClass.listenerEvents();
                this.hasSubscriberForEvent.open();
              }
            })
        }
        .alignItems(VerticalAlign.Center)
        .padding({ left: 20, right: 20 })
      }
      .height('100%')
      .borderRadius(50)
      .clip(true)
      .backgroundImage($r('app.media.carton'))
      .backgroundImagePosition(Alignment.Center)
    }
    .width('100%')
    .padding({ right: 20, top: 10, bottom: 10 })
    .height(56)
    .backgroundColor($r('app.color.divider'))
  }
}