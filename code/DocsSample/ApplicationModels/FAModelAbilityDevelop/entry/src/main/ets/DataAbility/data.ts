/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import featureAbility from '@ohos.ability.featureAbility';
import type common from '@ohos.app.ability.common';
import type Want from '@ohos.app.ability.Want';
import type { AsyncCallback, BusinessError } from '@ohos.base';
import dataAbility from '@ohos.data.dataAbility';
import rdb from '@ohos.data.rdb';
import hilog from '@ohos.hilog';

let TABLE_NAME = 'book';
let STORE_CONFIG: rdb.StoreConfig = { name: 'book.db' };
let SQL_CREATE_TABLE = 'CREATE TABLE IF NOT EXISTS book(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, introduction TEXT NOT NULL)';
let rdbStore: rdb.RdbStore | undefined = undefined;
const TAG: string = '[Sample_FAModelAbilityDevelop]';
const domain: number = 0xFF00;

class DataAbility {
  onInitialized(want: Want): void {
    hilog.info(domain, TAG, 'DataAbility onInitialized, abilityInfo:' + want.bundleName);
    let context: common.BaseContext = { stageMode: featureAbility.getContext().stageMode };
    rdb.getRdbStore(context, STORE_CONFIG, 1, (err, store) => {
      hilog.info(domain, TAG, 'DataAbility getRdbStore callback');
      store.executeSql(SQL_CREATE_TABLE, []);
      rdbStore = store;
    });
  }

  insert(uri: string, valueBucket: rdb.ValuesBucket, callback: AsyncCallback<number>): void {
    hilog.info(domain, TAG, 'DataAbility insert start');
    if (rdbStore) {
      rdbStore.insert(TABLE_NAME, valueBucket, callback);
    }
  }

  batchInsert(uri: string, valueBuckets: Array<rdb.ValuesBucket>, callback: AsyncCallback<number>): void {
    hilog.info(domain, TAG, 'DataAbility batch insert start');
    if (rdbStore) {
      for (let i = 0; i < valueBuckets.length; i++) {
        hilog.info(domain, TAG, 'DataAbility batch insert i=' + i);
        if (i < valueBuckets.length - 1) {
          rdbStore.insert(TABLE_NAME, valueBuckets[i], (err: BusinessError, num: number) => {
            hilog.info(domain, TAG, 'DataAbility batch insert ret=' + num);
          });
        } else {
          rdbStore.insert(TABLE_NAME, valueBuckets[i], callback);
        }
      }
    }
  }

  query(uri: string, columns: Array<string>, predicates: dataAbility.DataAbilityPredicates, callback: AsyncCallback<rdb.ResultSet>): void {
    hilog.info(domain, TAG, 'DataAbility query start');
    let rdbPredicates = dataAbility.createRdbPredicates(TABLE_NAME, predicates);
    if (rdbStore) {
      rdbStore.query(rdbPredicates, columns, callback);
    }
  }

  update(uri: string, valueBucket: rdb.ValuesBucket, predicates: dataAbility.DataAbilityPredicates, callback: AsyncCallback<number>): void {
    hilog.info(domain, TAG, 'DataAbility update start');
    let rdbPredicates = dataAbility.createRdbPredicates(TABLE_NAME, predicates);
    if (rdbStore) {
      rdbStore.update(valueBucket, rdbPredicates, callback);
    }
  }

  delete(uri: string, predicates: dataAbility.DataAbilityPredicates, callback: AsyncCallback<number>): void {
    hilog.info(domain, TAG, 'DataAbility delete start');
    let rdbPredicates = dataAbility.createRdbPredicates(TABLE_NAME, predicates);
    if (rdbStore) {
      rdbStore.delete(rdbPredicates, callback);
    }
  }
}

export default new DataAbility();