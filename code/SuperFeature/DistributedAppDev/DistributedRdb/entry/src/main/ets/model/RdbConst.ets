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

import data_rdb from '@ohos.data.relationalStore';

export const TABLE_NAME = 'contact';

export const SQL_CREATE_TABLE = 'CREATE TABLE IF NOT EXISTS contact(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, gender INTEGER, phone TEXT NOT NULL UNIQUE, remark TEXT,age INTEGER)';

export const COLUMNS = ['id', 'name', 'gender', 'phone', 'remark', 'age'];

export const STORE_CONFIG: data_rdb.StoreConfig = { name: 'contact.db', securityLevel: data_rdb.SecurityLevel.S1 };

export const BUNDLE = 'ohos.samples.distributedrdb';

export const ABILITY = 'EntryAbility';

export const TYPE_INSERT = 'insert';

export const TYPE_UPDATE = 'update';

export const TYPE_DELETE = 'delete';