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

/**
 * 常量
 */
export default class Constants {
  // 月份数组
  public static readonly MONTHS: string[] =
    ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'];
  // 星期
  public static readonly WEEKS: string[] = ['日', '一', '二', '三', '四', '五', '六'];
  // 农历月份的中文表示
  public static readonly CHINESE_MONTH: string[] =
    ['正', '二', '三', '四', '五', '六', '七', '八', '九', '十', '十一', '腊'];
  // 农历日期的中文表示
  public static readonly CHINESE_DAY: string[] =
    ['初一', '初二', '初三', '初四', '初五', '初六', '初七', '初八', '初九', '初十',
      '十一', '十二', '十三', '十四', '十五', '十六', '十七', '十八', '十九', '二十',
      '廿一', '廿二', '廿三', '廿四', '廿五', '廿六', '廿七', '廿八', '廿九', '三十'];
  // 一天的总毫秒数。1000 * 60 * 60 * 24
  public static readonly TOTAL_MILLISECONDS_IN_DAY: number = 86400000;
  // 一周的天数
  public static readonly DAYS_IN_WEEK: number = 7;
  // 公历字体大小
  public static readonly DAY_FONT_SIZE: number = 16;
  // 农历字体大小
  public static readonly LUNAR_DAY_FONT_SIZE: number = 10;
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
  // 今天日期
  public static readonly TODAY: number = new Date().getDate();
  // 本月
  public static readonly TODAY_MONTH: number = new Date().getMonth() + 1;
  // 本年
  public static readonly TODAY_YEAR: number = new Date().getFullYear();
  // 年视图宽度
  public static readonly YEAR_VIEW_WIDTH: number | string = '100%';
  // 年视图高度
  public static readonly YEAR_VIEW_HEIGHT: number | string = 650;
  // 月视图宽度
  public static readonly MONTH_VIEW_WIDTH: number | string = '100%';
  // 月视图高度
  public static readonly MONTH_VIEW_HEIGHT: number | string = 400;
  // 周视图宽度
  public static readonly WEEK_VIEW_WIDTH: number | string = '100%';
  // 周视图高度
  public static readonly WEEK_VIEW_HEIGHT: number | string = 120;
  // 日程点直径
  public static readonly SCHEDULE_POINT_DIAMETER: number = 5;
  // 年视图字体颜色灰色
  public static readonly YEAR_VIEW_FONT_COLOR: string = '#7e7e7e';
  // 日程提醒时间选项
  public static readonly REMINDER_TIME_OPTION: string[] = ['准时', '1分钟前', '5分钟前', '30分钟前', '1小时前'];
  // 年视图月份字体大小，粗细
  public static readonly YEAR_VIEW_MONTH_FONT: string[] = ['60px 500', '70px 500', '25px 400'];
  // 年视图星期字体大小
  public static readonly YEAR_VIEW_WEEK_FONT: string[] = ['35px', '45px', '20px'];
  // 年视图日期字体大小，粗细
  public static readonly YEAR_VIEW_DAY_FONT: string[] = ['30px 400', '40px 400', '16px 400'];
  // 年视图下滑线
  public static readonly YEAR_VIEW_UNDERLINE: string[] = ['80px', '100px', '40px'];
  // 年视图月份高度
  public static readonly YEAR_VIEW_MONTH_HEIGHT: number[] = [20, 20, 15];
  // 年视图星期，日期水平绘制偏移量
  public static readonly YEAR_VIEW_HORIZONTAL_OFFSET: number[] = [15, 30, 20];
  // 年视图日期垂直绘制偏移量
  public static readonly YEAR_VIEW_VERTICAL_OFFSET: number[] = [18, 18, 20];
  // 年视图星期初始高度
  public static readonly YEAR_VIEW_WEEK_HEIGHT: number[] = [40, 40, 33];
  // 年视图日期初始垂直绘制高度
  public static readonly YEAR_VIEW_DAY_HEIGHT: number[] = [58, 58, 58];
  // 年视图今天日期的圆半径
  public static readonly YEAR_VIEW_TODAY_RADIUS: number[] = [6, 9, 7];
  // 年视图今天日期的圆的弧线的终止弧度
  public static readonly YEAR_VIEW_TODAY_END_ANGLE: number[] = [6.28, 6.28, 6.28];
  // 年视图月数据的x轴初始值
  public static readonly YEAR_VIEW_INIT_THREE: number[] = [3, 3, 3];
  // 年视图今天日期的圆x轴位置微调
  public static readonly YEAR_VIEW_X_AXIS: number[] = [0, 2, 1];
  // 年视图今天日期的圆y轴位置微调
  public static readonly YEAR_VIEW_Y_AXIS: number[] = [0, 1, 0];
}