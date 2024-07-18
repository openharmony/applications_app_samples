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

import distributedKVStore from '@ohos.data.distributedKVStore';
import relationalStore from '@ohos.data.relationalStore';
import { BusinessError } from '@ohos.base';
import startupManager from '@ohos.app.appstartup.startupManager';

export class SingleKVStoreUtil {
  static getKVStore(): Promise<distributedKVStore.SingleKVStore> {
    // 返回单例对象
    return new Promise((resolve, reject) => {
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

      let kvManagerUtilTask = startupManager.getStartupTaskResult('KvManagerUtilTask') as distributedKVStore.KVManager
      kvManagerUtilTask.getKVStore<distributedKVStore.SingleKVStore>('storeId', options,
        (err, store: distributedKVStore.SingleKVStore) => {
          if (err) {
            console.error(`Failed to get KVStore: Code:${err.code},message:${err.message}`);
            reject(`Failed to get KVStore: Code:${err.code},message:${err.message}`)
            return;
          }
          // 请确保获取到键值数据库实例后，再进行相关数据操作
          if (store == undefined) {
            reject('store == undefined');
            return;
          }
          resolve(store);
        });
    })
  }
}

export class KvManagerUtil {
  private static kvManager: distributedKVStore.KVManager | undefined = undefined;

  private constructor() {
  }

  public static getInstance(context) {
    // 返回单例对象
    if (this.kvManager == undefined) {
      const kvManagerConfig: distributedKVStore.KVManagerConfig = {
        context: context,
        bundleName: 'com.samples.appstartup'
      };
      // 创建KVManager实例
      this.kvManager = distributedKVStore.createKVManager(kvManagerConfig);
    }
    return this.kvManager;
  }
}

export class RdbStoreUtil {
  static getRdbStore(context): Promise<relationalStore.RdbStore> {
    return new Promise((resolve, reject) => {
      const STORE_CONFIG: relationalStore.StoreConfig = {
        name: "RdbTest.db",
        securityLevel: relationalStore.SecurityLevel.S1
      };

      relationalStore.getRdbStore(context, STORE_CONFIG, (err: BusinessError, rdbStore: relationalStore.RdbStore) => {
        if (err) {
          reject('rdbStore == undefined');
          console.error(`Get RdbStore failed, code is ${err.code},message is ${err.message}`);
          return;
        }
        resolve(rdbStore);
        console.info('Get RdbStore successfully.');
      })
    });

  }
}