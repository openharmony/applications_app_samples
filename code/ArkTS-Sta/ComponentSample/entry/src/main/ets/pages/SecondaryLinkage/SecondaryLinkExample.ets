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
import { CustomDataType, MyDataSource, ListIndexPosition, ComponentStyle } from './DataType';
import {
  memo,
  __memo_context_type,
  __memo_id_type
} from '@ohos.arkui.stateManagement';
import {
  WordBreak,
  TextOverflow,
  TouchType,
  TextAlign,
  FontWeight,
  FlexAlign,
  HorizontalAlign,
  BarState,
  Scroller,
  Scroll,
  SafeAreaType,
  SafeAreaEdge,
  ListItem,
  Axis,
  LazyForEach,
  List,
  TouchEvent,
  ForEach,
  Flex,
  FlexWrap,
  Builder,
  NavDestination,
  Text,
  TextAttribute,
  Column,
  Component,
  Button,
  ButtonAttribute,
  ClickEvent,
  Image,
  Row,
  CalendarPickerDialog,$r
} from '@ohos.arkui.component';
import {
  State,
  MutableState,
  stateOf,
  observableProxy,
  Watch
} from '@ohos.arkui.stateManagement';
import hilog from '@ohos.hilog';

const TAG_LIST_LENGTH = 12; // TagList长度
const CONTENT_PER_TAG = 10; // 每个TAG对应多少个元素

/**
 * 功能描述: 本示例主要介绍了List组件实现二级联动（Cascading List）的场景
 *
 * 推荐场景: 需要使用多级列表联合滚动的场景，如：外卖点单页面等
 *
 * 核心组件:
 * 1. SecondaryLinkExample.tagListItemBuilder
 *
 * 实现步骤:
 * 1. 一二级列表分别绑定不同的Scroller对象，一级列表(tagLists)绑定classifyScroller对象，二级列表绑定scroller对象
 * 2. 点击一级列表后，通过一级列表的索引获取二级列表的索引，调用scrollToIndex方法将一二级列表滚动到指定索引值
 * 3. 滑动二级列表触发组件滚动事件后，获取到列表可视区域第一个item对应的索引值，通过二级列表索引获取一级列表索引，调用scrollToIndex方法将一级列表滚动到指定索引值
 */
@Component
export struct SecondaryLinkExample {
  private tagIndexPosition: ListIndexPosition = { start: 0, end: 0 } as ListIndexPosition; // 一级列表可视区域的起始索引和终点索引
  @State @Watch('onIndexChange') currentTagIndex: int = 0; // 一级列表焦点索引值
  private tagLists: Array<string> = new Array<string>(); // 一级列表数据
  @State contentData: MyDataSource = new MyDataSource(); // 二级列表数据
  private records: Array<int> = new Array<int>(); // 二级列表分组count数量
  // 知识点: 1.级联列表分别绑定不同的Scroller对象，通过调用Scroller对象方法实现控制列表滚动
  private classifyScroller: Scroller = new Scroller(); // 一级列表Scroller对象
  private scroller: Scroller = new Scroller(); // 二级列表Scroller对象
  private isClickTagList: boolean = false; // 是否点击一级列表

  /**
   * 生命周期函数
   */
  aboutToAppear(): void {
    // 构造数据
    for (let i = 0; i < TAG_LIST_LENGTH; i++) {
      this.tagLists.push(`类别${i + 1}`);
      const tempData: Array<CustomDataType> = new Array<CustomDataType>(CONTENT_PER_TAG).fill({
        desc: '内容数据',
        tag: `类别${i + 1}`
      });
      this.records.push(i * CONTENT_PER_TAG);
      this.contentData.pushData(tempData);
    }
    this.records.push(CONTENT_PER_TAG * TAG_LIST_LENGTH);
    this.tagIndexPosition = { start: 0, end: 0 };
  }

  build() {
    Column() {
      Column() {
        Text($r('app.string.secondarylinkage_secondary_link'))
          .fontSize(20)
        Text($r('app.string.secondarylinkage_secondary_link_desc'))
          .fontSize(20)
          .wordBreak(WordBreak.BREAK_ALL)
      }
      .width('100%')
      .backgroundColor('#ffcac6c6')
      .borderRadius(12)
      .padding(12)

      Row() {
        // 知识点: 2.一级列表绑定Scroller对象
        List({ scroller: this.classifyScroller, initialIndex: 0 }) {
          ForEach(this.tagLists, (item: string, index: number) => {
            this.tagListItemBuilder(item, index);
          }, (item: string, index: number) => item)
        }
        .backgroundColor('#ffe3e3e3')
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
        .onScrollIndex((start: number, end: number): void => {
          this.tagIndexPosition = { start, end };
        })
        .listDirection(Axis.Vertical)
        .scrollBar(BarState.Off)
        .height('100%')
        .width('30%')
        // 二级列表
        List({ scroller: this.scroller}) {
          ForEach(this.contentData.dataArray, (item: CustomDataType, index: number) => {
            this.contentListItemBuilder(item, index);
          }, (item: CustomDataType, index: number) => index.toString())
          this.contentListNoMoreBuilder();
        }
        .backgroundColor('#ffffffff')
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
        .id('list_content')
        .scrollBar(BarState.Off)
        .listDirection(Axis.Vertical) // 列表排列方向水平
        .flexShrink(1)
        .onTouch((event: TouchEvent): void => {
          if (event.type === TouchType.Down) {
            this.isClickTagList = false; // 当前点击的非一级列表
          }
        })
        // 性能知识点:onScrollIndex事件在列表滚动时频繁执行，在回调中需要尽量减少耗时和冗余操作，例如减少不必要的日志打印
        .onScrollIndex((start: number): void => {
          // 知识点: 4.滑动二级列表触发组件滚动事件后，返回列表可视区域的第一个item对应的索引值，当前通过二级列表索引获取一级列表索引，操作一级列表Scroller对象使列表滚动到指定位置
          const currentClassIndex = this.findClassIndex(start.toInt());
          if (currentClassIndex !== this.currentTagIndex && this.isClickTagList !== true) {
            this.currentTagIndex = currentClassIndex;
            this.classifyScroller.scrollToIndex(currentClassIndex, true);
          }
        })
      }
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
      .width('100%')
      .layoutWeight(1)
    }
  }

  /**
   * 内容底部'没有更多'视图
   */
  @Builder
  contentListNoMoreBuilder() {
    ListItem() {
      Text($r('app.string.secondarylinkage_nomore'))
        .fontSize(20)
        .backgroundColor('#ffb8b8b8')
    }
    .width('100%')
  }

  /**
   * 右侧内容视图
   */
  @Builder
  contentListItemBuilder(item: CustomDataType, index: number) {
    ListItem() {
      Row() {
        Text()
          .aspectRatio(1)
          .height('100%')
          .backgroundColor('#ffe5e5e5')
          .borderRadius(15)
        Column() {
          Text(item.desc + index)
          Text(item.tag)
            .fontSize(20)
            .fontColor('#ff1dee06')
          Text()
            .height(ComponentStyle.SUB_ITEM_TEXT_HEIGHT)
            .width(ComponentStyle.SUB_ITEM_TEXT_WIDTH_TITLE)
            .backgroundColor('#ffb8b8b8')
          Text()
            .height(ComponentStyle.SUB_ITEM_TEXT_HEIGHT)
            .width(ComponentStyle.SUB_ITEM_TEXT_WIDTH_BODY)
            .backgroundColor('#ff8f8f8f')
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.SpaceEvenly)
        .height('100%')
      }
      .backgroundColor('#ffffffff')
      .height(ComponentStyle.SUB_ITEM_HEIGHT)
    }
    .id('content_' + index)
  }

  /**
   * 左侧类别视图
   */
  @Builder
  tagListItemBuilder(item: string, index: number) {
    ListItem() {
      Text(item)
        .width('100%')
        .height(ComponentStyle.TAG_TEXT_HEIGHT)
        .textAlign(TextAlign.Center)
        .onTouch((event: TouchEvent) => {
          if (event.type === TouchType.Down) {
            this.isClickTagList = true; // 当前点击的是一级列表
          }
        })
        .onClick((e: ClickEvent): void => {
          // 知识点: 3.点击一级列表后，通过一级列表索引获取二级列表索引，分别操作不同的Scroller对象使列表滚动到指定位置
          this.currentTagIndex = index.toInt();
          const itemIndex = this.findItemIndex(index.toInt());
          this.scroller.scrollToIndex(itemIndex, true);
        })
        .backgroundColor(this.currentTagIndex === index ? '#ffffffff' : '#ffe3e3e3')
    }
    .id(this.currentTagIndex === index ? 'type_' + index : 'type_' + index + '_selected')
  }

  /**
   * 根据一级列表索引值获取二级列表索引值
   *
   * @param {int} index - 一级列表索引值
   * @returns {int} 二级列表索引值
   */
  findItemIndex(index: int): int {
    return this.records[index];
  }

  /**
   * 根据二级列表索引值获取对应一级列表索引
   *
   * @param {int} index - 二级列表索引值
   * @returns {int} 一级列表索引值
   */
  findClassIndex(index: int): int {
    let classIndex = 0;
    for (let i = 0; i < this.records.length; i++) {
      if (index >= this.records[i] && index < this.records[i + 1]) {
        classIndex = i;
        break;
      }
    }
    return classIndex;
  }

  /**
   * 监听一级列表获焦索引变化
   * @param {string} param - 语法要求
   */
  onIndexChange(param: string) {
    const start = this.tagIndexPosition.start;
    const end = this.tagIndexPosition.end;
    if ((this.currentTagIndex === end || this.currentTagIndex === end - 1)) {
      let leftScrollCount: int = this.currentTagIndex + 1;
      leftScrollCount = leftScrollCount >= this.tagLists.length - 1 ? this.tagLists.length - 1 : leftScrollCount;
      this.classifyScroller.scrollToIndex(leftScrollCount, true); // 使获焦item向上滚动
    }
    if (this.currentTagIndex === start || this.currentTagIndex === start + 1) {
      let rightScrollCount: int = this.currentTagIndex - 1;
      rightScrollCount = rightScrollCount <= 0 ? 0 : rightScrollCount;
      this.classifyScroller.scrollToIndex(rightScrollCount, true); // 使获焦item向下滚动
    }
  }
}