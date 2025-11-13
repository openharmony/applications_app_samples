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

// [Start add_behavior_intent_header]
import { notificationManager } from '@kit.NotificationKit';
import { wantAgent, WantAgent } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = '[PublishOperation]';
const DOMAIN_NUMBER: number = 0xFF00;
// [End add_behavior_intent_header]

@Entry
@Component
export struct AddBehaviorIntent {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      NavDestination() {
        Button($r('app.string.ability_agent_create'))
          .margin({ top: 20, bottom: 20 })
          .onClick(() => {
            // [Start create_launch_uiability_agent_info]
            let wantAgentObj: WantAgent; // 用于保存创建成功的wantAgent对象，后续使用其完成触发的动作。

            // 通过WantAgentInfo的operationType设置动作类型
            let wantAgentInfo: wantAgent.WantAgentInfo = {
              wants: [
                {
                  deviceId: '',
                  bundleName: 'com.sample.myapplication', // 需要替换为对应的bundleName。
                  abilityName: 'EntryAbility', // 需要替换为对应的abilityName。
                  action: '',
                  entities: [],
                  uri: '',
                  parameters: {}
                }
              ],
              actionType: wantAgent.OperationType.START_ABILITY,
              requestCode: 0,
              actionFlags: [wantAgent.WantAgentFlags.CONSTANT_FLAG]
            };
            // [End create_launch_uiability_agent_info]

            // [Start create_get_agent]
            // 创建WantAgent
            wantAgent.getWantAgent(wantAgentInfo, (err: BusinessError, data: WantAgent) => {
              if (err) {
                hilog.error(DOMAIN_NUMBER, TAG,
                  `Failed to get want agent. Code is ${err.code}, message is ${err.message}`);
                return;
              }
              hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in getting want agent.');
              wantAgentObj = data;

              // [StartExclude create_get_agent]
              // [Start pub_want_agent_req_notify]
              // 构造NotificationActionButton对象
              let actionButton: notificationManager.NotificationActionButton = {
                title: 'Test_Title',
                // wantAgentObj使用前需要保证已被赋值（即步骤3执行完成）
                // 通知按钮的WantAgent
                wantAgent: wantAgentObj
              };

              // 构造NotificationRequest对象
              let notificationRequest: notificationManager.NotificationRequest = {
                content: {
                  notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
                  normal: {
                    title: 'Test_Title',
                    text: 'Test_Text',
                    additionalText: 'Test_AdditionalText',
                  },
                },
                id: 6,
                // 通知消息的WantAgent
                wantAgent: wantAgentObj,
                // 通知按钮
                actionButtons: [actionButton],
              };

              notificationManager.publish(notificationRequest, (err: BusinessError) => {
                if (err) {
                  hilog.error(DOMAIN_NUMBER, TAG,
                    `Failed to publish notification. Code is ${err.code}, message is ${err.message}`);
                  return;
                }
                hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in publishing notification.');
              });
              // [End pub_want_agent_req_notify]
              // [EndExclude create_get_agent]
            });
            // [End create_get_agent]
          })
        Button($r('app.string.pub_event_agent'))
          .margin({ top: 20, bottom: 20 })
          .onClick(() => {
            // [Start create_pub_event_agent_info]
            let wantAgentObj: WantAgent; // 用于保存创建成功的WantAgent对象，后续使用其完成触发的动作。

            // 通过WantAgentInfo的operationType设置动作类型
            let wantAgentInfo: wantAgent.WantAgentInfo = {
              wants: [
                {
                  action: 'event_name', // 设置事件名
                  parameters: {},
                }
              ],
              actionType: wantAgent.OperationType.SEND_COMMON_EVENT,
              requestCode: 0,
              actionFlags: [wantAgent.WantAgentFlags.CONSTANT_FLAG],
            };
            // [End create_pub_event_agent_info]

            // 创建WantAgent
            wantAgent.getWantAgent(wantAgentInfo, (err: BusinessError, data: WantAgent) => {
              if (err) {
                hilog.error(DOMAIN_NUMBER, TAG,
                  `Failed to get want agent. Code is ${err.code}, message is ${err.message}`);
                return;
              }
              hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in getting want agent.');
              wantAgentObj = data;

              // 构造NotificationActionButton对象
              let actionButton: notificationManager.NotificationActionButton = {
                title: 'Test_Title',
                // wantAgentObj使用前需要保证已被赋值（即步骤3执行完成）
                // 通知按钮的WantAgent
                wantAgent: wantAgentObj
              };

              // 构造NotificationRequest对象
              let notificationRequest: notificationManager.NotificationRequest = {
                content: {
                  notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
                  normal: {
                    title: 'Test_Title',
                    text: 'Test_Text',
                    additionalText: 'Test_AdditionalText',
                  },
                },
                id: 6,
                // 通知消息的WantAgent
                wantAgent: wantAgentObj,
                // 通知按钮
                actionButtons: [actionButton],
              };

              notificationManager.publish(notificationRequest, (err: BusinessError) => {
                if (err) {
                  hilog.error(DOMAIN_NUMBER, TAG,
                    `Failed to publish notification. Code is ${err.code}, message is ${err.message}`);
                  return;
                }
                hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in publishing notification.');
              });
            });
          })
      }
      .title('AddBehaviorIntent')
    }
    .height('100%')
    .width('100%')
  }
}