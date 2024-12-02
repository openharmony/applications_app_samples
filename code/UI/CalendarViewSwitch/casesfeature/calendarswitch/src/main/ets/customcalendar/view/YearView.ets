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
import { CalendarViewType } from '../components/CustomCalendar';
import { CalendarSwitch } from '../model/CalendarModel';
import { YearViewItem } from './YearViewItem';

/**
 * 年视图
 */
@Component
export struct YearView {
  // swiper当前显示的子组件索引
  @State swiperYearIndex: number = 1;
  // 当前显示的年
  @State currentShowYear: number = Constants.TODAY_YEAR;
  // 上一年
  @State lastYear: number = Constants.TODAY_YEAR - 1;
  // 当前年
  @State currentYear: number = Constants.TODAY_YEAR;
  // 下一年
  @State nextYear: number = Constants.TODAY_YEAR + 1;
  // 记录swiper上一次显示的子组件索引。
  private oldYearViewIndex: number = 1;
  // 年、月、周视图切换场景的相关设置
  calendarSwitch: CalendarSwitch = { isYearMonthHidden: false };
  // 年、月、周视图左右滑动切换回调
  onChangeYearMonth: (year: number, month: number) => void = () => {
  };
  // 年视图月份点击回调
  onMonthClick: (year: number, month: number) => void = () => {
  };
  /**
   * 用于年、月、周视图间切换场景下刷新日期数据
   */
  private swiperRefresh = (value: CalendarViewType) => {
    if (value === CalendarViewType.YEAR) {
      if (this.calendarSwitch.currentSelectDay) {
        if (this.calendarSwitch.currentSelectDay.year === this.currentShowYear && this.swiperYearIndex === 1) {
          return;
        }
        this.currentShowYear = this.calendarSwitch.currentSelectDay.year;
        // 重置swiper索引
        this.swiperYearIndex = 1;
        this.oldYearViewIndex = 1;
        // 更新年月数据
        this.currentYear = this.calendarSwitch.currentSelectDay.year;
        this.lastYear = this.calendarSwitch.currentSelectDay.year - 1;
        this.nextYear = this.calendarSwitch.currentSelectDay.year + 1;
      }
    }
  }

  aboutToAppear() {
    if (this.calendarSwitch.controller) {
      // 给controller对应的方法赋值
      this.calendarSwitch.controller.swiperRefresh = this.swiperRefresh;
    }
  }

  build() {
    // 年视图
    Column() {
      if (!this.calendarSwitch.isYearMonthHidden) {
        // 年月信息标题
        Text(`${this.currentShowYear}年`)
          .fontSize($r('app.integer.calendar_switch_size_twenty_five'))
          .fontWeight(Constants.FONT_WEIGHT_EIGHT_HUNDRED)
          .fontColor(Color.Red)
          .width($r('app.string.calendar_switch_full_size'))
        Divider()
          .strokeWidth('1px')
          .margin({
            top: $r('app.integer.calendar_switch_size_four'),
            bottom: $r('app.integer.calendar_switch_size_four')
          })
      }
      Swiper() {
        // 年视图子组件
        YearViewItem({
          year: this.lastYear,
          onMonthClick: (year: number, month: number) => {
            this.onMonthClick(year, month);
          }
        })
        YearViewItem({
          year: this.currentYear,
          onMonthClick: (year: number, month: number) => {
            this.onMonthClick(year, month);
          }
        })
        YearViewItem({
          year: this.nextYear,
          onMonthClick: (year: number, month: number) => {
            this.onMonthClick(year, month);
          },
        })
      }
      .onAnimationStart((index: number, targetIndex: number, extraInfo: SwiperAnimationEvent) => {
        if (this.oldYearViewIndex === targetIndex) {
          // 如果手指滑动swiper松开时，targetIndex和之前记录子组件索引oldYearViewIndex一样，说明swiper没有切换子组件，不需要切换年份
          return;
        }
        // 记录子组件索引
        this.oldYearViewIndex = targetIndex;
        // 判断是否右滑切换年
        const IS_RIGHT_SLIDE: boolean = (index === 1 && targetIndex === 0) || (index === 0 && targetIndex === 2) ||
          (index === 2 && targetIndex === 1);
        // 手指右滑切换上一年
        if (IS_RIGHT_SLIDE) {
          // 滑到上一年，当前显示的年份-1
          this.currentShowYear = this.currentShowYear - 1;
          if (targetIndex === 0) {
            // swiper索引右滑到0时，修改swiper索引2的年为当前年（索引0）的上一年。比如，假设swiper索引0（2023年），swiper索引1（2024年）
            // ，swiper索引2（2025年）。当右滑切换到索引0（2023年）时，需要把索引2（2025年）改成2022年。
            this.nextYear = this.currentShowYear - 1;
          } else if (targetIndex === 1) {
            // swiper索引右滑到1时，修改swiper索引0的年为当前年（索引1）的上一年。
            this.lastYear = this.currentShowYear - 1;
          } else if (targetIndex === 2) {
            // swiper索引右滑到2时，修改swiper索引1的年为当前年（索引2）的上一年。
            this.currentYear = this.currentShowYear - 1;
          }
        } else {
          // 左滑切换下一年
          // 滑到下一年，当前显示的年份+1
          this.currentShowYear = this.currentShowYear + 1;
          if (targetIndex === 0) {
            // swiper索引左滑到0时，修改swiper索引1的年为当前年（索引0）的下一年。
            this.currentYear = this.currentShowYear + 1;
          } else if (targetIndex === 1) {
            // swiper索引左滑到1时，修改swiper索引2的年为当前年（索引1）的下一年。
            this.nextYear = this.currentShowYear + 1;
          } else if (targetIndex === 2) {
            // swiper索引左滑到2时，修改swiper索引0的年为当前年（索引2）的下一年。
            this.lastYear = this.currentShowYear + 1;
          }
        }
        this.onChangeYearMonth(this.currentShowYear, Constants.DEFAULT);
      })
      .indicator(false)
      .loop(true)
      .index($$this.swiperYearIndex)
    }
    .width(Constants.YEAR_VIEW_WIDTH)
    .height(Constants.YEAR_VIEW_HEIGHT)
  }
}