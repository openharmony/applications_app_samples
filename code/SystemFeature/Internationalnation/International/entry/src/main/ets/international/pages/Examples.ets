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
import i18n from '@ohos.i18n';
import IntlUtil from '../../utils/IntlUtil';
import TitleBar from '../../components/TitleBar';
import ResourceUtil from '../../utils/ResourceUtil';

const LONGITUDE = 116.20;
const LATITUDE = 39.56;

@Entry
@Component
struct Examples {
  @State date: string = '';
  @State time: string = '';
  @State language: string = '';
  @State numberFormat: Array<string> = [];
  @State pluralFormat: string = '';
  @State mDirection: string = '';
  @State timeZoneDetect: string = '';
  @State normalizer: string = '';

  aboutToAppear() {
    this.getLanguage();
    this.getTimeDisplay();
    this.getTimeZoneDetect();
    this.getNormalizer();
    this.numberFormat = IntlUtil.getNumberFormatString();
    this.getPluralFormat();
  }

  async getPluralFormat() {
    this.pluralFormat = await ResourceUtil.getPluralString($r('app.plural.eat_apple').id, 5);
    this.mDirection = ResourceUtil.getString($r('app.string.screen_direction').id);
    this.mDirection += await ResourceUtil.getDirection();
  }

  getTimeDisplay() {
    let timeInfo = IntlUtil.getDateString();
    this.date = timeInfo[0];
    this.time = timeInfo[1];
  }

  getTimeZoneDetect() {
    this.timeZoneDetect = ResourceUtil.getString($r('app.string.coordinate').id);
    this.timeZoneDetect += '(' + LONGITUDE + ',' + LATITUDE + ') ' +
    i18n.TimeZone.getTimezonesByLocation(LONGITUDE, LATITUDE)[0].getDisplayName();
  }

  getNormalizer() {
    let nl = i18n.Normalizer.getInstance(i18n.NormalizerMode.NFC);
    this.normalizer = '\u1100 +\u1161 +\u11A8 = ' + nl.normalize('\u1100\u1161\u11A8');
  }

  getLanguage() {
    let systemLanguage = i18n.System.getSystemLanguage();
    this.language = i18n.System.getDisplayLanguage(systemLanguage, systemLanguage);
  }

  @Builder
  TextView($$: Data) {
    Text($$.text)
      .fontSize(20)
      .fontColor($r('app.color.gray'))
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
        ForEach(this.numberFormat, (item: string, index: number) => {
          this.TextView({ text: item });
        }, (item: string) => item)
        this.TextView({ text: this.pluralFormat })
        this.TextView({ text: this.timeZoneDetect })
        this.TextView({ text: this.normalizer })
        this.TextView({ text: this.mDirection })
      }
      .width('95%')
      .padding({ bottom: 20, left: 10, right: 10 })
      .backgroundColor($r('app.color.white'))
      .margin({ top: 5 })
      .border({ color: $r('app.color.white'), width: 1, radius: 15 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.f5f5f5'))
  }
}

class Data {
  text: string = '';
}