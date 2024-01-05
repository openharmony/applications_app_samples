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

import distributedKVStore from '@ohos.data.distributedKVStore'
import { BusinessError } from '@ohos.base'
import common from '@ohos.app.ability.common'
import Logger from './Logger'

const TAG: string = 'PreferencesUtil'
const context = getContext(this) as common.UIAbilityContext

interface kvManagerConfig {
  context: common.UIAbilityContext,
  bundleName: string
}

class KVManagerUtil {
  private kvManager: distributedKVStore.KVManager = {} as distributedKVStore.KVManager
  private kvStore: distributedKVStore.SingleKVStore = {} as distributedKVStore.SingleKVStore

  constructor(context: common.UIAbilityContext, bundleName: string, storeId: string) {
    this.getKvManager(context, bundleName, storeId)
  }

  /**
   * 获取一个KVManager实例，用于管理数据库对象。
   * @param context
   * @param bundleName
   * @param storeId
   */
  getKvManager(context: common.UIAbilityContext, bundleName: string, storeId: string) {
    try {
      let config: kvManagerConfig = {
        context,
        bundleName
      }
      // 创建KVManager实例
      this.kvManager = distributedKVStore.createKVManager(config)
      this.getKvStore(storeId)
    } catch (e) {
      let error = e as BusinessError
      Logger.error(TAG, `Failed to create KVManager. Code:${error.code},message:${error.message}`)
    }
  }

  /**
   * 创建并获取键值数据库
   * @param storeId
   */
  async getKvStore(storeId: string) {
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
      }

      this.kvStore = await this.kvManager.getKVStore<distributedKVStore.SingleKVStore>(storeId, options)
    } catch (e) {
      let error = e as BusinessError
      Logger.error(TAG, `getKvStore - An unexpected error occurred. Code:${error.code},message:${error.message}`)
    }
  }

  /**
   * 关闭指定的分布式键值数据库
   * @param appId
   * @param storeId
   */
  async closeKVStore(appId: string, storeId: string) {
    if (!this.kvManager) {
      return
    }
    this.kvManager.closeKVStore(appId, storeId, (err) => {
      if (err != undefined) {
        Logger.error(TAG, `Failed to close KVStore.code is ${err.code},message is ${err.message}`);
        return;
      }
      Logger.info(TAG, 'Succeeded in closing KVStore');
    });
  }

  /**
   * 取指定键的值
   * @param key
   * @returns
   */
  async get(key: string): Promise<string> {
    let value: string = ''
    try {
      let data = await this.kvStore.get(key)
      if (data) {
        Logger.info(TAG, `get data: ${data}`)
        value = data as string
      }
    } catch (e) {
      let error = e as BusinessError
      Logger.error(TAG, `Failed to get data. Code:${error.code},message:${error.message}`)
    }
    return value
  }

  /**
   * 向键值数据库中插入数据
   * @param key
   * @param value
   */
  put(key: string, value: string) {
    try {
      this.kvStore.put(key, value, (err) => {
        if (err !== undefined) {
          Logger.error(TAG, `Failed to put data. Code:${err.code},message:${err.message}`)
          return
        }
        Logger.info(TAG, 'Succeeded in putting data.')
      })
    } catch (e) {
      let error = e as BusinessError
      Logger.error(TAG, `put - An unexpected error occurred. Code:${error.code},message:${error.message}`)
    }
  }

  /**
   * 删除指定键值的数据
   * @param key
   */
  delete(key: string) {
    try {
      this.kvStore.delete(key, (err) => {
        if (err !== undefined) {
          Logger.error(TAG, `Failed to delete data. Code:${err.code},message:${err.message}`);
          return;
        }
        Logger.info(TAG, 'Succeeded in deleting data.');
      });
    } catch (e) {
      let error = e as BusinessError;
      Logger.error(TAG, `delete - An unexpected error occurred. Code:${error.code},message:${error.message}`);
    }
  }
}

export default new KVManagerUtil(context, context.abilityInfo.bundleName, 'offlineLicenseId')