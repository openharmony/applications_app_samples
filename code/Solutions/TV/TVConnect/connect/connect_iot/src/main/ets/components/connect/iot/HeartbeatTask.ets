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
import { Logger } from '@ohos/common';
import IotConstants from './IotConstants';
import { AsyncCallback, BusinessError } from '@kit.BasicServicesKit';

const HEART_BEAT_TIME = 10 * 1000;
const MAX_RETRY_COUNT = 6;

export default class HeartbeatTask {
  private timeoutID = 0;
  private totalCount = 0;
  private retryCount = 0;
  private executeReady = true;
  private callBack: AsyncCallback<number> | undefined;

  public async execute(func: () => Promise<boolean>, callBack: AsyncCallback<number>) {
    this.callBack = callBack;
    this.timeoutID = setInterval(async () => {
      if (!this.executeReady) {
        Logger.warn(IotConstants.IOT_TAG, 'last execute not complete');
        return;
      }
      Logger.debug(IotConstants.IOT_TAG, `HeartbeatTask execute count =${this.totalCount}`);
      this.executeReady = false;
      let result = await func();
      this.executeReady = true;
      this.totalCount++;
      this.retryCount++;
      if (result) {
        this.retryCount = 0;
        this.callBack && this.callBack(undefined, this.totalCount);
        return;
      }
      // 超过最大重试次数,停止重试周期
      if (this.retryCount >= MAX_RETRY_COUNT) {
        Logger.error(IotConstants.IOT_TAG, `HeartbeatTask retry count = ${this.retryCount}`);
        clearInterval(this.timeoutID);
        this.timeoutID = 0;
        let error: BusinessError = {
          name: 'HeartbeatTask',
          message: 'maximum number of attempts exceeded',
          code: 0
        };
        this.callBack && this.callBack(error, this.totalCount);
      }
    }, HEART_BEAT_TIME);
  }

  public stop() {
    this.callBack = undefined;
    clearInterval(this.timeoutID);
    this.timeoutID = 0;
  }
};