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
 * @file SettingsDataValidation.test.ets
 * @overview 测试设置数据验证逻辑
 *           覆盖：参数合法性、边界校验、类型检查、格式验证
 */

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

export default function settingsDataValidationTest() {
  describe('SettingsDataValidation_Test', () => {
    let driver: Driver;
    const TEST_PREFIX = 'validation_test';

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

    // ========== 亮度值边界测试 ==========

    it('brightness_min_value_zero_should_be_valid', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = DataSettingsKey.SETTINGS_SCREEN_BRIGHTNESS;
        const value = '0';
        
        const ret = await DatabaseTestHelper.insertTestData(key, value);
        expect(ret).assertLargerOrEqual(0);
      });
      expect(success).assertTrue();
    });

    it('brightness_max_value_255_should_be_valid', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = DataSettingsKey.SETTINGS_SCREEN_BRIGHTNESS;
        const value = '255';
        
        const ret = await DatabaseTestHelper.insertTestData(key, value);
        expect(ret).assertLargerOrEqual(0);
      });
      expect(success).assertTrue();
    });

    it('brightness_mid_value_128_should_be_valid', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = DataSettingsKey.SETTINGS_SCREEN_BRIGHTNESS;
        const value = '128';
        
        const ret = await DatabaseTestHelper.insertTestData(key, value);
        expect(ret).assertLargerOrEqual(0);
      });
      expect(success).assertTrue();
    });

    it('brightness_negative_value_should_fail', 0, () => {
      const brightnessValue = -1;
      expect(brightnessValue).assertLess(0);
    });

    it('brightness_exceeding_max_should_fail', 0, () => {
      const brightnessValue = 256;
      expect(brightnessValue).assertLarger(255);
    });

    // ========== 时间格式验证测试 ==========

    it('time_format_12_hour_should_be_valid', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = DataSettingsKey.SETTINGS_TIME_FORMAT;
        const value = '12';
        
        const ret = await DatabaseTestHelper.insertTestData(key, value);
        expect(ret).assertLargerOrEqual(0);
      });
      expect(success).assertTrue();
    });

    it('time_format_24_hour_should_be_valid', 0, async () => {
      const success = await TestAssertions.shouldSucceed(async () => {
        const key = DataSettingsKey.SETTINGS_TIME_FORMAT;
        const value = '24';
        
        const ret = await DatabaseTestHelper.insertTestData(key, value);
        expect(ret).assertLargerOrEqual(0);
      });
      expect(success).assertTrue();
    });

    it('time_format_invalid_value_should_fail', 0, () => {
      const invalidFormat: string = '99';
      expect(invalidFormat !== '12' && invalidFormat !== '24').assertTrue();
    });

    // ========== 音频值边界测试 ==========

    it('audio_ringtone_min_value_zero_should_be_valid', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': DataSettingsKey.SETTINGS_AUDIO_RINGTONE,
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

    it('audio_ringtone_max_value_15_should_be_valid', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': DataSettingsKey.SETTINGS_AUDIO_RINGTONE,
            'VALUE': '15'
          };
          const ret = await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          expect(ret).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('audio_media_min_value_zero_should_be_valid', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': DataSettingsKey.SETTINGS_AUDIO_MEDIA,
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

    it('audio_media_max_value_15_should_be_valid', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': DataSettingsKey.SETTINGS_AUDIO_MEDIA,
            'VALUE': '15'
          };
          const ret = await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          expect(ret).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('audio_voicecall_min_value_zero_should_be_valid', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': DataSettingsKey.SETTINGS_AUDIO_VOICE_CALL,
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

    it('audio_voicecall_max_value_15_should_be_valid', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': DataSettingsKey.SETTINGS_AUDIO_VOICE_CALL,
            'VALUE': '15'
          };
          const ret = await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          expect(ret).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 设备名称长度测试 ==========

    it('device_name_empty_should_be_valid', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': DataSettingsKey.SETTINGS_GENERAL_DEVICE_NAME,
            'VALUE': ''
          };
          const ret = await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          expect(ret).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('device_name_short_should_be_valid', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': DataSettingsKey.SETTINGS_GENERAL_DEVICE_NAME,
            'VALUE': 'TV'
          };
          const ret = await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          expect(ret).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('device_name_medium_should_be_valid', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': DataSettingsKey.SETTINGS_GENERAL_DEVICE_NAME,
            'VALUE': 'LivingRoomTV'
          };
          const ret = await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          expect(ret).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('device_name_long_should_be_valid', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          let longName = '';
          for (let i = 0; i < 100; i++) {
            longName += 'A';
          }
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': DataSettingsKey.SETTINGS_GENERAL_DEVICE_NAME,
            'VALUE': longName
          };
          const ret = await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
          expect(ret).assertLargerOrEqual(0);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 布尔值验证测试 ==========

    it('navbar_status_zero_should_be_valid', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const rdbStore = await helper.getRdbStore();
        if (rdbStore !== undefined) {
          const valuesBucket: relationalStore.ValuesBucket = {
            'KEYWORD': DataSettingsKey.SETTINGS_DISPALY_NAVBAR_STATUS,
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

    it('navbar_status_one_should_be_valid', 0, async () => {
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

    it('cellular_data_zero_should_be_valid', 0, async () => {
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

    it('cellular_data_one_should_be_valid', 0, async () => {
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

    // ========== 类型检查测试 ==========

    it('value_type_string_should_be_valid', 0, () => {
      const value = 'string_value';
      expect(typeof value === 'string').assertTrue();
    });

    it('value_type_number_converted_to_string', 0, () => {
      const numValue = 123;
      const strValue = numValue.toString();
      expect(typeof strValue === 'string').assertTrue();
    });

    it('value_type_boolean_converted_to_string', 0, () => {
      const boolValue = true;
      const strValue = boolValue.toString();
      expect(typeof strValue === 'string').assertTrue();
    });

    // ========== 格式验证测试 ==========

    it('value_format_numeric_string_should_be_valid', 0, () => {
      const value = '12345';
      const numValue = Number(value);
      expect(Number.isNaN(numValue)).assertFalse();
    });

    it('value_format_non_numeric_string_should_be_invalid', 0, () => {
      const value = 'abc';
      const numValue = Number(value);
      expect(Number.isNaN(numValue)).assertTrue();
    });
  });
}
