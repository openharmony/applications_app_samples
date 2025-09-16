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
import { OffscreenCanvas } from '../model/OffscreenCanvas'; // 离屏画布类
import { TimeUtils } from '../utils/TimeUtils'; // 时间计算工具类
import {
  $r,
  Builder,
  BarState,
  ClickEvent,
  Color,
  Column,
  Component,
  FlexAlign,
  FontWeight,
  ForEach,
  HorizontalAlign,
  Margin,
  Padding,
  Row,
  Text,
  TextAlign,Canvas,GridItem,Grid
} from '@ohos.arkui.component';
import { Link, State, Watch, Prop } from '@ohos.arkui.stateManagement';
/**
 * 年视图子组件
 */
@Component
export struct YearViewItem {
  // 年视图离屏画布列表
  @State yearViewList: Array<OffscreenCanvas> = new Array<OffscreenCanvas>();
  @Prop @Watch('updateYearData') year: number;
  // 年视图月份点击回调
  onMonthClick: (year: number, month: number) => void = () => {
  };

  /**
   * 更新年数据
   */
  updateYearData(param:string) {
    this.yearViewList = [];
    for (let i = 1; i <= Constants.MONTHS_NUM; i++) {
      this.yearViewList.push(new OffscreenCanvas(this.year, i));
    }
  }

  aboutToAppear(): void {
    // 添加年视图中每个月的离屏画布对象。一个画布对象绘制一个月数据。
    for (let i = 1; i <= Constants.MONTHS_NUM; i++) {
      this.yearViewList.push(new OffscreenCanvas(this.year, i));
    }
  }

  build() {
    Grid() {
      ForEach(this.yearViewList, (monthItem: OffscreenCanvas) => {
        GridItem() {
          Canvas(monthItem.context)
            .width('100%')
            .width('100%')
            .onReady(() :void=> {
              // 绘制年视图中一个月的数据
              let isTodayMoth: boolean =
                monthItem.year === Constants.TODAY_YEAR && monthItem.month === Constants.TODAY_MONTH;
              // 画月
              monthItem.offContext.font = Constants.YEAR_VIEW_MONTH_FONT;
              monthItem.offContext.fillStyle = Color.Black;
              monthItem.offContext.fillText(Constants.MONTHS[monthItem.month-1], Constants.YEAR_VIEW_INIT_THREE,
                Constants.YEAR_VIEW_MONTH_HEIGHT);
              // 水平偏移
              let horizontalOffset = Constants.YEAR_VIEW_INIT_THREE;
              // 画星期
              monthItem.offContext.font = Constants.YEAR_VIEW_WEEK_FONT;
              for (let i = 0; i < Constants.WEEKS.length; i++) {
                // 星期六，日字体颜色设置灰色
                if (i === 0 || i === 6) {
                  monthItem.offContext.fillStyle = Constants.YEAR_VIEW_FONT_COLOR;
                }
                monthItem.offContext.fillText(Constants.WEEKS[i], horizontalOffset, Constants.YEAR_VIEW_WEEK_HEIGHT);
                monthItem.offContext.fillStyle = Color.Black;
                horizontalOffset += Constants.YEAR_VIEW_HORIZONTAL_OFFSET;
              }
              // 获取月份日期前占位个数
              const INTERVAL_COUNT: number = TimeUtils.getWeekDay(monthItem.year, monthItem.month, 1);
              // 画日期
              monthItem.offContext.font = Constants.YEAR_VIEW_DAY_FONT;
              monthItem.offContext.fillStyle = Color.Black;
              // 获取每个月的总天数
              const TOTAL_DAYS_IN_MONTH: number = TimeUtils.getMonthDays(monthItem.year, monthItem.month);
              // 获取一个月占几周。向上取整
              const WEEK_LENGTH = Math.ceil((INTERVAL_COUNT + TOTAL_DAYS_IN_MONTH) / 7);
              // 初始化绘制日期。从1号开始绘制
              let dayIndex = 1;
              // 日期垂直偏移
              let verticalOffset = Constants.YEAR_VIEW_DAY_HEIGHT;
              for (let i = 0; i < WEEK_LENGTH; i++) {
                horizontalOffset = Constants.YEAR_VIEW_INIT_THREE;
                // 画一周
                for (let j = 1; j <= Constants.DAYS_IN_WEEK; j++) {
                  if (i === 0 && j <= INTERVAL_COUNT) {
                    // 月份日期前占位
                  } else {
                    // 判断绘制的日期是不是今天。如果是今天，日期绘制圆圈红色背景，白色字体。如果不是今天，黑色字体
                    if (isTodayMoth && Constants.TODAY === dayIndex) {
                      // 画圆圈
                      monthItem.offContext.fillStyle = '#fffc0101';
                      // 绘制弧线路径。这里绘制圆圈。arc入参分别是弧线圆心的x坐标值，弧线圆心的y坐标值，弧线的圆半径，弧线的起始弧度，弧线的终止弧度。5和3是圆圈x，y坐标绘制位置的微调值
                      monthItem.offContext.arc(horizontalOffset + 5, verticalOffset - 3,
                        Constants.YEAR_VIEW_TODAY_RADIUS, Constants.DEFAULT, Constants.YEAR_VIEW_TODAY_END_ANGLE);
                      // 对封闭路径进行填充。
                      monthItem.offContext.fill();
                      // 设置白色字体
                      monthItem.offContext.fillStyle = Color.White;
                    } else {
                      if (j === 1 || j === 7) {
                        // 星期日和星期六字体设置灰色
                        monthItem.offContext.fillStyle = Constants.YEAR_VIEW_FONT_COLOR;
                      } else {
                        monthItem.offContext.fillStyle = Color.Black;
                      }
                    }
                    // 画日期
                    if (dayIndex < 10) {
                      // 日期1-9号，字体水平位置微调3vp
                      monthItem.offContext.fillText(dayIndex.toString(), 3 + horizontalOffset, verticalOffset);
                    } else {
                      monthItem.offContext.fillText(dayIndex.toString(), horizontalOffset, verticalOffset);
                    }
                    // 重置日期字体颜色
                    monthItem.offContext.fillStyle = Color.Black;
                    dayIndex++;
                  }
                  // 日期绘制水平偏移
                  horizontalOffset += Constants.YEAR_VIEW_HORIZONTAL_OFFSET;
                  if (dayIndex > TOTAL_DAYS_IN_MONTH) {
                    break;
                  }
                }
                // 周绘制垂直偏移
                verticalOffset += Constants.YEAR_VIEW_VERTICAL_OFFSET;
              }
              // 从OffscreenCanvas组件中最近渲染的图像创建一个ImageBitmap对象
              const IMAGE = monthItem.offContext.transferToImageBitmap();
              // 显示给定的ImageBitmap对象
              monthItem.context.transferFromImageBitmap(IMAGE);
            })
        }
        .id('month' + monthItem.month)
        .height('23%')
        .width('25%')
        .onClick((e:ClickEvent) => {
          this.onMonthClick(monthItem.year, monthItem.month);
        })
      }, (monthItem: OffscreenCanvas) => monthItem.year + '' + monthItem.month)
    }
    .id(this.year.toString())
    .scrollBar(BarState.Off)
    .columnsTemplate('1fr 1fr 1fr')
    .columnsGap(0)
    .rowsGap(10)
  }
}