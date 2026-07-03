/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
import { Logger } from './Logger';
import { BusinessError } from '@kit.BasicServicesKit';

export enum NotificationId {
  DUPLICATE_LOGIN
}

const TAG = 'NotificationUtils';

export class NotificationUtils {
  public static async publishNotificationBasic(id: NotificationId, title: string, text: string,
    additionalText?: string) {
    let notificationRequest: notificationManager.NotificationRequest;
    if (additionalText) {
      notificationRequest = {
        id: id,
        content: {
          notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
          normal: {
            title: title,
            text: text,
            additionalText: additionalText
          }
        }
      };
    } else {
      notificationRequest = {
        id: id,
        content: {
          notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
          normal: {
            title: title,
            text: text,
          }
        }
      };
    }
    await notificationManager.publish(notificationRequest!);
  }

  public static async cancelNotification(id: NotificationId) {
    await notificationManager.cancel(id);
  }

  public static async cancelAllNotification() {
    await notificationManager.cancelAll();
  }
}