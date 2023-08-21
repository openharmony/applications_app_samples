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
import Logger from '../model/Logger'
import { BUNDLE_NAME } from './RemoteDeviceModel'

const TAG: string = 'KvStoreModel'
const STORE_ID: string = 'distributedcalc'

export class KvStoreModel {
  public kvManager: distributedData.KVManager = undefined
  public kvStore = undefined;

 async createKvStore(context, callback) {
    if ((typeof (this.kvStore) !== 'undefined')) {
      callback()
      return
    }
    let config = {
      bundleName: BUNDLE_NAME,
      userInfo: {
        userId: '0',
        userType: 0
      },
      context: context
    };
    try {
      Logger.info(TAG, `ecreateKVManager success`);
      this.kvManager = distributedData.createKVManager(config);
    } catch (err) {
      Logger.info(TAG, `ecreateKVManager err:${JSON.stringify(err)}`);
    }
    Logger.info(TAG, `createKVManager begin`);
    let options = {
      createIfMissing: true,
      encrypt: false,
      backup: false,
      autoSync: true,
      kvStoreType: 1,
      securityLevel: 1
    };
    Logger.info(TAG, `kvManager.getKVStore begin`);
    this.kvManager.getKVStore(STORE_ID, options).then((store) => {
      Logger.info(TAG, `getKVStore success, kvStore= ${store}`);
      this.kvStore = store;
      callback();
    })
    Logger.info(TAG, `createKVManager end`)
  }

  put(key, value) {
    if(this.kvStore) {
      Logger.debug(TAG, `kvStore.put ${key} = ${value}`)
      this.kvStore.put(key, value).then((data) => {
        Logger.debug(TAG, `kvStore.put ${key} finished, data= ${JSON.stringify(data)}`)
      }).catch((err) => {
        Logger.debug(TAG, `kvStore.put ${key} failed, ${JSON.stringify(err)}`)
      })
    }
  }

  setOnMessageReceivedListener(context, msg, callback) {
    Logger.info(TAG, `setOnMessageReceivedListener: ${msg}`)
    this.createKvStore(context, () => {
      Logger.info(TAG, `kvStore.on(dataChange) begin`)
      this.kvStore.on('dataChange', 1, (data) => {
        Logger.debug(TAG, `dataChange, ${JSON.stringify(data)}`)
        let entries = data.insertEntries.length > 0 ? data.insertEntries : data.updateEntries
        for (let i = 0; i < entries.length; i++) {
          if (entries[i].key === msg) {
            let value = <string> entries[i].value.value
            Logger.debug(TAG, `Entries receive msg :${msg}, value：${value}`)
            callback(value)
            return
          }
        }
      })
      Logger.info(TAG, `kvStore.on(dataChange) end`)
    })
  }
}