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

// [Start request_enable_notification_header]
import { notificationManager } from '@kit.NotificationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { common } from '@kit.AbilityKit';

const TAG: string = '[PublishOperation]';
const DOMAIN_NUMBER: number = 0xFF00;

// [End request_enable_notification_header]

@Entry
@Component
export struct RequestEnableNotification {
  @Consume('pageInfos') pageInfos: NavPathStack;

  build() {
    NavDestination() {
      Column() {
        Button($r('app.string.request_notify_auth'))
          .margin({ top: 20, bottom: 20 })
          .onClick(() => {
            // [Start request_enable_notification_permission]
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            notificationManager.isNotificationEnabled().then((data: boolean) => {
              hilog.info(DOMAIN_NUMBER, TAG, 'isNotificationEnabled success, data: ' + JSON.stringify(data));
              if (!data) {
                notificationManager.requestEnableNotification(context).then(() => {
                  hilog.info(DOMAIN_NUMBER, TAG, `[ANS] requestEnableNotification success`);
                }).catch((err: BusinessError) => {
                  if (1600004 == err.code) {
                    hilog.error(DOMAIN_NUMBER, TAG,
                      `[ANS] requestEnableNotification refused, code is ${err.code}, message is ${err.message}`);
                  } else {
                    hilog.error(DOMAIN_NUMBER, TAG,
                      `[ANS] requestEnableNotification failed, code is ${err.code}, message is ${err.message}`);
                  }
                });
              }
            }).catch((err: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG,
                `isNotificationEnabled fail, code is ${err.code}, message is ${err.message}`);
            });
            // [End request_enable_notification_permission]
          })

        Button($r('app.string.cancel_notify_auth'))
          .margin({ top: 20, bottom: 20 })
          .onClick(() => {
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            notificationManager.isNotificationEnabled().then((data: boolean) => {
              hilog.info(DOMAIN_NUMBER, TAG, 'isNotificationEnabled failed, data: ' + JSON.stringify(data));
              if (data) {
                notificationManager.openNotificationSettings(context).then(() => {
                  hilog.info(DOMAIN_NUMBER, TAG, `[ANS] openNotificationSettings fail`);
                }).catch((err: BusinessError) => {
                  hilog.error(DOMAIN_NUMBER, TAG,
                    `[ANS] openNotificationSettings successed, code is ${err.code}, message is ${err.message}`);
                });
              }
            }).catch((err: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG,
                `isNotificationEnabled success, code is ${err.code}, message is ${err.message}`);
            });
          })

        Button($r('app.string.reapply_notify_auth'))
          .margin({ top: 20, bottom: 20 })
          .onClick(() => {
            // [Start reapply_notify_auth_halfmodal]
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            notificationManager.isNotificationEnabled().then((data: boolean) => {
              hilog.info(DOMAIN_NUMBER, TAG, 'isNotificationEnabled success, data: ' + JSON.stringify(data));
              if (!data) {
                notificationManager.openNotificationSettings(context).then(() => {
                  hilog.info(DOMAIN_NUMBER, TAG, `[ANS] openNotificationSettings success`);
                }).catch((err: BusinessError) => {
                  hilog.error(DOMAIN_NUMBER, TAG,
                    `[ANS] openNotificationSettings failed, code is ${err.code}, message is ${err.message}`);
                });
              }
            }).catch((err: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG,
                `isNotificationEnabled fail, code is ${err.code}, message is ${err.message}`);
            });
            // [End reapply_notify_auth_halfmodal]
          })
      }
      .width('100%')
      .height('100%')

    }
    .title('RequestEnableNotification')
  }
}