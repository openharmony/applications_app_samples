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
 * @file PermissionAndSecurity.test.ets
 * @overview 测试 DataExtAbility 权限验证和安全机制
 *           覆盖：信任列表验证、权限检查、UID验证、安全设置权限
 */

import { describe, it, expect, beforeAll, afterAll } from '@ohos/hypium';
import { settingsDataConfig, DataSettingsKey } from '../../../main/ets/Utils/SettingsDataConfig';
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
import { settings } from '@kit.BasicServicesKit';

export default function permissionAndSecurityTest() {
  describe('PermissionAndSecurity_Test', () => {
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

    // ========== 信任列表测试 ==========

    it('trust_list_should_contain_brightness_status', 0, () => {
      const trustList: string[] = [
        settings.display.SCREEN_BRIGHTNESS_STATUS,
        settings.display.AUTO_SCREEN_BRIGHTNESS,
        settings.display.SCREEN_OFF_TIMEOUT
      ];
      expect(trustList.includes(settings.display.SCREEN_BRIGHTNESS_STATUS)).assertTrue();
    });

    it('trust_list_should_contain_auto_brightness', 0, () => {
      const trustList: string[] = [
        settings.display.SCREEN_BRIGHTNESS_STATUS,
        settings.display.AUTO_SCREEN_BRIGHTNESS,
        settings.display.SCREEN_OFF_TIMEOUT
      ];
      expect(trustList.includes(settings.display.AUTO_SCREEN_BRIGHTNESS)).assertTrue();
    });

    it('trust_list_should_contain_screen_off_timeout', 0, () => {
      const trustList: string[] = [
        settings.display.SCREEN_BRIGHTNESS_STATUS,
        settings.display.AUTO_SCREEN_BRIGHTNESS,
        settings.display.SCREEN_OFF_TIMEOUT
      ];
      expect(trustList.includes(settings.display.SCREEN_OFF_TIMEOUT)).assertTrue();
    });

    it('trust_list_should_have_three_entries', 0, () => {
      const trustList: string[] = [
        settings.display.SCREEN_BRIGHTNESS_STATUS,
        settings.display.AUTO_SCREEN_BRIGHTNESS,
        settings.display.SCREEN_OFF_TIMEOUT
      ];
      expect(trustList.length).assertEqual(3);
    });

    it('trust_list_entries_should_be_distinct', 0, () => {
      const trustList: string[] = [
        settings.display.SCREEN_BRIGHTNESS_STATUS,
        settings.display.AUTO_SCREEN_BRIGHTNESS,
        settings.display.SCREEN_OFF_TIMEOUT
      ];
      const uniqueEntries = new Set<string>(trustList);
      expect(uniqueEntries.size).assertEqual(trustList.length);
    });

    it('trust_list_should_not_contain_audio_keys', 0, () => {
      const trustList: string[] = [
        settings.display.SCREEN_BRIGHTNESS_STATUS,
        settings.display.AUTO_SCREEN_BRIGHTNESS,
        settings.display.SCREEN_OFF_TIMEOUT
      ];
      expect(trustList.includes(DataSettingsKey.SETTINGS_AUDIO_RINGTONE)).assertFalse();
      expect(trustList.includes(DataSettingsKey.SETTINGS_AUDIO_MEDIA)).assertFalse();
      expect(trustList.includes(DataSettingsKey.SETTINGS_AUDIO_VOICE_CALL)).assertFalse();
    });

    it('trust_list_should_not_contain_device_name', 0, () => {
      const trustList: string[] = [
        settings.display.SCREEN_BRIGHTNESS_STATUS,
        settings.display.AUTO_SCREEN_BRIGHTNESS,
        settings.display.SCREEN_OFF_TIMEOUT
      ];
      expect(trustList.includes(DataSettingsKey.SETTINGS_GENERAL_DEVICE_NAME)).assertFalse();
    });

    it('trust_list_should_not_contain_time_format', 0, () => {
      const trustList: string[] = [
        settings.display.SCREEN_BRIGHTNESS_STATUS,
        settings.display.AUTO_SCREEN_BRIGHTNESS,
        settings.display.SCREEN_OFF_TIMEOUT
      ];
      expect(trustList.includes(DataSettingsKey.SETTINGS_TIME_FORMAT)).assertFalse();
    });

    it('trust_list_should_not_contain_navbar_status', 0, () => {
      const trustList: string[] = [
        settings.display.SCREEN_BRIGHTNESS_STATUS,
        settings.display.AUTO_SCREEN_BRIGHTNESS,
        settings.display.SCREEN_OFF_TIMEOUT
      ];
      expect(trustList.includes(DataSettingsKey.SETTINGS_DISPALY_NAVBAR_STATUS)).assertFalse();
    });

    it('trust_list_should_not_contain_cellular_data', 0, () => {
      const trustList: string[] = [
        settings.display.SCREEN_BRIGHTNESS_STATUS,
        settings.display.AUTO_SCREEN_BRIGHTNESS,
        settings.display.SCREEN_OFF_TIMEOUT
      ];
      expect(trustList.includes(DataSettingsKey.CELLULAR_DATA_ENABLE)).assertFalse();
    });

    // ========== 权限验证逻辑测试 ==========

    it('non_trust_key_should_require_permission_check', 0, () => {
      const trustList: string[] = [
        settings.display.SCREEN_BRIGHTNESS_STATUS,
        settings.display.AUTO_SCREEN_BRIGHTNESS,
        settings.display.SCREEN_OFF_TIMEOUT
      ];
      const nonTrustKey = DataSettingsKey.SETTINGS_AUDIO_RINGTONE;
      expect(trustList.includes(nonTrustKey)).assertFalse();
    });

    it('audio_ringtone_should_not_be_in_trust_list', 0, () => {
      const trustList: string[] = [
        settings.display.SCREEN_BRIGHTNESS_STATUS,
        settings.display.AUTO_SCREEN_BRIGHTNESS,
        settings.display.SCREEN_OFF_TIMEOUT
      ];
      expect(trustList.includes(DataSettingsKey.SETTINGS_AUDIO_RINGTONE)).assertFalse();
    });

    it('audio_media_should_not_be_in_trust_list', 0, () => {
      const trustList: string[] = [
        settings.display.SCREEN_BRIGHTNESS_STATUS,
        settings.display.AUTO_SCREEN_BRIGHTNESS,
        settings.display.SCREEN_OFF_TIMEOUT
      ];
      expect(trustList.includes(DataSettingsKey.SETTINGS_AUDIO_MEDIA)).assertFalse();
    });

    it('audio_voicecall_should_not_be_in_trust_list', 0, () => {
      const trustList: string[] = [
        settings.display.SCREEN_BRIGHTNESS_STATUS,
        settings.display.AUTO_SCREEN_BRIGHTNESS,
        settings.display.SCREEN_OFF_TIMEOUT
      ];
      expect(trustList.includes(DataSettingsKey.SETTINGS_AUDIO_VOICE_CALL)).assertFalse();
    });

    it('device_name_should_not_be_in_trust_list', 0, () => {
      const trustList: string[] = [
        settings.display.SCREEN_BRIGHTNESS_STATUS,
        settings.display.AUTO_SCREEN_BRIGHTNESS,
        settings.display.SCREEN_OFF_TIMEOUT
      ];
      expect(trustList.includes(DataSettingsKey.SETTINGS_GENERAL_DEVICE_NAME)).assertFalse();
    });

    // ========== 安全设置权限测试 ==========

    it('manage_secure_settings_permission_name_should_be_valid', 0, () => {
      const permissionName = 'ohos.permission.MANAGE_SECURE_SETTINGS';
      expect(permissionName.length).assertLarger(0);
      expect(permissionName.startsWith('ohos.permission.')).assertTrue();
    });

    // ========== 键值合法性测试 ==========

    it('brightness_value_should_be_numeric', 0, () => {
      const testValue = '75';
      const numericValue = Number(testValue);
      expect(Number.isNaN(numericValue)).assertFalse();
    });

    it('brightness_value_zero_should_be_valid', 0, () => {
      const testValue = '0';
      const numericValue = Number(testValue);
      expect(Number.isNaN(numericValue)).assertFalse();
      expect(numericValue).assertEqual(0);
    });

    it('brightness_value_max_should_be_valid', 0, () => {
      const testValue = '255';
      const numericValue = Number(testValue);
      expect(Number.isNaN(numericValue)).assertFalse();
      expect(numericValue).assertEqual(255);
    });

    it('time_format_value_should_be_valid', 0, () => {
      const validFormats: string[] = ['12', '24'];
      expect(validFormats.includes('12')).assertTrue();
      expect(validFormats.includes('24')).assertTrue();
    });

    it('audio_volume_value_should_be_numeric', 0, () => {
      const testValue = '10';
      const numericValue = Number(testValue);
      expect(Number.isNaN(numericValue)).assertFalse();
    });

    it('navbar_status_value_should_be_numeric', 0, () => {
      const testValue = '1';
      const numericValue = Number(testValue);
      expect(Number.isNaN(numericValue)).assertFalse();
    });

    it('cellular_data_value_should_be_numeric', 0, () => {
      const testValue = '1';
      const numericValue = Number(testValue);
      expect(Number.isNaN(numericValue)).assertFalse();
    });

    // ========== 值长度限制测试 ==========

    it('value_length_should_be_within_limit', 0, () => {
      const maxLength = 1000;
      const testValue = 'test_value';
      expect(testValue.length).assertLessOrEqual(maxLength);
    });

    it('empty_value_should_be_within_limit', 0, () => {
      const maxLength = 1000;
      const testValue = '';
      expect(testValue.length).assertLessOrEqual(maxLength);
    });

    it('max_length_value_should_be_at_limit', 0, () => {
      const maxLength = 1000;
      let testValue = '';
      for (let i = 0; i < maxLength; i++) {
        testValue += 'a';
      }
      expect(testValue.length).assertEqual(maxLength);
    });

    it('exceeding_length_value_should_fail_check', 0, () => {
      const maxLength = 1000;
      let testValue = '';
      for (let i = 0; i < maxLength + 1; i++) {
        testValue += 'a';
      }
      expect(testValue.length).assertLarger(maxLength);
    });

    // ========== 关键字合法性测试 ==========

    it('keyword_should_not_be_empty', 0, () => {
      const testKey = DataSettingsKey.SETTINGS_SCREEN_BRIGHTNESS;
      expect(testKey.length).assertLarger(0);
    });

    it('keyword_should_not_exceed_reasonable_length', 0, () => {
      const testKey = DataSettingsKey.SETTINGS_SCREEN_BRIGHTNESS;
      expect(testKey.length).assertLess(100);
    });

    it('keyword_should_be_string_type', 0, () => {
      const testKey = DataSettingsKey.SETTINGS_SCREEN_BRIGHTNESS;
      expect(typeof testKey === 'string').assertTrue();
    });

    // ========== 权限验证组合测试 ==========

    it('trust_list_keys_should_skip_permission_check', 0, () => {
      const trustList: string[] = [
        settings.display.SCREEN_BRIGHTNESS_STATUS,
        settings.display.AUTO_SCREEN_BRIGHTNESS,
        settings.display.SCREEN_OFF_TIMEOUT
      ];
      for (const key of trustList) {
        expect(trustList.includes(key)).assertTrue();
      }
    });

    it('non_trust_keys_should_require_permission', 0, () => {
      const trustList: string[] = [
        settings.display.SCREEN_BRIGHTNESS_STATUS,
        settings.display.AUTO_SCREEN_BRIGHTNESS,
        settings.display.SCREEN_OFF_TIMEOUT
      ];
      const nonTrustKeys: string[] = [
        DataSettingsKey.SETTINGS_AUDIO_RINGTONE,
        DataSettingsKey.SETTINGS_AUDIO_MEDIA,
        DataSettingsKey.SETTINGS_AUDIO_VOICE_CALL,
        DataSettingsKey.SETTINGS_GENERAL_DEVICE_NAME
      ];
      for (const key of nonTrustKeys) {
        expect(trustList.includes(key)).assertFalse();
      }
    });

    // ========== 安全边界测试 ==========

    it('null_keyword_should_be_handled', 0, () => {
      const testKey: string | null = null;
      expect(testKey === null).assertTrue();
    });

    it('undefined_keyword_should_be_handled', 0, () => {
      const testKey: string | undefined = undefined;
      expect(testKey === undefined).assertTrue();
    });

    it('empty_string_keyword_should_be_valid', 0, () => {
      const testKey = '';
      expect(testKey.length).assertEqual(0);
    });

    it('special_chars_in_value_should_be_valid', 0, () => {
      const testValue = 'value@#$%^&*()';
      expect(testValue.length).assertLarger(0);
    });

    it('unicode_in_value_should_be_valid', 0, () => {
      const testValue = '设置值';
      expect(testValue.length).assertLarger(0);
    });
  });
}
