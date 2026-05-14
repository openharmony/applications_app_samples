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
export enum DataDefaultKey {
  SETTINGS_SCREEN_BRIGHTNESS_DEFAULT = 'settings.screen.brightness.default',
  SETTINGS_TIME_FORMAT_DEFAULT = 'settings.time.format.default',
  SETTINGS_AUDIO_RINGTONE_DEFAULT = 'settings.audio.ringtone.default',
  SETTINGS_AUDIO_MEDIA_DEFAULT = 'settings.audio.media.default',
  SETTINGS_AUDIO_VOICE_CALL_DEFAULT = 'settings.audio.voicecall.default',
  SETTINGS_GENERAL_DEVICE_NAME_DEFAULT = 'settings.general.device_name.default',
  SETTINGS_DISPALY_NAVBAR_STATUS_DEFAULT = 'settings.display.navigationbar_status.default',
  CELLULAR_DATA_ENABLE_DEFAULT = 'cellular_data_enable.default',
  settingDataDefaultKey = 'SettingDataDefaultKey'
}

export enum DataSettingsKey {
  SETTINGS_SCREEN_BRIGHTNESS = 'settings.screen.brightness',
  SETTINGS_TIME_FORMAT = 'settings.time.format',
  SETTINGS_AUDIO_RINGTONE = 'settings.audio.ringtone',
  SETTINGS_AUDIO_MEDIA = 'settings.audio.media',
  SETTINGS_AUDIO_VOICE_CALL = 'settings.audio.voicecall',
  SETTINGS_GENERAL_DEVICE_NAME = 'settings.general.device_name',
  SETTINGS_DISPALY_NAVBAR_STATUS = 'settings.display.navigationbar_status',
  CELLULAR_DATA_ENABLE = 'cellular_data_enable',
  settingsDataKey = 'SettingsDataKey'
}

class SettingDataType {
  public DB_NAME: string = '';
  public TABLE_NAME: string = '';
  public USER_TABLE_NAME: string = '';
  public SECURE_TABLE_NAME: string = '';
  public FIELD_ID: string = '';
  public FIELD_KEYWORD: string = '';
  public FIELD_VALUE: string = '';
}

export const settingsDataConfig: SettingDataType = {
  DB_NAME: 'settingsdata.db',
  TABLE_NAME: 'SETTINGSDATA',
  USER_TABLE_NAME: 'USER_SETTINGSDATA',
  SECURE_TABLE_NAME: 'USER_SETTINGSDATA_SECURE',
  FIELD_ID: 'ID',
  FIELD_KEYWORD: 'KEYWORD',
  FIELD_VALUE: 'VALUE',
};
