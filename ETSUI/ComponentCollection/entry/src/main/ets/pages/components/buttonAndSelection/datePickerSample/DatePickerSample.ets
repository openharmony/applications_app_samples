/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { TitleBar } from '../../../../common/TitleBar'

@Entry
@Component
struct DatePickerSample {
  @State isLunar: boolean = false
  @State selectDate: string = '2022-10-30'

  @Styles itemBorder() {
    .padding(12)
    .borderRadius(24)
    .margin({ top: 12 })
    .backgroundColor(Color.White)
  }

  build() {
    Column() {
      TitleBar({ title: $r('app.string.date_picker_title') })
      Column() {
        Text(this.selectDate)
          .width('100%')
          .margin(12)
          .textAlign(TextAlign.Center)
        DatePicker({
          start: new Date('1970-1-1'),
          end: new Date('2200-12-31'),
          selected: new Date(this.selectDate) // Default date is 2022-10-30
        })
          .height(230)
          .lunar(this.isLunar)
          .onChange((date: DatePickerResult) => {
            // Get date from value
            let month: string = `${date.month + 1}`
            let day: string = `${date.day}`
            if (date.month < 9) {
              month = `0${date.month + 1}`
            }
            if (date.day < 10) {
              day = `0${date.day}`
            }
            this.selectDate = `${date.year}-${month}-${day}`
          })
        Row() {
          Checkbox()
            .select(this.isLunar)
            .onChange((isSelect: boolean) => {
              this.isLunar = isSelect
            })
          Text($r('app.string.date_picker_lunar'))
        }
      }
      .itemBorder()
      .padding({ left: 12, right: 12 })
      .margin({ top: 12, left: 12, right: 12 })
      .alignItems(HorizontalAlign.Start)
    }
    .height('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}