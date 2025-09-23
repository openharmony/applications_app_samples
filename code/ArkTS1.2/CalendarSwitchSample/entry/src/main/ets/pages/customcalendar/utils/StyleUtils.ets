'use static';
/**
 *
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 *
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice,this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS,
 *
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import Constants from '../constant/Constants';
import { CalendarViewType, DayInfo } from '../components/CustomCalendar';
import { Day, CalendarStyle } from '../model/CalendarModel';
import { Resource, Color } from '@ohos.arkui.component';
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
   * @param CalendarStyle 自定义日历样式
   * @returns 返回颜色
   */
  static getColor(day: Day, month: number, currentSelectDay: DayInfo, calendarViewType: CalendarViewType,
    calendarStyle: CalendarStyle): Color | number | string | Resource | undefined {
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
   * 获取日期背景色（仅用于月视图和周视图）
   * @param day 日期信息
   * @param currentSelectDay 当前选择的日期
   * @param CalendarStyle 自定义日历样式
   * @returns 返回颜色
   */
  static getBackgroundColor(day: Day, currentSelectDay: DayInfo,
    calendarStyle: CalendarStyle): Color | number | string | Resource | undefined {
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