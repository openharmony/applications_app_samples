/*
* Copyright (C) 2025 Huawei Device Co., Ltd.
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

import {Router} from '@ohos.arkui.UIContext';
const router = new Router();

@Entry
@Component
struct Index {
  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center}) {
        this.textComponent('Index');
        this.buttonComponent('音振协同播放页面', 'pages/Haptic');
        this.buttonComponent('音频播放页面', 'pages/Renderer');
      }.size({ width: '100%', height: '100%' })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  textComponent(name: string) {
    Text(name)
      .textAlign(TextAlign.Center)
      .margin(10)
      .fontSize($r('app.float.index_text_font_size'))
      .size({ width: '100%', height: $r('app.float.index_button_height_size') })
  }

  @Builder
  buttonComponent(name: string, dstUri: string) {
    Button(name)
      .width('80%')
      .margin(10)
      .onClick((e: ClickEvent) => {
        router.pushUrl({ url: dstUri });
      })
  }
}