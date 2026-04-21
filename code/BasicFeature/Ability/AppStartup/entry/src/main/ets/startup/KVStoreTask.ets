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

import StartupTask from '@ohos.app.appstartup.StartupTask';
import common from '@ohos.app.ability.common';

import { BusinessError } from '@ohos.base';
import { SingleKVStoreUtil } from '../util/SingleKVStore';
import distributedKVStore from '@ohos.data.distributedKVStore';

@Sendable
export default class KVStoreTask extends StartupTask {
  constructor() {
    super();
  }

  async init(context: common.AbilityStageContext) {
    try {
      SingleKVStoreUtil.getKVStore()
        .then((kvStore: distributedKVStore.SingleKVStore) => {
          const KEY_TEST_STRING_ELEMENT = 'key_test_string';
          const VALUE_TEST_STRING_ELEMENT = 'value_test_string';
          kvStore.put(KEY_TEST_STRING_ELEMENT, VALUE_TEST_STRING_ELEMENT, (err) => {
            if (err !== undefined) {
              console.error(`Failed to put data. Code:${err.code},message:${err.message}`);
              return;
            }
            console.info('Succeeded in putting data.');
          });
        }).catch((err: BusinessError) => {
        console.error(`Failed to create KVManager.message:${err}`);
      });

    } catch (e) {
      let error = e as BusinessError;
      console.error(`Failed to create KVManager. Code:${error.code},message:${error.message}`);
    }
  }

  onDependencyCompleted(dependence: string, result: Object): void {
  }
}