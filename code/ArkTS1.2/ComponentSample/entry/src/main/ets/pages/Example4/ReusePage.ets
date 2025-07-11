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
import hilog from '@ohos.hilog'
import { getMonthDate } from './GetDate';
import { Month, MonthDataSource } from './MonthDataSource';
import {
  memo,
  __memo_context_type,
  __memo_id_type
} from '@ohos.arkui.stateManagement' // should be insert by ui-plugins
import {
  Text,
  TextAttribute,
  Column,
  Component,
  Button,
  ButtonAttribute,
  ClickEvent,
  UserView,
  Flex,
  ItemAlign,
  ForEach,
  FlexWrap,
  Entry,
  TextAlign,
  $r,
  Color,
  HorizontalAlign,
  SafeAreaType,
  Row,
  LazyForEach,
  SafeAreaEdge,
  Span,
  List,
  EdgeEffect,
  BarState,
  Scroll,
  Scroller,
  ExpectedFrameRateRange,
  ListItem
} from '@ohos.arkui.component'; // TextAttribute should be insert by ui-plugins
import {
  State,
  Link,
  StateDecoratedVariable,
  MutableState,
  stateOf,
  observableProxy
} from '@ohos.arkui.stateManagement'; // should be insert by ui-plugins
import { Context, UIContext } from '@ohos.arkui.UIContext';

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

/**
 * 通过组件复用，加载每个月份的数据，当数据量较多时，快速滑动到底部，会出现掉帧的情况。
 */

@Component
export struct ReusePage {
  @State contentData: MonthDataSource = new MonthDataSource(); // 列表数据
  nowDate: Date = new Date();
  currentMonth: number = this.nowDate.getMonth() + 1; // 当前月份
  currentDay: number = this.nowDate.getDate(); // 当前日
  currentYear: number = this.nowDate.getFullYear(); // 当前年份
  currentWeekDay: number = new Date(this.currentYear, this.currentMonth - 1, this.currentDay).getDay(); // 当前周几
  private scroller: Scroller = new Scroller(); // 二级列表Scroller对象

  // 初始化日历中一年的数据
  initCalenderData() {
    for (let k = this.currentYear; k < 2035; ++k) {
      for (let i = 1; i <= 12; i++) {
        // 获取每个月的日数据
        const monthDays: number[] = getMonthDate(i, k);
        const month: Month = {
          month: i + MONTH,
          num: i,
          days: monthDays,
          year: k
        };
        this.contentData.pushData(month);
      }
    }
  }

  aboutToAppear() {
    this.initCalenderData();
  }

  build() {
    Column() {
      Text(this.currentYear + YEAR)
        .width('100%')
        .height(40)
        .fontSize(20)
        .fontColor(Color.Black)
        .backgroundColor($r('app.color.highlyloadedcomponentrender_color_year_background'))
        .textAlign(TextAlign.Center)
        .id('id_highly_loaded_component_render_title')
      List() {
        LazyForEach(this.contentData, (monthItem: Month) => {
          ListItem() {
            ItemView({
              monthItem: monthItem,
              currentMonth: this.currentMonth,
              currentDay: this.currentDay,
              currentYear: this.currentYear
            })
          }.width('100%')
        })
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.ohos_id_color_background'))
    .alignItems(HorizontalAlign.Center)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }
}

// @Reusable
@Component
struct ItemView {
  @State monthItem: Month = {
    month: '',
    num: 0,
    days: [],
    year: 0
  } as Month;
  private currentMonth: number = 0;
  private currentYear: number = 0; // 当前年份
  private currentDay: number = 0;
  private temp: Month[] = new Array<Month>();
  private step: number = 0;
  private maxStep: number = 2; // 最多执行的帧数
  readonly MAX_EVERY_FRAME: number = 5; // 每帧最多处理的数据量
  @State month: string = '';
  @State monthNumber: number = 0;
  @State days: number[] = new Array<number>();
  @State year: number = 0;

  build() {
    Flex({ wrap: FlexWrap.Wrap }) {
      // 月份信息
      Text(this.monthItem.month)
        .fontSize(25)
        .height(40)
        .fontColor(Color.Black)
        .width('100%')
        .textAlign(TextAlign.Start)
        .layoutWeight(1)

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
      // 日期信息
      ForEach(this.monthItem.days, (day: number, index: number) => {
        Text() {
          Span(JSON.stringify(day))
            .fontSize(20)
        }
        .height(50)
        .width(50)
        .opacity(day === 0 ? 0 : 1)
        .fontColor(Color.Black)
        .borderRadius(10)
        .textAlign(TextAlign.Center)
        .backgroundColor(day === this.currentDay && this.monthItem.num === this.currentMonth &&
          this.monthItem.year === this.currentYear ?
        $r('app.color.ohos_id_color_palette9') : Color.Transparent)
        .layoutWeight(1)
      })
    }
    .alignSelf(ItemAlign.Start)
    .backgroundColor(Color.Transparent)
    .width(350)
  }
}