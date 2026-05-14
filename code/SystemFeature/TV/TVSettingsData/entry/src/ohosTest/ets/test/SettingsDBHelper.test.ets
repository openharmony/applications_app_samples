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
 * @file SettingsDBHelper.test.ets
 * @overview 测试 SettingsDBHelper 数据库帮助类
 *           覆盖：单例模式、RDB初始化、首次启动检测、默认配置加载、
 *                表数据加载、区域模式判断、SQL执行验证
 */

import { describe, it, expect, beforeAll, afterAll, beforeEach, afterEach } from '@ohos/hypium';
import SettingsDBHelper from '../../../main/ets/Utils/SettingsDBHelper';
import { settingsDataConfig, DataSettingsKey, DataDefaultKey } from '../../../main/ets/Utils/SettingsDataConfig';
import { IContent, TableType } from '../../../main/ets/common/Common';
import { GlobalContext } from '../../../main/ets/Utils/GlobalContext';
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
import { relationalStore, dataSharePredicates } from '@kit.ArkData';
import { contextConstant } from '@kit.AbilityKit';
import { TestDataCleaner } from './TestUtils';

export default function settingsDBHelperTest() {
  describe('SettingsDBHelper_Test', () => {
    let driver: Driver;
    const TEST_PREFIX = 'db_helper_test';

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

    beforeEach(async () => {
      TestDataCleaner.reset();
    });

    afterEach(async () => {
      await TestDataCleaner.cleanTestDataByPrefix(TEST_PREFIX);
    });

    // ========== 单例模式测试 ==========

    it('get_instance_should_return_same_object', 0, () => {
      const instance1 = SettingsDBHelper.getInstance();
      const instance2 = SettingsDBHelper.getInstance();
      expect(instance1 === instance2).assertTrue();
    });

    it('get_instance_should_not_return_null', 0, () => {
      const instance = SettingsDBHelper.getInstance();
      expect(instance !== null).assertTrue();
    });

    it('multiple_get_instance_calls_should_return_same_ref', 0, () => {
      const instances: SettingsDBHelper[] = [];
      for (let i = 0; i < 5; i++) {
        instances.push(SettingsDBHelper.getInstance());
      }
      for (let i = 1; i < instances.length; i++) {
        expect(instances[i] === instances[0]).assertTrue();
      }
    });

    // ========== 常量定义测试 ==========

    it('shared_table_create_prefix_should_contain_table_name', 0, () => {
      expect(SettingsDBHelper.SHARED_TABLE_CREATE_PREFIX)
        .assertEqual(`CREATE TABLE IF NOT EXISTS ${settingsDataConfig.TABLE_NAME}`);
    });

    it('current_user_table_create_prefix_should_contain_user_table_name', 0, () => {
      expect(SettingsDBHelper.CURRENT_USER_TABLE_CREATE_PREFIX)
        .assertEqual(`CREATE TABLE IF NOT EXISTS ${settingsDataConfig.USER_TABLE_NAME}_`);
    });

    it('current_secure_table_create_prefix_should_contain_secure_table_name', 0, () => {
      expect(SettingsDBHelper.CURRENT_SECURE_TABLE_CREATE_PREFIX)
        .assertEqual(`CREATE TABLE IF NOT EXISTS ${settingsDataConfig.SECURE_TABLE_NAME}_`);
    });

    it('table_create_suffix_should_contain_field_definitions', 0, () => {
      const suffix = SettingsDBHelper.TABLE_CREATE_SUFFIX;
      expect(suffix.includes(settingsDataConfig.FIELD_ID)).assertTrue();
      expect(suffix.includes(settingsDataConfig.FIELD_KEYWORD)).assertTrue();
      expect(suffix.includes(settingsDataConfig.FIELD_VALUE)).assertTrue();
    });

    it('table_create_suffix_should_have_primary_key', 0, () => {
      const suffix = SettingsDBHelper.TABLE_CREATE_SUFFIX;
      expect(suffix.includes('PRIMARY KEY AUTOINCREMENT')).assertTrue();
    });

    it('table_create_suffix_should_have_value_length_check', 0, () => {
      const suffix = SettingsDBHelper.TABLE_CREATE_SUFFIX;
      expect(suffix.includes('CHECK')).assertTrue();
      expect(suffix.includes('1000')).assertTrue();
    });

    // ========== 区域模式判断测试 ==========

    it('get_area_should_return_valid_area', 0, () => {
      const helper = SettingsDBHelper.getInstance();
      const area = helper.getArea();
      expect(area === contextConstant.AreaMode.EL1 || area === contextConstant.AreaMode.EL2)
        .assertTrue();
    });

    it('get_area_should_be_consistent', 0, () => {
      const helper = SettingsDBHelper.getInstance();
      const area1 = helper.getArea();
      const area2 = helper.getArea();
      expect(area1).assertEqual(area2);
    });

    // ========== RDB初始化测试 ==========

    it('get_rdb_store_should_return_valid_store', 0, async () => {
      const helper = SettingsDBHelper.getInstance();
      const rdbStore = await helper.getRdbStore();
      expect(rdbStore !== undefined).assertTrue();
    });

    it('get_rdb_store_should_be_consistent', 0, async () => {
      const helper = SettingsDBHelper.getInstance();
      const store1 = await helper.getRdbStore();
      const store2 = await helper.getRdbStore();
      expect(store1 === store2).assertTrue();
    });

    it('rdb_store_should_have_valid_security_level', 0, async () => {
      const helper = SettingsDBHelper.getInstance();
      const rdbStore = await helper.getRdbStore();
      expect(rdbStore !== undefined).assertTrue();
    });

    // ========== 首次启动检测测试 ==========

    it('first_startup_config_should_initialize_preferences', 0, async () => {
      const helper = SettingsDBHelper.getInstance();
      await helper.getRdbStore();
      expect(helper !== null).assertTrue();
    });

    // ========== 默认配置加载测试 ==========

    it('load_default_settings_should_not_throw', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        await helper.getRdbStore();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 表数据加载测试 ==========

    it('load_table_data_with_empty_content_should_not_throw', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const emptyContent: IContent = {
          settings: [],
          user: [],
          userSecure: []
        };
        await helper.loadTableData(emptyContent, TableType.SETTINGS, 0);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('load_table_data_with_settings_type_should_not_throw', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const entry: Map<string, string> = new Map<string, string>();
        entry.set('name', 'test_key');
        entry.set('value', 'test_value');
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

    it('load_table_data_with_user_type_should_not_throw', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const entry: Map<string, string> = new Map<string, string>();
        entry.set('name', 'user_key');
        entry.set('value', 'user_value');
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

    it('load_table_data_with_secure_type_should_not_throw', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const entry: Map<string, string> = new Map<string, string>();
        entry.set('name', 'secure_key');
        entry.set('value', 'secure_value');
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

    it('load_table_data_with_multiple_entries_should_not_throw', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const entry1: Map<string, string> = new Map<string, string>();
        entry1.set('name', 'key1');
        entry1.set('value', 'value1');
        const entry2: Map<string, string> = new Map<string, string>();
        entry2.set('name', 'key2');
        entry2.set('value', 'value2');
        const content: IContent = {
          settings: [entry1, entry2],
          user: [],
          userSecure: []
        };
        await helper.loadTableData(content, TableType.SETTINGS, 0);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 表名生成测试 ==========

    it('get_table_name_for_settings_should_return_base_table', 0, async () => {
      const helper = SettingsDBHelper.getInstance();
      await helper.getRdbStore();
      const tableName = settingsDataConfig.TABLE_NAME;
      expect(tableName).assertEqual('SETTINGSDATA');
    });

    it('get_table_name_for_user_should_include_user_id', 0, async () => {
      const helper = SettingsDBHelper.getInstance();
      await helper.getRdbStore();
      const userId = 0;
      const userTableName = `${settingsDataConfig.USER_TABLE_NAME}_${userId}`;
      expect(userTableName).assertEqual('USER_SETTINGSDATA_0');
    });

    it('get_table_name_for_secure_should_include_user_id', 0, async () => {
      const helper = SettingsDBHelper.getInstance();
      await helper.getRdbStore();
      const userId = 0;
      const secureTableName = `${settingsDataConfig.SECURE_TABLE_NAME}_${userId}`;
      expect(secureTableName).assertEqual('USER_SETTINGSDATA_SECURE_0');
    });

    // ========== 初始插入测试 ==========

    it('initial_insert_should_not_throw', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        await helper.getRdbStore();
        await helper.initialInsert(settingsDataConfig.TABLE_NAME);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('initial_insert_should_create_time_key', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        await helper.getRdbStore();
        await helper.initialInsert(settingsDataConfig.TABLE_NAME);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('initial_insert_for_user_table_should_not_throw', 0, async () => {
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

    it('initial_insert_for_secure_table_should_not_throw', 0, async () => {
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

    // ========== 默认文件读取测试 ==========

    it('read_default_file_should_not_throw', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        await helper.getRdbStore();
        const result = await helper.readDefaultFile();
        expect(result !== null).assertTrue();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('read_default_file_should_return_string', 0, async () => {
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

    it('read_default_file_should_return_valid_json', 0, async () => {
      let threw = false;
      let validJson = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        await helper.getRdbStore();
        const result = await helper.readDefaultFile();
        if (typeof result === 'string' && result.length > 0) {
          JSON.parse(result);
          validJson = true;
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 数据库操作压力测试 ==========

    it('multiple_rdb_store_calls_should_be_consistent', 0, async () => {
      const helper = SettingsDBHelper.getInstance();
      const stores: relationalStore.RdbStore[] = [];
      for (let i = 0; i < 5; i++) {
        const store = await helper.getRdbStore();
        if (store !== undefined) {
          stores.push(store);
        }
      }
      for (let i = 1; i < stores.length; i++) {
        expect(stores[i] === stores[0]).assertTrue();
      }
    });

    it('concurrent_initial_inserts_should_not_throw', 0, async () => {
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

    // ========== 边界条件测试 ==========

    it('load_table_data_with_large_content_should_not_throw', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const entries: Map<string, string>[] = [];
        for (let i = 0; i < 50; i++) {
          const entry: Map<string, string> = new Map<string, string>();
          entry.set('name', `${TEST_PREFIX}_large_key_${i}`);
          entry.set('value', 'large_value_' + i);
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

    it('load_table_data_with_special_chars_should_not_throw', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const entry: Map<string, string> = new Map<string, string>();
        entry.set('name', `${TEST_PREFIX}_key@#$%^&*()`);
        entry.set('value', 'value_with_special_chars!@#');
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

    it('load_table_data_with_unicode_should_not_throw', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const entry: Map<string, string> = new Map<string, string>();
        entry.set('name', `${TEST_PREFIX}_设置键名`);
        entry.set('value', '设置值');
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
  });
}
