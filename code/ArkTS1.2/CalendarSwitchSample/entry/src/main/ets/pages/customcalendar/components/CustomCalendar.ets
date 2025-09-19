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

import { CalendarStyle, CalendarSwitch } from '../model/CalendarModel';
import { YearView } from '../view/YearView';
import { MonthView } from '../view/MonthView';
import { WeekView } from '../view/WeekView';
import CommonData from '../common/CommonData';
import { TimeUtils } from '../utils/TimeUtils';
import { BusinessError } from '@ohos.base';
import common from '@ohos.app.ability.common';

import {
  Text,
  TextAttribute,
  Column,
  Component,
  Button,
  ButtonAttribute,
  ClickEvent,
} from '@ohos.arkui.component';
import {
  State,
  Observed,
  MutableState,
  PropRef
} from '@ohos.arkui.stateManagement';

/**
 * 自定义日历组件CustomCalendar（年视图，月视图，周视图）
 *
 * 功能描述：
 * 提供可左右滑动切换年、月、周的年视图，月视图，周视图。
 *
 * 基本用法：
 * CustomCalendar() // 不传参默认显示月视图
 * CustomCalendar({ CalendarViewType: CalendarViewType.YEAR }) // 年视图
 * CustomCalendar({ CalendarViewType: CalendarViewType.MONTH }) // 月视图
 * CustomCalendar({ CalendarViewType: CalendarViewType.WEEK }) // 周视图
 */
@Component
export struct CustomCalendar {
  // 自定义日历类型
  @PropRef calendarViewType: CalendarViewType = CalendarViewType.MONTH;
  // 自定义日历样式
  calendarStyle: CalendarStyle = {} as CalendarStyle;
  // 年、月、周视图切换场景的相关设置
  calendarSwitch: CalendarSwitch = { isYearMonthHidden: false } as CalendarSwitch;
  // 年视图月份点击回调。返回年视图点击的年月信息。仅用于年视图。
  onMonthClick: (year: number, month: number) => void = () => {
  };
  // 日期点击回调。返回点击日期的年月日信息。仅用于月、周视图。
  onDateClick: (year: number, month: number, date: number) => void = () => {
  };
  // 年、月、周视图左右滑动切换回调。返回左右切换年、月、周后的年月信息，其中年视图切换实际只返回切换后年份信息。
  onChangeYearMonth: (year: number, month: number) => void = () => {
  };

  aboutToAppear() {

  }

  build() {
    if (this.calendarViewType === CalendarViewType.YEAR) {
      YearView({
        onMonthClick: (year: number, month: number) => {
          this.onMonthClick(year, month);
        },
        onChangeYearMonth: (year: number, month: number) => {
          this.onChangeYearMonth(year, month);
        },
        calendarSwitch: {
          currentSelectDay: this.calendarSwitch.currentSelectDay,
          isYearMonthHidden: this.calendarSwitch.isYearMonthHidden
        },
      })
    } else if (this.calendarViewType === CalendarViewType.MONTH) {
      MonthView({
        calendarStyle: {
          backgroundColor: this.calendarStyle.backgroundColor,
          monthDayColor: this.calendarStyle.monthDayColor,
          noMonthDayColor: this.calendarStyle.noMonthDayColor,
        },
        onDateClick: (year: number, month: number, date: number) => {
          this.onDateClick(year, month, date);
        },
        onChangeYearMonth: (year: number, month: number) => {
          this.onChangeYearMonth(year, month);
        },
        calendarSwitch: {
          currentSelectDay: this.calendarSwitch.currentSelectDay,
          isYearMonthHidden: this.calendarSwitch.isYearMonthHidden
        }
      })
    } else if (this.calendarViewType === CalendarViewType.WEEK) {
      WeekView({
        calendarStyle: {
          backgroundColor: this.calendarStyle.backgroundColor,
          monthDayColor: this.calendarStyle.monthDayColor
        },
        onDateClick: (year: number, month: number, date: number) => {
          this.onDateClick(year, month, date);
        },
        onChangeYearMonth: (year: number, month: number) => {
          this.onChangeYearMonth(year, month);
        },
        calendarSwitch: {
          currentSelectDay: this.calendarSwitch.currentSelectDay,
          isYearMonthHidden: this.calendarSwitch.isYearMonthHidden
        }
      })
    }
  }
}

/**
 * 一天的信息
 */
@Observed
export class DayInfo {
  public year: number; // 年
  public month: number; // 月
  public date: number; // 日
  public week: number; // 月视图周信息。月视图上点击上个月日期进行月份切换时需要用到

  constructor(year: number, month: number, date: number, week: number) {
    this.year = year;
    this.month = month;
    this.date = date;
    this.week = week;
  }
}

/**
 * 自定义日历类型：YEAR年视图 MONTH月视图 WEEK周视图
 */
export enum CalendarViewType {
  YEAR, // 年视图
  MONTH, // 月视图
  WEEK, // 周视图
}