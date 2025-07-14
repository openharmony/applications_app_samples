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
import { assertEqual } from '../component/AssertEqual';
import { resourceToString } from '../component/ResourceToString';
// [Start import_module]
import { i18n } from '@kit.LocalizationKit';
// [End import_module]

// [Start check_and_set_date]
// 设置日历和历法开发实例
// 公历相关用法
let calendar: i18n.Calendar = i18n.getCalendar('zh-Hans', 'gregory');

// 设置日历对象的日期
calendar.setTime(new Date(2022, 5, 13, 8, 0, 0));
calendar.setTime(10540800000);

// 设置日历对象的年、月、日、时、分、秒
calendar.set(2022, 5, 13, 8, 0, 0);

// 设置日历对象的时区
calendar.setTimeZone('Asia/Shanghai');

// 获取日历对象的时区
let timezone: string = calendar.getTimeZone(); // Asia/Shanghai

// 获取日历对象的一周起始日
let firstDayOfWeek: number = calendar.getFirstDayOfWeek(); // 1

// 设置每一周的起始日
calendar.setFirstDayOfWeek(1);

// 获取一年中第一周的最小天数
let minimalDaysInFirstWeek: number = calendar.getMinimalDaysInFirstWeek(); // 1

// 设置一年中第一周的最小天数
calendar.setMinimalDaysInFirstWeek(3);

// 获取日历对象中与field相关联的值
let value: number = calendar.get('year'); // 2022

// 获取日历对象本地化名称
let calendarName: string = calendar.getDisplayName('zh-Hans'); // 公历

// 判断指定的日期在日历中是否为周末
let isWeekend: boolean = calendar.isWeekend(new Date(2023, 9, 15)); // true

// 在日历的给定字段进行加减操作
calendar.set(2023, 10, 15);
calendar.add('date', 2);
let day: number = calendar.get('date'); // day = 17

// 比较日历和指定日期相差的天数
let daysDifference: number = calendar.compareDays(new Date(2023, 10, 15)); // daysDifference = -3
let calendarChinese: i18n.Calendar = i18n.getCalendar('zh-Hans', 'chinese');
// 将公历日期设置到calendar对象，时间日期为2023.07.25 08:00:00
calendarChinese.setTime(new Date(2023, 6, 25, 8, 0, 0));
// [End check_and_set_date]

// [Start get_lunar_date]
// 获取农历年月日
let yearChinese: number = calendarChinese.get('year'); // year = 40，指干支纪年40，范围1-60
let monthChinese: number = calendarChinese.get('month'); // month = 5，指6月
let dayChinese: number = calendarChinese.get('date'); // day = 8，指8日
// [End get_lunar_date]

const expectedTimezone = 'Asia/Shanghai';
const expectedFirstDayOfWeek = 1;
const expectedMinimalDaysInFirstWeek = 1;
const expectedValue = 2022;
const expectedCalendarName = resourceToString($r('app.string.Calendar'));
const expectedIsWeekend = true;
const expectedDateAddTwoDays = 17;
const expectedCompareDays = -3;
const expectedCalendarYear = 40;
const expectedCalendarMonth = 5;
const expectedCalendarDate = 8;

@Extend(Text)
function textStyle() {
  .fontSize(20)
  .margin({ top: 15, left: 20, right: 20 });
}

@Entry
@Component
struct CalendarSetting {
  build() {
    Column() {
      TitleBar({ hasBackPress: true, title: $r('app.string.CalendarSetting') })
      Text($r('app.string.ResultsOfTheGregorianCalendar'))
        .textStyle()
        .fontWeight(FontWeight.Bold)
      Text($r('app.string.TheGregorianCalendarSets'))
        .textStyle()
      Text(assertEqual(timezone, expectedTimezone, $r('app.string.Timezone')))
        .textStyle()
      Text(assertEqual(firstDayOfWeek, expectedFirstDayOfWeek, $r('app.string.FirstDayOfWeek')))
        .textStyle()
      Text(assertEqual(minimalDaysInFirstWeek, expectedMinimalDaysInFirstWeek, $r('app.string.MinimalDaysInFirstWeek')))
        .textStyle()
      Text($r('app.string.SetMinimalDaysInFirstWeek'))
        .textStyle()
        .fontWeight(FontWeight.Bold)
      Text(assertEqual(value, expectedValue, $r('app.string.YearOfTheFirstWeekIs3')))
        .textStyle()
      Text(assertEqual(calendarName, expectedCalendarName, $r('app.string.LocalizedCalendarName')))
        .textStyle()
      Text(assertEqual(isWeekend, expectedIsWeekend, $r('app.string.IsWeekend')))
        .textStyle()
      Text(assertEqual(day, expectedDateAddTwoDays, $r('app.string.DateAfterAddingDays')))
        .textStyle()
      Text(assertEqual(daysDifference, expectedCompareDays,
        $r('app.string.DaysBetweenDates')))
        .textStyle()
      Text($r('app.string.LunarCalendar'))
        .textStyle().fontWeight(FontWeight.Bold)
      Text(assertEqual(yearChinese, expectedCalendarYear, $r('app.string.LunarYear')))
        .textStyle()
      Text(assertEqual(monthChinese, expectedCalendarMonth, $r('app.string.LunarMonth')))
        .textStyle()
      Text(assertEqual(dayChinese, expectedCalendarDate, $r('app.string.LunarDate')))
        .textStyle()
    }.width('100%').height('100%').alignItems(HorizontalAlign.Start)
  }
}