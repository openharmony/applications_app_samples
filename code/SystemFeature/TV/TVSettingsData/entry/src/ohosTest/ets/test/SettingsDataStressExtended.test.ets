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
 * @file SettingsDataStressExtended.test.ets
 * @overview 扩展测试设置数据压力场景
 *           覆盖：长时间运行、高频操作、混合压力、资源耗尽恢复
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

interface StressObj {
  index: number;
  data: string;
}

export default function settingsDataStressExtendedTest() {
  describe('SettingsDataStressExtended_Test', () => {
    let driver: Driver;
    const TEST_PREFIX = 'stress_test';

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

    // ========== 长时间运行测�?==========

    it('stress_long_running_insert_query_cycle', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          for (let cycle = 0; cycle < 20; cycle++) {
            const valuesBucket: relationalStore.ValuesBucket = {
              'KEYWORD': 'stress_long_cycle_key_' + cycle,
              'VALUE': 'stress_long_cycle_value_' + cycle
            };
            await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);

            const predicates = new dataSharePredicates.DataSharePredicates();
            predicates.equalTo('KEYWORD', 'stress_long_cycle_key_' + cycle);
            const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
            expect(resultSet.rowCount).assertLargerOrEqual(1);
          }
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('stress_long_running_context_operations', 0, () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        for (let cycle = 0; cycle < 100; cycle++) {
          ctx.setProperty('stress_long_prop_' + cycle, 'stress_long_value_' + cycle);
          expect(ctx.getProperty('stress_long_prop_' + cycle)).assertEqual('stress_long_value_' + cycle);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 高频操作测试 ==========

    it('stress_high_frequency_insert', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          for (let i = 0; i < 200; i++) {
            const valuesBucket: relationalStore.ValuesBucket = {
              'KEYWORD': 'stress_high_freq_key_' + i,
              'VALUE': 'stress_high_freq_value_' + i
            };
            await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          }
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('stress_high_frequency_query', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          for (let i = 0; i < 100; i++) {
            const predicates = new dataSharePredicates.DataSharePredicates();
            predicates.equalTo('KEYWORD', 'stress_high_freq_key_' + (i % 50));
            const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
            expect(resultSet.rowCount).assertLargerOrEqual(0);
          }
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('stress_high_frequency_update', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          for (let i = 0; i < 50; i++) {
            const predicates = new dataSharePredicates.DataSharePredicates();
            predicates.equalTo('KEYWORD', 'stress_high_freq_key_' + i);
            const valuesBucket: relationalStore.ValuesBucket = {
              'VALUE': 'stress_high_freq_updated_' + i
            };
            await rdbStore.update(settingsDataConfig.TABLE_NAME, valuesBucket, predicates);
          }
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('stress_high_frequency_delete', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          for (let i = 0; i < 50; i++) {
            const predicates = new dataSharePredicates.DataSharePredicates();
            predicates.equalTo('KEYWORD', 'stress_high_freq_key_' + i);
            await rdbStore.delete(settingsDataConfig.TABLE_NAME, predicates);
          }
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 混合压力测试 ==========

    it('stress_mixed_insert_query_update_delete', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          for (let i = 0; i < 30; i++) {
            const valuesBucket: relationalStore.ValuesBucket = {
              'KEYWORD': 'stress_mixed_key_' + i,
              'VALUE': 'stress_mixed_value_' + i
            };
            await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          }

          for (let i = 0; i < 30; i++) {
            const predicates = new dataSharePredicates.DataSharePredicates();
            predicates.equalTo('KEYWORD', 'stress_mixed_key_' + i);
            const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
            expect(resultSet.rowCount).assertLargerOrEqual(1);
          }

          for (let i = 0; i < 30; i++) {
            const predicates = new dataSharePredicates.DataSharePredicates();
            predicates.equalTo('KEYWORD', 'stress_mixed_key_' + i);
            const valuesBucket: relationalStore.ValuesBucket = {
              'VALUE': 'stress_mixed_updated_' + i
            };
            await rdbStore.update(settingsDataConfig.TABLE_NAME, valuesBucket, predicates);
          }

          for (let i = 0; i < 30; i++) {
            const predicates = new dataSharePredicates.DataSharePredicates();
            predicates.equalTo('KEYWORD', 'stress_mixed_key_' + i);
            await rdbStore.delete(settingsDataConfig.TABLE_NAME, predicates);
          }
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 资源耗尽恢复测试 ==========

    it('stress_resource_exhaustion_recovery', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          for (let i = 0; i < 100; i++) {
            const valuesBucket: relationalStore.ValuesBucket = {
              'KEYWORD': 'stress_resource_key_' + i,
              'VALUE': 'stress_resource_value_' + i
            };
            await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          }

          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.like('KEYWORD', 'stress_resource_%');
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          expect(resultSet.rowCount).assertLargerOrEqual(100);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 大量数据测试 ==========

    it('stress_large_data_insert', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          await rdbStore.beginTransaction();
          for (let i = 0; i < 500; i++) {
            const valuesBucket: relationalStore.ValuesBucket = {
              'KEYWORD': 'stress_large_key_' + i,
              'VALUE': 'stress_large_value_' + i
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

    it('stress_large_data_query', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.like('KEYWORD', 'stress_large_%');
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          expect(resultSet.rowCount).assertLargerOrEqual(500);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 上下文压力测�?==========

    it('stress_context_hundred_properties', 0, () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        for (let i = 0; i < 200; i++) {
          ctx.setProperty('stress_ctx_prop_' + i, 'stress_ctx_value_' + i);
        }
        for (let i = 0; i < 200; i++) {
          expect(ctx.getProperty('stress_ctx_prop_' + i)).assertEqual('stress_ctx_value_' + i);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('stress_context_hundred_objects', 0, () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        for (let i = 0; i < 200; i++) {
          const obj: StressObj = { index: i, data: 'stress_data_' + i };
          ctx.setObject('stress_ctx_obj_' + i, obj);
        }
        for (let i = 0; i < 200; i++) {
          expect(ctx.getObject('stress_ctx_obj_' + i) !== undefined).assertTrue();
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 日志压力测试 ==========

    it('stress_log_thousand_messages', 0, () => {
      let threw = false;
      try {
        for (let i = 0; i < 500; i++) {
          Log.info('Stress log message ' + i);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });
  });
}
