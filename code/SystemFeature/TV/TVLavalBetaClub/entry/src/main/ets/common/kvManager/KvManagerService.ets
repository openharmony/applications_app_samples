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
import distributedKVStore from '@ohos.data.distributedKVStore';
import { BusinessError } from '@ohos.base';
import LogManager from '../Log/LogManager';


const TAG = 'kvManagerService';


export default class KvManagerService {
  public static kvManager: distributedKVStore.KVManager | undefined = undefined;
  public static kvStore: distributedKVStore.SingleKVStore | undefined = undefined;

  public static createKV(context: Context, bundleName: string) {
    const kvManagerConfig: distributedKVStore.KVManagerConfig = {
      context,
      bundleName
    };
    try {
      // 创建KVManager实例
      KvManagerService.kvManager = distributedKVStore.createKVManager(kvManagerConfig);
      LogManager.hilogIWithTag(TAG, `Succeeded in creating KVManager`);
    } catch (e) {
      let error = e as BusinessError;
      LogManager.hilogIWithTag(TAG, `Failed to create KVManager. Code:${error.code},message:${error.message}`);
    }
  }

  public static createStore(storeId: string) {
    if (KvManagerService.kvManager !== undefined) {
      try {
        const options: distributedKVStore.Options = {
          createIfMissing: true,
          encrypt: false,
          backup: false,
          autoSync: false,
          // kvStoreType不填时，默认创建多设备协同数据库
          kvStoreType: distributedKVStore.KVStoreType.SINGLE_VERSION,
          // 多设备协同数据库：kvStoreType: distributedKVStore.KVStoreType.DEVICE_COLLABORATION,
          securityLevel: distributedKVStore.SecurityLevel.S1
        };
        KvManagerService.kvManager.getKVStore<distributedKVStore.SingleKVStore>(storeId, options,
          (err: BusinessError, store: distributedKVStore.SingleKVStore) => {
            if (err) {
              LogManager.hilogIWithTag(TAG, `Failed to get KVStore: Code:${err.code},message:${err.message}`);
              return;
            }
            LogManager.hilogIWithTag(TAG, `Succeeded in getting KVStore.`);

            KvManagerService.kvStore = store;
          });
      } catch (e) {
        let error = e as BusinessError;
        LogManager.hilogIWithTag(TAG, `An unexpected error occurred. Code:${error.code},message:${error.message}`);
      }
    }
  }

  public static getValue(key: string, callBack: (val: string) => void) {
    if (KvManagerService.kvStore !== undefined) {
      KvManagerService.kvStore.get(key, (err: BusinessError, data: string | number | boolean | Uint8Array) => {
        if (err != undefined) {
          LogManager.hilogIWithTag(TAG, `Failed to get data. Code:${err.code},message:${err.message}`);
          callBack('[]');
          return;
        }
        LogManager.hilogIWithTag(TAG, `Succeeded in getting data. Data:${data}`);
        if (typeof (data) === 'string') {
          callBack(data);
        }
      });
    }
  }

  public static putValue(key: string, value: string) {
    if (KvManagerService.kvStore !== undefined) {
      try {
        KvManagerService.kvStore.put(key, value, (err: BusinessError) => {
          if (err !== undefined) {
            LogManager.hilogIWithTag(TAG, `Failed to put data. Code:${err.code},message:${err.message}`);

            return;
          }
          LogManager.hilogIWithTag(TAG, `Succeeded in putting data.` + value);

        });
      } catch (e) {
        let error = e as BusinessError;
        LogManager.hilogIWithTag(TAG, `Failed to get data. Code:${error.code},message:${error.message}`);
      }
    }
  }

  public static deleteValue(key: string) {
    if (KvManagerService.kvStore !== undefined) {
      KvManagerService.kvStore.delete(key, (err: BusinessError) => {
        if (err !== undefined) {
          LogManager.hilogIWithTag(TAG, `Failed to delete data. Code:${err.code},message:${err.message}`);
          return;
        }
        LogManager.hilogIWithTag(TAG, `Succeeded in deleting data.`);
      });
    }

  }
};