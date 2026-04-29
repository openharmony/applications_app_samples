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
 * WITHOUT WARRANTIES OR CONDITIONS OF InputStyle KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { Entry, Text, TextAttribute, Column, Component, Button, ClickEvent, ForEach, Flex, FlexDirection, ItemAlign, FlexAlign, Padding, Stack, Alignment, Builder, $r } from '@ohos.arkui.component';
import { numberSourceListData, sourceListType } from './KeyboardKeyData';
import keyboardController from '../model/KeyboardController';
import { State } from '@ohos.arkui.stateManagement';
import router from '@ohos.router';

@Component
struct keyItem {
  private keyValue: sourceListType = numberSourceListData[0];
  @State keyBgc: string = "#fff";
  @State keyFontColor: string = "#000";

  build() {
    Flex({ direction: FlexDirection.Column,
      alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Text(this.keyValue.content).fontSize(20).fontColor(this.keyFontColor)
    }
    .backgroundColor(this.keyBgc)
    .borderRadius(6)
    .width("8%")
    .height("65%")
    .onClick(() => {
      keyboardController.insertText(this.keyValue.content);
    })
  }
}

// 删除组件
@Component
export struct deleteItem {
  @State keyBgc: string = "#fff";
  @State keyFontColor: string = "#000";

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column,
        alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
        Text($r('app.string.delete_button')).fontSize(20).fontColor(this.keyFontColor)
      }
    }
    .backgroundColor(this.keyBgc)
    .width("13%")
    .borderRadius(6)
    .onClick(() => {
      keyboardController.deleteForward(1);
    })
  }
}

// 数字键盘
@Component
struct numberMenu {
  private numberList: sourceListType[] = numberSourceListData;

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceEvenly }) {
      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        ForEach(this.numberList, (item: sourceListType) => { // 数字键盘第一行
          keyItem({ keyValue: item })
        }, (item: sourceListType) => item.content);
      }
      .padding({ top: "2%" } as Padding )
      .width("96%")
      .height("25%")

      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        deleteItem()
      }
      .width("96%")
      .height("25%")
    }

  }
}

@Entry
@Component
struct Index {
  private numberList: sourceListType[] = numberSourceListData

  build() {
    Stack() {
      Flex({
        direction: FlexDirection.Column,
        alignItems: ItemAlign.Center,
        justifyContent: FlexAlign.End
      }) {
        Flex({
          direction: FlexDirection.Column,
          alignItems: ItemAlign.Center,
          justifyContent: FlexAlign.SpaceBetween
        }) {
          numberMenu({
            numberList: this.numberList
          })
        }
        .align(Alignment.End)
        .width("100%")
        .height("75%")
      }
      .height("100%").align(Alignment.End).backgroundColor("#cdd0d7")
    }
    .position({ x: 0, y: 0 }).zIndex(99999)
  }
}