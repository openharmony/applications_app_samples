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

import { CalendarViewType, CustomCalendar, DayInfo } from './customcalendar/components/CustomCalendar'; // 自定义日历组件
import display from '@ohos.display'; // 屏幕属性模块
import {
  $r,
  Alignment,
  BarPosition,
  Builder,
  Circle,
  ClickEvent,
  Color,
  Column,
  Component,
  Curve,
  Divider,
  FlexAlign,
  FontWeight,
  ForEach,
  HorizontalAlign,
  Margin,
  OnSwiperAnimationStartCallback,
  OnTabsAnimationStartCallback,
  Padding,
  PlayMode,
  px2vp,
  Row,
  Stack,
  Swiper,
  SwiperAnimationEvent,
  TabsAnimationEvent,
  TabContent,
  Tabs,
  TabsController,
  Text,
  TextAlign,animateTo
} from '@ohos.arkui.component';
import { Link, Prop, State, Watch } from '@ohos.arkui.stateManagement';
import common from '@ohos.app.ability.common';
import { UIContext } from '@ohos.arkui.UIContext';

// 布局权重
const LAYOUT_WEIGHT_ONE: number = 1;
const LAYOUT_WEIGHT_THREE: number = 3;
// 字体缩放倍数
const TEXT_SCALING: number = 0.95;
// 当前年
const TODAY_YEAR: number = new Date().getFullYear();
// 当前月
const TODAY_MONTH: number = new Date().getMonth() + 1;
// 内边距。和下面的自定义的分段按钮customSegmentButtonItem有关联
const PADDING: number = 15;
// 自定义分段按钮中Column宽度
const COLUMN_WIDTH: number = 50;
// 自定义分段按钮白色滑块空隙间距
const GAP_SPACE: number = 6;
// 自定义分段按钮'月'Text的宽度
const CUSTOM_SEGMENT_Button_MONTH_WIDTH: number = 30;
// 自定义分段按钮选中和未选中的字体粗细
const FONT_WEIGHT_FOUR_HUNDRED: number = 400;
const FONT_WEIGHT_FIVE_HUNDRED: number = 500;
// 月份数组
const MONTHS: string[] =
  ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"];
// 年月信息标题字体大小
const FONT_SIZE: number = 18;

/**
 * 功能描述：本示例介绍如何使用自定义日历组件CustomCalendar实现日历年视图，月视图，周视图以及视图切换功能。
 *
 * 推荐场景：需要使用左右滑动切换年视图，月视图，周视图
 *
 * 核心组件：
 * CustomCalendar
 *
 * 实现步骤：
 *  日历切换场景：
 *  1.使用Tabs进行年、月、周视图页面布局。
 *  2.调用自定义日历组件CustomCalendar组件分别在TabContent中显示对应年、月、周视图。
 *  3.点击自定义分段按钮customSegmentButton进行年、月、周视图间切换。
 */
@Component
export struct CustomCalendarSamplePage {
  // 屏幕宽度
  @State screenWidth: number = 0;
  // 当前显示的年份
  @State currentShowYear: number = TODAY_YEAR;
  // 当前显示的月份
  @State @Watch('monthChange') currentShowMonth: number = TODAY_MONTH;
  // 当前月视图或周视图中选中的日期
  @State currentSelectDay: DayInfo =
    new DayInfo(new Date().getFullYear(), new Date().getMonth() + 1, new Date().getDate(), 0);
  // 是否隐藏年、月、周视图中年月信息标题
  @State isYearMonthHidden: boolean = false;
  // 当前选中的自定义分段按钮。0年视图，1月视图,2周视图
  @State currentIndex: number = 1;
  // 自定义分段按钮左侧边距
  @State indicatorLeftMargin: number = 0;
  // 自定义分段按钮白色滑块宽度
  @State indicatorWidth: number = 0;
  // 记录自定义分段按钮切换的index。如果切换到年视图，隐藏年月信息标题中月份
  @State tabSelectedIndex: number = 1;
  // 自定义分段按钮滑动动画时长
  private animationDuration: number = 300;
  // Tabs控制器
  private tabController: TabsController = new TabsController();
  // 依据cases工程Navigation的mode属性说明，如使用Auto，窗口宽度>=600vp时，采用Split模式显示；窗口宽度<600vp时，采用Stack模式显示。
  private readonly DEVICESIZE: number = 600;
  // 不传isPlugin，默认为true。作为插件使用。设置false，适配cases。
  isPlugin: boolean = true;

  /**
   * 当前月份信息，用于自动化用例
   */
  monthChange(param:string) {
    // 当前显示的月份
    let month = this.currentShowMonth;
  }

  /**
   * 获取当前屏幕宽度
   */
  getCurrentScreenWidth(): number {
    let screenWidth: number = px2vp(display.getDefaultDisplaySync().width);
    // 适配cases中Navigation在不同mode时，计算相对需要使用的屏幕宽度。当屏幕宽度大于600vp时，cases工程Navigation的mode采用Split模式显示，需要重新计算实际页面所需的屏幕宽度。
    if (!this.isPlugin && screenWidth >= this.DEVICESIZE) {
      return screenWidth / 2;
    } else {
      return screenWidth;
    }
  }

  aboutToAppear() {
    // 获取屏幕宽度
    this.screenWidth = this.getCurrentScreenWidth();
    // 初始化自定义分段按钮白色滑块的位置，本案例默认首次加载显示月视图。由于onAreaChange获取indicatorLeftMargin有延迟，首次加载会出现白色滑块跳变，所以这里计算indicatorLeftMargin的初始位置。
    this.indicatorLeftMargin = (this.screenWidth - COLUMN_WIDTH) / 2 - PADDING;
  }

  /**
   * 年月信息标题。月视图和周视图显示年月信息，年视图只显示年信息。周视图中如果选中了日期，则优先根据选中日期显示年月信息。
   */
  @Builder
  yearMonthTitle() {
    Row() {
      Text(`${this.currentShowYear}年 ${this.tabSelectedIndex === CalendarViewType.YEAR ? '' :
      MONTHS[this.currentShowMonth-1]}`)
        .fontSize(FONT_SIZE * TEXT_SCALING)
        .fontWeight(FONT_WEIGHT_FIVE_HUNDRED)
    }
    .padding({ left: 10, right: 10 } as Padding)
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .height(30)
  }

  /**
   * 自定义分段按钮。这里不使用SegmentButtonOptions分段按钮是因为在年视图中点击月份，想实现从'年'滑动到'月'按钮的动效，但是
   * SegmentButtonOptions只支持点击操作才有滑动切换动效。这里自定义分段按钮的切换动画参考自定义TabBar的切换动画实现https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/ts-container-tabs-V5#%E7%A4%BA%E4%BE%8B9
   */
  @Builder
  customSegmentButton() {
    Stack({ alignContent: Alignment.TopStart }) {
      Row() {
      }
      .width('100%')
      .height(35)
      .backgroundColor($r('app.color.calendar_switch_segment_button_row_bgcolor'))
      .borderRadius(20)
      .layoutWeight(LAYOUT_WEIGHT_THREE)

      Column() {
        Row() {
        }
        .borderRadius(20)
        .height('100%')
        .width((this.screenWidth - PADDING * 2) / 3 - GAP_SPACE)
        .backgroundColor(Color.White)
      }
      .height(35)
      .width(COLUMN_WIDTH)
      .margin({ left: this.indicatorLeftMargin } as Margin)
      .padding({ top: 3, bottom: 3 } as Padding)

      Row() {
        this.customSegmentButtonItem(CalendarViewType.YEAR, '年')
        this.customSegmentButtonItem(CalendarViewType.MONTH, '月')
        this.customSegmentButtonItem(CalendarViewType.WEEK, '周')
      }
      .width('100%')
      .height(35)
      .borderRadius(20)
      .backgroundColor(Color.Transparent)
      .layoutWeight(LAYOUT_WEIGHT_THREE)
    }
    .width('100%')
    .height(35)
    .margin({ top: 10, bottom: 12 } as Margin)
  }

  /**
   * 自定义分段按钮项
   * @param index 自定义分段按钮索引。这里对应自定义日历视图类型。0：年视图YEAR，1：月视图MONTH，2：周视图WEEK
   * @param name 自定义分段按钮名。这里对应'年'，'月'，'周'
   */
  @Builder
  customSegmentButtonItem(index: number, name: string) {
    Column() {
      Text(name)
        .width(CUSTOM_SEGMENT_Button_MONTH_WIDTH)
        .textAlign(TextAlign.Center)
        .height(35)
        .fontSize(14)
        .fontColor(this.currentIndex === index ? Color.Black :
        $r('app.color.calendar_switch_segment_button_font_color'))
        .fontWeight(this.currentIndex === index ? FONT_WEIGHT_FIVE_HUNDRED : FONT_WEIGHT_FOUR_HUNDRED)
    }
    .id(index === 0 ? 'year' : (index === 1 ? 'month' : 'week'))
    .width('100%')
    .height(35)
    .layoutWeight(LAYOUT_WEIGHT_ONE)
    .onClick((e: ClickEvent) => {
      if (index === this.tabSelectedIndex) {
        // 点击同一个自定义分段按钮项，不做切换，避免冗余操作
        return;
      }
      this.tabSelectedIndex = index;
      this.tabController.changeIndex(index);
      this.currentShowYear = this.currentSelectDay.year;
      this.currentShowMonth = this.currentSelectDay.month;
    })
  }

  /**
   * 自定义分段按钮切换动画
   * @param duration 动画时长
   * @param leftMargin 自定义分段按钮左侧边距
   */
  startAnimateTo(duration: number, leftMargin: number) {
    animateTo({
      duration: duration, // 动画时长
      curve: Curve.Linear, // 动画曲线
      iterations: 1, // 播放次数
      playMode: PlayMode.Normal, // 动画模式
    }, () => {
      this.indicatorLeftMargin = leftMargin;
    })
  }

  build() {
    Column() {
      // 自定义分段按钮
      this.customSegmentButton()

      Tabs({ barPosition: BarPosition.End, index: this.currentIndex, controller: this.tabController }) {
        TabContent() {
          Column() {
            CustomCalendar({
              CalendarViewType: CalendarViewType.YEAR,
              onMonthClick: (year: number, month: number) => {
                if (this.tabController) {
                  // 刷新年月信息标题
                  this.currentShowYear = year;
                  this.currentShowMonth = month;
                }
              },
              onChangeYearMonth: (year: number, month: number) => {
                this.currentShowYear = year;
                // 当前显示的年，用于自动化用例
                let currentYear = year;
              },
              calendarSwitch: {
                currentSelectDay: this.currentSelectDay,
                isYearMonthHidden: this.isYearMonthHidden
              }
            })
          }
          .width('100%')
          .height('100%')
        }

        TabContent() {
          Column() {
            CustomCalendar({
              CalendarViewType: CalendarViewType.MONTH,
              CalendarStyle: {
                backgroundColor: Color.Red,
                monthDayColor: Color.Black,
                noMonthDayColor: Color.Gray,
              },
              onDateClick: (year: number, month: number, date: number) => {
                this.currentSelectDay.year = year;
                this.currentSelectDay.month = month;
                this.currentSelectDay.date = date;
                // 当前选中的日期信息，用于自动化用例
                let selectDate = date;
                let selectYear = year;
              },
              onChangeYearMonth: (year: number, month: number) => {
                this.currentShowYear = year;
                this.currentShowMonth = month;
              },
              calendarSwitch: {
                currentSelectDay: this.currentSelectDay,
                isYearMonthHidden: this.isYearMonthHidden,
              }
            })
          }
          .width('100%')
          .height('100%')
        }

        TabContent() {
          Column() {
            CustomCalendar({
              CalendarViewType: CalendarViewType.WEEK,
              CalendarStyle: {
                backgroundColor: Color.Red,
                monthDayColor: Color.Black,
              },
              onDateClick: (year: number, month: number, date: number) => {
                this.currentSelectDay.year = year;
                this.currentSelectDay.month = month;
                this.currentSelectDay.date = date;
              },
              onChangeYearMonth: (year: number, month: number) => {
                this.currentShowYear = year;
                this.currentShowMonth = month;
              },
              calendarSwitch: {
                currentSelectDay: this.currentSelectDay,
                isYearMonthHidden: this.isYearMonthHidden
              }
            })
          }
          .width('100%')
          .height('100%')
        }
      }
      .animationDuration(this.animationDuration)
      .onAnimationStart((index: number, targetIndex: number, event: TabsAnimationEvent) => {
        // 在年视图中点击月，切换到月视图时，需要显示'年月信息标题'中的的月份信息
        if (index === CalendarViewType.YEAR && targetIndex === CalendarViewType.MONTH) {
          this.tabSelectedIndex = CalendarViewType.MONTH;
        }
        // 切换动画开始时触发该回调。白色滑块跟着页面一起滑动。
        this.currentIndex = targetIndex;
        if (targetIndex === CalendarViewType.YEAR) {
          // 传入自定义分段按钮左侧边距 点击“年”的分段按钮时，分段按钮白色滑块移动到屏幕1/6位置
          this.startAnimateTo(this.animationDuration, (this.screenWidth - PADDING * 2) / 6 * 1 - COLUMN_WIDTH / 2);
        } else if (targetIndex === CalendarViewType.MONTH) {
          // 传入自定义分段按钮左侧边距 点击“月”的分段按钮时，分段按钮白色滑块移动到屏幕3/6位置
          this.startAnimateTo(this.animationDuration, (this.screenWidth - PADDING * 2) / 2 - COLUMN_WIDTH / 2);
        } else if (targetIndex === CalendarViewType.WEEK) {
          // 传入自定义分段按钮左侧边距 点击“周”的分段按钮时，分段按钮白色滑块移动到屏幕5/6位置
          this.startAnimateTo(this.animationDuration, (this.screenWidth - PADDING * 2) / 6 * 5 - COLUMN_WIDTH / 2);
        }
      } as OnTabsAnimationStartCallback)
      .onAppear(() => {
        // 针对月视图切换周视图场景，需要预加载周视图（索引2），不然在月视图切换月份，选择日期后，再切换到周视图，周视图不会刷新
        this.tabController.preloadItems([0, 2]); // 索引0对应年视图，索引2对应周视图
      })
      .layoutWeight(LAYOUT_WEIGHT_ONE)
      .scrollable(false)
      .barHeight(0)
    }
    .width('100%')
    .height('100%')
    .padding(PADDING)
  }
}