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
// [Start import_module]
import { i18n } from '@kit.LocalizationKit';
// [End import_module]

/**********************************************************************************************************************
 * 时区开发步骤
 *********************************************************************************************************************/
// [Start get_current_timezone]
// 获取巴西时区
let timezone: i18n.TimeZone = i18n.getTimeZone('America/Sao_Paulo'); // 传入特定时区，创建时区对象
let timezoneId = timezone.getID(); // timezoneId = 'America/Sao_Paulo'

// 获取城市ID对应的时区对象
let aucklandTimezone: i18n.TimeZone = i18n.TimeZone.getTimezoneFromCity('Auckland');
timezoneId = aucklandTimezone.getID(); // timezoneId = 'Pacific/Auckland'

// 获取时区的本地化名称
let timeZoneName = timezone.getDisplayName('zh-Hans', true); // timeZoneName = '巴西利亚标准时间'

// 本地化城市名称
let cityDisplayName = i18n.TimeZone.getCityDisplayName('Auckland', 'zh-Hans'); // cityDisplayName = '奥克兰 (新西兰)'

// 时区的固定偏移量
let rawOffset = timezone.getRawOffset(); // rawOffset = -10800000

// 时区的实际偏移量（固定偏移量+夏令时）
let offset = timezone.getOffset(1234567890); // offset = -10800000

// 系统支持的时区ID列表
let availableIDs = i18n.TimeZone.getAvailableIDs(); // availableIDs = ['America/Adak', 'Asia/Hovd', ...]

// 系统支持的时区城市ID列表
let cityIDs = i18n.TimeZone.getAvailableZoneCityIDs(); // cityIDs = ['Auckland', 'Magadan', ...]

// 遍历时区城市ID列表
let timezoneList: object[] = []; // 呈现给用户的时区列表

class Item {
  public cityDisplayName = '';
  public timezoneId = '';
  public offset = '';
  public cityId = '';
};

for (let i = 0; i < cityIDs.length; i++) {
  let cityId = cityIDs[i];
  let timezone: i18n.TimeZone = i18n.TimeZone.getTimezoneFromCity(cityId); // 城市ID对应的时区对象
  let cityDisplayName = i18n.TimeZone.getCityDisplayName(cityId, 'zh-CN'); // 本地化城市名称
  let timestamp = (new Date()).getTime();
  let item: Item = {
    cityDisplayName: cityDisplayName,
    timezoneId: timezone.getID(),
    offset: 'GMT' + (timezone.getOffset(timestamp) / 3600 * 1000),
    cityId: cityId
  };
  timezoneList.push(item);
}

// 指定地理坐标所在的时区对象数组
let timezoneArray: i18n.TimeZone[] = i18n.TimeZone.getTimezonesByLocation(-43.1, -22.5);

// 获取指定时间的下一个时区跳变点
let tijuanaTzId = 'America/Tijuana';
let tijuanaTimeZone: i18n.TimeZone = i18n.getTimeZone(tijuanaTzId); // 获取蒂华纳时区对象
let zoneRules: i18n.ZoneRules = tijuanaTimeZone.getZoneRules(); // 获取蒂华纳时区的时区跳变规则
let someTime = new Date(2025, 4, 13);
let zoneOffsetTrans: i18n.ZoneOffsetTransition = zoneRules.nextTransition(someTime.getTime());
zoneOffsetTrans.getMilliseconds(); // 跳变点的时间戳: 1762074000000
zoneOffsetTrans.getOffsetAfter(); // 跳变后的偏移量: -28800000
zoneOffsetTrans.getOffsetBefore(); // 跳变前的偏移量: -25200000
// 将跳变点时间格式化
let dateTimeFormat: Intl.DateTimeFormat = new Intl.DateTimeFormat('en-US', {
  timeZone: tijuanaTzId,
  dateStyle: 'long',
  timeStyle: 'long',
  hour12: false
});
let dateFormat =
  dateTimeFormat.format(new Date(zoneOffsetTrans.getMilliseconds())); // November 2, 2025, 1:00:00 PST
// [End get_current_timezone]

// [Start display_dual_timezones]
// 双时钟应用开发实例
let pauloTimezone: i18n.TimeZone = i18n.getTimeZone('America/Sao_Paulo');
let defaultTimezone: i18n.TimeZone = i18n.getTimeZone();
let appPreferredTimeZoneList: i18n.TimeZone[] = []; // 应用偏好时区列表
appPreferredTimeZoneList.push(pauloTimezone);
appPreferredTimeZoneList.push(defaultTimezone);

// [StartExclude display_dual_timezones]
let timeZoneData: string[] = []; // 用于存储每个时区的时间信息
// [EndExclude display_dual_timezones]
let locale: Intl.Locale = i18n.System.getSystemLocaleInstance();
for (let i = 0; i < appPreferredTimeZoneList.length; i++) {
  let timezone = appPreferredTimeZoneList[i].getID();
  let calendar: i18n.Calendar = i18n.getCalendar(locale.toString());
  calendar.setTimeZone(timezone); // 设置日历对象的时区
  // 获取年月日时分秒
  let year = calendar.get('year');
  let month = calendar.get('month');
  let day = calendar.get('date');
  let hour = calendar.get('hour');
  let minute = calendar.get('minute');
  let second = calendar.get('second');
  // [StartExclude display_dual_timezones]
  // 格式化时间信息并存储
  timeZoneData.push(
    `${resourceToString($r('app.string.TimeZone'))} ${timezone}, ` +
      `${resourceToString($r('app.string.Time'))} ${year}-${month}-${day} ${hour}:${minute}:${second}`
  );
  // [EndExclude display_dual_timezones]
}
// [End display_dual_timezones]

/**********************************************************************************************************************
 * 夏令时跳变实现原理
 *********************************************************************************************************************/
// [Start handle_dst_transition]
// 计算夏令时跳变前后同一个挂钟时间之间相差的小时数示例
let calendar: i18n.Calendar = i18n.getCalendar('zh-Hans');
calendar.setTimeZone('Europe/London');
calendar.set(2021, 2, 27, 16, 0, 0); // 夏令时开始前的时间
let startTime = calendar.getTimeInMillis();
calendar.set(2021, 2, 28, 16, 0, 0); // 处于夏令时期间的时间
let finishTime = calendar.getTimeInMillis();
let hours = (finishTime - startTime) / (3600 * 1000); // hours = 23
// [End handle_dst_transition]

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
          Text(assertEqual(timezoneId, expectedAucklandTzId, $r('app.string.GetAucklandID')))
            .textStyle()
          Text(assertEqualFuzzy(timeZoneName, expectedTimeZoneName, $r('app.string.TimeZoneLocalName')))
            .textStyle()
          Text(assertEqual(cityDisplayName, expectedCityDisplayName, $r('app.string.AucklandDisplayName')))
            .textStyle()
          Text(assertEqual(rawOffset, expectedRawOffset, $r('app.string.GetRawOffset')))
            .textStyle()
          Text(assertEqual(offset, expectedOffset, $r('app.string.GetOffset')))
            .textStyle()
          Text(assertEqualLong(availableIDs.join(', '), expectedIds, $r('app.string.GetAvailableIDs')))
            .textStyle()
          Scroll() {
            Text(availableIDs.join(', '))
              .textStyle()
              .id('idsText')
          }
          .scrollStyle('idsScroll')

          Text(assertEqualLong(cityIDs.join(', '), expectedCityIdArray, $r('app.string.GetAvailableZoneCityIDs')))
            .textStyle()
          Scroll() {
            Text(cityIDs.join(', '))
              .textStyle()
              .id('cityIdArrayText')
          }
          .scrollStyle('cityIdArrayScroll')

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
