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
import { AsyncTask, Logger } from '@ohos/common';
import CloudConstants from '../CloudConstants';
import MqttManager from './MqttManager';

export default class MqttConnectTask extends AsyncTask<boolean, boolean> {
  private sleepTimes = [0, 500, 1000, 3000, 5000];

  protected async doOnBackground(params: boolean = false): Promise<boolean> {
    if (params) {
      let isConnected = await MqttManager.getInstance().isConnected();
      if (isConnected) {
        return true;
      }
    }
    Logger.info(CloudConstants.CLOUD_TAG, `start connect mqtt`);
    let connectResult = CloudConstants.COMMON_FAILED;
    let retryCount = 0;
    let maxRetryCount = this.sleepTimes.length;
    do {
      Logger.info(CloudConstants.CLOUD_TAG, `connect mqtt execute current count=${retryCount}`);
      let sleepTime = this.sleepTimes[retryCount];
      if (sleepTime > 0) {
        await MqttConnectTask.delay(sleepTime);
      }
      try {
        connectResult = await MqttManager.getInstance().connect();
      } catch (e) {
        Logger.warn(CloudConstants.CLOUD_TAG, `connect mqtt failed ${e?.message}`);
      }
      // 参数错误不再重连
      if (connectResult == CloudConstants.COMMON_PARAMETER_INVALID) {
        Logger.error(CloudConstants.CLOUD_TAG, `connect mqtt failed by parameter invalid`);
        return false;
      }
      Logger.info(CloudConstants.CLOUD_TAG, `connect mqtt execute complete current count=${retryCount}`);
      retryCount += 1;
    } while (connectResult != CloudConstants.COMMON_SUCCESS && retryCount < maxRetryCount);
    let isSuccess = connectResult == CloudConstants.COMMON_SUCCESS;
    Logger.info(CloudConstants.CLOUD_TAG, `end connect mqtt result=${isSuccess},count=${retryCount}`);
    return isSuccess;
  }

  static delay(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
};