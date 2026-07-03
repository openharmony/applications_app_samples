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
import { BusinessError, Callback } from '@ohos.base';
import IotConstants from './IotConstants';

export default class Timers<T> {
  private time = IotConstants.RESPONSE_TIMERS;
  private timeoutID = 0;
  private successFunction: Callback<T> | undefined;
  private failedFunction: Callback<BusinessError> | undefined;

  constructor(successFunction: Callback<T>, failedFunction: Callback<BusinessError>) {
    this.successFunction = successFunction;
    this.failedFunction = failedFunction;
  }

  setTime(time: number) {
    this.time = time;
  }

  start() {
    this.timeoutID = setTimeout(() => {
      const error: BusinessError = {
        name: IotConstants.IOT_NAME,
        code: IotConstants.IOT_CALL_TIME_OUT,
        message: IotConstants.IOT_CALL_TIME_OUT_MSG,
      };
      this.failedFunction && this.failedFunction(error);
    }, this.time);
  }

  executeSuccess(data: T) {
    clearTimeout(this.timeoutID);
    this.successFunction && this.successFunction(data);
    this.successFunction = undefined;
    this.failedFunction = undefined;
  }

  executeFailed(error: BusinessError) {
    clearTimeout(this.timeoutID);
    this.failedFunction && this.failedFunction(error);
    this.successFunction = undefined;
    this.failedFunction = undefined;
  }

  clearTimers() {
    clearTimeout(this.timeoutID);
    this.successFunction = undefined;
    this.failedFunction = undefined;
  }

  static delay(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
};