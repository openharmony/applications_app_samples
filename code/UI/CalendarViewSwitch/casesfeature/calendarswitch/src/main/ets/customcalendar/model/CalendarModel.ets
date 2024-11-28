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

import { CalendarController, DayInfo } from '../components/CustomCalendar';

/**
 * 自定义日历样式。仅用于月、周视图。
 */
export interface CalendarStyle {
  textScaling?: number; // 月视图和周视图中的公历、农历、星期、年月信息标题文字缩放比例。
  backgroundColor?: Color | number | string | Resource; // 今天选中日期的背景色
  monthDayColor?: Color | number | string | Resource; // 本月公历日期颜色
  noMonthDayColor?: Color | number | string | Resource; // 非本月公历日期颜色，仅对月视图有效。
  lunarColor?: Color | number | string | Resource; // 本月农历字体颜色
}

/**
 * 一天的信息。包含农历
 */
export interface Day {
  dayNum: number, // 日期
  lunarDay: string, // 农历中文日期
  dayInfo: DayInfo, // 一天的年月日信息
  isShowSchedulePoint: boolean // 是否显示日程点
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
  controller?: CalendarController; // 自定义日历控制器，用于视图切换后的数据刷新。
  currentSelectDay?: DayInfo; // 记录月、周视图中点击选中的日期信息。
  isYearMonthHidden?: boolean; // 是否隐藏自定义日历年、月、周视图中自带的年月信息标题。
}

/**
 * 日程点相关信息
 */
@Observed
export class ScheduleInfo {
  public title: string; // 标题
  public location: string; // 地点
  public startTime: Date; // 开始时间
  public endTime: Date; // 结束时间
  public describe: string; // 说明
  public dateString: string; // 开始时间startTime里的年月日，如'2024/11/5'
  public reminderTime: number[]; // 提醒时间

  constructor(title: string, location: string, startTime: Date, endTime: Date, describe: string,
    dateString: string, reminderTime: number[]) {
    this.title = title;
    this.location = location;
    this.startTime = startTime;
    this.endTime = endTime;
    this.describe = describe;
    this.dateString = dateString;
    this.reminderTime = reminderTime;
  }
}

/**
 * 设备类型
 */
export enum DeviceType {
  PHONE, // 手机或者折叠态折叠屏
  EXPAND_FOLD, // 展开态折叠屏
  RK, // RK3568
}