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
 
// [Start HiLog_ArkTS]
import { hilog } from '@kit.PerformanceAnalysisKit';
// [StartExclude HiLog_ArkTS]
import testNapi from 'libentry.so';
// [EndExclude HiLog_ArkTS]
@Entry
@Component
struct Index {
  build() {
    Row() {
      Column() {
        // 添加按钮，以响应用户点击
        Button($r('app.string.HiLogArkTS_Button'))
          .type(ButtonType.Capsule)
          .margin({
            top: 20
          })
          .backgroundColor('#0D9FFB')
          .width('40%')
          .height('5%')
          // 按钮绑定onClick事件，点击时打印日志，注意realse hap包默认无法打印debug级别日志
          .onClick(() => {
            hilog.info(0xFF00, 'testTag', 'hilog_info_test');
            hilog.debug(0xFF00, 'testTag', 'hilog_debug_test');
            hilog.warn(0xFF00, 'testTag', 'hilog_warn_test');
            hilog.fatal(0xFF00, 'testTag', 'hilog_fatal_test');
            hilog.error(0xFF00, 'testTag', 'hilog_error_test');
            //isLoggable是用来判断，domainID和tag是否满足目前的日志级别打印，建议对返回值进行判断
            let ret = hilog.isLoggable(0xFF00, 'testTag', hilog.LogLevel.INFO);
            if (ret) {
              hilog.info(0xFF00, 'testTag',
              'A log with a domainID of 0xFF00 and a label of testTag can print logs at the Info level or higher.');
            }
          })
// [StartExclude HiLog_ArkTS]
        Button($r('app.string.HiLogCPP_Button'))
          .type(ButtonType.Capsule)
          .margin({
            top: 20
          })
          .backgroundColor('#0D9FFB')
          .width('40%')
          .height('5%')
          .onClick(() => {
            testNapi.HiLogTest();
          })
// [EndExclude HiLog_ArkTS]
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End HiLog_ArkTS]
