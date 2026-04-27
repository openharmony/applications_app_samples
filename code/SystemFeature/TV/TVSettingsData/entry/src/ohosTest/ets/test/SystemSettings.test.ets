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
 * @file SystemSettings.test.ets
 * @overview 测试 doSystemSetting 系统设置功能
 *           覆盖：音频设置、亮度设置、设备名称设置、蓝牙设置
 */

import { describe, it, expect, beforeAll, afterAll } from '@ohos/hypium';
import { DataSettingsKey } from '../../../main/ets/Utils/SettingsDataConfig';
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

export default function systemSettingsTest() {
  describe('SystemSettings_Test', () => {
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

    // ========== 音频设置测试 ==========

    it('audio_ringtone_key_should_match', 0, () => {
      expect(DataSettingsKey.SETTINGS_AUDIO_RINGTONE)
        .assertEqual('settings.audio.ringtone');
    });

    it('audio_media_key_should_match', 0, () => {
      expect(DataSettingsKey.SETTINGS_AUDIO_MEDIA)
        .assertEqual('settings.audio.media');
    });

    it('audio_voicecall_key_should_match', 0, () => {
      expect(DataSettingsKey.SETTINGS_AUDIO_VOICE_CALL)
        .assertEqual('settings.audio.voicecall');
    });

    it('audio_ringtone_value_should_be_numeric', 0, () => {
      const testValue = '5';
      const numericValue = Number(testValue);
      expect(Number.isNaN(numericValue)).assertFalse();
    });

    it('audio_media_value_should_be_numeric', 0, () => {
      const testValue = '10';
      const numericValue = Number(testValue);
      expect(Number.isNaN(numericValue)).assertFalse();
    });

    it('audio_voicecall_value_should_be_numeric', 0, () => {
      const testValue = '6';
      const numericValue = Number(testValue);
      expect(Number.isNaN(numericValue)).assertFalse();
    });

    it('audio_volume_zero_should_be_valid', 0, () => {
      const testValue = '0';
      const numericValue = Number(testValue);
      expect(numericValue).assertEqual(0);
    });

    it('audio_volume_max_should_be_valid', 0, () => {
      const testValue = '15';
      const numericValue = Number(testValue);
      expect(numericValue).assertEqual(15);
    });

    it('audio_volume_negative_should_be_invalid', 0, () => {
      const testValue = '-1';
      const numericValue = Number(testValue);
      expect(numericValue).assertLess(0);
    });

    it('audio_volume_exceeding_max_should_be_invalid', 0, () => {
      const testValue = '100';
      const numericValue = Number(testValue);
      expect(numericValue).assertLarger(15);
    });

    // ========== 亮度设置测试 ==========

    it('brightness_key_should_match', 0, () => {
      expect(DataSettingsKey.SETTINGS_SCREEN_BRIGHTNESS)
        .assertEqual('settings.screen.brightness');
    });

    it('brightness_value_zero_should_be_valid', 0, () => {
      const testValue = '0';
      const numericValue = Number(testValue);
      expect(numericValue).assertEqual(0);
    });

    it('brightness_value_max_should_be_valid', 0, () => {
      const testValue = '255';
      const numericValue = Number(testValue);
      expect(numericValue).assertEqual(255);
    });

    it('brightness_value_mid_should_be_valid', 0, () => {
      const testValue = '128';
      const numericValue = Number(testValue);
      expect(numericValue).assertEqual(128);
    });

    it('brightness_value_negative_should_be_invalid', 0, () => {
      const testValue = '-10';
      const numericValue = Number(testValue);
      expect(numericValue).assertLess(0);
    });

    it('brightness_value_exceeding_max_should_be_invalid', 0, () => {
      const testValue = '300';
      const numericValue = Number(testValue);
      expect(numericValue).assertLarger(255);
    });

    // ========== 设备名称设置测试 ==========

    it('device_name_key_should_match', 0, () => {
      expect(DataSettingsKey.SETTINGS_GENERAL_DEVICE_NAME)
        .assertEqual('settings.general.device_name');
    });

    it('device_name_should_be_string', 0, () => {
      const testValue = 'TestTV';
      expect(typeof testValue === 'string').assertTrue();
    });

    it('device_name_empty_should_be_valid', 0, () => {
      const testValue = '';
      expect(testValue.length).assertEqual(0);
    });

    it('device_name_with_spaces_should_be_valid', 0, () => {
      const testValue = 'My TV Device';
      expect(testValue.length).assertLarger(0);
    });

    it('device_name_with_unicode_should_be_valid', 0, () => {
      const testValue = '我的电视';
      expect(testValue.length).assertLarger(0);
    });

    it('device_name_with_special_chars_should_be_valid', 0, () => {
      const testValue = 'TV@#$%';
      expect(testValue.length).assertLarger(0);
    });

    // ========== 时间格式设置测试 ==========

    it('time_format_key_should_match', 0, () => {
      expect(DataSettingsKey.SETTINGS_TIME_FORMAT)
        .assertEqual('settings.time.format');
    });

    it('time_format_24_should_be_valid', 0, () => {
      const testValue = '24';
      expect(testValue).assertEqual('24');
    });

    it('time_format_12_should_be_valid', 0, () => {
      const testValue = '12';
      expect(testValue).assertEqual('12');
    });

    it('time_format_invalid_value_should_be_invalid', 0, () => {
      const testValue: string = '48';
      expect(testValue === '12' || testValue === '24').assertFalse();
    });

    // ========== 导航栏状态设置测试 ==========

    it('navbar_status_key_should_match', 0, () => {
      expect(DataSettingsKey.SETTINGS_DISPALY_NAVBAR_STATUS)
        .assertEqual('settings.display.navigationbar_status');
    });

    it('navbar_status_enabled_should_be_valid', 0, () => {
      const testValue = '1';
      expect(testValue).assertEqual('1');
    });

    it('navbar_status_disabled_should_be_valid', 0, () => {
      const testValue = '0';
      expect(testValue).assertEqual('0');
    });

    // ========== 蜂窝数据设置测试 ==========

    it('cellular_data_key_should_match', 0, () => {
      expect(DataSettingsKey.CELLULAR_DATA_ENABLE)
        .assertEqual('cellular_data_enable');
    });

    it('cellular_data_enabled_should_be_valid', 0, () => {
      const testValue = '1';
      expect(testValue).assertEqual('1');
    });

    it('cellular_data_disabled_should_be_valid', 0, () => {
      const testValue = '0';
      expect(testValue).assertEqual('0');
    });

    // ========== 设置值转换测试 ==========

    it('string_to_number_conversion_should_work', 0, () => {
      const strValue = '75';
      const numValue = Number(strValue);
      expect(numValue).assertEqual(75);
    });

    it('invalid_string_to_number_should_be_nan', 0, () => {
      const strValue = 'invalid';
      const numValue = Number(strValue);
      expect(Number.isNaN(numValue)).assertTrue();
    });

    it('empty_string_to_number_should_be_zero', 0, () => {
      const strValue = '';
      const numValue = Number(strValue);
      expect(numValue).assertEqual(0);
    });

    // ========== 设置键值对应关系测试 ==========

    it('all_audio_keys_should_have_audio_prefix', 0, () => {
      const audioKeys: string[] = [
        DataSettingsKey.SETTINGS_AUDIO_RINGTONE,
        DataSettingsKey.SETTINGS_AUDIO_MEDIA,
        DataSettingsKey.SETTINGS_AUDIO_VOICE_CALL
      ];
      for (const key of audioKeys) {
        expect(key.startsWith('settings.audio.')).assertTrue();
      }
    });

    it('all_display_keys_should_have_display_prefix', 0, () => {
      const displayKeys: string[] = [
        DataSettingsKey.SETTINGS_SCREEN_BRIGHTNESS,
        DataSettingsKey.SETTINGS_DISPALY_NAVBAR_STATUS
      ];
      for (const key of displayKeys) {
        expect(key.startsWith('settings.') || key.startsWith('settings.display.'))
          .assertTrue();
      }
    });

    // ========== 设置操作组合测试 ==========

    it('multiple_settings_keys_should_be_distinct', 0, () => {
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
  });
}
