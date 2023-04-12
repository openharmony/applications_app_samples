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
import { notificationUtil, notificationContentUtil, notificationRequestUtil, wantAgentUtil } from '@ohos/notification'
import { logger } from '@ohos/details-page-component'

const TAG: string = 'WorkAbility'
const BUNDLE_NAME = 'ohos.samples.orangeshopping'
const ABILITY_NAME = 'MainAbility'
const NOTIFICATION_ID = 1 // 定义发送通知的id,默认1

export default class WorkAbility extends WorkSchedulerExtensionAbility {
  onWorkStart(workInfo) {
    logger.info(TAG, `onWorkStart ${JSON.stringify(workInfo)}`)
    if (workInfo.parameters) {
      this.publishNotification(workInfo.parameters)
    }
  }

  onWorkStop(workInfo) {
    logger.info(TAG, `onWorkStop ${JSON.stringify(workInfo)}`)
    notificationUtil.cancelNotificationById(1)
  }

  publishNotification = async (parameters: any) => {
    let parametersObject = JSON.parse(parameters)
    logger.info(TAG, `publishNotification parametersObject= ${parametersObject}`)
    let basicContent = {
      title: parametersObject.title,
      text: ''
    }
    let actionButtons = [
      {
        title: parametersObject.firstButton,
        wantAgent: await wantAgentUtil.createWantAgentForCommonEvent('')
      },
      {
        title: parametersObject.secondButton,
        wantAgent: await wantAgentUtil.createWantAgentForStartAbility(BUNDLE_NAME, ABILITY_NAME)
      }
    ]
    try {
      let notificationContent = notificationContentUtil.initBasicNotificationContent(basicContent)
      let notificationRequest = notificationRequestUtil.initButtonNotificationRequest(notificationContent, actionButtons)
      notificationUtil.publishNotification(notificationRequest, NOTIFICATION_ID)
    } catch (error) {
      logger.info(TAG, `publish notification error ${JSON.stringify(error)}`)
    }
  }
}