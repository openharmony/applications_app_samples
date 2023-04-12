/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
import i18n from '@ohos.i18n'
import IntlUtil from '../model/IntlUtil'
import TitleBar from '../view/TitleBar'
import ResourceUtil from '../model/ResourceUtil'

@Entry
@Component
struct Examples {
  private is24Hours: boolean = i18n.is24HourClock()
  @State date: string = ''
  @State time: string = ''
  @State language: string = ''
  @State numberFormat: Array<string> = []
  @State pluralFormat: string = ''
  @State mDirection: string = ''

  aboutToAppear() {
    this.getLanguage()
    this.getTimeDisplay()
    this.numberFormat = IntlUtil.getNumberFormatString()
    this.getPluralFormat()
  }

  async getPluralFormat() {
    this.pluralFormat = await ResourceUtil.getPluralString($r('app.plural.eat_apple').id, 5)
    this.mDirection = await ResourceUtil.getString($r('app.string.screen_direction').id)
    this.mDirection += await ResourceUtil.getDirection()
  }

  getTimeDisplay() {
    let timeInfo = IntlUtil.getDateString()
    this.date = timeInfo[0]
    this.time = timeInfo[1]
  }

  getLanguage() {
    let systemLanguage = i18n.getSystemLanguage()
    this.language = i18n.getDisplayLanguage(systemLanguage, systemLanguage)
  }

  @Builder TextView( $$: { text }) {
    Text($$.text)
      .fontSize(22)
      .fontColor(Color.Gray)
      .width('95%')
      .margin({ top: 20 })
  }

  build() {
    Column() {
      TitleBar({ hasBackPress: true, title: $r('app.string.format_example') })
      this.TextView({ text: this.language })
      Column() {
        this.TextView({ text: this.date })
        this.TextView({ text: this.time })
        ForEach(this.numberFormat, (item, index) => {
          this.TextView({ text: item })
        }, item => item)
        this.TextView({ text: this.pluralFormat })
        this.TextView({ text: this.mDirection })
      }
      .width('95%')
      .padding(10)
      .backgroundColor(Color.White)
      .margin({ top: 10 })
      .border({ color: Color.White, width: 1, radius: 15 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}