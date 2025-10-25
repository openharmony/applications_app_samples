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
import { BusinessError, commonEventManager } from '@kit.BasicServicesKit';
// [End import_module]

/**********************************
 *       设置系统语言与区域
 *********************************/
// [Start set_system_language_and_region]
// 设置系统当前语言为'zh-Hans'
try {
  i18n.System.setSystemLanguage('zh-Hans');
} catch (error) {
  let err: BusinessError = error as BusinessError;
  console.error(`call System.setSystemLanguage failed, error code: ${err.code}, message: ${err.message}.`);
}

// 设置系统当前地区为'CN'
try {
  i18n.System.setSystemRegion('CN');
} catch (error) {
  let err: BusinessError = error as BusinessError;
  console.error(`call System.setSystemRegion failed, error code: ${err.code}, message: ${err.message}.`);
}
// [End set_system_language_and_region]

// [Start get_system_language_and_region]
// 获取系统语言
let systemLanguage = i18n.System.getSystemLanguage();  // systemLanguage为当前系统语言

// 获取系统地区
let systemRegion = i18n.System.getSystemRegion();  // systemRegion为当前系统地区

// 获取系统区域
let systemLocale: Intl.Locale = i18n.System.getSystemLocaleInstance();  // systemLocale为当前系统区域

// 通过监听公共事件COMMON_EVENT_LOCALE_CHANGED可以感知系统语言、系统地区或系统区域变化
let subscriber: commonEventManager.CommonEventSubscriber; // 用于保存创建成功的订阅者对象，后续使用其完成订阅及退订的动作
let subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
  events: [commonEventManager.Support.COMMON_EVENT_LOCALE_CHANGED]
};
// 创建订阅者
commonEventManager.createSubscriber(subscribeInfo)
  .then((commonEventSubscriber: commonEventManager.CommonEventSubscriber) => {
    console.info('CreateSubscriber');
    subscriber = commonEventSubscriber;
    commonEventManager.subscribe(subscriber, (err, data) => {
      if (err) {
        console.error(`Failed to subscribe common event. error code: ${err.code}, message: ${err.message}.`);
        return;
      }
      console.info('The subscribed event has occurred.'); // 系统语言、系统地区或系统区域变化时执行
    })
  })
  .catch((err: BusinessError) => {
    console.error(`CreateSubscriber failed, code is ${err.code}, message is ${err.message}`);
  });
// [End get_system_language_and_region]

/**********************************
 *       设置应用偏好语言
 *********************************/
// [Start set_preferred_language]
try {
  i18n.System.setAppPreferredLanguage('zh-Hans'); // 设置应用偏好语言为zh-Hans
} catch (error) {
  let err: BusinessError = error as BusinessError;
  console.error(`call System.setAppPreferredLanguage failed, error code: ${err.code}, message: ${err.message}.`);
}
// [End set_preferred_language]

// [Start get_preferred_language]
let appPreferredLanguage = i18n.System.getAppPreferredLanguage(); // 获取应用偏好语言
// [End get_preferred_language]

// [Start clear_preferred_language]
// 清除应用的偏好语言
try {
  i18n.System.setAppPreferredLanguage('default'); // 清除应用偏好语言
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
  i18n.System.setUsingLocalDigit(true); // 使用本地数字
} catch (error) {
  let err: BusinessError = error as BusinessError;
  console.error(`call System.setUsingLocalDigit failed, error code: ${err.code}, message: ${err.message}.`);
}
// [End set_app_interface_numbers]

// [Start set_24_hour_clock_format]
// 设置格式化的24小时制
try {
  i18n.System.set24HourClock(true); // 设置系统时制为24小时制
} catch (error) {
  let err: BusinessError = error as BusinessError;
  console.error(`call System.set24HourClock failed, error code: ${err.code}, message: ${err.message}.`);
}
// [End set_24_hour_clock_format]

// [Start get_user_preference]
// 判断系统当前是否使用本地数字
let usingLocalDigit: boolean = i18n.System.getUsingLocalDigit();

// 判断系统当前是否使用24小时制
let is24HourClock: boolean = i18n.System.is24HourClock();

// 通过监听公共事件COMMON_EVENT_TIME_CHANGED可以感知系统时制变化
let timeSubscriber: commonEventManager.CommonEventSubscriber; // 用于保存创建成功的订阅者对象，后续使用其完成订阅及退订的动作
let timeSubscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
  events: [commonEventManager.Support.COMMON_EVENT_TIME_CHANGED]
};
// 创建订阅者
commonEventManager.createSubscriber(timeSubscribeInfo)
  .then((commonEventSubscriber: commonEventManager.CommonEventSubscriber) => {
    console.info('CreateSubscriber');
    timeSubscriber = commonEventSubscriber;
    commonEventManager.subscribe(timeSubscriber, (err, data) => {
      if (err) {
        console.error(`Failed to subscribe common event. error code: ${err.code}, message: ${err.message}.`);
        return;
      }
      // 用于区分系统时间和系统时制变化
      if (data.data != undefined && data.data == '24HourChange') {
        console.info('The subscribed event has occurred.'); // 系统时制变化时执行
      }
    })
  })
  .catch((err: BusinessError) => {
    console.error(`CreateSubscriber failed, code is ${err.code}, message is ${err.message}`);
  });
// [End get_user_preference]

const expectedSystemLanguage = 'zh-Hans';
const expectedSystemRegion = 'CN';
const expectedSystemLocale = 'zh-Hans-CN';
const expectedAppPreferredLanguage = 'zh-Hans';
const expectedResult1 = true;
const expectedResult2 = true;

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
      Text(assertEqual(systemLocale.toString(), expectedSystemLocale, $r('app.string.SetAndGetSystemLocale')))
        .textStyle()
      Text($r('app.string.ResultsOfSetPreferredLanguage'))
        .textStyle()
        .fontWeight(FontWeight.Bold)
      Text(assertEqual(appPreferredLanguage, expectedAppPreferredLanguage, $r('app.string.SetAndGetPreferredLanguage')))
        .textStyle()
      Text($r('app.string.ResultsOfSetUserPreference'))
        .textStyle()
        .fontWeight(FontWeight.Bold)
      Text(assertEqual(usingLocalDigit, expectedResult1, $r('app.string.SetApplicationInterfaceNumber')))
        .textStyle()
      Text(assertEqual(is24HourClock, expectedResult2, $r('app.string.SetFormatTo24Format')))
        .textStyle()
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Start)
  }
}