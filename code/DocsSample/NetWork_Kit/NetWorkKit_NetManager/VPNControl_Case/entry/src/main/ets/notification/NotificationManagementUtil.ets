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

import { notificationManager } from '@kit.NotificationKit';
import Logger from '../common/Logger';

const NOTIFICATION_TYPE_SIZE = 5;

export interface getAllNotificationsResultType {
  groupNotifications: Array<Array<notificationManager.NotificationRequest>>;
  countsByType: Array<number>;
}

// Notification management
class NotificationManagementUtil {
  public typeNotifications: Array<Array<notificationManager.NotificationRequest>> = 
    new Array(NOTIFICATION_TYPE_SIZE + 1);
  public countsByType: Array<number> = new Array(NOTIFICATION_TYPE_SIZE + 1);
  public badgeNum: number = 0;

  constructor() {
    this.countsByType.fill(0);
    for (let i = 0; i < NOTIFICATION_TYPE_SIZE + 1; i++) {
      this.typeNotifications[i] = new Array();
    }
    // Get all notifications for the current application.
    notificationManager.getActiveNotifications().then((notifications) => {
      for (let i = 0; i < notifications.length; i++) {
        let typeId = notifications[i].content.notificationContentType;
        this.countsByType[typeId as number] += 1;
        this.typeNotifications[typeId as number].push(notifications[i]);
      }
      Logger.info(`getAllActiveNotifications success, data: ${JSON.stringify(notifications)}`);
      // Calculate the number of badge.
      this.countsByType.forEach((num: number) => {
        this.badgeNum += num;
      })
    })
  }

  // Cancel notifications of this type.
  cancelNotificationType(typeId: number) {
    this.typeNotifications[typeId].forEach(item => {
      notificationManager.cancel(item.id);
    })
  }

  // Display badge
  async setBadgeNumber(num: number) {
    await notificationManager.setBadgeNumber(num).then(() => {
      this.badgeNum = num;
      Logger.info('displayBadge success');
    });
  }

  getBadgeNumber(): number {
    return this.badgeNum;
  }

  // Add a notification.
  async addNotification(notification: notificationManager.NotificationRequest) {
    const typeId: notificationManager.ContentType = 
      notification.content.notificationContentType as notificationManager.ContentType;
    this.typeNotifications[typeId].push(notification);
    this.countsByType[typeId] += 1;
    this.badgeNum += 1;
    await notificationManagement.setBadgeNumber(this.badgeNum);
    Logger.info('add Message success');
  }

  // Get all current notifications and quantities.
  async getAllNotifications() {
    let result: getAllNotificationsResultType = {
      groupNotifications: this.typeNotifications,
      countsByType: this.countsByType
    }
    return result;
  }
}

export let notificationManagement = new NotificationManagementUtil();