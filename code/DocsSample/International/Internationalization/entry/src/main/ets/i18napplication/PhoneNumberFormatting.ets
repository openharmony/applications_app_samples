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
// 格式化电话号码
let phoneNumberFormat: i18n.PhoneNumberFormat = new i18n.PhoneNumberFormat('CN');
let formattedPhoneNumber = phoneNumberFormat.format('158****2312'); // formattedPhoneNumber = '158 **** 2312'

// RFC3966类型的电话号码
let rfcFormat: i18n.PhoneNumberFormat = new i18n.PhoneNumberFormat('CN', { type: 'RFC3966' });
let formattedRFCPhoneNumber = rfcFormat.format('158****2312'); // formattedRFCPhoneNumber = 'tel:+86-158-****-2312'

// 判断电话号码是否有效
let isValid = phoneNumberFormat.isValidNumber('158****2312'); // isValid = true

// 以某种语言显示号码归属地
let locationName = phoneNumberFormat.getLocationName('158****2312', 'en-GB'); // locationName = 'XiAn, Shanxi'

// 拨号中的电话号码格式化
let typingFormat: i18n.PhoneNumberFormat = new i18n.PhoneNumberFormat('CN', { type: 'TYPING' });
let phoneNumber = '0755453';
let formatResult = ''; // 通过如下方式对拨号中的号码格式化后，formatResult = '0755 453'
for (let i = 0; i < phoneNumber.length; i++) {
  formatResult += phoneNumber.charAt(i);
  formatResult = typingFormat.format(formatResult);
}
// [End format_phone_numbers]

const expectedFormattedPhoneNumber1 = '158 2312';
const expectedFormattedPhoneNumber2 = 'tel:+86-1582312';
const expectedIsValid = false;
const expectedLocationName4 = '';
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
      Text(assertEqual(formattedPhoneNumber, expectedFormattedPhoneNumber1, $r('app.string.PhoneNumberFormat')))
        .textStyle()
      Text(assertEqual(formattedRFCPhoneNumber, expectedFormattedPhoneNumber2, $r('app.string.RFC3966TypeNumberFormat')))
        .textStyle()
      Text(assertEqual(isValid, expectedIsValid, $r('app.string.IsValidNumber')))
        .textStyle()
      Text(assertEqual(locationName, expectedLocationName4, $r('app.string.CNLocationName')))
        .textStyle()
      Text(assertEqual(formatResult, expectedFormatResult, $r('app.string.FormatResult')))
        .textStyle()
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Start)
  }
}