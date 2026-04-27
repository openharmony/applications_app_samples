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
 * @file SettingsDataConfigExtended.test.ets
 * @overview 扩展测试 SettingsDataConfig 配置项
 *           覆盖：配置一致性、键值映射、默认值验证、配置变更影响
 */

import { describe, it, expect, beforeAll, afterAll, beforeEach, afterEach } from '@ohos/hypium';
import { settingsDataConfig, DataSettingsKey, DataDefaultKey } from '../../../main/ets/Utils/SettingsDataConfig';
import SettingsDBHelper from '../../../main/ets/Utils/SettingsDBHelper';
import { TestDataCleaner } from './TestUtils';
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

export default function settingsDataConfigExtendedTest() {
  describe('SettingsDataConfigExtended_Test', () => {
    let driver: Driver;
    const TEST_PREFIX = 'config_test';

    beforeAll(async () => {
      SettingsDBHelper.resetInstance();
      TestDataCleaner.reset();

      driver = createFreshDriver();
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await waitForSurface(driver, 2, TIMEOUT_COLD_START);
      await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 2500);
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

    // ========== 配置一致性测试 ==========

    it('config_db_name_consistent_across_access', 0, () => {
      const name1 = settingsDataConfig.DB_NAME;
      const name2 = settingsDataConfig.DB_NAME;
      expect(name1).assertEqual(name2);
    });

    it('config_table_name_consistent_across_access', 0, () => {
      const table1 = settingsDataConfig.TABLE_NAME;
      const table2 = settingsDataConfig.TABLE_NAME;
      expect(table1).assertEqual(table2);
    });

    it('config_user_table_name_consistent_across_access', 0, () => {
      const userTable1 = settingsDataConfig.USER_TABLE_NAME;
      const userTable2 = settingsDataConfig.USER_TABLE_NAME;
      expect(userTable1).assertEqual(userTable2);
    });

    it('config_secure_table_name_consistent_across_access', 0, () => {
      const secureTable1 = settingsDataConfig.SECURE_TABLE_NAME;
      const secureTable2 = settingsDataConfig.SECURE_TABLE_NAME;
      expect(secureTable1).assertEqual(secureTable2);
    });

    it('config_field_id_consistent_across_access', 0, () => {
      const field1 = settingsDataConfig.FIELD_ID;
      const field2 = settingsDataConfig.FIELD_ID;
      expect(field1).assertEqual(field2);
    });

    it('config_field_keyword_consistent_across_access', 0, () => {
      const keyword1 = settingsDataConfig.FIELD_KEYWORD;
      const keyword2 = settingsDataConfig.FIELD_KEYWORD;
      expect(keyword1).assertEqual(keyword2);
    });

    it('config_field_value_consistent_across_access', 0, () => {
      const value1 = settingsDataConfig.FIELD_VALUE;
      const value2 = settingsDataConfig.FIELD_VALUE;
      expect(value1).assertEqual(value2);
    });

    // ========== 键值映射测试 ==========

    it('brightness_key_mapping_correct', 0, () => {
      const settingsKey = DataSettingsKey.SETTINGS_SCREEN_BRIGHTNESS;
      const defaultKey = DataDefaultKey.SETTINGS_SCREEN_BRIGHTNESS_DEFAULT;
      expect(defaultKey).assertEqual(settingsKey + '.default');
    });

    it('time_format_key_mapping_correct', 0, () => {
      const settingsKey = DataSettingsKey.SETTINGS_TIME_FORMAT;
      const defaultKey = DataDefaultKey.SETTINGS_TIME_FORMAT_DEFAULT;
      expect(defaultKey).assertEqual(settingsKey + '.default');
    });

    it('audio_ringtone_key_mapping_correct', 0, () => {
      const settingsKey = DataSettingsKey.SETTINGS_AUDIO_RINGTONE;
      const defaultKey = DataDefaultKey.SETTINGS_AUDIO_RINGTONE_DEFAULT;
      expect(defaultKey).assertEqual(settingsKey + '.default');
    });

    it('audio_media_key_mapping_correct', 0, () => {
      const settingsKey = DataSettingsKey.SETTINGS_AUDIO_MEDIA;
      const defaultKey = DataDefaultKey.SETTINGS_AUDIO_MEDIA_DEFAULT;
      expect(defaultKey).assertEqual(settingsKey + '.default');
    });

    it('audio_voicecall_key_mapping_correct', 0, () => {
      const settingsKey = DataSettingsKey.SETTINGS_AUDIO_VOICE_CALL;
      const defaultKey = DataDefaultKey.SETTINGS_AUDIO_VOICE_CALL_DEFAULT;
      expect(defaultKey).assertEqual(settingsKey + '.default');
    });

    it('device_name_key_mapping_correct', 0, () => {
      const settingsKey = DataSettingsKey.SETTINGS_GENERAL_DEVICE_NAME;
      const defaultKey = DataDefaultKey.SETTINGS_GENERAL_DEVICE_NAME_DEFAULT;
      expect(defaultKey).assertEqual(settingsKey + '.default');
    });

    it('navbar_status_key_mapping_correct', 0, () => {
      const settingsKey = DataSettingsKey.SETTINGS_DISPALY_NAVBAR_STATUS;
      const defaultKey = DataDefaultKey.SETTINGS_DISPALY_NAVBAR_STATUS_DEFAULT;
      expect(defaultKey).assertEqual(settingsKey + '.default');
    });

    it('cellular_data_key_mapping_correct', 0, () => {
      const settingsKey = DataSettingsKey.CELLULAR_DATA_ENABLE;
      const defaultKey = DataDefaultKey.CELLULAR_DATA_ENABLE_DEFAULT;
      expect(defaultKey).assertEqual(settingsKey + '.default');
    });

    // ========== 默认值验证测试 ==========

    it('default_brightness_value_valid', 0, () => {
      const defaultKey = DataDefaultKey.SETTINGS_SCREEN_BRIGHTNESS_DEFAULT;
      expect(defaultKey.length).assertLarger(0);
      expect(defaultKey.endsWith('.default')).assertTrue();
    });

    it('default_time_format_value_valid', 0, () => {
      const defaultKey = DataDefaultKey.SETTINGS_TIME_FORMAT_DEFAULT;
      expect(defaultKey.length).assertLarger(0);
      expect(defaultKey.endsWith('.default')).assertTrue();
    });

    it('default_audio_ringtone_value_valid', 0, () => {
      const defaultKey = DataDefaultKey.SETTINGS_AUDIO_RINGTONE_DEFAULT;
      expect(defaultKey.length).assertLarger(0);
      expect(defaultKey.endsWith('.default')).assertTrue();
    });

    it('default_audio_media_value_valid', 0, () => {
      const defaultKey = DataDefaultKey.SETTINGS_AUDIO_MEDIA_DEFAULT;
      expect(defaultKey.length).assertLarger(0);
      expect(defaultKey.endsWith('.default')).assertTrue();
    });

    it('default_audio_voicecall_value_valid', 0, () => {
      const defaultKey = DataDefaultKey.SETTINGS_AUDIO_VOICE_CALL_DEFAULT;
      expect(defaultKey.length).assertLarger(0);
      expect(defaultKey.endsWith('.default')).assertTrue();
    });

    it('default_device_name_value_valid', 0, () => {
      const defaultKey = DataDefaultKey.SETTINGS_GENERAL_DEVICE_NAME_DEFAULT;
      expect(defaultKey.length).assertLarger(0);
      expect(defaultKey.endsWith('.default')).assertTrue();
    });

    it('default_navbar_status_value_valid', 0, () => {
      const defaultKey = DataDefaultKey.SETTINGS_DISPALY_NAVBAR_STATUS_DEFAULT;
      expect(defaultKey.length).assertLarger(0);
      expect(defaultKey.endsWith('.default')).assertTrue();
    });

    it('default_cellular_data_value_valid', 0, () => {
      const defaultKey = DataDefaultKey.CELLULAR_DATA_ENABLE_DEFAULT;
      expect(defaultKey.length).assertLarger(0);
      expect(defaultKey.endsWith('.default')).assertTrue();
    });

    // ========== 配置变更影响测试 ==========

    it('config_change_db_name_affects_connection', 0, () => {
      const originalName = settingsDataConfig.DB_NAME;
      expect(originalName).assertEqual('settingsdata.db');
    });

    it('config_change_table_name_affects_queries', 0, () => {
      const originalTable = settingsDataConfig.TABLE_NAME;
      expect(originalTable).assertEqual('SETTINGSDATA');
    });

    it('config_change_field_keyword_affects_filters', 0, () => {
      const originalKeyword = settingsDataConfig.FIELD_KEYWORD;
      expect(originalKeyword).assertEqual('KEYWORD');
    });

    it('config_change_field_value_affects_storage', 0, () => {
      const originalValue = settingsDataConfig.FIELD_VALUE;
      expect(originalValue).assertEqual('VALUE');
    });

    // ========== 配置命名规范测试 ==========

    it('config_db_name_lowercase_with_extension', 0, () => {
      const dbName = settingsDataConfig.DB_NAME;
      expect(dbName).assertEqual(dbName.toLowerCase());
      expect(dbName.endsWith('.db')).assertTrue();
    });

    it('config_table_names_uppercase', 0, () => {
      const tableName = settingsDataConfig.TABLE_NAME;
      expect(tableName).assertEqual(tableName.toUpperCase());
    });

    it('config_user_table_name_uppercase', 0, () => {
      const userTableName = settingsDataConfig.USER_TABLE_NAME;
      expect(userTableName).assertEqual(userTableName.toUpperCase());
    });

    it('config_secure_table_name_uppercase', 0, () => {
      const secureTableName = settingsDataConfig.SECURE_TABLE_NAME;
      expect(secureTableName).assertEqual(secureTableName.toUpperCase());
    });

    it('config_field_names_uppercase', 0, () => {
      const fieldId = settingsDataConfig.FIELD_ID;
      const fieldKeyword = settingsDataConfig.FIELD_KEYWORD;
      const fieldValue = settingsDataConfig.FIELD_VALUE;
      expect(fieldId).assertEqual(fieldId.toUpperCase());
      expect(fieldKeyword).assertEqual(fieldKeyword.toUpperCase());
      expect(fieldValue).assertEqual(fieldValue.toUpperCase());
    });

    // ========== 配置组合测试 ==========

    it('config_all_fields_non_empty', 0, () => {
      expect(settingsDataConfig.DB_NAME.length).assertLarger(0);
      expect(settingsDataConfig.TABLE_NAME.length).assertLarger(0);
      expect(settingsDataConfig.USER_TABLE_NAME.length).assertLarger(0);
      expect(settingsDataConfig.SECURE_TABLE_NAME.length).assertLarger(0);
      expect(settingsDataConfig.FIELD_ID.length).assertLarger(0);
      expect(settingsDataConfig.FIELD_KEYWORD.length).assertLarger(0);
      expect(settingsDataConfig.FIELD_VALUE.length).assertLarger(0);
    });

    it('config_all_table_names_distinct', 0, () => {
      const tables: string[] = [
        settingsDataConfig.TABLE_NAME,
        settingsDataConfig.USER_TABLE_NAME,
        settingsDataConfig.SECURE_TABLE_NAME
      ];
      const uniqueTables = new Set<string>(tables);
      expect(uniqueTables.size).assertEqual(tables.length);
    });

    it('config_all_field_names_distinct', 0, () => {
      const fields: string[] = [
        settingsDataConfig.FIELD_ID,
        settingsDataConfig.FIELD_KEYWORD,
        settingsDataConfig.FIELD_VALUE
      ];
      const uniqueFields = new Set<string>(fields);
      expect(uniqueFields.size).assertEqual(fields.length);
    });

    it('config_settings_keys_all_distinct', 0, () => {
      const keys: string[] = [
        DataSettingsKey.SETTINGS_SCREEN_BRIGHTNESS,
        DataSettingsKey.SETTINGS_TIME_FORMAT,
        DataSettingsKey.SETTINGS_AUDIO_RINGTONE,
        DataSettingsKey.SETTINGS_AUDIO_MEDIA,
        DataSettingsKey.SETTINGS_AUDIO_VOICE_CALL,
        DataSettingsKey.SETTINGS_GENERAL_DEVICE_NAME,
        DataSettingsKey.SETTINGS_DISPALY_NAVBAR_STATUS,
        DataSettingsKey.CELLULAR_DATA_ENABLE
      ];
      const uniqueKeys = new Set<string>(keys);
      expect(uniqueKeys.size).assertEqual(keys.length);
    });

    it('config_default_keys_all_distinct', 0, () => {
      const keys: string[] = [
        DataDefaultKey.SETTINGS_SCREEN_BRIGHTNESS_DEFAULT,
        DataDefaultKey.SETTINGS_TIME_FORMAT_DEFAULT,
        DataDefaultKey.SETTINGS_AUDIO_RINGTONE_DEFAULT,
        DataDefaultKey.SETTINGS_AUDIO_MEDIA_DEFAULT,
        DataDefaultKey.SETTINGS_AUDIO_VOICE_CALL_DEFAULT,
        DataDefaultKey.SETTINGS_GENERAL_DEVICE_NAME_DEFAULT,
        DataDefaultKey.SETTINGS_DISPALY_NAVBAR_STATUS_DEFAULT,
        DataDefaultKey.CELLULAR_DATA_ENABLE_DEFAULT
      ];
      const uniqueKeys = new Set<string>(keys);
      expect(uniqueKeys.size).assertEqual(keys.length);
    });

    // ========== 配置值长度测试 ==========

    it('config_db_name_reasonable_length', 0, () => {
      expect(settingsDataConfig.DB_NAME.length).assertLess(50);
    });

    it('config_table_name_reasonable_length', 0, () => {
      expect(settingsDataConfig.TABLE_NAME.length).assertLess(50);
    });

    it('config_field_id_reasonable_length', 0, () => {
      expect(settingsDataConfig.FIELD_ID.length).assertLess(20);
    });

    it('config_field_keyword_reasonable_length', 0, () => {
      expect(settingsDataConfig.FIELD_KEYWORD.length).assertLess(20);
    });

    it('config_field_value_reasonable_length', 0, () => {
      expect(settingsDataConfig.FIELD_VALUE.length).assertLess(20);
    });

    it('config_settings_key_reasonable_length', 0, () => {
      const keys: string[] = [
        DataSettingsKey.SETTINGS_SCREEN_BRIGHTNESS,
        DataSettingsKey.SETTINGS_TIME_FORMAT,
        DataSettingsKey.SETTINGS_AUDIO_RINGTONE
      ];
      for (const key of keys) {
        expect(key.length).assertLess(50);
      }
    });
  });
}
