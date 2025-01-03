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
import { BusinessError } from '@kit.BasicServicesKit';
import { hiAppEvent, hilog } from '@kit.PerformanceAnalysisKit';
import hidebug from '@ohos.hidebug';
import testNapi from 'libentry.so';

@Entry
@Component
struct Index {
  @State leakedArray: string[][] = [];

  build() {
    Row() {
      Column() {
        Button($r('app.string.WriteEventArkTS_Button'))
          .type(ButtonType.Capsule)
          .margin({
            top: 20
          })
          .backgroundColor('#0D9FFB')
          .width('80%')
          .height('5%')
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
      }
      .width('50%')

      Column() {
        Button($r('app.string.WriteEventCPP_Button'))
          .type(ButtonType.Capsule)
          .margin({
            top: 20
          })
          .backgroundColor('#0D9FFB')
          .width('80%')
          .height('5%')
          .onClick(() => {
            testNapi.writeAppEvent();
          })
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
      }
      .width('50%')
    }
    .height('100%')
  }
}
