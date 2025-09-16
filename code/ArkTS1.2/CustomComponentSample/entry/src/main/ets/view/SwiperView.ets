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
  $r
} from '@ohos.arkui.component';
import { State } from '@ohos.arkui.stateManagement';
import hilog from '@ohos.hilog';
import { TextCardNode, NodePool } from '../utils/BuilderNodePool';

@Builder
export function swiperBuilder() {
  SubSwiper()
}
// 自定义组件复用池子组件
@Component
export struct SwiperNode {
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
export struct SubSwiper {
  @State images: Resource[] = [
    $r('app.media.custom_reusable_text_expand_img1'),
    $r('app.media.custom_reusable_text_expand_img2'),
    $r('app.media.custom_reusable_text_expand_img3'),
    $r('app.media.custom_reusable_text_expand_img4')
  ];

  build() {
    Swiper() {
      ForEach(this.images, (item: Resource, index: number) => {
        Image(item)
          .width('100%')
          .height('100%')
      },(item: Resource, index: number) => index.toString())
    }
    .loop(true)
    .width('100%')
    .height(200)
    .nestedScroll(SwiperNestedScrollMode.SELF_FIRST)
    .id('id_custom_reusable_pool_banner')
  }
}