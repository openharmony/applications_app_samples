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

import dataAbility from '@ohos.data.dataAbility'
import featureAbility from '@ohos.ability.featureAbility'
import rdb from '@ohos.data.rdb'
import Logger from '../MainAbility/util/Logger'
import { TABLE_NAME, STORE_CONFIG, SQL_CREATE_TABLE } from '../MainAbility/model/DaHelperConst'

const TAG: string = 'data'
let rdbStore: rdb.RdbStore = undefined
// 对应stage模型中DataShareExtensionAbility.ts
export default {

  // 对应stage模型中的onCreate
  onInitialized(abilityInfo) {
    Logger.info(TAG, 'DataAbility onInitialized start')

    // 初始化RDB数据库
    rdb.getRdbStore(featureAbility.getContext(), STORE_CONFIG, 1, (err, data) => { // 1代表需要升级或降级的数据库版本号
      if (err) {
        Logger.info(TAG, `getRdbStore create table err = ${JSON.stringify(err)}`)
      }
      Logger.info(TAG, `getRdbStore create table done`)
      data.executeSql(SQL_CREATE_TABLE)
      rdbStore = data
      Logger.info(TAG, `create table end, rdbStore = ${rdbStore}`)
    })
    Logger.info(TAG, 'DataAbility onInitialized end')
  },

  // 添加单条数据,对应stage模型中的insert
  insert(uri, valueBucket, callback) {
    Logger.info(TAG, `insert start`)
    if (rdbStore) {
      rdbStore.insert(TABLE_NAME, valueBucket, callback)
    }
  },

  // 查询数据,对应stage模型中的query
  query(uri, columns, predicates, callback) {
    Logger.info(TAG, `query start`)
    if (rdbStore) {
      let rdbPredicates = dataAbility.createRdbPredicates(TABLE_NAME, predicates)
      rdbStore.query(rdbPredicates, columns, callback)
    }
  },

  update(uri, valueBucket, predicates, callback) {
    Logger.info(TAG, 'update start')
    if (rdbStore) {
      let rdbPredicates = dataAbility.createRdbPredicates(TABLE_NAME, predicates)
      rdbStore.update(valueBucket, rdbPredicates, callback)
    }
  },

  // 删除数据,对应stage模型中的delete
  delete(uri, predicates, callback) {
    Logger.info(TAG, `delete start`)
    if (rdbStore) {
      let rdbPredicates = dataAbility.createRdbPredicates(TABLE_NAME, predicates)
      rdbStore.delete(rdbPredicates, callback)
    }
  },

  call(method, arg, extras, callback) {
    Logger.info(TAG, `call start`)
  }
}