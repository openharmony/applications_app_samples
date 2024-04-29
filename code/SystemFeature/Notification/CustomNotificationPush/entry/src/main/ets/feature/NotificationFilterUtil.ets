/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import notification from '@ohos.notificationManager';
import { logger } from '../util/Logger';
import Base from '@ohos.base';

const BUNDLE_NAME: string = 'com.example.CustomNotificationPush';

export enum ContentCallBackType {
  CALLBACK_NOTIFICATION_CONTENT_BASIC_TEXT = 1,
  CALLBACK_NOTIFICATION_CONTENT_LONG_TEXT = 3,
  CALLBACK_NOTIFICATION_CONTENT_MULTILINE = 5,
  CALLBACK_NOTIFICATION_CONTENT_PICTURE = 6,
  CALLBACK_NOTIFICATION_CONTENT_CONVERSATION
}

const CONTENT_TYPE_COUNT = 7;

class NotificationFilterUtil {
  private disableContentTypes: Array<boolean> = new Array(CONTENT_TYPE_COUNT);

  constructor() {
    this.disableContentTypes.fill(false);
    let bundle: notification.BundleOption = {
      bundle: BUNDLE_NAME,
    };
    notification.setNotificationEnable(bundle, true).then(() => {
      logger.info("setNotificationEnable success");
    });
  }

  //使能和去使能通知过滤功能
  setNotificationEnableFilter(enable: boolean) {
    if (enable) {
      try {
        notification.on("checkNotification", this.OnCheckNotification);
        this.disableContentTypes.fill(false);
      } catch (error) {
        logger.error(`notificationManager.on error: ${JSON.stringify(error as Base.BusinessError)}`);
      }
      logger.info("notificationFilter enable success");
    }
    else {
      try {
        notification.off("checkNotification");
      } catch (error) {
        logger.error(`notificationManager.off error: ${JSON.stringify(error as Base.BusinessError)}`);
      }
      logger.info("notificationFilter disable success");
    }
  }

  setContentTypeDisable(type: ContentCallBackType, enable: boolean) {
    this.disableContentTypes[type] = enable;
    logger.info(`allowContentTypes ${JSON.stringify(type)}`);
  }

  // push callback
  OnCheckNotification = (info: notification.NotificationCheckInfo) => {
    logger.info(`OnCheckNotification info: ${JSON.stringify(info.contentType)}`);
    if (this.disableContentTypes[info.contentType] === false) {
      let result: notification.NotificationCheckResult = { code: 0, message: "Notification send success" };
      return result;
    } else {
      let result: notification.NotificationCheckResult = { code: 1, message: "Notification send fail" };
      return result;
    }
  }
}

export let notificationFilter = new NotificationFilterUtil();