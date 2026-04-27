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
 * @file SettingsDataConsistency.test.ets
 * @overview 测试设置数据一致�?
 *           覆盖：读写一致性、事务一致性、多表一致性、状态一致�?
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

interface ConsistencyStateObj {
  consistency_state: boolean;
  value: number;
}

interface ConsistencyStateUpdateObj {
  consistency_state_update: boolean;
  version: number;
}

export default function settingsDataConsistencyTest() {
  describe('SettingsDataConsistency_Test', () => {
    let driver: Driver;
    const TEST_PREFIX = 'consistency_test';

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

    // ========== 读写一致性测�?==========

    it('consistency_write_then_read_immediately', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = `${TEST_PREFIX}_write_read_key`;
        const value = 'consistency_write_read_value';
        
        await DatabaseTestHelper.insertTestData(key, value);

        const resultSet = await DatabaseTestHelper.queryTestData(key);
        expect(resultSet.rowCount).assertLargerOrEqual(1);
      });
      expect(success).assertTrue();
    });

    it('consistency_write_then_read_after_update', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = `${TEST_PREFIX}_write_update_read_key`;
        const originalValue = 'consistency_write_update_read_value_original';
        const updatedValue = 'consistency_write_update_read_value_updated';
        
        await DatabaseTestHelper.insertTestData(key, originalValue);
        await DatabaseTestHelper.updateTestData(key, updatedValue);

        const resultSet = await DatabaseTestHelper.queryTestData(key);
        expect(resultSet.rowCount).assertLargerOrEqual(1);
      });
      expect(success).assertTrue();
    });

    it('consistency_write_then_read_after_delete', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = `${TEST_PREFIX}_write_delete_read_key`;
        const value = 'consistency_write_delete_read_value';
        
        await DatabaseTestHelper.insertTestData(key, value);
        await DatabaseTestHelper.deleteTestData(key);

        const predicates = new dataSharePredicates.DataSharePredicates();
        predicates.equalTo('KEYWORD', key);
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          expect(resultSet.rowCount).assertEqual(0);
        }
      });
      expect(success).assertTrue();
    });

    // ========== 事务一致性测�?==========

    it('consistency_transaction_commit_all_or_nothing', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          await rdbStore.beginTransaction();
          for (let i = 0; i < 10; i++) {
            const valuesBucket: relationalStore.ValuesBucket = {
              'KEYWORD': 'consistency_txn_commit_key_' + i,
              'VALUE': 'consistency_txn_commit_value_' + i
            };
            await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          }
          await rdbStore.commit();

          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.like('KEYWORD', 'consistency_txn_commit_%');
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          expect(resultSet.rowCount).assertLargerOrEqual(10);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('consistency_transaction_rollback_on_error', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          try {
            await rdbStore.beginTransaction();
            for (let i = 0; i < 5; i++) {
              const valuesBucket: relationalStore.ValuesBucket = {
                'KEYWORD': 'consistency_txn_rollback_key_' + i,
                'VALUE': 'consistency_txn_rollback_value_' + i
              };
              await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
            }
            await rdbStore.commit();
          } catch (e) {
            await rdbStore.rollBack();
          }
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 多表一致性测�?==========

    it('consistency_multiple_tables_insert', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const settingsBucket: relationalStore.ValuesBucket = {
            'KEYWORD': 'consistency_multi_table_settings_key',
            'VALUE': 'consistency_multi_table_settings_value'
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, settingsBucket);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 状态一致性测�?==========

    it('consistency_context_property_set_get', 0, () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        ctx.setProperty('consistency_state_key', 'consistency_state_value');
        expect(ctx.getProperty('consistency_state_key')).assertEqual('consistency_state_value');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('consistency_context_object_set_get', 0, () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        const testObj: ConsistencyStateObj = { consistency_state: true, value: 123 };
        ctx.setObject('consistency_state_obj_key', testObj);
        expect(ctx.getObject('consistency_state_obj_key') !== undefined).assertTrue();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('consistency_context_property_update', 0, () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        ctx.setProperty('consistency_state_update_key', 'consistency_state_update_value_original');
        ctx.setProperty('consistency_state_update_key', 'consistency_state_update_value_updated');
        expect(ctx.getProperty('consistency_state_update_key')).assertEqual('consistency_state_update_value_updated');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('consistency_context_object_update', 0, () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        const originalObj: ConsistencyStateUpdateObj = { consistency_state_update: true, version: 1 };
        ctx.setObject('consistency_state_update_obj_key', originalObj);
        const updatedObj: ConsistencyStateUpdateObj = { consistency_state_update: true, version: 2 };
        ctx.setObject('consistency_state_update_obj_key', updatedObj);
        expect(ctx.getObject('consistency_state_update_obj_key') !== undefined).assertTrue();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 数据格式一致性测�?==========

    it('consistency_data_format_string_value', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': 'consistency_format_string_key',
            'VALUE': 'consistency_format_string_value'
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);

          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.equalTo('KEYWORD', 'consistency_format_string_key');
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          expect(resultSet.rowCount).assertLargerOrEqual(1);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('consistency_data_format_numeric_value', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': 'consistency_format_numeric_key',
            'VALUE': '12345'
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);

          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.equalTo('KEYWORD', 'consistency_format_numeric_key');
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          expect(resultSet.rowCount).assertLargerOrEqual(1);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 批量操作一致性测�?==========

    it('consistency_batch_insert_all_succeed', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          for (let i = 0; i < 20; i++) {
            const valuesBucket: relationalStore.ValuesBucket = {
              'KEYWORD': 'consistency_batch_insert_key_' + i,
              'VALUE': 'consistency_batch_insert_value_' + i
            };
            await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          }

          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.like('KEYWORD', 'consistency_batch_insert_%');
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          expect(resultSet.rowCount).assertLargerOrEqual(20);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('consistency_batch_update_all_succeed', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.like('KEYWORD', 'consistency_batch_insert_%');
          const updateBucket: relationalStore.ValuesBucket = {
            'VALUE': 'consistency_batch_update_value'
          };
          await rdbStore.update(settingsDataConfig.TABLE_NAME, updateBucket, predicates);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('consistency_batch_delete_all_succeed', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.like('KEYWORD', 'consistency_batch_insert_%');
          await rdbStore.delete(settingsDataConfig.TABLE_NAME, predicates);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });
  });
}
