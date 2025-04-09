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
import { BusinessError } from '@kit.BasicServicesKit';
import { notificationManagement } from '../notification/NotificationManagementUtil';
import Logger from '../common/Logger';

const TAG: string = 'NotificationUtilModel';

class NotificationUtil {
  /**
   * enable notification
   */
  private id: number = 0;

  async enableNotification() {
    try {
      notificationManager.requestEnableNotification(AppStorage.get('context'), (err: BusinessError): void => {
        if (err) {
          Logger.error(TAG, `requestEnableNotification failed, code is ${err.code}, message is ${err.message}`);
        } else {
          Logger.info(TAG, 'requestEnableNotification success');
        }
      });
      Logger.info(TAG, `enableNotification success`);
    } catch (err) {
      Logger.info(TAG, `enableNotification err ${JSON.stringify(err)}`);
    }
  }

  /**
   *
   * @param notificationRequest
   * @param id, Support specifying notification id when publishing notifications
   */
  async publishNotification(notificationRequest: notificationManager.NotificationRequest, group?: string) {
    notificationRequest.id = this.id;
    this.id++;
    if (group) {
      notificationRequest.groupName = group;
    }

    try {
      await notificationManager.publish(notificationRequest);
      // Notify manager add new notification.
      await notificationManagement.addNotification(notificationRequest);
    } catch (err) {
      if (err) {
        Logger.info(TAG, `publishNotification err ${JSON.stringify(err)}`);
      }
    }
  }

  /**
   * cancel notification by id
   */
  async cancelNotificationById(id: number) {
    try {
      await notificationManager.cancel(id);
      Logger.info(TAG, `cancel success`);
    } catch (err) {
      if (err) {
        Logger.info(TAG, `cancel err ${JSON.stringify(err)}`);
      }
    }
  }

  /**
   * cancel all notification
   */
  async cancelAllNotifications() {
    try {
      await notificationManager.cancelAll();
      Logger.info(TAG, `cancel all success`);
    } catch (err) {
      if (err) {
        Logger.info(TAG, `cancel all err ${JSON.stringify(err)}`);
      }
    }
  }
}

export let notificationUtil = new NotificationUtil();