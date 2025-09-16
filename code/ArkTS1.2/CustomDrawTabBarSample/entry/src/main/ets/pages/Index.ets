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
  Column,
  Component,
  FlexAlign,
  GradientDirection,
  Color,
  $r,
  Divider
} from '@ohos.arkui.component';
import { State } from '@ohos.arkui.stateManagement';
import hilog from '@ohos.hilog';
import { TabsConcaveCircle } from '../components/tabsConcaveCircle/TabsConcaveCircle';
import { TabsRaisedCircle } from '../components/tabsRaisedCircle/TabsRaisedCircle';
import { TabMenusInterfaceIRequired } from '../types/TabMenusInterface';

@Entry
@Component
struct Index {
  @State currentIndex: number = 0;
  @State tabsMenu: TabMenusInterfaceIRequired[] = [
    {
      text: $r('app.string.custom_tab_home'),
      image: $r('app.media.tab_home'),
      selectImage: $r('app.media.tab_community')
    },
    {
      text: $r('app.string.custom_tab_friend'),
      image: $r('app.media.tab_cart'),
      selectImage: $r('app.media.tab_community')
    },
    {
      text: $r('app.string.custom_tab_news'),
      image: $r('app.media.tab_new'),
      selectImage: $r('app.media.tab_community')
    },
    {
      text: $r('app.string.custom_tab_mine'),
      image: $r('app.media.tab_user'),
      selectImage: $r('app.media.tab_community')
    }
  ] as TabMenusInterfaceIRequired[];

  build() {
    Column() {
      TabsRaisedCircle({
        tabsMenu: this.tabsMenu,
        selectIndex: this.currentIndex,
      })
      Divider()
        .margin(30)
      TabsConcaveCircle({
        tabsMenu: this.tabsMenu,
        selectIndex: this.currentIndex,
      });
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .linearGradient({
      direction: GradientDirection.Left,
      repeating: false,
      colors: [[Color.White, 0.0], [Color.Pink, 1]]
    })
  }
}