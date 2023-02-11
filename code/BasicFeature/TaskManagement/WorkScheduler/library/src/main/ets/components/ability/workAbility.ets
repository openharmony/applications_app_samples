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

import WorkSchedulerExtensionAbility from '@ohos.WorkSchedulerExtensionAbility'
import { notification, Logger } from '@ohos/notification'

const TAG: string = 'WorkSchedulerExtension'
const upgradeMessage: string = 'upgrade version3.2.5.6'
export default class workAbility extends WorkSchedulerExtensionAbility {
  onWorkStart(workInfo) {
    Logger.info(TAG, `onWorkStart CommonEvent publish start ${JSON.stringify(workInfo)}`)
    let notificationRequest = notification.getNotificationContentBasic('upgrade', upgradeMessage, '')
    notification.publish(notificationRequest, (err) => {
      if (err) {
        Logger.info(TAG, `onWorkStart notification publish err ${JSON.stringify(err)}`)
      }
      Logger.info(TAG, `onWorkStart notification publish success`)
    })
  }

  onWorkStop(workInfo) {
    let notificationRequest = notification.getNotificationContentBasic('upgrade', 'upgrade success', '')
    notification.publish(notificationRequest, (err) => {
      if (err) {
        Logger.info(TAG, `onWorkStop notification publish err ${JSON.stringify(err)}`)
      }
      Logger.info(TAG, `onWorkStop notification publish success`)
    })
  }
}
