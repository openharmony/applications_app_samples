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
import { CalendarViewType } from '../components/CustomCalendar';
import { CalendarSwitch } from '../model/CalendarModel';
import { YearViewItem } from './YearViewItem';
import {
  $r,
  Builder,
  Circle,
  ClickEvent,
  Color,
  Column,
  Component,
  Divider,
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
  calendarSwitch: CalendarSwitch = { isYearMonthHidden: false } as CalendarSwitch;
  // 年、月、周视图左右滑动切换回调
  onChangeYearMonth: (year: number, month: number) => void = () => {
  };
  // 年视图月份点击回调
  onMonthClick: (year: number, month: number) => void = () => {
  };

  aboutToAppear() {

  }

  build() {
    // 年视图
    Column() {
      if (!this.calendarSwitch.isYearMonthHidden) {
        // 年月信息标题
        Text(`${this.currentShowYear}年`)
          .fontSize(25)
          .fontWeight(Constants.FONT_WEIGHT_EIGHT_HUNDRED)
          .fontColor(Color.Red)
          .width('100%')
        Divider()
          .strokeWidth('1px')
          .margin({ top: 4, bottom: 4 } as Margin)
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
      .id('yearView')
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
            // swiper索引右滑到0时，修改swiper索引2的年为当前年（索引0）的上一年。比如，假设swiper索引0（2023年），swiper索引1（2024年），swiper索引2（2025年）。当右滑切换到索引0（2023年）时，需要把索引2（2025年）改成2022年。
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
      } as OnSwiperAnimationStartCallback)
      .indicator(false)
      .loop(true)
      .index(this.swiperYearIndex)
    }
    .width(Constants.YEAR_VIEW_WIDTH)
    .height(Constants.YEAR_VIEW_HEIGHT)
  }
}