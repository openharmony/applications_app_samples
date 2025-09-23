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
  wrapBuilder,
  SwiperNestedScrollMode,
  Swiper,
  ForEach,
  Image,
  Resource,
  $r,
  SafeAreaType,
  SafeAreaEdge,
  Scroll,
  Scroller
} from '@ohos.arkui.component';
import { State } from '@ohos.arkui.stateManagement';
import { swiperBuilder, SwiperNode, SubSwiper } from './SwiperView';
import { flowItemBuilder, FlowItemNode, SubFlowItem } from './FlowItemView';
import hilog from '@ohos.hilog';

const REUSE_VIEW_TYPE_SWIPER: string = 'reuse_type_swiper_';
const REUSE_VIEW_TYPE_ITEM: string = 'reuse_type_';

@Builder
export function thisSwiperBuilder() {
  swiperBuilder();
}

@Builder
export function thisFlowItemBuilder() {
  flowItemBuilder();
}

// 瀑布流子组件WrappedBuilder对象
let flowItemWrapper: WrappedBuilder<CustomBuilder> = wrapBuilder<CustomBuilder>(thisFlowItemBuilder);
// 瀑布流轮播图WrappedBuilder对象
let swiperWrapper: WrappedBuilder<CustomBuilder> = wrapBuilder<CustomBuilder>(thisSwiperBuilder);

// 自定义组件复用池页面
@Component
export struct TabNode {
  scroller: Scroller = new Scroller();

  build() {
    Scroll(this.scroller) {
      Column() {
        SwiperNode({
          type: REUSE_VIEW_TYPE_SWIPER,
          builder: swiperWrapper
        })
        FlowItemNode({
          type: REUSE_VIEW_TYPE_ITEM,
          builder: flowItemWrapper
        })
      }
    }
    .width('100%')
    .height('100%')
    .clip(false)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }
}