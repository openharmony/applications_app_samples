/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import rdb from '@ohos.data.relationalStore';

export const TABLE_NAME = 'contact';

export const SQL_CREATE_TABLE =
  'CREATE TABLE IF NOT EXISTS contact(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, phone TEXT NOT NULL, email TEXT NOT NULL, address TEXT NOT NULL, avatar TEXT NOT NULL, category TEXT NOT NULL)';

export const COLUMNS = ['id', 'name', 'phone', 'email', 'address', 'avatar', 'category'];

export const STORE_CONFIG: rdb.StoreConfig = { name: 'contact.db', securityLevel: rdb.SecurityLevel.S2 };

export const BUNDLE = 'com.north.cases';

export const ABILITY = 'EntryAbility';