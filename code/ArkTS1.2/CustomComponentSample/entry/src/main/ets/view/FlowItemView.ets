'use static';
/**
 *
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 *
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice,this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS,
 *
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import {
  Entry,
  Text,
  Column,
  Component,
  Button,
  ClickEvent,
  WrappedBuilder,
  NodeContainer,
  Builder,
  CustomBuilder,
  SwiperNestedScrollMode,
  Swiper,
  ForEach,
  Image,
  Resource,
  Margin,
  $r,
  Color,
  WaterFlow,
  FlowItem,
  SafeAreaType,
  SafeAreaEdge,
  BorderRadiuses,
  NestedScrollMode
} from '@ohos.arkui.component';
import { State } from '@ohos.arkui.stateManagement';
import hilog from '@ohos.hilog';
import { TextCardNode, NodePool } from '../utils/BuilderNodePool';
import { ViewItem } from '../data/ViewItem';

@Builder
export function flowItemBuilder() {
  SubFlowItem()
}

// 自定义组件复用池子组件
@Component
export struct FlowItemNode {
  @State type: string = '';
  @State builder: WrappedBuilder<CustomBuilder> | null = null;
  private nodeItem: TextCardNode = new TextCardNode();

  aboutToAppear(): void {
    this.nodeItem = NodePool.getInstance().getNode(this.type, this.builder!)!;
  }
  aboutToRecycle(): void {
    this.nodeItem?.node?.recycle();
  }
  aboutToReuse(params: ESValue): void {
    this.nodeItem?.node?.reuse(params);
  }
  build() {
    NodeContainer(this.nodeItem)
  }
}

@Component
export struct SubFlowItem {
  furnitureImages: Resource[] = [$r('app.media.custom_reusable_waterFlow1'), $r('app.media.custom_reusable_waterFlow2'),
    $r('app.media.custom_reusable_waterFlow3'), $r('app.media.custom_reusable_waterFlow4'),
    $r('app.media.custom_reusable_waterFlow5'), $r('app.media.custom_reusable_waterFlow6'),
    $r('app.media.custom_reusable_waterFlow7'), $r('app.media.custom_reusable_waterFlow8')];
  furnitureNames: string[] = ['地铁口 精装带地暖三房', '精装花了两百多万',
    '靠东白马湖 高楼层视野开阔', '万科映月华庭',
    '乐虹湾三房精装修好', '湘湖地铁口，次新小区',
    '白马湖畔 三千余户的小区', '开发商精装，面对花园'];
  furnitureDes: string[] = ['3室2厅 | 88.78㎡ | 南 北', '5室2厅 | 256.86㎡ | 南',
  '3室2厅 | 88.86㎡ | 南', '3室2厅 | 81.72㎡ | 东 南',
  '3室2厅 | 88.86㎡ | 南', '3室2厅 | 88.86㎡ | 南',
  '3室2厅 | 88.86㎡ | 南', '3室2厅 | 89.71㎡ | 南'];
  @State data: ViewItem[] = [] as ViewItem[];

  aboutToAppear(): void {
    for (let i = 0; i < 10; i++) {
      const viewItem: ViewItem = new ViewItem();
      viewItem.id = i + '';
      viewItem.name = this.furnitureNames[i%this.furnitureNames.length];
      viewItem.des = this.furnitureDes[i%this.furnitureDes.length];
      viewItem.type = i % 2;
      viewItem.image = this.furnitureImages[i%this.furnitureImages.length];
      this.data = [...this.data, viewItem];
    }
  }

  build() {
    WaterFlow() {
      ForEach(this.data, (item: ViewItem, index: number) => {
        FlowItem() {
          Column() {
            Image(item.image)
              .width('100%')
              .borderRadius({ topLeft: 10, topRight: 10 } as BorderRadiuses)
            Text(item.name)
              .fontSize(14)
              .fontColor(Color.Black)
              .margin({ top: 10 } as Margin)
            Text(item.des)
              .fontSize(12)
              .fontColor(Color.Grey)
          }
          .borderRadius(10)
          .backgroundColor(Color.White)
        }
        .width('100%')
      }, (item: ViewItem, index: number) => item.name)
    }
    .margin({ top: 2 } as Margin)
    .columnsTemplate('1fr 1fr')
    .columnsGap(10)
    .rowsGap(5)
    .backgroundColor('#FAEEE0')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    .width('100%')
    .height('100%')
    .clip(false)
    .nestedScroll({
      scrollForward: NestedScrollMode.PARENT_FIRST,
      scrollBackward: NestedScrollMode.SELF_FIRST
    })
    .id('id_custom_reusable_pool_list')
  }
}
