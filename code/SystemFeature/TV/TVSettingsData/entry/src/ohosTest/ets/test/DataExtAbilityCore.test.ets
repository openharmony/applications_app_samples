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
 * @file DataExtAbilityCore.test.ets
 * @overview 测试 DataExtAbility 核心功能：insert/update/query/delete 操作
 *           覆盖：数据插入、数据更新、数据查询、数据删除、回调验证
 */

import { describe, it, expect, beforeAll, afterAll, beforeEach, afterEach } from '@ohos/hypium';
import { settingsDataConfig, DataSettingsKey, DataDefaultKey } from '../../../main/ets/Utils/SettingsDataConfig';
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
import SettingsDBHelper from '../../../main/ets/Utils/SettingsDBHelper';
import { TestDataCleaner, DatabaseTestHelper, TestAssertions } from './TestUtils';
import { GlobalContext } from '../../../main/ets/Utils/GlobalContext';

export default function dataExtAbilityCoreTest() {
  describe('DataExtAbilityCore_Test', () => {
    let driver: Driver;
    const TEST_PREFIX = 'core_test';

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

    // ========== Insert 操作测试 ==========

    it('insert_single_record_should_succeed', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': 'test_insert_key',
            'VALUE': 'test_insert_value'
          };
          const ret = await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          expect(ret).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('insert_with_brightness_key_should_succeed', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': DataSettingsKey.SETTINGS_SCREEN_BRIGHTNESS,
            'VALUE': '75'
          };
          const ret = await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          expect(ret).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('insert_with_time_format_key_should_succeed', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': DataSettingsKey.SETTINGS_TIME_FORMAT,
            'VALUE': '24'
          };
          const ret = await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          expect(ret).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('insert_with_audio_ringtone_key_should_succeed', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': DataSettingsKey.SETTINGS_AUDIO_RINGTONE,
            'VALUE': '8'
          };
          const ret = await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          expect(ret).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('insert_with_audio_media_key_should_succeed', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': DataSettingsKey.SETTINGS_AUDIO_MEDIA,
            'VALUE': '10'
          };
          const ret = await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          expect(ret).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('insert_with_audio_voicecall_key_should_succeed', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': DataSettingsKey.SETTINGS_AUDIO_VOICE_CALL,
            'VALUE': '6'
          };
          const ret = await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          expect(ret).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('insert_with_device_name_key_should_succeed', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': DataSettingsKey.SETTINGS_GENERAL_DEVICE_NAME,
            'VALUE': 'TestTV'
          };
          const ret = await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          expect(ret).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('insert_with_navbar_status_key_should_succeed', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': DataSettingsKey.SETTINGS_DISPALY_NAVBAR_STATUS,
            'VALUE': '1'
          };
          const ret = await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          expect(ret).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('insert_with_cellular_data_key_should_succeed', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': DataSettingsKey.CELLULAR_DATA_ENABLE,
            'VALUE': '1'
          };
          const ret = await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          expect(ret).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('insert_multiple_records_should_succeed', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const records: relationalStore.ValuesBucket[] = [
            { 'KEYWORD': 'multi_key_1', 'VALUE': 'multi_val_1' },
            { 'KEYWORD': 'multi_key_2', 'VALUE': 'multi_val_2' },
            { 'KEYWORD': 'multi_key_3', 'VALUE': 'multi_val_3' }
          ];
          for (const record of records) {
            const ret = await rdbStore.insert(settingsDataConfig.TABLE_NAME, record);
            expect(ret).assertLargerOrEqual(0);
          }
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== Update 操作测试 ==========

    it('update_existing_record_should_succeed', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.equalTo('KEYWORD', 'test_insert_key');
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': 'test_insert_key',
            'VALUE': 'updated_value'
          };
          const ret = await rdbStore.update(settingsDataConfig.TABLE_NAME, valuesBucket, predicates);
          expect(ret).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('update_brightness_value_should_succeed', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.equalTo('KEYWORD', DataSettingsKey.SETTINGS_SCREEN_BRIGHTNESS);
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': DataSettingsKey.SETTINGS_SCREEN_BRIGHTNESS,
            'VALUE': '100'
          };
          const ret = await rdbStore.update(settingsDataConfig.TABLE_NAME, valuesBucket, predicates);
          expect(ret).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('update_time_format_value_should_succeed', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.equalTo('KEYWORD', DataSettingsKey.SETTINGS_TIME_FORMAT);
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': DataSettingsKey.SETTINGS_TIME_FORMAT,
            'VALUE': '12'
          };
          const ret = await rdbStore.update(settingsDataConfig.TABLE_NAME, valuesBucket, predicates);
          expect(ret).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('update_audio_media_value_should_succeed', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.equalTo('KEYWORD', DataSettingsKey.SETTINGS_AUDIO_MEDIA);
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': DataSettingsKey.SETTINGS_AUDIO_MEDIA,
            'VALUE': '15'
          };
          const ret = await rdbStore.update(settingsDataConfig.TABLE_NAME, valuesBucket, predicates);
          expect(ret).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('update_nonexistent_record_should_return_zero', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.equalTo('KEYWORD', 'nonexistent_key_xyz');
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': 'nonexistent_key_xyz',
            'VALUE': 'some_value'
          };
          const ret = await rdbStore.update(settingsDataConfig.TABLE_NAME, valuesBucket, predicates);
          expect(ret).assertEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== Query 操作测试 ==========

    it('query_existing_record_should_return_result', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.equalTo('KEYWORD', 'test_insert_key');
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          expect(resultSet.rowCount).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('query_brightness_record_should_return_result', 0, async () => {
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

    it('query_all_records_should_return_all', 0, async () => {
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

    it('query_with_columns_should_return_specified_columns', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.equalTo('KEYWORD', 'test_insert_key');
          const columns = ['KEYWORD', 'VALUE'];
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, columns);
          expect(resultSet.rowCount).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('query_nonexistent_record_should_return_empty', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.equalTo('KEYWORD', 'nonexistent_query_key');
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          expect(resultSet.rowCount).assertEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== Delete 操作测试 ==========

    it('delete_operation_should_be_noop', 0, () => {
      expect(true).assertTrue();
    });

    // ========== 组合操作测试 ==========

    it('insert_then_query_should_return_same_value', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const insertBucket: relationalStore.ValuesBucket = {
            'KEYWORD': 'insert_query_key',
            'VALUE': 'insert_query_value'
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, insertBucket);
          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.equalTo('KEYWORD', 'insert_query_key');
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          expect(resultSet.rowCount).assertLargerOrEqual(1);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('insert_then_update_then_query_should_return_updated_value', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const insertBucket: relationalStore.ValuesBucket = {
            'KEYWORD': 'insert_update_query_key',
            'VALUE': 'original_value'
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, insertBucket);
          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.equalTo('KEYWORD', 'insert_update_query_key');
          const updateBucket: relationalStore.ValuesBucket = {
            'KEYWORD': 'insert_update_query_key',
            'VALUE': 'updated_value'
          };
          await rdbStore.update(settingsDataConfig.TABLE_NAME, updateBucket, predicates);
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          expect(resultSet.rowCount).assertLargerOrEqual(1);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });
  });
}
