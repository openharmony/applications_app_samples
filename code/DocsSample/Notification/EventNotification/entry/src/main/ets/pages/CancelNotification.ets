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

// [Start cancel_notification_header]
import { notificationManager } from '@kit.NotificationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = '[PublishOperation]';
const DOMAIN_NUMBER: number = 0xFF00;
// [End cancel_notification_header]

@Entry
@Component
export struct CancelNotification {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      NavDestination() {
        Button($r('app.string.plain_text_notify'))
          .margin({ top: 20, bottom: 20 })
          .onClick(() => {
            let notificationRequest: notificationManager.NotificationRequest = {
              id: 1,
              content: {
                notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT, // 普通文本类型通知
                normal: {
                  title: 'test_title',
                  text: 'test_text',
                  additionalText: 'test_additionalText',
                }
              }
            };
            notificationManager.publish(notificationRequest, (err: BusinessError) => {
              if (err) {
                hilog.error(DOMAIN_NUMBER, TAG,
                  `Failed to publish notification. Code is ${err.code}, message is ${err.message}`);
                return;
              }
              hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in publishing notification.');
            });
          })
        Button($r('app.string.cancel_notify'))
          .margin({ top: 20, bottom: 20 })
          .onClick(() => {
            // [Start cancel_notification_content]
            // 当拉起应用到前台，查看消息后，调用该接口取消通知。
            notificationManager.cancel(1, (err: BusinessError) => {
              if (err) {
                hilog.error(DOMAIN_NUMBER, TAG,
                  `Failed to cancel notification. Code is ${err.code}, message is ${err.message}`);
                return;
              }
              hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in canceling notification.');
            });
            // [End cancel_notification_content]
          })
      }
      .title('CancelNotification')
    }
    .height('100%')
    .width('100%')
  }
}