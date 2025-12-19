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
// [Start date_picker_custom_dialog]

@Entry
@Component
export struct DatePickerCustomDialogExample {
  @State selectTime: Date = new Date('2023-12-25T08:30:00');

  build() {
    NavDestination() {
      Column() {
        Button('showDatePickerDialog')
          .margin(30)
          .onClick(() => {
            this.getUIContext().showDatePickerDialog({
              start: new Date('2000-1-1'),
              end: new Date('2100-12-31'),
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
    // [StartExclude date_picker_custom_dialog]
    .backgroundColor('#f1f2f3')
    // 请将$r('app.string.CustomCustomDialog_date')替换为实际资源文件，在本示例中该资源文件的value值为"日期滑动选择器自定义弹窗"
    .title($r('app.string.CustomCustomDialog_date'))
    // [EndExclude date_picker_custom_dialog]
    }
}
// [End date_picker_custom_dialog]