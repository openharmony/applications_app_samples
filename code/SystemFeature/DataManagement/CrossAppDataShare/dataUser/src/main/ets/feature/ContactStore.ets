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
import {
  Contact,
  COLUMNS,
  getListFromResultSet,
  logger,
  STORE_CONFIG,
  SQL_CREATE_TABLE,
  TABLE_NAME
} from '@ohos/common'

const TAG: string = 'ContactStore'
let rdbStore: rdb.RdbStore = undefined

class ContactStore {
  constructor() {
  }

  async getRdbStore(context: Context) {
    try {
      rdbStore = await rdb.getRdbStore(context, STORE_CONFIG, 1)
      await rdbStore.executeSql(SQL_CREATE_TABLE, [])
      logger.info(TAG, `ContactStore executeSql done`)
    } catch (err) {
      logger.error(TAG, `getRdbStore error: ${JSON.stringify(err)}`)
    }
  }

  async insert(valuesBucket: rdb.ValuesBucket) {
    logger.info(TAG, `insert enter`)
    if (valuesBucket === null || valuesBucket === undefined) {
      logger.info(' insert invalid valueBuckets')
      return
    }
    logger.info(TAG, ` insert  value = ${JSON.stringify(valuesBucket)}`)
    if (rdbStore === undefined) {
      await this.getRdbStore(getContext(this))
    }
    try {
      let ret = await rdbStore.insert(TABLE_NAME, valuesBucket)
      logger.info(TAG, ` insert finish ${ret}`)
    } catch (err) {
      logger.error(TAG, `insert error: ${JSON.stringify(err)}`)
    }
  }

  async update(id: number, contact: Contact) {
    logger.info(TAG, `update enter`)
    if (contact === null || contact === undefined) {
      logger.info('update invalid valueBuckets')
      return
    }
    const valuesBucket = {
      'name': contact.name,
      'phone': contact.phone,
      'email': contact.email,
      'address': contact.address,
      'remark': contact.remark
    }
    logger.info(TAG, `update  value = ${JSON.stringify(valuesBucket)}`)
    if (rdbStore === undefined) {
      await this.getRdbStore(getContext(this))
    }
    try {
      let predicates = new rdb.RdbPredicates(TABLE_NAME)
      predicates.equalTo('id', id)
      let ret = rdbStore.update(valuesBucket, predicates)
      logger.info(TAG, `update finish ${ret}`)
    } catch (err) {
      logger.error(TAG, `update error: ${JSON.stringify(err)}`)
    }
  }

  async batchInsert(contacts: Contact[]) {
    logger.info(TAG, `batchInsert enter`)
    if (contacts === null || contacts === undefined) {
      logger.info('batchInsert invalid valueBuckets')
      return
    }
    let valuesBuckets = new Array()
    contacts.forEach((item) => {
      let valuesBucket: rdb.ValuesBucket = {
        'name': item.name,
        'phone': item.phone,
        'email': item.email,
        'address': item.address,
        'remark': item.remark
      }
      valuesBuckets.push(valuesBucket)
    })
    logger.info(TAG, `batchInsert  value = ${JSON.stringify(valuesBuckets)}`)
    if (rdbStore === undefined) {
      await this.getRdbStore(getContext(this))
    }
    try {
      let ret = await rdbStore.batchInsert(TABLE_NAME, valuesBuckets)
      logger.info(TAG, `batchInsert finish ${ret}`)
    } catch (err) {
      logger.error(TAG, `batchInsert error: ${JSON.stringify(err)}`)
    }
  }

  async delete(id: number) {
    if (rdbStore === undefined) {
      await this.getRdbStore(getContext(this))
    }
    try {
      let predicates = new rdb.RdbPredicates(TABLE_NAME)
      predicates.equalTo('id', id)
      await rdbStore.delete(predicates)
    } catch (err) {
      logger.error(TAG, `delete error: ${JSON.stringify(err)}`)
    }
  }

  async clearData() {
    if (rdbStore === undefined) {
      await this.getRdbStore(getContext(this))
    }
    try {
      let predicates = new rdb.RdbPredicates(TABLE_NAME)
      predicates.isNotNull('name')
      await rdbStore.delete(predicates)
    } catch (err) {
      logger.error(TAG, `clearData error: ${JSON.stringify(err)}`)
    }
  }

  async queryAll() {
    logger.info(TAG, `query enter`)
    if (rdbStore === undefined) {
      await this.getRdbStore(getContext(this))
    }
    try {
      let predicates = new rdb.RdbPredicates(TABLE_NAME)
      let resultSet = await rdbStore.query(predicates, COLUMNS)
      logger.info(TAG, `query ret: ${resultSet}`)
      if (resultSet !== undefined) {
        logger.info(TAG, `query resultSet.rowCount: ${JSON.stringify(resultSet.rowCount)}`)
        return getListFromResultSet(resultSet)
      } else {
        return []
      }
    } catch (err) {
      logger.error(TAG, `query error: ${JSON.stringify(err)}`)
    }
  }
}

export default new ContactStore()