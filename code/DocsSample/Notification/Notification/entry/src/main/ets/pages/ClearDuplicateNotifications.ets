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

// [Start clear_duplicate_notifications_header]
import { notificationManager } from '@kit.NotificationKit';
import { BusinessError } from '@kit.BasicServicesKit';
// [End clear_duplicate_notifications_header]

@Entry
@Component
export struct ClearDuplicateNotifications {
  build() {
    RelativeContainer() {
      NavDestination() {
        Button($r('app.string.pub_notify_with_msgid'))
          .margin({ top: 20, bottom: 20 })
          .onClick(() => {
            // [Start pub_appmsgid_notify]
            // publish回调
            let publishCallback = (err: BusinessError): void => {
              if (err) {
                console.error(`Failed to publish notification. Code is ${err.code}, message is ${err.message}`);
              } else {
                console.info(`Succeeded in publishing notification.`);
              }
            };
            // 通知Request对象
            let notificationRequest: notificationManager.NotificationRequest = {
              id: 1,
              content: {
                notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
                normal: {
                  title: 'test_title',
                  text: 'test_text',
                  additionalText: 'test_additionalText'
                }
              },
              appMessageId: 'test_appMessageId_1'
            };
            notificationManager.publish(notificationRequest, publishCallback);
            // [End pub_appmsgid_notify]
          })

      }
      .title('ClearDuplicateNotifications')
    }
    .height('100%')
    .width('100%')
  }
}