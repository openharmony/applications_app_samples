/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import type dataSharePredicates from '@ohos.data.dataSharePredicates';
import Extension from '@ohos.application.DataShareExtensionAbility';
import hilog from '@ohos.hilog';
import rdb from '@ohos.data.relationalStore';
import type Want from '@ohos.app.ability.Want';
import type { AsyncCallback } from '@ohos.base';
import type { ValuesBucket } from '@ohos.data.ValuesBucket';

const DB_NAME = 'DB00.db';
const TBL_NAME = 'TBL00';
const DDL_TBL_CREATE = 'CREATE TABLE IF NOT EXISTS ' + TBL_NAME +
' (cityId INTEGER PRIMARY KEY AUTOINCREMENT, type TEXT)';

let rdbStore;
let result;
const TAG: string = 'DataShareExtAbility';
const DOMAIN_NUMBER: number = 0xFF00;

export default class DataShareExtAbility extends Extension {
  private rdbStore_;

  // 重写onCreate接口
  async onCreate(want: Want, callback: AsyncCallback<void>): Promise<void> {
    result = this.context.cacheDir + '/datashare.txt';
    hilog.info(DOMAIN_NUMBER, TAG, `result : ${result}`);
    // 业务实现使用RDB
    rdb.getRdbStore(this.context, {
      name: DB_NAME,
      securityLevel: rdb.SecurityLevel.S1
    }, function (err, data) {
      hilog.info(DOMAIN_NUMBER, TAG, `getRdbStore done, data : ${data}`);
      rdbStore = data;
      rdbStore.executeSql(DDL_TBL_CREATE, [], (err) => {
        hilog.info(DOMAIN_NUMBER, TAG, `DataShareExtAbility onCreate, executeSql done err: ${JSON.stringify(err)}`);
      });
    });
  }

  async insert(uri: string, valueBucket: ValuesBucket, callback: Function): Promise<void> {
    if (valueBucket === null) {
      hilog.error(DOMAIN_NUMBER, TAG, 'invalid valueBuckets');
      return;
    }
    else {
      hilog.info(DOMAIN_NUMBER, TAG, `valueBucket, ${JSON.stringify(valueBucket)}`);
    }

    rdbStore.insert(TBL_NAME, valueBucket, (err, ret) => {
      hilog.info(DOMAIN_NUMBER, TAG, `callback ret: ${ret}`, JSON.stringify(err));
      if (callback !== undefined) {
        callback(err, ret);
      }
    });
  }

  async update(uri: string, predicates: dataSharePredicates.DataSharePredicates, valueBucket: ValuesBucket, callback: Function): Promise<void> {
    hilog.info(DOMAIN_NUMBER, TAG, '[ttt] [DataShareTest] <<Provider>> [update] enter');
    if (predicates === null || predicates === undefined) {
      hilog.info(DOMAIN_NUMBER, TAG, '[ttt] [DataShareTest] <<Provider>> [update] invalid predicates');
      return;
    }
    hilog.info(DOMAIN_NUMBER, TAG, `[update]  values = ${valueBucket}`);
    hilog.info(DOMAIN_NUMBER, TAG, `[update]  [update]  predicates = ${predicates}`);
    try {
      await rdbStore.update(TBL_NAME, valueBucket, predicates, function (err, ret) {
        hilog.info(DOMAIN_NUMBER, TAG, `[update] callback ret: ${ret}`);
        hilog.info(DOMAIN_NUMBER, TAG, `[update] callback err: ${err}`);
        if (callback !== undefined) {
          callback(err, ret);
        }
      });
    } catch (err) {
      hilog.error(DOMAIN_NUMBER, TAG, `[update] error: ${err}`);
    };
    hilog.info(DOMAIN_NUMBER, TAG, '[update] leave');
  }
}