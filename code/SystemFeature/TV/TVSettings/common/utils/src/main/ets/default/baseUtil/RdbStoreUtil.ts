/**
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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
import BaseModel from '../model/BaseModel';
import LogUtil  from './LogUtil';
import ohosDataRdb from '@ohos.data.rdb';

const TAG = "RdbStoreUtil.js->";
// Database name
const STORE_CONFIG = {
  name: "settings.db",
}
// Database instance object
var rdbStore = undefined;
/**
 * Creating a database
 */
var getRdbStore = async function () {
  if (rdbStore == null) {
    rdbStore = await ohosDataRdb.getRdbStore(STORE_CONFIG, 1);
  }
  return rdbStore;
}

export default {
  /**
     * create data
     */
  createRdbStore(callback) {
    LogUtil.info(TAG + 'get data')
    if (!rdbStore) {
      ohosDataRdb.getRdbStore(STORE_CONFIG, 1)
        .then((store) => {
          LogUtil.info(TAG + 'get data create  success' + JSON.stringify(store))
          rdbStore = store
          callback(true)
      })
        .catch((err) => {
        LogUtil.info(TAG + 'get data createRdbStore err' + err)
        callback(false)
      })
    }
  },
  /**
     * create data table
     */
  async createTable(table) {
    LogUtil.info(TAG + 'create table start');
    await rdbStore.executeSql(table, null);
    LogUtil.info(TAG + 'create table end');
  },
  /**
     * insert
     */
  insert(tableName, rowValue) {
    LogUtil.info('get data start: ' + tableName);
    return rdbStore.insert(tableName, rowValue);
  },
  /**
     * update
     * @param predicates
     * @param valueBucket
     * @return
     */
  async update(predicates, rowValue) {
    LogUtil.info(TAG + 'update start');
    let changedRows = await rdbStore.update(rowValue, predicates);
    LogUtil.info(TAG + 'update row count: ' + changedRows);
  },
  /**
     * delete
     * @param predicates
     * @return
     */
  async deleteItem(predicates) {
    LogUtil.info(TAG + 'get data delete item');
    let deletedRows = await rdbStore.delete(predicates);
    LogUtil.info(TAG + 'get data delete deletedRows' + deletedRows);
  },
  /**
     * query
     * @param tableName
     * @return
     */
  getRdbPredicates(tableName) {
    LogUtil.info(TAG + 'get data query table start')
    let predicates = new ohosDataRdb.RdbPredicates(tableName);
    LogUtil.info(TAG + 'get data query table end' + JSON.stringify(predicates))
    return predicates;
  },
  /**
     * get rdbData
     * @return
     */
  getRdbStore() {
    return rdbStore;
  },
}


