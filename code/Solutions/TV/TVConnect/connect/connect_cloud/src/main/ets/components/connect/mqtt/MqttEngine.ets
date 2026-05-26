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
import MqttConnectTask from './MqttConnectTask';
import { BusinessError } from '@ohos.base';
import { Logger } from '@ohos/common';
import CloudConstants from '../CloudConstants';
import MqttManager from './MqttManager';

export default class MqttEngine {
  static connect(reConnect: boolean = false) {
    Logger.info(CloudConstants.CLOUD_TAG, `MqttEngine connect start`);
    new MqttConnectTask().executeSync(reConnect).then((value) => {
      Logger.info(CloudConstants.CLOUD_TAG, `MqttEngine connect complete isSuccess=${value}`);
    }).catch((error: BusinessError) => {
      Logger.info(CloudConstants.CLOUD_TAG, `MqttEngine connect error=${error.message}`);
    });
  }

  static disConnect() {
    Logger.info(CloudConstants.CLOUD_TAG, `MqttEngine disConnect`);
    MqttManager.getInstance().disconnect();
  }
};