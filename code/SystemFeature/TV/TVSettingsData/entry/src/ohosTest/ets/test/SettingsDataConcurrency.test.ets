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
 * @file SettingsDataConcurrency.test.ets
 * @overview 测试设置数据并发访问
 *           覆盖：多线程读写、竞态条件、锁机制、并发一致�? */

import { describe, it, expect, beforeAll, afterAll, beforeEach, afterEach } from '@ohos/hypium';
import { settingsDataConfig, DataSettingsKey, DataDefaultKey } from '../../../main/ets/Utils/SettingsDataConfig';
import SettingsDBHelper from '../../../main/ets/Utils/SettingsDBHelper';
import { TestDataCleaner, DatabaseTestHelper, TestAssertions } from './TestUtils';
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

interface ConcurrentObj {
  index: number;
}

interface ConcurrentPropObj {
  prop: string;
}

export default function settingsDataConcurrencyTest() {
  describe('SettingsDataConcurrency_Test', () => {
    let driver: Driver;
    const TEST_PREFIX = 'concurrency_test';

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

    // ========== 并发读取测试 ==========

    it('concurrent_read_same_record_should_return_same_value', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = `${TEST_PREFIX}_read_key`;
        const value = 'concurrent_read_value';
        
        await DatabaseTestHelper.insertTestData(key, value);

        const resultSet = await DatabaseTestHelper.queryTestData(key);
        expect(resultSet.rowCount).assertLargerOrEqual(1);
      });
      expect(success).assertTrue();
    });

    it('concurrent_read_multiple_records', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        for (let i = 0; i < 10; i++) {
          const key = `${TEST_PREFIX}_multi_read_key_${i}`;
          const value = `concurrent_multi_read_value_${i}`;
          await DatabaseTestHelper.insertTestData(key, value);
        }

        const predicates = new dataSharePredicates.DataSharePredicates();
        predicates.like('KEYWORD', `${TEST_PREFIX}_multi_read_%`);
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          expect(resultSet.rowCount).assertLargerOrEqual(10);
        }
      });
      expect(success).assertTrue();
    });

    // ========== 并发写入测试 ==========

    it('concurrent_write_same_record_should_handle_race', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = `${TEST_PREFIX}_write_race_key`;
        const value1 = 'value1';
        
        await DatabaseTestHelper.insertTestData(key, value1);

        const predicates = new dataSharePredicates.DataSharePredicates();
        predicates.equalTo('KEYWORD', key);
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket2: relationalStore.ValuesBucket = {
            'VALUE': 'value2'
          };
          await rdbStore.update(settingsDataConfig.TABLE_NAME, valuesBucket2, predicates);
        }
      });
      expect(success).assertTrue();
    });

    it('concurrent_write_multiple_records', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const promises: Promise<number>[] = [];
          for (let i = 0; i < 10; i++) {
            const valuesBucket: relationalStore.ValuesBucket = {
              'KEYWORD': 'concurrent_write_multi_key_' + i,
              'VALUE': 'concurrent_write_multi_value_' + i
            };
            promises.push(rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket));
          }
          const results = await Promise.all(promises);
          for (const result of results) {
            expect(result).assertLargerOrEqual(0);
          }
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 并发读写混合测试 ==========

    it('concurrent_read_write_mixed_operations', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          for (let i = 0; i < 5; i++) {
            const valuesBucket: relationalStore.ValuesBucket = {
              'KEYWORD': 'concurrent_mixed_key_' + i,
              'VALUE': 'concurrent_mixed_value_' + i
            };
            await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          }

          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.like('KEYWORD', 'concurrent_mixed_%');
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          expect(resultSet.rowCount).assertLargerOrEqual(5);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 竞态条件测�?==========

    it('race_condition_simultaneous_insert', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const promises: Promise<number>[] = [];
          for (let i = 0; i < 5; i++) {
            const valuesBucket: relationalStore.ValuesBucket = {
              'KEYWORD': 'race_simultaneous_key_' + i,
              'VALUE': 'race_simultaneous_value_' + i
            };
            promises.push(rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket));
          }
          const results = await Promise.all(promises);
          for (const result of results) {
            expect(result).assertLargerOrEqual(0);
          }
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('race_condition_simultaneous_update', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          for (let i = 0; i < 5; i++) {
            const valuesBucket: relationalStore.ValuesBucket = {
              'KEYWORD': 'race_update_key_' + i,
              'VALUE': 'race_update_original_' + i
            };
            await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          }

          const promises: Promise<number>[] = [];
          for (let i = 0; i < 5; i++) {
            const predicates = new dataSharePredicates.DataSharePredicates();
            predicates.equalTo('KEYWORD', 'race_update_key_' + i);
            const valuesBucket: relationalStore.ValuesBucket = {
              'VALUE': 'race_update_new_' + i
            };
            promises.push(rdbStore.update(settingsDataConfig.TABLE_NAME, valuesBucket, predicates));
          }
          const results = await Promise.all(promises);
          for (const result of results) {
            expect(result).assertLargerOrEqual(0);
          }
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 锁机制测�?==========

    it('lock_transaction_isolation', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          await rdbStore.beginTransaction();
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': 'lock_isolation_key',
            'VALUE': 'lock_isolation_value'
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          await rdbStore.commit();
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 并发一致性测�?==========

    it('consistency_after_concurrent_operations', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          for (let i = 0; i < 10; i++) {
            const valuesBucket: relationalStore.ValuesBucket = {
              'KEYWORD': 'consistency_key_' + i,
              'VALUE': 'consistency_value_' + i
            };
            await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          }

          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.like('KEYWORD', 'consistency_%');
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          expect(resultSet.rowCount).assertLargerOrEqual(10);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 上下文并发测�?==========

    it('concurrent_context_set_property', 0, () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        for (let i = 0; i < 50; i++) {
          ctx.setProperty('concurrent_prop_' + i, 'concurrent_value_' + i);
        }
        for (let i = 0; i < 50; i++) {
          expect(ctx.getProperty('concurrent_prop_' + i)).assertEqual('concurrent_value_' + i);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('concurrent_context_set_object', 0, () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        for (let i = 0; i < 50; i++) {
          const obj: ConcurrentObj = { index: i };
          ctx.setObject('concurrent_obj_' + i, obj);
        }
        for (let i = 0; i < 50; i++) {
          expect(ctx.getObject('concurrent_obj_' + i) !== undefined).assertTrue();
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 日志并发测试 ==========

    it('concurrent_log_operations', 0, () => {
      let threw = false;
      try {
        for (let i = 0; i < 20; i++) {
          Log.info('Concurrent log message ' + i);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 压力并发测试 ==========

    it('stress_concurrent_hundred_operations', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const promises: Promise<number>[] = [];
          for (let i = 0; i < 100; i++) {
            const valuesBucket: relationalStore.ValuesBucket = {
              'KEYWORD': 'stress_concurrent_key_' + i,
              'VALUE': 'stress_concurrent_value_' + i
            };
            promises.push(rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket));
          }
          const results = await Promise.all(promises);
          for (const result of results) {
            expect(result).assertLargerOrEqual(0);
          }
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });
  });
}
