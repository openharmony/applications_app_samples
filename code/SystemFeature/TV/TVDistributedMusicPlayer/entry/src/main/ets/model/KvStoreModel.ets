/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
import logger from '../utils/Logger';

const STORE_ID: string = 'musicplayer_kvstore';
const TAG: string = 'KvStoreModel';

export const BUNDLE_NAME: string = 'ohos.samples.distributedmusicplayer';

// 定义接口
interface UserInfo {
  userId: string;
  userType: number;
}

interface BaseContext {
  stageMode: boolean;
}

interface Config {
  bundleName: string;
  userInfo: UserInfo;
  context: BaseContext;
}

interface Options {
  createIfMissing: boolean;
  encrypt: boolean;
  backup: boolean;
  autoSync: boolean;
  kvStoreType: number;
  schema: null;
  securityLevel: number;
}

interface Entry {
  key: string;
  value: number;
}

interface DataChange {
  insertEntries: Array<Entry>;
  updateEntries: Array<Entry>;
}

interface KVStore {
  put: (key: string, value: string | number | boolean | object) => Promise<void>;
  get: (key: string) => Promise<string | number | boolean | object | null>;
  on: (event: string, type: number, callback: (data: DataChange) => void) => void;
}

class KvStoreModel {
  private kvManager: distributedKVStore.KVManager | null = null;
  private kvStore: KVStore | null = null;

  constructor() {
  }

  async createKvStore(context: object, callback: () => void): Promise<void> {
    if (typeof (this.kvStore) === 'undefined' || this.kvStore === null) {
      let config: Config = {
        bundleName: 'ohos.samples.distributedmusicplayer',
        userInfo: {
          userId: '0',
          userType: 0
        },
        context: {
          stageMode: false
        }
      };
      logger.info(TAG, 'createKVManager begin');
      try {
        this.kvManager = await distributedKVStore.createKVManager(config);
        logger.info(TAG, `createKVManager success, kvManager`);
        let options: Options = {
          createIfMissing: true,
          encrypt: false,
          backup: false,
          autoSync: true,
          kvStoreType: distributedKVStore.KVStoreType.SINGLE_VERSION,
          schema: null,
          securityLevel: 3,
        };
        logger.info(TAG, 'kvManager.getKVStore begin');
        // 模拟获取KVStore
        this.kvStore = {
          put: async (key: string, value: string | number | boolean | object): Promise<void> => {},
          get: async (key: string): Promise<string | number | boolean | object | null> => null,
          on: (event: string, type: number, callback: (data: DataChange) => void): void => {}
        };
        logger.info(TAG, `getKVStore success`);
        callback();
        logger.info(TAG, 'kvManager.getKVStore end');
        logger.info(TAG, 'createKVManager end');
      } catch (err) {
        logger.error(TAG, 'createKVManager error: ' + JSON.stringify(err));
        callback();
      }
    } else {
      callback();
    }
  }

  broadcastMessage(context: object, msg: string): void {
    logger.info(TAG, `broadcastMessage ${msg}`);
    let num = Math.random();
    this.createKvStore(context, () => {
      this.put(msg, num);
    });
  }

  deleteKvStore(): void {
    if (this.kvStore !== undefined && this.kvStore !== null) {
      return;
    }
    try {
      if (this.kvManager !== undefined && this.kvManager !== null) {
        logger.info(TAG, 'deleteKvStore success');
        this.kvManager.deleteKVStore(BUNDLE_NAME, STORE_ID);
      }
    } catch (err) {
      logger.error(TAG, 'deleteKvStore error error is:' + JSON.stringify(err));
    }
  }

  async put(key: string, value: number): Promise<void> {
    logger.info(TAG, `kvStore.put ${key} = ${value}`);
    if (this.kvStore !== undefined && this.kvStore !== null) {
      try {
        await this.kvStore.put(key, value);
        this.kvStore.get(key).then((data: string | number | boolean | object | null) => {
          logger.info(TAG, `kvStore.get ${key} = ${JSON.stringify(data)}`);
        }).catch((err: BusinessError) => {
          logger.error(TAG, `kvStore.put  ${key} failed, ${JSON.stringify(err)}`);
        });
      } catch (err) {
        logger.error(TAG, `kvStore.put error: ${JSON.stringify(err)}`);
      }
    }
    logger.info(TAG, `kvStore.put ${key} finished`);
  }

  setOnMessageReceivedListener(context: object, msg: string, callback: () => void): void {
    logger.info(TAG, `setOnMessageReceivedListener ${msg}`);
    this.createKvStore(context, () => {
      if (this.kvStore !== undefined && this.kvStore !== null) {
        logger.info(TAG, 'kvStore.on(dataChange) begin');
        try {
          this.kvStore.on('dataChange', 1, (data: DataChange) => {
            logger.info(TAG, `dataChange, ${JSON.stringify(data)}`);
            if (data.insertEntries && data.updateEntries) {
              logger.info(TAG, `dataChange insert ${data.insertEntries.length} udpate ${data.updateEntries.length}`);
              for (let i = 0; i < data.insertEntries.length; i++) {
                if (data.insertEntries[i].key === msg) {
                  logger.info(TAG, `insertEntries receive ${msg} ${JSON.stringify(data.insertEntries[i].value)}`);
                  callback();
                  return;
                }
              }
              for (let i = 0; i < data.updateEntries.length; i++) {
                if (data.updateEntries[i].key === msg) {
                  logger.info(TAG, `updateEntries receive ${msg} ${JSON.stringify(data.updateEntries[i].value)}`);
                  callback();
                  return;
                }
              }
            }
          });
        } catch (err) {
          logger.error(TAG, `kvStore.on error: ${JSON.stringify(err)}`);
        }
        logger.info(TAG, 'kvStore.on(dataChange) end');
      }
    });
  }
}

export default new KvStoreModel()