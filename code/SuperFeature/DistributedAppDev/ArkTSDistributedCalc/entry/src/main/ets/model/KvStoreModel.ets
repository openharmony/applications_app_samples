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
import Logger from './Logger'
import { BUNDLE_NAME } from './RemoteDeviceModel'
import common from '@ohos.app.ability.common';
import { BusinessError, Callback } from '@ohos.base';
import distributedDeviceManager from '@ohos.distributedDeviceManager';

const TAG: string = 'KvStoreModel';
const STORE_ID: string = 'distributedcalc';
let devManager: distributedDeviceManager.DeviceManager;

export class KvStoreModel {
  public kvManager: distributedData.KVManager | undefined = undefined;
  public kvStore: distributedData.SingleKVStore | undefined = undefined;
  public syncDelayTimeMs: number = 1000;
  public isFirstSync: boolean = true;

  async createKvStore(context: common.BaseContext, callback: Callback<void>) {
    Logger.info(TAG, `createKvStore start, type of kvStore = ` + (typeof (this.kvStore)));
    if ((typeof (this.kvStore) !== 'undefined')) {
      callback()
      return
    }
    let config: distributedData.KVManagerConfig = {
      bundleName: BUNDLE_NAME,
      context: context
    };
    try {
      Logger.info(TAG, `ecreateKVManager start`);
      this.kvManager = distributedData.createKVManager(config);
      Logger.info(TAG, `ecreateKVManager success`);
    } catch (err) {
      Logger.info(TAG, `ecreateKVManager err:${JSON.stringify(err)}`);
    }
    Logger.info(TAG, `createKVManager end`);
    let options: distributedData.Options = {
      createIfMissing: true,
      encrypt: false,
      backup: false,
      autoSync: false,
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
    Logger.info(TAG, `kvManager.getKVStore end`);
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

  put(key: string, value: string, isFirstSync: boolean) {
    if (this.kvStore) {
      Logger.info(TAG, `kvStore.put ${key} = ${value}， isFirstSync ${isFirstSync}`);
      this.kvStore.put(
        key,
        value
      ).then((data) => {
        Logger.info(TAG, `kvStore.put ${key} finished, data= ${JSON.stringify(data)}`);
        devManager = distributedDeviceManager.createDeviceManager(BUNDLE_NAME);
        Logger.info(TAG, `kvStore.put ${key} create deviceManager success`);
        let deviceIds: string[] = [];
        if (devManager != null) {
          let devices = devManager.getAvailableDeviceListSync();
          Logger.info(TAG, `kvStore.put devices ${JSON.stringify(devices)}`);
          for (let i = 0; i < devices.length; i++) {
            deviceIds[i] = devices[i].networkId as string;
          }
        }
        Logger.info(TAG, `kvStore.put networkIds ${JSON.stringify(deviceIds)}`);
        const mode = distributedData.SyncMode.PUSH_PULL;
        Logger.info(TAG, `isFirstSync ${this.isFirstSync}`);

        if (this.kvStore != null) {
          // 第一次同步，涉及拉起应用，耗时较长，增加延时时间，减少同步失败问题
          if (isFirstSync) {
            this.syncDelayTimeMs = 2000;
          } else {
            this.syncDelayTimeMs = 1000;
          }
          Logger.info(TAG,
            `kvStore.put start sync, delay time is ${this.syncDelayTimeMs}, isFirstSync ${this.isFirstSync}`);
          this.kvStore.sync(deviceIds, mode, this.syncDelayTimeMs);
          Logger.info(TAG, `kvStore.put sync success`);
        }
      }).catch((err: BusinessError) => {
        Logger.error(TAG, `kvStore.put ${key} failed, ${JSON.stringify(err)}`);
      })
    }
  }

  setOnMessageReceivedListener(context: common.UIAbilityContext, msg: string, callback: Callback<string>) {
    Logger.info(TAG, `setOnMessageReceivedListener: msg = ${msg}`);
    this.createKvStore(context, () => {
      Logger.info(TAG, `setOnMessageReceivedListener kvStore create kvStore success`);
      if (this.kvStore !== undefined && this.kvStore !== null) {
        try {
          Logger.info(TAG, `setOnMessageReceivedListener kvStore.on(dataChange) begin`);
          this.kvStore!.on('dataChange', distributedData.SubscribeType.SUBSCRIBE_TYPE_REMOTE, (data) => {
            Logger.info(TAG, `setOnMessageReceivedListener dataChange result, ${JSON.stringify(data)}`);
            let entries = data.insertEntries.length > 0 ? data.insertEntries : data.updateEntries;
            Logger.info(TAG, `setOnMessageReceivedListener dataChange entries, ${JSON.stringify(entries)}`);
            for (let i = 0; i < entries.length; i++) {
              if (entries[i].key === msg) {
                let value = entries[i].value.value.toString();
                Logger.info(TAG, `setOnMessageReceivedListener Entries receive msg :${msg}, value：${value}`);
                callback(value);
                return;
              }
            }
          })
          Logger.info(TAG, `setOnMessageReceivedListener kvStore.on(dataChange) add success`);
          this.kvStore!.on('syncComplete', (data) => {
            Logger.info(TAG, `setOnMessageReceivedListener syncComplete result, ${JSON.stringify(data)}`);
          })
          Logger.info(TAG, `setOnMessageReceivedListener kvStore.on(syncComplete) add success`);
        } catch (err) {
          Logger.error(TAG, `setOnMessageReceivedListener kvStore.on() err :` + err);
        }
        Logger.info(TAG, `setOnMessageReceivedListener kvStore.on() end`);
      }
    })
  }

  releaseMessageReceivedListener() {
    if (this.kvStore !== undefined && this.kvStore !== null) {
      try {
        Logger.info(TAG, `releaseMessageReceivedListener kvStore.off(dataChange) begin`);
        this.kvStore!.off('dataChange');
        Logger.info(TAG, `releaseMessageReceivedListener kvStore.off(dataChange) success`);
        this.kvStore!.off('syncComplete');
        Logger.info(TAG, `releaseMessageReceivedListener kvStore.off(syncComplete) success`);
      } catch (err) {
        Logger.error(TAG, `releaseMessageReceivedListener kvStore.off() err :` + err);
      }
      Logger.info(TAG, `releaseMessageReceivedListener kvStore.off() end`);
    }
  }
}