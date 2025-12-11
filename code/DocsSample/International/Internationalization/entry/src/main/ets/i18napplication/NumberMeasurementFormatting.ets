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
import { i18n } from '@kit.LocalizationKit';
// [End import_module]

/**********************************************************************************************************************
 * 度量衡转换开发参考步骤
 * 1. 导入模块
 *  import { i18n } from '@kit.LocalizationKit';
 * 2. 度量衡转换
 *  let convertedUnit: string =
 *    i18n.I18NUtil.unitConvert(fromUnit: UnitInfo, toUnit: UnitInfo, value: number, locale: string, style?: string);
 *********************************************************************************************************************/
// [Start measurement_conversion]
// 设置要转换的单位和目标单位
let fromUnit: i18n.UnitInfo = {unit: 'cup', measureSystem: 'US'};
let toUnit: i18n.UnitInfo = {unit: 'liter', measureSystem: 'SI'};

// 以en-US区域ID转换度量衡
let simplifyConvertedUnit = i18n.I18NUtil.unitConvert(fromUnit, toUnit, 1000, 'en-US'); // simplifyConvertedUnit = '236.588 L'

// 显示完整的度量衡
let convertedUnit = i18n.I18NUtil.unitConvert(fromUnit, toUnit, 1000, 'en-US', 'long'); // convertedUnit = '236.588 liters'
// [End measurement_conversion]

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
      .id('outerScrollInNumberMeasure')
      .height('100%')
      .width('100%')
      .alignItems(HorizontalAlign.Start)
  }
}