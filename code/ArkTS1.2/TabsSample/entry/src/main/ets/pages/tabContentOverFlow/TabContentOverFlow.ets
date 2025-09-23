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
  Link,
  memo,
  MutableState,
  observableProxy,
  State,
  stateOf
} from '@ohos.arkui.stateManagement';
import {
  $r,
  Alignment,
  animateTo,
  BarMode,
  Builder,
  Button,
  ButtonAttribute,
  Callback,
  ClickEvent,
  Color,
  Column,
  Component,
  Entry,
  Flex,
  FlexAlign,
  FlexDirection,
  ForEach,
  GestureEvent,
  GestureType,
  HitTestMode,
  Image,
  ItemAlign,
  Margin,
  OnTabsAnimationStartCallback,
  PanGesture,
  PlaybackInfo,
  Position,
  PreparedInfo,
  RelativeContainer,
  Row,
  SeekMode,
  TabContent,
  Tabs,
  TabsAnimationEvent,
  TabsOptions,
  Text,
  TextAttribute,
  TranslateOptions,
  Video,
  VideoController,
  Visibility,
  VoidCallback
} from '@ohos.arkui.component';
import hilog from '@ohos.hilog';
import { Router, UIContext } from '@ohos.arkui.UIContext';
import router from '@ohos.router';

@Entry
@Component
export struct TabContentOverFlowComponent {
  @State tabArray: string[] = ['首页', '视频',
    '商城', '我的'];
  @State imageArray: string[] =
    ['app.media.tabcontentoverflow_homepage', 'app.media.tabcontentoverflow_video', 'app.media.tabcontentoverflow_mall',
      'app.media.tabcontentoverflow_mine'];
  @State imageClickArray: string[] =
    ['app.media.tabcontentoverflow_homepage_filled', 'app.media.tabcontentoverflow_video_filled',
      'app.media.tabcontentoverflow_mall_filled', 'app.media.tabcontentoverflow_mine_filled'];
  @State index: int = 1;
  @State offsetX: number = 0; // 用来记录实时拖动的距离
  @State positionX: number = 0; // 用来记录拖动后的距离
  @State playTime: string = ''; // 用来记录现在播放的时间
  @State totalTime: number = 0; // 用来记录视频全部时长
  @State isPlay: boolean = false; // 用来控制播放状态
  @State isTouch: boolean = false; // 是否处于拖动状态
  @State isTextButtonVisible: boolean = true;
  private isSeek: boolean = false; // 是否拖拽跳转
  private videoController: VideoController = new VideoController();
  private screenW: number = 480; // 获取设备宽度

  private dragAnimation() {
    this.getUIContext()?.animateTo({
      duration: 300,
    }, () => {
      this.isTouch = true;
    });
  }

  @Builder
  videoTabContent() {
    // 界面嵌套带来了渲染和计算的大量开销，造成性能的衰退。使用扁平化布局优化嵌套层级，建议采用相对布局RelativeContainer进行扁平化布局，有效减少容器的嵌套层级，减少组件的创建时间。
    Column() {
      Row() {
        Text(' ← 返回')
      }
      .margin(3)
      .width('100%')
      .onClick((e: ClickEvent) => {
        this.getUIContext().getRouter().back();
      })

      Video({
        src: $r('app.media.tabcontentoverflow_play_video'),
        controller: this.videoController
      })
        .height('90%')
        .width('100%')
        .autoPlay(false)
        .controls(false)
        .onPrepared((event: PreparedInfo) => {
          if (event !== undefined) {
            this.totalTime = event.duration;
          }
        } as Callback<PreparedInfo>)
        .onFinish(() => {
          this.isPlay = false;
        } as VoidCallback)
        .onUpdate((event: PlaybackInfo) => {
          if (event !== undefined) {
            if (!this.isTouch) {
              if (!this.isSeek) {
                // 当没有进行拖动进度条时，进度条根据播放进度进行变化。
                this.offsetX =
                  event.time / this.totalTime * (this.screenW - 30);
                this.positionX = this.offsetX;
              } else {
                this.isSeek = false;
              }
            }
          }
        } as Callback<PlaybackInfo>)
        .id('video')
      // 播放按钮
      Image($r('app.media.tabcontentoverflow_play'))
        .width(50)
        .height(50)
        .position({ x: '45%', y: '45%' } as Position)
        .id('image')
        .onClick((e: ClickEvent) => {
          if (this.isPlay) {
            this.isPlay = false;
            this.videoController.pause();
          } else {
            this.isPlay = true;
            this.videoController.start();
          }
        })
        .visibility(this.isPlay ? Visibility.Hidden : Visibility.Visible)
      // 拖动进度条时展示现在播放哪个到具体的时间点
      Text('00:' + this.playTime)
        .fontSize(20)
        .width(100)
        .height(30)
        .id('playTimeText')
        .fontColor('#ffff0000')
        .visibility(this.isTouch ? Visibility.Visible : Visibility.Hidden)
        .margin({
          left: -100,
          top: -100
        } as Margin)
      // 拖动进度条时展示视频总时长
      Text('/00:' + this.totalTime)
        .fontSize(20)
        .width(100)
        .height(30)
        .id('totalTimeText')
        .fontColor('#ffffffff')
        .visibility(this.isTouch ? Visibility.Visible : Visibility.Hidden)
      // 使用三个Text组件来模拟播放进度条，第一个text位置不变，宽度不变。第二个text根据this.offsetX来变换宽度。第三个text根据this.offsetX来translate该组件在x轴的位置。
      RelativeContainer() {
        Text()
          .width(this.screenW - 30)
          .height(this.isTouch ? 20 : 5)
          .borderRadius(this.isTouch ? 0 : 5)
          .backgroundColor('#804e4c4d')
          .translate({ y: this.isTouch ? -15 : 0 } as TranslateOptions)
          .id('text1')
          .margin({
            top: 8,
            left: 15
          } as Margin)
        Text()
          .width(this.offsetX)
          .height(this.isTouch ? 20 : 5)
          .borderRadius(this.isTouch ? 0 : 5)
          .backgroundColor('#999999')
          .translate({ y: this.isTouch ? -15 : 0 } as TranslateOptions)
          .id('text2')
        Text()
          .width(20)
          .height(20)
          .borderRadius(10)
          .backgroundColor('#999999')
          .translate({ x: this.offsetX } as TranslateOptions)
          .visibility(this.isTextButtonVisible ? Visibility.Visible : Visibility.None)
          .id('text3')
          .margin({
            top: -7.5,
            left: -10
          } as Margin)
      }
      .id('RelativeContainer')
      .margin({ top: 30 } as Margin)
      .width(this.screenW)
      .height(70)
      // 左右拖动触发该手势事件
      .gesture(
        PanGesture()
          .onActionStart((event: GestureEvent) => {
            this.dragAnimation();
            this.isTextButtonVisible = false;
            this.isSeek = true;
          })/**
           * 性能知识点: onActionUpdate是系统高频回调函数，避免在函数中进行冗余或耗时操作，例如应该减少或避免在函数打印日志，会有较大的性能损耗。
           */
          .onActionUpdate((event: GestureEvent) => {
            let playTime =
              Math.floor(this.offsetX / (this.screenW - 30) * this.totalTime);
            this.offsetX = this.positionX + event.offsetX;
            if (this.offsetX <= 0) {
              this.offsetX = 0;
            }
            if (this.offsetX >= this.screenW - 30) {
              this.offsetX = this.screenW - 30;
            }
            if (playTime >= 10) {
              this.playTime = (playTime as Number).toString();
            } else {
              this.playTime = '0' + (playTime as Number).toString();
            }
          })
          .onActionEnd((event: GestureEvent) => {
            if (this.positionX === this.offsetX) { // 进度条未发生改变
              this.isSeek = false;
            } else {
              // 拖动进度条发生改变后通过this.videoController.setCurrentTime来精准定位视频现在播放位置。
              this.videoController.setCurrentTime(Number(((this.offsetX /
                (this.screenW - 30) * this.totalTime) as Number).toFixed(3)),
                SeekMode.Accurate);
              this.positionX = this.offsetX;
            }
            this.isTextButtonVisible = true;
            this.isTouch = false;
          }) as GestureType
      )
    }

  }

  build() {
    Column() {
      // 将barHeight设置为0，预留60vp给自定义tabBar，TabContent的高度则可以使用calc(100% - 60vp)获取。
      Tabs({ index: this.index } as TabsOptions) {
        TabContent() {
          Text($r('app.string.custom_home'))
            .fontSize(20)
        }
        .align(Alignment.Center)
        .height('calc(100% - 60vp)')
        .width('100%')

        TabContent() {
          this.videoTabContent();
        }
        .align(Alignment.Top)

        TabContent() {
          Text($r('app.string.custom_store'))
            .fontSize(20)
        }
        .align(Alignment.Center)
        .height('calc(100% - 60vp)')
        .width('100%')

        TabContent() {
          Text($r('app.string.custom_my'))
            .fontSize(20)
        }
        .align(Alignment.Center)
        .height('calc(100% - 60vp)')
        .width('100%')
      }
      // 将zIndex设置为2，TabContent将在tabBar之上，显示的效果就是TabContent外溢的部分在tabBar上。
      .zIndex(2)
      .scrollable(false)
      .barHeight(1)
      .animationDuration(100)
      // hitTestBehavior属性可以实现在复杂的多层级场景下，一些组件能够响应手势和事件，而一些组件不能响应手势和事件。HitTestMode.Transparent的效果为，自身响应触摸测试，不会阻塞兄弟节点的触摸测试。
      .hitTestBehavior(HitTestMode.Transparent)
      .id('tabs')

      // 页签
      Row() {
        ForEach(this.tabArray, (item: string, idx: number) => {
          const index = idx.toInt();
          Column() {
            Image(this.index === index ? $r(this.imageClickArray[index.toInt()]) : $r(this.imageArray[index.toInt()]))
              .width(30)
              .height(30)
            Text(item)
              .fontSize(12)
              .fontColor(this.index === index ? '#e40d0d' : '#FFFFFFFF')
          }
          .width(50)
          .margin({ top: 10 } as Margin)
          // 为将底部视图扩展到非安全区域，可将原本60vp的高度设置为100vp。
          .height(100)
          .onClick((e: ClickEvent) => {
            this.index = index;
          })
        })
      }
      .width('100%')
      .backgroundColor('#FF000000')
      .margin({ top: '-60vp' } as Margin)
      .justifyContent(FlexAlign.SpaceAround)
      .id('tabBar')
    }
  }
}