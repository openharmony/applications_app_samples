/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import StaticSubscriberExtensionAbility from '@ohos.application.StaticSubscriberExtensionAbility';
import type Base from '@ohos.base';
import type commonEventManager from '@ohos.commonEventManager';
import notificationManager from '@ohos.notificationManager';
import hilog from '@ohos.hilog';

const DOMAIN_NUMBER: number = 0xFF00;
const TAG: string = 'StaticSubscriber';

export default class StaticSubscriber extends StaticSubscriberExtensionAbility {
  onReceiveEvent(event: commonEventManager.CommonEventData): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'onReceiveEvent, event: ' + event.event);
    // 发布通知事件
    let bundle = {
      bundle: 'com.samples.stageprocessthread',
    };
    notificationManager.setNotificationEnable(bundle, true).then(() => {
      hilog.info(DOMAIN_NUMBER, TAG, 'setNotificationEnable success');
    });

    let notificationRequest: notificationManager.NotificationRequest = {
      id: 1,
      content: {
        // @ts-ignore
        contentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
        normal: {
          title: event.event,
          text: event.data,
          additionalText: JSON.stringify(event.parameters)
        }
      }
    };
    notificationManager.publish(notificationRequest).then(() => {
      hilog.info(DOMAIN_NUMBER, TAG, 'publish success');
    }).catch((err: Base.BusinessError) => {
      hilog.error(DOMAIN_NUMBER, TAG, `publish fail: ${JSON.stringify(err)}`);
    });
  }
}