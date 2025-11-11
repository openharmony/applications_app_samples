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
// [Start ImportModule]
import { BusinessError, commonEventManager } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = 'ProcessModel';
const DOMAIN_NUMBER: number = 0xFF00;
// [End ImportModule]

// [Start CreateSubscriberInformation]
// 用于保存创建成功的订阅者对象，后续使用其完成订阅及退订的动作
let subscriber: commonEventManager.CommonEventSubscriber | null = null;
// 订阅者信息，其中的event字段需要替换为实际的事件名称。
let subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
  events: ['event'], // 订阅灭屏公共事件
};
// [End CreateSubscriberInformation]

// [Start PublicEventInformation]
// 公共事件相关信息
let options: commonEventManager.CommonEventPublishData = {
  code: 1, // 公共事件的初始代码
  data: 'initial data', // 公共事件的初始数据
};

// [Start PublicEventInformation]
@Entry
@Component
struct CreatSubscribeInfo {
  build() {
    Column({ space: 10 }) {
      Button('CreateSubscriberCallback')
        .onClick(() => {
          // [Start CreateSubscriberCallback]
          // 创建订阅者回调
          commonEventManager.createSubscriber(subscribeInfo,
            (err: BusinessError, data: commonEventManager.CommonEventSubscriber) => {
              if (err) {
                hilog.error(DOMAIN_NUMBER, TAG,
                  `Failed to create subscriber. Code is ${err.code}, message is ${err.message}`);
                return;
              }
              hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in creating subscriber.');
              subscriber = data;
            })
          // [End CreateSubscriberCallback]
        })

      Button('SubscribeToPublicEvents')
        .onClick(() => {
          // [Start SubscribeToPublicEvents]
          // 订阅公共事件回调
          if (subscriber !== null) {
            commonEventManager.subscribe(subscriber, (err: BusinessError, data: commonEventManager.CommonEventData) => {
              if (err) {
                hilog.error(DOMAIN_NUMBER, TAG,
                  `Failed to subscribe common event. Code is ${err.code}, message is ${err.message}`);
                return;
              }
              hilog.info(DOMAIN_NUMBER, TAG, `Succeeded in subscribing, data is ${JSON.stringify(data)}`);
            })
          } else {
            hilog.error(DOMAIN_NUMBER, TAG, `Need create subscriber`);
          }
          // [End SubscribeToPublicEvents]
        })

      Button('UnsubscribePublicEvents')
        .onClick(() => {
          // [Start UnsubscribePublicEvents]
          // subscriber为订阅事件时创建的订阅者对象
          if (subscriber !== null) {
            commonEventManager.unsubscribe(subscriber, (err: BusinessError) => {
              if (err) {
                hilog.error(DOMAIN_NUMBER, TAG,
                  `Failed to unsubscribe. code is ${err.code}, message is ${err.message}`);
              } else {
                hilog.info(DOMAIN_NUMBER, TAG, `Succeeded in unsubscribing.`);
                subscriber = null;
              }
            })
          }
          // [End UnsubscribePublicEvents]
        })

      Button('PublicEventNoInformation')
        .onClick(() => {
          // [Start PublicEventNoInformation]
          // 发布公共事件，其中的event字段需要替换为实际的事件名称。
          commonEventManager.publish('event', (err: BusinessError) => {
            if (err) {
              hilog.error(DOMAIN_NUMBER, TAG,
                `Publish failed, code is ${JSON.stringify(err.code)}, message is ${JSON.stringify(err.message)}`);
            } else {
              //...
              hilog.info(DOMAIN_NUMBER, TAG, `Publish success`);
            }
          });
          // [End PublicEventNoInformation]
        })

      Button('PublicEventCarryingInformation')
        .onClick(() => {
          // [Start PublicEventCarryingInformation]
          // 发布公共事件，其中的event字段需要替换为实际的事件名称。
          commonEventManager.publish('event', options, (err: BusinessError) => {
            if (err) {
              hilog.error(DOMAIN_NUMBER, TAG,
                `Failed to publish common event. Code is ${err.code}, message is ${err.message}`);
            } else {
              //...
              hilog.info(DOMAIN_NUMBER, TAG, `Succeeded in publishing common event.`);
            }
          });
          // [End PublicEventCarryingInformation]
        })
    }
    .height('100%')
    .width('100%')
  }
}