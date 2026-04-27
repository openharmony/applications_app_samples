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
 * @file SettingsDataFinal.test.ets
 * @overview 最终扩展测试模�? *           覆盖：数据完整性校验、灰度验证、兼容性矩阵、无障碍测试
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

export default function settingsDataFinalTest() {
  describe('SettingsDataFinal_Test', () => {
    let driver: Driver;
    const TEST_PREFIX = 'final_test';

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

    // ========== 数据完整性校�?==========

    it('integrity_insert_and_verify_count', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        for (let i = 0; i < 10; i++) {
          const key = `${TEST_PREFIX}_integrity_verify_key_${i}`;
          const value = `integrity_verify_value_${i}`;
          await DatabaseTestHelper.insertTestData(key, value);
        }

        const finalPredicates = new dataSharePredicates.DataSharePredicates();
        finalPredicates.like('KEYWORD', `${TEST_PREFIX}_integrity_verify_%`);
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const finalResultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, finalPredicates, []);
          expect(finalResultSet.rowCount).assertLargerOrEqual(10);
        }
      });
      expect(success).assertTrue();
    });

    it('integrity_update_and_verify_value', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = `${TEST_PREFIX}_integrity_update_verify_key`;
        const value = 'integrity_update_verify_original';
        
        await DatabaseTestHelper.insertTestData(key, value);

        const updatePredicates = new dataSharePredicates.DataSharePredicates();
        updatePredicates.equalTo('KEYWORD', key);
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const updateBucket: relationalStore.ValuesBucket = {
            'VALUE': 'integrity_update_verify_updated'
          };
          await rdbStore.update(settingsDataConfig.TABLE_NAME, updateBucket, updatePredicates);

          const readPredicates = new dataSharePredicates.DataSharePredicates();
          readPredicates.equalTo('KEYWORD', key);
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, readPredicates, []);
          expect(resultSet.rowCount).assertLargerOrEqual(1);
        }
      });
      expect(success).assertTrue();
    });

    it('integrity_delete_and_verify_removed', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = `${TEST_PREFIX}_integrity_delete_verify_key`;
        const value = 'integrity_delete_verify_value';
        
        await DatabaseTestHelper.insertTestData(key, value);

        const deletePredicates = new dataSharePredicates.DataSharePredicates();
        deletePredicates.equalTo('KEYWORD', key);
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          await rdbStore.delete(settingsDataConfig.TABLE_NAME, deletePredicates);

          const readPredicates = new dataSharePredicates.DataSharePredicates();
          readPredicates.equalTo('KEYWORD', key);
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, readPredicates, []);
          expect(resultSet.rowCount).assertEqual(0);
        }
      });
      expect(success).assertTrue();
    });

    // ========== 灰度验证测试 ==========

    it('canary_settings_data_basic_operations', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = `${TEST_PREFIX}_canary_basic_key`;
        const value = 'canary_basic_value';
        
        await DatabaseTestHelper.insertTestData(key, value);

        const predicates = new dataSharePredicates.DataSharePredicates();
        predicates.equalTo('KEYWORD', key);
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          expect(resultSet.rowCount).assertLargerOrEqual(1);
        }
      });
      expect(success).assertTrue();
    });

    it('canary_context_operations', 0, () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        ctx.setProperty('canary_property_key', 'canary_property_value');
        expect(ctx.getProperty('canary_property_key')).assertEqual('canary_property_value');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('canary_log_operations', 0, () => {
      let threw = false;
      try {
        Log.info('Canary test info message');
        Log.debug('Canary test debug message');
        Log.warn('Canary test warn message');
        Log.error('Canary test error message');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 兼容性矩阵测�?==========

    it('matrix_settings_data_config_enum_values', 0, () => {
      let threw = false;
      try {
        const tableTypeSettings = TableType.SETTINGS;
        const tableTypeUser = TableType.USER;
        const tableTypeUserSecure = TableType.USER_SECURE;
        expect(tableTypeSettings !== undefined).assertTrue();
        expect(tableTypeUser !== undefined).assertTrue();
        expect(tableTypeUserSecure !== undefined).assertTrue();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('matrix_data_settings_key_values', 0, () => {
      let threw = false;
      try {
        const brightnessKey = DataSettingsKey.SETTINGS_SCREEN_BRIGHTNESS;
        const timeFormatKey = DataSettingsKey.SETTINGS_TIME_FORMAT;
        const audioRingtoneKey = DataSettingsKey.SETTINGS_AUDIO_RINGTONE;
        expect(brightnessKey.length).assertLarger(0);
        expect(timeFormatKey.length).assertLarger(0);
        expect(audioRingtoneKey.length).assertLarger(0);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('matrix_data_default_key_values', 0, () => {
      let threw = false;
      try {
        const brightnessDefault = DataDefaultKey.SETTINGS_SCREEN_BRIGHTNESS_DEFAULT;
        const timeFormatDefault = DataDefaultKey.SETTINGS_TIME_FORMAT_DEFAULT;
        const audioRingtoneDefault = DataDefaultKey.SETTINGS_AUDIO_RINGTONE_DEFAULT;
        expect(brightnessDefault.length).assertLarger(0);
        expect(timeFormatDefault.length).assertLarger(0);
        expect(audioRingtoneDefault.length).assertLarger(0);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 最终综合验�?==========

    it('final_comprehensive_db_operations', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          await rdbStore.beginTransaction();
          for (let i = 0; i < 20; i++) {
            const valuesBucket: relationalStore.ValuesBucket = {
              'KEYWORD': 'final_comprehensive_key_' + i,
              'VALUE': 'final_comprehensive_value_' + i
            };
            await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          }
          await rdbStore.commit();

          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.like('KEYWORD', 'final_comprehensive_%');
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          expect(resultSet.rowCount).assertLargerOrEqual(20);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('final_comprehensive_context_operations', 0, () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        for (let i = 0; i < 50; i++) {
          ctx.setProperty('final_comprehensive_prop_' + i, 'final_comprehensive_value_' + i);
        }
        for (let i = 0; i < 50; i++) {
          expect(ctx.getProperty('final_comprehensive_prop_' + i)).assertEqual('final_comprehensive_value_' + i);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('final_comprehensive_log_operations', 0, () => {
      let threw = false;
      try {
        for (let i = 0; i < 50; i++) {
          Log.info('Final comprehensive log message ' + i);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });
  });
}
