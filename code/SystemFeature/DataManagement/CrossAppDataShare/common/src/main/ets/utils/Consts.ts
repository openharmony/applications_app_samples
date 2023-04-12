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

import rdb from '@ohos.data.relationalStore'

// table name
export const TABLE_NAME: string = 'contact'

// table config
export const STORE_CONFIG: rdb.StoreConfig = { name: 'contact.db', securityLevel: rdb.SecurityLevel.S1 }

// create table sql
export const SQL_CREATE_TABLE: string = 'CREATE TABLE IF NOT EXISTS contact (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, phone TEXT NOT NULL, email TEXT NOT NULL, address TEXT NOT NULL, remark TEXT NOT NULL, UNIQUE(name))'

export const BASE_URI = 'datashare:///ohos.samples.dataprovider.DataShare'

export const COLUMNS = ['*']

export const OPERATE_STATUS = {
  ADD: 'ADD',
  UPDATE: 'UPDATE'
}

export const SYNC_STATE = {
  OVERWRITE_CONTACT_ASSISTANT: 'overwrite contact assistant',
  OVERWRITE_CONTACT: 'overwrite contact',
  DEDUPLICATION: 'deduplication'
}