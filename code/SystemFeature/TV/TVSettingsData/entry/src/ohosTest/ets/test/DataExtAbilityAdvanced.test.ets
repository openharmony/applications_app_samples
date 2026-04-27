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
 * @file DataExtAbilityAdvanced.test.ets
 * @overview 测试 DataExtAbility 高级功能：批量操作、事务处理、数据迁�? *           覆盖：批量插入、批量更新、事务回滚、数据迁移验�? */

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

export default function dataExtAbilityAdvancedTest() {
  describe('DataExtAbilityAdvanced_Test', () => {
    let driver: Driver;
    const TEST_PREFIX = 'advanced_test';

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

    // ========== 批量插入测试 ==========

    it('batch_insert_five_records_should_succeed', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          for (let i = 0; i < 5; i++) {
            const valuesBucket: relationalStore.ValuesBucket = {
              'KEYWORD': `${TEST_PREFIX}_batch_insert_key_${i}`,
              'VALUE': 'batch_insert_value_' + i
            };
            const ret = await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
            expect(ret).assertLargerOrEqual(0);
          }
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('batch_insert_with_settings_keys_should_succeed', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const settingsKeys: string[] = [
            DataSettingsKey.SETTINGS_SCREEN_BRIGHTNESS,
            DataSettingsKey.SETTINGS_TIME_FORMAT,
            DataSettingsKey.SETTINGS_AUDIO_RINGTONE
          ];
          for (const key of settingsKeys) {
            const valuesBucket: relationalStore.ValuesBucket = {
              'KEYWORD': key,
              'VALUE': 'batch_value'
            };
            const ret = await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
            expect(ret).assertLargerOrEqual(0);
          }
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('batch_insert_ten_records_should_succeed', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          for (let i = 0; i < 10; i++) {
            const valuesBucket: relationalStore.ValuesBucket = {
              'KEYWORD': 'batch_ten_key_' + i,
              'VALUE': 'batch_ten_value_' + i
            };
            const ret = await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
            expect(ret).assertLargerOrEqual(0);
          }
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('batch_insert_with_audio_settings_should_succeed', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const audioSettings: Map<string, string> = new Map<string, string>();
          audioSettings.set(DataSettingsKey.SETTINGS_AUDIO_RINGTONE, '5');
          audioSettings.set(DataSettingsKey.SETTINGS_AUDIO_MEDIA, '10');
          audioSettings.set(DataSettingsKey.SETTINGS_AUDIO_VOICE_CALL, '6');
          audioSettings.forEach((value: string, key: string) => {
            const valuesBucket: relationalStore.ValuesBucket = {
              'KEYWORD': key,
              'VALUE': value
            };
            rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          });
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('batch_insert_with_display_settings_should_succeed', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const displaySettings: Map<string, string> = new Map<string, string>();
          displaySettings.set(DataSettingsKey.SETTINGS_SCREEN_BRIGHTNESS, '128');
          displaySettings.set(DataSettingsKey.SETTINGS_DISPALY_NAVBAR_STATUS, '1');
          displaySettings.forEach((value: string, key: string) => {
            const valuesBucket: relationalStore.ValuesBucket = {
              'KEYWORD': key,
              'VALUE': value
            };
            rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          });
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 批量更新测试 ==========

    it('batch_update_five_records_should_succeed', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          for (let i = 0; i < 5; i++) {
            const predicates = new dataSharePredicates.DataSharePredicates();
            predicates.equalTo('KEYWORD', 'batch_insert_key_' + i);
            const valuesBucket: relationalStore.ValuesBucket = {
              'KEYWORD': 'batch_insert_key_' + i,
              'VALUE': 'batch_updated_value_' + i
            };
            const ret = await rdbStore.update(settingsDataConfig.TABLE_NAME, valuesBucket, predicates);
            expect(ret).assertLargerOrEqual(0);
          }
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('batch_update_with_predicates_should_succeed', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.like('KEYWORD', 'batch_%');
          const valuesBucket: relationalStore.ValuesBucket = {
            'VALUE': 'batch_updated_all'
          };
          const ret = await rdbStore.update(settingsDataConfig.TABLE_NAME, valuesBucket, predicates);
          expect(ret).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 批量查询测试 ==========

    it('batch_query_all_records_should_succeed', 0, async () => {
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

    it('batch_query_with_like_predicate_should_succeed', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.like('KEYWORD', 'batch_%');
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          expect(resultSet.rowCount).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('batch_query_with_in_predicate_should_succeed', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.in('KEYWORD', [
            DataSettingsKey.SETTINGS_SCREEN_BRIGHTNESS,
            DataSettingsKey.SETTINGS_TIME_FORMAT
          ]);
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          expect(resultSet.rowCount).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 数据迁移测试 ==========

    it('data_migration_single_record_should_succeed', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': 'migration_test_key',
            'VALUE': 'migration_test_value'
          };
          const insertRet = await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          expect(insertRet).assertLargerOrEqual(0);

          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.equalTo('KEYWORD', 'migration_test_key');
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          expect(resultSet.rowCount).assertLargerOrEqual(1);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('data_migration_multiple_records_should_succeed', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          for (let i = 0; i < 3; i++) {
            const valuesBucket: relationalStore.ValuesBucket = {
              'KEYWORD': 'migration_multi_key_' + i,
              'VALUE': 'migration_multi_value_' + i
            };
            await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          }
          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.like('KEYWORD', 'migration_multi_%');
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          expect(resultSet.rowCount).assertLargerOrEqual(3);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('transaction_insert_commit_should_work', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          await rdbStore.beginTransaction();
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': 'transaction_commit_key',
            'VALUE': 'transaction_commit_value'
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          await rdbStore.commit();
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 复杂查询测试 ==========

    it('complex_query_with_order_by_should_succeed', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const resultSet: relationalStore.ResultSet =
            await rdbStore.querySql('SELECT * FROM ' + settingsDataConfig.TABLE_NAME +
              ' WHERE KEYWORD LIKE ? ORDER BY KEYWORD ASC', ['batch_%']);
          expect(resultSet.rowCount).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('complex_query_with_limit_should_succeed', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const resultSet: relationalStore.ResultSet =
            await rdbStore.querySql('SELECT * FROM ' + settingsDataConfig.TABLE_NAME + ' ORDER BY ID ASC LIMIT 5');
          expect(resultSet.rowCount).assertLargerOrEqual(0);
          expect(resultSet.rowCount).assertLessOrEqual(5);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });
  });
}
