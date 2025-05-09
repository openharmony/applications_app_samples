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

// [Start EventSub_Header]
import { BusinessError } from '@kit.BasicServicesKit';
import { hiAppEvent, hilog } from '@kit.PerformanceAnalysisKit';
// [End EventSub_Header]
// [Start PssleakEvent_Header]
import hidebug from '@ohos.hidebug';
// [End PssleakEvent_Header]
// [Start EventSub_Index_Capi_Header]
import testNapi from 'libentry.so';
// [End EventSub_Index_Capi_Header]
@Entry
@Component
struct Index {
  @State leakedArray: string[][] = [];

  build() {
    Row() {
      Column() {
        // [Start AppEvent_ArkTS_Button]
        Button($r('app.string.WriteEventArkTS_Button'))
          // [StartExclude AppEvent_ArkTS_Button]
          .type(ButtonType.Capsule)
          .margin({
            top: 20
          })
          .backgroundColor('#0D9FFB')
          .width('80%')
          .height('5%')
          // [EndExclude AppEvent_ArkTS_Button]
          .onClick(() => {
            // 在按钮点击函数中进行事件打点，以记录按钮点击事件
            let eventParams: Record<string, number> = {'clickTime': 100};
            let eventInfo: hiAppEvent.AppEventInfo = {
              // 事件领域定义
              domain: 'button',
              // 事件名称定义
              name: 'click',
              // 事件类型定义
              eventType: hiAppEvent.EventType.BEHAVIOR,
              // 事件参数定义
              params: eventParams,
            };
            hiAppEvent.write(eventInfo).then(() => {
              hilog.info(0x0000, 'testTag', `writeEvent ArkTS success`);
            }).catch((err: BusinessError) => {
              hilog.error(0x0000, 'testTag', `HiAppEvent err.code: ${err.code}, err.message: ${err.message}`);
            });
          })
        // [End AppEvent_ArkTS_Button]
        // [Start CrashEvent_Button]
        Button($r('app.string.Crash_Button'))
          .type(ButtonType.Capsule)
          .margin({
            top: 20
          })
          .backgroundColor('#0D9FFB')
          .width('80%')
          .height('5%')
          .onClick(() => {
            // 在按钮点击函数中构造一个crash场景，触发应用崩溃事件
            JSON.parse('');
          })
        // [End CrashEvent_Button]
        // [Start PssleakEvent_Button]
        Button($r('app.string.Pssleak_Button'))
            .type(ButtonType.Capsule)
            .margin({
              top: 20
            })
            .backgroundColor('#0D9FFB')
            .width('80%')
            .height('5%')
            .onClick(() => {
              // 设置一个简单的资源泄漏场景
              hidebug.setAppResourceLimit('pss_memory', 1024, true);
              for (let i = 0; i < 20 * 1024; i++) {
                this.leakedArray.push(new Array(1).fill('leak'));
              }
            })
          // [End PssleakEvent_Button]
          // [Start TimeOutEvent_Button]
          Button($r('app.string.TimeOut_Button'))
          .type(ButtonType.Capsule)
          .margin({
            top: 20
          })
          .backgroundColor('#0D9FFB')
          .width('80%')
          .height('5%')
          .onClick(() => {
            let t = Date.now();
            while (Date.now() - t <= 350) {
            }
          })
          // [End TimeOutEvent_Button]
      }
      .width('50%')

      Column() {
        // [Start AppEvent_CPP_Button]
        Button($r('app.string.WriteEventCPP_Button'))
          // [StartExclude AppEvent_CPP_Button]
          .type(ButtonType.Capsule)
          .margin({
            top: 20
          })
          .backgroundColor('#0D9FFB')
          .width('80%')
          .height('5%')
          // [EndExclude AppEvent_CPP_Button]
          .onClick(() => {
            testNapi.writeAppEvent();
          })
        // [End AppEvent_CPP_Button]
        // [Start FreezeEvent_Button]
        Button($r('app.string.Freeze_Button'))
          .type(ButtonType.Capsule)
          .margin({
            top: 20
          })
          .backgroundColor('#0D9FFB')
          .width('80%')
          .height('5%')
          .onClick(() => {
            setTimeout(() => {
              while (true) {
              }
            }, 1000)
          })
        // [End FreezeEvent_Button]
        // [Start AsanEvent_Button]
        Button($r('app.string.AsanEvent_Button'))
          .type(ButtonType.Capsule)
          .margin({
            top: 20
          })
          .backgroundColor('#0D9FFB')
          .width('80%')
          .height('5%')
          .onClick(() => {
            testNapi.addressTest();
          })
        // [End AsanEvent_Button]
      }
      .width('50%')
    }
    .height('100%')
  }
}
