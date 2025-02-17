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

import TitleBar from '../component/TitleBar';
import router from '@ohos.router';
import { resourceToString } from '../component/ResourceToString';

interface Item {
  text: string;
}

const operationUrls: Array<string> = [
  'i18napplication/LocaleCulturalDivision',
  'i18napplication/LanguagePreferenceSetting',
  'i18napplication/DateTimeFormatting',
  'i18napplication/NumberMeasurementFormatting',
  'i18napplication/PhoneNumberFormatting',
  'i18napplication/CalendarSetting',
  'i18napplication/TimezoneDstSetting',
  'i18napplication/MultilingualSorting',
  'i18napplication/CharacterProcessing',
  'i18napplication/NameLocalization'
];

@Entry
@Component
struct Index {

  @State ListItem: Item[] = [
    { text: resourceToString($r('app.string.LocaleCulturalDivisionExample')) },
    { text: resourceToString($r('app.string.LanguagePreferenceSetting')) },
    { text: resourceToString($r('app.string.DateTimeFormatting')) },
    { text: resourceToString($r('app.string.NumberMeasurementFormatting')) },
    { text: resourceToString($r('app.string.PhoneNumberFormatting')) },
    { text: resourceToString($r('app.string.CalendarSetting')) },
    { text: resourceToString($r('app.string.TimezoneDstSetting')) },
    { text: resourceToString($r('app.string.MultilingualSorting')) },
    { text: resourceToString($r('app.string.CharacterProcessing')) },
    { text: resourceToString($r('app.string.NameLocalization')) }
  ]

  build() {
    Column() {
      TitleBar()
      List() {
        ForEach(this.ListItem, (item: Item, index) => {
          ListItem() {
            Row() {
              Blank().width('4%')
              Text(item.text)
                .fontSize(16)
                .fontColor('black')
                .width('90%')
              Image($r('app.media.right'))
                .height(12)
                .width(12)
            }
            .onClick(() => {
              router.pushUrl({
                url: operationUrls[index]
              })
            })
            .border({ radius: 20 })
            .width('90%')
            .height('8%')
            .backgroundColor(Color.White)
            .margin({ top: 12, left: 15, right: 8 })
          }
        })
      }
      .height('90%')
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
  }
}