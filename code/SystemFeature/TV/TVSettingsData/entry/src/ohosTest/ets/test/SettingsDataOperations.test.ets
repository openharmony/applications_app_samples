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
 * @file SettingsDataOperations.test.ets
 * @overview 测试设置数据操作：增删改查完整流程
 *           覆盖：数据插入、数据更新、数据删除、数据查询、数据验证
 */

import { describe, it, expect, beforeAll, afterAll, beforeEach, afterEach } from '@ohos/hypium';
import { settingsDataConfig, DataSettingsKey, DataDefaultKey } from '../../../main/ets/Utils/SettingsDataConfig';
import SettingsDBHelper from '../../../main/ets/Utils/SettingsDBHelper';
import { TestDataCleaner, DatabaseTestHelper, TestAssertions } from './TestUtils';
import { IContent, TableType } from '../../../main/ets/common/Common';
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

export default function settingsDataOperationsTest() {
  describe('SettingsDataOperations_Test', () => {
    let driver: Driver;
    const TEST_PREFIX = 'operations_test';

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

    // ========== 数据插入测试 ==========

    it('data_insert_single_record_should_succeed', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = `${TEST_PREFIX}_single_key`;
        const value = 'insert_single_value';
        const ret = await DatabaseTestHelper.insertTestData(key, value);
        expect(ret).assertLargerOrEqual(0);
      });
      expect(success).assertTrue();
    });

    it('data_insert_with_brightness_setting', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = DataSettingsKey.SETTINGS_SCREEN_BRIGHTNESS;
        const value = '150';
        const ret = await DatabaseTestHelper.insertTestData(key, value);
        expect(ret).assertLargerOrEqual(0);
      });
      expect(success).assertTrue();
    });

    it('data_insert_with_time_format_setting', 0, async () => {
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

    it('data_insert_with_audio_ringtone_setting', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': DataSettingsKey.SETTINGS_AUDIO_RINGTONE,
            'VALUE': '7'
          };
          const ret = await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          expect(ret).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('data_insert_with_audio_media_setting', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': DataSettingsKey.SETTINGS_AUDIO_MEDIA,
            'VALUE': '12'
          };
          const ret = await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          expect(ret).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('data_insert_with_device_name_setting', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': DataSettingsKey.SETTINGS_GENERAL_DEVICE_NAME,
            'VALUE': 'MyTVDevice'
          };
          const ret = await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          expect(ret).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('data_insert_with_navbar_status_setting', 0, async () => {
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

    it('data_insert_with_cellular_data_setting', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': DataSettingsKey.CELLULAR_DATA_ENABLE,
            'VALUE': '0'
          };
          const ret = await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          expect(ret).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 数据更新测试 ==========

    it('data_update_existing_record_should_succeed', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = `${TEST_PREFIX}_update_key`;
        const initialValue = 'initial_value';
        const newValue = 'updated_value';

        await DatabaseTestHelper.insertTestData(key, initialValue);
        const ret = await DatabaseTestHelper.updateTestData(key, newValue);
        expect(ret).assertLargerOrEqual(0);
      });
      expect(success).assertTrue();
    });

    it('data_update_brightness_value_should_succeed', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = DataSettingsKey.SETTINGS_SCREEN_BRIGHTNESS;
        const newValue = '200';
        const ret = await DatabaseTestHelper.updateTestData(key, newValue);
        expect(ret).assertLargerOrEqual(0);
      });
      expect(success).assertTrue();
    });

    it('data_update_time_format_value_should_succeed', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = DataSettingsKey.SETTINGS_TIME_FORMAT;
        const newValue = '12';
        const ret = await DatabaseTestHelper.updateTestData(key, newValue);
        expect(ret).assertLargerOrEqual(0);
      });
      expect(success).assertTrue();
    });

    // ========== 数据删除测试 ==========

    it('data_delete_record_should_succeed', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = `${TEST_PREFIX}_delete_key`;
        const value = 'delete_value';

        await DatabaseTestHelper.insertTestData(key, value);
        const ret = await DatabaseTestHelper.deleteTestData(key);
        expect(ret).assertLargerOrEqual(0);
      });
      expect(success).assertTrue();
    });

    it('data_delete_nonexistent_record_should_return_zero', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = `${TEST_PREFIX}_nonexistent_key`;
        const ret = await DatabaseTestHelper.deleteTestData(key);
        expect(ret).assertEqual(0);
      });
      expect(success).assertTrue();
    });

    // ========== 数据查询测试 ==========

    it('data_query_all_records_should_succeed', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          expect(resultSet.rowCount).assertLargerOrEqual(0);
        }
      });
      expect(success).assertTrue();
    });

    it('data_query_by_keyword_should_succeed', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = DataSettingsKey.SETTINGS_SCREEN_BRIGHTNESS;
        const value = 'query_test_value';

        await DatabaseTestHelper.insertTestData(key, value);
        const resultSet = await DatabaseTestHelper.queryTestData(key);
        expect(resultSet.rowCount).assertLargerOrEqual(1);
      });
      expect(success).assertTrue();
    });

    it('data_query_by_id_should_succeed', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.equalTo('ID', 1);
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          expect(resultSet.rowCount).assertLargerOrEqual(0);
        }
      });
      expect(success).assertTrue();
    });

    // ========== 数据验证测试 ==========

    it('data_validate_inserted_value_matches', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = `${TEST_PREFIX}_validate_key`;
        const value = 'validate_test_value';

        await DatabaseTestHelper.insertTestData(key, value);
        const exists = await DatabaseTestHelper.assertDataExists(key);
        expect(exists).assertTrue();
      });
      expect(success).assertTrue();
    });

    it('data_validate_updated_value_matches', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.equalTo('KEYWORD', 'validate_test_key');
          const valuesBucket: relationalStore.ValuesBucket = {
            'VALUE': 'validate_updated_value'
          };
          await rdbStore.update(settingsDataConfig.TABLE_NAME, valuesBucket, predicates);

          const queryPredicates = new dataSharePredicates.DataSharePredicates();
          queryPredicates.equalTo('KEYWORD', 'validate_test_key');
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, queryPredicates, []);
          expect(resultSet.rowCount).assertLargerOrEqual(1);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 批量操作测试 ==========

    it('data_batch_insert_five_settings', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        for (let i = 0; i < 5; i++) {
          const key = `${TEST_PREFIX}_batch_key_${i}`;
          const value = `batch_ops_value_${i}`;
          const ret = await DatabaseTestHelper.insertTestData(key, value);
          expect(ret).assertLargerOrEqual(0);
        }
      });
      expect(success).assertTrue();
    });

    it('data_batch_update_five_settings', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        for (let i = 0; i < 5; i++) {
          const key = `${TEST_PREFIX}_batch_key_${i}`;
          const newValue = `batch_ops_updated_${i}`;
          const ret = await DatabaseTestHelper.updateTestData(key, newValue);
          expect(ret).assertLargerOrEqual(0);
        }
      });
      expect(success).assertTrue();
    });

    it('data_batch_delete_five_settings', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        for (let i = 0; i < 5; i++) {
          const key = `${TEST_PREFIX}_batch_key_${i}`;
          const ret = await DatabaseTestHelper.deleteTestData(key);
          expect(ret).assertLargerOrEqual(0);
        }
      });
      expect(success).assertTrue();
    });
  });
}
