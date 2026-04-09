/**
 * Copyright (c) 2021-2022 Huawei Device Co., Ltd.
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

import settings from '@ohos.settings';

export class ConfigData {
  FILE_URI = '/data/accounts/account_0/applications/com.ohos.settings'
  + '/com.ohos.settings/assets/phone/resources/rawfile/';
  PREFERENCES_PATH = '/data/accounts/account_0/appdata/com.ohos.settings/sharedPreference/SettingPreferences';
  BRIGHTNESS_SAVE_VALUE_KEY = 'BrightnessSaveValue';

  SENT_EVENT_BROADCAST_BRIGHTNESS_VALUE = 'BRIGHTNESS_VALUE';
  SENT_EVENT_BROADCAST_VOLUME_VALUE = 'VOLUME_VALUE';
  SENT_EVENT_WIFI_CONNECT_NAME = 'WIFI_CONNECT_NAME';
  SENT_EVENT_AUDIO_RINGER_MODE = 'AUDIO_RINGER_MODE';
  SENT_EVENT_AUDIO_VOLUME_VALUE = 'AUDIO_VOLUME_VALUE';

  BRIGHTNESS_DEFAULT_VALUE = 50;
  DEFAULT_BUNDLE_NAME = 'com.ohos.settings';
  DATE_AND_TIME_YEAR = 'DATE_AND_TIME_YEAR';
  DATE_AND_TIME_MONTH = 'DATE_AND_TIME_MONTH';
  DATE_AND_TIME_DAY = 'DATE_AND_TIME_DAY';
  TAG = 'Settings ';

  // page request
  PAGE_REQUEST_CODE_KEY = 'pageRequestCode';
  PAGE_RESULT_KEY = 'pageResult';
  PAGE_RESULT_OK = -1;
  PAGE_RESULT_NG = 0;

  // password request code
  PAGE_REQUEST_CODE_PASSWORD_CREATE = 20001;
  PAGE_REQUEST_CODE_PASSWORD_CHANGE = 20003;
  PAGE_REQUEST_CODE_PASSWORD_DISABLE = 20004;

  WH_100_100 = '100%';
  WH_25_100 = '25%';
  WH_30_100 = '30%';
  WH_33_100 = '33%';
  WH_35_100 = '35%';
  WH_40_100 = '40%';
  WH_45_100 = '45%';
  WH_48_100 = '48%';
  WH_50_100 = '50%';
  WH_52_100 = '52%';
  WH_55_100 = '55%';
  WH_58_100 = '58%';
  WH_70_100 = '70%';
  WH_83_100 = '83%';
  WH_90_100 = '90%';

  GRID_CONTAINER_GUTTER_24 = 24;
  GRID_CONTAINER_MARGIN_24 = 24;

  LAYOUT_WEIGHT_1 = 1;

  value_20 = 20;
  font_20 = 20;

  MAX_LINES_1 = 1;
  MAX_LINES_2 = 2;
  MAX_LINES_3 = 3;
  DURATION_TIME = 200;
  FUNCTION_TYPE_HDC = 4;

  TIME_FORMAT_24 = "24";
  TIME_FORMAT_12 = "12";
  TIME_FORMAT_KEY = settings.date.TIME_FORMAT;
  SETTINGSDATA_DEVICE_NAME = settings.general.DEVICE_NAME;
  SETTINGSDATA_WIFI = settings.wireless.WIFI_STATUS;
  SETTINGSDATA_BLUETOOTH = settings.wireless.BLUETOOTH_STATUS;//蓝牙是否可用
  SETTINGDATA_INPUTSOURCE = settings.input.DEFAULT_INPUT_METHOD;
  SLIDER_CHANG_MODE_MOVING = 1;
  SLIDER_CHANG_MODE_END = 2;

  //Language And Region
  ADDLANGUAGES = 'addedLanguages';
  CURRENTREGION = 'currentRegion';

  //Key of StoragePath
  STORAGEPATHKEY = 'storagePath';

  //StartAbility
  FACEAUTH_BUNDLE_NAME = 'com.ohos.settings.faceauth';
  FACEAUTH_ABILITY_NAME = 'com.ohos.settings.faceauth.enrollmentstartview';
  PERMISSION_MANAGER_BUNDLE_NAME = 'com.ohos.permissionmanager';
  PERMISSION_MANAGER_ABILITY_NAME = 'com.ohos.permissionmanager.MainAbility';
  MOBILE_DATA_BUNDLE_NAME = 'com.ohos.callui';
  MOBILE_DATA_ABILITY_NAME = 'com.ohos.mobiledatasettings.MainAbility';
  SOFTWARE_UPDATES_BUNDLE_NAME = 'com.hmos.ouc';
  SOFTWARE_UPDATES_ABILITY_NAME = 'com.hmos.ouc.MainAbility';
  SECURITY_BUNDLE_NAME = 'com.ohos.certmanager';
  SECURITY_ABILITY_NAME = 'MainAbility';

  DEVICE_NAME = 'OpenHarmony 2.0 Canary';

  // 亮度
  SETTINGSDATA_BRIGHTNESS = settings.display.SCREEN_BRIGHTNESS_STATUS;
  // 图像相关
  SETTINGSDATA_IMAGE = 'image';
  // 护眼模式
  SETTINGSDATA_EYE = 'eye';
  // 对比度
  SETTINGSDATA_CONTRAST = 'contrast';
  // 伽马
  SETTINGSDATA_GAMMA = 'gamma';
  // 黑色级别
  SETTINGSDATA_BLACK = 'black';
  // 动态对比度
  SETTINGSDATA_DYNAMICCONTRAST = 'dynamicContrast';
  // 动态背光
  SETTINGSDATA_DYNAMICBACKLIGHT = 'dynamicBacklight';
  // 饱和度
  SETTINGSDATA_SATURATION = 'saturation';
  // 色调
  SETTINGSDATA_HUE = 'hue';
  // 色调调节方式
  SETTINGSDATA_COLORTEMPERATURESTYLE = 'colorTemperatureStyle';
  // 色温值(护眼)
  SETTINGSDATA_COLORTEMPERATURE = 'colorTemperature';
  // 色温值(自定义)
  SETTINGSDATA_COLORTEMPERATURE_SEETING = 'colorTemperatureSetting';
  // 红色温
  SETTINGSDATA_RED = 'red';
  // 绿色温
  SETTINGSDATA_GREEN = 'green';
  // 蓝色温
  SETTINGSDATA_BLUE = 'blue';
  // 锐利度
  SETTINGSDATA_SHARPNESS = 'sharpness';
  // 随机降噪
  SETTINGSDATA_DENOISE = 'denoise';
  // MPEG降噪
  SETTINGSDATA_MPEGDENOISE = 'MPEGDenoise';

  //音量大小
  SETTINGSDATA_SOUND = 'sound';
  //音效
  SETTINGSDATA_EFFECT = 'effected';
  //音量输出设备
  SETTINGSDATA_OUTPUT = 'output';
  //按键音
  SETTINGSDATA_ISVOLUME = 'isVolumed'

  //HDMI自适应
  SETTINGSDATA_HDMIADAPATIVE = 'hdmiAdaptive';
  //HDMIcec
  SETTINGSDATA_HDMICEC = 'hdmiCec';
  //HDCP
  SETTINGSDATA_HDCP = 'hdmiHdcp';
  //HDMIcec唤醒屏幕
  SETTINGSDATA_HDMICECAWAKE = 'hdmiCecawake';

  //HDMI选择
  SETTINGSDATA_HDMISELECT = 'hdmiSelect';
  //输入源开关
  SETTINGSDATA_INPUTSOURCEON = 'inputSourceOn';

  //机顶盒通道
  SETTINGSDATA_WATCH_TV_SOURCE = 'watchTvSource';

  //Ipv4
  SETTINGSDATA_IPV4 = 'manualIpv4';
  //子网掩码
  SETTINGSDATA_NETMASK = 'manualNetMask';
  //默认网关
  SETTINGSDATA_GATEWAY = 'manualGateWay'
  //DNS服务器
  SETTINGSDATA_DNS = 'manualDns'
  //配置网络类型
  SETTINGSDATA_NETTYPE = 'netType'

  //更多连接
  MIRACAST_QUICK_PLAY_KEY = 'settings.wifi.miracast.quickplay';
}

let configData = new ConfigData();
export default configData as ConfigData;