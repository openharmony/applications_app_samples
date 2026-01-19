/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import { Router } from '@ohos.arkui.UIContext';

const router = new Router();

@Entry
@Component
struct Index {
  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
        this.textComponent('Index');
        this.buttonComponent($r('app.string.BasicKnowledge'), 'pages/BasicKnowledge');
        this.buttonComponent($r('app.string.Function'), 'pages/Function');
        this.buttonComponent($r('app.string.Class'), 'pages/Class');
        this.buttonComponent($r('app.string.GenericTypesAndFunctions'), 'pages/GenericTypesAndFunctions');
      }
      .width('100%')
      .padding(20)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  textComponent(name: string) {
    Text(name)
      .textAlign(TextAlign.Center)
      .margin({ bottom: 20 })
      .fontSize($r('app.float.page_text_font_size'))
      .fontWeight(FontWeight.Bold)
  }

  @Builder
  buttonComponent(name: string | ResourceStr, dstUri: string) {
    Button(name)
      .width('80%')
      .height('auto')
      .padding({ top: 16, bottom: 16, left: 20, right: 20 })
      .margin({ bottom: 16 })
      .fontSize(16)
      .onClick((e: ClickEvent) => {
        router.pushUrl({ url: dstUri });
      })
  }
}