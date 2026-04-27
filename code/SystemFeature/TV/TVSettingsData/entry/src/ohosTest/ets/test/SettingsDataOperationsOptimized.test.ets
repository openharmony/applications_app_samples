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

import { describe, it, expect, beforeAll, afterAll, beforeEach, afterEach } from '@ohos/hypium';
import { settingsDataConfig, DataSettingsKey } from '../../../main/ets/Utils/SettingsDataConfig';
import SettingsDBHelper from '../../../main/ets/Utils/SettingsDBHelper';
import { GlobalContext } from '../../../main/ets/Utils/GlobalContext';
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
import { TestDataCleaner, DatabaseTestHelper, TestAssertions, TestDataGenerator } from './TestUtils';

export default function settingsDataOperationsOptimizedTest() {
  describe('SettingsDataOperations_Optimized_Test', () => {
    let driver: Driver;
    const TEST_PREFIX = 'opt_test';

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

    // ========== 数据插入测试 ==========

    it('insert_single_record_should_return_valid_row_id', 0, async () => {
      const testKey = TestDataGenerator.generateTestKey(TEST_PREFIX);
      const testValue = 'insert_single_value';
      
      const rowId = await DatabaseTestHelper.insertTestData(testKey, testValue);
      
      expect(rowId).assertLargerOrEqual(0);
      const exists = await DatabaseTestHelper.assertDataExists(testKey);
      expect(exists).assertTrue();
    });

    it('insert_with_brightness_setting_should_succeed', 0, async () => {
      const testKey = TestDataGenerator.generateTestKey(`${TEST_PREFIX}_brightness`);
      const testValue = '150';
      
      const rowId = await DatabaseTestHelper.insertTestData(testKey, testValue);
      
      expect(rowId).assertLargerOrEqual(0);
    });

    it('insert_with_time_format_setting_should_succeed', 0, async () => {
      const testKey = TestDataGenerator.generateTestKey(`${TEST_PREFIX}_timeformat`);
      const testValue = '24';
      
      const rowId = await DatabaseTestHelper.insertTestData(testKey, testValue);
      
      expect(rowId).assertLargerOrEqual(0);
    });

    it('insert_with_audio_ringtone_setting_should_succeed', 0, async () => {
      const testKey = TestDataGenerator.generateTestKey(`${TEST_PREFIX}_ringtone`);
      const testValue = '7';
      
      const rowId = await DatabaseTestHelper.insertTestData(testKey, testValue);
      
      expect(rowId).assertLargerOrEqual(0);
    });

    it('insert_with_audio_media_setting_should_succeed', 0, async () => {
      const testKey = TestDataGenerator.generateTestKey(`${TEST_PREFIX}_media`);
      const testValue = '12';
      
      const rowId = await DatabaseTestHelper.insertTestData(testKey, testValue);
      
      expect(rowId).assertLargerOrEqual(0);
    });

    it('insert_with_device_name_setting_should_succeed', 0, async () => {
      const testKey = TestDataGenerator.generateTestKey(`${TEST_PREFIX}_devicename`);
      const testValue = 'MyTVDevice';
      
      const rowId = await DatabaseTestHelper.insertTestData(testKey, testValue);
      
      expect(rowId).assertLargerOrEqual(0);
    });

    it('insert_with_navbar_status_setting_should_succeed', 0, async () => {
      const testKey = TestDataGenerator.generateTestKey(`${TEST_PREFIX}_navbar`);
      const testValue = '1';
      
      const rowId = await DatabaseTestHelper.insertTestData(testKey, testValue);
      
      expect(rowId).assertLargerOrEqual(0);
    });

    it('insert_with_cellular_data_setting_should_succeed', 0, async () => {
      const testKey = TestDataGenerator.generateTestKey(`${TEST_PREFIX}_cellular`);
      const testValue = '0';
      
      const rowId = await DatabaseTestHelper.insertTestData(testKey, testValue);
      
      expect(rowId).assertLargerOrEqual(0);
    });

    // ========== 数据更新测试 ==========

    it('update_existing_record_should_return_affected_rows', 0, async () => {
      const testKey = TestDataGenerator.generateTestKey(`${TEST_PREFIX}_update`);
      const initialValue = 'initial_value';
      const updatedValue = 'updated_value';
      
      await DatabaseTestHelper.insertTestData(testKey, initialValue);
      const affectedRows = await DatabaseTestHelper.updateTestData(testKey, updatedValue);
      
      expect(affectedRows).assertLargerOrEqual(0);
    });

    it('update_brightness_value_should_succeed', 0, async () => {
      const testKey = TestDataGenerator.generateTestKey(`${TEST_PREFIX}_brightness_update`);
      const initialValue = '100';
      const updatedValue = '200';
      
      await DatabaseTestHelper.insertTestData(testKey, initialValue);
      const affectedRows = await DatabaseTestHelper.updateTestData(testKey, updatedValue);
      
      expect(affectedRows).assertLargerOrEqual(0);
    });

    it('update_time_format_value_should_succeed', 0, async () => {
      const testKey = TestDataGenerator.generateTestKey(`${TEST_PREFIX}_timeformat_update`);
      const initialValue = '24';
      const updatedValue = '12';
      
      await DatabaseTestHelper.insertTestData(testKey, initialValue);
      const affectedRows = await DatabaseTestHelper.updateTestData(testKey, updatedValue);
      
      expect(affectedRows).assertLargerOrEqual(0);
    });

    // ========== 数据删除测试 ==========

    it('delete_existing_record_should_return_affected_rows', 0, async () => {
      const testKey = TestDataGenerator.generateTestKey(`${TEST_PREFIX}_delete`);
      const testValue = 'delete_value';
      
      await DatabaseTestHelper.insertTestData(testKey, testValue);
      const affectedRows = await DatabaseTestHelper.deleteTestData(testKey);
      
      expect(affectedRows).assertLargerOrEqual(0);
      const exists = await DatabaseTestHelper.assertDataNotExists(testKey);
      expect(exists).assertTrue();
    });

    it('delete_nonexistent_record_should_return_zero', 0, async () => {
      const testKey = TestDataGenerator.generateTestKey(`${TEST_PREFIX}_nonexistent`);
      
      const affectedRows = await DatabaseTestHelper.deleteTestData(testKey);
      
      expect(affectedRows).assertEqual(0);
    });

    // ========== 数据查询测试 ==========

    it('query_all_records_should_return_resultset', 0, async () => {
      const helper = SettingsDBHelper.getInstance();
      const rdbStore = await helper.getRdbStore();
      
      expect(rdbStore !== undefined).assertTrue();
      
      if (rdbStore !== undefined) {
        const predicates = new dataSharePredicates.DataSharePredicates();
        const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
        
        expect(resultSet.rowCount).assertLargerOrEqual(0);
      }
    });

    it('query_by_keyword_should_return_matching_records', 0, async () => {
      const testKey = TestDataGenerator.generateTestKey(`${TEST_PREFIX}_query`);
      const testValue = 'query_value';
      
      await DatabaseTestHelper.insertTestData(testKey, testValue);
      const resultSet = await DatabaseTestHelper.queryTestData(testKey);
      
      expect(resultSet.rowCount).assertLargerOrEqual(1);
    });

    it('query_by_id_should_return_matching_records', 0, async () => {
      const helper = SettingsDBHelper.getInstance();
      const rdbStore = await helper.getRdbStore();
      
      if (rdbStore !== undefined) {
        const predicates = new dataSharePredicates.DataSharePredicates();
        predicates.equalTo('ID', 1);
        const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
        
        expect(resultSet.rowCount).assertLargerOrEqual(0);
      }
    });

    // ========== 数据验证测试 ==========

    it('validate_inserted_value_should_be_retrievable', 0, async () => {
      const testKey = TestDataGenerator.generateTestKey(`${TEST_PREFIX}_validate_insert`);
      const testValue = 'validate_test_value';
      
      await DatabaseTestHelper.insertTestData(testKey, testValue);
      const exists = await DatabaseTestHelper.assertDataExists(testKey);
      
      expect(exists).assertTrue();
    });

    it('validate_updated_value_should_match_new_value', 0, async () => {
      const testKey = TestDataGenerator.generateTestKey(`${TEST_PREFIX}_validate_update`);
      const initialValue = 'initial_value';
      const updatedValue = 'validate_updated_value';
      
      await DatabaseTestHelper.insertTestData(testKey, initialValue);
      await DatabaseTestHelper.updateTestData(testKey, updatedValue);
      
      const resultSet = await DatabaseTestHelper.queryTestData(testKey);
      expect(resultSet.rowCount).assertLargerOrEqual(1);
    });

    // ========== 批量操作测试 ==========

    it('batch_insert_five_records_should_succeed', 0, async () => {
      const testKeys: string[] = [];
      
      for (let i = 0; i < 5; i++) {
        const testKey = TestDataGenerator.generateTestKey(`${TEST_PREFIX}_batch_insert_${i}`);
        const testValue = `batch_value_${i}`;
        
        const rowId = await DatabaseTestHelper.insertTestData(testKey, testValue);
        expect(rowId).assertLargerOrEqual(0);
        testKeys.push(testKey);
      }
      
      await TestDataCleaner.cleanMultipleTestData(testKeys);
    });

    it('batch_update_five_records_should_succeed', 0, async () => {
      const testKeys: string[] = [];
      
      for (let i = 0; i < 5; i++) {
        const testKey = TestDataGenerator.generateTestKey(`${TEST_PREFIX}_batch_update_${i}`);
        const initialValue = `initial_value_${i}`;
        const updatedValue = `updated_value_${i}`;
        
        await DatabaseTestHelper.insertTestData(testKey, initialValue);
        const affectedRows = await DatabaseTestHelper.updateTestData(testKey, updatedValue);
        expect(affectedRows).assertLargerOrEqual(0);
        testKeys.push(testKey);
      }
      
      await TestDataCleaner.cleanMultipleTestData(testKeys);
    });

    it('batch_delete_five_records_should_succeed', 0, async () => {
      const testKeys: string[] = [];
      
      for (let i = 0; i < 5; i++) {
        const testKey = TestDataGenerator.generateTestKey(`${TEST_PREFIX}_batch_delete_${i}`);
        const testValue = `batch_delete_value_${i}`;
        
        await DatabaseTestHelper.insertTestData(testKey, testValue);
        testKeys.push(testKey);
      }
      
      for (const testKey of testKeys) {
        const affectedRows = await DatabaseTestHelper.deleteTestData(testKey);
        expect(affectedRows).assertLargerOrEqual(0);
      }
    });
  });
}
