/*
 *
 *  Copyright (c) 2023 Huawei Device Co., Ltd.
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */

import GoodsInfo from '../../model/GoodsModel';
import { GoodsItem } from './GoodsItem';

@Component
export struct ResultList {
  @Consume('resultList') resultList: Array<GoodsInfo>;

  build() {
    Column() {
      Scroll() {
        GridRow({ gutter: { x: vp2px(8), y: vp2px(8) } }) {
          ForEach(this.resultList, (item: GoodsInfo) => {
            GridCol({ span: { sm: 6, md: 6, lg: 4 } }) {
              // 快速选择的渲染条件，如果有当前类型的标签，才会进行渲染
              GoodsItem({ goods: item });
            }
          });
        }
        .width('100%')
        .margin({ left: 12, right: 12, bottom: 160 })
      }
      .scrollBar(BarState.Off)
      .alignSelf(ItemAlign.Center)
      .constraintSize({ minHeight: '100%' });
    }
    .height('100%')
  }
}