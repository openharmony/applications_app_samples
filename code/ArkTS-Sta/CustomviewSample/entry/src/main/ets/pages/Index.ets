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
import {
  __memo_context_type,
  __memo_id_type,
  memo,
  MutableState,
  observableProxy,
  State,
  stateOf
} from '@ohos.arkui.stateManagement';
import {
  $$,
  $r,
  AnimateParam,
  Axis,
  BarState,
  Button,
  Callback,
  ClickEvent,
  Color,
  Column,
  Component,
  Curve,
  Entry,
  Flex,
  FlexAlign,
  FontWeight,
  ForEach,
  GestureEvent,
  GestureType,
  Image,
  LazyForEach,
  List,
  ListItem,
  ListOptions,
  PanGesture,
  PlayMode,
  Position,
  Row,
  Scroll,
  ScrollAlign,
  Scroller,
  Stack,
  Tabs,
  Text,
  TextAlign,
} from '@ohos.arkui.component';
import hilog from '@ohos.hilog';
import { Router, UIContext } from '@ohos.arkui.UIContext';
import router from '@ohos.router';

@Entry
@Component
export struct CustomView {
  // 当前选中的页签index
  @State currentIndex: number = 0;
  // 颜色条的偏移量
  @State transitionX: number = 30;
  // 即将前往的页签index
  @State wantGoIndex: number = 0;
  // 创建Scroller对象
  private scroller: Scroller = new Scroller();
  // 计算title长度的一半
  private titleLengthHalf: number = 2;
  // 颜色条长度的一半
  private colorBarHalf: number = 10;
  // title宽度计算基数
  private titleLengthRadix: number = 20;
  // 循环因子初始值
  private loopDefault: int = 0;
  // duration计算基数
  private durationRadix: number = 200;
  // iterations默认值
  private iterationsDefault: number = 1;
  // 判断条件值
  private judgmentValue: number = 0;
  // currentIndex计算基数
  private currentIndexRadix: number = 1;
  // 是否开始动画标志
  isStartAction: boolean = false;

  aboutToAppear() {
    // 获取颜色条偏移量
    this.transitionX = this.getTransitionX(this.currentIndex);
  }

  // 获取颜色条偏移量
  getTransitionX(index: number) {
    let theNumber: number = 0;
    for (let i = this.loopDefault; i <= index; i++) {
      const title = this.titleArray[i];
      const titleLength = title.length * this.titleLengthRadix;
      if (i === index) {
        theNumber += titleLength / this.titleLengthHalf - this.colorBarHalf;
      } else {
        theNumber += titleLength;
      }
    }
    return theNumber;
  }

  // 页签显示数据
  private titleArray: Array<string> = ['候补预测', '在线换座', '余票挖掘', '个人中心'];

  // 实现动画效果
  achieveEffect(temIndex: number) {
    // 高性能知识点：scrollToIndex方法，开启smooth动效时，会对经过的所有item进行加载和布局计算，当大量加载item时会导致性能问题
    this.scroller.scrollToIndex(temIndex, true, ScrollAlign.START);
    this.wantGoIndex = temIndex;
    // 动画效果
    this.getUIContext()?.animateTo({
      duration: Math.abs(temIndex - this.currentIndex) * this.durationRadix,
      curve: Curve.EaseInOut,
      iterations: this.iterationsDefault,
      playMode: PlayMode.Normal,
      onFinish: () => {
        this.currentIndex = temIndex;
      }
    } as AnimateParam, () => {
      this.transitionX = this.getTransitionX(temIndex);
    })
  }

  build() {
    Column() {
      Column() {
        Row() {
          // 此处为了演示场景，列表数量只有4个，使用ForEach，列表数量较多的场景，推荐使用LazyForEach+组件复用+缓存列表项实现
          ForEach(this.titleArray, (title: string, idx: number) => {
            Text(title)
              .id('custom_view_title_' + idx)
              .height(30)
              .width(this.titleLengthRadix * title.length)
              .fontColor(this.currentIndex === idx ?
                (this.wantGoIndex === idx ? '#111111' : '#999999') :
                (this.wantGoIndex === idx ? '#111111' : '#999999'))
              .fontSize(this.currentIndex === idx ? 18 : 14)
              .fontWeight(this.currentIndex === idx ? FontWeight.Bold : FontWeight.Normal)
              .onClick((e: ClickEvent) => {
                // 页签实现：记录点击index，index变化后，获取颜色条偏移量，刷新页签颜色、字体大小，实现效果
                if (this.currentIndex !== idx) {
                  // 记录点击index
                  this.wantGoIndex = idx;
                  // 动画效果
                  this.getUIContext()?.animateTo({
                    duration: Math.abs(idx - this.currentIndex) * this.durationRadix,
                    curve: Curve.EaseInOut,
                    iterations: this.iterationsDefault,
                    playMode: PlayMode.Normal,
                    onFinish: () => {
                      this.currentIndex = idx;
                      // 高性能知识点：scrollToIndex方法，开启smooth动效时，会对经过的所有item进行加载和布局计算，当大量加载item时会导致性能问题
                      this.scroller.scrollToIndex(this.currentIndex, true, ScrollAlign.START);
                    }
                  } as AnimateParam, () => {
                    // 获取颜色条偏移量
                    this.transitionX = this.getTransitionX(idx);
                  })
                }
              })
          }, (title: string, idx: number) => title)
        }
        .id('custom_view_title')
        .height(30)
        .width('100%')

        Row()
          .id('custom_view_title_bar')
          .width(20)
          .height(6)
          .borderRadius(3)
          .backgroundColor('#3366FF')
          .position({ x: this.transitionX, y: 30 } as Position)
      }
      .height(40)
      .width(320)

      List({ scroller: this.scroller } as ListOptions) {
        // 内容区域部分
        // 此处为了演示场景，列表数量只有4个，使用ForEach，列表数量较多的场景，推荐使用LazyForEach+组件复用+缓存列表项实现
        ForEach(this.titleArray, (item: string, index: number) => {
          ListItem() {
            Text(item)
              .id('custom_view_content_' + index)
              .width('100%')
              .height(50)
              .fontSize(25)
              .textAlign(TextAlign.Center)
          }
        }, (item: string, index: number) => item)
      }
      .id('custom_view_content')
      .scrollBar(BarState.Off)
      .listDirection(Axis.Horizontal)
      .priorityGesture(
        PanGesture() // 内容区域实现：添加滑动手势，手势响应后，使用scrollToIndex方法来实现效果
          .onActionUpdate((event: GestureEvent) => {
            if (!this.isStartAction) {
              this.isStartAction = true;
              if (event.offsetX < this.judgmentValue) {
                if (this.currentIndex < this.titleArray.length - this.currentIndexRadix) {
                  const temIndex: number = this.currentIndex + this.currentIndexRadix;
                  this.achieveEffect(temIndex);
                }
              } else {
                if (this.currentIndex > this.judgmentValue) {
                  const temIndex: number = this.currentIndex - this.currentIndexRadix;
                  this.achieveEffect(temIndex);
                }
              }
            }
          })
          .onActionEnd((event: GestureEvent) => {
            this.isStartAction = false;
          }) as GestureType
      )
      .backgroundColor('#EEEEEE')
      .width('100%')
      .height(50)
    }
    .width('100%')
    .height('100%')
  }
}