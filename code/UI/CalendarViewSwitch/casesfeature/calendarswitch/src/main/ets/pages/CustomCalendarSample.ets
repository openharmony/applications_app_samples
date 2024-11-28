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

import {
  CustomCalendar, // 自定义日历组件
  CalendarViewType, // 自定义日历类型：年视图YEAR，月视图MONTH，周视图WEEK。
  CalendarController, // 自定义日历控制器。用于控制年、月、周视图间切换场景下刷新日期数据。
  DayInfo // 日期信息类
} from '../customcalendar/components/CustomCalendar'; // 自定义日历组件
import { SchedulePoint } from '../customcalendar/components/SchedulePoint'; // 自定义添加日程组件
import { display } from '@kit.ArkUI'; // 屏幕属性模块
import CommonData from '../customcalendar/common/CommonData';
import { DeviceType } from '../customcalendar/model/CalendarModel';

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
const CUSTOM_SEGMENT_BUTTON_MONTH_WIDTH: number = 30;
// 自定义分段按钮选中和未选中的字体粗细
const FONT_WEIGHT_FOUR_HUNDRED: number = 400;
const FONT_WEIGHT_FIVE_HUNDRED: number = 500;
// 月份数组
const MONTHS: string[] =
  ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'];
// 年月信息标题字体大小
const FONT_SIZE: number = 18;

/**
 * 功能描述：本示例介绍如何使用自定义日历组件CustomCalendar实现日历年视图，月视图，周视图以及视图切换功能。还有如何使用Calendar Kit日历服务实现日程提醒的功能。
 *
 * 推荐场景：需要使用左右滑动切换年视图，月视图，周视图以及需要添加日程提醒的应用场景
 *
 * 核心组件：
 * 1.CustomCalendar
 * 2.SchedulePoint
 *
 * 实现步骤：
 *  日历切换场景：
 *  1.使用Tabs进行年、月、周视图页面布局。
 *  2.调用自定义日历组件CustomCalendar组件分别在TabContent中显示对应年、月、周视图。
 *  3.点击自定义分段按钮customSegmentButton进行年、月、周视图间切换。使用视图控制器的swiperRefresh方法刷新对应视图数据。
 *  日程提醒场景：
 *  1.通过getCalendarManager获取管理日历对象，使用getCalendar获取日历对象，然后使用createCalendar创建自己的日历账户，通过配置
 *  CalendarConfig中enableReminder为true启用日程提醒功能。
 *  2.配置日程参数calendarManager.Event，然后传入addEvent创建日程，Calendar Kit日历服务会根据创建的日程进行相应的日程提醒。同时使用持久
 *  化preferences存储添加的日程信息，用于月视图和周视图中显示相应的日程点。
 */
@Component
export struct CustomCalendarSamplePage {
  // 屏幕宽度
  @State screenWidth: number = 0;
  // 当前显示的年份
  @State currentShowYear: number = TODAY_YEAR;
  // 当前显示的月份
  @State currentShowMonth: number = TODAY_MONTH;
  // 当前月视图或周视图中选中的日期
  @State currentSelectDay: DayInfo =
    new DayInfo(new Date().getFullYear(), new Date().getMonth() + 1, new Date().getDate(), 0);
  // 是否隐藏年、月、周视图中年月信息标题
  @State isYearMonthHidden: boolean = true;
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
  // 自定义日历年视图控制器
  private calendarYearController = new CalendarController();
  // 自定义日历月视图控制器
  private calendarMonthController = new CalendarController();
  // 自定义日历周视图控制器
  private calendarWeekController = new CalendarController();
  // 检查设备是否可折叠
  private isFoldable: boolean = false;
  // 折叠设备屏幕显示模式回调
  private callback: Callback<display.FoldDisplayMode> = (mode: display.FoldDisplayMode) => {
    // 可折叠设备的显示模式改变时(如展开或者折叠)，重新获取屏幕宽度
    this.screenWidth = this.getCurrentScreenWidth();
    // 重新计算indicatorLeftMargin
    if (this.currentIndex === CalendarViewType.YEAR) {
      this.indicatorLeftMargin = (this.screenWidth - PADDING * 2) / 6 * 1 - COLUMN_WIDTH / 2;
    } else if (this.currentIndex === CalendarViewType.MONTH) {
      this.indicatorLeftMargin = (this.screenWidth - PADDING * 2) / 2 - COLUMN_WIDTH / 2;
    } else if (this.currentIndex === CalendarViewType.WEEK) {
      this.indicatorLeftMargin = (this.screenWidth - PADDING * 2) / 6 * 5 - COLUMN_WIDTH / 2;
    }
    if (mode === display.FoldDisplayMode.FOLD_DISPLAY_MODE_FULL) {
      // 折叠屏展开态显示
      CommonData.DEVICE_TYPE = DeviceType.EXPAND_FOLD;
    } else if (mode === display.FoldDisplayMode.FOLD_DISPLAY_MODE_MAIN) {
      // 折叠屏折叠态显示
      CommonData.DEVICE_TYPE = DeviceType.PHONE;
    }
  };
  // 依据cases工程Navigation的mode属性说明，如使用Auto，窗口宽度>=600vp时，采用Split模式显示；窗口宽度<600vp时，采用Stack模式显示。
  private readonly DEVICESIZE: number = 600;
  // 不传isPlugin，默认为true。作为插件使用。设置false，适配cases。
  isPlugin: boolean = true;

  /**
   * 获取当前屏幕宽度
   */
  getCurrentScreenWidth(): number {
    let screenWidth: number = px2vp(display.getDefaultDisplaySync().width);
    // 适配cases中Navigation在不同mode时，计算相对需要使用的屏幕宽度。当屏幕宽度大于600vp时，cases工程Navigation的mode采用Split模式显
    // 示，需要重新计算实际页面所需的屏幕宽度。
    if (!this.isPlugin && screenWidth >= this.DEVICESIZE) {
      return screenWidth / 2;
    } else {
      return screenWidth;
    }
  }

  aboutToAppear() {
    // 检查设备是否可折叠。false表示不可折叠，true表示可折叠。
    this.isFoldable = display.isFoldable();
    CommonData.IS_FOLD = this.isFoldable;
    if (this.isFoldable) {
      // 如果是可折叠设备，注册折叠设备屏幕显示模式变化监听
      display.on('foldDisplayModeChange', this.callback);
      if (display.getFoldDisplayMode() === display.FoldDisplayMode.FOLD_DISPLAY_MODE_FULL) {
        // 设置折叠屏展开态
        CommonData.DEVICE_TYPE = DeviceType.EXPAND_FOLD;
      }
    }
    // 获取屏幕宽度
    this.screenWidth = this.getCurrentScreenWidth();
    // 初始化自定义分段按钮白色滑块的位置，本案例默认首次加载显示月视图。由于onAreaChange获取indicatorLeftMargin有延迟，首次加载会出现白色
    // 滑块跳变，所以这里计算indicatorLeftMargin的初始位置。
    this.indicatorLeftMargin = (this.screenWidth - COLUMN_WIDTH) / 2 - PADDING;
    // 判断是否是rk3568。用屏幕宽度480vp来判断
    if (px2vp(display.getDefaultDisplaySync().width) === 480) {
      CommonData.DEVICE_TYPE = DeviceType.RK;
    }
  }

  aboutToDisappear() {
    if (this.isFoldable) {
      // 关闭显示设备变化的监听
      display.off('foldDisplayModeChange', this.callback);
    }
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
      // 自定义添加日程组件
      // monthViewController：     可选项。传入该控制器，添加日程后，对应日程点会刷新到月视图上
      // weekViewController：      可选项。传入该控制器，添加日程后，对应日程点会刷新到周视图上
      SchedulePoint({
        monthViewController: this.calendarMonthController,
        weekViewController: this.calendarWeekController
      })
    }
    .padding({ left: $r('app.integer.calendar_switch_size_ten'), right: $r('app.integer.calendar_switch_size_ten') })
    .justifyContent(FlexAlign.SpaceBetween)
    .width($r('app.string.calendar_switch_full_size'))
    .height($r('app.integer.calendar_switch_size_thirty'))
  }

  /**
   * 自定义分段按钮
   */
  @Builder
  customSegmentButton() {
    Stack({ alignContent: Alignment.TopStart }) {
      Row() {
      }
      .width($r('app.string.calendar_switch_full_size'))
      .height($r('app.integer.calendar_switch_size_thirty_five'))
      .backgroundColor($r('app.color.calendar_switch_segment_button_row_bgcolor'))
      .borderRadius($r('app.integer.calendar_switch_border_radius'))
      .layoutWeight(LAYOUT_WEIGHT_THREE)

      Column() {
        Row() {
        }
        .borderRadius($r('app.integer.calendar_switch_border_radius'))
        .height($r('app.string.calendar_switch_full_size'))
        .width((this.screenWidth - PADDING * 2) / 3 - GAP_SPACE)
        .backgroundColor(Color.White)
      }
      .height($r('app.integer.calendar_switch_size_thirty_five'))
      .width(COLUMN_WIDTH)
      .margin({ left: this.indicatorLeftMargin })
      .padding({
        top: $r('app.integer.calendar_switch_size_three'),
        bottom: $r('app.integer.calendar_switch_size_three')
      })

      Row() {
        this.customSegmentButtonItem(CalendarViewType.YEAR, '年')
        this.customSegmentButtonItem(CalendarViewType.MONTH, '月')
        this.customSegmentButtonItem(CalendarViewType.WEEK, '周')
      }
      .width($r('app.string.calendar_switch_full_size'))
      .height($r('app.integer.calendar_switch_size_thirty_five'))
      .borderRadius($r('app.integer.calendar_switch_border_radius'))
      .backgroundColor(Color.Transparent)
      .layoutWeight(LAYOUT_WEIGHT_THREE)
    }
    .width($r('app.string.calendar_switch_full_size'))
    .height($r('app.integer.calendar_switch_size_thirty_five'))
    .margin({
      top: $r('app.integer.calendar_switch_size_ten'),
      bottom: $r('app.integer.calendar_switch_margin_size_twelve')
    })
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
        .width(CUSTOM_SEGMENT_BUTTON_MONTH_WIDTH)
        .textAlign(TextAlign.Center)
        .height($r('app.integer.calendar_switch_size_thirty_five'))
        .fontSize($r('app.integer.calendar_switch_size_fourteen'))
        .fontColor(this.currentIndex === index ? Color.Black :
        $r('app.color.calendar_switch_segment_button_font_color'))
        .fontWeight(this.currentIndex === index ? FONT_WEIGHT_FIVE_HUNDRED : FONT_WEIGHT_FOUR_HUNDRED)
    }
    .width($r('app.string.calendar_switch_full_size'))
    .height($r('app.integer.calendar_switch_size_thirty_five'))
    .layoutWeight(LAYOUT_WEIGHT_ONE)
    .onClick(() => {
      if (index === this.tabSelectedIndex) {
        // 点击同一个自定义分段按钮项，不做切换，避免冗余操作
        return;
      }
      this.tabSelectedIndex = index;
      this.tabController.changeIndex(index);
      this.currentShowYear = this.currentSelectDay.year;
      this.currentShowMonth = this.currentSelectDay.month;
      // TODO 知识点：点击自定义分段按钮customSegmentButton进行年、月、周视图间切换。使用视图控制器的swiperRefresh方法刷新对应视图数据。
      if (this.tabSelectedIndex === CalendarViewType.MONTH) {
        // 刷新月视图
        this.calendarMonthController.swiperRefresh(CalendarViewType.MONTH);
      } else if (this.tabSelectedIndex === CalendarViewType.WEEK) {
        // 刷新周视图
        this.calendarWeekController.swiperRefresh(CalendarViewType.WEEK);
      } else if (this.tabSelectedIndex === CalendarViewType.YEAR) {
        // 刷新年视图
        this.calendarYearController.swiperRefresh(CalendarViewType.YEAR);
      }
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
      // 年月信息标题（包含添加日程组件）
      this.yearMonthTitle()
      // 自定义分段按钮
      this.customSegmentButton()

      Tabs({ barPosition: BarPosition.End, index: CalendarViewType.MONTH, controller: this.tabController }) {
        TabContent() {
          Column() {
            // 自定义年视图
            // calendarViewType：   必选项。自定义日历类型。YEAR年视图 MONTH月视图 WEEK周视图
            // onMonthClick：       可选项。年视图月份点击回调。返回年视图点击的年月信息。仅用于年视图。
            // onChangeYearMonth：  可选项。年、月、周视图左右滑动切换回调。返回左右切换年、月、周后的年月信息，其中年视图切换实际只返回切换后年份信息。
            // calendarSwitch：     可选项。年、月、周视图切换场景的相关设置。
            // - controller：       可选项。自定义日历控制器，用于视图切换后的数据刷新。
            // - currentSelectDay： 可选项。记录月、周视图中点击选中的日期信息。
            // - isYearMonthHidden：可选项。是否隐藏自定义日历年、月、周视图中自带的年月信息标题。
            CustomCalendar({
              calendarViewType: CalendarViewType.YEAR,
              onMonthClick: (year: number, month: number) => {
                if (this.tabController) {
                  // 切到月视图
                  this.tabController.changeIndex(1);
                  // 刷新年月信息标题
                  this.currentShowYear = year;
                  this.currentShowMonth = month;
                  // 刷新在年视图上点击月后要跳转的月视图数据
                  this.calendarMonthController.swiperYearToMonthRefresh(year, month);
                }
              },
              onChangeYearMonth: (year: number, month: number) => {
                this.currentShowYear = year;
              },
              calendarSwitch: {
                controller: this.calendarYearController,
                currentSelectDay: this.currentSelectDay,
                isYearMonthHidden: this.isYearMonthHidden
              }
            })
          }
          .width($r('app.string.calendar_switch_full_size'))
          .height($r('app.string.calendar_switch_full_size'))
        }

        TabContent() {
          Column() {
            // 自定义月视图
            // calendarViewType：   必选项。自定义日历类型。YEAR年视图 MONTH月视图 WEEK周视图
            // calendarStyle：      可选项。自定义日历样式。仅用于月、周视图。
            // - textScaling：      可选项。月视图和周视图中的公历、农历、星期、年月信息标题文字缩放比例。
            // - backgroundColor：  可选项。今天选中日期的背景色。
            // - monthDayColor：    可选项。本月公历日期颜色。
            // - noMonthDayColor：  可选项。非本月公历日期颜色，仅对月视图有效。
            // - lunarColor：       可选项。本月农历字体颜色。
            // onDateClick：        可选项。日期点击回调。返回点击日期的年月日信息。仅用于月、周视图。
            // onChangeYearMonth：  可选项。年、月、周视图左右滑动切换回调，返回左右切换视图后的年月信息，其中年视图切换实际只返回切换后年份信息。
            // calendarSwitch：     可选项。用于年、月、周视图切换场景的相关设置。
            // - controller：       可选项。自定义日历控制器，用于视图切换后的数据刷新。
            // - currentSelectDay： 可选项。记录月、周视图中点击选中的日期信息。
            // - isYearMonthHidden：可选项。是否隐藏自定义日历年、月、周视图中自带的年月信息标题。
            CustomCalendar({
              calendarViewType: CalendarViewType.MONTH,
              calendarStyle: {
                textScaling: TEXT_SCALING,
                backgroundColor: Color.Red,
                monthDayColor: Color.Black,
                noMonthDayColor: Color.Gray,
                lunarColor: Color.Gray
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
                controller: this.calendarMonthController,
                currentSelectDay: this.currentSelectDay,
                isYearMonthHidden: this.isYearMonthHidden,
              }
            })
          }
          .width($r('app.string.calendar_switch_full_size'))
          .height($r('app.string.calendar_switch_full_size'))
        }

        TabContent() {
          Column() {
            // 自定义周视图
            // calendarViewType：   必选项。自定义日历类型。YEAR年视图 MONTH月视图 WEEK周视图
            // calendarStyle：      可选项。自定义日历样式。仅用于月、周视图。
            // - textScaling：      可选项。月视图和周视图中的公历、农历、星期、年月信息标题文字缩放比例。
            // - backgroundColor：  可选项。今天选中日期的背景色。
            // - monthDayColor：    可选项。本月公历日期颜色。
            // - noMonthDayColor：  可选项。非本月公历日期颜色，仅对月视图有效。
            // - lunarColor：       可选项。本月农历字体颜色。
            // onDateClick：        可选项。日期点击回调。返回点击日期的年月日信息。仅用于月、周视图。
            // onChangeYearMonth：  可选项。年、月、周视图左右滑动切换回调，返回左右切换视图后的年月信息，其中年视图切换实际只返回切换后年份信息。
            // calendarSwitch：     可选项。用于年、月、周视图切换场景的相关设置。
            // - controller：       可选项。自定义日历控制器，用于视图切换后的数据刷新。
            // - currentSelectDay： 可选项。记录月、周视图中点击选中的日期信息。
            // - isYearMonthHidden：可选项。是否隐藏自定义日历年、月、周视图中自带的年月信息标题。
            CustomCalendar({
              calendarViewType: CalendarViewType.WEEK,
              calendarStyle: {
                textScaling: TEXT_SCALING,
                backgroundColor: Color.Red,
                monthDayColor: Color.Black,
                lunarColor: Color.Gray
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
                controller: this.calendarWeekController,
                currentSelectDay: this.currentSelectDay,
                isYearMonthHidden: this.isYearMonthHidden
              }
            })
          }
          .width($r('app.string.calendar_switch_full_size'))
          .height($r('app.string.calendar_switch_full_size'))
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
      })
      .onAppear(() => {
        // TODO: 高性能知识点: 组件挂载显示后触发此回调,预加载年视图数据，避免首次切换到年视图时出现卡顿问题
        // 针对月视图切换周视图场景，需要预加载周视图（索引2），不然在月视图切换月份，选择日期后，再切换到周视图，周视图不会刷新
        this.tabController.preloadItems([0, 2]); // 索引0对应年视图，索引2对应周视图
      })
      .layoutWeight(LAYOUT_WEIGHT_ONE)
      .scrollable(false)
      .barHeight($r('app.integer.calendar_switch_zero'))
    }
    .width($r('app.string.calendar_switch_full_size'))
    .height($r('app.string.calendar_switch_full_size'))
    .padding(PADDING)
  }
}