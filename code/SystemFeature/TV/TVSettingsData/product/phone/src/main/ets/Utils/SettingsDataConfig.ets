/**
 * @file Describe the file
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

enum DefaultKey {
  SETTINGS_SCREEN_BRIGHTNESS_DEFAULT = 'settings.screen.brightness.default',
  SETTINGS_TIME_FORMAT_DEFAULT = 'settings.time.format.default',
  SETTINGS_AUDIO_RINGTONE_DEFAULT = 'settings.audio.ringtone.default',
  SETTINGS_AUDIO_MEDIA_DEFAULT = 'settings.audio.media.default',
  SETTINGS_AUDIO_VOICE_CALL_DEFAULT = 'settings.audio.voicecall.default',
  SETTINGS_GENERAL_DEVICE_NAME_DEFAULT = 'settings.general.device_name.default',
  SETTINGS_DISPALY_NAVBAR_STATUS_DEFAULT = 'settings.display.navigationbar_status.default',
  //饱和度
  SETTINGS_SCREEN_OUTPUTSATURATION_DEFAULT = 'settings.screen.outputSaturation.default',
  //对比度
  SETTINGS_SCREEN_OUTPUTCONTRAST_DEFAULT = 'settings.screen.outputContrast.default',
  //色调
  SETTINGS_SCREEN_DISPLAYHUE_DEFAULT = 'settings.screen.displayHue.default',
  //HDRType
  SETTINGS_SCREEN_HDRTYPE_DEFAULT = 'settings.screen.HDRType.default',
  //HDMI_adaptive
  SETTINGS_HDMI_ADAPTIVE_DEFAULT = 'settings.HDMI.adaptive.default',
  //HDMI_CEC
  SETTINGS_HDMI_CEC_DEFAULT = 'settings.HDMI.CEC.default',
  //HDMI_HDCP
  SETTINGS_HDMI_HDCP_DEFAULT = 'settings.HDMI.HDCP.default',
  //HDMI_CECRemote
  SETTINGS_HDMI_CECREMOTE_DEFAULT = 'settings.HDMI.CECRemote.default',
  //displayArea_x
  SETTINGS_DISPLAYAREA_X_DEFAULT = 'settings.displayArea.X.default',
  //displayArea_y
  SETTINGS_DISPLAYAREA_Y_DEFAULT = 'settings.displayArea.Y.default',
  //displayArea_width
  SETTINGS_DISPLAYAREA_WIDTH_DEFAULT = 'settings.displayArea.width.default',
  //displayArea_height
  SETTINGS_DISPLAYAREA_HEIGHT_DEFAULT = 'settings.displayArea.height.default',
  //displayFormat
  SETTINGS_DISPLAYFORMAT_DEFAULT = 'settings.displayFormat.default',
  //resolution
  SETTINGS_RESOLUTION_DEFAULT = 'settings.resolution.default',
};

enum SettingsKey {
  SETTINGS_SCREEN_BRIGHTNESS = 'settings.screen.brightness',
  SETTINGS_TIME_FORMAT = 'settings.time.format',
  SETTINGS_AUDIO_RINGTONE = 'settings.audio.ringtone',
  SETTINGS_AUDIO_MEDIA = 'settings.audio.media',
  SETTINGS_AUDIO_VOICE_CALL = 'settings.audio.voicecall',
  SETTINGS_GENERAL_DEVICE_NAME = 'settings.general.device_name',
  SETTINGS_DISPALY_NAVBAR_STATUS = 'settings.display.navigationbar_status',
  //饱和度
  SETTINGS_SCREEN_OUTPUTSATURATION = 'settings.screen.outputSaturation',
  //对比度
  SETTINGS_SCREEN_OUTPUTCONTRAST = 'settings.screen.outputContrast',
  //色调
  SETTINGS_SCREEN_DISPLAYHUE = 'settings.screen.displayHue',
  //HDRType
  SETTINGS_SCREEN_HDRTYPE = 'settings.screen.HDRType',
  //HDMI_adaptive
  SETTINGS_HDMI_ADAPTIVE = 'settings.HDMI.adaptive',
  //HDMI_CEC
  SETTINGS_HDMI_CEC = 'settings.HDMI.CEC',
  //HDMI_HDCP
  SETTINGS_HDMI_HDCP = 'settings.HDMI.HDCP',
  //HDMI_CECRemote
  SETTINGS_HDMI_CECREMOTE = 'settings.HDMI.CECRemote',
  //displayArea_x
  SETTINGS_DISPLAYAREA_X = 'settings.displayArea.X',
  //displayArea_y
  SETTINGS_DISPLAYAREA_Y = 'settings.displayArea.Y',
  //displayArea_width
  SETTINGS_DISPLAYAREA_WIDTH = 'settings.displayArea.width',
  //displayArea_height
  SETTINGS_DISPLAYAREA_HEIGHT = 'settings.displayArea.height',
  //displayFormat
  SETTINGS_DISPLAYFORMAT = 'settings.displayFormat',
  //resolution
  SETTINGS_RESOLUTION = 'settings.resolution'
};

const settingsDataConfig = {
  DB_NAME: 'settingsdata.db',
  TABLE_NAME: 'SETTINGSDATA',
  FIELD_ID: 'ID',
  FIELD_KEYWORD: 'KEYWORD',
  FIELD_VALUE: 'VALUE',
  DefaultKey: DefaultKey,
  SettingsKey: SettingsKey,
};

export default settingsDataConfig;
