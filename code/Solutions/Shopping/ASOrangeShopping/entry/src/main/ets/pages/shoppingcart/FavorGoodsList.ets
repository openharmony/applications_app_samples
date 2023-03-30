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

import { GoodsItem } from '../common/GoodsItem';
import { GOODS_LIST } from '../../data/GoodsData';

@Component
export struct FavorGoodList {
  @State flag: boolean = false;
  @State productsData: Array<GoodsInfo> = GOODS_LIST;

  build() {
    Column() {
      Text($r('app.string.guess_you_like'))
        .fontSize(20)
        .fontColor(Color.Black)
        .padding({ top: 24, bottom: 20, left: 12 })

      GridRow({ gutter: { x: vp2px(8), y: vp2px(8) } }) {
        ForEach(this.productsData, (item: GoodsInfo) => {
          GridCol({ span: { sm: 6, md: 6, lg: 4 } }) {
            GoodsItem({ goods: item, isSimpleMode: true })
          }
        }, item => Date.now().toString() + item)
      }
      .width('100%')
      .margin({ bottom: 120 })
    }
  }
}
