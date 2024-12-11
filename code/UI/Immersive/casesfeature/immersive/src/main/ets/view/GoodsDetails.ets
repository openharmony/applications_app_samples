/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { promptAction } from '@kit.ArkUI';
import { ProductDataModel } from '../model/GoodsModel';
import { ImmersiveDialog } from '../dialog/ImmersiveDialog';

const COLUMN_SPACE = 20; // column间隙

@Component
export struct GoodsDetails {
  @State item: ProductDataModel | undefined = undefined;
  @Consume navPathStack: NavPathStack;

  aboutToAppear(): void {
    this.item = this.navPathStack.getParamByIndex(this.navPathStack.size() - 1) as ProductDataModel;
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Stack({ alignContent: Alignment.Bottom }) {
        Column() {
          // 商品图片
          Image(this.item?.uri)
            .width($r('app.string.immersive_max_size'))
            .height('60%')
            .onClick(() => {
              promptAction.showToast({ message: $r('app.string.immersive_only_show') });
            })
          // 商品详情区
          ProductInfo({ item: this.item })
        }
        .width($r('app.string.immersive_max_size'))
        .height($r('app.string.immersive_max_size'))

        // 底部购买区
        Row() {
          Button($r('app.string.immersive_add_cart'))
            .height($r('app.string.immersive_vp_30'))
            .fontSize($r('app.string.immersive_vp_15'))
            .linearGradient({
              angle: 90,
              colors: [[$r('app.color.immersive_buttonColor'), 0.5], [$r('app.color.immersive_orange'), 1.0]]
            })
            .margin({ right: $r('app.string.immersive_vp_10') })
            .onClick(() => {
              promptAction.showToast({ message: $r('app.string.immersive_only_show') });
            })


          Button($r('app.string.immersive_settlement'))
            .height($r('app.string.immersive_vp_30'))
            .fontSize($r('app.string.immersive_vp_15'))
            .linearGradient({
              angle: 90,
              colors: [[$r('app.color.immersive_buttonColor'), 0.5], [$r('app.color.immersive_orange'), 1.0]]
            })
            .onClick(() => {
              promptAction.showToast({ message: $r('app.string.immersive_only_show') });
            })
        }
        .width($r('app.string.immersive_max_size'))
        .padding({ top: $r('app.string.immersive_vp_15'), left: $r('app.string.immersive_vp_15'), right: $r('app.string.immersive_vp_15')})
        .backgroundColor($r('app.color.immersive_barColor'))
        .justifyContent(FlexAlign.End)
        .border({
          width: { top: $r('app.string.immersive_vp_1') },
          color: { top: $r('sys.color.ohos_id_color_component_normal') },
        })
        // 设置底部绘制延伸至导航条
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
      }
      .height('100%')

      Row() {
        Image($r('app.media.immersive_back'))
          .width(30)
          .height(30)
          .borderRadius(15)
          .backgroundColor(Color.Gray)
          .opacity(0.5)
          .onClick(() => {
            this.navPathStack.pop();
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .padding({ left: 10 })
    }
    .height('100%')
    .width('100%')
  }
}

@Component
struct ProductInfo {
  @Link item: ProductDataModel;
  // 底部弹框
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: ImmersiveDialog(),
    cancel: () => {
      this.dialogController?.close();
    },
    isModal: true,
    alignment: DialogAlignment.Bottom,
    customStyle: true
  });

  build() {
    Row() {
      Column({ space: COLUMN_SPACE }) {
        Row() {
          Text(this.item.price)// 动态设置组件样式
            .fontSize($r('app.string.immersive_vp_30'))
            .fontColor($r('app.color.immersive_orange'))
            .fontWeight(FontWeight.Bolder)

          Text($r('app.string.immersive_sold'))
            .fontColor(Color.Gray)
            .fontSize($r('app.string.immersive_vp_15'))
            .fontWeight(FontWeight.Normal);
        }
        .width($r('app.string.immersive_max_size'))
        .justifyContent(FlexAlign.SpaceBetween)

        Row() {
          Text($r('app.string.immersive_full_reduction'))
            .fontSize($r('app.string.immersive_vp_15'))
            .fontColor($r('app.color.immersive_orange'))
            .textAlign(TextAlign.Center)
            .border({
              width: $r('app.string.immersive_vp_1'),
              color: $r('app.color.immersive_orange'),
              style: BorderStyle.Solid
            })
            .margin({ right: $r('app.string.immersive_vp_10') });

          Button($r('app.string.immersive_coupon_collection'))
            .height($r('app.string.immersive_vp_15'))
            .backgroundColor($r('app.color.immersive_red'))
            .onClick(() => {
              promptAction.showToast({ message: $r('app.string.immersive_only_show') });
            })
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width($r('app.string.immersive_max_size'))

        Text(this.item.title)
          .fontSize($r('app.string.immersive_vp_20'))
          .fontWeight(FontWeight.Bold)
          .fontColor($r('sys.color.ohos_id_counter_title_font_color'))

        Text($r('app.string.immersive_commodity_model'))
          .fontColor(Color.Gray)
          .fontSize($r('app.string.immersive_vp_20'))
          .fontWeight(FontWeight.Normal)
          .onClick(() => {
            this.dialogController?.open();
          })
      }
      .backgroundColor($r('app.color.immersive_white'))
      .padding($r('app.string.immersive_vp_10'))
      .borderRadius($r('app.string.immersive_vp_10'))
      .height($r('app.string.immersive_max_size'))
      .alignItems(HorizontalAlign.Start)
    }
    .backgroundColor($r('sys.color.ohos_id_color_component_normal'))
    .padding($r('app.string.immersive_vp_10'))
    .height($r('app.string.immersive_text_proportion'))
    .width($r('app.string.immersive_max_size'))
  }
}
