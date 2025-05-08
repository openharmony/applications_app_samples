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
// [Start import_module]
import { i18n, intl } from '@kit.LocalizationKit';
// [End import_module]

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
// [Start format_numbers]
// 数字格式化开发示实例
// 用科学计数法显示数字
let scientificFormat: intl.NumberFormat = new intl.NumberFormat('zh-CN',
  {
    notation: 'scientific',
    maximumSignificantDigits: 3
  });
let scientificNumber: string = scientificFormat.format(123400); // scientificNumber = '1.23E5'

// 用紧凑的格式显示数字
let compactFormat: intl.NumberFormat = new intl.NumberFormat('zh-CN',
  {
    notation: 'compact',
    compactDisplay: 'short'
  });
let compactNumber: string = compactFormat.format(123400); // compactNumber = '12万'

// 显示数字的符号
let signFormat: intl.NumberFormat = new intl.NumberFormat('zh-CN', { signDisplay: 'always' });
let signNumber: string = signFormat.format(123400); // signNumber = '+123,400'

// 显示百分数
let percentFormat: intl.NumberFormat = new intl.NumberFormat('zh-CN', { style: 'percent' });
let percentNumber: string = percentFormat.format(0.25); // percentNumber = '25%'

// 舍入模式
let truncFormat: intl.NumberFormat = new intl.NumberFormat('en',
  {
    roundingMode: 'trunc',
    maximumSignificantDigits: 2
  });
let truncPositiveNumber: string = truncFormat.format(2.28); // truncPositiveNumber = '2.2'
let truncNegativeNumber: string = truncFormat.format(-2.25); // truncNegativeNumber = '-2.2'

// 舍入优先级
let lessPrecisionOptions: intl.NumberOptions = {
  roundingPriority: 'lessPrecision',
  maximumFractionDigits: 3,
  maximumSignificantDigits: 2
};
let lessPrecisionFormat: intl.NumberFormat = new intl.NumberFormat('en', lessPrecisionOptions);
let lessPrecisionNumber: string = lessPrecisionFormat.format(1.23456); // lessPrecisionNumber = '1.2'

// 舍入增量
let halfCeilNumOptions: intl.NumberOptions = {
  style: 'currency',
  currency: 'USD',
  roundingIncrement: 5,
  maximumFractionDigits: 2,
  roundingMode: 'halfCeil'
};
let halfCeilFormat: intl.NumberFormat = new intl.NumberFormat('en-US', halfCeilNumOptions);
let halfCeilNumber: string = halfCeilFormat.format(11.21); // halfCeilNumber = '$11.20'

// 数字范围格式化
let options: intl.NumberOptions = {
  style: 'currency',
  currency: 'EUR',
  maximumFractionDigits: 0
};
let numberRangeFormat: intl.NumberFormat = new intl.NumberFormat('es-ES', options);
let integerFormattedRange: string = numberRangeFormat.formatRange(2, 8); // integerFormattedRange = '2-8 €'
let fractionFormattedRange: string = numberRangeFormat.formatRange(2.9, 3.1); // fractionFormattedRange = '~3 €'
let numberFormat4 = new intl.NumberFormat('zh-CN', { style: 'percent' });
let formattedNumber4 = numberFormat4.format(0.25); // formattedNumber4: 25%
// [End format_numbers]

// [Start currency_and_unit_formatting]
// 货币和单位格式化开发实例
// 格式化货币
let currencyFormat: intl.NumberFormat = new intl.NumberFormat('zh-CN', { style: 'currency', currency: 'USD' });
let currencyNumber: string = currencyFormat.format(123400); // currencyNumber = 'US$123,400.00'

// 用名称表示货币
let currencyNameFormat: intl.NumberFormat = new intl.NumberFormat('zh-CN',
  {
    style: 'currency',
    currency: 'USD',
    currencyDisplay: 'name'
  });
let currencyDisplayNumber: string = currencyNameFormat.format(123400); // currencyDisplayNumber = '123,400.00美元'

// 格式化度量衡
let unitFormat: intl.NumberFormat = new intl.NumberFormat('en-GB', { style: 'unit', unit: 'hectare' });
let unitNumber: string = unitFormat.format(123400); // unitNumber = '123,400 ha'

// 格式化特定场景下度量衡，如面积-土地-农业
let unitUsageFormat: intl.NumberFormat = new intl.NumberFormat('en-GB',
  {
    style: 'unit',
    unit: 'hectare',
    unitUsage: 'area-land-agricult'
  });
let unitUsageNumber = unitUsageFormat.format(123400); // unitUsageNumber = '304,928.041 ac'
let numberFormat8 = new intl.NumberFormat('en-GB', { style: 'unit', unit: 'hectare', unitUsage: 'area-land-agricult' });
let formattedNumber8 = numberFormat8.format(123400); // formattedNumber8: 304,928.041 ac
// [End currency_and_unit_formatting]

/**********************************************************************************************************************
 * 度量衡转换开发参考步骤
 * 1. 导入模块
 *  import { i18n } from '@kit.LocalizationKit';
 * 2. 度量衡转换
 *  let convertedUnit: string =
 *    i18n.I18NUtil.unitConvert(fromUnit: UnitInfo, toUnit: UnitInfo, value: number, locale: string, style?: string);
 *********************************************************************************************************************/
// [Start measurement_conversion]
// 度量衡转换开发实例
// 设置要转换的单位和目标单位
let fromUnit: i18n.UnitInfo = { unit: 'cup', measureSystem: 'US' };
let toUnit: i18n.UnitInfo = { unit: 'liter', measureSystem: 'SI' };

// 以en-US区域参数转换度量衡
let simplifyConvertedUnit: string = i18n.I18NUtil.unitConvert(fromUnit, toUnit, 1000, 'en-US'); // simplifyConvertedUnit: 236.588 L

// 显示完整的度量衡
let convertedUnit =
  i18n.I18NUtil.unitConvert(fromUnit, toUnit, 1000, 'en-US', 'long'); // convertedUnit2: 236.588 liters
// [End measurement_conversion]

const expectedScientificNumber = '1.23E5';
const expectedCompactNumber = resourceToString($r('app.string.ExpectedFormattedNumber2'));
const expectedSignNumber = '+123,400';
const expectedPercentNumber = '25%';
const expectedTruncPositiveNumber = '2.2';
const expectedTruncNegativeNumber = '-2.2';
const expectedLessPrecisionNumber = '1.2';
const expectedHalfCeilNumber = '$11.20';
const expectedIntegerFormattedRange = '2-8 €';
const expectedFractionFormattedRange = '~3 €';
const expectedCurrencyNumber= 'US$123,400.00'
const expectedCurrencyDisplayNumber = resourceToString($r('app.string.ExpectedFormattedNumber6'));
const expectedUnitNumber = '123,400 ha';
const expectedUnitUsageNumber = '304,928.041 ac';
const expectedSimplifyConvertedUnit = '236.588 L';
const expectedConvertedUnit = '236.588 liters';

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
        Scroll() {
          Column() {
            Text($r('app.string.ResultsOfNumberFormat'))
              .textStyle()
              .fontWeight(FontWeight.Bold)
            Text(assertEqual(scientificNumber, expectedScientificNumber, $r('app.string.ScientificDisplayNumber')))
              .textStyle()
            Text(assertEqual(compactNumber, expectedCompactNumber, $r('app.string.CompactDisplayNumber')))
              .textStyle()
            Text(assertEqual(signNumber, expectedSignNumber, $r('app.string.SignDisplayNumber')))
              .textStyle()
            Text(assertEqual(percentNumber, expectedPercentNumber, $r('app.string.PercentDisplayNumber')))
              .textStyle()
            Text(assertEqual(truncPositiveNumber, expectedTruncPositiveNumber, $r('app.string.RoundingModePositive')))
              .textStyle()
            Text(assertEqual(truncNegativeNumber, expectedTruncNegativeNumber, $r('app.string.RoundingModeNegative')))
              .textStyle()
            Text(assertEqual(lessPrecisionNumber, expectedLessPrecisionNumber, $r('app.string.RoundingPriority')))
              .textStyle()
            Text(assertEqual(halfCeilNumber, expectedHalfCeilNumber, $r('app.string.RoundingMode')))
              .textStyle()
            Text($r('app.string.ResultsOfCurrencyAndUnit'))
              .textStyle()
              .fontWeight(FontWeight.Bold)
            Text(assertEqual(integerFormattedRange, expectedIntegerFormattedRange,
              $r('app.string.IntegerFormattedRange')))
              .textStyle()
            Text(assertEqual(fractionFormattedRange, expectedFractionFormattedRange,
              $r('app.string.FractionFormattedRange')))
              .textStyle()
            Text($r('app.string.FormatRange'))
              .textStyle()
              .fontWeight(FontWeight.Bold)
            Text(assertEqual(currencyNumber, expectedCurrencyNumber, $r('app.string.DisplayCurrency')))
              .textStyle()
            Text(assertEqual(currencyDisplayNumber, expectedCurrencyDisplayNumber,
              $r('app.string.DisplayCurrencyName')))
              .textStyle()
            Text(assertEqual(unitNumber, expectedUnitNumber, $r('app.string.DisplayUnit')))
              .textStyle()
            Text(assertEqual(unitUsageNumber, expectedUnitUsageNumber, $r('app.string.DisplayUnitLand')))
              .textStyle()
            Text($r('app.string.ResultsOfMeasureTrans'))
              .textStyle()
              .fontWeight(FontWeight.Bold)
            Text(`${assertEqual(simplifyConvertedUnit, expectedSimplifyConvertedUnit, $r('app.string.MeasureTrans'))}`)
              .textStyle()
            Text(`${assertEqual(convertedUnit, expectedConvertedUnit, $r('app.string.LongMeasureTrans'))}`)
              .textStyle()
            Blank().height('10%')
          }.alignItems(HorizontalAlign.Start)
        }
      }
      .height('100%')
      .width('100%')
      .alignItems(HorizontalAlign.Start)

  }
}