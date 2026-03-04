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
  UIUtils,
  Binding,
  MutableBinding,
  TextInputOptions,
  Margin,
  Color,
  Padding,
  ResourceColor,
  HorizontalAlign,
  FlexAlign,
  Entry, 
  Text, 
  Column, 
  Component, 
  Button, 
  ClickEvent, 
  TextInput, 
  Divider,
  State, 
  Link
} from '@kit.ArkUI'
import hilog from '@ohos.hilog'
import { SIZES, COLORS } from '../common/Contants'

@Builder
function customTextInput(placeHolderValue: Binding<string>, textValue: MutableBinding<string>) {
  Column() {
    Text(placeHolderValue.value)
    TextInput({ placeholder: placeHolderValue.value })
      .placeholderColor(COLORS.textSub)
      .fontSize(SIZES.fontSizeNormal)
      .fontColor(COLORS.textMain)
      .backgroundColor(COLORS.bgCard)
      .height(50)
      .padding({ left: 16, right: 16 } as Padding)
      .borderRadius(SIZES.radius)
      .border({ width: 1, color: COLORS.border })
      .onChange((v: string) => {
        textValue.value = v;
      })
  }
  .backgroundColor(COLORS.bgCard)
  .padding(SIZES.padding as number)
  .borderRadius(SIZES.radius)
  .shadow({
    radius: 6,
    color: 'rgba(0,0,0,0.04)',
    offsetX: 0,
    offsetY: 2
  })
  .width('100%')
}

@Component
export struct MainPage {
  @State placeholderVal: string = '请输入你的新年愿望...';
  @Link textVal: string;

  build() {
    Column() {
      //被修改的父组件参数
      Text(this.textVal)
        .fontSize(SIZES.fontSizeNormal + 2)
        .fontColor(COLORS.textMain)
        .margin({ bottom: 12 } as Margin)
      Button('update')
        .fontSize(SIZES.fontSizeNormal)
        .backgroundColor(COLORS.textMain)
        .height(44)
        .width('100%')
        .onClick((event: ClickEvent) => {
        this.placeholderVal = '新年快乐!'
      })
      //实现功能代码
      customTextInput(
        UIUtils.makeBinding(() => this.placeholderVal),
        UIUtils.makeBinding(() => this.textVal, (v: string) => {
          this.textVal = v;
        })
      )
    }
    .justifyContent(FlexAlign.Start)
  }
}