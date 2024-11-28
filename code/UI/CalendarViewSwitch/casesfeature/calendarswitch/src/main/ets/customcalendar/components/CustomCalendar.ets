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

import { CalendarStyle, CalendarSwitch } from '../model/CalendarModel';
import { YearView } from '../view/YearView';
import { MonthView } from '../view/MonthView';
import { WeekView } from '../view/WeekView';
import CommonData from '../common/CommonData';
import { preferences } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { TimeUtils } from '../utils/TimeUtils';

/**
 * 自定义日历组件CustomCalendar（年视图，月视图，周视图）
 *
 * 功能描述：
 * 1.提供可左右滑动切换年、月、周的年视图，月视图，周视图。
 * 2.月视图和周视图支持点击日期监听onDateClick，年视图支持点击月份监听onMonthClick，提供左右滑动切换年月监听onChangeYearMonth。
 * 3.月视图支持点击非当前月日期切换月份。
 * 4.月视图和周视图支持自定义设置公历、农历、星期、年月信息标题文字缩放比例，今天选中日期的背景色，本月公历日期颜色，本月农历字体颜色。月视图支持
 * 设置非本月公历日期颜色。
 *
 * 实现思路
 * 1.根据自定义日历类型CalendarViewType，分别显示对应年（YearView）、月（MonthView）、周视图（WeekView）。
 * 2.月视图和周视图参考[日历三方库@xsqd/calendar](https://ohpm.openharmony.cn/#/cn/detail/@xsqd%2Fcalendar)的部分源码使用两个ForEach
 * 循环实现日历的月视图和周视图的日期布局效果。通过CalendarViewType条件渲染对应的月视图或周视图。年视图使用Canvas绘制显示年视图中每个月。使用
 * OffscreenCanvasRenderingContext2D在Canvas上进行离屏绘制（主要使用fillText绘制月份，星期，日期等文本数据），它会将需要绘制的内容先绘制
 * 在缓存区，然后使用transferToImageBitmap将其转换成图片，一次性绘制到canvas上，以加快绘制速度。
 * 3.年视图、月视图、周视图都是根据Swiper的onAnimationStart事件（切换动画开始时触发该回调）进行年、月、周的切换。以月视图为例，通过oldMonthViewIndex
 * 存储上一次的Swiper索引值，然后跟本次切换的索引targetIndex进行比较，来识别月份是左滑还是右滑。然后根据当前切换后的索引值去刷新所需的月份。例如，
 * 假设swiper索引0（7月），swiper索引1（8月），swiper索引2（9月），当前Swiper显示的索引为1。当Swiper右滑从索引1（8月）切换到索引0（7月）时，
 * 需要把Swiper里索引2（9月）的月份更新为6月的数据。年视图和周视图也是类似的逻辑，这里不再赘述。
 *
 * 接口：
 * CustomCalendar({ calendarViewType: CalendarViewType, calendarStyle?: CalendarStyle, calendarSwitch?: CalendarSwitch,
 * onDateClick: (year: number, month: number, date: number)=>void, onChangeYearMonth: (year: number, month: number)=>
 * void, onMonthClick: (year: number, month: number)=>void})
 *
 * 参数：
 * @param { CalendarViewType } calendarViewType - 自定义日历类型。YEAR年视图 MONTH月视图 WEEK周视图。必选项。
 *
 * @param { CalendarStyle } calendarStyle - 自定义日历样式。仅用于月、周视图。可选项。
 * 包含以下子项：
 * @param { number } textScaling - 月视图和周视图中的公历、农历、星期、年月信息标题文字缩放比例。可选项。
 * @param { Color | number | string | Resource } backgroundColor - 今天选中日期的背景色。可选项。
 * @param { Color | number | string | Resource } monthDayColor - 本月公历日期颜色。可选项。
 * @param { Color | number | string | Resource } noMonthDayColor - 非本月公历日期颜色，仅对月视图有效。可选项。
 * @param { Color | number | string | Resource } lunarColor - 本月农历字体颜色。可选项。
 *
 * @param { CalendarSwitch } calendarSwitch - 年、月、周视图切换场景的相关设置。可选项。
 * 包含以下子项：
 * @param { CalendarController } controller - 自定义日历控制器，用于视图切换后的数据刷新。可选项。
 * @param { DayInfo } currentSelectDay - 记录月、周视图中点击选中的日期信息。可选项。
 * @param { boolean } isYearMonthHidden - 是否隐藏自定义日历年、月、周视图中自带的年月信息标题。可选项。
 *
 * @param { function } onDateClick - 日期点击回调。返回点击日期的年月日信息。仅用于月、周视图。可选项。
 *
 * @param { function } onChangeYearMonth - 年、月、周视图左右滑动切换回调，返回左右切换视图后的年月信息，其中年视图切换实际只返回切换后年份信息。可选项。
 *
 * @param { function } onMonthClick - 年视图月份点击回调。返回年视图点击的年月信息。仅用于年视图。可选项。
 *
 * 基本用法：
 * CustomCalendar() // 不传参默认显示月视图
 * CustomCalendar({ calendarViewType: CalendarViewType.YEAR }) // 年视图
 * CustomCalendar({ calendarViewType: CalendarViewType.MONTH }) // 月视图
 * CustomCalendar({ calendarViewType: CalendarViewType.WEEK }) // 周视图
 */
@Component
export struct CustomCalendar {
  // 自定义日历类型
  @Prop calendarViewType: CalendarViewType = CalendarViewType.MONTH;
  // 自定义日历样式
  calendarStyle: CalendarStyle = {};
  // 年、月、周视图切换场景的相关设置
  calendarSwitch: CalendarSwitch = { isYearMonthHidden: false };
  // 年视图月份点击回调。返回年视图点击的年月信息。仅用于年视图。
  onMonthClick: (year: number, month: number) => void = () => {
  };
  // 日期点击回调。返回点击日期的年月日信息。仅用于月、周视图。
  onDateClick: (year: number, month: number, date: number) => void = () => {
  };
  // 年、月、周视图左右滑动切换回调。返回左右切换年、月、周后的年月信息，其中年视图切换实际只返回切换后年份信息。
  onChangeYearMonth: (year: number, month: number) => void = () => {
  };

  aboutToAppear() {
    // 月视图和周视图加载时，从持久化存储dataPreferences中获取应用的日程数据
    if (this.calendarViewType === CalendarViewType.MONTH || this.calendarViewType === CalendarViewType.WEEK) {
      let dataPreferences: preferences.Preferences | null = null;
      let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
      // Preferences实例配置选项,自定义Preferences实例的名称mySchedule
      let options: preferences.Options = { name: 'mySchedule' };
      // 获取Preferences实例
      dataPreferences = preferences.getPreferencesSync(context, options);
      // 检查缓存的Preferences实例中是否包含名为给定Key的存储键值对
      if (dataPreferences?.hasSync('schedule')) {
        // schedule如果存在，则获取schedule里所有日程数据，刷新到月视图和周视图上
        dataPreferences?.get('schedule', '', (err: BusinessError, val: preferences.ValueType) => {
          if (err) {
            return;
          }
          if (val !== '') {
            CommonData.SCHEDULE_DATA = JSON.parse(JSON.stringify(val));
            for (let i = 0; i < CommonData.SCHEDULE_DATA.length; i++) {
              TimeUtils.addSchedule(CommonData.SCHEDULE_DATA[i].startTime, CommonData.SCHEDULE_DATA[i].endTime);
            }
          }
          if (this.calendarViewType === CalendarViewType.WEEK) {
            // 获取到持久化日程数据之后，主动调用一次周视图数据刷新
            this.calendarSwitch.controller?.schedulePointRefresh();
          }
        })
      }
    }
  }

  build() {
    if (this.calendarViewType === CalendarViewType.YEAR) {
      // 年视图
      // onMonthClick：       年视图月份点击回调。返回年视图点击的年月信息。仅用于年视图。
      // onChangeYearMonth：  年、月、周视图左右滑动切换回调。返回左右切换年、月、周后的年月信息，其中年视图切换实际只返回切换后年份信息。
      // CalendarSwitch：     年、月、周视图切换场景的相关设置。
      // - controller：       自定义日历控制器，用于视图切换后的数据刷新。
      // - currentSelectDay： 记录月、周视图中点击选中的日期信息。
      // - isYearMonthHidden：是否隐藏自定义日历年、月、周视图中自带的年月信息标题。
      YearView({
        onMonthClick: (year: number, month: number) => {
          this.onMonthClick(year, month);
        },
        onChangeYearMonth: (year: number, month: number) => {
          this.onChangeYearMonth(year, month);
        },
        calendarSwitch: {
          controller: this.calendarSwitch.controller,
          currentSelectDay: this.calendarSwitch.currentSelectDay,
          isYearMonthHidden: this.calendarSwitch.isYearMonthHidden
        },
      })
    } else if (this.calendarViewType === CalendarViewType.MONTH) {
      // 月视图
      // CalendarStyle：      自定义日历样式。仅用于月、周视图。
      // - textScaling：      月视图和周视图中的公历、农历、星期、年月信息标题文字缩放比例。
      // - backgroundColor：  今天选中日期的背景色。
      // - monthDayColor：    本月公历日期颜色。
      // - noMonthDayColor：  非本月公历日期颜色，仅对月视图有效。
      // - lunarColor：       本月农历字体颜色。
      // onDateClick：        日期点击回调。返回点击日期的年月日信息。仅用于月、周视图。
      // onChangeYearMonth：  年、月、周视图左右滑动切换回调，返回左右切换视图后的年月信息，其中年视图切换实际只返回切换后年份信息。
      // CalendarSwitch：     用于年、月、周视图切换场景的相关设置。
      // - controller：       自定义日历控制器，用于视图切换后的数据刷新。
      // - currentSelectDay： 记录月、周视图中点击选中的日期信息。
      // - isYearMonthHidden：是否隐藏自定义日历年、月、周视图中自带的年月信息标题。
      MonthView({
        calendarStyle: {
          textScaling: this.calendarStyle.textScaling,
          backgroundColor: this.calendarStyle.backgroundColor,
          monthDayColor: this.calendarStyle.monthDayColor,
          noMonthDayColor: this.calendarStyle.noMonthDayColor,
          lunarColor: this.calendarStyle.lunarColor
        },
        onDateClick: (year: number, month: number, date: number) => {
          this.onDateClick(year, month, date);
        },
        onChangeYearMonth: (year: number, month: number) => {
          this.onChangeYearMonth(year, month);
        },
        calendarSwitch: {
          controller: this.calendarSwitch.controller,
          currentSelectDay: this.calendarSwitch.currentSelectDay,
          isYearMonthHidden: this.calendarSwitch.isYearMonthHidden
        }
      })
    } else if (this.calendarViewType === CalendarViewType.WEEK) {
      // 周视图
      // CalendarStyle：      自定义日历样式。仅用于月、周视图。
      // - textScaling：      月视图和周视图中的公历、农历、星期、年月信息标题文字缩放比例。
      // - backgroundColor：  今天选中日期的背景色。
      // - monthDayColor：    本月公历日期颜色。
      // - noMonthDayColor：  非本月公历日期颜色，仅对月视图有效。
      // - lunarColor：       本月农历字体颜色。
      // onDateClick：        日期点击回调。返回点击日期的年月日信息。仅用于月、周视图。
      // onChangeYearMonth：  年、月、周视图左右滑动切换回调，返回左右切换视图后的年月信息，其中年视图切换实际只返回切换后年份信息。
      // CalendarSwitch：     用于年、月、周视图切换场景的相关设置。
      // - controller：       自定义日历控制器，用于视图切换后的数据刷新。
      // - currentSelectDay： 记录月、周视图中点击选中的日期信息。
      // - isYearMonthHidden：是否隐藏自定义日历年、月、周视图中自带的年月信息标题。
      WeekView({
        calendarStyle: {
          textScaling: this.calendarStyle.textScaling,
          backgroundColor: this.calendarStyle.backgroundColor,
          monthDayColor: this.calendarStyle.monthDayColor,
          lunarColor: this.calendarStyle.lunarColor
        },
        onDateClick: (year: number, month: number, date: number) => {
          this.onDateClick(year, month, date);
        },
        onChangeYearMonth: (year: number, month: number) => {
          this.onChangeYearMonth(year, month);
        },
        calendarSwitch: {
          controller: this.calendarSwitch.controller,
          currentSelectDay: this.calendarSwitch.currentSelectDay,
          isYearMonthHidden: this.calendarSwitch.isYearMonthHidden
        }
      })
    }
  }
}

/**
 * 一天的信息
 */
@Observed
export class DayInfo {
  public year: number; // 年
  public month: number; // 月
  public date: number; // 日
  public week: number; // 月视图周信息。月视图上点击上个月日期进行月份切换时需要用到

  constructor(year: number, month: number, date: number, week: number) {
    this.year = year;
    this.month = month;
    this.date = date;
    this.week = week;
  }
}

/**
 * 自定义日历控制器。用于控制年、月、周视图间切换场景下刷新日期数据。
 */
export class CalendarController {
  // 视图刷新接口
  public swiperRefresh = (value: CalendarViewType) => {
  };
  // 视图刷新接口（仅用于在年视图上点击月份切换到月视图时刷新）
  public swiperYearToMonthRefresh = (year: number, month: number) => {
  };
  // 日程点数据刷新接口
  public schedulePointRefresh = () => {
  };
}

/**
 * 自定义日历类型：YEAR年视图 MONTH月视图 WEEK周视图
 */
export enum CalendarViewType {
  YEAR, // 年视图
  MONTH, // 月视图
  WEEK, // 周视图
}