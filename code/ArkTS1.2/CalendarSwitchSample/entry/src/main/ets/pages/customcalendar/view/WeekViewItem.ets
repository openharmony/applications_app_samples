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
import { CalendarData, CalendarStyle, Day } from '../model/CalendarModel';
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
import { Link, State, Watch, PropRef } from '@ohos.arkui.stateManagement';
/**
 * 周视图子组件
 */
@Component
export struct WeekViewItem {
  // 周视图日期数据
  @State @Watch('getFirstDayData') weekDays: Day[][] = Array<Array<Day>>();
  // 当前选中的日期
  @State currentSelectDay: DayInfo =
    new DayInfo(new Date().getFullYear(), new Date().getMonth() + 1, new Date().getDate(), 0); // 当前选中的日期
  // 当前选中的日期，格式'year-month-date'
  @Link @Watch('OnChangeSelectDate') currentSelectDate: string;
  // 表示周视图第几周
  @PropRef @Watch('updateWeekData') weekNum: number;
  private month: number = Constants.TODAY_MONTH;
  // 自定义日历样式
  calendarStyle: CalendarStyle = {} as CalendarStyle;
  // 周视图数据切换回调，返回一周中第一天的数据
  onWeekSwitch: (item: CalendarData) => void = () => {
  };
  // 日期点击回调
  onDateClick: (year: number, month: number, date: number) => void = () => {
  };

  /**
   * 日期选择监听
   */
  OnChangeSelectDate(param:string) {
    const PARTS: string[] = this.currentSelectDate.split('-');
    this.currentSelectDay.year = Number(PARTS[0]);
    this.currentSelectDay.month = Number(PARTS[1]);
    this.currentSelectDay.date = Number(PARTS[2]);
  }

  /**
   * 周视图切换时，将当前周数据的第一天（周日）日期数据传出去
   */
  getFirstDayData(param:string) {
    if (this.weekDays && this.weekDays[0][0].dayInfo) {
      this.onWeekSwitch({
        date: this.weekDays[0][0].dayInfo.date,
        month: this.weekDays[0][0].dayInfo.month,
        year: this.weekDays[0][0].dayInfo.year
      })
    }
  }

  /**
   * 更新周数据
   */
  updateWeekData(param:string) {
    this.getWeekViewData(this.weekNum);
  }

  /**
   *  获取指定周数据
   */
  getWeekViewData(weekNum: number) {
    this.weekDays = [...TimeUtils.getWeekDays(weekNum)];
  }

  aboutToAppear() {
    this.getWeekViewData(this.weekNum);
  }

  /**
   * 周视图一天的子组件
   * @param day 日期
   */
  @Builder
  weekDayBuilder(day: Day) {
    Column() {
      Text(day.dayNum + '')
        .fontColor(StyleUtils.getColor(day, this.month, this.currentSelectDay, CalendarViewType.WEEK,
          this.calendarStyle))
        .fontSize(13)
        .fontWeight(FontWeight.Medium)
    }
    .width(40)
    .height(40)
    .borderRadius(40)
    .borderColor($r('app.color.calendar_switch_border_color'))
    .borderWidth(StyleUtils.getBorderWidth(day, this.month, this.currentSelectDay, CalendarViewType.WEEK))
    .backgroundColor(StyleUtils.getBackgroundColor(day, this.currentSelectDay, this.calendarStyle))
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .onClick((e:ClickEvent) => {
      // 获取年月日信息
      this.onDateClick(day.dayInfo.year, day.dayInfo.month, day.dayInfo.date);
      this.currentSelectDate = day.dayInfo.year + '-' + day.dayInfo.month + '-' + day.dayInfo.date;
      this.currentSelectDay.year = day.dayInfo.year;
      this.currentSelectDay.month = day.dayInfo.month;
      this.currentSelectDay.date = day.dayInfo.date;
    })
  }

  build() {
    Column() {
      ForEach(this.weekDays, (items: Day[]) => {
        Row() {
          ForEach(items, (item: Day) => {
            Column() {
              this.weekDayBuilder(item)
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