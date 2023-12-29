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
import common from '@ohos.app.ability.common';
import { Callback } from '@ohos.base';

const TAG: string = 'KvStoreModel'
const STORE_ID: string = 'distributedcalc'

export class KvStoreModel {
  public kvManager: distributedData.KVManager | undefined = undefined
  public kvStore: distributedData.SingleKVStore | undefined = undefined

  async createKvStore(context: common.BaseContext, callback: Callback<void>) {
    if ((typeof (this.kvStore) !== 'undefined')) {
      callback()
      return
    }
    let config: distributedData.KVManagerConfig = {
      bundleName: BUNDLE_NAME,
      context: context
    };
    try {
      Logger.info(TAG, `ecreateKVManager success`);
      this.kvManager = distributedData.createKVManager(config);
    } catch (err) {
      Logger.info(TAG, `ecreateKVManager err:${JSON.stringify(err)}`);
    }
    Logger.info(TAG, `createKVManager begin`);
    let options: distributedData.Options = {
      createIfMissing: true,
      encrypt: false,
      backup: false,
      autoSync: true,
      kvStoreType: distributedData.KVStoreType.DEVICE_COLLABORATION,
      securityLevel: distributedData.SecurityLevel.S1
    };
    Logger.info(TAG, `kvManager.getKVStore begin`);
    if (this.kvManager !== undefined) {
      this.kvManager.getKVStore(STORE_ID, options, (err, store: distributedData.SingleKVStore) => {
        Logger.info(TAG, `getKVStore success, kvStore= ${store}`);
        this.kvStore = store;
        callback();
      })
    }
    Logger.info(TAG, `createKVManager end`)
  }

  deleteKvStore() {
    if (this.kvStore !== undefined && this.kvStore !== null) {
      return;
    }
    try {
      if (this.kvManager !== undefined) {
        Logger.info(TAG, 'deleteKvStore success')
        this.kvManager.deleteKVStore(BUNDLE_NAME, STORE_ID)
      }
    } catch (err) {
      Logger.error(TAG, 'deleteKvStore error error is:' + JSON.stringify(err))
    }
  }

  put(key: string, value: string) {
    if (this.kvStore) {
      Logger.debug(TAG, `kvStore.put ${key} = ${value}`)
      this.kvStore.put(
        key,
        value
      ).then((data) => {
        Logger.debug(TAG, `kvStore.put ${key} finished, data= ${JSON.stringify(data)}`)
      }).catch((err: object) => {
        Logger.debug(TAG, `kvStore.put ${key} failed, ${JSON.stringify(err)}`)
      })
    }
  }

  setOnMessageReceivedListener(context: common.UIAbilityContext, msg: string, callback: Callback<string>) {
    Logger.info(TAG, `setOnMessageReceivedListener: ${msg}`);
    this.createKvStore(context, () => {
      Logger.info(TAG, `kvStore.on(dataChange) begin`);
      if (this.kvStore !== undefined && this.kvStore !== null) {
        try {
          this.kvStore!.on('dataChange', distributedData.SubscribeType.SUBSCRIBE_TYPE_REMOTE, (data) => {
            Logger.debug(TAG, `dataChange, ${JSON.stringify(data)}`);
            let entries = data.insertEntries.length > 0 ? data.insertEntries : data.updateEntries;
            for (let i = 0; i < entries.length; i++) {
              if (entries[i].key === msg) {
                let value = entries[i].value.value.toString();
                Logger.debug(TAG, `Entries receive msg :${msg}, value：${value}`);
                callback(value);
                return;
              }
            }
          })
        } catch (err) {
          Logger.error(TAG, `kvStore.on(dataChange) err :` + err);
        }
      }
      Logger.info(TAG, `kvStore.on(dataChange) end`);
    })
  }
}