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

// [Start Store]
import { distributedKVStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import Logger from '../common/Logger';

let kvManager: distributedKVStore.KVManager;

export class StoreInfo {
  kvManagerConfig: distributedKVStore.KVManagerConfig;
  storeId: string;
  option: distributedKVStore.Options;
}

export class Store {
  async getECStore(storeInfo: StoreInfo): Promise<distributedKVStore.SingleKVStore> {
    try {
      kvManager = distributedKVStore.createKVManager(storeInfo.kvManagerConfig);
      Logger.info('Succeeded in creating KVManager');
    } catch (e) {
      let error = e as BusinessError;
      Logger.error(`Failed to create KVManager.code is ${error.code},message is ${error.message}`);
    }
    if (kvManager !== undefined) {
      let kvStore: distributedKVStore.SingleKVStore | null;
      try {
        kvStore = await kvManager.getKVStore<distributedKVStore.SingleKVStore>(storeInfo.storeId, storeInfo.option);
        if (kvStore != undefined) {
          Logger.info(`ECDB_Encry succeeded in getting store : ${storeInfo.storeId}`);
          return kvStore;
        }
      } catch (e) {
        let error = e as BusinessError;
        Logger.error(`An unexpected error occurred.code is ${error.code},message is ${error.message}`);
      }
    }
  }

  putOnedata(kvStore: distributedKVStore.SingleKVStore): void {
    if (kvStore != undefined) {
      const KEY_TEST_STRING_ELEMENT = 'key_test_string' + String(Date.now());
      const VALUE_TEST_STRING_ELEMENT = 'value_test_string' + String(Date.now());
      try {
        kvStore.put(KEY_TEST_STRING_ELEMENT, VALUE_TEST_STRING_ELEMENT, (err) => {
          if (err !== undefined) {
            Logger.error(`Failed to put data. Code:${err.code},message:${err.message}`);
            return;
          }
          Logger.info(`ECDB_Encry Succeeded in putting data.${KEY_TEST_STRING_ELEMENT}`);
        });
      } catch (e) {
        let error = e as BusinessError;
        Logger.error(`An unexpected error occurred. Code:${error.code},message:${error.message}`);
      }
    }
  }

  getDataNum(kvStore: distributedKVStore.SingleKVStore): void {
    if (kvStore != undefined) {
      let resultSet: distributedKVStore.KVStoreResultSet;
      kvStore.getResultSet('key_test_string').then((result: distributedKVStore.KVStoreResultSet) => {
        Logger.info(`ECDB_Encry Succeeded in getting result set num ${result.getCount()}`);
        resultSet = result;
        if (kvStore != null) {
          kvStore.closeResultSet(resultSet).then(() => {
            Logger.info('Succeeded in closing result set');
          }).catch((err: BusinessError) => {
            Logger.error(`Failed to close resultset.code is ${err.code},message is ${err.message}`);
          });
        }
      }).catch((err: BusinessError) => {
        Logger.error(`Failed to get resultset.code is ${err.code},message is ${err.message}`);
      });
    }
  }

  deleteOnedata(kvStore: distributedKVStore.SingleKVStore): void {
    if (kvStore != undefined) {
      kvStore.getEntries('key_test_string', (err: BusinessError, entries: distributedKVStore.Entry[]) => {
        if (err != undefined) {
          Logger.error(`Failed to get Entries.code is ${err.code},message is ${err.message}`);
          return;
        }
        if (kvStore != null && entries.length != 0) {
          kvStore.delete(entries[0].key, (err: BusinessError) => {
            if (err != undefined) {
              Logger.error(`Failed to delete.code is ${err.code},message is ${err.message}`);
              return;
            }
            Logger.info('ECDB_Encry Succeeded in deleting');
          });
        }
      });
    }
  }

  updateOnedata(kvStore: distributedKVStore.SingleKVStore): void {
    if (kvStore != undefined) {
      kvStore.getEntries('key_test_string', async (err: BusinessError, entries: distributedKVStore.Entry[]) => {
        if (err != undefined) {
          Logger.error(`Failed to get Entries.code is ${err.code},message is ${err.message}`);
          return;
        }
        if (kvStore != null && entries.length != 0) {
          Logger.info(`ECDB_Encry old data:${entries[0].key},value :${entries[0].value.value.toString()}`);
          await kvStore.put(entries[0].key, 'new value_test_string' + String(Date.now()) + 'new').then(() => {
          }).catch((err: BusinessError) => {
            Logger.error(`Failed to put.code is ${err.code},message is ${err.message}`);
          });
          Logger.info(`ECDB_Encry update success`);
        }
      });
    }
  }
}
// [End Store]