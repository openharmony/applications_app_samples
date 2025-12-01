/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { flowItemBuilder, FlowItemNode } from './FlowItemNode';
import { ViewItem } from '../data/ViewItem';
import { WaterFlowDataSource } from '../data/WaterFlowDataSource';
import { swiperBuilder, SwiperNode } from './SwiperView';
import { banners1, banners2 } from '../data/MockData';
import { avatarData, furnitureData, goodsData, natureData, travelData } from '../data/MockData';

const REUSE_VIEW_TYPE_SWIPER: string = 'reuse_type_swiper_';

export const REUSE_VIEW_TYPE_ITEM: string = 'reuse_type_';

// 瀑布流子组件WrappedBuilder对象
export let flowItemWrapper: WrappedBuilder<ESObject> = wrapBuilder<ESObject>(flowItemBuilder);

// 瀑布流轮播图WrappedBuilder对象
let swiperWrapper: WrappedBuilder<ESObject> = wrapBuilder<ESObject>(swiperBuilder);

// 自定义组件复用池Swiper页面
@Component
export struct TabNode {
  minSize: number = 80;
  maxSize: number = 180;
  fontSize: number = 24;
  @State index: number = 0;
  scroller: Scroller = new Scroller();
  dataSource: WaterFlowDataSource = new WaterFlowDataSource();
  // FlowItem组件高度列表
  private itemHeightArray: number[] = [];
  // FlowItem组件宽度列表
  private itemWidthArray: number[] = [];

  // 计算FlowItem宽/高
  getSize() {
    let ret = Math.floor(Math.random() * this.maxSize);
    return (ret > this.minSize ? ret : this.minSize);
  }

  // 设置FlowItem的宽/高数组
  setItemSizeArray() {
    for (let i = 0; i < 100; i++) {
      this.itemWidthArray.push(this.getSize());
      this.itemHeightArray.push(this.getSize());
    }
  }

  aboutToAppear(): void {
    this.setItemSizeArray();
    // 添加模拟数据
    switch (this.index) {
      case 0:
        this.dataSource.addItems(furnitureData());
        break;
      case 1:
        this.dataSource.addItems(natureData());
        break;
      case 2:
        this.dataSource.addItems(goodsData());
        break;
      case 3:
        this.dataSource.addItems(travelData());
        break;
      case 4:
        this.dataSource.addItems(avatarData());
        break;
    }
  }

  // 更新数据方法
  fillNewData(item: ViewItem) {
    this.dataSource.addLastItem(item);
  }

  build() {
    Scroll(this.scroller) {
      Column({ space: 2 }) {
        SwiperNode({
          type: REUSE_VIEW_TYPE_SWIPER,
          images: this.index % 2 === 0 ? banners1 : banners2,
          builder: swiperWrapper
        })
        WaterFlow() {
          LazyForEach(this.dataSource, (item: ViewItem, index: number) => {
            FlowItem() {
              FlowItemNode({
                type: REUSE_VIEW_TYPE_ITEM,
                data: item,
                itemColor: Color.White,
                builder: flowItemWrapper
              })
            }
            .width($r('app.string.customreusablepool_percent_100'))
          }, (item: string) => item)
        }
        .columnsTemplate('1fr 1fr')
        .columnsGap($r('app.integer.customreusablepool_flow_columns_Gap'))
        .rowsGap($r('app.integer.customreusablepool_flow_rows_Gap'))
        .backgroundColor($r('app.string.customreusablepool_water_flow_background_color'))
        .width($r('app.string.customreusablepool_percent_100'))
        .height($r('app.string.customreusablepool_percent_100'))
        .nestedScroll({
          scrollForward: NestedScrollMode.PARENT_FIRST,
          scrollBackward: NestedScrollMode.SELF_FIRST
        })
      }
    }
    .width($r('app.string.customreusablepool_percent_100'))
    .height($r('app.string.customreusablepool_percent_100'))
  }
}