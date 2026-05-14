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
 * @file SettingsDataRobustness.test.ets
 * @overview 测试设置数据健壮�? *           覆盖：异常输入、重复操作、并发访问、资源限�? */

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
import { dataSharePredicates, relationalStore, relationalStore as rdb } from '@kit.ArkData';

interface RobustnessIndexObj {
  index: number;
}

export default function settingsDataRobustnessTest() {
  describe('SettingsDataRobustness_Test', () => {
    let driver: Driver;
    const TEST_PREFIX = 'robustness_test';

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

    // ========== 异常输入测试 ==========

    it('robustness_insert_null_keyword', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': null,
            'VALUE': 'robustness_null_keyword_value'
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('robustness_insert_null_value', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': 'robustness_null_value_key',
            'VALUE': null
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('robustness_query_null_predicate', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const resultSet: relationalStore.ResultSet =
            await rdbStore.querySql('SELECT * FROM ' + settingsDataConfig.TABLE_NAME);
          expect(resultSet.rowCount).assertLargerOrEqual(0);
        }
      });
      expect(success).assertTrue();
    });

    // ========== 重复操作测试 ==========

    it('robustness_repeated_insert_same_key', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = `${TEST_PREFIX}_robustness_repeated_insert_key`;
        for (let i = 0; i < 10; i++) {
          const value = `robustness_repeated_insert_value_${i}`;
          await DatabaseTestHelper.insertTestData(key, value);
        }
      });
      expect(success).assertTrue();
    });

    it('robustness_repeated_update_same_key', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = `${TEST_PREFIX}_robustness_repeated_insert_key`;
        const value = 'robustness_repeated_insert_value_initial';
        
        await DatabaseTestHelper.insertTestData(key, value);

        for (let i = 0; i < 10; i++) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.equalTo('KEYWORD', key);
          const valuesBucket: relationalStore.ValuesBucket = {
            'VALUE': `robustness_repeated_update_value_${i}`
          };
          const helper = SettingsDBHelper.getInstance();
          const rdbStore = await helper.getRdbStore();
          if (rdbStore !== undefined) {
            await rdbStore.update(settingsDataConfig.TABLE_NAME, valuesBucket, predicates);
          }
        }
      });
      expect(success).assertTrue();
    });

    it('robustness_repeated_delete_same_key', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = `${TEST_PREFIX}_robustness_repeated_insert_key`;
        const value = 'robustness_repeated_insert_value_initial';
        
        await DatabaseTestHelper.insertTestData(key, value);

        for (let i = 0; i < 5; i++) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.equalTo('KEYWORD', key);
          const helper = SettingsDBHelper.getInstance();
          const rdbStore = await helper.getRdbStore();
          if (rdbStore !== undefined) {
            await rdbStore.delete(settingsDataConfig.TABLE_NAME, predicates);
          }
        }
      });
      expect(success).assertTrue();
    });

    // ========== 并发访问测试 ==========

    it('robustness_concurrent_insert_operations', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const promises: Promise<number>[] = [];
          for (let i = 0; i < 20; i++) {
            const valuesBucket: relationalStore.ValuesBucket = {
              'KEYWORD': 'robustness_concurrent_key_' + i,
              'VALUE': 'robustness_concurrent_value_' + i
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

    it('robustness_concurrent_query_operations', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const promises: Promise<relationalStore.ResultSet>[] = [];
          for (let i = 0; i < 10; i++) {
            const predicates = new dataSharePredicates.DataSharePredicates();
            predicates.equalTo('KEYWORD', 'robustness_concurrent_key_' + i);
            promises.push(rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []));
          }
          const results = await Promise.all(promises);
          for (const resultSet of results) {
            expect(resultSet.rowCount).assertLargerOrEqual(0);
          }
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 资源限制测试 ==========

    it('robustness_context_many_properties', 0, () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        for (let i = 0; i < 300; i++) {
          ctx.setProperty('robustness_ctx_prop_' + i, 'robustness_ctx_value_' + i);
        }
        for (let i = 0; i < 300; i++) {
          expect(ctx.getProperty('robustness_ctx_prop_' + i)).assertEqual('robustness_ctx_value_' + i);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('robustness_context_many_objects', 0, () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        for (let i = 0; i < 300; i++) {
          const indexObj: RobustnessIndexObj = { index: i };
          ctx.setObject('robustness_ctx_obj_' + i, indexObj);
        }
        for (let i = 0; i < 300; i++) {
          expect(ctx.getObject('robustness_ctx_obj_' + i) !== undefined).assertTrue();
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });
  });
}
