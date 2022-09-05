/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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

import notify from '@ohos.notification'

export default class Notification {
  getNotificationContentBasic(notifyTitle: string, notifyText: string, notifyAdditionalText: string) {
    let notificationRequest = {
      id: 1,
      content: {
        contentType: notify.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
        normal: {
          title: notifyTitle, // 通知标题
          text: notifyText, // 通知内容
          additionalText: notifyAdditionalText, // 通知次要内容，是对通知内容的补充
        }
      }
    }
    return notificationRequest
  }

  publish(notificationRequest, callback) {
    notify.publish(notificationRequest, callback)
  }
}

export const notification = new Notification()