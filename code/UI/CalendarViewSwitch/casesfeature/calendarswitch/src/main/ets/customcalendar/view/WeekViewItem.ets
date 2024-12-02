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
import { CalendarData, CalendarStyle, Day } from '../model/CalendarModel';
import { StyleUtils } from '../utils/StyleUtils';
import { TimeUtils } from '../utils/TimeUtils'; // 时间计算工具类

/**
 * 周视图子组件
 */
@Component
export struct WeekViewItem {
  // 周视图日期数据
  @State @Watch('getFirstDayData') weekDays: Day[][] = [];
  // 当前选中的日期
  @State currentSelectDay: DayInfo =
    new DayInfo(new Date().getFullYear(), new Date().getMonth() + 1, new Date().getDate(), 0); // 当前选中的日期
  // 当前选中的日期，格式'year-month-date'
  @Link @Watch('OnChangeSelectDate') currentSelectDate: string;
  // 表示周视图第几周
  @Prop @Watch('updateWeekData') weekNum: number;
  private month: number = Constants.TODAY_MONTH;
  // 自定义日历样式
  calendarStyle: CalendarStyle = {};
  // 周视图数据切换回调，返回一周中第一天的数据
  onWeekSwitch: (item: CalendarData) => void = () => {
  };
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
   * 周视图切换时，将当前周数据的第一天（周日）日期数据传出去
   */
  getFirstDayData() {
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
  updateWeekData() {
    this.getWeekViewData(this.weekNum);
  }

  /**
   *  获取指定周数据
   */
  getWeekViewData(weekNum: number) {
    this.weekDays = [...TimeUtils.getWeekDays(weekNum)];
  }

  aboutToAppear() {
    if (this.controller) {
      this.controller.schedulePointRefresh = this.schedulePointRefresh;
    }
    this.getWeekViewData(this.weekNum);
  }

  /**
   * 刷新日程点数据
   */
  private schedulePointRefresh = () => {
    this.updateWeekData();
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
        .fontSize(Constants.DAY_FONT_SIZE *
          (this.calendarStyle.textScaling ? this.calendarStyle.textScaling : Constants.FONT_MULTIPLIER))
        .fontWeight(FontWeight.Medium)
      Text(day.lunarDay)
        .fontColor(StyleUtils.getLunarDayColor(day, this.month, this.currentSelectDay, CalendarViewType.WEEK,
          this.calendarStyle))
        .fontSize(Constants.LUNAR_DAY_FONT_SIZE *
          (this.calendarStyle.textScaling ? this.calendarStyle.textScaling : Constants.FONT_MULTIPLIER))
    }
    .width($r('app.integer.calendar_switch_size_forty'))
    .height($r('app.integer.calendar_switch_size_forty'))
    .borderRadius($r('app.integer.calendar_switch_size_forty'))
    .borderColor($r('app.color.calendar_switch_border_color'))
    .borderWidth(StyleUtils.getBorderWidth(day, this.month, this.currentSelectDay, CalendarViewType.WEEK))
    .backgroundColor(StyleUtils.getBackgroundColor(day, this.currentSelectDay, this.calendarStyle))
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .onClick(() => {
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
        }, '') + index;
      })
    }.width($r('app.string.calendar_switch_full_size'))
  }
}