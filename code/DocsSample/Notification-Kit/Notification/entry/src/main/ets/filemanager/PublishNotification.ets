/*
 * Copyright (c) 2025-2026 Huawei Device Co., Ltd.
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

// [Start publish_notification_header]
import { notificationManager } from '@kit.NotificationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = '[PublishOperation]';
const DOMAIN_NUMBER: number = 0xFF00;
// [End publish_notification_header]

@Entry
@Component
export struct PublishNotification {
  build() {
    RelativeContainer() {
      NavDestination() {
        Button($r('app.string.pub_plaintext_notify'))
          .margin({ top: 20, bottom: 20 })
          .onClick(() => {
            // [Start pub_plaintext_req_notify]
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
            // [End pub_plaintext_req_notify]
          })
        Button($r('app.string.pub_multi_line_notify'))
          .margin({ top: 20, bottom: 20 })
          .onClick(() => {
            // [Start pub_multi_line_req_notify]
            let notificationRequest: notificationManager.NotificationRequest = {
              id: 3,
              content: {
                notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_MULTILINE, // 多行文本类型通知
                multiLine: {
                  title: 'test_multi_line_title',
                  text: 'test_text',
                  briefText: 'test_briefText',
                  longTitle: 'test_longTitle',
                  lines: ['line_01', 'line_02', 'line_03'],
                }
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
            // [End pub_multi_line_req_notify]
          })
        Button($r('app.string.check_progress_template_notify'))
          .margin({ top: 20, bottom: 20 })
          .onClick(() => {
            // [Start check_progress_template_download]
            notificationManager.isSupportTemplate('downloadTemplate').then((data: boolean) => {
              let isSupportTemplate: boolean = data; // isSupportTemplate的值为true表示支持downloadTemplate模板类通知，false表示不支持
              hilog.info(DOMAIN_NUMBER, TAG,
                `Succeeded in supporting download template notification. data is ${isSupportTemplate}`);
            }).catch((err: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG,
                `Failed to support download template notification. Code is ${err.code}, message is ${err.message}`);
            });
            // [End check_progress_template_download]
            AppStorage.setOrCreate<string>('check_notify','success');
          })
        Button($r('app.string.pub_progress_notify'))
          .margin({ top: 20, bottom: 20 })
          .onClick(() => {
            // [Start pub_progress_template_req_notify]
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
                data: { title: 'File Title', fileName: 'music.mp4', progressValue: 45 }
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
            // [End pub_progress_template_req_notify]
          })
      }
      .title('PublishNotification')
    }
    .height('100%')
    .width('100%')
  }
}