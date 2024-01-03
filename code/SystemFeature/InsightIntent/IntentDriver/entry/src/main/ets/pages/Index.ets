/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import PlayMusicIntentExecutorImpl from '../intents/PlayMusicIntentExecutorImpl';
import { playMusicIntentDriver } from '../intents/PlayMusicIntentDriver';
import promptAction from '@ohos.promptAction';

const DELAY_MS: number = 500;
const DURATION: number = 2500;

@Entry
@Component
struct Index {
  @State message: string = '';

  build() {
    Column() {
      Text($r('app.string.intent_execute_title'))
        .fontColor('#182431')
        .fontSize(32)
        .fontWeight(700)
        .margin({ left: 72, top: 32 })
        .textAlign(TextAlign.Start)
        .width('100%')
      Button($r('app.string.IntentInUIAbilityForeground'))
        .type(ButtonType.Capsule)
        .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
        .backgroundColor($r('app.color.button_background'))
        .fontColor($r('sys.color.ohos_id_color_foreground_contrary'))
        .fontSize($r('sys.float.ohos_id_text_size_button1'))
        .height(48)
        .width('624px')
        .margin({ top: 500 })
        .key('button_IntentInUIAbilityForeground')
        .onClick(() => {
          playMusicIntentDriver.executeUIAbilityForeground();
          setTimeout(() => {
            this.message = JSON.stringify(playMusicIntentDriver.executeResult);
            if (this.message != null) {
              promptAction.showToast({ message: this.message, duration: DURATION, bottom: 230 });
            }
          }, DELAY_MS)
          PlayMusicIntentExecutorImpl.length;
        })
      Button($r('app.string.IntentInServiceExtension'))
        .type(ButtonType.Capsule)
        .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
        .backgroundColor($r('app.color.button_background'))
        .fontColor($r('sys.color.ohos_id_color_foreground_contrary'))
        .fontSize($r('sys.float.ohos_id_text_size_button1'))
        .height(48)
        .width('624px')
        .margin({ top: 16 })
        .id('button_IntentInServiceExtension')
        .onClick(() => {
          playMusicIntentDriver.executeServiceExtension();
          setTimeout(() => {
            this.message = JSON.stringify(playMusicIntentDriver.executeResult);
            if (this.message != null) {
              promptAction.showToast({ message: this.message, duration: DURATION, bottom: 230 });
            }
          }, DELAY_MS)
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('sys.color.ohos_id_color_text_field_sub_bg'))
  }
}