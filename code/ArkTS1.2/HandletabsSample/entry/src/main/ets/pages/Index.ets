'use static';
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
import { memo, __memo_context_type, __memo_id_type } from '@ohos.arkui.stateManagement';
import { Text, TextAttribute, Column, Component, Button, ButtonAttribute, ClickEvent, Entry, Tabs, TabContent,
  CustomBuilder, ComponentContent, SubTabBarStyle, BottomTabBarStyle, Resource, TabBarOptions, JSON, Flex, FlexDirection,
  FlexAlign, ItemAlign, Divider, TabsOptions, Row, ForEach, Position, Builder, Margin, BarMode,
  OnTabsAnimationStartCallback,TabsAnimationEvent} from '@ohos.arkui.component';
import { State, Link, MutableState, stateOf, observableProxy } from '@ohos.arkui.stateManagement';
import hilog from '@ohos.hilog';
import { UIContext, Router } from '@ohos.arkui.UIContext';
import router from '@ohos.router';

@Entry
@Component
export struct CustomView {
  @State fontColor: string = '#182431'
  @State selectedFontColor: string = '#007DFF'
  @State currentIndex: number = 0
  @State selectedIndex: number = 0
  @State newPage: number = 2
  @State arr: string[] = ['页面1','页面2']

  @Builder tabBuilder(index: number, name: string) {
    Column() {
      Row(){
        Text(name)
          .fontColor(this.selectedIndex === index ? this.selectedFontColor : this.fontColor)
          .fontSize(16)
          .fontWeight(this.selectedIndex === index ? 500 : 400)
          .lineHeight(22)
          .margin({ top: 17, bottom: 7 } as Margin)
        if(this.arr.length > 1){
          Text('X')
            .margin({ top: 17, bottom: 7, left: 10 } as Margin)
            .fontColor('red')
            .lineHeight(22)
            .onClick((e: ClickEvent) => {
              this.arr.splice(index, 1);
              this.arr = [...this.arr];
            })
        }
      }
      Divider()
        .strokeWidth(2)
        .color('#007DFF')
        .opacity(this.selectedIndex === index ? 1 : 0)
    }.width('100%')
    .onClick((e: ClickEvent) => {
      // 更新被选中的tabBar下标
      this.currentIndex =  index
      this.selectedIndex = index
    })
  }

  @Builder addTab() {
    Column() {
      Row(){
        Text('+')
          .margin({ top: 18, bottom: 0, left: 10 } as Margin)
          .fontColor('#707070')
          .fontSize(30)
          .lineHeight(22)
          .onClick((e: ClickEvent) => {
            this.newPage++;
            this.arr = [...this.arr, '页面' + this.newPage];
          })
      }
      .onClick((e: ClickEvent) => {
        this.newPage++;
        this.arr = [...this.arr, '页面' + this.newPage];
      })
    }.width('50%')
  }

  build() {
    Column() {
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround, alignItems: ItemAlign.Center }) {
        ForEach(this.arr, (item: string, tabBarIndex: number) => {
          // 单独一个TabBar组件
          this.tabBuilder(tabBarIndex, item)
        })
        if(this.arr.length < 4){
          this.addTab()
        }
      }
      .margin({ left: 13, right: 13 } as Margin)
      Tabs({ index: this.selectedIndex } as TabsOptions) {
        ForEach(this.arr, (item: string, idx: number) => {
          TabContent() {
            Column(){
              Text(item)
            }
            .justifyContent(FlexAlign.Center)
            .width('100%').height('100%').backgroundColor('#007DFF')
          }
        })
      }
      .barWidth(360)
      .barHeight(56)
      .animationDuration(400)
      .onAnimationStart((index: number, targetIndex: number, event: TabsAnimationEvent) => {
        if (index === targetIndex) {
          return
        }
        // selectedIndex控制自定义TabBar内Image和Text颜色切换
        this.selectedIndex = targetIndex
      } as OnTabsAnimationStartCallback)
      .width(360)
      .height(296)
      .backgroundColor('#F1F3F5')
      .barHeight(1)
    }.width('100%')
  }
}