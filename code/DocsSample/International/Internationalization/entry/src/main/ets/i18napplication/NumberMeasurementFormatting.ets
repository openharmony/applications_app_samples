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
import { i18n, intl } from '@kit.LocalizationKit';

/**********************************************************************************************************************
 * 数字格式化开发参考步骤
 * 1. 导入模块
 *  import { intl } from '@kit.LocalizationKit';
 * 2. 创建NumberFormat对象
 *  let numberFormat: intl.NumberFormat =
 *    new intl.NumberFormat(locale: string | Array<string>, options?: NumberOptions);
 * 3. 数字格式化，根据numberFormat的设置格式化number
 *  let formattedNumber: string = numberFormat.format(number: number);
 * 4. 获取数字格式化选项，查看对象的设置信息
 *  let options: intl.NumberOptions = numberFormat.resolvedOptions();
 *********************************************************************************************************************/

// 数字格式化开发示实例
// 用科学计数法显示数字
let numberFormat1 = new intl.NumberFormat('zh-CN', { notation: 'scientific', maximumSignificantDigits: 3 });
let formattedNumber1 = numberFormat1.format(123400); // formattedNumber1: 1.23E5

// 用紧凑的格式显示数字
let numberFormat2 = new intl.NumberFormat('zh-CN', { notation: 'compact', compactDisplay: 'short' });
let formattedNumber2 = numberFormat2.format(123400); // formattedNumber2: 12万

// 显示数字的符号
let numberFormat3 = new intl.NumberFormat('zh-CN', { signDisplay: 'always' });
let formattedNumber3 = numberFormat3.format(123400); // formattedNumber3: +123,400

// 显示百分数
let numberFormat4 = new intl.NumberFormat('zh-CN', { style: 'percent' });
let formattedNumber4 = numberFormat4.format(0.25); // formattedNumber4: 25%

// 货币和单位格式化开发实例
// 格式化货币
let numberFormat5 = new intl.NumberFormat('zh-CN', { style: 'currency', currency: 'USD' });
let formattedNumber5 = numberFormat5.format(123400); // formattedNumber5: US$123,400.00

// 用名称表示货币
let numberFormat6 = new intl.NumberFormat('zh-CN', { style: 'currency', currency: 'USD', currencyDisplay: 'name' });
let formattedNumber6 = numberFormat6.format(123400); // formattedNumber6: 123,400.00美元

// 格式化度量衡
let numberFormat7 = new intl.NumberFormat('en-GB', { style: 'unit', unit: 'hectare' });
let formattedNumber7 = numberFormat7.format(123400); // formattedNumber7: 123,400 ha

// 格式化特定场景下度量衡，如面积-土地-农业
let numberFormat8 = new intl.NumberFormat('en-GB', { style: 'unit', unit: 'hectare', unitUsage: 'area-land-agricult' });
let formattedNumber8 = numberFormat8.format(123400); // formattedNumber8: 304,928.041 ac

/**********************************************************************************************************************
 * 度量衡转换开发参考步骤
 * 1. 导入模块
 *  import { i18n } from '@kit.LocalizationKit';
 * 2. 度量衡转换
 *  let convertedUnit: string =
 *    i18n.I18NUtil.unitConvert(fromUnit: UnitInfo, toUnit: UnitInfo, value: number, locale: string, style?: string);
 *********************************************************************************************************************/

// 度量衡转换开发实例
// 设置要转换的单位和目标单位
let fromUnit: i18n.UnitInfo = { unit: 'cup', measureSystem: 'US' };
let toUnit: i18n.UnitInfo = { unit: 'liter', measureSystem: 'SI' };

// 以en-US区域参数转换度量衡
let convertedUnit1 = i18n.I18NUtil.unitConvert(fromUnit, toUnit, 1000, 'en-US'); // convertedUnit1: 236.588 L

// 显示完整的度量衡
let convertedUnit2 =
  i18n.I18NUtil.unitConvert(fromUnit, toUnit, 1000, 'en-US', 'long'); // convertedUnit2: 236.588 liters

const expectedFormattedNumber1 = '1.23E5';
const expectedFormattedNumber2 = resourceToString($r('app.string.ExpectedFormattedNumber2'));
const expectedFormattedNumber3 = '+123,400';
const expectedFormattedNumber4 = '25%';
const expectedFormattedNumber5 = 'US$123,400.00'
const expectedFormattedNumber6 = resourceToString($r('app.string.ExpectedFormattedNumber6'));
const expectedFormattedNumber7 = '123,400 ha';
const expectedFormattedNumber8 = '304,928.041 ac';
const expectedConvertedUnit1 = '236.588 L';
const expectedconvertedUnit2 = '236.588 liters';

@Extend(Text)
function textStyle() {
  .fontSize(20)
  .margin({ top: 15, left: 30, right: 30 });
}

@Entry
@Component
struct NumberMeasurementFormatting {
  build() {
    Column() {
      TitleBar({ hasBackPress: true, title: $r('app.string.NumberMeasurementFormatting') })
      Text($r('app.string.ResultsOfNumberFormat'))
        .textStyle()
        .fontWeight(FontWeight.Bold)
      Text(assertEqual(formattedNumber1, expectedFormattedNumber1, $r('app.string.ScientificDisplayNumber')))
        .textStyle()
      Text(assertEqual(formattedNumber2, expectedFormattedNumber2, $r('app.string.CompactDisplayNumber')))
        .textStyle()
      Text(assertEqual(formattedNumber3, expectedFormattedNumber3, $r('app.string.SignDisplayNumber')))
        .textStyle()
      Text(assertEqual(formattedNumber4, expectedFormattedNumber4, $r('app.string.PercentDisplayNumber')))
        .textStyle()
      Text($r('app.string.ResultsOfCurrencyAndUnit'))
        .textStyle()
        .fontWeight(FontWeight.Bold)
      Text(assertEqual(formattedNumber5, expectedFormattedNumber5, $r('app.string.DisplayCurrency')))
        .textStyle()
      Text(assertEqual(formattedNumber6, expectedFormattedNumber6, $r('app.string.DisplayCurrencyName')))
        .textStyle()
      Text(assertEqual(formattedNumber7, expectedFormattedNumber7, $r('app.string.DisplayUnit')))
        .textStyle()
      Text(assertEqual(formattedNumber8, expectedFormattedNumber8, $r('app.string.DisplayUnitLand')))
        .textStyle()
      Text($r('app.string.ResultsOfMeasureTrans'))
        .textStyle()
        .fontWeight(FontWeight.Bold)
      Text(`${assertEqual(convertedUnit1, expectedConvertedUnit1, $r('app.string.MeasureTrans'))}`)
        .textStyle()
      Text(`${assertEqual(convertedUnit2, expectedconvertedUnit2, $r('app.string.LongMeasureTrans'))}`)
        .textStyle()
    }
    .height('100%')
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}