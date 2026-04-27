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
 * @file SettingsDataPerformance.test.ets
 * @overview 测试设置数据性能指标
 *           覆盖：查询性能、插入性能、更新性能、删除性能、内存占�? */

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

interface PerfMemoryObj {
  index: number;
}

export default function settingsDataPerformanceTest() {
  describe('SettingsDataPerformance_Test', () => {
    let driver: Driver;
    const TEST_PREFIX = 'performance_test';

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

    // ========== 查询性能测试 ==========

    it('performance_query_single_record_time', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = `${TEST_PREFIX}_query_single_key`;
        const value = 'perf_query_single_value';
        
        await DatabaseTestHelper.insertTestData(key, value);

        const startTime = new Date().getTime();
        const resultSet = await DatabaseTestHelper.queryTestData(key);
        const endTime = new Date().getTime();
        const queryTime = endTime - startTime;
        
        expect(queryTime).assertLess(1000);
        expect(resultSet.rowCount).assertLargerOrEqual(1);
      });
      expect(success).assertTrue();
    });

    it('performance_query_multiple_records_time', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        for (let i = 0; i < 50; i++) {
          const key = `${TEST_PREFIX}_query_multi_key_${i}`;
          const value = `perf_query_multi_value_${i}`;
          await DatabaseTestHelper.insertTestData(key, value);
        }

        const startTime = new Date().getTime();
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.like('KEYWORD', `${TEST_PREFIX}_query_multi_%`);
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          const endTime = new Date().getTime();
          const queryTime = endTime - startTime;
          
          expect(queryTime).assertLess(2000);
          expect(resultSet.rowCount).assertLargerOrEqual(50);
        }
      });
      expect(success).assertTrue();
    });

    it('performance_query_with_order_by_time', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const startTime = new Date().getTime();
          const resultSet: relationalStore.ResultSet =
            await rdbStore.querySql('SELECT * FROM ' + settingsDataConfig.TABLE_NAME + ' ORDER BY ID ASC');
          const endTime = new Date().getTime();
          const queryTime = endTime - startTime;
          expect(queryTime).assertLess(1000);
          expect(resultSet.rowCount).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('performance_query_with_limit_time', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const startTime = new Date().getTime();
          const resultSet: relationalStore.ResultSet =
            await rdbStore.querySql('SELECT * FROM ' + settingsDataConfig.TABLE_NAME + ' ORDER BY ID ASC LIMIT 10');
          const endTime = new Date().getTime();
          const queryTime = endTime - startTime;
          expect(queryTime).assertLess(500);
          expect(resultSet.rowCount).assertLessOrEqual(10);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 插入性能测试 ==========

    it('performance_insert_single_record_time', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = `${TEST_PREFIX}_insert_single_key`;
        const value = 'perf_insert_single_value';
        
        const startTime = new Date().getTime();
        const ret = await DatabaseTestHelper.insertTestData(key, value);
        const endTime = new Date().getTime();
        const insertTime = endTime - startTime;
        
        expect(insertTime).assertLess(1000);
        expect(ret).assertLargerOrEqual(0);
      });
      expect(success).assertTrue();
    });

    it('performance_insert_hundred_records_time', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const startTime = new Date().getTime();
        for (let i = 0; i < 100; i++) {
          const key = `${TEST_PREFIX}_insert_hundred_key_${i}`;
          const value = `perf_insert_hundred_value_${i}`;
          await DatabaseTestHelper.insertTestData(key, value);
        }
        const endTime = new Date().getTime();
        const insertTime = endTime - startTime;
        expect(insertTime).assertLess(5000);
      });
      expect(success).assertTrue();
    });

    it('performance_insert_in_transaction_time', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          await rdbStore.beginTransaction();
          const startTime = new Date().getTime();
          for (let i = 0; i < 50; i++) {
            const key = `${TEST_PREFIX}_insert_txn_key_${i}`;
            const value = `perf_insert_txn_value_${i}`;
            const valuesBucket: relationalStore.ValuesBucket = {
              'KEYWORD': key,
              'VALUE': value
            };
            await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          }
          await rdbStore.commit();
          const endTime = new Date().getTime();
          const insertTime = endTime - startTime;
          expect(insertTime).assertLess(3000);
        }
      });
      expect(success).assertTrue();
    });

    // ========== 更新性能测试 ==========

    it('performance_update_single_record_time', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': 'perf_update_single_key',
            'VALUE': 'perf_update_single_value'
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);

          const startTime = new Date().getTime();
          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.equalTo('KEYWORD', 'perf_update_single_key');
          const updateBucket: relationalStore.ValuesBucket = {
            'VALUE': 'perf_update_single_new_value'
          };
          await rdbStore.update(settingsDataConfig.TABLE_NAME, updateBucket, predicates);
          const endTime = new Date().getTime();
          const updateTime = endTime - startTime;
          expect(updateTime).assertLess(1000);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('performance_update_multiple_records_time', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          for (let i = 0; i < 20; i++) {
            const valuesBucket: relationalStore.ValuesBucket = {
              'KEYWORD': 'perf_update_multi_key_' + i,
              'VALUE': 'perf_update_multi_value_' + i
            };
            await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          }

          const startTime = new Date().getTime();
          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.like('KEYWORD', 'perf_update_multi_%');
          const updateBucket: relationalStore.ValuesBucket = {
            'VALUE': 'perf_update_multi_new_value'
          };
          await rdbStore.update(settingsDataConfig.TABLE_NAME, updateBucket, predicates);
          const endTime = new Date().getTime();
          const updateTime = endTime - startTime;
          expect(updateTime).assertLess(2000);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 删除性能测试 ==========

    it('performance_delete_single_record_time', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': 'perf_delete_single_key',
            'VALUE': 'perf_delete_single_value'
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);

          const startTime = new Date().getTime();
          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.equalTo('KEYWORD', 'perf_delete_single_key');
          await rdbStore.delete(settingsDataConfig.TABLE_NAME, predicates);
          const endTime = new Date().getTime();
          const deleteTime = endTime - startTime;
          expect(deleteTime).assertLess(1000);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('performance_delete_multiple_records_time', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          for (let i = 0; i < 20; i++) {
            const valuesBucket: relationalStore.ValuesBucket = {
              'KEYWORD': 'perf_delete_multi_key_' + i,
              'VALUE': 'perf_delete_multi_value_' + i
            };
            await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          }

          const startTime = new Date().getTime();
          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.like('KEYWORD', 'perf_delete_multi_%');
          await rdbStore.delete(settingsDataConfig.TABLE_NAME, predicates);
          const endTime = new Date().getTime();
          const deleteTime = endTime - startTime;
          expect(deleteTime).assertLess(2000);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 内存占用测试 ==========

    it('performance_memory_context_operations', 0, () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        for (let i = 0; i < 100; i++) {
          ctx.setProperty('perf_memory_prop_' + i, 'perf_memory_value_' + i);
        }
        for (let i = 0; i < 100; i++) {
          expect(ctx.getProperty('perf_memory_prop_' + i)).assertEqual('perf_memory_value_' + i);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('performance_memory_object_operations', 0, () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        for (let i = 0; i < 100; i++) {
          const obj: PerfMemoryObj = { index: i };
          ctx.setObject('perf_memory_obj_' + i, obj);
        }
        for (let i = 0; i < 100; i++) {
          expect(ctx.getObject('perf_memory_obj_' + i) !== undefined).assertTrue();
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 日志性能测试 ==========

    it('performance_log_hundred_messages', 0, () => {
      let threw = false;
      try {
        const startTime = new Date().getTime();
        for (let i = 0; i < 100; i++) {
          Log.info('Performance log message ' + i);
        }
        const endTime = new Date().getTime();
        const logTime = endTime - startTime;
        expect(logTime).assertLess(2000);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 综合性能测试 ==========

    it('performance_mixed_operations_time', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const startTime = new Date().getTime();

          for (let i = 0; i < 20; i++) {
            const valuesBucket: relationalStore.ValuesBucket = {
              'KEYWORD': 'perf_mixed_key_' + i,
              'VALUE': 'perf_mixed_value_' + i
            };
            await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          }

          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.like('KEYWORD', 'perf_mixed_%');
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          expect(resultSet.rowCount).assertLargerOrEqual(20);

          const endTime = new Date().getTime();
          const mixedTime = endTime - startTime;
          expect(mixedTime).assertLess(3000);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });
  });
}
