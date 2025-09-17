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

import { UIContext } from '@ohos.arkui.UIContext'
import { Text,  List, ListItem, TextAttribute, Column, Component, Button, ButtonAttribute, ClickEvent, $r,
  Image, Margin, Blank, Row, Builder, Alignment, ForEach, Padding, Color, Divider, Tabs, TabContent, BuilderParam, JSON,
  LazyForEach, ListItemGroup, Entry, Canvas, CanvasRenderingContext2D, RenderingContextSettings,FlexAlign
} from '@ohos.arkui.component';
@Entry
@Component
struct Concent {
  build() {
    Column(undefined) {
      Row() {
        Text($r('app.string.custom_return'))
      }
      .margin(3)
      .width('100%')
      .onClick((e: ClickEvent) => {
        this.getUIContext().getRouter().back();
      })
      Column() {
        Text($r('app.string.custom_detail')).fontSize(20)
      }
      .height('100%')
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .align(Alignment.Center)
    }
    .margin({
      bottom: 24,
    } as Margin)
    .height('110%')
    .width('100%')
    .backgroundColor('#F3F3F3')
  }
}
