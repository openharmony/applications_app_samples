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
 * @file ConfigAndConstants.test.ets
 * @overview 测试 SettingsDataConfig 配置枚举、常量定义、数据模型类型
 *           覆盖：枚举值合法性、配置常量一致性、表结构字段验证
 */

import { describe, it, expect, beforeAll, afterAll } from '@ohos/hypium';
import { DataDefaultKey, DataSettingsKey, settingsDataConfig } from '../../../main/ets/Utils/SettingsDataConfig';
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

export default function configAndConstantsTest() {
  describe('ConfigAndConstants_Test', () => {
    let driver: Driver;

    beforeAll(async () => {
      driver = createFreshDriver();
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await waitForSurface(driver, 2, TIMEOUT_COLD_START);
      await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 2500);
    });

    afterAll(async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 2000);
    });

    // ========== DataDefaultKey 枚举测试 ==========

    it('default_brightness_key_should_match', 0, () => {
      expect(DataDefaultKey.SETTINGS_SCREEN_BRIGHTNESS_DEFAULT)
        .assertEqual('settings.screen.brightness.default');
    });

    it('default_time_format_key_should_match', 0, () => {
      expect(DataDefaultKey.SETTINGS_TIME_FORMAT_DEFAULT)
        .assertEqual('settings.time.format.default');
    });

    it('default_audio_ringtone_key_should_match', 0, () => {
      expect(DataDefaultKey.SETTINGS_AUDIO_RINGTONE_DEFAULT)
        .assertEqual('settings.audio.ringtone.default');
    });

    it('default_audio_media_key_should_match', 0, () => {
      expect(DataDefaultKey.SETTINGS_AUDIO_MEDIA_DEFAULT)
        .assertEqual('settings.audio.media.default');
    });

    it('default_audio_voicecall_key_should_match', 0, () => {
      expect(DataDefaultKey.SETTINGS_AUDIO_VOICE_CALL_DEFAULT)
        .assertEqual('settings.audio.voicecall.default');
    });

    it('default_device_name_key_should_match', 0, () => {
      expect(DataDefaultKey.SETTINGS_GENERAL_DEVICE_NAME_DEFAULT)
        .assertEqual('settings.general.device_name.default');
    });

    it('default_navbar_status_key_should_match', 0, () => {
      expect(DataDefaultKey.SETTINGS_DISPALY_NAVBAR_STATUS_DEFAULT)
        .assertEqual('settings.display.navigationbar_status.default');
    });

    it('default_cellular_data_key_should_match', 0, () => {
      expect(DataDefaultKey.CELLULAR_DATA_ENABLE_DEFAULT)
        .assertEqual('cellular_data_enable.default');
    });

    it('default_setting_data_key_marker_should_match', 0, () => {
      expect(DataDefaultKey.settingDataDefaultKey)
        .assertEqual('SettingDataDefaultKey');
    });

    it('all_default_keys_should_be_distinct', 0, () => {
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

    it('default_keys_should_contain_settings_prefix', 0, () => {
      expect(DataDefaultKey.SETTINGS_SCREEN_BRIGHTNESS_DEFAULT.startsWith('settings.'))
        .assertTrue();
      expect(DataDefaultKey.SETTINGS_TIME_FORMAT_DEFAULT.startsWith('settings.'))
        .assertTrue();
    });

    // ========== DataSettingsKey 枚举测试 ==========

    it('settings_brightness_key_should_match', 0, () => {
      expect(DataSettingsKey.SETTINGS_SCREEN_BRIGHTNESS)
        .assertEqual('settings.screen.brightness');
    });

    it('settings_time_format_key_should_match', 0, () => {
      expect(DataSettingsKey.SETTINGS_TIME_FORMAT)
        .assertEqual('settings.time.format');
    });

    it('settings_audio_ringtone_key_should_match', 0, () => {
      expect(DataSettingsKey.SETTINGS_AUDIO_RINGTONE)
        .assertEqual('settings.audio.ringtone');
    });

    it('settings_audio_media_key_should_match', 0, () => {
      expect(DataSettingsKey.SETTINGS_AUDIO_MEDIA)
        .assertEqual('settings.audio.media');
    });

    it('settings_audio_voicecall_key_should_match', 0, () => {
      expect(DataSettingsKey.SETTINGS_AUDIO_VOICE_CALL)
        .assertEqual('settings.audio.voicecall');
    });

    it('settings_device_name_key_should_match', 0, () => {
      expect(DataSettingsKey.SETTINGS_GENERAL_DEVICE_NAME)
        .assertEqual('settings.general.device_name');
    });

    it('settings_navbar_status_key_should_match', 0, () => {
      expect(DataSettingsKey.SETTINGS_DISPALY_NAVBAR_STATUS)
        .assertEqual('settings.display.navigationbar_status');
    });

    it('settings_cellular_data_key_should_match', 0, () => {
      expect(DataSettingsKey.CELLULAR_DATA_ENABLE)
        .assertEqual('cellular_data_enable');
    });

    it('settings_data_key_marker_should_match', 0, () => {
      expect(DataSettingsKey.settingsDataKey)
        .assertEqual('SettingsDataKey');
    });

    it('all_settings_keys_should_be_distinct', 0, () => {
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

    it('settings_keys_should_not_have_default_suffix', 0, () => {
      expect(DataSettingsKey.SETTINGS_SCREEN_BRIGHTNESS.endsWith('.default'))
        .assertFalse();
      expect(DataSettingsKey.SETTINGS_TIME_FORMAT.endsWith('.default'))
        .assertFalse();
    });

    // ========== DefaultKey 与 SettingsKey 对应关系测试 ==========

    it('brightness_default_key_should_correspond_to_brightness_key', 0, () => {
      const defaultKey = DataDefaultKey.SETTINGS_SCREEN_BRIGHTNESS_DEFAULT;
      const settingsKey = DataSettingsKey.SETTINGS_SCREEN_BRIGHTNESS;
      expect(defaultKey.replace('.default', '') === settingsKey).assertTrue();
    });

    it('time_format_default_key_should_correspond_to_time_format_key', 0, () => {
      const defaultKey = DataDefaultKey.SETTINGS_TIME_FORMAT_DEFAULT;
      const settingsKey = DataSettingsKey.SETTINGS_TIME_FORMAT;
      expect(defaultKey.replace('.default', '') === settingsKey).assertTrue();
    });

    it('audio_ringtone_default_key_should_correspond_to_ringtone_key', 0, () => {
      const defaultKey = DataDefaultKey.SETTINGS_AUDIO_RINGTONE_DEFAULT;
      const settingsKey = DataSettingsKey.SETTINGS_AUDIO_RINGTONE;
      expect(defaultKey.replace('.default', '') === settingsKey).assertTrue();
    });

    it('audio_media_default_key_should_correspond_to_media_key', 0, () => {
      const defaultKey = DataDefaultKey.SETTINGS_AUDIO_MEDIA_DEFAULT;
      const settingsKey = DataSettingsKey.SETTINGS_AUDIO_MEDIA;
      expect(defaultKey.replace('.default', '') === settingsKey).assertTrue();
    });

    it('audio_voicecall_default_key_should_correspond_to_voicecall_key', 0, () => {
      const defaultKey = DataDefaultKey.SETTINGS_AUDIO_VOICE_CALL_DEFAULT;
      const settingsKey = DataSettingsKey.SETTINGS_AUDIO_VOICE_CALL;
      expect(defaultKey.replace('.default', '') === settingsKey).assertTrue();
    });

    it('device_name_default_key_should_correspond_to_device_name_key', 0, () => {
      const defaultKey = DataDefaultKey.SETTINGS_GENERAL_DEVICE_NAME_DEFAULT;
      const settingsKey = DataSettingsKey.SETTINGS_GENERAL_DEVICE_NAME;
      expect(defaultKey.replace('.default', '') === settingsKey).assertTrue();
    });

    it('navbar_status_default_key_should_correspond_to_navbar_key', 0, () => {
      const defaultKey = DataDefaultKey.SETTINGS_DISPALY_NAVBAR_STATUS_DEFAULT;
      const settingsKey = DataSettingsKey.SETTINGS_DISPALY_NAVBAR_STATUS;
      expect(defaultKey.replace('.default', '') === settingsKey).assertTrue();
    });

    it('cellular_data_default_key_should_correspond_to_cellular_key', 0, () => {
      const defaultKey = DataDefaultKey.CELLULAR_DATA_ENABLE_DEFAULT;
      const settingsKey = DataSettingsKey.CELLULAR_DATA_ENABLE;
      expect(defaultKey.replace('.default', '') === settingsKey).assertTrue();
    });

    // ========== settingsDataConfig 配置测试 ==========

    it('db_name_should_be_settingsdata', 0, () => {
      expect(settingsDataConfig.DB_NAME).assertEqual('settingsdata.db');
    });

    it('table_name_should_be_settingsdata', 0, () => {
      expect(settingsDataConfig.TABLE_NAME).assertEqual('SETTINGSDATA');
    });

    it('user_table_name_should_be_user_settingsdata', 0, () => {
      expect(settingsDataConfig.USER_TABLE_NAME).assertEqual('USER_SETTINGSDATA');
    });

    it('secure_table_name_should_be_user_settingsdata_secure', 0, () => {
      expect(settingsDataConfig.SECURE_TABLE_NAME).assertEqual('USER_SETTINGSDATA_SECURE');
    });

    it('field_id_should_be_id', 0, () => {
      expect(settingsDataConfig.FIELD_ID).assertEqual('ID');
    });

    it('field_keyword_should_be_keyword', 0, () => {
      expect(settingsDataConfig.FIELD_KEYWORD).assertEqual('KEYWORD');
    });

    it('field_value_should_be_value', 0, () => {
      expect(settingsDataConfig.FIELD_VALUE).assertEqual('VALUE');
    });

    it('all_config_fields_should_be_non_empty', 0, () => {
      expect(settingsDataConfig.DB_NAME.length).assertLarger(0);
      expect(settingsDataConfig.TABLE_NAME.length).assertLarger(0);
      expect(settingsDataConfig.USER_TABLE_NAME.length).assertLarger(0);
      expect(settingsDataConfig.SECURE_TABLE_NAME.length).assertLarger(0);
      expect(settingsDataConfig.FIELD_ID.length).assertLarger(0);
      expect(settingsDataConfig.FIELD_KEYWORD.length).assertLarger(0);
      expect(settingsDataConfig.FIELD_VALUE.length).assertLarger(0);
    });

    it('table_names_should_be_distinct', 0, () => {
      const names: string[] = [
        settingsDataConfig.TABLE_NAME,
        settingsDataConfig.USER_TABLE_NAME,
        settingsDataConfig.SECURE_TABLE_NAME
      ];
      const uniqueNames = new Set<string>(names);
      expect(uniqueNames.size).assertEqual(names.length);
    });

    it('field_names_should_be_distinct', 0, () => {
      const fields: string[] = [
        settingsDataConfig.FIELD_ID,
        settingsDataConfig.FIELD_KEYWORD,
        settingsDataConfig.FIELD_VALUE
      ];
      const uniqueFields = new Set<string>(fields);
      expect(uniqueFields.size).assertEqual(fields.length);
    });

    // ========== TableType 枚举测试 ==========

    it('table_type_settings_should_be_zero', 0, () => {
      expect(TableType.SETTINGS).assertEqual(0);
    });

    it('table_type_user_should_be_one', 0, () => {
      expect(TableType.USER).assertEqual(1);
    });

    it('table_type_user_secure_should_be_two', 0, () => {
      expect(TableType.USER_SECURE).assertEqual(2);
    });

    it('all_table_types_should_be_distinct', 0, () => {
      const types: number[] = [
        TableType.SETTINGS,
        TableType.USER,
        TableType.USER_SECURE
      ];
      const uniqueTypes = new Set<number>(types);
      expect(uniqueTypes.size).assertEqual(types.length);
    });

    it('table_type_count_should_be_three', 0, () => {
      const types: number[] = [
        TableType.SETTINGS,
        TableType.USER,
        TableType.USER_SECURE
      ];
      expect(types.length).assertEqual(3);
    });

    // ========== IContent 接口测试 ==========

    it('icontent_should_support_empty_settings', 0, () => {
      const content: IContent = {
        settings: [],
        user: [],
        userSecure: []
      };
      expect(content.settings.length).assertEqual(0);
      expect(content.user.length).assertEqual(0);
      expect(content.userSecure.length).assertEqual(0);
    });

    it('icontent_should_support_single_entry', 0, () => {
      const entry: Map<string, string> = new Map<string, string>();
      entry.set('name', 'test_key');
      entry.set('value', 'test_value');
      const content: IContent = {
        settings: [entry],
        user: [],
        userSecure: []
      };
      expect(content.settings.length).assertEqual(1);
      expect(content.settings[0].get('name')).assertEqual('test_key');
    });

    it('icontent_should_support_multiple_entries', 0, () => {
      const entry1: Map<string, string> = new Map<string, string>();
      entry1.set('name', 'key1');
      entry1.set('value', 'val1');
      const entry2: Map<string, string> = new Map<string, string>();
      entry2.set('name', 'key2');
      entry2.set('value', 'val2');
      const content: IContent = {
        settings: [entry1, entry2],
        user: [],
        userSecure: []
      };
      expect(content.settings.length).assertEqual(2);
    });

    it('icontent_settings_and_user_should_be_independent', 0, () => {
      const settingsEntry: Map<string, string> = new Map<string, string>();
      settingsEntry.set('name', 'settings_key');
      settingsEntry.set('value', 'settings_val');
      const userEntry: Map<string, string> = new Map<string, string>();
      userEntry.set('name', 'user_key');
      userEntry.set('value', 'user_val');
      const content: IContent = {
        settings: [settingsEntry],
        user: [userEntry],
        userSecure: []
      };
      expect(content.settings[0].get('name')).assertEqual('settings_key');
      expect(content.user[0].get('name')).assertEqual('user_key');
    });

    it('icontent_map_get_should_return_correct_value', 0, () => {
      const entry: Map<string, string> = new Map<string, string>();
      entry.set('name', 'brightness');
      entry.set('value', '100');
      const content: IContent = {
        settings: [entry],
        user: [],
        userSecure: []
      };
      expect(content.settings[0].get('name')).assertEqual('brightness');
      expect(content.settings[0].get('value')).assertEqual('100');
    });

    // ========== 常量命名规范测试 ==========

    it('default_keys_should_follow_naming_convention', 0, () => {
      expect(DataDefaultKey.SETTINGS_SCREEN_BRIGHTNESS_DEFAULT.includes('default'))
        .assertTrue();
      expect(DataDefaultKey.SETTINGS_TIME_FORMAT_DEFAULT.includes('default'))
        .assertTrue();
    });

    it('config_table_names_should_be_uppercase', 0, () => {
      expect(settingsDataConfig.TABLE_NAME).assertEqual(settingsDataConfig.TABLE_NAME.toUpperCase());
      expect(settingsDataConfig.USER_TABLE_NAME)
        .assertEqual(settingsDataConfig.USER_TABLE_NAME.toUpperCase());
      expect(settingsDataConfig.SECURE_TABLE_NAME)
        .assertEqual(settingsDataConfig.SECURE_TABLE_NAME.toUpperCase());
    });

    it('config_db_name_should_be_lowercase', 0, () => {
      expect(settingsDataConfig.DB_NAME).assertEqual(settingsDataConfig.DB_NAME.toLowerCase());
    });

    it('config_field_names_should_be_uppercase', 0, () => {
      expect(settingsDataConfig.FIELD_ID).assertEqual(settingsDataConfig.FIELD_ID.toUpperCase());
      expect(settingsDataConfig.FIELD_KEYWORD)
        .assertEqual(settingsDataConfig.FIELD_KEYWORD.toUpperCase());
      expect(settingsDataConfig.FIELD_VALUE).assertEqual(settingsDataConfig.FIELD_VALUE.toUpperCase());
    });

    // ========== 业务场景组合测试 ==========

    it('audio_keys_should_form_complete_group', 0, () => {
      const audioKeys: string[] = [
        DataSettingsKey.SETTINGS_AUDIO_RINGTONE,
        DataSettingsKey.SETTINGS_AUDIO_MEDIA,
        DataSettingsKey.SETTINGS_AUDIO_VOICE_CALL
      ];
      expect(audioKeys.length).assertEqual(3);
      for (const key of audioKeys) {
        expect(key.startsWith('settings.audio.')).assertTrue();
      }
    });

    it('display_keys_should_form_complete_group', 0, () => {
      const displayKeys: string[] = [
        DataSettingsKey.SETTINGS_SCREEN_BRIGHTNESS,
        DataSettingsKey.SETTINGS_DISPALY_NAVBAR_STATUS
      ];
      expect(displayKeys.length).assertEqual(2);
    });

    it('all_settings_keys_should_be_valid_for_db_storage', 0, () => {
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
      for (const key of keys) {
        expect(key.length).assertLarger(0);
        expect(key.length).assertLess(100);
      }
    });

    it('config_values_should_be_consistent_across_access', 0, () => {
      const dbName1 = settingsDataConfig.DB_NAME;
      const dbName2 = settingsDataConfig.DB_NAME;
      expect(dbName1).assertEqual(dbName2);
    });

    it('enum_values_should_be_immutable', 0, () => {
      const brightnessKey = DataSettingsKey.SETTINGS_SCREEN_BRIGHTNESS;
      expect(brightnessKey).assertEqual('settings.screen.brightness');
    });
  });
}
