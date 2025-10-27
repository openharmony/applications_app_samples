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

import { distributedKVStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { distributedDeviceManager } from '@kit.DistributedServiceKit';
import EntryAbility from '../entryability/EntryAbility';
import Logger from '../common/Logger';

let kvManager: distributedKVStore.KVManager | undefined = undefined;
let kvStore: distributedKVStore.SingleKVStore | undefined = undefined;
let appId: string = 'com.example.kvstoresamples';
let storeId: string = 'storeId';
const context = EntryAbility.getContext();

export class KvInterface {
  // [Start kv_store1]
  public CreateKvManager = (() => {
    Logger.info('CreateKvManager start');
    if (typeof (kvManager) === 'undefined') {
      const kvManagerConfig: distributedKVStore.KVManagerConfig = {
        bundleName: appId,
        context: context
      };
      try {
        // 创建KVManager实例
        kvManager = distributedKVStore.createKVManager(kvManagerConfig);
        Logger.info('Succeeded in creating KVManager.');
      } catch (err) {
        Logger.error(`Failed to create KVManager. Code:${err.code},message:${err.message}`);
      }
    } else {
      Logger.info ('KVManager has created');
    }
  })
  // [End kv_store1]

  // [Start kv_store3]
  public GetKvStore = (() => {
    Logger.info('GetKvStore start');
    if (kvManager === undefined) {
      Logger.info('KvManager not initialized');
      return;
    }
    try {
      let child1 = new distributedKVStore.FieldNode('id');
      child1.type = distributedKVStore.ValueType.INTEGER;
      child1.nullable = false;
      child1.default = '1';
      let child2 = new distributedKVStore.FieldNode('name');
      child2.type = distributedKVStore.ValueType.STRING;
      child2.nullable = false;
      child2.default = 'zhangsan';

      let schema = new distributedKVStore.Schema();
      schema.root.appendChild(child1);
      schema.root.appendChild(child2);
      schema.indexes = ['$.id', '$.name'];
      // 0表示COMPATIBLE模式，1表示STRICT模式。
      schema.mode = 1;
      // 支持在检查Value时，跳过skip指定的字节数，且取值范围为[0,4M-2]。
      schema.skip = 0;

      const options: distributedKVStore.Options = {
        createIfMissing: true,
        // 设置数据库加密
        encrypt: true,
        backup: false,
        autoSync: false,
        // kvStoreType不填时，默认创建多设备协同数据库
        kvStoreType: distributedKVStore.KVStoreType.SINGLE_VERSION,
        // 多设备协同数据库：kvStoreType: distributedKVStore.KVStoreType.DEVICE_COLLABORATION,
        schema: schema,
        // schema未定义可以不填，定义方法请参考上方schema示例。
        securityLevel: distributedKVStore.SecurityLevel.S3
      };
      kvManager.getKVStore<distributedKVStore.SingleKVStore>(storeId, options,
        (err, store: distributedKVStore.SingleKVStore) => {
          if (err) {
            Logger.error(`Failed to get KVStore: Code:${err.code},message:${err.message}`);
            return;
          }
          Logger.info('Succeeded in getting KVStore.');
          kvStore = store;
          // 请确保获取到键值数据库实例后，再进行相关数据操作
        });
    } catch (e) {
      let error = e as BusinessError;
      Logger.error(`An unexpected error occurred. Code:${error.code},message:${error.message}`);
    }
  })
  // [End kv_store3]

  // [Start kv_store4]
  public Put = (() => {
    Logger.info('Put start');
    if (kvStore === undefined) {
      Logger.info('Put: kvStore not initialized');
      return;
    }
    const KEY_TEST_STRING_ELEMENT = 'key_test_string';
    // 如果未定义Schema则Value可以传其他符合要求的值。
    const VALUE_TEST_STRING_ELEMENT = '{"id":0, "name":"lisi"}';
    try {
      kvStore.put(KEY_TEST_STRING_ELEMENT, VALUE_TEST_STRING_ELEMENT, (err) => {
        if (err !== undefined) {
          Logger.error(`Failed to put data. Code:${err.code},message:${err.message}`);
          return;
        }
        Logger.info('Succeeded in putting data.');
      });
    } catch (e) {
      let error = e as BusinessError;
      Logger.error(`An unexpected error occurred. Code:${error.code},message:${error.message}`);
    }
  })
  // [End kv_store4]

  // [Start kv_store5]
  public Get = (() => {
    Logger.info('Get start');
    if (kvStore === undefined) {
      Logger.info('Get: kvStore not initialized');
      return;
    }
    const KEY_TEST_STRING_ELEMENT = 'key_test_string';
    try {
      kvStore.get(KEY_TEST_STRING_ELEMENT, (err, data) => {
        if (err != undefined) {
          Logger.error(`Failed to get data. Code:${err.code},message:${err.message}`);
          return;
        }
        Logger.info(`Succeeded in getting data. Data:${data}`);
      });
    } catch (e) {
      let error = e as BusinessError;
      Logger.error(`Failed to get data. Code:${error.code},message:${error.message}`);
    }
  })
  // [End kv_store5]

  // [Start kv_store6]
  public Delete = (() => {
    Logger.info('DeleteData start');
    if (kvStore === undefined) {
      Logger.info('DeleteData: kvStore not initialized');
      return;
    }
    const KEY_TEST_STRING_ELEMENT = 'key_test_string';
    try {
      kvStore.delete(KEY_TEST_STRING_ELEMENT, (err) => {
        if (err !== undefined) {
          Logger.error(`Failed to delete data. Code:${err.code},message:${err.message}`);
          return;
        }
        Logger.info('Succeeded in deleting data.');
      });
    } catch (e) {
      let error = e as BusinessError;
      Logger.error(`An unexpected error occurred. Code:${error.code},message:${error.message}`);
    }
  })
  // [End kv_store6]

  // [Start kv_store7]
  public Backup = (() => {
    Logger.info('Backup start');
    if (kvStore === undefined) {
      Logger.info('Backup: kvStore not initialized');
      return;
    }
    let backupFile = 'BK001';
    try {
      kvStore.backup(backupFile, (err) => {
        if (err) {
          Logger.error(`Fail to backup data.code:${err.code},message:${err.message}`);
        } else {
          Logger.info('Succeeded in backing up data.');
        }
      });
    } catch (e) {
      let error = e as BusinessError;
      Logger.error(`An unexpected error occurred. Code:${error.code},message:${error.message}`);
    }
  })
  // [End kv_store7]

  // [Start kv_store8]
  public Restore = (() => {
    Logger.info('Restore start');
    if (kvStore === undefined) {
      Logger.info('Restore: kvStore not initialized');
      return;
    }
    let backupFile = 'BK001';
    try {
      kvStore.restore(backupFile, (err) => {
        if (err) {
          Logger.error(`Fail to restore data. Code:${err.code},message:${err.message}`);
        } else {
          Logger.info('Succeeded in restoring data.');
        }
      });
    } catch (e) {
      let error = e as BusinessError;
      Logger.error(`An unexpected error occurred. Code:${error.code},message:${error.message}`);
    }
  })
  // [End kv_store8]

  // [Start kv_store9]
  public DeleteBackup = (() => {
    Logger.info('DeleteBackup start');
    if (kvStore === undefined) {
      Logger.info('DeleteBackup: kvStore not initialized');
      return;
    }
    let backupFile = 'BK001';
    let files = [backupFile];
    try {
      kvStore.deleteBackup(files, (err: BusinessError, data: [string, number][]) => {
        if (err) {
          Logger.error(`Failed to delete Backup.code is ${err.code},message is ${err.message}`);
        } else {
          Logger.info(`Succeed in deleting Backup.data=${data}`);
        }
      });
    } catch (e) {
      let error = e as BusinessError;
      Logger.error(`An unexpected error occurred.code is ${error.code},message is ${error.message}`);
    }
  })
  // [End kv_store9]

  // [Start kv_store10]
  public CloseKVStore = (()=>{
    Logger.info('CloseKVStore start');
    if (kvManager === undefined) {
      Logger.info('KvManager not initialized');
      return;
    }
    try {
      // appId为应用的bundleName
      kvStore = undefined;
      kvManager.closeKVStore(appId, storeId, (err: BusinessError)=> {
        if (err) {
          Logger.error(`Failed to close KVStore.code is ${err.code},message is ${err.message}`);
          return;
        }
        Logger.info('Succeeded in closing KVStore');
      });
    } catch (e) {
      let error = e as BusinessError;
      Logger.error(`An unexpected error occurred. Code:${error.code},message:${error.message}`);
    }
  })
  // [End kv_store10]

  // [Start kv_store11]
  public DeleteKvStore = (()=>{
    Logger.info('DeleteKvStore start');
    if (kvManager === undefined) {
      Logger.info('KvManager not initialized');
      return;
    }
    try {
      // appId为应用的bundleName
      kvStore = undefined;
      kvManager.deleteKVStore(appId, storeId, (err: BusinessError)=> {
        if (err) {
          Logger.error(`Failed to delete KVStore.code is ${err.code},message is ${err.message}`);
          return;
        }
        Logger.info('Succeeded in deleting KVStore');
      });
    } catch (e) {
      let error = e as BusinessError;
      Logger.error(`An unexpected error occurred. Code:${error.code},message:${error.message}`);
    }
  })
  // [End kv_store11]

  // [Start kv_store12]
  public On = (() =>{
    Logger.info('On start');
    if(kvStore === undefined) {
      Logger.info('On: kvStore not initialized');
      return;
    }
    try {
      kvStore.on('dataChange', distributedKVStore.SubscribeType.SUBSCRIBE_TYPE_ALL, (data) => {
        Logger.info(`dataChange callback call data: ${data}`);
      });
    } catch (e) {
      let error = e as BusinessError;
      Logger.error(`An unexpected error occurred. code:${error.code},message:${error.message}`);
    }
  })
  // [End kv_store12]

  // [Start kv_store13]
  public Sync = (() =>{
    Logger.info('Sync start');
    if(kvStore === undefined) {
      Logger.info('Sync: kvStore not initialized');
      return;
    }
    let devManager: distributedDeviceManager.DeviceManager;
    try {
      // create deviceManager
      devManager = distributedDeviceManager.createDeviceManager(context.applicationInfo.name);
      // deviceIds由deviceManager调用getAvailableDeviceListSync方法得到
      let deviceIds: string[] = [];
      if (devManager != null) {
        let devices = devManager.getAvailableDeviceListSync();
        for (let i = 0; i < devices.length; i++) {
          deviceIds[i] = devices[i].networkId as string;
        }
      }
      if (deviceIds.length === 0) {
        Logger.info('Sync failed networkId is empty.');
        return;
      }
      try {
        // 1000表示最大延迟时间为1000ms
        kvStore.sync(deviceIds, distributedKVStore.SyncMode.PUSH_PULL, 1000);
      } catch (e) {
        let error = e as BusinessError;
        Logger.error(`An unexpected error occurred. Code:${error.code},message:${error.message}`);
      }
    } catch (err) {
      let error = err as BusinessError;
      Logger.error('createDeviceManager errCode:' + error.code + ',errMessage:' + error.message);
    }
  })
  // [End kv_store13]
}
