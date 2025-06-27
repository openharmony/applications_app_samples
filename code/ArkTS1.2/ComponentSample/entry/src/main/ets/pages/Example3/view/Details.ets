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
  UserView,
  Stack,
  Row,
  FlexAlign,
  Image,
  $r,
  FontWeight,
  Color,
  Entry,
  SafeAreaEdge,
  SafeAreaType
} from '@ohos.arkui.component';
import { State, StateDecoratedVariable, MutableState, stateOf, observableProxy } from '@ohos.arkui.stateManagement';
import hilog from '@ohos.hilog';
import { BarType, BottomBar, CommonText } from '../common/CommonText';

const COLUMN_SPACE = 20; // column间隙
const TEXT_SIZE = 15; // 自定义组件中text大小

@Entry
@Component
export struct Details {
  build() {
    Column() {
      Column() {
        Text('← ').fontSize(20)
          .onClick((e: ClickEvent) => {
            this.getUIContext().getRouter().back()
          }).width('100%').height('5%')

        // 商品图片
        Image($r('app.media.icon'))
          .height('60%').width('100%')
        // 商品详情区
        ProductInfo()
      }.width('100%').height('95%')

      // 底部购买区
      BottomBar({
        buttonName: $r('app.string.dynamicattributes_settlement'),
        barType: BarType.DETAILS
      })
    }.width('100%').height('100%').backgroundColor(Color.White)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}

@Component
struct ProductInfo {
  build() {
    Row() {
      Column() {
        Row() {
          Text($r('app.string.dynamicattributes_commodity_price'))// 动态设置组件样式
            .width(100)
            .fontSize(30)
          Text($r('app.string.dynamicattributes_sold'))
            .fontSize(15)
            .width(60)
        }
        .width($r('app.string.dynamicattributes_max_size'))
        .justifyContent(FlexAlign.SpaceBetween)

        Row() {
          Text($r('app.string.dynamicattributes_full_reduction'))
            .fontColor($r('app.color.dynamicattributes_red'))
            .fontSize(20)

          Button($r('app.string.dynamicattributes_coupon_collection'))
            .height(20)
            .backgroundColor($r('app.color.dynamicattributes_red'))
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width($r('app.string.dynamicattributes_max_size'))

        Text($r('app.string.dynamicattributes_commodity_name'))
          .fontWeight(FontWeight.Bold)
          .fontSize(25)
          .width('100%')
        Text($r('app.string.dynamicattributes_commodity_model'))
          .fontSize(25)
          .fontColor(Color.Gray)
          .width('100%')
        CommonText()
      }
      .backgroundColor($r('app.color.dynamicattributes_white'))
      .height('100%')
    }
    .padding(10)
    .height('40%')
    .width($r('app.string.dynamicattributes_max_size'))
  }
}