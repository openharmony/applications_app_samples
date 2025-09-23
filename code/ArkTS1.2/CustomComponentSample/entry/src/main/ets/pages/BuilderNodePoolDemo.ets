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
  Text,
  Column,
  Component,
  Button,
  ClickEvent,
  Row,
  NodeContainer,
  WrappedBuilder,
  wrapBuilder,
  CustomBuilder,
  SwiperController,
  Swiper,
  Axis,
  List,
  ListItem,
  ForEach,
  Padding,
  Color,
  SafeAreaType,
  SafeAreaEdge,
  ListItemAlign,
  LazyForEach,
  HorizontalAlign,
  TextAlign
}
from '@ohos.arkui.component';
import { State } from '@ohos.arkui.stateManagement';
import { Constants }from '../constants/Constants';
import { Title } from '../data/TitleBean';
import { TabNode } from '../view/TabNode';
import hilog from '@ohos.hilog';

@Component
export struct BuilderNodePoolDemoComponent {
  @State selectIndex: number = 0;
  @State arrayTitle: Title[] = [] as Title[];
  array: string[] = [] as string[];
  arrayStr: string[] = [Constants.HOME1, Constants.HOME2];
  swiperController: SwiperController = new SwiperController();

  aboutToAppear(): void {
    // 添加标题模拟数据
    for (let i = 0; i < this.arrayStr.length; i++) {
      let title: Title = new Title();
      if (i === 0) {
        title.isSelected = true;
      }
      title.name = this.arrayStr[i];
      this.arrayTitle = [...this.arrayTitle, title];
      this.array = [...this.array, this.arrayStr[i]];
    }
  }

  build() {
    Column() {
      List() {
        ForEach(this.arrayTitle, (title: Title, index: number) => {
          ListItem() {
            Text(title.name)
              .width('40%')
              .textAlign(TextAlign.Center)
              .fontColor(title.isSelected ? Color.Blue : Color.Black)
          }.onClick((): void => {
            if (title.isSelected) {
              return;
            }
            this.swiperController.changeIndex(index, true);
            // 设置标题为选中状态
            this.arrayTitle[index.toInt()].isSelected = true;
            this.arrayTitle[this.selectIndex.toInt()].isSelected = false;
            this.selectIndex = index;
            this.arrayTitle = [...this.arrayTitle];
          })
          .padding({ left: 20, right: 20 } as Padding)
        }, (item: Title) => item.isSelected.toString())
      }
      .height(30)
      .listDirection(Axis.Horizontal)
      .id('id_custom_reusable_pool_title_list')

      Swiper(this.swiperController) {
        ForEach(this.array, (item: string, index: number) => {
          TabNode()
        }, (item: string, index: number) => item)
      }
      .loop(false)
      .indicator(false)
      .id('id_custom_reusable_pool_main_swiper')
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    }
  }
}