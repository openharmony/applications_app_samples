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

@Entry
@Component
struct Index {
  processorId: number = -1 // 初始化processorId为-1

  build() {
    Row() {
      Column() {
        Button($r('app.string.AddProcessorTest_Button'))
          .type(ButtonType.Capsule)
          .margin({
            top: 20
          })
          .backgroundColor('#0D9FFB')
          .width('50%')
          .height('5%')
          .onClick(() => {
            // 在按钮点击函数中进行数据处理者添加
            let eventConfig: hiAppEvent.AppEventReportConfig = {
              domain: 'button',
              name: 'click',
              isRealTime: true
            };
            let processor: hiAppEvent.Processor = {
              name: 'analytics_demo',
              debugMode: true,
              routeInfo: 'CN',
              onStartReport: true,
              onBackgroundReport: true,
              periodReport: 10,
              batchReport: 5,
              userIds: ['testUserIdName'],
              userProperties: ['testUserPropertyName'],
              eventConfigs: [eventConfig]
            };
            this.processorId = hiAppEvent.addProcessor(processor);
          })
        Button($r('app.string.UserIdTest_Button'))
          .type(ButtonType.Capsule)
          .margin({
            top: 20
          })
          .backgroundColor('#0D9FFB')
          .width('40%')
          .height('5%')
          .onClick(() => {
            // 在按钮点击函数中设置用户ID
            hiAppEvent.setUserId('testUserIdName', '123456');

            // 在按钮点击函数中获取刚设置的用户ID
            let userId = hiAppEvent.getUserId('testUserIdName');
            hilog.info(0x0000, 'testTag', `userId: ${userId}`)
          })
        Button($r('app.string.UserPropertyTest_Button'))
          .type(ButtonType.Capsule)
          .margin({
            top: 20
          })
          .backgroundColor('#0D9FFB')
          .width('50%')
          .height('5%')
          .onClick(() => {
            // 在按钮点击函数中设置用户属性值
            hiAppEvent.setUserProperty('testUserPropertyName', '123456');

            // 在按钮点击函数中获取刚设置的用户属性值
            let userProperty = hiAppEvent.getUserProperty('testUserPropertyName');
            hilog.info(0x0000, 'testTag', `userProperty: ${userProperty}`)
          })
        Button($r('app.string.WriteTest_Button'))
          .type(ButtonType.Capsule)
          .margin({
            top: 20
          })
          .backgroundColor('#0D9FFB')
          .width('40%')
          .height('5%')
          .onClick(() => {
            // 在按钮点击函数中进行事件打点，以记录按钮点击事件
            let eventParams: Record<string, number> = { 'click_time': 100 };
            let eventInfo: hiAppEvent.AppEventInfo = {
              // 事件领域定义
              domain: "button",
              // 事件名称定义
              name: "click",
              // 事件类型定义
              eventType: hiAppEvent.EventType.BEHAVIOR,
              // 事件参数定义
              params: eventParams,
            };
            hiAppEvent.write(eventInfo).then(() => {
              hilog.info(0x0000, 'testTag', `HiAppEvent success to write event`)
            }).catch((err: BusinessError) => {
              hilog.error(0x0000, 'testTag', `HiAppEvent err.code: ${err.code}, err.message: ${err.message}`)
            });
          })
        Button($r('app.string.RemoveProcessorTest_Button'))
          .type(ButtonType.Capsule)
          .margin({
            top: 20
          })
          .backgroundColor('#0D9FFB')
          .width('60%')
          .height('5%')
          .onClick(() => {
            // 在按钮点击函数中进行数据处理者移除
            hiAppEvent.removeProcessor(this.processorId);
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}