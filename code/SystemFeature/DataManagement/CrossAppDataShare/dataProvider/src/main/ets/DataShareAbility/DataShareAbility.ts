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

import rdb from '@ohos.data.rdb'
import DataShareExtensionAbility from '@ohos.application.DataShareExtensionAbility'
import { logger, SQL_CREATE_TABLE, STORE_CONFIG, TABLE_NAME } from '@ohos/common'

const TAG: string = 'DataShareAbility'
let rdbStore: rdb.RdbStoreV9 = undefined

export default class DataShareAbility extends DataShareExtensionAbility {
  onCreate(want, callback) {
    logger.info(TAG, 'onCreate')
    try {
      rdb.getRdbStoreV9(this.context, STORE_CONFIG, 1, (error, data) => {
        logger.info(TAG, `DataShareExtAbility getRdbStore done`)
        rdbStore = data
        rdbStore.executeSql(SQL_CREATE_TABLE, [], () => {
          logger.info(TAG, `DataShareExtAbility executeSql done`)
          if (callback) {
            callback()
          }
        })
      })
    } catch (error) {
      logger.error(TAG, `getRdbStore error: ${JSON.stringify(error)}`)
    }
  }

  insert(uri: string, valueBucket, callback) {
    logger.info(TAG, `[insert] enter`)
    if (valueBucket === null || valueBucket === undefined) {
      logger.info(' [insert] invalid valueBuckets')
      return
    }
    logger.info(TAG, ` [insert]  value = ${JSON.stringify(valueBucket)}`)
    if (rdbStore) {
      try {
        rdbStore.insert(TABLE_NAME, valueBucket, (error, ret) => {
          if (callback !== undefined) {
            callback(error, ret)
          }
        })
      } catch (error) {
        logger.error(TAG, `insert error: ${JSON.stringify(error)}`)
      }
    }
  }

  delete(uri, predicates, callback) {
    logger.info(TAG, `delete`)
    if (rdbStore) {
      try {
        rdbStore.delete(TABLE_NAME, predicates, (error, ret) => {
          logger.info(TAG, `delete ret: ${ret}`)
          callback(error, ret)
        })
      } catch (error) {
        logger.error(TAG, `delete error: ${JSON.stringify(error)}`)
      }
    }
  }

  query(uri, predicates, columns, callback) {
    logger.info(TAG, `query enter`)
    if (rdbStore) {
      try {
        rdbStore.query(TABLE_NAME, predicates, columns, (error, resultSet) => {
          logger.info(TAG, `query ret: ${resultSet}`)
          if (resultSet !== undefined) {
            logger.info(TAG, `query resultSet.rowCount: ${JSON.stringify(resultSet.rowCount)}`)
          }
          if (callback !== undefined) {
            callback(error, resultSet)
          }
        })
      } catch (error) {
        logger.error(TAG, `query error: ${JSON.stringify(error)}`)
      }
    }
  }

  update(uri, predicates, value, callback) {
    logger.info(TAG, `update enter`)
    if (predicates === null || predicates === undefined) {
      return
    }
    if (rdbStore) {
      try {
        rdbStore.update(TABLE_NAME, value, predicates, (error, ret) => {
          if (callback !== undefined) {
            callback(error, ret)
          }
        })
      } catch (error) {
        logger.error(TAG, `update error: ${JSON.stringify(error)}`)
      }
    }
  }

  batchInsert(uri, valueBuckets, callback) {
    logger.info(TAG, `batchInsert enter`)
    if (rdbStore) {
      try {
        rdbStore.batchInsert(TABLE_NAME, valueBuckets, (error, ret) => {
          if (callback !== undefined) {
            callback(error, ret)
          }
        })
      } catch (error) {
        logger.error(TAG, `update error: ${JSON.stringify(error)}`)
      }
    }
  }
}
