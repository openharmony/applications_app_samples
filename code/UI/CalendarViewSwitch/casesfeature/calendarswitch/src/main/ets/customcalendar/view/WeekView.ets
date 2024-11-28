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
import { CalendarController, CalendarViewType } from '../components/CustomCalendar';
import { CalendarData, CalendarStyle, CalendarSwitch } from '../model/CalendarModel';
import { TimeUtils } from '../utils/TimeUtils';
import { WeekViewItem } from './WeekViewItem';
import CommonData from '../common/CommonData';

/**
 * 周视图
 */
@Component
export struct WeekView {
  // swiper当前显示的子组件索引
  @State swiperWeekIndex: number = 1;
  // 控制周视图每个WeekViewItem显示哪一周的数据
  @State weekNumOne: number = -1;
  @State weekNumTwo: number = 0;
  @State weekNumThree: number = 1;
  // 当前选中的日期
  @State @Watch('onSelectDayChange') currentSelectDate: string =
    Constants.TODAY_YEAR + '-' + Constants.TODAY_MONTH + '-' + Constants.TODAY + '-' + '0';
  // 当前显示的年份
  @State currentShowYear: number = Constants.TODAY_YEAR;
  // 当前显示的月份
  @State currentShowMonth: number = Constants.TODAY_MONTH;
  // 用于记录周视图每个WeekViewItem第一天（周日）的年月信息
  private weekYearOne: number = 0;
  private weekYearTwo: number = 0;
  private weekYearThree: number = 0;
  private weekMonthOne: number = 0;
  private weekMonthTwo: number = 0;
  private weekMonthThree: number = 0;
  // 记录swiper上一次显示的子组件索引。
  private oldWeekViewIndex: number = 1;
  // 添加日程后，重新刷新周视图的控制器
  private oneController = new CalendarController();
  private twoController = new CalendarController();
  private threeController = new CalendarController();
  // 自定义日历样式
  calendarStyle: CalendarStyle = {};
  // 年、月、周视图切换场景的相关设置
  calendarSwitch: CalendarSwitch = { isYearMonthHidden: false };
  // 日期点击回调
  onDateClick: (year: number, month: number, date: number) => void = () => {
  };
  // 年、月、周视图左右滑动切换回调
  onChangeYearMonth: (year: number, month: number) => void = () => {
  };
  /**
   * 用于年、月、周视图间切换场景下刷新日期数据
   */
  private swiperRefresh = (value: CalendarViewType) => {
    if (value === CalendarViewType.WEEK) {
      if (this.calendarSwitch.currentSelectDay) {
        // 重置
        this.swiperWeekIndex = 1;
        this.oldWeekViewIndex = 1;
        this.currentSelectDate =
          this.calendarSwitch.currentSelectDay.year + '-' + this.calendarSwitch.currentSelectDay.month + '-' +
          this.calendarSwitch.currentSelectDay.date;
        // 更新年月数据
        this.currentShowYear = this.calendarSwitch.currentSelectDay.year;
        this.currentShowMonth = this.calendarSwitch.currentSelectDay.month;
        const SELECT_DAY =
          new Date(this.calendarSwitch.currentSelectDay.year, this.calendarSwitch.currentSelectDay.month - 1,
            this.calendarSwitch.currentSelectDay.date);
        // 计算目前选中的日期selectDay距离今天相差的周数
        const WEEKS_BETWEEN = TimeUtils.weeksBetweenDates(SELECT_DAY);
        this.weekNumOne = WEEKS_BETWEEN - 1; // 设置上一周
        this.weekNumTwo = WEEKS_BETWEEN; // 设置本周
        this.weekNumThree = WEEKS_BETWEEN + 1; // 设置下一周
      }
    }
  }

  /**
   * 日期选择改变
   */
  onSelectDayChange() {
    CommonData.CURRENT_SELECT_DATE = this.currentSelectDate;
    const PARTS: string[] = this.currentSelectDate.split('-');
    // 更新年月数据
    this.currentShowYear = Number(PARTS[0]);
    this.currentShowMonth = Number(PARTS[1]);
    this.onChangeYearMonth(this.currentShowYear, this.currentShowMonth);
  }

  /**
   * 用于添加日程后，重刷周视图数据
   */
  private schedulePointRefresh = () => {
    this.oneController.schedulePointRefresh();
    this.twoController.schedulePointRefresh();
    this.threeController.schedulePointRefresh();
  }

  aboutToAppear() {
    if (this.calendarSwitch.controller) {
      // 给controller对应的方法赋值
      this.calendarSwitch.controller.swiperRefresh = this.swiperRefresh;
      this.calendarSwitch.controller.schedulePointRefresh = this.schedulePointRefresh;
    }
  }

  /**
   * 星期
   */
  @Builder
  weeks() {
    Row() {
      ForEach(Constants.WEEKS, (text: string, index: number) => {
        Text(text)
          .fontSize(Constants.WEEK_FONT_SIZE *
            (this.calendarStyle.textScaling ? this.calendarStyle.textScaling : Constants.FONT_MULTIPLIER))
          .fontColor((index === 0 || index === 6) ? Color.Grey : Color.Black)
          .width($r('app.integer.calendar_switch_size_forty'))
          .textAlign(TextAlign.Center)
      }, (text: string) => text)
    }
    .width(Constants.WEEK_VIEW_WIDTH)
    .justifyContent(FlexAlign.SpaceBetween)
    .margin({ bottom: $r('app.integer.calendar_switch_size_ten') })
  }

  build() {
    // 月视图
    Column() {
      if (!this.calendarSwitch.isYearMonthHidden) {
        // 年月信息标题
        Text(`${this.currentShowYear}年${this.currentShowMonth}月`)
          .fontSize(Constants.YEAR_MONTH_FONT_SIZE *
            (this.calendarStyle.textScaling ? this.calendarStyle.textScaling : Constants.FONT_MULTIPLIER))
          .fontWeight(Constants.FONT_WEIGHT_FIVE_HUNDRED)
          .width($r('app.string.calendar_switch_full_size'))
          .padding({ left: $r('app.integer.calendar_switch_size_ten') })
          .margin({ bottom: $r('app.integer.calendar_switch_size_ten') })
      }
      // 星期
      this.weeks()

      Swiper() {
        // 周视图子组件
        WeekViewItem({
          weekNum: this.weekNumOne,
          currentSelectDate: this.currentSelectDate,
          onWeekSwitch: (item: CalendarData) => {
            // 周视图获取第一天（周日）日期数据
            this.weekYearOne = item.year;
            this.weekMonthOne = item.month;
          },
          onDateClick: (year: number, month: number, date: number) => {
            this.onDateClick(year, month, date);
          },
          calendarStyle: {
            textScaling: this.calendarStyle.textScaling,
            backgroundColor: this.calendarStyle.backgroundColor,
            monthDayColor: this.calendarStyle.monthDayColor,
            lunarColor: this.calendarStyle.lunarColor
          },
          controller: this.oneController
        })
        WeekViewItem({
          weekNum: this.weekNumTwo,
          currentSelectDate: this.currentSelectDate,
          onWeekSwitch: (item: CalendarData) => {
            // 周视图获取第一天（周日）日期数据
            this.weekYearTwo = item.year;
            this.weekMonthTwo = item.month;
          },
          onDateClick: (year: number, month: number, date: number) => {
            this.onDateClick(year, month, date);
          },
          calendarStyle: {
            textScaling: this.calendarStyle.textScaling,
            backgroundColor: this.calendarStyle.backgroundColor,
            monthDayColor: this.calendarStyle.monthDayColor,
            lunarColor: this.calendarStyle.lunarColor
          },
          controller: this.twoController
        })
        WeekViewItem({
          weekNum: this.weekNumThree,
          currentSelectDate: this.currentSelectDate,
          onWeekSwitch: (item: CalendarData) => {
            // 周视图获取第一天（周日）日期数据
            this.weekYearThree = item.year;
            this.weekMonthThree = item.month;
          },
          onDateClick: (year: number, month: number, date: number) => {
            this.onDateClick(year, month, date);
          },
          calendarStyle: {
            textScaling: this.calendarStyle.textScaling,
            backgroundColor: this.calendarStyle.backgroundColor,
            monthDayColor: this.calendarStyle.monthDayColor,
            lunarColor: this.calendarStyle.lunarColor
          },
          controller: this.threeController
        })
      }
      .onAnimationStart((index: number, targetIndex: number, extraInfo: SwiperAnimationEvent) => {
        // 判断是否右滑切换周
        const IS_RIGHT_SLIDE: boolean = (index === 1 && targetIndex === 0) || (index === 0 && targetIndex === 2) ||
          (index === 2 && targetIndex === 1);
        // 记录子组件索引
        this.oldWeekViewIndex = targetIndex;
        // 切换周时，刷新当前周视图第一天（周日）对应的年月信息
        this.currentShowYear =
          (this.oldWeekViewIndex === 0) ? this.weekYearOne :
            ((this.oldWeekViewIndex === 1) ? this.weekYearTwo : this.weekYearThree);
        this.currentShowMonth =
          ((this.oldWeekViewIndex === 0) ? this.weekMonthOne :
            ((this.oldWeekViewIndex === 1) ? this.weekMonthTwo : this.weekMonthThree));
        this.onChangeYearMonth(this.currentShowYear, this.currentShowMonth);
        // 右滑切换周
        if (IS_RIGHT_SLIDE) {
          if (targetIndex === 0) {
            // swiper索引右滑到0时，修改swiper索引2的周为当前周（索引0）的上一周。
            this.weekNumThree = this.weekNumOne - 1;
          } else if (targetIndex === 1) {
            // swiper索引右滑到1时，修改swiper索引0的周为当前周（索引1）的上一周。
            this.weekNumOne = this.weekNumTwo - 1;
          } else if (targetIndex === 2) {
            // swiper索引右滑到2时，修改swiper索引1的周为当前周（索引2）的上一周。
            this.weekNumTwo = this.weekNumThree - 1;
          }
        } else {
          // 左滑切换周
          if (targetIndex === 0) {
            // swiper索引左滑到0时，修改swiper索引1的周为当前周（索引0）的下一周。
            this.weekNumTwo = this.weekNumOne + 1;
          } else if (targetIndex === 1) {
            // swiper索引左滑到1时，修改swiper索引2的周为当前周（索引1）的下一周。
            this.weekNumThree = this.weekNumTwo + 1;
          } else if (targetIndex === 2) {
            // swiper索引右滑到2时，修改swiper索引0的周为当前周（索引2）的下一周。
            this.weekNumOne = this.weekNumThree + 1;
          }
        }
      })
      .indicator(false)
      .loop(true)
      .index($$this.swiperWeekIndex)
    }
    .width(Constants.WEEK_VIEW_WIDTH)
    .height(Constants.WEEK_VIEW_HEIGHT)
  }
}