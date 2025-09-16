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

import { memo, __memo_context_type, __memo_id_type } from '@ohos.arkui.stateManagement';
import {
  Text, TextAttribute, Column, Component, Button, ButtonAttribute, ClickEvent, Builder,
  SwiperController, Swiper, TextAlign, ForEach, Color, Margin, Scroll, Scroller, ScrollDirection, EdgeEffect, List,
  ListItem, FontWeight, ImageFit, ListItemAlign, Axis, BarState, Stack, Alignment, Row, Image, $r, VerticalAlign, Resource,
  ResourceColor, FlexAlign, SizeOptions, Area, Curve, PlayMode, SwiperAnimationEvent, ScrollState, ScrollOptions, ScrollSource,
  ScrollOnWillScrollCallback, OffsetResult, ScrollOnScrollCallback, Entry
} from '@ohos.arkui.component';
import { State, MutableState, stateOf, observableProxy } from '@ohos.arkui.stateManagement';
import { UIContext } from '@ohos.arkui.UIContext';
import { SkeletonLayout } from './SkeletonLayout';
import common from '@ohos.app.ability.common';
import hilog from '@ohos.hilog';

@Entry
@Component
struct MyStateSample {
  @State indicatorBarColor: ResourceColor = '#C0C0C0';
  @State tabIndex: number = 0;
  @State backgroundBarDisplacement: number = 0;
  @State barMargin: number = 0;
  @State tabs: Array<string> = new Array<string>();
  private swiperController: SwiperController = new SwiperController();
  private scroller: Scroller = new Scroller();
  private data: Array<string> = new Array<string>();

  aboutToAppear(): void {
    for (let i = 0; i < 8; i++) {
      this.data.push(`${i}`);
    }
    this.tabs = ['全部', 'UI布局', '动效', '三方库', '其他'];
  }

  build() {
    Column() {
      Column(){
        Stack({ alignContent: Alignment.Start }) {
          Row() {
            Column() {
              Column()
                .height('100%')
                .width('100%')
                .backgroundColor(this.indicatorBarColor)
                .borderRadius(20)
            }
            .height(60)
            .width(90)
            .margin({ left: this.backgroundBarDisplacement } as Margin)
          }
          .alignItems(VerticalAlign.Center)
          .clip(true)
          .height('100%')
          .width('100%')

          // 页签条
          Scroll(this.scroller) {
            Row(){
              ForEach(this.tabs, (item: string, index: number) => {
                Column() {
                  Image($r('app.media.return_home_fill'))
                    .height(20)
                    .width(20)
                    .objectFit(ImageFit.Contain)
                  Text(item)
                    .fontSize(index === this.tabIndex ? $r('app.float.custom_animation_tab_list_select_font_size') : $r('app.float.custom_animation_tab_list_unselect_font_size'))
                    .fontColor('#000000')
                    .fontWeight(index === this.tabIndex ? FontWeight.Bold : FontWeight.Medium)
                    .textAlign(TextAlign.Center)
                }
                .id(String(index))
                .height('100%')
                .width(95)
                .onClick(():void=>{
                  this.backgroundBarDisplacement = this.backgroundBarDisplacement + (index - this.tabIndex) * 95;
                  this.tabIndex = index;
                  if(this.tabIndex === 3){
                    this.scroller.scrollTo({xOffset: 90, yOffset: 0});
                  } else if(this.tabIndex === 1) {
                    this.scroller.scrollTo({xOffset: -90, yOffset: 0});
                  }
                })
              })
            }
          }
          .margin({ top: 10 } as Margin)
          .scrollable(ScrollDirection.Horizontal)
          .scrollBar(BarState.Off)
          .onDidScroll((xOffset: number, yOffset: number, scrollState: ScrollState): void => {
            // 当页签向右滑动时，背景条向左移动；页签向左滑动时，背景条向右移动，通过取负值 -xOffset 反转方向
            this.backgroundBarDisplacement += -xOffset;
          } as ScrollOnScrollCallback)
        }.height(60)
        Swiper() {
          ForEach(this.tabs, (item: string, index: number) => {
            Column(){
              Text(item).fontSize(20)
              List() {
                ForEach(this.data, (data: string, index: number) => {
                  ListItem() {
                    SkeletonLayout({ isMine: false })
                  }
                },(data: string)=> data)
              }
              .width('100%')
              .height('100%')
            }.width('100%')
            .height('100%')
          },(item: string)=> item)
        }
        .id('tabContent')
        .loop(false)
        .indicator(false)
        .index(this.tabIndex)
        .width('100%')
        .height('100%')
        .onChange((index: number):void => {
          this.backgroundBarDisplacement = this.backgroundBarDisplacement + (index - this.tabIndex) * 95;
          this.tabIndex = index;
          if(this.tabIndex === 3){
            this.scroller.scrollTo({xOffset: 90, yOffset: 0});
          } else if(this.tabIndex === 1) {
            this.scroller.scrollTo({xOffset: -90, yOffset: 0});
          }
        })
      }.height('85%')

      // 更新自定义动效变量——背景条颜色
      Column() {
        Button($r('app.string.custom_animation_tab_button_text'))
          .height('40%')
          .onClick(():void => {
            if(this.indicatorBarColor == '#C0C0C0') {
              this.indicatorBarColor = Color.Yellow;
            } else  {
              this.indicatorBarColor = '#C0C0C0';
            }
          })
      }
      .justifyContent(FlexAlign.End)
      .height('15%')
      .width('100%')
    }
    .width('100%')
    .height('100%')
  }
}
