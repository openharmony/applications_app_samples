/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import TitleBar from '../component/TitleBar';
import { assertEqual } from '../component/AssertEqual';
import { resourceToString } from '../component/ResourceToString';
import { intl } from '@kit.LocalizationKit';

/**********************************************************************************************************************
 * 时间日期格式化开发参考步骤
 * 1. 导入模块
 *  import { intl } from '@kit.LocalizationKit';
 * 2. 创建DateTimeFormat对象
 *  let dateFormat: intl.DateTimeFormat =
 *    new intl.DateTimeFormat(locale: string | Array<string>, options?: DateTimeOptions);
 *  let dateFormat: intl.DateTimeFormat = new intl.DateTimeFormat(); // 不传入locale参数
 * 3. 时间日期和相对时间格式化
 *  - 时间日期格式化
 *  let formattedDate: string = dateFormat.format(date: Date);
 *  - 相对时间格式化
 *  let formattedDate: string = dateFormat.format(date: Date);
 * 4. 获取格式化选项，查看对象的设置信息
 *  let options: intl.DateTimeOptions = dateFormat.resolvedOptions();
 *********************************************************************************************************************/

// 时间日期格式化开发实例
// 设置要格式化的日期
let date = new Date(2021, 8, 17, 13, 4, 0);
let startDate = new Date(2021, 8, 17, 13, 4, 0);
let endDate = new Date(2021, 8, 18, 13, 4, 0);

// 在软件上展示完整的时间信息
let dateFormat1 = new intl.DateTimeFormat('zh-CN', { dateStyle: 'full', timeStyle: 'full' });
let formattedDate1 = dateFormat1.format(date); // formattedDate1: 2021年9月17日星期五 中国标准时间 13:04:00

// 在有限的空间展示简短的时间信息
let dateFormat2 = new intl.DateTimeFormat('zh-CN', { dateStyle: 'short', timeStyle: 'short' });
let formattedDate2 = dateFormat2.format(date); // formattedDate2: 2021/9/17 13:04

// 自定义年月日时分秒的显示效果
let dateFormat3 = new intl.DateTimeFormat('zh-CN', {
  year: 'numeric',
  month: '2-digit',
  day: '2-digit',
  hour: '2-digit',
  minute: '2-digit',
  second: '2-digit'
});
let formattedDate3 = dateFormat3.format(date); // formattedDate3: 2021/09/17 13:04:00

// 仅显示一部分时间
let dateFormat4 = new intl.DateTimeFormat('zh-CN', { month: 'long', day: 'numeric', weekday: 'long' });
let formattedDate4 = dateFormat4.format(date); // formattedDate4: 9月17日星期五

// 自定义时制格式
let dateFormat5 = new intl.DateTimeFormat('zh-CN', { dateStyle: 'short', timeStyle: 'short', hourCycle: 'h11' });
let formattedDate5 = dateFormat5.format(date); // formattedDate5: 2021/9/17 下午13:04

// 面向习惯于其他数字系统的用户
let dateFormat6 = new intl.DateTimeFormat('zh-CN', { dateStyle: 'short', timeStyle: 'short', numberingSystem: 'arab' });
let formattedDate6 = dateFormat6.format(date); // formattedDate6: ٢٠٢١/٩/١٧ ١٣:٠٤

// 格式化时间段
let dataFormat7 = new intl.DateTimeFormat('en-GB');
let formattedDateRange = dataFormat7.formatRange(startDate, endDate); // formattedDateRange: 17/09/2021 - 18/09/2021

// 获取格式化选项
let dataFormat8 = new intl.DateTimeFormat('en-GB', { dateStyle: 'full' });
let options = dataFormat8.resolvedOptions();
let dateStyle = options.dateStyle; // dateStyle: full

/**********************************************************************************************************************
 * 相对时间格式化开发参考步骤
 * 1. 导入模块
 *  import { intl } from '@kit.LocalizationKit';
 * 2. 创建RelativeTimeFormat对象
 *  let relativeTimeFormat: intl.RelativeTimeFormat =
 *    new intl.RelativeTimeFormat(locale: string | Array<string>, options?: RelativeTimeFormatInputOptions);
 * 3. 格式化相对时间
 *  let formattedRelativeTime: string = relativeTimeFormat.format(value: number, unit: string);
 * 4. 自定义相对时间的格式化
 *  let parts: Array<object> = relativeTimeFormat.formatToParts(value: number, unit: string);
 * 5. 获取相对时间格式化选项，查看对象的设置信息
 *  let options: intl.RelativeTimeFormatInputOptions = relativeTimeFormat.resolvedOptions();
 *********************************************************************************************************************/

// 相对时间格式化开发实例
// 显示相对时间
let relativeTimeFormat1 = new intl.RelativeTimeFormat('en-GB');
let formattedRelativeTime1 = relativeTimeFormat1.format(-1, 'day'); // formattedRelativeTime1: 1 day ago

// 口语化
let relativeTimeFormat2 = new intl.RelativeTimeFormat('en-GB', { numeric: 'auto' });
let formattedRelativeTime2 = relativeTimeFormat2.format(-1, 'day'); // formattedRelativeTime2: yesterday

// 部分语言支持更为简短的显示风格
let relativeTimeFormat3 = new intl.RelativeTimeFormat('fr-FR'); // 默认style为long
let formattedRelativeTime3 = relativeTimeFormat3.format(-1, 'day'); // formattedRelativeTime3: il y a 1 jour
let relativeTimeFormat4 = new intl.RelativeTimeFormat('fr-FR', { style: 'narrow' });
let formattedRelativeTime4 = relativeTimeFormat4.format(-1, 'day'); // formattedRelativeTime4: -1 j

// 自定义区域设置格式的相对时间格式
let relativeTimeFormat5 = new intl.RelativeTimeFormat('en-GB', { style: 'long' });
// parts: [{type: 'literal', value: 'in'}, {type: 'integer', value: 1, unit: 'day'}, {type: 'literal', value: 'day'}]
let parts = relativeTimeFormat5.formatToParts(1, 'day');

// 获取RelativeTimeFormat对象的格式化选项
let relativeTimeFormat6 = new intl.RelativeTimeFormat('en-GB', { numeric: 'auto' });
let relativeOptions = relativeTimeFormat6.resolvedOptions();
let numeric = relativeOptions.numeric; // numeric: auto

const expectedFormattedDate1 = resourceToString($r('app.string.ExpectedFormattedDate1'));
const expectedFormattedDate2 = '2021/9/17 13:04';
const expectedFormattedDate3 = '2021/09/17 13:04:00';
const expectedFormattedDate4 = resourceToString($r('app.string.ExpectedFormattedDate4'));
const expectedFormattedDate5 = resourceToString($r('app.string.ExpectedFormattedDate5'));
const expectedFormattedDate6 = '٢٠٢١/٩/١٧ ١٣:٠٤';
const expectedFormattedDateRange = '17/09/2021 – 18/09/2021';
const expectedDateStyle = 'full';
const expectedFormattedRelativeTime1 = '1 day ago';
const expectedFormattedRelativeTime2 = 'yesterday';
const expectedFormattedRelativeTime3 = 'il y a 1 jour';
const expectedFormattedRelativeTime4 = '-1 j';
const expectedCustomFormat =
  '[{\"value\":\"in \",\"type\":\"literal\"},' +
    '{\"value\":\"1\",\"unit\":\"day\",\"type\":\"integer\"},' +
    '{\"value\":\" day\",\"type\":\"literal\"}]';
const expectedNumeric = 'auto';

@Extend(Text)
function textStyle() {
  .fontSize(20)
  .margin({ top: 12, left: 30, right: 30 });
}

@Entry
@Component
struct DateTimeFormatting {
  build() {
    Column() {
      TitleBar({ hasBackPress: true, title: $r('app.string.DateTimeFormatting') })
      Scroll() {
        Column() {
          Text($r('app.string.ResultsOfDateTimeFormat'))
            .textStyle()
            .fontWeight(FontWeight.Bold)
          Text(assertEqual(formattedDate1, expectedFormattedDate1, $r('app.string.FullDateStyle')))
            .textStyle()
          Text(assertEqual(formattedDate2, expectedFormattedDate2, $r('app.string.ShortDateStyle')))
            .textStyle()
          Text(assertEqual(formattedDate3, expectedFormattedDate3, $r('app.string.CustomDateStyle')))
            .textStyle()
          Text(assertEqual(formattedDate4, expectedFormattedDate4, $r('app.string.PartDateStyle')))
            .textStyle()
          Text(assertEqual(formattedDate5, expectedFormattedDate5, $r('app.string.CustomTimeStyle')))
            .textStyle()
          Text(assertEqual(formattedDate6, expectedFormattedDate6, $r('app.string.CustomNumberingSystem')))
            .textStyle()
          Text(assertEqual(formattedDateRange, expectedFormattedDateRange, $r('app.string.FormatDateRange')))
            .textStyle()
          Text(assertEqual(dateStyle, expectedDateStyle, $r('app.string.FormatDateStyle')))
            .textStyle()
          Text($r('app.string.ResultsOfRelativeTimeFormat'))
            .textStyle()
            .fontWeight(FontWeight.Bold)
          Text(assertEqual(formattedRelativeTime1, expectedFormattedRelativeTime1, $r('app.string.FormatRelativeTime')))
            .textStyle()
          Text(assertEqual(formattedRelativeTime2, expectedFormattedRelativeTime2,
            $r('app.string.AutoFormatRelativeTime')))
            .textStyle()
          Text(assertEqual(formattedRelativeTime3, expectedFormattedRelativeTime3,
            $r('app.string.LongFormatRelativeTime')))
            .textStyle()
          Text(assertEqual(formattedRelativeTime4, expectedFormattedRelativeTime4,
            $r('app.string.NarrowFormatRelativeTime')))
            .textStyle()
          Text(assertEqual(JSON.stringify(parts), expectedCustomFormat, $r('app.string.CustomFormatRelativeTime')))
            .textStyle()
          Text(assertEqual(numeric, expectedNumeric, $r('app.string.GetRelativeTimeFormatOptions')))
            .textStyle()
          Blank().height('10%')
        }
        .alignItems(HorizontalAlign.Start)
      }
      .id('outerScrollInDateTime')
      .width('100%')
      .height('100%')
    }
  }
}
