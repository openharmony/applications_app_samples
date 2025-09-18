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
import { CalendarStyle, Day } from '../model/CalendarModel';
import { StyleUtils } from '../utils/StyleUtils';
import { TimeUtils } from '../utils/TimeUtils'; // 时间计算工具类
import {
  $r,
  Builder,
  ClickEvent,
  Color,
  Column,
  Component,
  FlexAlign,
  FontWeight,
  ForEach,
  HorizontalAlign,
  Margin,
  Padding,
  Row,
  Text,
  TextAlign
} from '@ohos.arkui.component';
import { Link, State, Watch } from '@ohos.arkui.stateManagement';

/**
 * 月视图子组件
 */
@Component
export struct MonthViewItem {
  // 月视图日期数据
  @State monthDays: Day[][] = new Array<Array<Day>>();
  // 年月信息
  @Link @Watch('updateMonthData') yearMonth: string;
  // 当前选中的日期
  @State currentSelectDay: DayInfo =
    new DayInfo(new Date().getFullYear(), new Date().getMonth() + 1, new Date().getDate(), 0); // 当前选中的日期
  // 当前选中的日期，格式'year-month-date-week'
  @Link @Watch('OnChangeSelectDate') currentSelectDate: string;
  private year: number = Constants.TODAY_YEAR;
  private month: number = Constants.TODAY_MONTH;
  // 自定义日历样式
  calendarStyle: CalendarStyle = {} as CalendarStyle;
  // 日期点击回调
  onDateClick: (year: number, month: number, date: number) => void = () => {
  };

  /**
   * 日期选择监听
   */
  OnChangeSelectDate(param: string) {
    const PARTS: string[] = this.currentSelectDate.split('-');
    this.currentSelectDay.year = Number(PARTS[0]);
    this.currentSelectDay.month = Number(PARTS[1]);
    this.currentSelectDay.date = Number(PARTS[2]);
  }

  /**
   * 获取指定月份数据
   */
  getMonthViewData(year: number, month: number) {
    this.monthDays = [...TimeUtils.byMonthDayForYear(year, month)];
  }

  /**
   * 更新月数据
   */
  updateMonthData(param:string) {
    const PARTS: string[] = this.yearMonth.split('-');
    this.year = Number(PARTS[0]);
    this.month = Number(PARTS[1]);
    this.getMonthViewData(this.year, this.month);
  }

  aboutToAppear() {
    const PARTS: string[] = this.yearMonth.split('-');
    this.year = Number(PARTS[0]);
    this.month = Number(PARTS[1]);
    this.getMonthViewData(this.year, this.month);
  }

  /**
   * 月视图点击上个月或下个月日期切换月份
   * @param is true为下月，false为上一月
   */
  nextMouth(is: boolean) {
    if (is) {
      this.year =
        (this.month + 1 > 12) ? this.year + 1 : this.year;
      this.month = (this.month + 1 > 12) ? 1 : this.month + 1;
    } else {
      this.year =
        (this.month - 1 < 1) ? this.year - 1 : this.year;
      this.month = (this.month - 1 < 1) ? 12 : this.month - 1;
    }
    this.yearMonth = this.year + '-' + this.month;
  }

  /**
   * 月视图一天的子组件
   * @param day 日期
   * @param week 月视图周信息。0上个月，1当前月，2下个月
   */
  @Builder
  monthDayBuilder(day: Day, week: number) {
    Column() {
      Text(day.dayNum + '')
        .fontColor(StyleUtils.getColor(day, this.month, this.currentSelectDay, CalendarViewType.MONTH,
          this.calendarStyle))
        .fontSize(13)
        .fontWeight(FontWeight.Medium)
    }
    .width(40)
    .height(40)
    .borderRadius(40)
    .borderColor($r('app.color.calendar_switch_border_color'))
    .borderWidth(StyleUtils.getBorderWidth(day, this.month, this.currentSelectDay, CalendarViewType.MONTH))
    .backgroundColor(StyleUtils.getBackgroundColor(day, this.currentSelectDay, this.calendarStyle))
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .onClick((e: ClickEvent) => {
      this.onDateClick(day.dayInfo.year, day.dayInfo.month, day.dayInfo.date);
      // 月视图需要拼接day.dayInfo.week
      this.currentSelectDate =
        day.dayInfo.year + '-' + day.dayInfo.month + '-' + day.dayInfo.date + '-' + day.dayInfo.week;
      this.currentSelectDay.year = day.dayInfo.year;
      this.currentSelectDay.month = day.dayInfo.month;
      this.currentSelectDay.date = day.dayInfo.date;
      // 必须记录点击日期的week值。CalendarSwitch的onSelectDayChange监听中需要根据week值点击的是上个月还是下个月的日期，从而进行相应的月份切换
      this.currentSelectDay.week = day.dayInfo.week;
      // 选中了上个月的日期，切换到上个月。1表示月视图第一周
      if (week == 1 && day.dayNum > Constants.DAYS_IN_WEEK) {
        this.nextMouth(false);
      }
      // 选中了下个月的日期，切换到下个月。2表示月视图第二周
      if (week > 2 && day.dayNum < Constants.DAYS_IN_WEEK) {
        this.nextMouth(true);
      }
    })
  }

  build() {
    Column() {
      ForEach(this.monthDays, (items: Day[], index: number) => {
        Row() {
          ForEach(items, (item: Day) => {
            Column() {
              this.monthDayBuilder(item, index + 1)
            }
            .height(46)
          })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      })
    }.width('100%')
  }
}