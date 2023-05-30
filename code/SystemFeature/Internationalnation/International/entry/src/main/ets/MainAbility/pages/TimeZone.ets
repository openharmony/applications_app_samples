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
import i18n from '@ohos.i18n'
import router from '@ohos.router'
import systemTime from '@ohos.systemTime'
import Logger from '../model/Logger'
import TitleBar from '../view/TitleBar'
import IntlUtil from '../model/IntlUtil';


class TimeZoneInfo {
  key: string
  timeZone: string
  display:  string
}

const TAG: string = 'TimeZone'

@Entry
@Component
struct TimeZone {
  @State timeZoneSrc: TimeZoneInfo[] = [];

  async setTimeZone(key) {
    try {
      let timeZone = await systemTime.getTimezone();
      if (timeZone === key) {
        router.back();
        return
      }
      await systemTime.setTimezone(key);
      Logger.info(TAG, `setTimezone, ${key}`);
      router.back();
    } catch (err) {
      Logger.error(TAG, JSON.stringify(err));
    }
  }

  getTimeZoneSrc() {
    this.timeZoneSrc = [];
    let zoneCityIDs = i18n.TimeZone.getAvailableZoneCityIDs();
    for (let zoneCityId of zoneCityIDs) {
      let cityDisplayName = i18n.TimeZone.getCityDisplayName(zoneCityId, "zh-Hans");
      let timeZone = i18n.TimeZone.getTimezoneFromCity(zoneCityId);
      this.timeZoneSrc.push({
        key: timeZone.getID(),
        timeZone: IntlUtil.getTimeZoneShortString(timeZone),
        display: cityDisplayName
      })
    };
  }

  aboutToAppear() {
    this.getTimeZoneSrc();
  }

  build() {
    Column() {
      TitleBar({ hasBackPress: true, title: $r('app.string.time_zone') })
      Scroll() {
        Column() {
          ForEach(this.timeZoneSrc, (item, index) => {
            Column() {
              if (index !== 0) {
                Divider()
                  .color(Color.Gray)
                  .width('100%')
                  .strokeWidth(1)
                  .margin({ top: 10, bottom: 10 })
              }
              Text(item.display)
                .fontSize(22)
                .width('100%')
                .margin({ top: 10, bottom: 10 })
                .fontColor(Color.Black)
              Text(item.timeZone)
                .fontColor(Color.Gray)
                .fontSize(22)
                .width('100%')
                .margin({ top: 10, bottom: 10 })
            }
            .id(`time_zone_item${index}`)
            .onClick(() => {
              this.setTimeZone(item.key)
            })
          }, item => item.key)
        }
        .width('95%')
        .padding(10)
        .margin({ top: 20, bottom: 10 })
        .backgroundColor(Color.White)
        .border({ color: Color.White, width: 1, radius: 15 })
      }
      .height('92%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}