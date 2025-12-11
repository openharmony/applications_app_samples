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
export struct AddWantAgent {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      NavDestination() {
        Button($r('app.string.publish_no_button_notify'))
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

              // 构造NotificationRequest对象
              let notificationRequest: notificationManager.NotificationRequest = {
                content: {
                  notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
                  normal: {
                    title: 'no_button_notify',
                    text: 'Click this notification to open the app',
                    additionalText: 'Test_AdditionalText',
                  },
                },
                id: 6,
                // 通知消息的WantAgent
                wantAgent: wantAgentObj
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
        Button($r('app.string.publish_one_button_notify'))
          .margin({ top: 20, bottom: 20 })
          .onClick(() => {
            // [Start create_launch_uiability_agent_info]
            let wantAgentObj: WantAgent; // 用于保存创建成功的wantAgent对象，后续使用其完成触发的动作。

            // 通过WantAgentInfo的operationType设置动作类型
            let wantAgentInfo: wantAgent.WantAgentInfo = {
              wants: [
                {
                  deviceId: '',
                  bundleName: 'com.sample.eventnotification', // 需要替换为对应的bundleName。
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
                title: 'open_the_app',
                // wantAgentObj使用前需要保证已被赋值（即步骤3执行完成）
                // 通知按钮的WantAgent
                wantAgent: wantAgentObj
              };

              // 构造NotificationRequest对象
              let notificationRequest: notificationManager.NotificationRequest = {
                content: {
                  notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
                  normal: {
                    title: 'one_button_notify',
                    text: 'Click on this notification twice to open the app',
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
        Button($r('app.string.publish_two_button_notify'))
          .margin({ top: 20, bottom: 20 })
          .onClick(() => {
            // 用于保存“拉起应用”的WantAgent对象，后续使用其完成触发的动作。
            let startAbilityWantAgentObj: WantAgent | null = null;
            // 通过WantAgentInfo的operationType设置动作类型
            let startAbilityWantAgentInfo: wantAgent.WantAgentInfo = {
              wants: [
                {
                  deviceId: '',
                  bundleName: 'com.sample.eventnotification', // 替换为你的实际包名
                  abilityName: 'EntryAbility', // 替换为你的实际Ability名
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

            // 用于保存“发布公共事件”的WantAgent对象,后续使用其完成触发的动作。
            let pubEventWantAgentObj: WantAgent | null = null;
            // 发布公共事件的WantAgent配置
            const pubEventWantAgentInfo: wantAgent.WantAgentInfo = {
              wants: [
                {
                  action: 'event_name', // 设置事件名
                  parameters: {},
                }
              ],
              actionType: wantAgent.OperationType.SEND_COMMON_EVENT,
              requestCode: 1,
              actionFlags: [wantAgent.WantAgentFlags.CONSTANT_FLAG],
            };

            // 注意：ArkTS不支持箭头函数直接作为回调参数的解构，所以用普通函数+Promise封装
            const createWantAgent = (info: wantAgent.WantAgentInfo): Promise<WantAgent> => {
              return new Promise((resolve, reject) => {
                wantAgent.getWantAgent(info, (err: BusinessError, data: WantAgent) => {
                  if (err) {
                    reject(err);
                  } else {
                    resolve(data);
                  }
                });
              });
            };

            Promise.all([
              createWantAgent(startAbilityWantAgentInfo), // 任务1：创建“拉起应用”的Agent
              createWantAgent(pubEventWantAgentInfo)// 任务2：创建“发布事件”的Agent
            ])
              .then((result: WantAgent[]) => {
                // 用索引访问数组元素（ArkTS支持）
                startAbilityWantAgentObj = result[0]; // 第一个结果：拉起应用的Agent
                pubEventWantAgentObj = result[1]; // 第二个结果：发布事件的Agent

                hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in getting both want agents');

                // 第一个按钮：open_the_app（拉起应用）
                const actionButtonOne: notificationManager.NotificationActionButton = {
                  title: 'open_the_app', // 英文标题
                  wantAgent: startAbilityWantAgentObj! // 绑定“拉起应用”的Agent（!表示非空断言，确保已赋值）
                };

                // 第二个按钮：Publish Common Event（发布公共事件）
                const actionButtonTwo: notificationManager.NotificationActionButton = {
                  title: 'Publish Common Event', // 英文标题
                  wantAgent: pubEventWantAgentObj! // 绑定“发布事件”的Agent
                };

                const notificationRequest: notificationManager.NotificationRequest = {
                  content: {
                    notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
                    normal: {
                      title: 'two_buttons_notify', // 通知标题
                      text: 'Click on this notification twice to open the app.', // 正文
                      additionalText: 'Dual-action Test' // 附加文本（可选）
                    },
                  },
                  id: 7, // 唯一ID
                  wantAgent: startAbilityWantAgentObj!, // 点击通知本身→拉起应用
                  actionButtons: [actionButtonOne, actionButtonTwo] // 两个按钮按顺序排列
                };

                notificationManager.publish(notificationRequest, (err: BusinessError) => {
                  if (err) {
                    hilog.error(DOMAIN_NUMBER, TAG,
                      `Failed to publish two-button notification. Code: ${err.code}, Msg: ${err.message}`);
                    return;
                  }
                  hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in publishing two-button notification');
                });
              })
              .catch((err: BusinessError) => {
                // 捕获任一WantAgent创建失败的错误
                hilog.error(DOMAIN_NUMBER, TAG,
                  `Failed to create want agent. Code: ${err.code}, Msg: ${err.message}`);
              });
          });
      }
      .title('AddWantAgent')
    }
    .height('100%')
    .width('100%')
  }
}