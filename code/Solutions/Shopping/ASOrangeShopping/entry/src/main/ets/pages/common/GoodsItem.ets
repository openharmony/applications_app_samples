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
import RouterUtil from '../../utils/RouterUtil';

import { GOODS_LIST, GOODS_TYPE_LIST, GOODS_DATA_ROOT } from '../../data/GoodsData';


@Preview
@Component
export struct GoodsItem {
  @State goods: GoodsInfo = GOODS_LIST[0];
  @State isSimpleMode: boolean = false; //适配猜你喜欢页面需要显示的简略信息
  private bigTextSize: number = 20;
  private mediumTextSize: number = 16;
  private smallTextSize: number = 14;

  @Styles hideInSimpleMode() {
    .visibility(this.isSimpleMode ? Visibility.None : Visibility.Visible)
  }

  build() {
    Column() {
      // 此处的商品图片需要根据父组件的宽度而变化，这里使用65%
      Image(GOODS_DATA_ROOT + this.goods.imageUrl)
        .width('65%')
        .aspectRatio(1)
        .objectFit(ImageFit.Contain)

      Divider()
        .strokeWidth(1)
        .margin(6)

      Column() {
        Text(this.goods.title)
          .maxLines(2)
          .fontSize(this.bigTextSize)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Text(this.goods.introduction)
          .maxLines(2)
          .margin({ bottom: 6 })
          .fontColor(Color.Gray)
          .fontSize(this.smallTextSize)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Text(this.goods.price)
          .fontSize(this.bigTextSize)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.pink'))
        Text(this.goods.old_price)
          .width('100%')
          .fontSize(this.mediumTextSize)
          .fontColor(Color.Gray)
          .margin({ left: 3 })
          .hideInSimpleMode()
          .decoration({ type: TextDecorationType.LineThrough })

        Row({ space: 6 }) {
          ForEach(this.goods.type.split(','), item => {
            Text(GOODS_TYPE_LIST[parseInt(item)])
              .margin({ top: 6, bottom:6 })
              .borderRadius(6)
              .fontWeight(FontWeight.Bold)
              .fontSize(this.mediumTextSize)
              .textAlign(TextAlign.Center)
              .size({ width: 45, height: 25 })
              .fontColor($r('app.color.white'))
              .backgroundColor($r('app.color.pink'))
          })
        }
        .width('100%')
        .justifyContent(FlexAlign.End)
        .hideInSimpleMode()
      }
      .width('100%')
      .padding({ left: 12, right: 12 })
      .alignItems(HorizontalAlign.Start)
    }
    .borderRadius(12)
    .padding({ top: 6, bottom: 6 })
    .backgroundColor($r('app.color.white'))
    .onClick(() => {
      RouterUtil.gotoProductDetail(this.goods);
    })
  }
}