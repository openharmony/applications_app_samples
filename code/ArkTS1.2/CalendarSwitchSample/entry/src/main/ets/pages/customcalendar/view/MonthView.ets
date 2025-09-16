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
import { CalendarViewType } from '../components/CustomCalendar';
import { CalendarStyle, CalendarSwitch } from '../model/CalendarModel';
import { MonthViewItem } from './MonthViewItem';
import { TimeUtils } from '../utils/TimeUtils';
import CommonData from '../common/CommonData';
import {
  $r,
  Builder,
  Circle,
  ClickEvent,
  Color,
  Column,
  Component,
  FlexAlign,
  FontWeight,
  ForEach,
  HorizontalAlign,
  Margin,
  OnSwiperAnimationStartCallback,
  Padding,
  Row,
  Swiper,
  SwiperAnimationEvent,
  Text,
  TextAlign
} from '@ohos.arkui.component';
import { Link, State, Watch } from '@ohos.arkui.stateManagement';

/**
 * 月视图
 */
@Component
export struct MonthView {
  // 当前显示的年份
  @State currentShowYear: number = Constants.TODAY_YEAR;
  // 当前显示的月份
  @State currentShowMonth: number = Constants.TODAY_MONTH;
  // 当前显示的年月
  @State currentYearMonth: string = Constants.TODAY_YEAR + '-' + Constants.TODAY_MONTH;
  // 当前选中的日期
  @State @Watch('onSelectDayChange') currentSelectDate: string =
    Constants.TODAY_YEAR + '-' + Constants.TODAY_MONTH + '-' + Constants.TODAY + '-' + '0';
  // 下个月对应的年月信息
  @State nextYearMonth: string = TimeUtils.getNextYearMonth(this.currentShowYear, this.currentShowMonth);
  // 上个月对应的年月信息
  @State lastYearMonth: string = TimeUtils.getLastYearMonth(this.currentShowYear, this.currentShowMonth);
  // swiper当前显示的子组件索引
  @State swiperMonthIndex: number = 1;
  // 记录swiper上一次显示的子组件索引。
  private oldMonthViewIndex: number = 1;
  // 自定义日历样式
  calendarStyle: CalendarStyle = {} as CalendarStyle;
  // 年、月、周视图切换场景的相关设置
  calendarSwitch: CalendarSwitch = { isYearMonthHidden: false } as CalendarSwitch;
  // 日期点击回调
  onDateClick: (year: number, month: number, date: number) => void = () => {
  };
  // 年、月、周视图左右滑动切换回调
  onChangeYearMonth: (year: number, month: number) => void = () => {
  };

  aboutToAppear() {

  }

  /**
   * 日期选择改变
   */
  onSelectDayChange(param: string) {
    // 记录选中的月视图日期，拉起添加日程页面会根据选中日期显示对应的"开始时间"
    CommonData.CURRENT_SELECT_DATE = this.currentSelectDate;
    const PARTS: string[] = this.currentSelectDate.split('-');
    // 更新年月数据
    this.currentShowYear = Number(PARTS[0]);
    this.currentShowMonth = Number(PARTS[1]);
    this.onChangeYearMonth(this.currentShowYear, this.currentShowMonth);
    const WEEK = Number(PARTS[3]);
    /**
     * 月视图中点击非当月日期时，会切换相应的月份，根据日期中的this.currentSelectDay.week值进行判断是切换上个月（week等于0）还是下个月（week
     * 等于2）。在TimeUtils的byMonthDayForYear中月视图中上个月日期中的week会写入0，下个月的日期写入2。
     */
    if (WEEK === 0) {
      // 月视图中如果点击了上个月的日期，即切换到上个月，类似右滑切换月份，只是swiper索引不变，所以需要刷新两个月
      if (this.oldMonthViewIndex === 0) {
        // 月视图当前swiper显示的是索引0，则刷新索引1和2的月份
        this.currentYearMonth = TimeUtils.getNextYearMonth(this.currentShowYear, this.currentShowMonth);
        this.nextYearMonth = TimeUtils.getLastYearMonth(this.currentShowYear, this.currentShowMonth);
      } else if (this.oldMonthViewIndex === 1) {
        // 月视图当前swiper显示的是索引1，则刷新索引0和2的月份
        this.lastYearMonth = TimeUtils.getLastYearMonth(this.currentShowYear, this.currentShowMonth);
        this.nextYearMonth = TimeUtils.getNextYearMonth(this.currentShowYear, this.currentShowMonth);
      } else if (this.oldMonthViewIndex === 2) {
        // 月视图当前swiper显示的是索引2，则刷新索引0和1的月份
        this.lastYearMonth = TimeUtils.getNextYearMonth(this.currentShowYear, this.currentShowMonth);
        this.currentYearMonth = TimeUtils.getLastYearMonth(this.currentShowYear, this.currentShowMonth);
      }
    } else if (WEEK === 2) {
      // 月视图中如果点击了下个月的日期，即切换到下个月，类似左滑切换月份，只是swiper索引不变，所以需要刷新两个月
      if (this.oldMonthViewIndex === 0) {
        //刷新索引1和2
        this.currentYearMonth = TimeUtils.getNextYearMonth(this.currentShowYear, this.currentShowMonth);
        this.nextYearMonth = TimeUtils.getLastYearMonth(this.currentShowYear, this.currentShowMonth);
      } else if (this.oldMonthViewIndex === 1) {
        //刷新索引0和2
        this.lastYearMonth = TimeUtils.getLastYearMonth(this.currentShowYear, this.currentShowMonth);
        this.nextYearMonth = TimeUtils.getNextYearMonth(this.currentShowYear, this.currentShowMonth);
      } else if (this.oldMonthViewIndex === 2) {
        //刷新索引0和1
        this.lastYearMonth = TimeUtils.getNextYearMonth(this.currentShowYear, this.currentShowMonth);
        this.currentYearMonth = TimeUtils.getLastYearMonth(this.currentShowYear, this.currentShowMonth);
      }
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
          .fontSize(13)
          .fontColor((index === 0 || index === 6) ? Color.Grey : Color.Black)
          .width(40)
          .textAlign(TextAlign.Center)
      }, (text: string, index: number) => text)
    }
    .width(Constants.MONTH_VIEW_WIDTH)
    .justifyContent(FlexAlign.SpaceBetween)
    .margin({ bottom: 10 } as Margin)
  }

  build() {
    // 月视图
    Column() {
      if (!this.calendarSwitch.isYearMonthHidden) {
        // 年月信息标题
        Text(`${this.currentShowYear}年${this.currentShowMonth}月`)
          .fontSize(20)
          .fontWeight(Constants.FONT_WEIGHT_FIVE_HUNDRED)
          .width('100%')
          .padding({ left: 10 } as Padding)
          .margin({ bottom: 10 } as Margin)
      }
      // 星期
      this.weeks()

      Swiper() {
        // 月视图子组件
        MonthViewItem({
          yearMonth: this.lastYearMonth,
          currentSelectDate: this.currentSelectDate,
          onDateClick: (year: number, month: number, date: number) => {
            this.onDateClick(year, month, date);
          },
          calendarStyle: {
            backgroundColor: this.calendarStyle.backgroundColor,
            monthDayColor: this.calendarStyle.monthDayColor,
            noMonthDayColor: this.calendarStyle.noMonthDayColor,
          }
        })
        MonthViewItem({
          yearMonth: this.currentYearMonth,
          currentSelectDate: this.currentSelectDate,
          onDateClick: (year: number, month: number, date: number) => {
            this.onDateClick(year, month, date);
          },
          calendarStyle: {
            backgroundColor: this.calendarStyle.backgroundColor,
            monthDayColor: this.calendarStyle.monthDayColor,
            noMonthDayColor: this.calendarStyle.noMonthDayColor,
          }
        })
        MonthViewItem({
          yearMonth: this.nextYearMonth,
          currentSelectDate: this.currentSelectDate,
          onDateClick: (year: number, month: number, date: number) => {
            this.onDateClick(year, month, date);
          },
          calendarStyle: {
            backgroundColor: this.calendarStyle.backgroundColor,
            monthDayColor: this.calendarStyle.monthDayColor,
            noMonthDayColor: this.calendarStyle.noMonthDayColor,
          }
        })
      }
      .id('monthView')
      .onAnimationStart((index: number, targetIndex: number, extraInfo: SwiperAnimationEvent) => {
        if (this.oldMonthViewIndex === targetIndex) {
          // 如果手指滑动swiper松开时，targetIndex和之前记录子组件索引oldMonthViewIndex一样，说明swiper没有切换子组件，不需要切换月份
          return;
        }
        // 记录子组件索引
        this.oldMonthViewIndex = targetIndex;
        // 判断是否右滑切换月份
        const IS_RIGHT_SLIDE: boolean = (index === 1 && targetIndex === 0) || (index === 0 && targetIndex === 2) ||
          (index === 2 && targetIndex === 1);
        // 右滑切换到上个月
        if (IS_RIGHT_SLIDE) {
          // 将当前月份设置为上个月
          this.currentShowYear = TimeUtils.getLastYear(this.currentShowYear, this.currentShowMonth);
          this.currentShowMonth = TimeUtils.getLastMonth(this.currentShowYear, this.currentShowMonth);
          this.onChangeYearMonth(this.currentShowYear, this.currentShowMonth);
          if (targetIndex === 0) {
            // swiper索引右滑到0时，修改swiper索引2的月份为当前月份（索引0）的上一个月。比如，假设swiper索引0（7月），swiper索引1（8月），swiper索引2（9月）。当右滑切换到索引0（7月）时，需要把索引2（9月）的月份改成6月。
            // 修改swiper索引2的月份为当前月份（索引0）的上一个月
            this.nextYearMonth = TimeUtils.getLastYearMonth(this.currentShowYear, this.currentShowMonth);
          } else if (targetIndex === 1) {
            // swiper索引右滑到1时，修改swiper索引0的月份为当前月份（索引1）的上一个月。
            this.lastYearMonth = TimeUtils.getLastYearMonth(this.currentShowYear, this.currentShowMonth);
          } else if (targetIndex === 2) {
            // swiper索引右滑到2时，修改swiper索引1的月份为当前月份（索引2）的上一个月。
            this.currentYearMonth = TimeUtils.getLastYearMonth(this.currentShowYear, this.currentShowMonth);
          }
        } else {
          // 右滑切换到下个月
          // 将当前月份设置为下个月
          this.currentShowYear = TimeUtils.getNextYear(this.currentShowYear, this.currentShowMonth);
          this.currentShowMonth = TimeUtils.getNextMonth(this.currentShowYear, this.currentShowMonth);
          this.onChangeYearMonth(this.currentShowYear, this.currentShowMonth);
          if (targetIndex === 0) {
            // swiper索引左滑到0时，修改swiper索引1的月份为当前月份（索引0）的下一个月。
            this.currentYearMonth = TimeUtils.getNextYearMonth(this.currentShowYear, this.currentShowMonth);
          } else if (targetIndex === 1) {
            // swiper索引左滑到1时，修改swiper索引2的月份为当前月份（索引1）的下一个月。
            this.nextYearMonth = TimeUtils.getNextYearMonth(this.currentShowYear, this.currentShowMonth);
          } else if (targetIndex === 2) {
            // swiper索引左滑到2时，修改swiper索引0的月份为当前月份（索引2）的下一个月。
            this.lastYearMonth = TimeUtils.getNextYearMonth(this.currentShowYear, this.currentShowMonth);
          }
        }
      } as OnSwiperAnimationStartCallback)
      .indicator(false)
      .loop(true)
      .index(this.swiperMonthIndex)
    }
    .width(Constants.MONTH_VIEW_WIDTH)
    .height(Constants.MONTH_VIEW_HEIGHT)
  }
}