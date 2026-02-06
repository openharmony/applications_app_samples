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
      Scroll() {
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
          this.textComponent($r('app.string.index_title'));
          this.buttonComponent($r('app.string.create_avSession'), 'pages/CreateAVSession');
          this.buttonComponent($r('app.string.page_destroy'), 'pages/Destroy');
          this.buttonComponent($r('app.string.page_advanced_playback'), 'pages/AdvancedPlaybackControlEvents');
          this.buttonComponent($r('app.string.page_dispatch_event'), 'pages/DispatchSessionEvent');
          this.buttonComponent($r('app.string.page_set_info'), 'pages/SetAVSessionInformation');
          this.buttonComponent($r('app.string.page_fixed_playback'), 'pages/FixedPlaybackControlCommands');
          this.buttonComponent($r('app.string.page_get_controller'), 'pages/GetController');
          this.buttonComponent($r('app.string.page_off'), 'pages/Off');
          this.buttonComponent($r('app.string.page_set_extras'), 'pages/SetExtras');
          this.buttonComponent($r('app.string.page_want_agent'), 'pages/WantAgent');
        }
        .width('100%')
        .padding(20)
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  textComponent(name: string | ResourceStr) {
    Text(name)
      .textAlign(TextAlign.Center)
      .margin({ bottom: 20 })
      .fontSize($r('app.float.index_text_font_size'))
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