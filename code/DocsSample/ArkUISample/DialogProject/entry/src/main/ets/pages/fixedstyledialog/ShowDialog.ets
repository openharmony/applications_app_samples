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

import { PromptAction } from '@kit.ArkUI';

@Entry
@Component
export struct ShowDialogExample {
  build() {
    NavDestination() {
      Column({ space: 12 }) {
        Column() {
          Button('ShowDialog')
            .margin(30)
            .onClick(() => {
              let uiContext = this.getUIContext();
              let promptAction: PromptAction = uiContext.getPromptAction();
              try {
                promptAction.showDialog({
                  title: 'showDialog Title Info',
                  message: 'Message Info',
                  buttons: [
                    {
                      text: 'button1',
                      color: '#000000'
                    },
                    {
                      text: 'button2',
                      color: '#000000'
                    }
                  ]
                }, (err, data) => {
                  if (err) {
                    console.error('showDialog err: ' + err);
                    return;
                  }
                  console.info('showDialog success callback, click button: ' + data.index);
                });
              } catch (error) {
              }
            })
        }.width('100%')
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.ShowDialog_title'))
  }
}