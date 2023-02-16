/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import notification from '@ohos.notificationManager'
import { WantAgent } from '@ohos.wantAgent'

class NotificationRequestUtil {
  /**
   * init basic NotificationRequest
   * @param notificationContent
   * @return return the created NotificationRequest
   */
  initBasicNotificationRequest(notificationContent: notification.NotificationContent) {
    return {
      slotType: notification.SlotType.CONTENT_INFORMATION,
      id: 1, // 通知id，默认为1
      content: notificationContent
    }
  }

  /**
   * init wantAgent NotificationRequest
   * @param notificationContent
   * @param notificationWantAgent
   * @return return the created NotificationRequest
   */
  initWantAgentNotificationRequest(notificationContent: notification.NotificationContent, notificationWantAgent: WantAgent) {
    return {
      slotType: notification.SlotType.CONTENT_INFORMATION,
      id: 1, // 通知id，默认为1
      content: notificationContent,
      wantAgent: notificationWantAgent
    }
  }


  /**
   * init NotificationRequest width buttons
   * @param notificationContent
   * @param notificationActionButtons
   * @return return the created NotificationRequest
   */
  initButtonNotificationRequest(notificationContent: notification.NotificationContent, notificationActionButtons: notification.NotificationActionButton[]) {
    let actionButtons = notificationActionButtons
    if (notificationActionButtons.length > 2) { // 当前通知接口最大允许有两个按钮，超过两个按钮不展示
      actionButtons = notificationActionButtons.splice(0, 2)
    }
    return {
      slotType: notification.SlotType.CONTENT_INFORMATION,
      id: 1, // 通知id，默认为1
      content: notificationContent,
      actionButtons: actionButtons
    }
  }
}

export let notificationRequestUtil = new NotificationRequestUtil()