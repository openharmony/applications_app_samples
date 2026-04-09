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

/**
 * Search config
 */
export default {
  RDB_NAME: 'settings.db',
  search: {
    TABLE_NAME: 'SEARCH_DATA',
    FIELD_ID: 'ID',
    FIELD_ICON: 'ICON',
    FIELD_TITLE: 'TITLE',
    FIELD_KEYWORD: 'KEYWORD',
    FIELD_SUMMARY: 'SUMMARY',
    FIELD_SYNONYM: 'SYNONYM',
    FIELD_URI: 'URI',
    DDL_TABLE_CREATE: 'CREATE TABLE IF NOT EXISTS SEARCH_DATA (' +
    'ID INTEGER PRIMARY KEY AUTOINCREMENT, ' +
    'URI VARCHAR(200) NOT NULL, ' +
    'ICON VARCHAR(200), ' +
    'TITLE TEXT NOT NULL COLLATE NOCASE, ' +
    'KEYWORD TEXT NOT NULL COLLATE NOCASE, ' +
    'SUMMARY TEXT, ' +
    'SYNONYM TEXT )',
    SQL_DELETE_ALL: 'DELETE FROM SEARCH_DATA',
    PATH_SEPARATOR: ' > '
  }
}
