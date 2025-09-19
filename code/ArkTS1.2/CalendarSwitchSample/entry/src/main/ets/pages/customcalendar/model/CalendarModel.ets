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

import { DayInfo } from '../components/CustomCalendar';
import { Resource, Color } from '@ohos.arkui.component';
/**
 * 自定义日历样式。仅用于月、周视图。
 */
export interface CalendarStyle {
  backgroundColor?: Color | number | string | Resource; // 今天选中日期的背景色
  monthDayColor?: Color | number | string | Resource; // 本月公历日期颜色
  noMonthDayColor?: Color | number | string | Resource; // 非本月公历日期颜色，仅对月视图有效。
}

/**
 * 一天的信息。包含农历
 */
export interface Day {
  dayNum: number, // 日期
  dayInfo: DayInfo, // 一天的年月日信息
}

/**
 * 日期信息。用于选择日期回调
 */
export interface CalendarData {
  year: number, // 年
  month: number, // 月
  date: number // 日
}

/**
 * 年、月、周视图切换场景的相关设置
 */
export interface CalendarSwitch {
  currentSelectDay?: DayInfo; // 记录月、周视图中点击选中的日期信息。
  isYearMonthHidden?: boolean; // 是否隐藏自定义日历年、月、周视图中自带的年月信息标题。
}