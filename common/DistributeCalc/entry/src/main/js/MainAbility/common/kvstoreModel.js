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
import { logger } from './Logger'

const STORE_ID = 'distributedcalc'
const TAG = 'KvStoreModel'

export class KvStoreModel {
  kvManager
  kvStore

  createKvStore(callback) {
    if ((typeof (this.kvStore) !== undefined)) {
      callback()
    }
    var config = {
      bundleName: 'ohos.samples.distributedcalc',
      userInfo: {
        userId: '0',
        userType: 0
      }
    }
    logger.info(TAG, `createKVManager begin`)
    distributedData.createKVManager(config).then((manager) => {
      logger.debug(`createKVManager success, kvManager=${JSON.stringify(manager)}`)
      this.kvManager = manager
      let options = {
        createIfMissing: true,
        encrypt: false,
        backup: false,
        autoSync: true,
        kvStoreType: 1,
        securityLevel: 1,
      }
      logger.info(TAG, `kvManager.getKVStore begin`)
      this.kvManager.getKVStore(STORE_ID, options).then((store) => {
        logger.debug(TAG, `getKVStore success, kvStore=${store}`)
        this.kvStore = store
        callback()
      })
      logger.info(TAG, `kvManager.getKVStore end`)
    })
    logger.info(TAG, `createKVManager end`)
  }

  put(key, value) {
    logger.debug(TAG, `kvStore.put ${key}=${value}`)
    try {
      this.kvStore.put(key, value + 'end').then((data) => {
        logger.debug(TAG, `kvStore.put ${key}  finished, data=${JSON.stringify(data)}`)
      }).catch((err) => {
        logger.error(TAG, `kvStore.put ${key} failed, ${JSON.stringify(err)}`)
      })
    } catch(error) {
      logger.error(TAG, `kvStore.put code ${JSON.stringify(error.code)}`)
    }
  }

  off() {
    if (this.kvStore !== null) {
      try {
        this.kvStore.off('dataChange')
      } catch(error) {
        logger.error(TAG, `kvStore.off code ${JSON.stringify(error.code)}`)
      }
    }
  }

  setOnMessageReceivedListener(msg, refreshdata) {
    logger.debug(TAG, `setOnMessageReceivedListener ${msg}`)
    this.createKvStore(() => {
      logger.info(TAG, `kvStore.on(dataChange) begin`)
      try {
      this.kvStore.on('dataChange', distributedData.SubscribeType.SUBSCRIBE_TYPE_REMOTE, (data) => {
        logger.debug(TAG, `dataChange, ${JSON.stringify(data)}`)
        logger.debug(TAG, `dataChange, insert ${data.insertEntries.length} update ${data.updateEntries.length}`)
        let entries = data.insertEntries.length > 0 ? data.insertEntries : data.updateEntries
        this.simplify(entries, msg, refreshdata)
      })
      } catch(error) {
        logger.error(TAG, `kvStore.on(dataChange) code is ${JSON.stringify(error.code)}, message is ${JSON.stringify(error.message)}`)
      }
      logger.info(TAG, `kvStore.on(dataChange) end`)
    })
  }

  simplify(entries, msg, refreshdata) {
    for (let i = 0; i < entries.length; i++) {
      if (entries[i].key === msg) {
        let value = entries[i].value.value
        logger.debug(TAG, `Entries receive ${msg}=${value}`)
        let valueResult = value.substring(0, value.lastIndexOf('end'))
        logger.debug(TAG, `Entries receive valueResult = ${valueResult}`)
        refreshdata(valueResult)
        return
      }
    }
  }
}