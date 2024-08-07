/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { AsyncCallback, BusinessError, commonEventManager } from '@kit.BasicServicesKit';
import Logger from '../common/Logger';

export class CommonEventManagerHelper {
  private subscriber: commonEventManager.CommonEventSubscriber | null = null;

  async createSubscriber(subscribeInfo: commonEventManager.CommonEventSubscribeInfo,
    callback: AsyncCallback<commonEventManager.CommonEventData>) {
    commonEventManager.createSubscriber(subscribeInfo,
        (err: BusinessError, data: commonEventManager.CommonEventSubscriber) => {
      if (err) {
        Logger.error(`Failed to create subscriber. Code is ${err.code}, message is ${err.message}`);
        return;
      }
      Logger.info('Succeeded in creating subscriber.');
      this.subscriber = data;
      this.subscribe(callback);
    });
  }

  private async subscribe(callback: AsyncCallback<commonEventManager.CommonEventData>) {
    if (this.subscriber !== null) {
      commonEventManager.subscribe(this.subscriber, callback);
    } else {
      Logger.warn(`Need create subscriber`);
    }
  }

  async unsubscribe() {
    if (this.subscriber !== null) {
      commonEventManager.unsubscribe(this.subscriber, (err: BusinessError) => {
        if (err) {
          Logger.error(`UnsubscribeCallBack err = ${JSON.stringify(err)}`);
        } else {
          Logger.error(`Unsubscribe success`);
          this.subscriber = null;
        }
      })
    }
  }

}