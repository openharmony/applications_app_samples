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

import distributedData from '@ohos.data.distributedData'
import { logger } from '../model/Logger'

const STORE_ID = 'musicplayer_kvstore'
const TAG = 'KvStoreModel'

export default class KvStoreModel {
  kvManager
  kvStore

  constructor() {
  }

  createKvStore(callback) {
    if (typeof (this.kvStore) === 'undefined') {
      var config = {
        bundleName: 'ohos.samples.distributedmusicplayer',
        userInfo: {
          userId: '0',
          userType: 0
        }
      }
      let self = this
      logger.info(TAG, `createKVManager begin`)
      distributedData.createKVManager(config).then((manager) => {
        logger.debug(TAG, `createKVManager success, kvManager=${JSON.stringify(manager)}`)
        self.kvManager = manager
        var options = {
          createIfMissing: true,
          encrypt: false,
          backup: false,
          autoSync: true,
          kvStoreType: 1,
          schema: '',
          securityLevel: 3,
        }
        logger.info(TAG, `kvManager.getKVStore begin`)
        self.kvManager.getKVStore(STORE_ID, options).then((store) => {
          logger.debug(TAG, `getKVStore success, kvStore=${store}`)
          self.kvStore = store
          callback()
        })
        logger.info(TAG, `kvManager.getKVStore end`)
      })
      logger.info(TAG, `createKVManager end`)
    } else {
      callback()
    }
  }

  broadcastMessage(msg) {
    logger.debug(TAG, `broadcastMessage ${msg}`)
    var num = Math.random()
    let self = this
    this.createKvStore(() => {
      self.put(msg, num)
    })
  }

  put(key, value) {
    logger.debug(TAG, `kvStore.put ${key}=${value}`)
    this.kvStore.put(key, value).then((data) => {
      this.kvStore.get(key).then((data) => {
        logger.debug(TAG, `kvStore.get ${key}=${JSON.stringify(data)}`)
      })
      logger.debug(TAG, `kvStore.put ${key}  finished, data= ${JSON.stringify(data)}`)
    }).catch((err) => {
      logger.error(TAG, `kvStore.put  ${key} failed, ${JSON.stringify(err)}`)
    })
  }

  setOnMessageReceivedListener(msg, callback) {
    logger.debug(TAG, `setOnMessageReceivedListener ${msg}`)
    let self = this
    this.createKvStore(() => {
      logger.info(TAG, `kvStore.on(dataChange) begin`)
      self.kvStore.on('dataChange', 1, (data) => {
        logger.debug(TAG, `dataChange ${JSON.stringify(data)} insert ${data.insertEntries.length} update ${data.updateEntries.length}`)
        for (var i = 0; i < data.insertEntries.length; i++) {
          if (data.insertEntries[i].key === msg) {
            logger.debug(TAG, `insertEntries receive ${msg}=${JSON.stringify(data.insertEntries[i].value)}`)
            callback()
            return
          }
        }
        for (i = 0; i < data.updateEntries.length; i++) {
          if (data.updateEntries[i].key === msg) {
            logger.debug(TAG, `updateEntries receive ${msg}=${JSON.stringify(data.updateEntries[i].value)}`)
            callback()
            return
          }
        }
      })
      logger.info(TAG, `kvStore.on(dataChange) end`)
    })
  }
}