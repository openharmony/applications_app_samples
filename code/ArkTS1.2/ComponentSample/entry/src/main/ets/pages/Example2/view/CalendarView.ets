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
import { DateModel } from '../components/DateModel';
import { getRealTimeDate, getMonthDate } from '../components/GetDate';
import promptAction from '@ohos.promptAction';
import {
  memo,
  __memo_context_type,
  __memo_id_type
} from '@ohos.arkui.stateManagement';
import {
  Text,
  TextAttribute,
  Column,
  FlexAlign,
  Component,
  Button,
  ButtonAttribute,
  ClickEvent,
  List,
  ListItem,
  Image,
  Tabs,
  TabContent,
  Row,
  ButtonType,
  Builder,
  CustomDialogController,
  DismissDialogAction,
  DialogAlignment,
  $r,
  Resource,
  Entry,
  TextInput,
  Scroller,
  Flex,
  HorizontalAlign,
  SafeAreaType,
  SafeAreaEdge,
  FlexWrap,
  TextAlign,
  ForEach,
  Scroll,
  Color,
  Span,
  ItemAlign,
  Margin
} from '@ohos.arkui.component';
import { State, Link, StorageLink, Consume } from '@ohos.arkui.stateManagement';
import hilog from '@ohos.hilog';
import { Context, UIContext } from '@ohos.arkui.UIContext';
import { Month, MonthDataSource } from '../components/MonthDataSource';

const ELEMENTS_MARGIN_L = 24;
const ELEMENTS_MARGIN_M = 8;
const TRANSITION_DURATION = 200;
const MONDAY = '一';
const TUESDAY = '二';
const WEDNESDAY = '三';
const THURSDAY = '四';
const FRIDAY = '五';
const SATURDAY = '六';
const SUNDAY = '日';
const WEEK: string[] = [SUNDAY, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY]; // 设置日历周，从周日开始
const MONTH: string = '月';
const YEAR: string = '年';
const MONTHS = 12;
const JANUARY = 1;
const WEEK_NUMBER = 7;
const MONTH_NUMBER = 35;
const GRID_HEIGHT_L = 360;
const GRID_HEIGHT_M = 300;
const ELEMENTS_MARGIN = 12;

@Entry
@Component
export struct CalendarView {
  private week: string[] = ['日', '一', '二', '三', '四', '五', '六']; // 设置日历周，从周日开始
  @State dateModel: DateModel = new DateModel(0, 0, 0, 0); // 初始化dateModel数据
  @State flag: boolean = false;
  @State contentData: MonthDataSource = new MonthDataSource(); // 列表数据
  nowDate: Date = new Date();
  currentMonth: number = this.nowDate.getMonth() + 1; // 当前月份
  currentDay: number = this.nowDate.getDate(); // 当前日
  currentYear: number = this.nowDate.getFullYear(); // 当前年份
  currentWeekDay: number = new Date(this.currentYear, this.currentMonth - 1, this.currentDay).getDay(); // 当前周几
  private scroller: Scroller = new Scroller(); // 二级列表Scroller对象
  @State nextMonth: number = 1; // 初始化下一个月月份
  @State nextYear: number = 1; // 初始化下一个月年份
  @State nextMonthDay: number[] = new Array<number>(); // 初始化下一个月的日期排列数组
  @State currentMonthDay: number[] = new Array<number>(); // 初始化当前月的日期排列数组

  // 获取当前日期
  aboutToAppear(): void {
    this.dateModel = getRealTimeDate(); // 获取当前年月日信息
    this.currentMonth = this.dateModel.month; // 获取当前月份
    this.currentDay = this.dateModel.day; // 获取当前日
    this.currentYear = this.dateModel.year; // 获取当前年份

    this.currentMonthDay = getMonthDate(this.currentMonth, this.currentYear);
    // 如果下个月是在下一年，则下个月是1月份，年份要+1
    if (this.currentMonth === MONTHS) {
      this.nextMonth = JANUARY;
      this.nextYear = this.currentYear + 1;
    } else {
      this.nextMonth = this.currentMonth + 1;
      this.nextYear = this.currentYear;
    }
    this.nextMonthDay = getMonthDate(this.nextMonth, this.nextYear);
    // 获取当前月和下个月的日期数据
    const months: Month =
      {
        month: `${this.currentYear}年 ${this.currentMonth}月`,
        num: this.currentMonth,
        days: this.currentMonthDay
      }
    const months2: Month =
      {
        month: `${this.nextYear}年 ${this.nextMonth}月`,
        num: this.nextMonth,
        days: this.nextMonthDay
      }
    this.contentData.pushData(months);
    this.contentData.pushData(months2);
  }

  @State strss: string | Resource = $r('app.string.customcalendarpickerdialog_departure');

  @Builder
  calendarMainView() {
    Column() {
      Column() {
        // 出发地和目的地显示
        Row() {
          Text($r('app.string.customcalendarpickerdialog_departure'))
            .fontSize(20)
          Image($r('app.media.app_icon'))
            .height(20)
            .width(20)
          Text($r('app.string.customcalendarpickerdialog_destination'))
            .fontSize(20)
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')

        // 当前日期显示
        Row() {
          Text(`${this.dateModel.month}月${this.dateModel.day}日`)
            .fontSize(20)
          Text(`星期${this.week[this.dateModel.week]}`)
            .fontSize(20)
        }
        .id('calender_click')
        .justifyContent(FlexAlign.Start)
        .width('100%')
        .margin(8)
        .onClick((e: ClickEvent) => {
          // 点击当前日期后打开自定义弹窗显示日历
          hilog.info(0x0000, 'testTag', '查询车票按钮显示 onClick');
          this.flag = !this.flag;
        })

        // 查询车票按钮显示
        Button($r('app.string.customcalendarpickerdialog_check_ticket'))
          .fontSize(20)
          .width('100%')
          .onClick((e: ClickEvent) => {
          })
      }
      .margin(10)
      .borderRadius($r('app.string.ohos_id_corner_radius_default_m'))

      Flex({ wrap: FlexWrap.Wrap }) {
        Text($r('app.string.customcalendarpickerdialog_departure_date'))
          .fontSize(20)
          .height(20).width('100%')
          .textAlign(TextAlign.Center)
        // 显示周信息，从周日开始到周六
        ForEach(WEEK, (weekday: string) => {
          Text(weekday)
            .fontSize(20)
            .width(50)
            .height(30)
            .fontColor(weekday === SUNDAY || weekday === SATURDAY ? Color.Red : Color.Black)
            .borderRadius(10)
            .textAlign(TextAlign.Center)
            .layoutWeight(1)
        })
        List() {
          ForEach(this.contentData.dataArray, (monthItem: Month) => {
            ListItem() {
              Flex({ wrap: FlexWrap.Wrap }) {
                // 月份信息
                Text(monthItem.month)
                  .width('100%')
                  .height(40)
                  .fontSize(20)
                  .fontColor(Color.Black)
                  .backgroundColor($r('app.color.highlyloadedcomponentrender_color_year_background'))
                  .textAlign(TextAlign.Center)
                  .id('id_highly_loaded_component_render_title')
                // 日期信息
                ForEach(monthItem.days, (day: number, index: number) => {
                  Text() {
                    Span(JSON.stringify(day))
                      .fontSize(20)
                  }
                  .height(50)
                  .width(50)
                  .opacity(day === 0 ? 0 : 1)
                  .fontColor(day < this.currentDay && monthItem.num === this.currentMonth ? Color.Grey :
                  Color.Black)
                  .borderRadius(10)
                  .textAlign(TextAlign.Center)
                  .backgroundColor(day === this.currentDay && monthItem.num === this.currentMonth ?
                  $r('app.color.ohos_id_color_palette9') : Color.Transparent)
                  .onClick((e: ClickEvent) => {
                    if (day >= this.currentDay || monthItem.num > this.currentMonth ||
                      Number(monthItem.month.substring(0, 4)) > this.currentYear) {
                      let weekIndex = monthItem.days.indexOf(day) % WEEK_NUMBER; // 将当前日转换成星期显示
                      let dateModelTmp: DateModel = new DateModel(0, 0, 0, 0);
                      dateModelTmp.day = day;
                      dateModelTmp.week = weekIndex;
                      dateModelTmp.month = monthItem.num;
                      dateModelTmp.year = Number(monthItem.month.substring(0, 4));
                      this.dateModel = dateModelTmp;
                      if (this.flag == true) {
                        this.flag = false;
                      }
                    }
                  })
                })
              }.width('100%')
            }
          })
        }
        .width('100%')
        .height('100%')
        .backgroundColor($r('app.color.ohos_id_color_background'))
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
      }
      .width('100%')
      .height('60%')
      .margin(10)
      .opacity(this.flag === true ? 1 : 0)
      .borderRadius($r('app.string.ohos_id_corner_radius_default_m'))
    }.height('100%')
  }

  build() {
    Column() {
      this.calendarMainView();
    }
    .width('100%')
    .height('100%')
  }
}