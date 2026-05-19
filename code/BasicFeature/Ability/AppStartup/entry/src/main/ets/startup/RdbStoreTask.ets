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

import StartupTask from '@ohos.app.appstartup.StartupTask';
import common from '@ohos.app.ability.common';
import { RdbStoreUtil } from '../util/SingleKVStore';
import relationalStore from '@ohos.data.relationalStore';
import { BusinessError } from '@ohos.base';
import { ValuesBucket } from '@ohos.data.ValuesBucket';

@Sendable
export default class RdbStoreTask extends StartupTask {
  constructor() {
    super();
  }

  async init(context: common.AbilityStageContext) {

    RdbStoreUtil.getRdbStore(context)
      .then((rdbStore: relationalStore.RdbStore) => {
        const SQL_CREATE_TABLE =
          'CREATE TABLE IF NOT EXISTS EMPLOYEE (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT NOT NULL, AGE INTEGER, SALARY REAL, CODES BLOB)'; // 建表Sql语句
        rdbStore.executeSql(SQL_CREATE_TABLE); // 创建数据表
        let value1 = 'Lisa';
        let value2 = 18;
        let value3 = 100.5;
        let value4 = new Uint8Array([1, 2, 3, 4, 5]);

        const valueBucket1: ValuesBucket = {
          'NAME': value1,
          'AGE': value2,
          'SALARY': value3,
          'CODES': value4,
        };

        rdbStore.insert('EMPLOYEE', valueBucket1, (err: BusinessError, rowId: number) => {
          if (err) {
            console.error(`Failed to insert data. Code:${err.code}, message:${err.message}`);
            return;
          }
          console.info(`Succeeded in inserting data. rowId:${rowId}`);
        })

      }).catch((err: BusinessError) => {
      console.error(`Failed to create KVManager.message:${err}`);
    });

  }

  onDependencyCompleted(dependence: string, result: Object): void {
  }
}