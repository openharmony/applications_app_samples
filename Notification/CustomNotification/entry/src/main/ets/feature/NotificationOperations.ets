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

import image from '@ohos.multimedia.image'
import {
  logger,
  notificationUtil,
  notificationContentUtil,
  notificationRequestUtil,
  wantAgentUtil
} from '@ohos/notification'
import notification from '@ohos.notificationManager'

const TAG: string = 'NotificationOperations'
const BUNDLE_NAME: string = 'ohos.samples.customnotification'
const ABILITY_NAME: string = 'MainAbility'
const MULTI_LINE_CONTENT: Array<string> = ['line0', 'line1', 'line2', 'line3'] // 多行文本通知的多行文本内容
const NOTIFICATION_ID = { // 定义不同类型通知的通知id
  BASIC: 1,
  LONG_TEXT: 2,
  MULTI_LINE: 3,
  PICTURE: 4,
  BUTTON: 5,
  WANTAGENT: 6
}

export default class NotificationOperations {
  private context: Context = undefined
  private basicContent: notification.NotificationBasicContent = undefined

  // 在初始化函数初始化基本通知类型的参数
  constructor(context: Context) {
    this.context = context
    let notificationTitle = ''
    let notificationText = this.context.resourceManager.getStringSync($r('app.string.notification_content'))
    let notificationAdditional = this.context.resourceManager.getStringSync($r('app.string.notification_additional'))
    this.basicContent = {
      title: notificationTitle,
      text: notificationText,
      additionalText: notificationAdditional
    }
  }

  // 发布基本类型通知
  publishBasicNotification = () => {
    try {
      logger.info(TAG, `publishBasicNotification`)
      this.basicContent.title = this.context.resourceManager.getStringSync($r('app.string.basic_notification'))
      let notificationContent = notificationContentUtil.initBasicNotificationContent(this.basicContent)
      notificationUtil.publishNotification(notificationRequestUtil.initBasicNotificationRequest(notificationContent), NOTIFICATION_ID.BASIC)
    } catch (error) {
      logger.info(TAG, `publishBasicNotification error, error = ${JSON.stringify(error)}`)
    }
  }

  // 发布长文本类型通知
  publishLongTextNotification = () => {
    try {
      logger.info(TAG, `publishLongTextNotification`)
      this.basicContent.title = this.context.resourceManager.getStringSync($r('app.string.long_text_notification'))
      let notificationLongText = this.context.resourceManager.getStringSync($r('app.string.notification_long_text'))
      let notificationBriefText = this.context.resourceManager.getStringSync($r('app.string.notification_brief_text'))
      let notificationExpandedText = this.context.resourceManager.getStringSync($r('app.string.notification_expanded_title'))
      let notificationContent = notificationContentUtil.initNotificationLongTextContent(this.basicContent, notificationLongText, notificationBriefText, notificationExpandedText)
      notificationUtil.publishNotification(notificationRequestUtil.initBasicNotificationRequest(notificationContent), NOTIFICATION_ID.LONG_TEXT)
    } catch (error) {
      logger.info(TAG, `publishLongTextNotification error, error = ${JSON.stringify(error)}`)
    }
  }

  // 发布多行文本类型通知
  publishMultiLineNotification = () => {
    try {
      logger.info(TAG, `publishMultiLineNotification`)
      this.basicContent.title = this.context.resourceManager.getStringSync($r('app.string.multiline_notification'))
      let notificationBriefText = this.context.resourceManager.getStringSync($r('app.string.notification_brief_text'))
      let notificationLongTitle = this.context.resourceManager.getStringSync($r('app.string.notification_expanded_title'))
      let notificationContent = notificationContentUtil.initNotificationMultiLineContent(this.basicContent, notificationBriefText, notificationLongTitle, MULTI_LINE_CONTENT)
      notificationUtil.publishNotification(notificationRequestUtil.initBasicNotificationRequest(notificationContent), NOTIFICATION_ID.MULTI_LINE)
    } catch (error) {
      logger.info(TAG, `publishMultiLineNotification error, error = ${JSON.stringify(error)}`)
    }
  }

  // 发布图片类型通知
  publishPictureNotification = async () => {
    try {
      logger.info(TAG, `publishPictureNotification`)
      this.basicContent.title = this.context.resourceManager.getStringSync($r('app.string.picture_notification'))
      let notificationBriefText = this.context.resourceManager.getStringSync($r('app.string.notification_brief_text'))
      let notificationExpandedText = this.context.resourceManager.getStringSync($r('app.string.notification_expanded_title'))
      let imageArray = await this.context.resourceManager.getMedia($r('app.media.notification_icon').id)
      let imageResource = image.createImageSource(imageArray.buffer)
      let picture = await imageResource.createPixelMap()
      let notificationContent = notificationContentUtil.initNotificationPictureContent(this.basicContent, notificationBriefText, notificationExpandedText, picture)
      notificationUtil.publishNotification(notificationRequestUtil.initBasicNotificationRequest(notificationContent), NOTIFICATION_ID.PICTURE)
    } catch (error) {
      logger.info(TAG, `publishPictureNotification error, error = ${JSON.stringify(error)}`)
    }
  }

  // 发布带按钮的通知
  publishNotificationWithButtons = async () => {
    try {
      logger.info(TAG, `publishNotificationWithButtons`)
      this.basicContent.title = this.context.resourceManager.getStringSync($r('app.string.notification_with_buttons'))
      let actionButtons = [
        {
          title: this.context.resourceManager.getStringSync($r('app.string.first_button')),
          wantAgent: await wantAgentUtil.createWantAgentForCommonEvent('')
        },
        {
          title: this.context.resourceManager.getStringSync($r('app.string.second_button')),
          wantAgent: await wantAgentUtil.createWantAgentForStartAbility(BUNDLE_NAME, ABILITY_NAME)
        }
      ]
      let notificationContent = notificationContentUtil.initBasicNotificationContent(this.basicContent)
      let notificationRequest = notificationRequestUtil.initButtonNotificationRequest(notificationContent, actionButtons)
      notificationUtil.publishNotification(notificationRequest, NOTIFICATION_ID.BUTTON)
    } catch (error) {
      logger.info(TAG, `publishNotificationWithButtons error, error = ${JSON.stringify(error)}`)
    }
  }

  // 发布点击跳转到应用的通知
  publishNotificationWithWantAgent = async () => {
    try {
      logger.info(TAG, `publishNotificationWithWantAgent`)
      this.basicContent.title = this.context.resourceManager.getStringSync($r('app.string.clickable_notification'))
      let notificationWantAgent = await wantAgentUtil.createWantAgentForStartAbility(BUNDLE_NAME, ABILITY_NAME)
      let notificationContent = notificationContentUtil.initBasicNotificationContent(this.basicContent)
      let notificationRequest = notificationRequestUtil.initWantAgentNotificationRequest(notificationContent, notificationWantAgent)
      notificationUtil.publishNotification(notificationRequest, NOTIFICATION_ID.WANTAGENT)
    } catch (error) {
      logger.info(TAG, `publishNotificationWithWantAgent error, error = ${JSON.stringify(error)}`)
    }
  }
}