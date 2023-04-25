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

import promptAction from '@ohos.promptAction';
import RouterUtil from '../../utils/RouterUtil';
import { EmitterUtil } from 'shoppingdata';
import { GoodsInfo } from '../../model/DetailMode';
import { logger } from '../../utils/Logger';
import { ShoppingDataUtil } from '../../utils/ShoppingDataUtil';

@Component
export struct BottomNavigation {
  @StorageProp('curBp') curBp: string = 'md';
  @LocalStorageProp('goodsInfo') goodsInfo: GoodsInfo = new GoodsInfo();
  @StorageLink('goods_data_update') @Watch('onUpdate') updateTime: number = 0;
  @State goodsCount: number = 0;
  private context: Context = getContext(this);
  private shoppingDataUtil: ShoppingDataUtil;

  onUpdate() {
    this.shoppingDataUtil.getGoodsInfo(parseInt(this.goodsInfo.id)).then(goodsInfo => {
      this.goodsInfo = goodsInfo;
      logger.info('onUpdate info: ' + JSON.stringify(this.goodsInfo));
    });
  }

  aboutToAppear() {
    this.shoppingDataUtil = new ShoppingDataUtil(this.context);
    this.onUpdate();
  }

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
          AppStorage.SetOrCreate('tabsIndex', 0);
          RouterUtil.goHome();
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
          AppStorage.SetOrCreate('tabsIndex', 1);
          RouterUtil.goHome();
        })
      }
      .layoutWeight(1)
      .justifyContent(this.curBp === 'sm' ? FlexAlign.SpaceEvenly : FlexAlign.Start)

      Row() {
        Row() {
          Text($r('app.string.add_to_cart'))
            .fontColor($r('app.color.white'))
            .fontSize(this.curBp === 'sm' ? 16 : 20)
        }
        .alignItems(VerticalAlign.Center)
        .padding({ left: 20, right: 20 })
        .onClick(() => {
          // 通过Emitter将商品id与商品数量进行同步
          new EmitterUtil().changeGoods(this.goodsInfo.id, ++this.goodsInfo.count);
          logger.info('click to add goods.' + this.goodsInfo.id);
          promptAction.showToast({ message: $r('app.string.add_to_cart') })
        })

        Row() {
          Text($r('app.string.buy_now'))
            .fontColor($r('app.color.white'))
            .fontSize(this.curBp === 'sm' ? 16 : 20)
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