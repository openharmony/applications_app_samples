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
import Resource2String from '../../utils/StringUtil';

import { FastSelections } from '../common/FastSelections';
import { GoodsItem } from '../common/GoodsItem';
import { GoodsFlow } from '../../model/GoodsFlow';
import { GOODS_TYPE, getGoodsList } from '../../data/GoodsData';
import { SearchBar } from '../common/SearchBar';
import { UserTitle } from '../common/UserTitle';
import { WaitDialog } from '../common/WaitDialog';


@Component
export struct Home {
  @State childWidth: number = 0;
  @State childHeight: number = 0;
  @State goodsFlow: GoodsFlow = GoodsFlow.getInstance();
  @State currentList: Array<GoodsInfo> = [];
  @State @Watch("myChange") currentGoodsType: number = GOODS_TYPE.SELECTED.valueOf();
  private waitDialog: CustomDialogController = new CustomDialogController({
    builder: WaitDialog({ showTime: 3000 }),
    autoCancel: false,
    customStyle: true
  });
  private stringUtil: Resource2String = new Resource2String(getContext(this));

  aboutToAppear() {
    getGoodsList(GOODS_TYPE.SELECTED).then(list => {
      this.currentList = list;
      this.goodsFlow.loadList(this.currentList);
    });
    this.waitDialog.open();
  }

  build() {
    Column() {
      UserTitle()
      SearchBar()
      FastSelections({ currentGoodsType: $currentGoodsType })

      Scroll() {
        GridRow({ gutter: { x: vp2px(8), y: vp2px(8) } }) {
          LazyForEach(this.goodsFlow, (item: GoodsInfo) => {
            GridCol({ span: { sm: 6, md: 6, lg: 4 } }) {
              GoodsItem({ goods: item })
            }
          }, item => Date.now().toString() + item);
        }
        .width('100%')
        .margin({ bottom: 160 })
      }
      .scrollBar(BarState.Off)
      .alignSelf(ItemAlign.Center)
      .constraintSize({ minHeight: '100%' })
    }
    .height('100%')
    .padding({ left: 12, right: 12 })
  }

  myChange() {
    getGoodsList(this.currentGoodsType).then(list => {
      this.currentList = list;
      this.goodsFlow.loadList(this.currentList);
    })
  }
}