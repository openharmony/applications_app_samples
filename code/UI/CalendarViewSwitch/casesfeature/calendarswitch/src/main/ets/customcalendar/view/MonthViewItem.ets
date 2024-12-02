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
import { CalendarController, CalendarViewType, DayInfo } from '../components/CustomCalendar';
import { CalendarStyle, Day } from '../model/CalendarModel';
import { StyleUtils } from '../utils/StyleUtils';
import { TimeUtils } from '../utils/TimeUtils'; // 时间计算工具类

/**
 * 月视图子组件
 */
@Component
export struct MonthViewItem {
  // 月视图日期数据
  @State monthDays: Day[][] = [];
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
  calendarStyle: CalendarStyle = {};
  // 日期点击回调
  onDateClick: (year: number, month: number, date: number) => void = () => {
  };
  // 日历控制器。这里用于控制添加日程后月视图数据刷新
  controller?: CalendarController;

  /**
   * 日期选择监听
   */
  OnChangeSelectDate() {
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
  updateMonthData() {
    const PARTS: string[] = this.yearMonth.split('-');
    this.year = Number(PARTS[0]);
    this.month = Number(PARTS[1]);
    this.getMonthViewData(this.year, this.month);
  }

  /**
   * 刷新日程点数据
   */
  private schedulePointRefresh = () => {
    this.updateMonthData();
  }

  aboutToAppear() {
    if (this.controller) {
      this.controller.schedulePointRefresh = this.schedulePointRefresh;
    }
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
        .fontSize(Constants.DAY_FONT_SIZE *
          (this.calendarStyle.textScaling ? this.calendarStyle.textScaling : Constants.FONT_MULTIPLIER))
        .fontWeight(FontWeight.Medium)
      Text(day.lunarDay)
        .fontColor(StyleUtils.getLunarDayColor(day, this.month, this.currentSelectDay, CalendarViewType.MONTH,
          this.calendarStyle))
        .fontSize(Constants.LUNAR_DAY_FONT_SIZE *
          (this.calendarStyle.textScaling ? this.calendarStyle.textScaling : Constants.FONT_MULTIPLIER))
    }
    .width($r('app.integer.calendar_switch_size_forty'))
    .height($r('app.integer.calendar_switch_size_forty'))
    .borderRadius($r('app.integer.calendar_switch_size_forty'))
    .borderColor($r('app.color.calendar_switch_border_color'))
    .borderWidth(StyleUtils.getBorderWidth(day, this.month, this.currentSelectDay, CalendarViewType.MONTH))
    .backgroundColor(StyleUtils.getBackgroundColor(day, this.currentSelectDay, this.calendarStyle))
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .onClick(() => {
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
              if (item.isShowSchedulePoint) {
                // 日程点
                Circle({ width: Constants.SCHEDULE_POINT_DIAMETER, height: Constants.SCHEDULE_POINT_DIAMETER })
                  .fill($r('app.color.calendar_switch_schedule_point_color'))
                  .margin({ top: $r('app.integer.calendar_switch_size_one') })
              }
            }
            .height($r('app.integer.calendar_switch_size_forty_six'))
          }, (item: Day, index: number) => {
            return item.dayNum + '' + index + item.isShowSchedulePoint;
          })
        }
        .width($r('app.string.calendar_switch_full_size'))
        .justifyContent(FlexAlign.SpaceBetween)
      }, (item: Day[], index: number) => {
        return item.reduce((item1, item2) => {
          return item1 + item2.dayInfo.year + item2.dayInfo.month + item2.dayInfo.date + item2.isShowSchedulePoint
        }, '') + index
      })
    }.width($r('app.string.calendar_switch_full_size'))
  }
}