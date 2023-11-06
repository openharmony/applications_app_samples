/*
 * Copyright (c) 2021-2023 Huawei Device Co., Ltd.
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

import distributedData from '@ohos.data.distributedKVStore'
import common from '@ohos.app.ability.common'
import Logger from '../util/Logger'
import { Callback } from '@ohos.base';

const STORE_ID = 'etskvstore'
const TAG = 'KvStoreModel'

export class KvStoreModel {
  private kvManager?: distributedData.KVManager = undefined;
  private kvStore?: distributedData.SingleKVStore = undefined;

  constructor() {
  }

  async createKvStore(callback: Callback<void>) {
    if ((typeof (this.kvStore) !== 'undefined')) {
      callback()
      return;
    }
    let context: common.Context = getContext(this)
    let config: distributedData.KVManagerConfig = {
      context,
      bundleName: 'ohos.samples.kvstore',
    }
    Logger.info(TAG, 'createKVManager begin')
    try {
      this.kvManager = await distributedData.createKVManager(config)
    } catch (err) {
      Logger.info(TAG, `ecreateKVManager err:${JSON.stringify(err)}`)
    }
    Logger.info(TAG, 'ecreateKVManager end')
    let options: distributedData.Options = {
      createIfMissing: true,
      encrypt: false,
      backup: false,
      autoSync: true,
      kvStoreType: distributedData.KVStoreType.SINGLE_VERSION,
      securityLevel: distributedData.SecurityLevel.S1,
    }
    Logger.info(TAG, 'kvManager.getKVStore begin')
    if (this.kvManager !== undefined) {
      this.kvManager.getKVStore(STORE_ID, options, (err, store: distributedData.SingleKVStore) => {
        Logger.info(TAG, `getKVStore success, kvStore= ${store}`);
        this.kvStore = store;
        callback();
      })
    }
    Logger.info(TAG, 'kvstorTAG,ekvManager.getKVStore end')
  }

  put(key: string, value: string) {
    if (this.kvStore) {
      Logger.debug(TAG, `kvStore.put ${key} = ${value}`);
      this.kvStore.put(
        key,
        value
      ).then((data) => {
        Logger.debug(TAG, `kvStore.put ${key} finished, data= ${JSON.stringify(data)}`);
      }).catch((err: object) => {
        Logger.debug(TAG, `kvStore.put ${key} failed, ${JSON.stringify(err)}`);
      })
    }
  }

  setOnMessageReceivedListener(msg: string, callback: Callback<string>) {
    Logger.info(TAG, `setOnMessageReceivedListener ${msg}`)
    let self = this
    this.createKvStore(() => {
      Logger.info(TAG, 'kvStore.on(dataChange) begin')
      self.kvStore!.on('dataChange', 1, (data) => {
        Logger.info(TAG, `dataChange, ${JSON.stringify(data)}`);
        Logger.info(TAG, `dataChange, insert ${data.insertEntries.length} udpate ${data.updateEntries.length}`)
        let entries = data.insertEntries.length > 0 ? data.insertEntries : data.updateEntries
        for (let i = 0; i < entries.length; i++) {
          if (entries[i].key === msg) {
            let value = entries[i].value.value.toString();
            Logger.info(TAG, `Entries receive ${msg} = ${value}`)
            callback(value)
            return;
          }
        }
      });
      Logger.info(TAG, 'kvStore.on(dataChange) end')
    })
  }
}