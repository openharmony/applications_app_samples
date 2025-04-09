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

import notification from '@ohos.notificationManager';
import Logger from '../common/Logger';
import { notificationContentUtil } from './NotificationContentUtil';
import { notificationRequestUtil } from './NotificationRequestUtil';
import { notificationUtil } from './NotificationUtil';
import { wantAgentUtil } from './WantAgentUtil';

const BUNDLE_NAME: string = 'com.samples.vpncontrol_case';
const ABILITY_NAME: string = 'EntryAbility';

export default class NotificationOperations {
  private context: Context | undefined = undefined;
  private basicContent: notification.NotificationBasicContent | undefined = undefined;

  // 在初始化函数初始化基本通知类型的参数
  constructor(context: Context) {
    this.context = context;
    let notificationTitle = '';
    let notificationText = this.context.resourceManager.getStringSync($r('app.string.notification_content'));
    let notificationAdditional = this.context.resourceManager.getStringSync($r('app.string.notification_additional'));
    this.basicContent = {
      title: notificationTitle,
      text: notificationText,
      additionalText: notificationAdditional
    };
  }

  // 发布点击跳转到应用的通知
  publishNotificationWithWantAgent = async () => {
    try {
      if (this.context !== undefined && this.context !== null && this.basicContent !== undefined &&
        this.basicContent !== null) {
        this.basicContent.title = this.context.resourceManager.getStringSync($r('app.string.vpn_clickable_notification'));
        this.basicContent.text = this.context.resourceManager.getStringSync($r('app.string.vpn_clickable_information'));
        let notificationWantAgent = await wantAgentUtil.createWantAgentForStartAbility(BUNDLE_NAME, ABILITY_NAME);
        let notificationContent = notificationContentUtil.initBasicNotificationContent(this.basicContent);
        let notificationRequest =
          notificationRequestUtil.initWantAgentNotificationRequest(notificationContent, notificationWantAgent);
        notificationUtil.publishNotification(notificationRequest);
      }
    } catch (error) {
      Logger.info(`publishNotificationWithWantAgent error, error = ${JSON.stringify(error)}`);
    }
  }
}
