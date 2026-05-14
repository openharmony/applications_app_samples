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
 * @file SettingsDataRegression.test.ets
 * @overview 自动化回归测试套�?
 *           覆盖：核心功能回归、数据操作回归、配置回归、生命周期回�?
 */

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

interface RegressionLifecycleObj {
  regression_lifecycle: boolean;
  version: number;
}

export default function settingsDataRegressionTest() {
  describe('SettingsDataRegression_Test', () => {
    let driver: Driver;
    const TEST_PREFIX = 'regression_test';

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

    // ========== 核心功能回归测试 ==========

    it('regression_db_helper_get_instance', 0, () => {
      let threw = false;
      try {
        const instance1 = SettingsDBHelper.getInstance();
        const instance2 = SettingsDBHelper.getInstance();
        expect(instance1 !== undefined).assertTrue();
        expect(instance2 !== undefined).assertTrue();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('regression_db_helper_get_rdb_store', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        expect(rdbStore !== undefined).assertTrue();
      });
      expect(success).assertTrue();
    });

    it('regression_global_context_get_context', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const ctx1 = GlobalContext.getContext();
        const ctx2 = GlobalContext.getContext();
        expect(ctx1 !== undefined).assertTrue();
        expect(ctx2 !== undefined).assertTrue();
      });
      expect(success).assertTrue();
    });

    it('regression_settings_data_config_values', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        expect(settingsDataConfig.TABLE_NAME.length).assertLarger(0);
        expect(settingsDataConfig.DB_NAME.length).assertLarger(0);
        expect(settingsDataConfig.FIELD_ID.length).assertLarger(0);
        expect(settingsDataConfig.FIELD_KEYWORD.length).assertLarger(0);
        expect(settingsDataConfig.FIELD_VALUE.length).assertLarger(0);
      });
      expect(success).assertTrue();
    });

    // ========== 数据操作回归测试 ==========

    it('regression_insert_single_record', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = `${TEST_PREFIX}_regression_insert_key`;
        const value = 'regression_insert_value';
        
        const ret = await DatabaseTestHelper.insertTestData(key, value);
        expect(ret).assertLargerOrEqual(0);
      });
      expect(success).assertTrue();
    });

    it('regression_query_single_record', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = `${TEST_PREFIX}_regression_insert_key`;
        const value = 'regression_insert_value';
        
        await DatabaseTestHelper.insertTestData(key, value);

        const predicates = new dataSharePredicates.DataSharePredicates();
        predicates.equalTo('KEYWORD', key);
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          expect(resultSet.rowCount).assertLargerOrEqual(1);
        }
      });
      expect(success).assertTrue();
    });

    it('regression_update_single_record', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = `${TEST_PREFIX}_regression_insert_key`;
        const value = 'regression_insert_value';
        
        await DatabaseTestHelper.insertTestData(key, value);

        const predicates = new dataSharePredicates.DataSharePredicates();
        predicates.equalTo('KEYWORD', key);
        const valuesBucket: relationalStore.ValuesBucket = {
          'VALUE': 'regression_insert_value_updated'
        };
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          await rdbStore.update(settingsDataConfig.TABLE_NAME, valuesBucket, predicates);
        }
      });
      expect(success).assertTrue();
    });

    it('regression_delete_single_record', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = `${TEST_PREFIX}_regression_insert_key`;
        const value = 'regression_insert_value';
        
        await DatabaseTestHelper.insertTestData(key, value);

        const predicates = new dataSharePredicates.DataSharePredicates();
        predicates.equalTo('KEYWORD', key);
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          await rdbStore.delete(settingsDataConfig.TABLE_NAME, predicates);
        }
      });
      expect(success).assertTrue();
    });

    // ========== 配置回归测试 ==========

    it('regression_data_settings_keys', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        expect(DataSettingsKey.SETTINGS_SCREEN_BRIGHTNESS.length).assertLarger(0);
        expect(DataSettingsKey.SETTINGS_TIME_FORMAT.length).assertLarger(0);
        expect(DataSettingsKey.SETTINGS_AUDIO_RINGTONE.length).assertLarger(0);
      });
      expect(success).assertTrue();
    });

    it('regression_data_default_keys', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        expect(DataDefaultKey.SETTINGS_SCREEN_BRIGHTNESS_DEFAULT.length).assertLarger(0);
        expect(DataDefaultKey.SETTINGS_TIME_FORMAT_DEFAULT.length).assertLarger(0);
        expect(DataDefaultKey.SETTINGS_AUDIO_RINGTONE_DEFAULT.length).assertLarger(0);
      });
      expect(success).assertTrue();
    });

    // ========== 生命周期回归测试 ==========

    it('regression_context_property_lifecycle', 0, () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        ctx.setProperty('regression_lifecycle_key', 'regression_lifecycle_value');
        expect(ctx.getProperty('regression_lifecycle_key')).assertEqual('regression_lifecycle_value');
        ctx.setProperty('regression_lifecycle_key', 'regression_lifecycle_value_updated');
        expect(ctx.getProperty('regression_lifecycle_key')).assertEqual('regression_lifecycle_value_updated');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('regression_context_object_lifecycle', 0, () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        const obj1: RegressionLifecycleObj = { regression_lifecycle: true, version: 1 };
        ctx.setObject('regression_lifecycle_obj_key', obj1);
        expect(ctx.getObject('regression_lifecycle_obj_key') !== undefined).assertTrue();
        const obj2: RegressionLifecycleObj = { regression_lifecycle: true, version: 2 };
        ctx.setObject('regression_lifecycle_obj_key', obj2);
        expect(ctx.getObject('regression_lifecycle_obj_key') !== undefined).assertTrue();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 日志回归测试 ==========

    it('regression_log_info', 0, () => {
      let threw = false;
      try {
        Log.info('Regression test info message');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('regression_log_debug', 0, () => {
      let threw = false;
      try {
        Log.debug('Regression test debug message');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('regression_log_warn', 0, () => {
      let threw = false;
      try {
        Log.warn('Regression test warn message');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('regression_log_error', 0, () => {
      let threw = false;
      try {
        Log.error('Regression test error message');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('regression_log_fatal', 0, () => {
      let threw = false;
      try {
        Log.fatal('Regression test fatal message');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 事务回归测试 ==========

    it('regression_transaction_commit', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          await rdbStore.beginTransaction();
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': 'regression_txn_commit_key',
            'VALUE': 'regression_txn_commit_value'
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          await rdbStore.commit();
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 批量操作回归测试 ==========

    it('regression_batch_insert', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          for (let i = 0; i < 10; i++) {
            const valuesBucket: relationalStore.ValuesBucket = {
              'KEYWORD': 'regression_batch_insert_key_' + i,
              'VALUE': 'regression_batch_insert_value_' + i
            };
            await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          }
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('regression_batch_query', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.like('KEYWORD', 'regression_batch_insert_%');
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          expect(resultSet.rowCount).assertLargerOrEqual(10);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });
  });
}
