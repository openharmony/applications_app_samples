/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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
import distributedData from '@ohos.data.distributedData'

const STORE_ID = 'etskvstore'

export class KvStoreModel {
  private kvManager: distributedData.KVManager = undefined
  private kvStore: distributedData.KVStore = undefined

  constructor() {
  }

  async createKvStore(callback) {
    if ((typeof (this.kvStore) != 'undefined')) {
      callback()
      return;
    }
    var config = {
      bundleName: 'ohos.samples.etskvstore',
      userInfo: {
        userId: '0',
        userType: 0
      }
    }
    console.info('[KvStoreModel] createKVManager begin')
    this.kvManager = await distributedData.createKVManager(config)
    console.info('kvstore[KvStoreModel] createKVManager end')
    let options = {
      createIfMissing: true,
      encrypt: false,
      backup: false,
      autoSync: true,
      kvStoreType: 1,
      securityLevel: 1,
    }
    console.info('[KvStoreModel] kvManager.getKVStore begin')
    this.kvStore = await this.kvManager.getKVStore(STORE_ID, options)
    console.info('kvstore[KvStoreModel] kvManager.getKVStore end')
    callback()
  }

  put(key, value) {
    console.info('[KvStoreModel] kvStore.put ' + key + '=' + value)
    this.kvStore.put(key, value).then((data) => {
      console.info('[KvStoreModel] kvStore.put ' + key + ' finished, data=' + JSON.stringify(data))
    }).catch((err) => {
      console.error('[KvStoreModel] kvStore.put ' + key + ' failed, ' + JSON.stringify(err))
    });
  }

  setOnMessageReceivedListener(msg, callback) {
    console.info('[KvStoreModel] setOnMessageReceivedListener ' + msg)
    let self = this
    this.createKvStore(() => {
      console.info('[KvStoreModel] kvStore.on(dataChange) begin')
      self.kvStore.on('dataChange', 1, (data) => {
        console.info('[KvStoreModel] dataChange, ' + JSON.stringify(data));
        console.info('[KvStoreModel] dataChange, insert ' + data.insertEntries.length + ' udpate '
        + data.updateEntries.length)
        let entries = data.insertEntries.length > 0 ? data.insertEntries : data.updateEntries
        for (let i = 0; i < entries.length; i++) {
          if (entries[i].key === msg) {
            let value = entries[i].value.value
            console.info('[KvStoreModel] Entries receive ' + msg + '=' + value)
            callback(value)
            return;
          }
        }
      });
      console.info('[KvStoreModel] kvStore.on(dataChange) end')
    })
  }
}