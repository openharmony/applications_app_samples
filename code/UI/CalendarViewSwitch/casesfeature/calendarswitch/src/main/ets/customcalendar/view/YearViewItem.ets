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

import CommonData from '../common/CommonData';
import Constants from '../constant/Constants';
import { OffscreenCanvas } from '../model/OffscreenCanvas'; // 离屏画布类
import { TimeUtils } from '../utils/TimeUtils'; // 时间计算工具类

/**
 * 年视图子组件
 */
@Component
export struct YearViewItem {
  // 年视图离屏画布列表
  @State yearViewList: Array<OffscreenCanvas> = [];
  @Prop @Watch('updateYearData') year: number;
  // 年视图月份点击回调
  onMonthClick: (year: number, month: number) => void = () => {
  };

  /**
   * 更新年数据
   */
  updateYearData() {
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
          // TODO: 高性能知识点: 年视图使用Canvas绘制显示年视图中每个月，以减少节点数量，同时使用OffscreenCanvasRenderingContext2D离
          // 屏绘制，将需要绘制的内容先绘制在缓存区，然后将其转换成图片，一次性绘制到canvas上，以加快绘制速度。
          Canvas(monthItem.context)
            .width($r('app.string.calendar_switch_full_size'))
            .height($r('app.string.calendar_switch_full_size'))
            .onReady(() => {
              // 绘制年视图中一个月的数据
              let isTodayMoth: boolean =
                monthItem.year === Constants.TODAY_YEAR && monthItem.month === Constants.TODAY_MONTH;
              // 画月
              monthItem.offContext.font = Constants.YEAR_VIEW_MONTH_FONT[CommonData.DEVICE_TYPE];
              monthItem.offContext.fillStyle = isTodayMoth ? Color.Red : Color.Black;
              monthItem.offContext.fillText(Constants.MONTHS[monthItem.month-1],
                Constants.YEAR_VIEW_INIT_THREE[CommonData.DEVICE_TYPE],
                Constants.YEAR_VIEW_MONTH_HEIGHT[CommonData.DEVICE_TYPE]);
              // 水平偏移
              let horizontalOffset = Constants.YEAR_VIEW_INIT_THREE[CommonData.DEVICE_TYPE];
              // 画星期
              monthItem.offContext.font = Constants.YEAR_VIEW_WEEK_FONT[CommonData.DEVICE_TYPE];
              for (let i = 0; i < Constants.WEEKS.length; i++) {
                // 星期六，日字体颜色设置灰色
                if (i === 0 || i === 6) {
                  monthItem.offContext.fillStyle = Constants.YEAR_VIEW_FONT_COLOR;
                }
                monthItem.offContext.fillText(Constants.WEEKS[i], horizontalOffset,
                  Constants.YEAR_VIEW_WEEK_HEIGHT[CommonData.DEVICE_TYPE]);
                monthItem.offContext.fillStyle = Color.Black;
                horizontalOffset += Constants.YEAR_VIEW_HORIZONTAL_OFFSET[CommonData.DEVICE_TYPE];
              }
              // 获取月份日期前占位个数
              const INTERVAL_COUNT: number = TimeUtils.getWeekDay(monthItem.year, monthItem.month, 1);
              // 画日期
              monthItem.offContext.font = Constants.YEAR_VIEW_DAY_FONT[CommonData.DEVICE_TYPE];
              monthItem.offContext.fillStyle = Color.Black;
              // 获取每个月的总天数
              const TOTAL_DAYS_IN_MONTH: number = TimeUtils.getMonthDays(monthItem.year, monthItem.month);
              // 获取一个月占几周。向上取整
              const WEEK_LENGTH = Math.ceil((INTERVAL_COUNT + TOTAL_DAYS_IN_MONTH) / 7);
              // 初始化绘制日期。从1号开始绘制
              let dayIndex = 1;
              // 日期垂直偏移
              let verticalOffset = Constants.YEAR_VIEW_DAY_HEIGHT[CommonData.DEVICE_TYPE];
              for (let i = 0; i < WEEK_LENGTH; i++) {
                horizontalOffset = Constants.YEAR_VIEW_INIT_THREE[CommonData.DEVICE_TYPE];
                // 画一周
                for (let j = 1; j <= Constants.DAYS_IN_WEEK; j++) {
                  if (i === 0 && j <= INTERVAL_COUNT) {
                    // 月份日期前占位
                  } else {
                    // 判断绘制的日期是不是今天。如果是今天，日期绘制圆圈红色背景，白色字体。如果不是今天，黑色字体
                    if (isTodayMoth && Constants.TODAY === dayIndex) {

                      // 画圆圈
                      monthItem.offContext.fillStyle = Color.Red;
                      // 绘制弧线路径。这里绘制圆圈。arc入参分别是弧线圆心的x坐标值，弧线圆心的y坐标值，弧线的圆半径，弧线的起始弧度，弧线的
                      // 终止弧度。5和3是圆圈x，y坐标绘制位置的微调值
                      monthItem.offContext.arc(horizontalOffset + 5 +
                      Constants.YEAR_VIEW_X_AXIS[CommonData.DEVICE_TYPE],
                        verticalOffset - 3 - Constants.YEAR_VIEW_Y_AXIS[CommonData.DEVICE_TYPE],
                        Constants.YEAR_VIEW_TODAY_RADIUS[CommonData.DEVICE_TYPE], Constants.DEFAULT,
                        Constants.YEAR_VIEW_TODAY_END_ANGLE[CommonData.DEVICE_TYPE]);
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
                    // 画线。如果是农历初一，则日期底部加下划线
                    if (TimeUtils.isLunarFirstDayOfMonth(monthItem.year, monthItem.month, dayIndex)) {
                      monthItem.offContext.font = Constants.YEAR_VIEW_UNDERLINE[CommonData.DEVICE_TYPE];
                      monthItem.offContext.fillStyle = Color.Red;
                      monthItem.offContext.fillText('_', 1 + horizontalOffset, verticalOffset);
                      monthItem.offContext.font = Constants.YEAR_VIEW_DAY_FONT[CommonData.DEVICE_TYPE];
                    }
                    // 重置日期字体颜色
                    monthItem.offContext.fillStyle = Color.Black;
                    dayIndex++;
                  }
                  // 日期绘制水平偏移
                  horizontalOffset += Constants.YEAR_VIEW_HORIZONTAL_OFFSET[CommonData.DEVICE_TYPE];
                  if (dayIndex > TOTAL_DAYS_IN_MONTH) {
                    break;
                  }
                }
                // 周绘制垂直偏移
                verticalOffset += Constants.YEAR_VIEW_VERTICAL_OFFSET[CommonData.DEVICE_TYPE];
              }
              // 从OffscreenCanvas组件中最近渲染的图像创建一个ImageBitmap对象
              const IMAGE = monthItem.offContext.transferToImageBitmap();
              // 显示给定的ImageBitmap对象
              monthItem.context.transferFromImageBitmap(IMAGE);
            })
        }
        .height($r('app.string.calendar_switch_size_twenty_three'))
        .width($r('app.string.calendar_switch_size_twenty_five'))
        .onClick(() => {
          this.onMonthClick(monthItem.year, monthItem.month);
        })
      }, (monthItem: OffscreenCanvas) => monthItem.year + '' + monthItem.month + '' + CommonData.DEVICE_TYPE)
    }
    .onSizeChange(() => {
      if (CommonData.IS_FOLD) {
        // 折叠屏展开态和折叠态尺寸变化时需要刷新当前年视图
        this.updateYearData();
      }
    })
    .scrollBar(BarState.Off)
    .columnsTemplate('1fr 1fr 1fr')
    .columnsGap($r('app.integer.calendar_switch_columns_gap'))
    .rowsGap($r('app.integer.calendar_switch_rows_gap'))
  }
}