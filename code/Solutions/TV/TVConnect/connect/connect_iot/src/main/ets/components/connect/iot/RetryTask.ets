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
import Timers from './Timers';

export default class RetryTask<T> {
  private sleepTimes = [0, 2000, 3000];

  async execute(func: () => Promise<T>): Promise<T> {
    let e = undefined;
    let retryCount = 0;
    let maxRetryCount = this.sleepTimes.length;
    do {
      Logger.debug(IotConstants.IOT_TAG, `RetryTask count =${retryCount}`);
      try {
        let sleepTime = this.sleepTimes[retryCount];
        if (sleepTime > 0) {
          await Timers.delay(sleepTime);
        }
        let result = await func();
        Logger.debug(IotConstants.IOT_TAG, `RetryTask execute success`);
        return Promise.resolve(result);
      } catch (error) {
        Logger.error(IotConstants.IOT_TAG,
          `RetryTask error count =${retryCount} code =${error.code} data =${error.data}`);
        // hilink-svc wifi 物理连接失败错误码，物理连接失败重试
        if (error?.code == 1000082) {
          e = error;
        } else {
          // hilink-svc 内部有speke 协商失败的重试机制，所以不需要重试
          return Promise.reject(e);
        }
      }
      retryCount += 1;
    } while (retryCount < maxRetryCount);
    return Promise.reject(e);
  }
};