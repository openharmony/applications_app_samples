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
import { TabInfo } from '../model/TabInfo';
import {
  $r,
  AdaptiveColor,
  Alignment,
  BackgroundBlurStyleOptions,
  BackgroundBrightnessOptions,
  BarPosition,
  BarState,
  Blank,
  BlurStyle,
  Button,
  ButtonAttribute,
  Callback,
  ClickEvent,
  Color,
  Column,
  Component,
  Divider,
  Flex,
  FlexAlign,
  FlexDirection,
  FlexOptions,
  ForEach,
  Image,
  ItemAlign,
  JSON,
  List,
  ListItem,
  Margin,
  ResourceStr,
  Row,
  SafeAreaEdge,
  SafeAreaType,
  SizeOptions,
  Stack,
  StackOptions,
  SystemAdaptiveOptions,
  TabContent,
  Tabs,
  TabsController,
  Text,
  ThemeColorMode
} from '@ohos.arkui.component'
import { Consume, Link, ObjectLink, Prop, Provide, State, StorageLink } from '@ohos.arkui.stateManagement'
import { UIContext } from '@ohos.arkui.UIContext';

/**
 * 功能介绍：自定义的Tabs实现
 *
 * 参数介绍：
 * @params selectedIndex 初始化被选定的tabBar下标
 * @params tabsInfoList 入参的数据信息，包含TabBar的标题、选中前后的图片，TabContent的信息等
 *
 * 实现思路：
 * 1、布局主要是一个Tab结构，实现了TabContent和自定义TabBar，通过TabInfo入参可以获取；
 * 2、在TabBar中设置backgroundBrightness和backgroundBlurStyle属性，并且通过Stack布局，使TabContent和TabBar重叠，
 * 通过TabBar的背景可以模糊看到TabContent的内容，实现了背景模糊的效果。
 * 3、补充：需要使用expandSafeArea层层嵌套（从父组件一直到TabBar组件都需要设置），实现沉浸式效果，保证体验。
 */
@Component
export struct CustomTabsComponent {
  @Provide selectedIndex: number = 0;
  @StorageLink('avoidAreaBottomToModule') avoidAreaBottomToModule: number = 0;
  controller: TabsController = new TabsController(); // 初始化Tab控制器
  tabsInfoList: TabInfo[] = [
    new TabInfo(0, $r('app.string.background_blur_main'), $r('app.media.backgroundblur_main_select'),
      $r('app.media.backgroundblur_main_normal')),
    new TabInfo(1, $r('app.string.background_blur_hot'), $r('app.media.backgroundblur_hot_select'),
      $r('app.media.backgroundblur_hot_normal')),
    new TabInfo(2, $r('app.string.background_blur_discover'), $r('app.media.backgroundblur_find_select'),
      $r('app.media.backgroundblur_find_normal')),
    new TabInfo(3, $r('app.string.background_blur_my'), $r('app.media.backgroundblur_my_select'),
      $r('app.media.backgroundblur_my_normal'))
  ];

  build() {
    Column() {
      Stack({ alignContent: Alignment.Bottom } as StackOptions) {
        MainContentBlur()
        Flex({
          direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround,
          alignItems: ItemAlign.Center
        } as FlexOptions) {
          ForEach(this.tabsInfoList, (item: TabInfo, tabIndex: number) => {
            TabItem({
              tabInfo: item,
              tabBarIndex: tabIndex,
              selectedIndex: this.selectedIndex,
            })
          }, (item: TabInfo, tabIndex: number) => tabIndex.toString())
        }
        /**
         * 设置组件背景提亮效果
         *
         * rate：亮度变化速率。亮度变化速率越大，亮度下降速度越快，亮度提升程度越低。默认值：0.0，取值范围：(0.0, +∞)
         * lightUpDegree：提亮程度。提亮程度越大，亮度提升程度越大。默认值：0.0，取值范围：[-1.0, 1.0]
         */
        .backgroundBrightness({
          rate: 0.5,
          lightUpDegree: 0.5
        } as BackgroundBrightnessOptions)
        /**
         * 为当前组件提供一种在背景和内容之间的模糊能力，通过枚举值的方式封装了不同的模糊半径、蒙版颜色、蒙版透明度、饱和度、亮度。
         * 当通过backgroundBlurStyle中的inactiveColor指定背景色时，不建议再通过backgroundColor设置背景色。
         *
         * 参数BlurStyle：背景模糊样式。模糊样式中封装了模糊半径、蒙版颜色、蒙版透明度、饱和度、亮度五个参数。
         * 参数BackgroundBlurStyleOptions：背景模糊选项。
         */
        .backgroundBlurStyle(BlurStyle.Thin, {
          colorMode: ThemeColorMode.LIGHT,
          adaptiveColor: AdaptiveColor.DEFAULT,
          scale: 1.0
        }, {} as SystemAdaptiveOptions)
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
      }
      .width('100%')
      .height('100%')
    }
  }
}

/**
 * 底部TabBar的单个显示项，由图片和文字的上下布局组合。
 *
 * @param tabInfo 显示图片和下标字体的内容
 * @param tabBarIndex 初始化下标
 * @param selectedIndex 被选中下标
 */
@Component
struct TabItem {
  tabInfo?: TabInfo = new TabInfo(0, 'textTest', $r('app.media.layered_image'), $r('app.media.layered_image'));
  @PropRef tabBarIndex: number = 0;
  @Link selectedIndex: number;

  build() {
    Column() {
      Image(this.selectedIndex === this.tabBarIndex ?
        this.tabInfo?.selectedIcon as ResourceStr : this.tabInfo?.defaultIcon as ResourceStr)
        .size({
          width: 24,
          height: 24
        } as SizeOptions)
        .margin({ top: 10 } as Margin)
      Text(this.tabInfo?.title)
        .fontSize(16)
        .margin({ top: 5 } as Margin)
        .fontWeight(5)
        .fontColor(this.selectedIndex === this.tabBarIndex ? $r('app.color.background_blur_selected_text_color') :
        Color.Black)
    }
    .width('100%') //50
    .onClick((e: ClickEvent) => {
      // 更新被选中的tabBar下标
      this.selectedIndex = this.tabBarIndex;
    })
  }
}

@Component
export struct MainContentBlur {
  info: string = '';
  LIST_IMAGE: ResourceStr[] = [$r('app.media.background_pic_1'), $r('app.media.background_pic_2'),
    $r('app.media.background_pic_3'), $r('app.media.background_pic_4')] as ResourceStr[];
  // 数据演示用
  arr: int[] = [0, 1, 3, 4, 5, 6, 7, 8, 9, 10] as int[];

  build() {
    List() {
      ForEach(this.arr, (item: int, index: number) => {
        ListItem() {
          Image(this.LIST_IMAGE[(item % this.LIST_IMAGE.length).toInt()] as ResourceStr)
            .width('100%')// 高度演示用
            .height(200)
        }
      }, (item: int, index: number) => index.toString())
    }
    .width('100%')
    .height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    .backgroundColor($r('app.color.background_blur_tabs_bar_background_color'))
  }
}