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
import { CalendarViewType, DayInfo } from '../components/CustomCalendar';
import { Day, CalendarStyle } from '../model/CalendarModel';

/**
 * 样式工具类
 */
export class StyleUtils {
  /**
   * 获取公历日期字体颜色（仅用于月视图和周视图）
   * @param day 日期信息
   * @param month 月份
   * @param currentSelectDay 当前选择的日期
   * @param calendarViewType 日历视图类型
   * @param calendarStyle 自定义日历样式
   * @returns 返回颜色
   */
  static getColor(day: Day, month: number, currentSelectDay: DayInfo, calendarViewType: CalendarViewType,
    calendarStyle: CalendarStyle): Color | number | string | Resource {
    const IS_SELECT_DAY: boolean =
      currentSelectDay.year === day.dayInfo.year && currentSelectDay.month === day.dayInfo.month &&
        currentSelectDay.date === day.dayInfo.date;
    const IS_TODAY: boolean =
      day.dayInfo.year === Constants.TODAY_YEAR && day.dayInfo.month === Constants.TODAY_MONTH &&
        day.dayInfo.date === Constants.TODAY;
    const IS_CURRENT_MONTH: boolean = (month === day.dayInfo.month);
    if (!IS_CURRENT_MONTH && (calendarViewType === CalendarViewType.MONTH)) {
      return calendarStyle.noMonthDayColor ? calendarStyle.noMonthDayColor : Color.Gray;
    } else if (IS_SELECT_DAY && IS_TODAY) {
      return Color.White;
    } else if (!IS_SELECT_DAY && IS_TODAY) {
      return Color.Red;
    } else {
      return calendarStyle.monthDayColor ? calendarStyle.monthDayColor : Color.Black;
    }
  }

  /**
   * 获取日期农历字体颜色（仅用于月视图和周视图）
   * @param day 日期信息
   * @param month 月
   * @param currentSelectDay 当前选择的日期
   * @param calendarViewType 日历视图类型
   * @param calendarStyle 自定义日历样式
   * @returns 返回颜色
   */
  static getLunarDayColor(day: Day, month: number, currentSelectDay: DayInfo, calendarViewType: CalendarViewType,
    calendarStyle: CalendarStyle): Color | number | string | Resource {
    const IS_SELECT_DAY: boolean =
      currentSelectDay.year === day.dayInfo.year && currentSelectDay.month === day.dayInfo.month &&
        currentSelectDay.date === day.dayInfo.date;
    const IS_TODAY: boolean =
      day.dayInfo.year === Constants.TODAY_YEAR && day.dayInfo.month === Constants.TODAY_MONTH &&
        day.dayInfo.date === Constants.TODAY;
    const IS_CURRENT_MONTH: boolean = (month === day.dayInfo.month);
    if (!IS_CURRENT_MONTH && (calendarViewType === CalendarViewType.MONTH)) {
      return Color.Gray;
    } else if (IS_SELECT_DAY && IS_TODAY) {
      return Color.White;
    } else if (!IS_SELECT_DAY && IS_TODAY) {
      return Color.Red;
    } else {
      return calendarStyle.lunarColor ? calendarStyle.lunarColor : Color.Gray;
    }
  }

  /**
   * 获取日期背景色（仅用于月视图和周视图）
   * @param day 日期信息
   * @param currentSelectDay 当前选择的日期
   * @param calendarStyle 自定义日历样式
   * @returns 返回颜色
   */
  static getBackgroundColor(day: Day, currentSelectDay: DayInfo,
    calendarStyle: CalendarStyle): Color | number | string | Resource {
    const IS_SELECT_DAY: boolean =
      currentSelectDay.year === day.dayInfo.year && currentSelectDay.month === day.dayInfo.month &&
        currentSelectDay.date === day.dayInfo.date;
    const IS_TODAY: boolean =
      day.dayInfo.year === Constants.TODAY_YEAR && day.dayInfo.month === Constants.TODAY_MONTH &&
        day.dayInfo.date === Constants.TODAY;
    if (IS_TODAY && IS_SELECT_DAY) {
      return calendarStyle.backgroundColor ? calendarStyle.backgroundColor : Color.Red;
    } else {
      return Color.Transparent;
    }
  }

  /**
   * 获取日期选中框宽度（仅用于月视图和周视图）
   * @param day 日期信息
   * @param month 月
   * @param currentSelectDay 当前选择的日期
   * @param calendarViewType 日历视图类型
   * @returns 返回颜色
   */
  static getBorderWidth(day: Day, month: number, currentSelectDay: DayInfo,
    calendarViewType: CalendarViewType): number {
    const IS_SELECT_DAY: boolean =
      currentSelectDay.year === day.dayInfo.year && currentSelectDay.month === day.dayInfo.month &&
        currentSelectDay.date === day.dayInfo.date;
    const IS_TODAY: boolean =
      day.dayInfo.year === Constants.TODAY_YEAR && day.dayInfo.month === Constants.TODAY_MONTH &&
        day.dayInfo.date === Constants.TODAY;
    // 判断是否为选定日期且非今天
    const IS_SELECTED_AND_NOT_TODAY = !IS_TODAY && IS_SELECT_DAY;
    switch (calendarViewType) {
      case CalendarViewType.MONTH:
        // 如果处于月视图，并且日期是选定且非今天，且月份匹配
        if (IS_SELECTED_AND_NOT_TODAY && day.dayInfo.month === month) {
          return Constants.SELECT_DATE_BORDER_WIDTH;
        }
        break;
      case CalendarViewType.WEEK:
        // 如果处于周视图，并且日期是选定且非今天
        if (IS_SELECTED_AND_NOT_TODAY) {
          return Constants.SELECT_DATE_BORDER_WIDTH;
        }
        break;
      default:
        break;
    }
    // 如果不满足上述任何条件，返回默认值
    return Constants.DEFAULT;
  }
}