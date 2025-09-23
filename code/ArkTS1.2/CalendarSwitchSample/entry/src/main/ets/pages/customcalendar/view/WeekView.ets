'use static';
/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import { CalendarViewType } from '../components/CustomCalendar';
import { CalendarData, CalendarStyle, CalendarSwitch } from '../model/CalendarModel';
import { TimeUtils } from '../utils/TimeUtils';
import { WeekViewItem } from './WeekViewItem';
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

  /**
   * 日期选择改变
   */
  onSelectDayChange(param: string) {
    CommonData.CURRENT_SELECT_DATE = this.currentSelectDate;
    const PARTS: string[] = this.currentSelectDate.split('-');
    // 更新年月数据
    this.currentShowYear = Number(PARTS[0]);
    this.currentShowMonth = Number(PARTS[1]);
    this.onChangeYearMonth(this.currentShowYear, this.currentShowMonth);
  }

  aboutToAppear() {

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
    .width(Constants.WEEK_VIEW_WIDTH)
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
            backgroundColor: this.calendarStyle.backgroundColor,
            monthDayColor: this.calendarStyle.monthDayColor,
          }
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
            backgroundColor: this.calendarStyle.backgroundColor,
            monthDayColor: this.calendarStyle.monthDayColor,
          }
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
            backgroundColor: this.calendarStyle.backgroundColor,
            monthDayColor: this.calendarStyle.monthDayColor,
          }
        })
      }
      .id('weekView')
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
      } as OnSwiperAnimationStartCallback)
      .indicator(false)
      .loop(true)
      .index(this.swiperWeekIndex)
    }
    .width(Constants.WEEK_VIEW_WIDTH)
    .height(Constants.WEEK_VIEW_HEIGHT)
  }
}