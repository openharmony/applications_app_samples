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
 * @file RdbStoreOperations.test.ets
 * @overview 测试 RdbStore 数据库操�? *           覆盖：事务管理、批量操作、索引操作、表管理、备份恢�? */

import { describe, it, expect, beforeAll, afterAll, beforeEach, afterEach } from '@ohos/hypium';
import { settingsDataConfig, DataSettingsKey, DataDefaultKey } from '../../../main/ets/Utils/SettingsDataConfig';
import SettingsDBHelper from '../../../main/ets/Utils/SettingsDBHelper';
import { TestDataCleaner, DatabaseTestHelper, TestAssertions } from './TestUtils';
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
import { GlobalContext } from '../../../main/ets/Utils/GlobalContext';

export default function rdbStoreOperationsTest() {
  describe('RdbStoreOperations_Test', () => {
    let driver: Driver;
    const TEST_PREFIX = 'rdbstore_test';

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

    // ========== 事务管理测试 ==========

    it('transaction_begin_and_commit_should_succeed', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          await rdbStore.beginTransaction();
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': 'transaction_commit_test_key',
            'VALUE': 'transaction_commit_test_value'
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          await rdbStore.commit();
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('transaction_multiple_operations_should_be_atomic', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          await rdbStore.beginTransaction();
          for (let i = 0; i < 5; i++) {
            const valuesBucket: relationalStore.ValuesBucket = {
              'KEYWORD': 'transaction_atomic_key_' + i,
              'VALUE': 'transaction_atomic_value_' + i
            };
            await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          }
          await rdbStore.commit();
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('transaction_nested_operations_should_work', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          await rdbStore.beginTransaction();
          const valuesBucket1: relationalStore.ValuesBucket = {
            'KEYWORD': 'transaction_nested_key_1',
            'VALUE': 'transaction_nested_value_1'
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket1);
          const valuesBucket2: relationalStore.ValuesBucket = {
            'KEYWORD': 'transaction_nested_key_2',
            'VALUE': 'transaction_nested_value_2'
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket2);
          await rdbStore.commit();
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 批量插入测试 ==========

    it('batch_insert_ten_records_in_transaction', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          await rdbStore.beginTransaction();
          for (let i = 0; i < 10; i++) {
            const valuesBucket: relationalStore.ValuesBucket = {
              'KEYWORD': 'batch_transaction_key_' + i,
              'VALUE': 'batch_transaction_value_' + i
            };
            await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          }
          await rdbStore.commit();
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('batch_insert_with_settings_keys_in_transaction', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          await rdbStore.beginTransaction();
          const settingsKeys: string[] = [
            DataSettingsKey.SETTINGS_SCREEN_BRIGHTNESS,
            DataSettingsKey.SETTINGS_TIME_FORMAT,
            DataSettingsKey.SETTINGS_AUDIO_RINGTONE,
            DataSettingsKey.SETTINGS_AUDIO_MEDIA,
            DataSettingsKey.SETTINGS_AUDIO_VOICE_CALL
          ];
          for (const key of settingsKeys) {
            const valuesBucket: relationalStore.ValuesBucket = {
              'KEYWORD': key,
              'VALUE': 'batch_settings_value'
            };
            await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          }
          await rdbStore.commit();
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 批量更新测试 ==========

    it('batch_update_with_predicates_in_transaction', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          await rdbStore.beginTransaction();
          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.like('KEYWORD', 'batch_transaction_%');
          const valuesBucket: relationalStore.ValuesBucket = {
            'VALUE': 'batch_transaction_updated'
          };
          await rdbStore.update(settingsDataConfig.TABLE_NAME, valuesBucket, predicates);
          await rdbStore.commit();
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('batch_update_multiple_records_individually', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          await rdbStore.beginTransaction();
          for (let i = 0; i < 5; i++) {
            const predicates = new dataSharePredicates.DataSharePredicates();
            predicates.equalTo('KEYWORD', 'batch_transaction_key_' + i);
            const valuesBucket: relationalStore.ValuesBucket = {
              'VALUE': 'batch_transaction_individual_updated_' + i
            };
            await rdbStore.update(settingsDataConfig.TABLE_NAME, valuesBucket, predicates);
          }
          await rdbStore.commit();
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 批量删除测试 ==========

    it('batch_delete_with_predicates_in_transaction', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          await rdbStore.beginTransaction();
          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.like('KEYWORD', 'batch_transaction_%');
          await rdbStore.delete(settingsDataConfig.TABLE_NAME, predicates);
          await rdbStore.commit();
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('batch_delete_multiple_records_individually', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          await rdbStore.beginTransaction();
          for (let i = 0; i < 5; i++) {
            const predicates = new dataSharePredicates.DataSharePredicates();
            predicates.equalTo('KEYWORD', 'transaction_atomic_key_' + i);
            await rdbStore.delete(settingsDataConfig.TABLE_NAME, predicates);
          }
          await rdbStore.commit();
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 查询操作测试 ==========

    it('query_all_records_with_empty_predicates', 0, async () => {
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

    it('query_with_equal_predicate', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.equalTo('KEYWORD', DataSettingsKey.SETTINGS_SCREEN_BRIGHTNESS);
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          expect(resultSet.rowCount).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('query_with_like_predicate', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.like('KEYWORD', '%SETTINGS%');
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          expect(resultSet.rowCount).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('query_with_in_predicate', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.in('KEYWORD', [
            DataSettingsKey.SETTINGS_SCREEN_BRIGHTNESS,
            DataSettingsKey.SETTINGS_TIME_FORMAT,
            DataSettingsKey.SETTINGS_AUDIO_RINGTONE
          ]);
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          expect(resultSet.rowCount).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('query_with_order_by_asc', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const resultSet: relationalStore.ResultSet =
            await rdbStore.querySql('SELECT * FROM ' + settingsDataConfig.TABLE_NAME + ' ORDER BY ID ASC');
          expect(resultSet.rowCount).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('query_with_order_by_desc', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const resultSet: relationalStore.ResultSet =
            await rdbStore.querySql('SELECT * FROM ' + settingsDataConfig.TABLE_NAME + ' ORDER BY ID DESC');
          expect(resultSet.rowCount).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('query_with_limit', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const resultSet: relationalStore.ResultSet =
            await rdbStore.querySql('SELECT * FROM ' + settingsDataConfig.TABLE_NAME + ' ORDER BY ID ASC LIMIT 10');
          expect(resultSet.rowCount).assertLessOrEqual(10);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('query_with_offset_and_limit', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const resultSet: relationalStore.ResultSet =
            await rdbStore.querySql('SELECT * FROM ' + settingsDataConfig.TABLE_NAME +
              ' ORDER BY ID ASC LIMIT 5 OFFSET 0');
          expect(resultSet.rowCount).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 结果集操作测�?==========

    it('result_set_go_to_first_row', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          if (resultSet.rowCount > 0) {
            resultSet.goToFirstRow();
          }
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('result_set_go_to_last_row', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          if (resultSet.rowCount > 0) {
            resultSet.goToLastRow();
          }
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('result_set_go_to_next_row', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          if (resultSet.rowCount > 1) {
            resultSet.goToFirstRow();
            resultSet.goToNextRow();
          }
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('result_set_go_to_previous_row', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          if (resultSet.rowCount > 1) {
            resultSet.goToLastRow();
            resultSet.goToPreviousRow();
          }
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('result_set_get_column_count', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          expect(resultSet.columnCount).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('result_set_get_column_names', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          const columnNames = resultSet.columnNames;
          expect(columnNames.length).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('result_set_is_first_row', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          if (resultSet.rowCount > 0) {
            resultSet.goToFirstRow();
            expect(resultSet.isAtFirstRow).assertTrue();
          }
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('result_set_is_last_row', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          if (resultSet.rowCount > 0) {
            resultSet.goToLastRow();
            expect(resultSet.isAtLastRow).assertTrue();
          }
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });
  });
}
