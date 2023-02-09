/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import StaticSubscriberExtensionAbility from '@ohos.application.StaticSubscriberExtensionAbility'
import Notification from '@ohos.notificationManager'
import Logger from '../model/Logger'

const BUNDLE_NAME:string = 'com.samples.staticsubscriber'
export default class StaticSubscriber extends StaticSubscriberExtensionAbility {
  onReceiveEvent(event) {
    Logger.info(`onReceiveEvent hasCalled, event is: ${event.event}`)
    let bundle = {
      bundle: BUNDLE_NAME,
    }
    Notification.setNotificationEnable(bundle, true).then(() => {
      Logger.info('setNotificationEnable success')
    })
    // publish回调
    function publishCallback(err) {
      if (err) {
        Logger.info(`publish failed ${JSON.stringify(err)}`)
      }
    }
    // 通知Request对象
    let notificationRequest = {
      id: 1, // 通知ID
      content: {
        contentType: Notification.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
        normal: {
          title: event.data,
          text: '',
          additionalText: ''
        }
      }
    }
    Notification.publish(notificationRequest, publishCallback)
  }
}