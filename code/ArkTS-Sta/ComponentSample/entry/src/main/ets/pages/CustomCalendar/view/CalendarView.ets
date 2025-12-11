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
import { DateModel } from '../components/DateModel';
import { getMonthDate, getRealTimeDate } from '../components/GetDate';
import promptAction from '@ohos.promptAction';
import {
  __memo_context_type,
  __memo_id_type,
  Consume,
  Link,
  memo,
  State,
  StorageLink
} from '@ohos.arkui.stateManagement';
import {
  $r,
  Builder,
  Button,
  ButtonAttribute,
  ButtonType,
  ClickEvent,
  Color,
  Column,
  Component,
  CustomDialogController,
  DialogAlignment,
  DismissDialogAction,
  Entry,
  Flex,
  FlexAlign,
  FlexWrap,
  ForEach,
  HorizontalAlign,
  Image,
  ItemAlign,
  List,
  ListItem,
  Margin,
  Resource,
  Row,
  SafeAreaEdge,
  SafeAreaType,
  Scroll,
  Scroller,
  Span,
  TabContent,
  Tabs,
  Text,
  TextAlign,
  TextAttribute,
  TextInput
} from '@ohos.arkui.component';
import hilog from '@ohos.hilog';
import { Context, UIContext } from '@ohos.arkui.UIContext';
import { Month, MonthDataSource } from '../components/MonthDataSource';

const ELEMENTS_MARGIN_L: double = 24;
const ELEMENTS_MARGIN_M: double = 8;
const TRANSITION_DURATION: double = 200;
const MONDAY: string = '一';
const TUESDAY: string = '二';
const WEDNESDAY: string = '三';
const THURSDAY: string = '四';
const FRIDAY: string = '五';
const SATURDAY: string = '六';
const SUNDAY: string = '日';
const WEEK: string[] = [SUNDAY, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY]; // 设置日历周，从周日开始
const MONTH: string = '月';
const YEAR: string = '年';
const MONTHS: int = 12;
const JANUARY: int = 1;
const WEEK_NUMBER: int = 7;
const MONTH_NUMBER: int = 35;
const GRID_HEIGHT_L: double = 360;
const GRID_HEIGHT_M: double = 300;
const ELEMENTS_MARGIN: double = 12;

@Entry
@Component
export struct CalendarView {
  private week: string[] = ['日', '一', '二', '三', '四', '五', '六']; // 设置日历周，从周日开始
  @State dateModel: DateModel = new DateModel(0, 0, 0, 0); // 初始化dateModel数据
  @State flag: boolean = false;
  @State contentData: MonthDataSource = new MonthDataSource(); // 列表数据
  nowDate: Date = new Date();
  currentMonth: int = this.nowDate.getMonth().toInt() + 1; // 当前月份
  currentDay: int = this.nowDate.getDate().toInt(); // 当前日
  currentYear: int = this.nowDate.getFullYear().toInt(); // 当前年份
  currentWeekDay: int = new Date(this.currentYear, this.currentMonth - 1, this.currentDay).getDay().toInt(); // 当前周几
  private scroller: Scroller = new Scroller(); // 二级列表Scroller对象
  @State nextMonth: int = 1; // 初始化下一个月月份
  @State nextYear: int = 1; // 初始化下一个月年份
  @State nextMonthDay: int[] = new Array<int>(); // 初始化下一个月的日期排列数组
  @State currentMonthDay: int[] = new Array<int>(); // 初始化当前月的日期排列数组

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
    const nextMonths: Month =
      {
        month: `${this.nextYear}年 ${this.nextMonth}月`,
        num: this.nextMonth,
        days: this.nextMonthDay
      }
    this.contentData.pushData(months);
    this.contentData.pushData(nextMonths);
  }

  @Builder
  calendarMainView() {
    Column() {
      Column() {
        // 出发地和目的地显示
        Row() {
          Text($r('app.string.customcalendarpickerdialog_departure'))
            .fontSize(20)
          Image($r('app.media.train_icon'))
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
          Text(`星期${this.week[this.dateModel.week.toInt()]}`)
            .fontSize(20)
        }
        .id('calender_click')
        .justifyContent(FlexAlign.Start)
        .width('100%')
        .margin(8)
        .onClick((e: ClickEvent) => {
          // 点击当前日期后显示日历
          this.flag = !this.flag;
        })

        // 查询车票按钮显示
        Button($r('app.string.customcalendarpickerdialog_check_ticket'))
          .fontSize(20)
          .width('100%')
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
        }, (weekday: string) => weekday)
        List() {
          ForEach(this.contentData.dataArray, (monthItem: Month, index: number) => {
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
                ForEach(monthItem.days, (day: int, index: number) => {
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
                      let weekIndex = monthItem.days.indexOf(day.toInt()) % WEEK_NUMBER; // 将当前日转换成星期显示
                      let dateModelTmp: DateModel = new DateModel(0, 0, 0, 0);
                      dateModelTmp.day = day.toInt();
                      dateModelTmp.week = weekIndex;
                      dateModelTmp.month = monthItem.num;
                      dateModelTmp.year = Number(monthItem.month.substring(0, 4)).toInt();
                      this.dateModel = dateModelTmp;
                      if (this.flag == true) {
                        this.flag = false;
                      }
                    }
                  })
                }, (day: int, index: number) => index.toString())
              }.width('100%')
            }
          }, (monthItem: Month, index: number) => index.toString())
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
      .borderRadius('12')
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