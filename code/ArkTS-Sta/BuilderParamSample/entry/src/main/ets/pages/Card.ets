'use static'
/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
  Component, Column, Row, Text, Button, ButtonType, SymbolGlyph, Divider, BuilderParam, Builder, PropRef, Require, $r,
  Resource, ResourceStr, HorizontalAlign, VerticalAlign, Color, Margin
} from '@kit.ArkUI'

@Component
export struct CustomCard {
  @PropRef
  symbol: Resource = $r('sys.symbol.label');
  @PropRef
  @Require
  title: string;
  @PropRef
  @Require
  description: ResourceStr;

  @Builder
  textBuilder() {
    Column() {
      Text(this.title)
        .fontColor($r('sys.color.font_primary'))

      Text(this.description)
        .fontColor($r('sys.color.font_secondary'))
        .fontSize($r('sys.float.Body_S'))
    }
    .alignItems(HorizontalAlign.Start)
    .layoutWeight(1)
    .padding({ left: 10, right: 10 })
  }

  @Builder
  dividerBuilder() {
    Divider()
      .backgroundColor(Color.Blue)
      .margin({ left: 10, right: 10 })
  }

  @Builder
  labelBuilder() {
    Button() {
      SymbolGlyph(this.symbol)
        .fontColor(['#fff'])
        .fontSize(16)
    }
    .type(ButtonType.Circle)
    .borderRadius(14)
  }

  build() {
    // 在创建Card组件时，通过其后紧跟一个大括号“{}”形成尾随闭包，同时支持Card组件中包含多个@BuilderParam属性。
    Card({
      verticalAlign: VerticalAlign.Top,
      // 把this.textBuilder传给子组件Card的@BuilderParam detailContent
      // 把this.dividerBuilder传给子组件Card的@BuilderParam bottomContent
      // this指向的是本组件CustomCard
      detailContent: this.textBuilder,
      bottomContent: this.dividerBuilder
    }) { // 尾随闭包仅初始化Card组件最后一个被@BuilderParam属性。
      this.labelBuilder()
    }
    .width('100%') // 支持通用属性
  }
}

@Component
export struct Card {
  @PropRef
  verticalAlign: VerticalAlign = VerticalAlign.Center;

  // 子组件内定义了多个被@BuilderParam装饰的属性。
  @BuilderParam
  bottomContent: () => void;
  @BuilderParam
  detailContent: () => void;
  @BuilderParam
  labelContent: () => void;

  build() {
    Column() {
      Row() {
        this.labelContent()
        this.detailContent()
      }
      .alignItems(this.verticalAlign)
      .backgroundColor('#fff')
      .borderRadius(12)
      .padding(12)
      .width('100%')

      this.bottomContent()
    }
  }
}