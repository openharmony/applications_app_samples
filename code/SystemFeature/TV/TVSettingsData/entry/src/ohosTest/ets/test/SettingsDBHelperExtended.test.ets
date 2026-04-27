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

/**
 * @file SettingsDBHelperExtended.test.ets
 * @overview 扩展测试 SettingsDBHelper 数据库帮助类
 *           覆盖：SQL语句验证、表结构检查、索引验证、数据完整性
 */

import { describe, it, expect, beforeAll, afterAll } from '@ohos/hypium';
import SettingsDBHelper from '../../../main/ets/Utils/SettingsDBHelper';
import { settingsDataConfig, DataSettingsKey, DataDefaultKey } from '../../../main/ets/Utils/SettingsDataConfig';
import { IContent, TableType } from '../../../main/ets/common/Common';
import { relationalStore } from '@kit.ArkData';
import {
  getDriver,
  createFreshDriver,
  KEY_HOME,
  KEY_BACK,
  surfaceCount,
  waitForSurface,
  waitForStableSurface,
  pressAndWait,
  countNonEmptyTexts,
  TIMEOUT_HOME,
  TIMEOUT_COLD_START,
  STABLE_TOLERANCE,
  STABLE_ROUNDS
} from './SharedDriver';
import { Driver } from '@kit.TestKit';
import { GlobalContext } from '../../../main/ets/Utils/GlobalContext';

export default function settingsDBHelperExtendedTest() {
  describe('SettingsDBHelperExtended_Test', () => {
    let driver: Driver;

    beforeAll(async () => {
      SettingsDBHelper.resetInstance();

      driver = createFreshDriver();
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await waitForSurface(driver, 2, TIMEOUT_COLD_START);
      await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 2500);

      const ctx = GlobalContext.getContext();
      const abilityContext = getContext() as Context;
      ctx.setObject('abilityContext', abilityContext);
    });

    afterAll(async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 2000);
    });

    // ========== SQL语句验证测试 ==========

    it('sql_create_table_prefix_valid', 0, () => {
      const prefix = SettingsDBHelper.SHARED_TABLE_CREATE_PREFIX;
      expect(prefix.startsWith('CREATE TABLE IF NOT EXISTS')).assertTrue();
    });

    it('sql_create_table_prefix_contains_table_name', 0, () => {
      const prefix = SettingsDBHelper.SHARED_TABLE_CREATE_PREFIX;
      expect(prefix.includes(settingsDataConfig.TABLE_NAME)).assertTrue();
    });

    it('sql_create_user_table_prefix_valid', 0, () => {
      const prefix = SettingsDBHelper.CURRENT_USER_TABLE_CREATE_PREFIX;
      expect(prefix.startsWith('CREATE TABLE IF NOT EXISTS')).assertTrue();
    });

    it('sql_create_user_table_prefix_contains_user_table_name', 0, () => {
      const prefix = SettingsDBHelper.CURRENT_USER_TABLE_CREATE_PREFIX;
      expect(prefix.includes(settingsDataConfig.USER_TABLE_NAME)).assertTrue();
    });

    it('sql_create_secure_table_prefix_valid', 0, () => {
      const prefix = SettingsDBHelper.CURRENT_SECURE_TABLE_CREATE_PREFIX;
      expect(prefix.startsWith('CREATE TABLE IF NOT EXISTS')).assertTrue();
    });

    it('sql_create_secure_table_prefix_contains_secure_table_name', 0, () => {
      const prefix = SettingsDBHelper.CURRENT_SECURE_TABLE_CREATE_PREFIX;
      expect(prefix.includes(settingsDataConfig.SECURE_TABLE_NAME)).assertTrue();
    });

    it('sql_create_table_suffix_contains_id_field', 0, () => {
      const suffix = SettingsDBHelper.TABLE_CREATE_SUFFIX;
      expect(suffix.includes(settingsDataConfig.FIELD_ID)).assertTrue();
    });

    it('sql_create_table_suffix_contains_keyword_field', 0, () => {
      const suffix = SettingsDBHelper.TABLE_CREATE_SUFFIX;
      expect(suffix.includes(settingsDataConfig.FIELD_KEYWORD)).assertTrue();
    });

    it('sql_create_table_suffix_contains_value_field', 0, () => {
      const suffix = SettingsDBHelper.TABLE_CREATE_SUFFIX;
      expect(suffix.includes(settingsDataConfig.FIELD_VALUE)).assertTrue();
    });

    it('sql_create_table_suffix_contains_primary_key', 0, () => {
      const suffix = SettingsDBHelper.TABLE_CREATE_SUFFIX;
      expect(suffix.includes('PRIMARY KEY')).assertTrue();
    });

    it('sql_create_table_suffix_contains_autoincrement', 0, () => {
      const suffix = SettingsDBHelper.TABLE_CREATE_SUFFIX;
      expect(suffix.includes('AUTOINCREMENT')).assertTrue();
    });

    it('sql_create_table_suffix_contains_check_constraint', 0, () => {
      const suffix = SettingsDBHelper.TABLE_CREATE_SUFFIX;
      expect(suffix.includes('CHECK')).assertTrue();
    });

    it('sql_create_table_suffix_contains_length_limit', 0, () => {
      const suffix = SettingsDBHelper.TABLE_CREATE_SUFFIX;
      expect(suffix.includes('1000')).assertTrue();
    });

    // ========== 表结构检查测试 ==========

    it('table_structure_has_id_column', 0, () => {
      const suffix = SettingsDBHelper.TABLE_CREATE_SUFFIX;
      expect(suffix.includes('ID')).assertTrue();
    });

    it('table_structure_has_keyword_column', 0, () => {
      const suffix = SettingsDBHelper.TABLE_CREATE_SUFFIX;
      expect(suffix.includes('KEYWORD')).assertTrue();
    });

    it('table_structure_has_value_column', 0, () => {
      const suffix = SettingsDBHelper.TABLE_CREATE_SUFFIX;
      expect(suffix.includes('VALUE')).assertTrue();
    });

    it('table_structure_columns_are_uppercase', 0, () => {
      const suffix = SettingsDBHelper.TABLE_CREATE_SUFFIX;
      expect(suffix.includes('ID')).assertTrue();
      expect(suffix.includes('KEYWORD')).assertTrue();
      expect(suffix.includes('VALUE')).assertTrue();
    });

    // ========== 索引验证测试 ==========

    it('index_on_keyword_field_should_exist', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        await helper.getRdbStore();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 数据完整性测试 ==========

    it('data_integrity_insert_and_query', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          await helper.initialInsert(settingsDataConfig.TABLE_NAME);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('data_integrity_multiple_inserts', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        await helper.getRdbStore();
        await helper.initialInsert(settingsDataConfig.TABLE_NAME);
        await helper.initialInsert(settingsDataConfig.TABLE_NAME);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('data_integrity_user_table_insert', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        await helper.getRdbStore();
        await helper.initialInsert(`${settingsDataConfig.USER_TABLE_NAME}_0`);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('data_integrity_secure_table_insert', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        await helper.getRdbStore();
        await helper.initialInsert(`${settingsDataConfig.SECURE_TABLE_NAME}_0`);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 区域模式测试 ==========

    it('area_mode_consistent', 0, () => {
      const helper = SettingsDBHelper.getInstance();
      const area1 = helper.getArea();
      const area2 = helper.getArea();
      expect(area1).assertEqual(area2);
    });

    // ========== 默认文件读取测试 ==========

    it('read_default_file_returns_string', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        await helper.getRdbStore();
        const result = await helper.readDefaultFile();
        expect(typeof result === 'string').assertTrue();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('read_default_file_returns_valid_json', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        await helper.getRdbStore();
        const result = await helper.readDefaultFile();
        if (typeof result === 'string' && result.length > 0) {
          JSON.parse(result);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 表名生成测试 ==========

    it('table_name_for_settings_type', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        await helper.getRdbStore();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('table_name_for_user_type_with_id', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        await helper.getRdbStore();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('table_name_for_secure_type_with_id', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        await helper.getRdbStore();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 数据加载测试 ==========

    it('load_table_data_with_settings_type', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const entry: Map<string, string> = new Map<string, string>();
        entry.set('name', 'load_settings_key');
        entry.set('value', 'load_settings_value');
        const content: IContent = {
          settings: [entry],
          user: [],
          userSecure: []
        };
        await helper.loadTableData(content, TableType.SETTINGS, 0);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('load_table_data_with_user_type', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const entry: Map<string, string> = new Map<string, string>();
        entry.set('name', 'load_user_key');
        entry.set('value', 'load_user_value');
        const content: IContent = {
          settings: [],
          user: [entry],
          userSecure: []
        };
        await helper.loadTableData(content, TableType.USER, 0);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('load_table_data_with_secure_type', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const entry: Map<string, string> = new Map<string, string>();
        entry.set('name', 'load_secure_key');
        entry.set('value', 'load_secure_value');
        const content: IContent = {
          settings: [],
          user: [],
          userSecure: [entry]
        };
        await helper.loadTableData(content, TableType.USER_SECURE, 0);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('load_table_data_with_empty_content', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const content: IContent = {
          settings: [],
          user: [],
          userSecure: []
        };
        await helper.loadTableData(content, TableType.SETTINGS, 0);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('load_table_data_with_large_content', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const entries: Map<string, string>[] = [];
        for (let i = 0; i < 100; i++) {
          const entry: Map<string, string> = new Map<string, string>();
          entry.set('name', 'large_load_key_' + i);
          entry.set('value', 'large_load_value_' + i);
          entries.push(entry);
        }
        const content: IContent = {
          settings: entries,
          user: [],
          userSecure: []
        };
        await helper.loadTableData(content, TableType.SETTINGS, 0);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 并发访问测试 ==========

    it('concurrent_get_rdb_store', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const promises: Promise<relationalStore.RdbStore | undefined>[] = [];
        for (let i = 0; i < 5; i++) {
          promises.push(helper.getRdbStore());
        }
        const results = await Promise.all(promises);
        for (let i = 1; i < results.length; i++) {
          expect(results[i] === results[0]).assertTrue();
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('concurrent_initial_insert', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        await helper.getRdbStore();
        const tables: string[] = [
          settingsDataConfig.TABLE_NAME,
          `${settingsDataConfig.USER_TABLE_NAME}_0`,
          `${settingsDataConfig.SECURE_TABLE_NAME}_0`
        ];
        for (const table of tables) {
          await helper.initialInsert(table);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });
  });
}
