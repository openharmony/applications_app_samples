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
 * @file DataModelAndTypes.test.ets
 * @overview 测试数据模型和类型定义
 *           覆盖：Map操作、IContent结构、TableType枚举、数据类型转换
 */

import { describe, it, expect, beforeAll, afterAll } from '@ohos/hypium';
import { settingsDataConfig, DataSettingsKey, DataDefaultKey } from '../../../main/ets/Utils/SettingsDataConfig';
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

export default function dataModelAndTypesTest() {
  describe('DataModelAndTypes_Test', () => {
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

    // ========== Map操作测试 ==========

    it('map_set_and_get_should_return_same_value', 0, () => {
      const map: Map<string, string> = new Map<string, string>();
      map.set('test_key', 'test_value');
      expect(map.get('test_key')).assertEqual('test_value');
    });

    it('map_set_multiple_keys_should_be_independent', 0, () => {
      const map: Map<string, string> = new Map<string, string>();
      map.set('key1', 'value1');
      map.set('key2', 'value2');
      expect(map.get('key1')).assertEqual('value1');
      expect(map.get('key2')).assertEqual('value2');
    });

    it('map_overwrite_existing_key_should_update_value', 0, () => {
      const map: Map<string, string> = new Map<string, string>();
      map.set('overwrite_key', 'old_value');
      map.set('overwrite_key', 'new_value');
      expect(map.get('overwrite_key')).assertEqual('new_value');
    });

    it('map_get_nonexistent_key_should_return_undefined', 0, () => {
      const map: Map<string, string> = new Map<string, string>();
      expect(map.get('nonexistent')).assertEqual(undefined);
    });

    it('map_has_should_return_true_for_existing_key', 0, () => {
      const map: Map<string, string> = new Map<string, string>();
      map.set('has_key', 'has_value');
      expect(map.has('has_key')).assertTrue();
    });

    it('map_has_should_return_false_for_nonexistent_key', 0, () => {
      const map: Map<string, string> = new Map<string, string>();
      expect(map.has('nonexistent')).assertFalse();
    });

    it('map_delete_should_return_true', 0, () => {
      const map: Map<string, string> = new Map<string, string>();
      map.set('delete_key', 'delete_value');
      const result = map.delete('delete_key');
      expect(result).assertTrue();
    });

    it('map_delete_nonexistent_should_return_false', 0, () => {
      const map: Map<string, string> = new Map<string, string>();
      const result = map.delete('nonexistent');
      expect(result).assertFalse();
    });

    it('map_size_should_reflect_entry_count', 0, () => {
      const map: Map<string, string> = new Map<string, string>();
      map.set('size_key1', 'size_value1');
      map.set('size_key2', 'size_value2');
      map.set('size_key3', 'size_value3');
      expect(map.size).assertEqual(3);
    });

    it('map_clear_should_remove_all_entries', 0, () => {
      const map: Map<string, string> = new Map<string, string>();
      map.set('clear_key1', 'clear_value1');
      map.set('clear_key2', 'clear_value2');
      map.clear();
      expect(map.size).assertEqual(0);
    });

    it('map_forEach_should_iterate_all_entries', 0, () => {
      const map: Map<string, string> = new Map<string, string>();
      map.set('foreach_key1', 'foreach_value1');
      map.set('foreach_key2', 'foreach_value2');
      let count = 0;
      map.forEach((value: string, key: string) => {
        count++;
      });
      expect(count).assertEqual(2);
    });

    it('map_with_settings_data_should_work', 0, () => {
      const map: Map<string, string> = new Map<string, string>();
      map.set(DataSettingsKey.SETTINGS_SCREEN_BRIGHTNESS, '100');
      map.set(DataSettingsKey.SETTINGS_TIME_FORMAT, '24');
      expect(map.get(DataSettingsKey.SETTINGS_SCREEN_BRIGHTNESS)).assertEqual('100');
      expect(map.get(DataSettingsKey.SETTINGS_TIME_FORMAT)).assertEqual('24');
    });

    it('map_with_audio_settings_should_work', 0, () => {
      const map: Map<string, string> = new Map<string, string>();
      map.set(DataSettingsKey.SETTINGS_AUDIO_RINGTONE, '5');
      map.set(DataSettingsKey.SETTINGS_AUDIO_MEDIA, '10');
      map.set(DataSettingsKey.SETTINGS_AUDIO_VOICE_CALL, '6');
      expect(map.size).assertEqual(3);
    });

    it('map_with_empty_key_should_work', 0, () => {
      const map: Map<string, string> = new Map<string, string>();
      map.set('', 'empty_key_value');
      expect(map.get('')).assertEqual('empty_key_value');
    });

    it('map_with_special_chars_key_should_work', 0, () => {
      const map: Map<string, string> = new Map<string, string>();
      map.set('key@#$%', 'special_value');
      expect(map.get('key@#$%')).assertEqual('special_value');
    });

    it('map_with_unicode_key_should_work', 0, () => {
      const map: Map<string, string> = new Map<string, string>();
      map.set('设置键', '设置值');
      expect(map.get('设置键')).assertEqual('设置值');
    });

    // ========== IContent结构测试 ==========

    it('icontent_create_with_empty_arrays', 0, () => {
      const content: IContent = {
        settings: [],
        user: [],
        userSecure: []
      };
      expect(content.settings.length).assertEqual(0);
      expect(content.user.length).assertEqual(0);
      expect(content.userSecure.length).assertEqual(0);
    });

    it('icontent_create_with_single_settings_entry', 0, () => {
      const entry: Map<string, string> = new Map<string, string>();
      entry.set('name', 'single_key');
      entry.set('value', 'single_value');
      const content: IContent = {
        settings: [entry],
        user: [],
        userSecure: []
      };
      expect(content.settings.length).assertEqual(1);
      expect(content.settings[0].get('name')).assertEqual('single_key');
    });

    it('icontent_create_with_multiple_settings_entries', 0, () => {
      const entry1: Map<string, string> = new Map<string, string>();
      entry1.set('name', 'key1');
      entry1.set('value', 'value1');
      const entry2: Map<string, string> = new Map<string, string>();
      entry2.set('name', 'key2');
      entry2.set('value', 'value2');
      const content: IContent = {
        settings: [entry1, entry2],
        user: [],
        userSecure: []
      };
      expect(content.settings.length).assertEqual(2);
    });

    it('icontent_create_with_user_entries', 0, () => {
      const userEntry: Map<string, string> = new Map<string, string>();
      userEntry.set('name', 'user_key');
      userEntry.set('value', 'user_value');
      const content: IContent = {
        settings: [],
        user: [userEntry],
        userSecure: []
      };
      expect(content.user.length).assertEqual(1);
      expect(content.user[0].get('name')).assertEqual('user_key');
    });

    it('icontent_create_with_secure_entries', 0, () => {
      const secureEntry: Map<string, string> = new Map<string, string>();
      secureEntry.set('name', 'secure_key');
      secureEntry.set('value', 'secure_value');
      const content: IContent = {
        settings: [],
        user: [],
        userSecure: [secureEntry]
      };
      expect(content.userSecure.length).assertEqual(1);
    });

    it('icontent_create_with_all_types', 0, () => {
      const settingsEntry: Map<string, string> = new Map<string, string>();
      settingsEntry.set('name', 'settings_key');
      settingsEntry.set('value', 'settings_value');
      const userEntry: Map<string, string> = new Map<string, string>();
      userEntry.set('name', 'user_key');
      userEntry.set('value', 'user_value');
      const secureEntry: Map<string, string> = new Map<string, string>();
      secureEntry.set('name', 'secure_key');
      secureEntry.set('value', 'secure_value');
      const content: IContent = {
        settings: [settingsEntry],
        user: [userEntry],
        userSecure: [secureEntry]
      };
      expect(content.settings.length).assertEqual(1);
      expect(content.user.length).assertEqual(1);
      expect(content.userSecure.length).assertEqual(1);
    });

    it('icontent_settings_array_push_should_work', 0, () => {
      const content: IContent = {
        settings: [],
        user: [],
        userSecure: []
      };
      const entry: Map<string, string> = new Map<string, string>();
      entry.set('name', 'pushed_key');
      entry.set('value', 'pushed_value');
      content.settings.push(entry);
      expect(content.settings.length).assertEqual(1);
    });

    it('icontent_user_array_push_should_work', 0, () => {
      const content: IContent = {
        settings: [],
        user: [],
        userSecure: []
      };
      const entry: Map<string, string> = new Map<string, string>();
      entry.set('name', 'user_pushed_key');
      entry.set('value', 'user_pushed_value');
      content.user.push(entry);
      expect(content.user.length).assertEqual(1);
    });

    it('icontent_secure_array_push_should_work', 0, () => {
      const content: IContent = {
        settings: [],
        user: [],
        userSecure: []
      };
      const entry: Map<string, string> = new Map<string, string>();
      entry.set('name', 'secure_pushed_key');
      entry.set('value', 'secure_pushed_value');
      content.userSecure.push(entry);
      expect(content.userSecure.length).assertEqual(1);
    });

    it('icontent_large_content_should_work', 0, () => {
      const settingsEntries: Map<string, string>[] = [];
      for (let i = 0; i < 50; i++) {
        const entry: Map<string, string> = new Map<string, string>();
        entry.set('name', 'large_key_' + i);
        entry.set('value', 'large_value_' + i);
        settingsEntries.push(entry);
      }
      const content: IContent = {
        settings: settingsEntries,
        user: [],
        userSecure: []
      };
      expect(content.settings.length).assertEqual(50);
    });

    // ========== TableType枚举测试 ==========

    it('table_type_settings_value', 0, () => {
      expect(TableType.SETTINGS).assertEqual(0);
    });

    it('table_type_user_value', 0, () => {
      expect(TableType.USER).assertEqual(1);
    });

    it('table_type_user_secure_value', 0, () => {
      expect(TableType.USER_SECURE).assertEqual(2);
    });

    it('table_type_settings_is_number', 0, () => {
      expect(typeof TableType.SETTINGS === 'number').assertTrue();
    });

    it('table_type_user_is_number', 0, () => {
      expect(typeof TableType.USER === 'number').assertTrue();
    });

    it('table_type_user_secure_is_number', 0, () => {
      expect(typeof TableType.USER_SECURE === 'number').assertTrue();
    });

    it('table_type_all_distinct', 0, () => {
      const types: number[] = [
        TableType.SETTINGS,
        TableType.USER,
        TableType.USER_SECURE
      ];
      const uniqueTypes = new Set<number>(types);
      expect(uniqueTypes.size).assertEqual(types.length);
    });

    it('table_type_settings_less_than_user', 0, () => {
      expect(TableType.SETTINGS).assertLess(TableType.USER);
    });

    it('table_type_user_less_than_user_secure', 0, () => {
      expect(TableType.USER).assertLess(TableType.USER_SECURE);
    });

    it('table_type_invalid_value_not_equal_settings', 0, () => {
      const invalidType: number = 999;
      expect(invalidType === TableType.SETTINGS).assertFalse();
    });

    it('table_type_invalid_value_not_equal_user', 0, () => {
      const invalidType: number = 999;
      expect(invalidType === TableType.USER).assertFalse();
    });

    it('table_type_invalid_value_not_equal_user_secure', 0, () => {
      const invalidType: number = 999;
      expect(invalidType === TableType.USER_SECURE).assertFalse();
    });

    it('table_type_negative_value_not_valid', 0, () => {
      const negativeType: number = -1;
      expect(negativeType === TableType.SETTINGS).assertFalse();
      expect(negativeType === TableType.USER).assertFalse();
      expect(negativeType === TableType.USER_SECURE).assertFalse();
    });

    // ========== 数据类型转换测试 ==========

    it('string_to_number_conversion_valid', 0, () => {
      const strValue = '123';
      const numValue = Number(strValue);
      expect(numValue).assertEqual(123);
    });

    it('string_to_number_conversion_invalid', 0, () => {
      const strValue = 'abc';
      const numValue = Number(strValue);
      expect(Number.isNaN(numValue)).assertTrue();
    });

    it('number_to_string_conversion', 0, () => {
      const numValue = 456;
      const strValue = numValue.toString();
      expect(strValue).assertEqual('456');
    });

    it('boolean_to_string_conversion', 0, () => {
      const boolValue = true;
      const strValue = boolValue.toString();
      expect(strValue).assertEqual('true');
    });

    it('string_to_boolean_conversion', 0, () => {
      const strValue = 'true';
      const boolValue = strValue === 'true';
      expect(boolValue).assertTrue();
    });

    it('empty_string_to_number', 0, () => {
      const strValue = '';
      const numValue = Number(strValue);
      expect(numValue).assertEqual(0);
    });

    it('float_string_to_number', 0, () => {
      const strValue = '3.14';
      const numValue = Number(strValue);
      expect(numValue).assertEqual(3.14);
    });

    it('negative_string_to_number', 0, () => {
      const strValue = '-100';
      const numValue = Number(strValue);
      expect(numValue).assertEqual(-100);
    });

    it('scientific_notation_to_number', 0, () => {
      const strValue = '1e5';
      const numValue = Number(strValue);
      expect(numValue).assertEqual(100000);
    });

    it('hex_string_to_number', 0, () => {
      const strValue = '0xFF';
      const numValue = Number(strValue);
      expect(numValue).assertEqual(255);
    });

    // ========== 组合测试 ==========

    it('map_and_icontent_integration', 0, () => {
      const settingsMap: Map<string, string> = new Map<string, string>();
      settingsMap.set('name', 'integration_key');
      settingsMap.set('value', 'integration_value');
      const content: IContent = {
        settings: [settingsMap],
        user: [],
        userSecure: []
      };
      expect(content.settings[0].get('name')).assertEqual('integration_key');
    });

    it('map_and_tabletype_integration', 0, () => {
      const map: Map<string, string> = new Map<string, string>();
      map.set('table_type', TableType.SETTINGS.toString());
      expect(map.get('table_type')).assertEqual('0');
    });

    it('icontent_and_tabletype_integration', 0, () => {
      const content: IContent = {
        settings: [],
        user: [],
        userSecure: []
      };
      const tableType = TableType.SETTINGS;
      expect(tableType).assertEqual(0);
      expect(content.settings.length).assertEqual(0);
    });
  });
}
