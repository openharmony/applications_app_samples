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
import { i18n, intl } from '@kit.LocalizationKit';
import { BusinessError } from '@kit.BasicServicesKit';
// [End import_module]

/**********************************
 *       设置系统语言与区域
 *********************************/
// [Start set_system_language_and_region]
// [StartExclude set_system_language_and_region]
// 设置系统当前语言为 'zh'
let systemLanguage = ''
// [EndExclude set_system_language_and_region]
try {
  i18n.System.setSystemLanguage('zh');
  systemLanguage = i18n.System.getSystemLanguage(); // systemLanguage为当前系统语言
} catch (error) {
  let err: BusinessError = error as BusinessError;
  console.error(`call System.setSystemLanguage failed, error code: ${err.code}, message: ${err.message}.`);
}

// [StartExclude set_system_language_and_region]
// 设置系统当前地区为 'CN'
let systemRegion = '';
// [EndExclude set_system_language_and_region]
try {
  i18n.System.setSystemRegion('CN');
  systemRegion = i18n.System.getSystemRegion(); // systemRegion为当前系统地区
} catch (error) {
  let err: BusinessError = error as BusinessError;
  console.error(`call System.setSystemRegion failed, error code: ${err.code}, message: ${err.message}.`);
}

// [StartExclude set_system_language_and_region]
// 设置系统当前区域为 'zh-Hans-CN'
let systemLocale = '';
// [EndExclude set_system_language_and_region]
try {
  i18n.System.setSystemLocale('zh-Hans-CN');
  systemLocale = i18n.System.getSystemLocale(); // systemLocale为当前系统区域
} catch (error) {
  let err: BusinessError = error as BusinessError;
  console.error(`call System.setSystemLocale failed, error code: ${err.code}, message: ${err.message}.`);
}
// [End set_system_language_and_region]

/**********************************
 *       设置应用偏好语言
 *********************************/
// [Start set_preferred_language]
// [StartExclude set_preferred_language]
// 设置应用的偏好语言
let appPreferredLanguage = '';
// [EndExclude set_preferred_language]
try {
  i18n.System.setAppPreferredLanguage('zh-Hans'); // 设置应用偏好语言为zh-Hans
  appPreferredLanguage = i18n.System.getAppPreferredLanguage(); // 获取应用偏好语言
} catch (error) {
  let err: BusinessError = error as BusinessError;
  console.error(`call System.setAppPreferredLanguage failed, error code: ${err.code}, message: ${err.message}.`);
}
// [End set_preferred_language]

// [Start clear_preferred_language]
// 清除应用的偏好语言
try {
  i18n.System.setAppPreferredLanguage('default'); // 清除应用的偏好语言
} catch (error) {
  let err: BusinessError = error as BusinessError;
  console.error(`call System.setAppPreferredLanguage failed, error code: ${err.code}, message: ${err.message}.`);
}
// [End clear_preferred_language]

/**********************************
 *       设置用户偏好
 *********************************/
// [Start set_app_interface_numbers]
// 设置应用界面数字
try {
  i18n.System.setUsingLocalDigit(true); // 打开本地化数字开关
} catch (error) {
  let err: BusinessError = error as BusinessError;
  console.error(`call System.setUsingLocalDigit failed, error code: ${err.code}, message: ${err.message}.`);
}
let date1 = new Date(2023, 9, 25);
let appPreferredLanguage1 = 'ar';
let dateTimeFmt1 = new intl.DateTimeFormat(appPreferredLanguage1);
let result1 = dateTimeFmt1.format(date1); // result = "٢٠٢٣/١٠/٢٥"（采用阿语本地数字表示）
// [End set_app_interface_numbers]

// [Start set_24_hour_clock_format]
// 设置格式化的24小时制
try {
  i18n.System.set24HourClock(true); // true表示打开24小时制开关，false表示打开12小时制开关
} catch (error) {
  let err: BusinessError = error as BusinessError;
  console.error(`call System.set24HourClock failed, error code: ${err.code}, message: ${err.message}.`);
}
let date2 = new Date(2023, 9, 25, 16, 48, 0);
let appPreferredLanguage2 = 'zh';
let dateTimeFmt2 = new intl.DateTimeFormat(appPreferredLanguage2, { timeStyle: 'medium' });
let result2 = dateTimeFmt2.format(date2);
// [End set_24_hour_clock_format]

const expectedSystemLanguage = 'zh';
const expectedSystemRegion = 'CN';
const expectedSystemLocale = 'zh-Hans-CN';
const expectedAppPreferredLanguage = 'zh-Hans';
const expectedResult1 = '٢٥‏/١٠‏/٢٠٢٣';
const expectedResult2 = '16:48:00';

@Extend(Text)
function textStyle() {
  .fontSize(20)
  .margin({ top: 20, left: 30, right: 20 });
}

@Entry
@Component
struct LanguagePreferenceSetting {
  build() {
    Column() {
      TitleBar({ hasBackPress: true, title: $r('app.string.LanguagePreferenceSetting') })
      Text($r('app.string.ResultsOfSetSystemLanguageAndRegion'))
        .textStyle()
        .fontWeight(FontWeight.Bold)
      Text(assertEqual(systemLanguage, expectedSystemLanguage, $r('app.string.SetAndGetSystemLanguage')))
        .textStyle()
      Text(assertEqual(systemRegion, expectedSystemRegion, $r('app.string.SetAndGetSystemRegion')))
        .textStyle()
      Text(assertEqual(systemLocale, expectedSystemLocale, $r('app.string.SetAndGetSystemLocale')))
        .textStyle()
      Text($r('app.string.ResultsOfSetPreferredLanguage'))
        .textStyle()
        .fontWeight(FontWeight.Bold)
      Text(assertEqual(appPreferredLanguage, expectedAppPreferredLanguage, $r('app.string.SetAndGetPreferredLanguage')))
        .textStyle()
      Text($r('app.string.ResultsOfSetUserPreference'))
        .textStyle()
        .fontWeight(FontWeight.Bold)
      Text(assertEqual(result1, expectedResult1, $r('app.string.SetApplicationInterfaceNumber')))
        .textStyle()
      Text(assertEqual(result2, expectedResult2, $r('app.string.SetFormatTo24Format')))
        .textStyle()
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Start)
  }
}