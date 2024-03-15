/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import DataRdb from '@ohos.data.relationalStore';
import Account from '../database/Account';
import { BusinessError } from '@ohos.base';
import CommonConstants from '../constants/CommonConstants';
import { GlobalContext } from '../database/GlobalContext';
import Logger from '../../model/Logger';

const TAG: string = `[DatabaseUtils]`

/**
 * Database operation tool class.
 */
export class DatabaseUtils {
  constructor(context: Context) {
    this.createRdbStore(context)
  }

  /**
   * Create rdb store
   *
   * @param {context} Context
   * @return {globalThis.rdbStore} return rdbStore RDB database
   */
  async createRdbStore(context: Context) {
    if (!GlobalContext.getrdbStore()) {
      // 获取RdbStore
      await DataRdb.getRdbStore(context, CommonConstants.RDB_STORE_CONFIG)
        .then((rdbStore: DataRdb.RdbStore) => {
          if (rdbStore) {
            // 创建数据表
            rdbStore.executeSql(CommonConstants.CREATE_TABLE_ACCOUNT).then(() => {
              Logger.info(TAG, 'executeSql Account successful');
            }).catch((error: BusinessError) => {
              Logger.error(TAG, 'executeSql Account error ' + JSON.stringify(error));
            });
            GlobalContext.setrdbStore(rdbStore);
          }
        }).catch((error: BusinessError) => {
          Logger.error(TAG, 'createRdbStore error ' + JSON.stringify(error));
        });
    }
    return GlobalContext.getrdbStore();
  }

  /**
   * Insert account data.
   *
   * @param {Account} account Account entity.
   * @param {DataRdb.RdbStore} rdbStore RDB database.
   */
  insertAccount(account: Account, rdbStore: DataRdb.RdbStore) {
    rdbStore.insert(CommonConstants.TABLE_ACCOUNT, account.toValuesBucket()).then((rowId) => {
      Logger.info(TAG, 'insertAccount successful ' + rowId);
    }).catch((error: BusinessError) => {
      Logger.error(TAG, 'insertAccount error ' + JSON.stringify(error));
    });
  }

  /**
   * Update account.
   *
   * @param {string} accountName Account Name.
   * @param {Account} account Account entity.
   * @param {DataRdb.RdbStore} rdbStore RDB database.
   */
  updateAccounts(accountName: string, account: Account, rdbStore: DataRdb.RdbStore) {
    let predicates: DataRdb.RdbPredicates = new DataRdb.RdbPredicates(CommonConstants.TABLE_ACCOUNT);
    predicates.equalTo(CommonConstants.FIELD_DISTRIBUTED_ACCOUNT_NAME, accountName);
    rdbStore.update(account.toValuesBucket(), predicates).then(async (rows) => {
      Logger.info(`Updated row count: ${rows}`);
    }).catch((err: BusinessError) => {
      Logger.error(`Updated failed, code is ${err.code},message is ${err.message}`);
    })
  }

  /**
   * Delete account data.
   *
   * @param {number} localId Account ID.
   * @param {DataRdb.RdbStore} rdbStore RDB database.
   */
  deleteAccountData(localId: number, rdbStore: DataRdb.RdbStore) {
    let predicates: DataRdb.RdbPredicates = new DataRdb.RdbPredicates(CommonConstants.TABLE_ACCOUNT);
    predicates.equalTo(CommonConstants.FIELD_LOCAL_ID, localId);
    rdbStore.delete(predicates).then(() => {
      Logger.info(TAG, 'deleteAccountData delete successful ');
    }).catch((error: BusinessError) => {
      Logger.error(TAG, 'deleteAccountData delete error ' + JSON.stringify(error));
    });
  }

  /**
   * Query account data.
   *
   * @param {string} accountName Account Name.
   * @param {DataRdb.RdbStore} rdbStore RDB database.
   */
  queryAccountData(accountName: string, rdbStore: DataRdb.RdbStore) {
    return new Promise<DataRdb.ResultSet>((resolve, reject) => {
      let predicates: DataRdb.RdbPredicates = new DataRdb.RdbPredicates(CommonConstants.TABLE_ACCOUNT);
      predicates.equalTo(CommonConstants.FIELD_DISTRIBUTED_ACCOUNT_NAME, accountName);
      rdbStore.query(predicates).then((resultSet) => {
        resolve(resultSet)
        Logger.info(TAG, 'queryAccountData query successful');
      }).catch((error: BusinessError) => {
        reject(error)
        Logger.error(TAG, 'queryAccountData query error ' + JSON.stringify(error));
      });
    })
  }
}
export default new DatabaseUtils(GlobalContext.getContext());