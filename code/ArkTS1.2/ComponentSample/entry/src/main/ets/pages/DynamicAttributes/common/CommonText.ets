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
  AttributeModifier,
  RowAttribute,
  ImageAttribute,
  CheckboxAttribute,
  Row,
  Checkbox,
  $r,
  Resource,
  Image,
  TextAlign,
  FlexAlign
} from '@ohos.arkui.component';
import {
  State,
  Consume,
  MutableState,
  stateOf,
  observableProxy
} from '@ohos.arkui.stateManagement';
import hilog from '@ohos.hilog';

const COLUMN_SPACE = 10; // column间隙

/**
 * 自定义封装公共文本组件
 */
@Component
export struct CommonText {
  build() {
    Row() {
      Text($r('app.string.dynamicattributes_text_one'))
        .fontSize(12)
        .fontColor($r('app.color.dynamicattributes_orange'))
        .textAlign(TextAlign.Center)
      Text($r('app.string.dynamicattributes_text_two'))
        .fontSize(12)
        .fontColor($r('app.color.dynamicattributes_orange'))
        .textAlign(TextAlign.Center)
        .margin(10);
      Text($r('app.string.dynamicattributes_text_three'))
        .fontSize(12)
        .fontColor($r('app.color.dynamicattributes_orange'))
        .textAlign(TextAlign.Center)
    }.width('100%')
  }
}

/**
 * 自定义封装底部bar组件
 */
@Component
export struct BottomBar {
  @State buttonName: Resource = $r('app.string.dynamicattributes_settlement');
  @State barType: BarType = BarType.SHOPPING_CART;

  build() {
    Row() {
      Column() {
        if (this.barType === BarType.DETAILS) {
          Button($r('app.string.dynamicattributes_add_cart'))
            .height(30)
            .width(90)
            .backgroundColor(($r('app.color.dynamicattributes_orange')))
            .onClick((e: ClickEvent) => {
            })
        }
      }

      Button(this.buttonName)
        .height(30)
        .width(90)
        .backgroundColor(($r('app.color.dynamicattributes_orange')))
        .onClick((e: ClickEvent) => {
        })
    }
    .height(60)
    .width('100%')
    .padding(15)
    .backgroundColor($r('app.color.dynamicattributes_barColor'))
    .justifyContent(FlexAlign.End)
  }
}

/**
 * 自定义封装图文组件
 */
@Component
export struct ImageText {
  @State item: string | Resource = $r('app.string.dynamicattributes_text');
  @State textOneContent: string | Resource = $r('app.string.dynamicattributes_text');
  @State textTwoContent: string | Resource = $r('app.string.dynamicattributes_text');
  @State textThreeContent: string | Resource = $r('app.string.dynamicattributes_text');
  @State imageSrc: Resource = $r('app.media.icon');

  build() {
    Row() {
      Row() {
        Image($r('app.media.icon'))
          .height(100)
          .width(100)
          .borderRadius(15)
      }

      Column() {
        Text(this.item)
          .fontSize(20).width('100%')
        Text(this.textThreeContent)
          .fontSize(20).width('100%')
        CommonText()
        Text(this.textOneContent)
          .fontSize(20).width('100%')
          .fontColor($r('app.color.dynamicattributes_orange'))
      }.margin(15)
    }
    .width('100%')
    .height('100%')
  }
}

/*
  枚举底部bar类型
*/
export enum BarType {
  SHOPPING_CART, // 购物车
  DETAILS, // 详情页
}