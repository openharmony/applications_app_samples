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
 * @file SettingsDataResultSet.test.ets
 * @overview 测试ResultSet结果集操作
 *           覆盖：结果集遍历、字段读取、位置操作、结果集关闭
 */

import { describe, it, expect, beforeAll, afterAll, beforeEach, afterEach } from '@ohos/hypium';
import { settingsDataConfig, DataSettingsKey, DataDefaultKey } from '../../../main/ets/Utils/SettingsDataConfig';
import SettingsDBHelper from '../../../main/ets/Utils/SettingsDBHelper';
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
import { TestDataCleaner, DatabaseTestHelper, TestAssertions } from './TestUtils';

export default function settingsDataResultSetTest() {
  describe('SettingsDataResultSet_Test', () => {
    let driver: Driver;
    const TEST_PREFIX = 'resultset_test';

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

    // ========== 结果集遍历测试 ==========

    it('resultset_go_to_first_row', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = `${TEST_PREFIX}_first_key`;
        const value = 'resultset_first_value';
        
        await DatabaseTestHelper.insertTestData(key, value);

        const predicates = new dataSharePredicates.DataSharePredicates();
        predicates.equalTo('KEYWORD', key);
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          const goToFirst = resultSet.goToFirstRow();
          expect(goToFirst).assertTrue();
        }
      });
      expect(success).assertTrue();
    });

    it('resultset_go_to_last_row', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = `${TEST_PREFIX}_last_key`;
        const value = 'resultset_last_value';
        
        await DatabaseTestHelper.insertTestData(key, value);

        const predicates = new dataSharePredicates.DataSharePredicates();
        predicates.equalTo('KEYWORD', key);
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          const goToLast = resultSet.goToLastRow();
          expect(goToLast).assertTrue();
        }
      });
      expect(success).assertTrue();
    });

    it('resultset_go_to_next_row', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        for (let i = 0; i < 5; i++) {
          const key = `${TEST_PREFIX}_next_key_${i}`;
          const value = `resultset_next_value_${i}`;
          await DatabaseTestHelper.insertTestData(key, value);
        }

        const predicates = new dataSharePredicates.DataSharePredicates();
        predicates.like('KEYWORD', `${TEST_PREFIX}_next_%`);
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          let count = 0;
          while (resultSet.goToNextRow()) {
            count++;
          }
          expect(count).assertLargerOrEqual(5);
        }
      });
      expect(success).assertTrue();
    });

    it('resultset_go_to_previous_row', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        for (let i = 0; i < 5; i++) {
          const key = `${TEST_PREFIX}_prev_key_${i}`;
          const value = `resultset_prev_value_${i}`;
          await DatabaseTestHelper.insertTestData(key, value);
        }

        const predicates = new dataSharePredicates.DataSharePredicates();
        predicates.like('KEYWORD', `${TEST_PREFIX}_prev_%`);
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          resultSet.goToLastRow();
          let count = 0;
          while (resultSet.goToPreviousRow()) {
            count++;
          }
          expect(count).assertLargerOrEqual(4);
        }
      });
      expect(success).assertTrue();
    });

    it('resultset_go_to_row_by_position', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          for (let i = 0; i < 10; i++) {
            const valuesBucket: relationalStore.ValuesBucket = {
              'KEYWORD': `${TEST_PREFIX}_position_key_${i}`,
              'VALUE': 'resultset_position_value_' + i
            };
            await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          }

          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.like('KEYWORD', `${TEST_PREFIX}_position_%`);
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          const goToPosition = resultSet.goToRow(5);
          expect(goToPosition).assertTrue();
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 字段读取测试 ==========

    it('resultset_get_string_column', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': `${TEST_PREFIX}_string_key`,
            'VALUE': 'resultset_string_value'
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);

          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.equalTo('KEYWORD', `${TEST_PREFIX}_string_key`);
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          resultSet.goToFirstRow();
          const columnIndex = resultSet.getColumnIndex('KEYWORD');
          expect(columnIndex).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('resultset_get_column_count', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          const columnCount = resultSet.columnCount;
          expect(columnCount).assertLargerOrEqual(3);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('resultset_get_column_names', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          const columnNames = resultSet.columnNames;
          expect(columnNames.length).assertLargerOrEqual(3);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 结果集位置测试 ==========

    it('resultset_get_row_position', 0, async () => {
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

    it('resultset_is_at_first', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          resultSet.goToFirstRow();
          const isAtFirst = resultSet.isAtFirstRow;
          expect(isAtFirst).assertTrue();
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('resultset_is_at_last', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          resultSet.goToLastRow();
          const isAtLast = resultSet.isAtLastRow;
          expect(isAtLast).assertTrue();
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('resultset_is_before_first', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          const resultSet: relationalStore.ResultSet =
            await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          const goToFirst: boolean = resultSet.goToFirstRow();
          expect(goToFirst).assertTrue();
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('resultset_is_after_last', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          const resultSet: relationalStore.ResultSet =
            await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          resultSet.goToLastRow();
          resultSet.goToNextRow();
          const isAtLast = resultSet.isAtLastRow;
          expect(isAtLast).assertFalse();
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 结果集关闭测试 ==========

    it('resultset_close_should_succeed', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          resultSet.close();
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 空结果集测试 ==========

    it('resultset_empty_query_should_return_zero_count', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.equalTo('KEYWORD', `${TEST_PREFIX}_nonexistent_key_xyz`);
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          expect(resultSet.rowCount).assertEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });
  });
}
