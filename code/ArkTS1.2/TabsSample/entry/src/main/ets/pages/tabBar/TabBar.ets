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
import { Text, TextAttribute, Column, Component, Button, ButtonAttribute, ClickEvent, Entry, Tabs, TabContent, SubTabBarStyle,
  Row, ForEach, Position, Builder, Margin, BarMode, OnTabsAnimationStartCallback, TabsAnimationEvent, TabsOptions,
  Color, FlexAlign, $r, Image, SizeOptions, Position, AnimateParam, Flex,FlexDirection,FlexAlign,ItemAlign} from '@ohos.arkui.component';
import { State, Link, MutableState, stateOf, observableProxy } from '@ohos.arkui.stateManagement';
import hilog from '@ohos.hilog';
import { UIContext, Router } from '@ohos.arkui.UIContext';
import router from '@ohos.router';

@Entry
@Component
export struct TabViewComponent {
  // 配置起始的页签索引
  @State selectedIndex: number = 0;
  // 初始化Tab控制器
  @State tabArray: string[] = ['首页', '新闻',
    '视频', '朋友圈', '我的'];
  @State imageArray: string[] =
    ['app.media.custom_tab_home', 'app.media.custom_tab_new', 'app.media.custom_tab_video',
      'app.media.custom_tab_friend','app.media.custom_tab_user'];
  @State imageClickArray: string[] =
    ['app.media.custom_tab_home_selected', 'app.media.custom_tab_new_selected', 'app.media.custom_tab_video_selected',
      'app.media.custom_tab_friend_selected','app.media.custom_tab_user_selected'];

  @State fontColor: string = '#182431';
  @State selectedFontColor: string = '#007DFF';

  @Builder tabBuilder(item: string, index: number) {
    Column() {
      if (index === 2) {
        Column() {
          Image(this.selectedIndex === index ? $r('app.media.custom_tab_video_selected') :
          $r('app.media.custom_tab_video'))
            .size({
              width: 43,
              height: 43
            } as SizeOptions)
        }
        .width(52)
        .height(52)
        // 通过设置borderRadius以及margin的top值实现圆弧外轮廓效果。
        .borderRadius(24)
        .margin({ top: -15 } as Margin)
        .backgroundColor(Color.White)
        .justifyContent(FlexAlign.Center)
      } else {
        Image(this.selectedIndex === index ? $r(this.imageClickArray[index]) : $r(this.imageArray[index]))
          .width(24)
          .height(24)
          .margin({ bottom: 4 } as Margin)
          .size({
            width: 28,
            height: 28
          } as SizeOptions)// 通过offset控制图片的纵向偏移。
          .offset({
            y: (this.selectedIndex === index &&
              this.selectedIndex !== 2) ?
              -3 : 0
          } as Position)// 组件的某些通用属性变化时，可以通过属性动画animation实现过渡效果。本示例的动画效果是tabBar的图片向上偏移一小段距离
      }
      Text(item)
        .fontColor(this.selectedIndex === index ? this.selectedFontColor : this.fontColor)
        .fontSize(10)
        .fontWeight(500)
        .lineHeight(14)
    }.width('100%')
    .onClick((e: ClickEvent) => {
      // 更新被选中的tabBar下标
      this.selectedIndex = index;
    })
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.custom_return'))
      }
      .margin(3)
      .width('100%')
      .onClick((e: ClickEvent) => {
        this.getUIContext().getRouter().back();
      })
      Tabs({ index: this.selectedIndex } as TabsOptions) {
        // 首页模块，可根据开发者实际业务替换TabContent中的布局
        TabContent() {
          Text($r('app.string.custom_tab_home'))
            .fontSize(26)
            .padding(20)
        }
        // 新闻模块，可根据开发者实际业务替换TabContent中的布局
        TabContent() {
          Text($r('app.string.custom_news'))
            .fontSize(26)
        }
        // 视频模块，可根据开发者实际业务替换TabContent中的布局
        TabContent() {
          Text($r('app.string.custom_video'))
            .fontSize(26)
        }
        // 朋友圈模块，可根据开发者实际业务替换TabContent中的布局
        TabContent() {
          Text($r('app.string.custom_friend'))
            .fontSize(26)
        }
        // 我的模块，可根据开发者实际业务替换TabContent中的布局
        TabContent() {
          Text($r('app.string.custom_tab_mine'))
            .fontSize(26)
        }
      }
      .vertical(false)
      .scrollable(true)
      .layoutWeight(1)
      .backgroundColor('#ffdbd9d9')
      .barHeight(1)
      .onAnimationStart((index: number, targetIndex: number) => {
        this.selectedIndex = targetIndex;
      } as OnTabsAnimationStartCallback)

      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround, alignItems: ItemAlign.Center }) {
        ForEach(this.tabArray, (item: string, tabBarIndex: number) => {
          // 单独一个TabBar组件
          this.tabBuilder(item, tabBarIndex)
        })
      }
    }
    .width('100%')
    .height('100%')
  }
}

