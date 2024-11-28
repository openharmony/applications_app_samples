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
import { CalendarStyle, CalendarSwitch } from '../model/CalendarModel';
import { MonthViewItem } from './MonthViewItem';
import { TimeUtils } from '../utils/TimeUtils';
import CommonData from '../common/CommonData';

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
  // 添加日程后，重新刷新月视图的控制器
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
    if (value === CalendarViewType.MONTH) {
      if (this.calendarSwitch.currentSelectDay) {
        // 重置swiper索引
        this.swiperMonthIndex = 1;
        this.oldMonthViewIndex = 1;
        // 获取当前选中的日期
        this.currentSelectDate =
          this.calendarSwitch.currentSelectDay.year + '-' + this.calendarSwitch.currentSelectDay.month + '-' +
          this.calendarSwitch.currentSelectDay.date;
        // 更新年月数据
        this.currentShowYear = this.calendarSwitch.currentSelectDay.year;
        this.currentShowMonth = this.calendarSwitch.currentSelectDay.month;
        this.currentYearMonth =
          this.calendarSwitch.currentSelectDay.year + '-' + this.calendarSwitch.currentSelectDay.month;
        this.lastYearMonth = TimeUtils.getLastYearMonth(this.calendarSwitch.currentSelectDay.year,
          this.calendarSwitch.currentSelectDay.month);
        this.nextYearMonth = TimeUtils.getNextYearMonth(this.calendarSwitch.currentSelectDay.year,
          this.calendarSwitch.currentSelectDay.month);
      }
    }
  }
  /**
   * 用于刷新在年视图上点击月后要跳转的月视图数据
   */
  private swiperYearToMonthRefresh = (year: number, month: number) => {
    // 重置swiper索引
    this.swiperMonthIndex = 1;
    this.oldMonthViewIndex = 1;
    // 更新年月数据
    this.currentShowYear = year;
    this.currentShowMonth = month;
    this.currentYearMonth = year + '-' + month;
    this.lastYearMonth = TimeUtils.getLastYearMonth(year, month);
    this.nextYearMonth = TimeUtils.getNextYearMonth(year, month);
  }
  /**
   * 用于添加日程后，重刷月视图数据
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
      this.calendarSwitch.controller.swiperYearToMonthRefresh = this.swiperYearToMonthRefresh;
      this.calendarSwitch.controller.schedulePointRefresh = this.schedulePointRefresh;
    }
  }

  /**
   * 日期选择改变
   */
  onSelectDayChange() {
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
          .fontSize(Constants.WEEK_FONT_SIZE *
            (this.calendarStyle.textScaling ? this.calendarStyle.textScaling : Constants.FONT_MULTIPLIER))
          .fontColor((index === 0 || index === 6) ? Color.Grey : Color.Black)
          .width($r('app.integer.calendar_switch_size_forty'))
          .textAlign(TextAlign.Center)
      }, (text: string) => text)
    }
    .width(Constants.MONTH_VIEW_WIDTH)
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
        // 月视图子组件
        MonthViewItem({
          yearMonth: this.lastYearMonth,
          currentSelectDate: this.currentSelectDate,
          onDateClick: (year: number, month: number, date: number) => {
            this.onDateClick(year, month, date);
          },
          calendarStyle: {
            textScaling: this.calendarStyle.textScaling,
            backgroundColor: this.calendarStyle.backgroundColor,
            monthDayColor: this.calendarStyle.monthDayColor,
            noMonthDayColor: this.calendarStyle.noMonthDayColor,
            lunarColor: this.calendarStyle.lunarColor
          },
          controller: this.oneController
        })
        MonthViewItem({
          yearMonth: this.currentYearMonth,
          currentSelectDate: this.currentSelectDate,
          onDateClick: (year: number, month: number, date: number) => {
            this.onDateClick(year, month, date);
          },
          calendarStyle: {
            textScaling: this.calendarStyle.textScaling,
            backgroundColor: this.calendarStyle.backgroundColor,
            monthDayColor: this.calendarStyle.monthDayColor,
            noMonthDayColor: this.calendarStyle.noMonthDayColor,
            lunarColor: this.calendarStyle.lunarColor
          },
          controller: this.twoController
        })
        MonthViewItem({
          yearMonth: this.nextYearMonth,
          currentSelectDate: this.currentSelectDate,
          onDateClick: (year: number, month: number, date: number) => {
            this.onDateClick(year, month, date);
          },
          calendarStyle: {
            textScaling: this.calendarStyle.textScaling,
            backgroundColor: this.calendarStyle.backgroundColor,
            monthDayColor: this.calendarStyle.monthDayColor,
            noMonthDayColor: this.calendarStyle.noMonthDayColor,
            lunarColor: this.calendarStyle.lunarColor
          },
          controller: this.threeController
        })
      }
      .onAnimationStart((index: number, targetIndex: number, extraInfo: SwiperAnimationEvent) => {
        /**
         * TODO 知识点：年视图，月视图和周视图都是根据Swiper的onAnimationStart事件（切换动画开始时触发该回调）进行年，月或周的切换。以月
         * 视图为例，通过oldMonthViewIndex存储上一次的Swiper索引值，然后跟本次切换的索引targetIndex进行比较，来识别月份是左滑还是右滑。
         * 然后根据当前切换后的索引值去刷新所需的月份。例如，假设swiper索引0（7月），swiper索引1（8月），swiper索引2（9月），当前Swiper
         * 显示的索引为1。当Swiper右滑从索引1（8月）切换到索引0（7月）时，需要把Swiper里索引2（9月）的月份更新为6月的数据。年视图和周视图
         * 的onAnimationStart也是类似处理逻辑，这里不再赘述。
         */
        if (this.oldMonthViewIndex === targetIndex) {
          // 如果手指滑动swiper松开时，targetIndex和之前记录子组件索引oldMonthViewIndex一样，说明swiper没有切换子组件，不需要切换月份
          return;
        }
        // 记录子组件索引
        this.oldMonthViewIndex = targetIndex;
        // 判断是否右滑切换月份
        const IS_RIGHT_SLIDE: boolean = (index === 1 && targetIndex === 0) || (index === 0 && targetIndex === 2) ||
          (index === 2 && targetIndex === 1);
        // TODO: 高性能知识点: 左右滑动切换月时，每次切换月只更新一个月的数据，以优化月视图左右切换时的性能。年视图和周视图也类似，这里不再赘述。
        // 右滑切换到上个月
        if (IS_RIGHT_SLIDE) {
          // 将当前月份设置为上个月
          this.currentShowYear = TimeUtils.getLastYear(this.currentShowYear, this.currentShowMonth);
          this.currentShowMonth = TimeUtils.getLastMonth(this.currentShowYear, this.currentShowMonth);
          this.onChangeYearMonth(this.currentShowYear, this.currentShowMonth);
          if (targetIndex === 0) {
            /**
             * swiper索引右滑到0时，修改swiper索引2的月份为当前月份（索引0）的上一个月。比如，假设swiper索引0（7月），swiper索引1（8月）
             * ，swiper索引2（9月）。当右滑切换到索引0（7月）时，需要把索引2（9月）的月份改成6月。
             */
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
      })
      .indicator(false)
      .loop(true)
      .index($$this.swiperMonthIndex)
    }
    .width(Constants.MONTH_VIEW_WIDTH)
    .height(Constants.MONTH_VIEW_HEIGHT)
  }
}