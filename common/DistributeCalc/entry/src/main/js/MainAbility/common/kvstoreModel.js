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
import distributedData from '@ohos.data.distributedData';

const STORE_ID = 'distributedcalc';

export class KvStoreModel {
  kvManager;
  kvStore;

  constructor() {
  }

  createKvStore(callback) {
    if ((typeof (this.kvStore) !== 'undefined')) {
      callback();
      return;
    }
    var config = {
      bundleName: 'ohos.samples.distributedcalc',
      userInfo: {
        userId: '0',
        userType: 0
      }
    };
    console.info('[KvStoreModel] createKVManager begin');
    distributedData.createKVManager(config).then((manager) => {
      console.debug('[KvStoreModel] createKVManager success, kvManager=' + JSON.stringify(manager));
      this.kvManager = manager;
      let options = {
        createIfMissing: true,
        encrypt: false,
        backup: false,
        autoSync: true,
        kvStoreType: 1,
        securityLevel: 1,
      };
      console.info('[KvStoreModel] kvManager.getKVStore begin');
      this.kvManager.getKVStore(STORE_ID, options).then((store) => {
        console.debug('[KvStoreModel] getKVStore success, kvStore=' + store);
        this.kvStore = store;
        callback();
      });
      console.info('[KvStoreModel] kvManager.getKVStore end');
    });
    console.info('[KvStoreModel] createKVManager end');
  }

  put(key, value) {
    console.debug('[KvStoreModel] kvStore.put ' + key + '=' + value);
    this.kvStore.put(key, value + 'end').then((data) => {
      console.debug('[KvStoreModel] kvStore.put ' + key + ' finished, data=' + JSON.stringify(data));
    }).catch((err) => {
      console.error('[KvStoreModel] kvStore.put ' + key + ' failed, ' + JSON.stringify(err));
    });
  }

  off() {
    if (this.kvStore !== null) {
      this.kvStore.off('dataChange');
    }
  }

  setOnMessageReceivedListener(msg, refreshdata) {
    console.debug('[KvStoreModel] setOnMessageReceivedListener ' + msg);
    this.createKvStore(() => {
      console.info('[KvStoreModel] kvStore.on(dataChange) begin');
      this.kvStore.on('dataChange', 1, (data) => {
        console.debug('[KvStoreModel] dataChange, ' + JSON.stringify(data));
        console.debug('[KvStoreModel] dataChange, insert ' + data.insertEntries.length + ' udpate '
        + data.updateEntries.length);
        let entries = data.insertEntries.length > 0 ? data.insertEntries : data.updateEntries;
        this.simplify(entries, msg, refreshdata)
      });
      console.info('[KvStoreModel] kvStore.on(dataChange) end');
    });
  }

  simplify(entries, msg, refreshdata) {
    for (let i = 0; i < entries.length; i++) {
      if (entries[i].key === msg) {
        let value = entries[i].value.value;
        console.debug('[KvStoreModel] Entries receive ' + msg + '=' + value);
        let valueResult = value.substring(0, value.lastIndexOf('end'));
        console.debug('[KvStoreModel] Entries receive valueResult = ' + valueResult);
        refreshdata(valueResult);
        return;
      }
    }
  }
}