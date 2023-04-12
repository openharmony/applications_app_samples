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

import featureAbility from '@ohos.ability.featureAbility'
import rdb from '@ohos.data.rdb'

export const BASE_URI: string = 'dataability:///ohos.samples.famodel.DataAbility'

export const COLUMNS: string[] = ['id', 'name', 'introduction']

export const TABLE_NAME: string = 'books'

export const STORE_CONFIG: rdb.StoreConfig = { name: 'books.db' }

export const SQL_CREATE_TABLE: string = 'CREATE TABLE IF NOT EXISTS books(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, introduction TEXT NOT NULL)'

export const BUNDLE_NAME: string = 'ohos.samples.famodel'

export const SERVICE_ABILITY_NAME: string = 'ohos.samples.famodel.ServiceAbility'

export const TAST_ABILITY_NAME: string = 'ohos.samples.famodel.TestAbility'

export const DA_HELPER = featureAbility.acquireDataAbilityHelper(BASE_URI)