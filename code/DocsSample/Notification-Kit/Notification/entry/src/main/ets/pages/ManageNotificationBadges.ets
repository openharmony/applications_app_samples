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

// [Start manage_notification_badges_header]
import { notificationManager } from '@kit.NotificationKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG: string = '[PublishOperation]';
const DOMAIN_NUMBER: number = 0xFF00;
// [End manage_notification_badges_header]

@Entry
@Component
export struct ManageNotificationBadges {
  @State badgeNum: number = 0;

  build() {
    NavDestination() {
      Button($r('app.string.increase_badge_count'))
        .margin({ top: 20, bottom: 20 })
        .onClick(() => {
          if (this.badgeNum < 100) {
            this.badgeNum++;
          }
          notificationManager.setBadgeNumber(this.badgeNum).then(() => {
            hilog.info(DOMAIN_NUMBER, TAG, `Succeeded in setting badge number.`);
          }).catch((err: BusinessError) => {
            hilog.error(DOMAIN_NUMBER, TAG,
              `Failed to set badge number. Code is ${err.code}, message is ${err.message}`);
          });
        })
      Button($r('app.string.reduce_notify_badge'))
        .margin({ top: 20, bottom: 20 })
        .onClick(() => {
          if (this.badgeNum > 0) {
            this.badgeNum--;
          }
          notificationManager.setBadgeNumber(this.badgeNum).then(() => {
            hilog.info(DOMAIN_NUMBER, TAG, `Succeeded in setting badge number.`);
          }).catch((err: BusinessError) => {
            hilog.error(DOMAIN_NUMBER, TAG,
              `Failed to set badge number. Code is ${err.code}, message is ${err.message}`);
          });
        })
      Button($r('app.string.set_badge_nine'))
        .margin({ top: 20, bottom: 20 })
        .onClick(() => {
          // [Start add_badge_count]
          let badgeNumber: number = 9;
          notificationManager.setBadgeNumber(badgeNumber).then(() => {
            hilog.info(DOMAIN_NUMBER, TAG, `Succeeded in setting badge number.`);
          }).catch((err: BusinessError) => {
            hilog.error(DOMAIN_NUMBER, TAG,
              `Failed to set badge number. Code is ${err.code}, message is ${err.message}`);
          });
          // [End add_badge_count]
        })
      Button($r('app.string.set_badge_eight'))
        .margin({ top: 20, bottom: 20 })
        .onClick(() => {
          // [Start reduce_badge_count]
          let badgeNumber: number = 8;
          notificationManager.setBadgeNumber(badgeNumber).then(() => {
            hilog.info(DOMAIN_NUMBER, TAG, `Succeeded in setting badge number.`);
          }).catch((err: BusinessError) => {
            hilog.error(DOMAIN_NUMBER, TAG,
              `Failed to set badge number. Code is ${err.code}, message is ${err.message}`);
          });
          // [End reduce_badge_count]
        })
      Button($r('app.string.badge_count_neg'))
        .margin({ top: 20, bottom: 20 })
        .onClick(() => {
          // [Start increase_badge_count_seq]
          let badgeNumber: number = 10;
          notificationManager.setBadgeNumber(badgeNumber).then(() => {
            hilog.info(DOMAIN_NUMBER, TAG, `setBadgeNumber 10 success.`);
          }).catch((err: BusinessError) => {
            hilog.error(DOMAIN_NUMBER, TAG,
              `Failed to set badge number. Code is ${err.code}, message is ${err.message}`);
          });
          badgeNumber = 11;
          notificationManager.setBadgeNumber(badgeNumber).then(() => {
            hilog.info(DOMAIN_NUMBER, TAG, `setBadgeNumber 11 success.`);
          }).catch((err: BusinessError) => {
            hilog.error(DOMAIN_NUMBER, TAG,
              `Failed to set badge number. Code is ${err.code}, message is ${err.message}`);
          });
          // [End increase_badge_count_seq]
        })
      Button($r('app.string.badge_count_pos'))
        .margin({ top: 20, bottom: 20 })
        .onClick(() => {
          // [Start update_badge_count_idempotent]
          let badgeNumber: number = 10;
          notificationManager.setBadgeNumber(badgeNumber).then(() => {
            hilog.info(DOMAIN_NUMBER, TAG, `setBadgeNumber 10 success.`);
            badgeNumber = 11;
            notificationManager.setBadgeNumber(badgeNumber).then(() => {
              hilog.info(DOMAIN_NUMBER, TAG, `setBadgeNumber 11 success.`);
            }).catch((err: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG,
                `Failed to set badge number. Code is ${err.code}, message is ${err.message}`);
            });
          }).catch((err: BusinessError) => {
            hilog.error(DOMAIN_NUMBER, TAG,
              `Failed to set badge number. Code is ${err.code}, message is ${err.message}`);
          });
          // [End update_badge_count_idempotent]
        })

      Button($r('app.string.pub_plaintext_notify'))
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
            if (this.badgeNum < 100) {
              this.badgeNum++;
            }
            notificationManager.setBadgeNumber(this.badgeNum).then(() => {
              hilog.info(DOMAIN_NUMBER, TAG, `Succeeded in setting badge number.`);
            }).catch((err: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG,
                `Failed to set badge number. Code is ${err.code}, message is ${err.message}`);
            });
            hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in publishing notification.');
          });
        })
      Button($r('app.string.delete_badge_count'))
        .margin({ top: 20, bottom: 20 })
        .onClick(() => {
          this.badgeNum = 0;
          notificationManager.setBadgeNumber(this.badgeNum).then(() => {
            hilog.info(DOMAIN_NUMBER, TAG, `Succeeded in setting badge number.`);
          }).catch((err: BusinessError) => {
            hilog.error(DOMAIN_NUMBER, TAG,
              `Failed to set badge number. Code is ${err.code}, message is ${err.message}`);
          });
        })
    }
    .title('ManageNotificationBadges')
    .height('100%')
    .width('100%')
  }
}