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
/**
 * 常量
 */
export default class Constants {
  // 月份数组
  public static readonly MONTHS: string[] =
    ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'];
  // 星期
  public static readonly WEEKS: string[] = ['日', '一', '二', '三', '四', '五', '六'];
  // 一天的总毫秒数。1000 * 60 * 60 * 24
  public static readonly TOTAL_MILLISECONDS_IN_DAY: number = 86400000;
  // 一周的天数
  public static readonly DAYS_IN_WEEK: number = 7;
  // 公历字体大小
  public static readonly DAY_FONT_SIZE: number = 16;
  // 星期字体大小
  public static readonly WEEK_FONT_SIZE: number = 10;
  // 年月信息字体大小
  public static readonly YEAR_MONTH_FONT_SIZE: number = 18;
  // 字体倍数
  public static readonly FONT_MULTIPLIER: number = 1;
  // 选中日期边框宽度
  public static readonly SELECT_DATE_BORDER_WIDTH: number = 1;
  // 默认值
  public static readonly DEFAULT: number = 0;
  // 一年12个月
  public static readonly MONTHS_NUM: number = 12;
  // 字体粗细设置
  public static readonly FONT_WEIGHT_FIVE_HUNDRED: number = 500;
  public static readonly FONT_WEIGHT_EIGHT_HUNDRED: number = 800;
  // 年视图月份字体大小，粗细
  public static readonly YEAR_VIEW_MONTH_FONT: string = '60px 500';
  // 年视图星期字体大小
  public static readonly YEAR_VIEW_WEEK_FONT: string = '35px';
  // 年视图日期字体大小，粗细
  public static readonly YEAR_VIEW_DAY_FONT: string = '30px 400';
  // 年视图下滑线
  public static readonly YEAR_VIEW_UNDERLINE: string = '80px';
  // 年视图字体颜色灰色
  public static readonly YEAR_VIEW_FONT_COLOR: string = '#7e7e7e';
  // 年视图月份高度
  public static readonly YEAR_VIEW_MONTH_HEIGHT: number = 20;
  // 年视图星期，日期水平绘制偏移量
  public static readonly YEAR_VIEW_HORIZONTAL_OFFSET: number = 15;
  // 年视图日期垂直绘制偏移量
  public static readonly YEAR_VIEW_VERTICAL_OFFSET: number = 18;
  // 年视图星期初始高度
  public static readonly YEAR_VIEW_WEEK_HEIGHT: number = 40;
  // 年视图日期初始垂直绘制高度
  public static readonly YEAR_VIEW_DAY_HEIGHT: number = 58;
  // 年视图今天日期的圆半径
  public static readonly YEAR_VIEW_TODAY_RADIUS: number = 6;
  // 年视图今天日期的圆的弧线的终止弧度
  public static readonly YEAR_VIEW_TODAY_END_ANGLE: number = 6.28;
  // 年视图月数据的x轴初始值
  public static readonly YEAR_VIEW_INIT_THREE: number = 3;
  // 今天日期
  public static readonly TODAY: number = new Date().getDate();
  // 本月
  public static readonly TODAY_MONTH: number = new Date().getMonth() + 1;
  // 本年
  public static readonly TODAY_YEAR: number = new Date().getFullYear();
  // 年视图宽度
  public static readonly YEAR_VIEW_WIDTH: number | string = '100%';
  // 年视图高度
  public static readonly YEAR_VIEW_HEIGHT: number | string = 600;
  // 月视图宽度
  public static readonly MONTH_VIEW_WIDTH: number | string = '100%';
  // 月视图高度
  public static readonly MONTH_VIEW_HEIGHT: number | string = 400;
  // 周视图宽度
  public static readonly WEEK_VIEW_WIDTH: number | string = '100%';
  // 周视图高度
  public static readonly WEEK_VIEW_HEIGHT: number | string = 120;
}