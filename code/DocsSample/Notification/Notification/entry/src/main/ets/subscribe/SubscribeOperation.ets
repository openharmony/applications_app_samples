/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import Base from '@ohos.base';
import notificationSubscribe from '@ohos.notificationSubscribe';
import { logger } from '../util/Logger';
import notificationManager from '@ohos.notificationManager';

interface NotificationSortingMap {
  readonly sortedHashCode: Array<string>;
}

class SubscribeOperations {
  createSubscriber = async () => {
    let subscriber: notificationSubscribe.NotificationSubscriber = {
      onConsume: (data: notificationSubscribe.SubscribeCallbackData) => {
        let req: notificationManager.NotificationRequest = data.request;
        logger.info(`onConsume callback. req.id: ${req.id}`);
      },
      onCancel: (data: notificationSubscribe.SubscribeCallbackData) => {
        let req: notificationManager.NotificationRequest = data.request;
        logger.info(`onCancel callback. req.id: ${req.id}`);
      },
      onUpdate: (data: NotificationSortingMap) => {
        logger.info(`onUpdate callback. req.id: ${data.sortedHashCode}`);
      },
      onConnect: () => {
        logger.info(`onConnect callback.`);
      },
      onDisconnect: () => {
        logger.info(`onDisconnect callback.`);
      },
      onDestroy: () => {
        logger.info(`onDestroy callback.`);
      },
    };

    notificationSubscribe.subscribe(subscriber, (err: Base.BusinessError) => { // callback形式调用异步接口
      if (err) {
        logger.error(`Failed to subscribe notification. Code is ${err.code}, message is ${err.message}`);
        return;
      }
    });
  }
}

export let subscribeOperations = new SubscribeOperations();