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

// [Start date_picker_dialog]
import { PromptAction } from '@kit.ArkUI';

@Entry
@Component
export struct DatePickerDialogExample {
  @State selectTime: Date = new Date('2023-12-25T08:30:00');

  build() {
    NavDestination() {
      Column({ space: 12 }) {

        Column() {
          Button('showDatePickerDialog')
            .margin(30)
            .onClick(() => {
              this.getUIContext().showDatePickerDialog({
                start: new Date('2000-1-1'),
                end: new Date('2100-12-31'),
                selected: this.selectTime,
                lunarSwitch: true,
                showTime: true,
                onDateAccept: (value: Date) => {
                  this.selectTime = value;
                  console.info('DatePickerDialog:onAccept()' + JSON.stringify(value));
                },
              })
            })
        }.width('100%').margin({ top: 5 })

      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.CustomDialog_date'))
  }
}
// [End date_picker_dialog]