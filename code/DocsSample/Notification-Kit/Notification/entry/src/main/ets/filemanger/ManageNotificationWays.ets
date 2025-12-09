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

// [Start manage_notification_ways_header]
import { notificationManager } from '@kit.NotificationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = '[PublishOperation]';
const DOMAIN_NUMBER: number = 0xFF00;
// [End manage_notification_ways_header]

@Entry
@Component
export struct ManageNotificationWays {
  build() {
    RelativeContainer() {
      NavDestination() {
        Button($r('app.string.create_channel_type'))
          .margin({ top: 20, bottom: 20 })
          .onClick(() => {
            // [Start create_type_channel]
            // addSlot回调
            let addSlotCallBack = (err: BusinessError): void => {
              if (err) {
                hilog.error(DOMAIN_NUMBER, TAG, `addSlot failed, code is ${err.code}, message is ${err.message}`);
              } else {
                hilog.info(DOMAIN_NUMBER, TAG, `addSlot success`);
              }
            };
            notificationManager.addSlot(notificationManager.SlotType.SOCIAL_COMMUNICATION, addSlotCallBack);
            // [End create_type_channel]
          })
        Button($r('app.string.get_channel_type'))
          .margin({ top: 20, bottom: 20 })
          .onClick(() => {
            // [Start get_type_channel]
            // getSlot回调
            let getSlotCallback = (err: BusinessError, data: notificationManager.NotificationSlot): void => {
              if (err) {
                hilog.error(DOMAIN_NUMBER, TAG, `Failed to get slot. Code is ${err.code}, message is ${err.message}`);
              } else {
                hilog.info(DOMAIN_NUMBER, TAG, `Succeeded in getting slot.`);
                if (data != null) {
                  hilog.info(DOMAIN_NUMBER, TAG, `slot enable status is ${JSON.stringify(data.enabled)}`);
                  hilog.info(DOMAIN_NUMBER, TAG, `vibrationEnabled status is ${JSON.stringify(data.vibrationEnabled)}`);
                  hilog.info(DOMAIN_NUMBER, TAG, `lightEnabled status is ${JSON.stringify(data.lightEnabled)}`);
                }
              }
            };
            let slotType: notificationManager.SlotType = notificationManager.SlotType.SOCIAL_COMMUNICATION;
            notificationManager.getSlot(slotType, getSlotCallback);
            // [End get_type_channel]
          })
        Button($r('app.string.delete_channel_type'))
          .margin({ top: 20, bottom: 20 })
          .onClick(() => {
            // [Start delete_type_channel]
            // removeSlot回调
            let removeSlotCallback = (err: BusinessError): void => {
              if (err) {
                hilog.error(DOMAIN_NUMBER, TAG,
                  `removeSlot failed, code is ${JSON.stringify(err.code)}, message is ${JSON.stringify(err.message)}`);
              } else {
                hilog.info(DOMAIN_NUMBER, TAG, 'removeSlot success');
              }
            };
            let slotType: notificationManager.SlotType = notificationManager.SlotType.SOCIAL_COMMUNICATION;
            notificationManager.removeSlot(slotType, removeSlotCallback);
            // [End delete_type_channel]
          })
      }
      .title('ManageNotificationWays')
    }
    .height('100%')
    .width('100%')
  }
}