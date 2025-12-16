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

// [Start update_notification_header]
import { notificationManager } from '@kit.NotificationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = '[PublishOperation]';
const DOMAIN_NUMBER: number = 0xFF00;
// [End update_notification_header]

@Entry
@Component
export struct UpdateNotification {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      NavDestination() {
        Button($r('app.string.pub_progress_notify'))
          .margin({ top: 20, bottom: 20 })
          .onClick(() => {
            // [Start pub_progress_bar_notify]
            let notificationRequest: notificationManager.NotificationRequest = {
              id: 5,
              content: {
                notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
                normal: {
                  title: 'test_title',
                  text: 'test_text',
                  additionalText: 'test_additionalText'
                }
              },
              // 构造进度条模板，name字段当前需要固定配置为downloadTemplate
              template: {
                name: 'downloadTemplate',
                data: { title: 'File Title', fileName: 'music.mp4', progressValue: 50 }
              }
            };

            // 发布通知
            notificationManager.publish(notificationRequest, (err: BusinessError) => {
              if (err) {
                hilog.error(DOMAIN_NUMBER, TAG,
                  `Failed to publish notification. Code is ${err.code}, message is ${err.message}`);
                return;
              }
              hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in publishing notification.');
            });
            // [End pub_progress_bar_notify]
          })
        Button($r('app.string.update_notify'))
          .margin({ top: 20, bottom: 20 })
          .onClick(() => {
            // [Start update_prog_only_notify]
            let notificationRequest: notificationManager.NotificationRequest = {
              id: 5,
              updateOnly: true,
              content: {
                notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
                normal: {
                  title: 'test_title',
                  text: 'test_text',
                  additionalText: 'test_additionalText'
                }
              },
              // 构造进度条模板，name字段当前需要固定配置为downloadTemplate
              template: {
                name: 'downloadTemplate',
                data: { title: 'File Title', fileName: 'music.mp4', progressValue: 99 }
              }
            };

            // 更新发布通知
            notificationManager.publish(notificationRequest, (err: BusinessError) => {
              if (err) {
                hilog.error(DOMAIN_NUMBER, TAG,
                  `Failed to update notification. Code is ${err.code}, message is ${err.message}`);
                return;
              }
              hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in updating notification.');
            });
            // [End update_prog_only_notify]
          })
      }
      .title('UpdateNotification')
    }
    .height('100%')
    .width('100%')
  }
}