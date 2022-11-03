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

@Extend(Text)
function leftTitleStyle() {
  .fontColor($r('app.color.sub_title_color'))
  .fontSize(14)
  .height(22)
  .alignSelf(ItemAlign.Start)
  .margin({left: 12, top: 12})
}

@Extend(Column)
function cardStyle() {
  .backgroundColor(Color.White)
  .borderRadius(24)
  .width('100%')
  .padding(15)
}

@Entry
@Component
struct TimePickerSample {
  @State isMilitaryTime: boolean = false
  private selectedTime: Date = new Date()

  build() {
    Column() {
      TitleBar({title: $r('app.string.time_picker')})
      Column() {
        TimePicker({
          selected: this.selectedTime,
        })
          .useMilitaryTime(this.isMilitaryTime)
          .onChange((value: TimePickerResult) => {
            this.selectedTime.setHours(value.hour, value.minute)
            console.info('select current date is: ' + JSON.stringify(value))
          })
          .height(300)
      }
      .cardStyle()
      .width('100%')
      Text($r('app.string.normal_options'))
        .leftTitleStyle()
      Column() {
        Row() {
          Text('useMilitaryTime')
            .leftTitleStyle()
            .width('50%')
          Blank()
          Toggle({ type: ToggleType.Switch, isOn: this.isMilitaryTime })
            .onChange((isOn) => {
              this.isMilitaryTime = isOn
            })
        }.width('100%')
        .height(50)
      }.cardStyle()
    }.height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_light_gray'))
    .padding({left: 20, right: 20})
  }
}