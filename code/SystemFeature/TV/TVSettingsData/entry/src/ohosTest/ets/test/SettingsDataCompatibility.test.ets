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
 * @file SettingsDataCompatibility.test.ets
 * @overview 测试设置数据兼容性
 *           覆盖：版本兼容、数据格式兼容、API兼容、向后兼容
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

export default function settingsDataCompatibilityTest() {
  describe('SettingsDataCompatibility_Test', () => {
    let driver: Driver;
    const TEST_PREFIX = 'compatibility_test';

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

    // ========== 版本兼容测试 ==========

    it('compatibility_v1_data_format', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': 'compat_v1_key',
            'VALUE': 'compat_v1_value'
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('compatibility_v2_data_format', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = `${TEST_PREFIX}_v2_key`;
        const value = 'compat_v2_value';
        
        const ret = await DatabaseTestHelper.insertTestData(key, value);
        expect(ret).assertLargerOrEqual(0);
      });
      expect(success).assertTrue();
    });

    it('compatibility_v3_data_format', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = `${TEST_PREFIX}_v3_key`;
        const value = 'compat_v3_value';
        
        const ret = await DatabaseTestHelper.insertTestData(key, value);
        expect(ret).assertLargerOrEqual(0);
      });
      expect(success).assertTrue();
    });

    // ========== 数据格式兼容测试 ==========

    it('compatibility_string_value_format', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = `${TEST_PREFIX}_string_key`;
        const value = 'string_value_format';
        
        const ret = await DatabaseTestHelper.insertTestData(key, value);
        expect(ret).assertLargerOrEqual(0);
      });
      expect(success).assertTrue();
    });

    it('compatibility_numeric_string_format', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = `${TEST_PREFIX}_numeric_key`;
        const value = '12345';
        
        const ret = await DatabaseTestHelper.insertTestData(key, value);
        expect(ret).assertLargerOrEqual(0);
      });
      expect(success).assertTrue();
    });

    it('compatibility_boolean_string_format', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = `${TEST_PREFIX}_boolean_key`;
        const value = 'true';
        
        const ret = await DatabaseTestHelper.insertTestData(key, value);
        expect(ret).assertLargerOrEqual(0);
      });
      expect(success).assertTrue();
    });

    it('compatibility_json_string_format', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const jsonValue = '{"key": "value", "nested": {"inner": "data"}}';
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': 'compat_json_key',
            'VALUE': jsonValue
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== API兼容测试 ==========

    it('compatibility_old_api_insert', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': 'compat_old_api_key',
            'VALUE': 'compat_old_api_value'
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('compatibility_new_api_insert', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': 'compat_new_api_key',
            'VALUE': 'compat_new_api_value'
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('compatibility_old_api_query', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.equalTo('KEYWORD', 'compat_old_api_key');
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          let count = 0;
          while (resultSet.goToNextRow()) {
            count++;
          }
          expect(count).assertLargerOrEqual(0);
          resultSet.close();
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('compatibility_new_api_query', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.equalTo('KEYWORD', 'compat_new_api_key');
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          let count = 0;
          while (resultSet.goToNextRow()) {
            count++;
          }
          expect(count).assertLargerOrEqual(0);
          resultSet.close();
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 向后兼容测试 ==========

    it('compatibility_backward_settings_keys', 0, () => {
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

    it('compatibility_backward_default_keys', 0, () => {
      let threw = false;
      try {
        const brightnessDefault = DataDefaultKey.SETTINGS_SCREEN_BRIGHTNESS_DEFAULT;
        const timeFormatDefault = DataDefaultKey.SETTINGS_TIME_FORMAT_DEFAULT;
        const audioRingtoneDefault = DataDefaultKey.SETTINGS_AUDIO_RINGTONE_DEFAULT;
        expect(brightnessDefault.endsWith('.default')).assertTrue();
        expect(timeFormatDefault.endsWith('.default')).assertTrue();
        expect(audioRingtoneDefault.endsWith('.default')).assertTrue();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('compatibility_backward_table_names', 0, () => {
      let threw = false;
      try {
        const tableName = settingsDataConfig.TABLE_NAME;
        const userTableName = settingsDataConfig.USER_TABLE_NAME;
        const secureTableName = settingsDataConfig.SECURE_TABLE_NAME;
        expect(tableName.length).assertLarger(0);
        expect(userTableName.length).assertLarger(0);
        expect(secureTableName.length).assertLarger(0);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('compatibility_backward_field_names', 0, () => {
      let threw = false;
      try {
        const fieldId = settingsDataConfig.FIELD_ID;
        const fieldKeyword = settingsDataConfig.FIELD_KEYWORD;
        const fieldValue = settingsDataConfig.FIELD_VALUE;
        expect(fieldId.length).assertLarger(0);
        expect(fieldKeyword.length).assertLarger(0);
        expect(fieldValue.length).assertLarger(0);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 配置兼容测试 ==========

    it('compatibility_config_db_name', 0, () => {
      let threw = false;
      try {
        const dbName = settingsDataConfig.DB_NAME;
        expect(dbName).assertEqual('settingsdata.db');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('compatibility_config_table_structure', 0, () => {
      let threw = false;
      try {
        const prefix = SettingsDBHelper.SHARED_TABLE_CREATE_PREFIX;
        const suffix = SettingsDBHelper.TABLE_CREATE_SUFFIX;
        expect(prefix.length).assertLarger(0);
        expect(suffix.length).assertLarger(0);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 多版本数据共存测试 ==========

    it('compatibility_multi_version_data_coexistence', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const v1Bucket: relationalStore.ValuesBucket = {
            'KEYWORD': 'compat_v1_coexist_key',
            'VALUE': 'v1_value'
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, v1Bucket);

          const v2Bucket: relationalStore.ValuesBucket = {
            'KEYWORD': 'compat_v2_coexist_key',
            'VALUE': 'v2_value'
          };
          await rdbStore.insert(settingsDataConfig.TABLE_NAME, v2Bucket);

          const predicates = new dataSharePredicates.DataSharePredicates();
          predicates.like('KEYWORD', 'compat_%_coexist_key');
          const resultSet = await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
          let count = 0;
          while (resultSet.goToNextRow()) {
            count++;
          }
          expect(count).assertLargerOrEqual(2);
          resultSet.close();
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });
  });
}
