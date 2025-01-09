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
export struct TextPickerDialogExample {
  private fruits: TextCascadePickerRangeContent[] = [
    {
      text: 'United States',
      children: [{ text: 'California', children: [{ text: 'Los Angeles' }, { text: 'San Francisco' }, { text: 'San Diego' }] },
        { text: 'Texas', children: [{ text: 'Houston' }, { text: 'Dallas' }, { text: 'Austin' }] }]
    },
    {
      text: 'Canada',
      children: [{ text: 'Ontario', children: [{ text: 'Toronto' }, { text: 'Ottawa' }, { text: 'Hamilton' }] },
        { text: 'British Columbia', children: [{ text: 'Vancouver' }, { text: 'Victoria' }, { text: 'Kelowna' }] }]
    },
    {
      text: 'Australia',
      children: [{ text: 'New South Wales', children: [{ text: 'Sydney' }, { text: 'Canberra' }, { text: 'Newcastle' }] },
        { text: 'Victoria', children: [{ text: 'Melbourne' }, { text: 'Geelong' }, { text: 'Ballarat' }] }]
    }
  ]
  private select : number  = 0;

  build() {
    NavDestination() {
      Column({ space: 12 }) {

        Column() {
          Button('showTextPickerDialog')
            .margin(30)
            .onClick(() => {
              this.getUIContext().showTextPickerDialog({
                range: this.fruits,
                selected: this.select,
                onAccept: (value: TextPickerResult) => {
                  this.select = value.index as number;
                }
              })
            })
        }.width('100%').margin({ top: 5 })

      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.CustomDialog_text'))
  }
}