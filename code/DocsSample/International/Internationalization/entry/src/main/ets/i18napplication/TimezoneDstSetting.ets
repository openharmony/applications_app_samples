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
import { assertEqual, assertEqualFuzzy, assertEqualLong } from '../component/AssertEqual';
import { resourceToString } from '../component/ResourceToString';
import { i18n } from '@kit.LocalizationKit';

/**********************************************************************************************************************
 * 时区开发步骤
 *********************************************************************************************************************/
// 时区相关功能开发实例
// 获取巴西时区
let timezone = i18n.getTimeZone('America/Sao_Paulo'); // 传入特定时区，创建时区类
let timezoneId = timezone.getID(); // America/Sao_Paulo

// 获取城市Id对应的时区对象
let aucklandTimezone = i18n.TimeZone.getTimezoneFromCity('Auckland');
let aucklandTzId = aucklandTimezone.getID(); // Pacific/Auckland

// 时区的本地化名称
let timeZoneName = timezone.getDisplayName('zh-Hans', true); // 巴西利亚标准时间

// 本地化城市名称
let cityDisplayName = i18n.TimeZone.getCityDisplayName('Auckland', 'zh-Hans'); // 奥克兰 (新西兰)

// 时区的固定偏移量
let rawOffset = timezone.getRawOffset(); // -10800000

// 时区的实际偏移量(固定偏移量+夏令时)
let offset = timezone.getOffset(1234567890); // -10800000

// 系统支持的时区Id列表
// ["America/Adak", "Asia/Hovd", "America/Sao_Paulo", "Asia/Jerusalem", "Europe/London",...]
let ids = i18n.TimeZone.getAvailableIDs();

// 系统支持的时区城市Id列表
let cityIdArray = i18n.TimeZone.getAvailableZoneCityIDs(); // ["Auckland", "Magadan", "Lord Howe Island",...]

// 遍历时区城市Id列表
let timezoneList: object[] = []; // 呈现给用户的时区列表

class Item {
  public cityDisplayName: string = '';
  public timezoneId: string = '';
  public offset: string = '';
  public cityId: string = '';
}

for (let i = 0; i < cityIdArray.length; i++) {
  let cityId = cityIdArray[i];
  let timezone = i18n.TimeZone.getTimezoneFromCity(cityId); // 城市Id对应的时区对象
  let cityDisplayName = i18n.TimeZone.getCityDisplayName(cityId, 'zh-CN'); // 本地化城市名称
  let timestamp = (new Date()).getTime();
  let item: Item = {
    cityDisplayName: cityDisplayName,
    timezoneId: timezone.getID(),
    offset: 'GMT' + (timezone.getOffset(timestamp) / 3600 * 1000),
    cityId: cityId
  }
  timezoneList.push(item);
}

// 指定地理坐标所在的时区对象数组
let timezoneArray = i18n.TimeZone.getTimezonesByLocation(-43.1, -22.5);
let locationTimezones: string[] = [];
for (let i = 0; i < timezoneArray.length; i++) {
  let tzId = timezoneArray[i].getID(); // America/Sao_Paulo
  locationTimezones.push(tzId);
}

// 双时钟应用开发实例
// 选择时区列表中的时区放入应用偏好时区列表中
let timezone1 = i18n.getTimeZone('America/Sao_Paulo');
let timezone2 = i18n.getTimeZone();
let appPreferredTimeZoneList: i18n.TimeZone[] = []; // 应用偏好时区列表
appPreferredTimeZoneList.push(timezone1);
appPreferredTimeZoneList.push(timezone2);

// 选择时区列表中的时区放入应用偏好时区列表中
let locale = i18n.System.getSystemLocale();
let timeZoneData: string[] = []; // 用于存储每个时区的时间信息
// 遍历时区数组并获取时间信息
for (let i = 0; i < appPreferredTimeZoneList.length; i++) {
  let timezone = appPreferredTimeZoneList[i].getID();
  let calendar = i18n.getCalendar(locale);
  calendar.setTimeZone(timezone); // 设置日历对象的时区
  // 获取年月日时分秒
  let year = calendar.get('year');
  let month = calendar.get('month');
  let day = calendar.get('date');
  let hour = calendar.get('hour');
  let minute = calendar.get('minute');
  let second = calendar.get('second');
  // 格式化时间信息并存储
  timeZoneData.push(
    `${resourceToString($r('app.string.TimeZone'))} ${timezone}, ` +
      `${resourceToString($r('app.string.Time'))} ${year}-${month}-${day} ${hour}:${minute}:${second}`
  );
}

/**********************************************************************************************************************
 * 夏令时跳变实现原理
 *********************************************************************************************************************/

// 计算夏令时跳变前后同一个挂钟时间之间相差的小时数示例
let calendar = i18n.getCalendar('zh-Hans');
calendar.setTimeZone('Europe/London');
calendar.set(2021, 2, 27, 16, 0, 0); // The day before daylight saving time start
let time1 = calendar.getTimeInMillis();
calendar.set(2021, 2, 28, 16, 0, 0); // The day daylight saving time start
let time2 = calendar.getTimeInMillis();
let hours =
  (time2 - time1) / (3600 * 1000); // The hours between the same wall clock time before and after DST. Should be 23

const expectedTimezoneId = 'America/Sao_Paulo';
const expectedAucklandTzId = 'Pacific/Auckland';
const expectedTimeZoneName = [resourceToString($r('app.string.ExpectedTimeZoneName'))];
const expectedCityDisplayName = resourceToString($r('app.string.ExpectedCityDisplayName'));
;
const expectedRawOffset = -10800000;
const expectedOffset = -10800000;
const expectedIds = ['America/Adak', 'Asia/Hovd', 'America/Sao_Paulo', 'Asia/Jerusalem', 'Europe/London'];
const expectedCityIdArray = ['Auckland', 'Magadan', 'Lord Howe Island'];
const expectedTimeZoneCityList: Item[] = [
  {
    cityDisplayName: resourceToString($r('app.string.Adak')),
    timezoneId: 'America/Adak',
    offset: 'GMT-9000000',
    cityId: 'Adak'
  },
  {
    cityDisplayName: resourceToString($r('app.string.Anchorage')),
    timezoneId: 'America/Anchorage',
    offset: 'GMT-8000000',
    cityId: 'Anchorage'
  }
];
const expectedTzId = 'America/Sao_Paulo';
const expectedTimeZoneData =
  [resourceToString($r('app.string.ExpectedTimeZoneData1')), resourceToString($r('app.string.ExpectedTimeZoneData2'))];
const expectedHours = 23;

@Extend(Text)
function textStyle() {
  .fontSize(18)
  .margin({ top: 15, left: 30, right: 20 });
}

@Extend(Scroll)
function scrollStyle(scrollIndex: string) {
  .height('20%')
  .width('80%')
  .id(scrollIndex)
  .margin({ left: 50 })
  .border({
    width: 2,
    color: $r('app.color.Border_Gray'),
    style: BorderStyle.Solid,
    radius: 10
  })
}

@Entry
@Component
struct TimezoneDstSetting {
  build() {
    Column() {
      TitleBar({ hasBackPress: true, title: $r('app.string.TimezoneDstSetting') })
      Scroll() {
        Column() {
          Text($r('app.string.ResultsOfTimezoneFunction'))
            .textStyle()
            .fontWeight(FontWeight.Bold)
          Text(assertEqual(timezoneId, expectedTimezoneId, $r('app.string.GetTimezoneID')))
            .textStyle()
          Text(assertEqual(aucklandTzId, expectedAucklandTzId, $r('app.string.GetAucklandID')))
            .textStyle()
          Text(assertEqualFuzzy(timeZoneName, expectedTimeZoneName, $r('app.string.TimeZoneLocalName')))
            .textStyle()
          Text(assertEqual(cityDisplayName, expectedCityDisplayName, $r('app.string.AucklandDisplayName')))
            .textStyle()
          Text(assertEqual(rawOffset, expectedRawOffset, $r('app.string.GetRawOffset')))
            .textStyle()
          Text(assertEqual(offset, expectedOffset, $r('app.string.GetOffset')))
            .textStyle()
          Text(assertEqualLong(ids.join(', '), expectedIds, $r('app.string.GetAvailableIDs')))
            .textStyle()
          Scroll() {
            Text(ids.join(', '))
              .textStyle()
              .id('idsText')
          }
          .scrollStyle('idsScroll')

          Text(assertEqualLong(cityIdArray.join(', '), expectedCityIdArray, $r('app.string.GetAvailableZoneCityIDs')))
            .textStyle()
          Scroll() {
            Text(cityIdArray.join(', '))
              .textStyle()
              .id('cityIdArrayText')
          }
          .scrollStyle('cityIdArrayScroll')

          Text(assertEqualLong(JSON.stringify(timezoneList),
            expectedTimeZoneCityList.map(item => JSON.stringify(item)), $r('app.string.TimezoneList')))
            .textStyle()
          Scroll() {
            Column() {
              ForEach(timezoneList, (item: Item, index: number) => {
                Column() {
                  Text(`${item.cityDisplayName},${item.timezoneId},${item.offset},${item.cityId}`)
                    .textStyle()
                    .id(`timezoneListText${index}`)
                  Divider().margin({ top: 3, left: 30, right: 30 });
                }
              }, (item: Item, index: number) => `${item.cityId}-${index}`
              );
            }
          }
          .scrollStyle('timezoneListScroll')

          Text(assertEqual(locationTimezones.join(','), expectedTzId, $r('app.string.IDOfGeographicCoordinate')))
            .textStyle()
          Text(assertEqualLong(JSON.stringify(timeZoneData), expectedTimeZoneData,
            $r('app.string.ResultsOfDualClockFeature')))
            .textStyle()
          ForEach(timeZoneData, (item: string, index: number) => {
            Text(item)
              .textStyle()
          }, (item: string, index: number) => `${index}` // 生成唯一标识符
          );

          Text($r('app.string.ResultsOfDaylightSavingTimeJumps'))
            .textStyle()
            .fontWeight(FontWeight.Bold)
          Text(assertEqual(
            hours, expectedHours, $r('app.string.DaylightSavingTimeHourDifference')))
            .textStyle()
          Blank().height('5%')
        }
        .alignItems(HorizontalAlign.Start)
      }
      .id('outerScrollInTimezone')
      .width('100%')
      .height('100%')
    }
  }
}
