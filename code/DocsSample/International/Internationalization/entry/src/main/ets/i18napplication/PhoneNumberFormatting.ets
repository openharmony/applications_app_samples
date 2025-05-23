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
// [Start import_module]
import { i18n } from '@kit.LocalizationKit';
// [End import_module]

/**********************************************************************************************************************
 * 电话号码格式化开发参考步骤
 * 1. 导入模块
 *  import { i18n } from '@kit.LocalizationKit';
 * 2. 创建PhoneNumberFormat对象
 *  let phoneNumberFormat: i18n.PhoneNumberFormat =
 *    new i18n.PhoneNumberFormat(country: string, options?: PhoneNumberFormatOptions);
 * 3. 电话号码格式化
 *  let formattedPhoneNumber: string = phoneNumberFormat.format(phoneNumber: string);
 * 4. 判断电话号码正确性和号码归属地
 *  let isValidNumber: boolean = phoneNumberFormat.isValidNumber(phoneNumber: string); // 判断电话号码正确性
 *  let locationName: string = phoneNumberFormat.getLocationName(number: string, locale: string); // 获取号码归属地
 *********************************************************************************************************************/
// [Start format_phone_numbers]
// 电话号码格式化开发实例
// 格式化电话号码
let phoneNumberFormat1 = new i18n.PhoneNumberFormat('CN');
let formattedPhoneNumber1 = phoneNumberFormat1.format('15812342312'); // formattedPhoneNumber1: 158 1234 2312

// RFC3966类型的电话号码
let phoneNumberFormat2 = new i18n.PhoneNumberFormat('CN', { type: 'RFC3966' });
let formattedPhoneNumber2 = phoneNumberFormat2.format('15812342312'); // formattedPhoneNumber2: tel:+86-158-1234-2312

// 判断电话号码是否有效
let phoneNumberFormat3 = new i18n.PhoneNumberFormat('CN');
let isValid = phoneNumberFormat3.isValidNumber('15812342312'); // isValid: true

// 以某种语言显示号码归属地
let phoneNumberFormat4 = new i18n.PhoneNumberFormat('CN');
let locationName4 = phoneNumberFormat4.getLocationName('15812342312', 'en-GB'); // locationName4: Zhanjiang, Guangdong

// 拨号中的电话号码格式化
let phoneNumberFmt = new i18n.PhoneNumberFormat('CN', { type: 'TYPING' });
let phoneNumber: string = '0755453';
let formatResult: string = '';
for (let i = 0; i < phoneNumber.length; i++) {
  formatResult += phoneNumber.charAt(i);
  formatResult = phoneNumberFmt.format(formatResult);
}
console.log(formatResult); // formatResult: 0755 453
// [End format_phone_numbers]

const expectedFormattedPhoneNumber1 = '158 1234 2312';
const expectedFormattedPhoneNumber2 = 'tel:+86-158-1234-2312';
const expectedIsValid = true;
const expectedLocationName4 = 'Zhanjiang, Guangdong';
const expectedFormatResult = '0755 453'

@Extend(Text)
function textStyle() {
  .fontSize(20)
  .margin({ top: 30, left: 30, right: 30 });
}

@Entry
@Component
struct PhoneNumberFormatting {
  build() {
    Column() {
      TitleBar({ hasBackPress: true, title: $r('app.string.PhoneNumberFormatting') })
      Text($r('app.string.ResultsOfPhoneNumberFormat'))
        .textStyle()
        .fontWeight(FontWeight.Bold)
      Text(assertEqual(formattedPhoneNumber1, expectedFormattedPhoneNumber1, $r('app.string.PhoneNumberFormat')))
        .textStyle()
      Text(assertEqual(formattedPhoneNumber2, expectedFormattedPhoneNumber2, $r('app.string.RFC3966TypeNumberFormat')))
        .textStyle()
      Text(assertEqual(isValid, expectedIsValid, $r('app.string.IsValidNumber')))
        .textStyle()
      Text(assertEqual(locationName4, expectedLocationName4, $r('app.string.CNLocationName')))
        .textStyle()
      Text(assertEqual(formatResult, expectedFormatResult, $r('app.string.FormatResult')))
        .textStyle()
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Start)
  }
}