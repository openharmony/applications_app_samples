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

// [Start time_picker_dialog]
import { PromptAction } from '@kit.ArkUI';

@Entry
@Component
export struct TimePickerDialogExample {
  @State selectTime: Date = new Date('2023-12-25T08:30:00');

  build() {
    NavDestination() {
      Column({ space: 12 }) {

        Column() {
          Button('showTimePickerDialog')
            .margin(30)
            .onClick(() => {
              this.getUIContext().showTimePickerDialog({
                selected: this.selectTime,
                textStyle: { color: '#2787d9', font: { size: '14fp', weight: FontWeight.Normal } },
                selectedTextStyle: { color: '#004aaf', font: { size: '18fp', weight: FontWeight.Regular } },
                acceptButtonStyle: {
                  fontColor: '#2787d9',
                  fontSize: '16fp',
                  backgroundColor: '#f7f7f7',
                  borderRadius: 10
                },
                cancelButtonStyle: {
                  fontColor: Color.Red,
                  fontSize: '16fp',
                  backgroundColor: '#f7f7f7',
                  borderRadius: 10
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
    .title($r('app.string.CustomDialog_time'))
  }
}
// [End time_picker_dialog]