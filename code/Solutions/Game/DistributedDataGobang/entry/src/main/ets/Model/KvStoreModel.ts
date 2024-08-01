/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import distributedData from '@ohos.data.distributedKVStore';
import Logger from '../util/Logger';
import { GobangConst } from '../util/GobangConst';
import distributedDeviceManager from '@ohos.distributedDeviceManager';
import common from '@ohos.app.ability.common';

const TAG: string = 'KvStoreModel';
let devManager: distributedDeviceManager.DeviceManager;
let bundleName = 'ohos.samples.distributeddatagobang';

export class KvStoreModel {
  public kvManager: distributedData.KVManager
  public kvStore = undefined;

  constructor() {
  }

  createKvStore(context, callback) {
    if ((typeof (this.kvStore) !== 'undefined')) {
      callback()
      return
    }
    let config = {
      bundleName,
      context: context
    }
    Logger.info(TAG, 'createKVManager begin')
    try {
      Logger.info(TAG, 'ecreateKVManager success');
      this.kvManager = distributedData.createKVManager(config);
    } catch (err) {
      Logger.info(TAG, `ecreateKVManager err:${JSON.stringify(err)}`);
    }
    let options = {
      createIfMissing: true,
      encrypt: false,
      backup: false,
      autoSync: false,
      kvStoreType: distributedData.KVStoreType.SINGLE_VERSION,
      securityLevel: distributedData.SecurityLevel.S1
    };
    Logger.info(TAG, 'kvManager.getKVStore begin');
    this.kvManager.getKVStore(GobangConst.STORE_ID, options).then((store) => {
      Logger.info(TAG, `getKVStore success, kvStore= ${store}`);
      this.kvStore = store;
      callback();
    })
    Logger.info(TAG, '[KvStoreModel] createKVManager end');
  }

  put(key, value) {
    Logger.info(TAG, `kvStore.put ${key} = ${value}`)
    try {
      this.kvStore.put(key, value).then((data) => {
        Logger.info(TAG, `kvStore.put ${key} finished, data= ${JSON.stringify(data)}`);
        devManager = distributedDeviceManager.createDeviceManager(bundleName);
        let deviceIds: string[] = [];
        if (devManager != null) {
          let devices = devManager.getAvailableDeviceListSync();
          for (let i = 0; i < devices.length; i++) {
            deviceIds[i] = devices[i].networkId as string;
          }
        }
        const mode = distributedData.SyncMode.PUSH_PULL;
        if (this.kvStore != null) {
          this.kvStore.sync(deviceIds, mode, 1000);
        }
      }).catch((err) => {
        Logger.info(TAG, `kvStore.put  ${key} failed, ${JSON.stringify(err)}`)
      })
    } catch (err) {
      Logger.error(TAG, `kvStore.put failed, code is ${err.code}, message is ${err.message}`)
    }
  }

  setOnMessageReceivedListener(context, msg, callback) {
    Logger.info(TAG, `setOnMessageReceivedListener: ${msg}`)
    this.createKvStore(context, () => {
      Logger.info(TAG, `kvStore.on(dataChange) begin`)
      this.kvStore.on('dataChange', 1, (data) => {
        Logger.info(TAG, `dataChange, ${JSON.stringify(data)}`)
        let entries = data.insertEntries.length > 0 ? data.insertEntries : data.updateEntries
        Logger.info(TAG, 'entries.length = ' + entries.length)
        for (let i = 0; i < entries.length; i++) {
          Logger.info(TAG, 'entries[i].key = ' + entries[i].key + ' and msg = ' + msg)
          if (entries[i].key === msg) {
            let value = entries[i].value.value
            Logger.info(TAG, `Entries receive, ${msg} = ${value}`)
            callback(value)
            return
          }
        }
      })
      Logger.info(TAG, `kvStore.on(dataChange) end`)
    })
  }
}