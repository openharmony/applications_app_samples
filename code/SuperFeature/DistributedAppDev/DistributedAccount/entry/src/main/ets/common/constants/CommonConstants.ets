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

import relationalStore from '@ohos.data.relationalStore';

/**
 * Common constants for all features.
 */
export default class CommonConstants {
  /**
   * Database store configuration.
   */
  static readonly RDB_STORE_CONFIG: relationalStore.StoreConfig = {
    name: 'AccountDatabase.db', securityLevel: relationalStore.SecurityLevel.S1, encrypt: false
  };

  /**
   * SQL statement for creating a account.
   */
  static readonly CREATE_TABLE_ACCOUNT: string = 'CREATE TABLE IF NOT EXISTS Account ' +
  '(id INTEGER PRIMARY KEY AUTOINCREMENT, distributedAccountName TEXT NOT NULL, distributedAccountID TEXT NOT NULL, localId INTEGER)';

  /**
   * Table account name.
   */
  static readonly TABLE_ACCOUNT: string = 'Account';

  /**
   * Account NAME field in the database table.
   */
  static readonly FIELD_DISTRIBUTED_ACCOUNT_NAME: string = 'distributedAccountName';

  /**
   * Specification fields in the database table.
   */
  static readonly FIELD_DISTRIBUTED_ACCOUNT_ID: string = 'distributedAccountID';

  /**
   * Time field in the database table.
   */
  static readonly FIELD_LOCAL_ID: string = 'localId';
}