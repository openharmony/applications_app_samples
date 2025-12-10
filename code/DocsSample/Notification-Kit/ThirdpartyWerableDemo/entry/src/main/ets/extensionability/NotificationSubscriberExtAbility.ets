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
//[Start huidiao_start]
import { hilog } from '@kit.PerformanceAnalysisKit';
import { notificationExtensionSubscription, NotificationSubscriberExtensionAbility } from '@kit.NotificationKit';
//[StartExclude huidiao_start]
import SppClientManager from '../utils/SppClientManager'
//[EndExclude huidiao_start]
const DOMAIN = 0x0000;

export default class NotificationSubscriberExtAbility extends NotificationSubscriberExtensionAbility {
  //[StartExclude huidiao_start]
  private sppClientManager: SppClientManager | undefined;
  //[EndExclude huidiao_start]
  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', 'onDestroy');
    //[StartExclude huidiao_start]
    this.sppClientManager!.stopConnect();
    //[EndExclude huidiao_start]
  }
  //[StartExclude huidiao_start]
  //Called back when a notification is published.
  //[EndExclude huidiao_start]
  onReceiveMessage(notificationInfo: notificationExtensionSubscription.NotificationInfo): void {
    hilog.info(DOMAIN, 'testTag', `on receive message ${JSON.stringify(notificationInfo)}`)
    //[StartExclude huidiao_start]
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
    //[EndExclude huidiao_start]
  }
  //[StartExclude huidiao_start]
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
  //[EndExclude huidiao_start]
  onCancelMessages(hashCodes: Array<string>): void {
    hilog.info(DOMAIN, 'testTag', `on cancel message ${JSON.stringify(hashCodes)}`)
    //[StartExclude huidiao_start]
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
  //[EndExclude huidiao_start]
  }
  //[StartExclude huidiao_start]
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
  //[EndExclude huidiao_start]
}
//[End huidiao_start]
//[End quick_start]