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

//[Start quick_start]
import { hilog } from '@kit.PerformanceAnalysisKit';
import { notificationExtensionSubscription, NotificationSubscriberExtensionAbility } from '@kit.NotificationKit';
import SppClientManager from '../utils/SppClientManager'

const DOMAIN = 0x0000;

export default class NotificationSubscriberExtAbility extends NotificationSubscriberExtensionAbility {
  private sppClientManager: SppClientManager | undefined;

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', 'onDestroy');
    this.sppClientManager!.stopConnect();
  }

  //Called back when a notification is published.
  onReceiveMessage(notificationInfo: notificationExtensionSubscription.NotificationInfo): void {
    hilog.info(DOMAIN, 'testTag', `on receive message ${JSON.stringify(notificationInfo)}`)
    notificationExtensionSubscription.getSubscribeInfo()
      .then(info => {
        if (this.sppClientManager == undefined) {
          this.sppClientManager = new SppClientManager(info[0].addr);
        }
        if (this.sppClientManager.isConnect()) {
          this.sendPublishWithRetry(notificationInfo);
        } else {
          this.sppClientManager.startConnect()
          setTimeout(() => {
            this.sendPublishWithRetry(notificationInfo);
          }, 3000)
        }
      })
  }

  // Sends a publish notification and retries once upon failure.
  private sendPublishWithRetry(notificationInfo: notificationExtensionSubscription.NotificationInfo) {
    try {
      this.sppClientManager!.sendNotificationData(notificationInfo);
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', `send failed, errCode ${err.code}, errorMessage ${err.message}, and retry one times`);
      this.sppClientManager!.startConnect();
      setTimeout(() => {
        this.sppClientManager!.sendNotificationData(notificationInfo);
      }, 3000);
    }
  }

  //Called back when notifications is cancelled.
  onCancelMessages(hashCodes: Array<string>): void {
    hilog.info(DOMAIN, 'testTag', `on cancel message ${JSON.stringify(hashCodes)}`)
    notificationExtensionSubscription.getSubscribeInfo()
      .then(info => {
        if (this.sppClientManager == undefined) {
          this.sppClientManager = new SppClientManager(info[0].addr);
        }
        if (this.sppClientManager.isConnect()) {
          this.sendCancelWithRetry(hashCodes);
        } else {
          this.sppClientManager.startConnect()
          setTimeout(() => {
            this.sendCancelWithRetry(hashCodes);
          }, 3000)
        }
      })
  }

  // Retries a cancel operation if it fails.
  private sendCancelWithRetry(hashCodes: string[]) {
    try {
      this.sppClientManager!.sendCancelNotificationData(hashCodes);
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', `send failed, errCode ${err.code}, errorMessage ${err.message}, and retry one times`);
      this.sppClientManager!.startConnect();
      setTimeout(() => {
        this.sppClientManager!.sendCancelNotificationData(hashCodes);
      }, 3000);
    }
  }
}
//[End quick_start]