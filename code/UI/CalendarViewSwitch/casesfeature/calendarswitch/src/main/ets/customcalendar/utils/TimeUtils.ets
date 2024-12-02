/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import Constants from '../constant/Constants';
import { Day, CalendarData } from '../model/CalendarModel';
import { i18n } from '@kit.LocalizationKit'; // 提供系统相关的或者增强的国际化能力。本例使用日历相关能力
import { DayInfo } from '../components/CustomCalendar';
import CommonData from '../common/CommonData';

/**
 * 日期计算工具类
 */
export class TimeUtils {
  /**
   * 确定给的日期是星期几
   * @param year 年
   * @param month 月
   * @param day 日
   * @returns 周几
   */
  static getWeekDay(year: number, month: number, day: number): number {
    const DATE = new Date(year, month - 1, day);
    return DATE.getDay();
  }

  /**
   * 给定年份和月份的最后一天是几号
   * @param year 年
   * @param month 月
   * @returns
   */
  static getLastDayOfMonth(year: number, month: number): number {
    return new Date(year, month, 0).getDate();
  }

  /**
   * 用于获取前一个月的最后几天
   * @param year 年
   * @param month 月
   * @param firstDayOfWeek 当前月份的第一天是周几
   * @returns
   */
  static getPreviousMonthLastDays(year: number, month: number, firstDayOfWeek: number): number[] {
    const DAYS: number[] = [];
    const LAST_DAY_OF_PREVIOUS_MONTH = TimeUtils.getLastDayOfMonth(year, month - 1);
    for (let i = LAST_DAY_OF_PREVIOUS_MONTH - firstDayOfWeek + 1; i <= LAST_DAY_OF_PREVIOUS_MONTH; i++) {
      DAYS.push(i);
    }
    return DAYS;
  }

  /**
   * 用于生成当前月份的所有天数的数组
   * @param year 年
   * @param month 月
   * @returns 返回所有天数
   */
  static getCurrentMonthDays(year: number, month: number): number[] {
    const DAYS: number[] = [];
    const LAST_DAY_OF_MONTH = TimeUtils.getLastDayOfMonth(year, month);
    for (let i = 1; i <= LAST_DAY_OF_MONTH; i++) {
      DAYS.push(i);
    }
    return DAYS;
  }

  /**
   * 返回农历月份的中文表示
   * @param month 农历月
   * @returns
   */
  static lunarMonthToChinese(month: number): string {
    // 检查是否是闰月
    const IS_LEAP_MONTH = month < 0;
    const LUNAR_MONTH = IS_LEAP_MONTH ? -month : month;
    // 转换月份
    const CHINSES_MONTH_STR = `${Constants.CHINESE_MONTH[LUNAR_MONTH - 1]}月`;
    // 如果是闰月，加上“闰”字
    return IS_LEAP_MONTH ? `闰${CHINSES_MONTH_STR}` : CHINSES_MONTH_STR;
  }

  /**
   * 返回农历日期的中文表示
   * @param day 农历日
   * @returns
   */
  static lunarDayToChinese(day: number): string {
    // 转换日期
    return Constants.CHINESE_DAY[day - 1];
  }

  /**
   * 获取某年某月的所有日期
   * @param year
   * @param month
   * @returns
   */
  static byMonthDayForYear(year: number, month: number): Day[][] {
    const FIRST_DAY_OF_WEEK = TimeUtils.getWeekDay(year, month, 1);
    const PREVIOUS_MONTH_DAYS = TimeUtils.getPreviousMonthLastDays(year, month, FIRST_DAY_OF_WEEK);
    const CURRENT_MONTH_DAYS = TimeUtils.getCurrentMonthDays(year, month);
    const CALENDAR: Day[][] = [];
    let week: Day[] = [];
    let i18nCalendar: i18n.Calendar = i18n.getCalendar('zh-Hans', 'chinese');
    // 用上个月的天数填充第一周
    for (let i = 0; i < FIRST_DAY_OF_WEEK; i++) {
      i18nCalendar.setTime(new Date(year, month - 2, PREVIOUS_MONTH_DAYS[i]))
      week.push({
        dayNum: PREVIOUS_MONTH_DAYS[i],
        lunarDay: TimeUtils.lunarDayToChinese(i18nCalendar.get('date')),
        dayInfo: new DayInfo((month - 1 < 1) ? year - 1 : year, (month - 1 < 1) ? 12 : month - 1,
          PREVIOUS_MONTH_DAYS[i], 0),
        isShowSchedulePoint: CommonData.SCHEDULE_ARRAY.includes(((month - 1 < 1) ? year - 1 : year) + '/' +
          ((month - 1 < 1) ? 12 : month - 1) + '/' + PREVIOUS_MONTH_DAYS[i]) ? true : false
      });
    }

    // 用当月的天数填充剩余的周数
    for (const day of CURRENT_MONTH_DAYS) {
      i18nCalendar.setTime(new Date(year, month - 1, day))
      week.push({
        dayNum: day,
        lunarDay: i18nCalendar.get('date') === 1 ? TimeUtils.lunarMonthToChinese(i18nCalendar.get('month') + 1) :
        TimeUtils.lunarDayToChinese(i18nCalendar.get('date')),
        dayInfo: new DayInfo(year, month, day, 1),
        isShowSchedulePoint: CommonData.SCHEDULE_ARRAY.includes(year + '/' + month + '/' + day) ? true : false
      });
      if (week.length === Constants.DAYS_IN_WEEK) {
        CALENDAR.push(week);
        week = [];
      }
    }

    // 用下个月的日子填满最后一周
    if (week.length > 0) {
      // week.length表示当月最后一周中的当月天数。用7-week.length计算得到的x表示在下个月第一周中的下个月天数
      let x = (Constants.DAYS_IN_WEEK - week.length)
      for (let index = 1; index <= x; index++) {
        i18nCalendar.setTime(new Date(year, month, index))
        week.push({
          dayNum: index,
          lunarDay: index === 0 ? TimeUtils.lunarMonthToChinese(i18nCalendar.get('month') + 1) :
          TimeUtils.lunarDayToChinese(i18nCalendar.get('date')),
          dayInfo: new DayInfo((month + 1 > 12) ? year + 1 : year, (month + 1 > 12) ? 1 : month + 1, index, 2),
          isShowSchedulePoint: CommonData.SCHEDULE_ARRAY.includes(((month + 1 > 12) ? year + 1 : year) + '/' +
            ((month + 1 > 12) ? 1 : month + 1) + '/' + index) ? true : false
        })
      }
      CALENDAR.push(week);
    }
    return CALENDAR;
  }

  /**
   * 获取某周的所有日期
   * @param weekNum 距离本周的周数。本周用0表示，负数表示过去周，正数表示未来周，以此类推。
   * @returns 返回某周的所有日期
   */
  static getWeekDays(weekNum: number): Day[][] {
    // 获取当前日期
    const CURRENT_DATE = new Date();
    // 获取当前日期是本周的周几（0-6，其中0代表周日，1代表周一，以此类推）
    const WEEK_DAY = CURRENT_DATE.getDay();
    // 计算并设置目标周的第一天(周日)的日期
    const BEGIN_DATE = new Date(CURRENT_DATE.getTime() - WEEK_DAY * Constants.TOTAL_MILLISECONDS_IN_DAY +
      (Constants.DAYS_IN_WEEK * weekNum) * Constants.TOTAL_MILLISECONDS_IN_DAY);
    let days: CalendarData[] = [];
    let week: Day[] = [];
    const CALENDAR: Day[][] = [];
    let i18nCalendar: i18n.Calendar = i18n.getCalendar('zh-Hans', 'chinese');
    for (let i = 0; i < Constants.DAYS_IN_WEEK; i++) {
      const DAY = new Date(BEGIN_DATE.getTime() + i * Constants.TOTAL_MILLISECONDS_IN_DAY);
      days[i] = {
        year: DAY.getFullYear(),
        month: DAY.getMonth() + 1,
        date: DAY.getDate()
      };
      // 设置日历对象内部的时间日期
      i18nCalendar.setTime(new Date(days[i].year, days[i].month - 1, days[i].date))
      week.push({
        dayNum: days[i].date,
        lunarDay: i18nCalendar.get('date') === 1 ? TimeUtils.lunarMonthToChinese(i18nCalendar.get('month') + 1) :
        TimeUtils.lunarDayToChinese(i18nCalendar.get('date')),
        dayInfo: new DayInfo(days[i].year, days[i].month, days[i].date, 0),
        isShowSchedulePoint: CommonData.SCHEDULE_ARRAY.includes(days[i].year + '/' + days[i].month + '/' +
        days[i].date) ? true : false
      })
    }
    CALENDAR.push(week);
    return CALENDAR;
  }

  /**
   * 用于获取给定日期所在周的第一天（上周日）
   * @param date 给定日期
   * @returns 返回给定日期所在周的第一天
   */
  static getLastSunday(date: Date): Date {
    // 获取当前日期是本周的周几（0-6，其中0代表周日，1代表周一，以此类推）
    const DAY_OF_WEEK = date.getDay();
    // 创建一个新的Date对象，其值与传入的date相同，用于后续计算而不改变原始date对象
    const LAST_SUNDAY = new Date(date);
    // 这里假设周日是一周的第一天，因此直接减去dayOfWeek就能得到本周的周日
    LAST_SUNDAY.setDate(LAST_SUNDAY.getDate() - DAY_OF_WEEK);
    // 返回计算后的日期，即本周的周日
    return LAST_SUNDAY;
  }

  /**
   * 获取每个月的天数
   * @param year 年
   * @param month 月
   * @returns 返回对应天数
   */
  static getMonthDays(year: number, month: number): number {
    switch (month) {
      case 1:
      case 3:
      case 5:
      case 7:
      case 8:
      case 10:
      case 12:
        // 1月、3月、5月、7月、8月、10月和12月各有31天。
        return 31;
      case 4:
      case 6:
      case 9:
      case 11:
        // 4月、6月、9月和11月各有30天。
        return 30;
      case 2:
        // 如果年份能被4整除但不能被100整除，或者能被400整除，则是闰年29天
        if ((year % 4 === 0 && year % 100 !== 0) || (year % 400 === 0)) {
          return 29;
        } else {
          return 28;
        }
      default:
        return 0;
    }
  }

  /**
   * 判断是否农历初一
   * @param year 年
   * @param month 月
   * @param day 日
   * @returns 返回是否农历初一
   */
  static isLunarFirstDayOfMonth(year: number, month: number, day: number): boolean {
    let i18nCalendar: i18n.Calendar = i18n.getCalendar('zh-Hans', 'chinese');
    i18nCalendar.setTime(new Date(year, month - 1, day));
    return i18nCalendar.get('date') === 1 ? true : false;
  }

  /**
   * 获取上个月的年份和月份
   * @param year 年
   * @param month 月
   * @returns 返回上个月的年份和月份
   */
  static getLastYearMonth(year: number, month: number): string {
    year = (month - 1 < 1) ? year - 1 : year;
    month = (month - 1 < 1) ? 12 : month - 1;
    return year + '-' + month;
  }

  /**
   * 获取下个月的年份和月份
   * @param year 年
   * @param month 月
   * @returns 返回下个月的年份和月份
   */
  static getNextYearMonth(year: number, month: number): string {
    year = (month + 1 > 12) ? year + 1 : year;
    month = (month + 1 > 12) ? 1 : month + 1;
    return year + '-' + month;
  }

  /**
   * 获取上个月的年份
   * @param year 年
   * @param month 月
   * @returns
   */
  static getLastYear(year: number, month: number): number {
    return (month - 1 < 1) ? year - 1 : year;
  }

  /**
   * 获取上个月的月份
   * @param year 年
   * @param month 月
   * @returns 返回上个月的月份
   */
  static getLastMonth(year: number, month: number): number {
    return (month - 1 < 1) ? 12 : month - 1;
  }

  /**
   * 获取下个月的年份
   * @param year 年
   * @param month 月
   * @returns 下个月的年份
   */
  static getNextYear(year: number, month: number): number {
    return (month + 1 > 12) ? year + 1 : year;
  }

  /**
   * 获取下个月的月份
   * @param year 年
   * @param month 月
   * @returns 返回下个月的月份
   */
  static getNextMonth(year: number, month: number): number {
    return (month + 1 > 12) ? 1 : month + 1;
  }

  /**
   * 计算某个日期距离今天相差的周数，过去周用负数表示，未来周用正数表示
   * @param selectDay 日期
   * @returns 返回某个日期距离今天相差的周数
   */
  static weeksBetweenDates(selectDay: Date): number {
    const TODAY = new Date();
    // 周视图中选中日期所属周的第一天（周日）
    let selectLastSunday: Date = TimeUtils.getLastSunday(selectDay);
    // 周视图中今天所属周的第一天（周日）
    let todayLastSunday: Date = TimeUtils.getLastSunday(TODAY);
    // 计算两个日期之间的毫秒差
    const DIFF = todayLastSunday.getTime() - selectLastSunday.getTime();
    // 将毫秒差转换为天数
    const DIFF_DAYS = DIFF / Constants.TOTAL_MILLISECONDS_IN_DAY;
    // 将天数差转换为周数，向下取整得到完整的周数
    const DIFF_WEEKS = Math.floor(DIFF_DAYS / Constants.DAYS_IN_WEEK);
    return -DIFF_WEEKS;
  }

  /**
   * 开始时间和结束时间涉及多日时，支持在月视图和周视图中显示添加的多日日程点
   * @param startDate 开始时间
   * @param endDate 结束时间
   */
  static addSchedule(startDate: Date, endDate: Date) {
    // 当前日期设置为开始日期
    let currentDateTime = new Date(startDate);
    let endDateTime = new Date(endDate);
    // 使用 while 循环遍历日期范围
    while (currentDateTime <= endDateTime) {
      // 只保留日期部分，格式化为 yyyy/MM/dd
      let scheduleTime =
        currentDateTime.toLocaleDateString('zh-CN', { year: 'numeric', month: '2-digit', day: '2-digit' })
          .replace(/\//g, '/');
      // 将生成的字符串中的月份和日期部分的零去掉（如果有的话）
      let parts = scheduleTime.split('/');
      // 去掉日期前的零（如果有的话）
      let formattedMonth = parts[1].replace(/^0/, '');
      let formattedDay = parts[2].replace(/^0/, '');
      scheduleTime = `${parts[0]}/${formattedMonth}/${formattedDay}`;
      // 将当前日期加一天
      currentDateTime.setDate(currentDateTime.getDate() + 1);
      if (!CommonData.SCHEDULE_ARRAY.includes(scheduleTime)) {
        CommonData.SCHEDULE_ARRAY.push(scheduleTime);
      }
    }
  }
}