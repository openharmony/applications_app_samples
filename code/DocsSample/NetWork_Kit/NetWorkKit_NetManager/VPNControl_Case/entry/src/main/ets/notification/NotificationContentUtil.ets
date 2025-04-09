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

class NotificationContentUtil {
  /**
   * init basic notification content
   * @param basicContent
   * @return return the created NotificationContent
   */
  initBasicNotificationContent(
    basicContent: notification.NotificationBasicContent
    ): notification.NotificationContent {
    return {
      notificationContentType: notification.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT, // 通知内容类型
      normal: basicContent // 基本类型通知内容
    };
  }
}

export let notificationContentUtil = new NotificationContentUtil();