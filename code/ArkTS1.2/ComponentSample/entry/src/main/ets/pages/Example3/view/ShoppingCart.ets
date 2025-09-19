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
  Text,
  TextAttribute,
  Column,
  Component,
  Button,
  ButtonAttribute,
  ClickEvent,
  PixelMap,
  ResourceStr,
  Row,
  Checkbox,
  Stack,
  NavDestination,
  FontWeight,
  Alignment,
  List,
  NavPathStack,
  Builder,
  Navigation,
  $r,
  SafeAreaType,
  SafeAreaEdge,
  Color,
  Scroll,
  ForEach,
  LazyForEach,
  ListItem
} from '@ohos.arkui.component';
import {
  State,
  MutableState,
  stateOf,
  observableProxy,
  Prop
} from '@ohos.arkui.stateManagement';

import hilog from '@ohos.hilog';
import { Context, UIContext } from '@ohos.arkui.UIContext';
import { MyDataSource } from '../common/LazyForEach';
import { BottomBar, ImageText } from '../common/CommonText';
import { Details } from './Details';

@Component
export struct ShoppingCart {
  private data: MyDataSource = new MyDataSource();

  aboutToAppear() {
    for (let i = 1; i <= 20; i++) {
      this.data.pushData('商品' + i);
    }
  }

  build() {
    Column() {
      Column() {
        Text($r('app.string.dynamicattributes_shopping_cart'))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .height(50)
          .padding(20)
          .align(Alignment.Bottom)
        List() {
          LazyForEach(this.data, (item: string) => {
            ListItem() {
              ShoppingInfo({ item: item });
            }.width('100%')
          })
        }.width('100%')
      }.backgroundColor('#ffc4c6c6')
      .height('90%')
      .width('100%')

      BottomBar({
        buttonName: $r('app.string.dynamicattributes_settlement')
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}


@Component
struct ShoppingInfo {
  @Prop item: string = ' ';

  build() {
    Column() {
      // 店铺信息
      Row() {
        Row()
          .borderRadius(5)
          .width(20)
          .height(20)
          .backgroundColor($r('app.color.dynamicattributes_iconColor'))

        Text($r('app.string.dynamicattributes_store_name'))
          .fontSize(15)
          .margin($r('app.float.dynamicattributes_float_5'))
      }
      .width(($r('app.string.dynamicattributes_max_size')))
      .height($r('app.float.dynamicattributes_float_20'))

      // 商品信息
      Row() {
        ImageText({ item: this.item })
      }.onClick((e: ClickEvent) => {
        this.getUIContext().getRouter().pushUrl({ url: 'pages/Example3/view/Details' });
      })
    }
    .padding($r('app.float.dynamicattributes_float_15'))
    .margin(10)
    .height($r('app.float.dynamicattributes_float_160'))
    .backgroundColor($r('app.color.dynamicattributes_white'))
    .borderRadius($r('app.float.dynamicattributes_float_20'))
  }
}
