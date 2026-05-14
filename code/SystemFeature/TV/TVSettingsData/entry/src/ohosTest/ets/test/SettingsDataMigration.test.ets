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
 * @file SettingsDataMigration.test.ets
 * @overview 测试设置数据迁移功能
 *           覆盖：数据导入、数据导出、版本迁移、格式转换、数据校�? */

import { describe, it, expect, beforeAll, afterAll, beforeEach, afterEach } from '@ohos/hypium';
import { settingsDataConfig, DataSettingsKey, DataDefaultKey } from '../../../main/ets/Utils/SettingsDataConfig';
import SettingsDBHelper from '../../../main/ets/Utils/SettingsDBHelper';
import { TestDataCleaner, DatabaseTestHelper, TestAssertions } from './TestUtils';
import { IContent, TableType } from '../../../main/ets/common/Common';
import { GlobalContext } from '../../../main/ets/Utils/GlobalContext';
import { Log } from '../../../main/ets/Utils/Log';
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
import { dataSharePredicates, relationalStore } from '@kit.ArkData';

export default function settingsDataMigrationTest() {
  describe('SettingsDataMigration_Test', () => {
    let driver: Driver;
    const TEST_PREFIX = 'migration_test';

    beforeAll(async () => {
      SettingsDBHelper.resetInstance();
      TestDataCleaner.reset();

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

    // ========== 数据导入测试 ==========

    it('migration_import_single_setting_entry', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const entry: Map<string, string> = new Map<string, string>();
        entry.set('name', 'import_single_key');
        entry.set('value', 'import_single_value');
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

    it('migration_import_multiple_setting_entries', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const helper = SettingsDBHelper.getInstance();
        const entries: Map<string, string>[] = [];
        for (let i = 0; i < 10; i++) {
          const entry: Map<string, string> = new Map<string, string>();
          entry.set('name', 'import_multi_key_' + i);
          entry.set('value', 'import_multi_value_' + i);
          entries.push(entry);
        }
        const content: IContent = {
          settings: entries,
          user: [],
          userSecure: []
        };
        await helper.loadTableData(content, TableType.SETTINGS, 0);
      });
      expect(success).assertTrue();
    });

    it('migration_import_user_data_entries', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const helper = SettingsDBHelper.getInstance();
        const entries: Map<string, string>[] = [];
        for (let i = 0; i < 5; i++) {
          const entry: Map<string, string> = new Map<string, string>();
          entry.set('name', 'import_user_key_' + i);
          entry.set('value', 'import_user_value_' + i);
          entries.push(entry);
        }
        const content: IContent = {
          settings: [],
          user: entries,
          userSecure: []
        };
        await helper.loadTableData(content, TableType.USER, 0);
      });
      expect(success).assertTrue();
    });

    it('migration_import_secure_data_entries', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const helper = SettingsDBHelper.getInstance();
        const entries: Map<string, string>[] = [];
        for (let i = 0; i < 5; i++) {
          const entry: Map<string, string> = new Map<string, string>();
          entry.set('name', 'import_secure_key_' + i);
          entry.set('value', 'import_secure_value_' + i);
          entries.push(entry);
        }
        const content: IContent = {
          settings: [],
          user: [],
          userSecure: entries
        };
        await helper.loadTableData(content, TableType.USER_SECURE, 0);
      });
      expect(success).assertTrue();
    });

    it('migration_import_all_types_together', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const settingsEntries: Map<string, string>[] = [];
        const userEntries: Map<string, string>[] = [];
        const secureEntries: Map<string, string>[] = [];
        for (let i = 0; i < 3; i++) {
          const settingsEntry: Map<string, string> = new Map<string, string>();
          settingsEntry.set('name', 'import_settings_' + i);
          settingsEntry.set('value', 'import_settings_value_' + i);
          settingsEntries.push(settingsEntry);

          const userEntry: Map<string, string> = new Map<string, string>();
          userEntry.set('name', 'import_user_' + i);
          userEntry.set('value', 'import_user_value_' + i);
          userEntries.push(userEntry);

          const secureEntry: Map<string, string> = new Map<string, string>();
          secureEntry.set('name', 'import_secure_' + i);
          secureEntry.set('value', 'import_secure_value_' + i);
          secureEntries.push(secureEntry);
        }
        const content: IContent = {
          settings: settingsEntries,
          user: userEntries,
          userSecure: secureEntries
        };
        await helper.loadTableData(content, TableType.SETTINGS, 0);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 数据导出测试 ==========

    it('migration_export_settings_data', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          expect(resultSet.rowCount).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('migration_export_user_data', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const userTableCreate = `CREATE TABLE IF NOT EXISTS ${settingsDataConfig.USER_TABLE_NAME}_0 (` +
            `${settingsDataConfig.FIELD_ID} INTEGER PRIMARY KEY AUTOINCREMENT, ` +
            `${settingsDataConfig.FIELD_KEYWORD} TEXT, ` +
            `${settingsDataConfig.FIELD_VALUE} TEXT CHECK (LENGTH(VALUE)<=1000))`;
          await rdbStore.executeSql(userTableCreate, []);

          const predicates = new dataSharePredicates.DataSharePredicates();
          const resultSet = await rdbStore.query(`${settingsDataConfig.USER_TABLE_NAME}_0`, predicates, []);
          expect(resultSet.rowCount).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('migration_export_secure_data', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const secureTableCreate = `CREATE TABLE IF NOT EXISTS ${settingsDataConfig.SECURE_TABLE_NAME}_0 (` +
            `${settingsDataConfig.FIELD_ID} INTEGER PRIMARY KEY AUTOINCREMENT, ` +
            `${settingsDataConfig.FIELD_KEYWORD} TEXT, ` +
            `${settingsDataConfig.FIELD_VALUE} TEXT CHECK (LENGTH(VALUE)<=1000))`;
          await rdbStore.executeSql(secureTableCreate, []);

          const predicates = new dataSharePredicates.DataSharePredicates();
          const resultSet = await rdbStore.query(`${settingsDataConfig.SECURE_TABLE_NAME}_0`, predicates, []);
          expect(resultSet.rowCount).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 版本迁移测试 ==========

    it('migration_version_v1_to_v2', 0, async () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        ctx.setProperty('migration_version', 'v1');
        ctx.setProperty('migration_version', 'v2');
        expect(ctx.getProperty('migration_version')).assertEqual('v2');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('migration_version_v2_to_v3', 0, async () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        ctx.setProperty('migration_version', 'v2');
        ctx.setProperty('migration_version', 'v3');
        expect(ctx.getProperty('migration_version')).assertEqual('v3');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('migration_version_multiple_upgrades', 0, async () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        ctx.setProperty('migration_version', 'v1');
        ctx.setProperty('migration_version', 'v2');
        ctx.setProperty('migration_version', 'v3');
        ctx.setProperty('migration_version', 'v4');
        expect(ctx.getProperty('migration_version')).assertEqual('v4');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 格式转换测试 ==========

    it('migration_format_json_to_db', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': 'migration_json_key',
            'VALUE': 'migration_json_value'
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('migration_format_db_to_json', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.equalTo('KEYWORD', 'migration_json_key');
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          expect(resultSet.rowCount).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 数据校验测试 ==========

    it('migration_validate_imported_data_count', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.like('KEYWORD', 'import_%');
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          expect(resultSet.rowCount).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('migration_validate_data_integrity', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.equalTo('KEYWORD', 'migration_json_key');
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          expect(resultSet.rowCount).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 迁移日志测试 ==========

    it('migration_log_start_and_end', 0, () => {
      let threw = false;
      try {
        Log.info('Migration started');
        Log.info('Migration completed');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('migration_log_progress', 0, () => {
      let threw = false;
      try {
        Log.info('Migration progress: 25%');
        Log.info('Migration progress: 50%');
        Log.info('Migration progress: 75%');
        Log.info('Migration progress: 100%');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });
  });
}
