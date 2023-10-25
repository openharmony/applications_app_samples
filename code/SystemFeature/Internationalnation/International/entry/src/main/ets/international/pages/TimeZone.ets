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
import router from '@ohos.router';
import systemTime from '@ohos.systemTime';
import Logger from '../../utils/Logger';
import TitleBar from '../../components/TitleBar';
import IntlUtil from '../../utils/IntlUtil';

class TimeZoneInfo {
  key: string = '';
  timeZone: string = '';
  display: string = '';
}

const TAG: string = 'TimeZone';

@Entry
@Component
struct TimeZone {
  @State timeZoneSrc: TimeZoneInfo[] = [];

  async setTimeZone(key: string) {
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
      });
    }
    ;
  }

  aboutToAppear() {
    this.getTimeZoneSrc();
  }

  build() {
    Column() {
      TitleBar({ hasBackPress: true, title: $r('app.string.time_zone') })
      Scroll() {
        Column() {
          ForEach(this.timeZoneSrc, (item: TimeZoneInfo, index: number) => {
            Column() {
              if (index !== 0) {
                Divider()
                  .color($r('app.color.divider'))
                  .width('100%')
                  .strokeWidth(1)
                  .margin({ top: 10, bottom: 10 })
              }
              Text(item.display)
                .fontSize(22)
                .width('100%')
                .margin({ top: 10, bottom: 10 })
                .fontColor($r('app.color.black'))
              Text(item.timeZone)
                .fontColor($r('app.color.gray'))
                .fontSize(20)
                .width('100%')
                .margin({ top: 5, bottom: 5 })
            }
            .id(`time_zone_item${index}`)
            .onClick(() => {
              this.setTimeZone(item.key);
            })
          }, (item: TimeZoneInfo) => item.key)
        }
        .width('95%')
        .padding(10)
        .margin({ top: 20, bottom: 10 })
        .backgroundColor($r('app.color.white'))
        .border({ color: $r('app.color.white'), width: 1, radius: 15 })
      }
      .height('92%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.f5f5f5'))
  }
}