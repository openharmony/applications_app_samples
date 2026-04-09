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

import settings from '@ohos.settings';

export class ConfigData {
  public FILE_URI =
    '/data/accounts/account_0/applications/com.ohos.settings' +
    '/com.ohos.settings/assets/phone/resources/rawfile/';
  public PREFERENCES_PATH = '/data/accounts/account_0/appdata/com.ohos.settings/sharedPreference/SettingPreferences';
  public BRIGHTNESS_SAVE_VALUE_KEY = 'BrightnessSaveValue';

  public SENT_EVENT_BROADCAST_BRIGHTNESS_VALUE = 'BRIGHTNESS_VALUE';
  public SENT_EVENT_BROADCAST_VOLUME_VALUE = 'VOLUME_VALUE';
  public SENT_EVENT_WIFI_CONNECT_NAME = 'WIFI_CONNECT_NAME';
  public SENT_EVENT_AUDIO_RINGER_MODE = 'AUDIO_RINGER_MODE';
  public SENT_EVENT_AUDIO_VOLUME_VALUE = 'AUDIO_VOLUME_VALUE';

  public BRIGHTNESS_DEFAULT_VALUE = 50;
  public DEFAULT_BUNDLE_NAME = 'com.ohos.settings';
  public DATE_AND_TIME_YEAR = 'DATE_AND_TIME_YEAR';
  public DATE_AND_TIME_MONTH = 'DATE_AND_TIME_MONTH';
  public DATE_AND_TIME_DAY = 'DATE_AND_TIME_DAY';
  public TAG = 'Settings ';

  // page request
  public PAGE_REQUEST_CODE_KEY = 'pageRequestCode';
  public PAGE_RESULT_KEY = 'pageResult';
  public PAGE_RESULT_OK = -1;
  public PAGE_RESULT_NG = 0;

  // password request code
  public PAGE_REQUEST_CODE_PASSWORD_CREATE = 20001;
  public PAGE_REQUEST_CODE_PASSWORD_CHANGE = 20003;
  public PAGE_REQUEST_CODE_PASSWORD_DISABLE = 20004;

  public WH_100_100 = '100%';
  public WH_25_100 = '25%';
  public WH_30_100 = '30%';
  public WH_33_100 = '33%';
  public WH_35_100 = '35%';
  public WH_40_100 = '40%';
  public WH_45_100 = '45%';
  public WH_48_100 = '48%';
  public WH_50_100 = '50%';
  public WH_52_100 = '52%';
  public WH_55_100 = '55%';
  public WH_58_100 = '58%';
  public WH_70_100 = '70%';
  public WH_83_100 = '83%';
  public WH_90_100 = '90%';

  public GRID_CONTAINER_GUTTER_24 = 24;
  public GRID_CONTAINER_MARGIN_24 = 24;

  public LAYOUT_WEIGHT_1 = 1;

  public value_20 = 20;
  public font_20 = 20;

  public MAX_LINES_1 = 1;
  public MAX_LINES_2 = 2;
  public MAX_LINES_3 = 3;
  public DURATION_TIME = 200;
  public FUNCTION_TYPE_HDC = 4;

  public TIME_FORMAT_24 = '24';
  public TIME_FORMAT_12 = '12';
  public TIME_FORMAT_KEY = settings.date.TIME_FORMAT;
  public SETTINGSDATA_DEVICE_NAME = settings.general.DEVICE_NAME;
  public SETTINGSDATA_WIFI = settings.wireless.WIFI_STATUS;
  public SETTINGSDATA_BLUETOOTH = settings.wireless.BLUETOOTH_STATUS;//蓝牙是否可用
  public SETTINGDATA_INPUTSOURCE = settings.input.DEFAULT_INPUT_METHOD;
  public SLIDER_CHANG_MODE_MOVING = 1;
  public SLIDER_CHANG_MODE_END = 2;

  //Language And Region
  public ADDLANGUAGES = 'addedLanguages';
  public CURRENTREGION = 'currentRegion';

  //Key of StoragePath
  public STORAGEPATHKEY = 'storagePath';

  //StartAbility
  public FACEAUTH_BUNDLE_NAME = 'com.ohos.settings.faceauth';
  public FACEAUTH_ABILITY_NAME = 'com.ohos.settings.faceauth.enrollmentstartview';
  public PERMISSION_MANAGER_BUNDLE_NAME = 'com.ohos.permissionmanager';
  public PERMISSION_MANAGER_ABILITY_NAME = 'com.ohos.permissionmanager.MainAbility';
  public MOBILE_DATA_BUNDLE_NAME = 'com.ohos.callui';
  public MOBILE_DATA_ABILITY_NAME = 'com.ohos.mobiledatasettings.MainAbility';
  public SOFTWARE_UPDATES_BUNDLE_NAME = 'com.hmos.ouc';
  public SOFTWARE_UPDATES_ABILITY_NAME = 'com.hmos.ouc.MainAbility';
  public SECURITY_BUNDLE_NAME = 'com.ohos.certmanager';
  public SECURITY_ABILITY_NAME = 'MainAbility';

  public DEVICE_NAME = 'OpenHarmony 2.0 Canary';

  // 亮度
  public SETTINGSDATA_BRIGHTNESS = settings.display.SCREEN_BRIGHTNESS_STATUS;
  // 图像相关
  public SETTINGSDATA_IMAGE = 'image';
  // 护眼模式
  public SETTINGSDATA_EYE = 'eye';
  // 对比度
  public SETTINGSDATA_CONTRAST = 'contrast';
  // 伽马
  public SETTINGSDATA_GAMMA = 'gamma';
  // 黑色级别
  public SETTINGSDATA_BLACK = 'black';
  // 动态对比度
  public SETTINGSDATA_DYNAMICCONTRAST = 'dynamicContrast';
  // 动态背光
  public SETTINGSDATA_DYNAMICBACKLIGHT = 'dynamicBacklight';
  // 饱和度
  public SETTINGSDATA_SATURATION = 'saturation';
  // 色调
  public SETTINGSDATA_HUE = 'hue';
  // 色调调节方式
  public SETTINGSDATA_COLORTEMPERATURESTYLE = 'colorTemperatureStyle';
  // 色温值(护眼)
  public SETTINGSDATA_COLORTEMPERATURE = 'colorTemperature';
  // 色温值(自定义)
  public SETTINGSDATA_COLORTEMPERATURE_SEETING = 'colorTemperatureSetting';
  // 红色温
  public SETTINGSDATA_RED = 'red';
  // 绿色温
  public SETTINGSDATA_GREEN = 'green';
  // 蓝色温
  public SETTINGSDATA_BLUE = 'blue';
  // 锐利度
  public SETTINGSDATA_SHARPNESS = 'sharpness';
  // 随机降噪
  public SETTINGSDATA_DENOISE = 'denoise';
  // MPEG降噪
  public SETTINGSDATA_MPEGDENOISE = 'MPEGDenoise';

  //音量大小
  public SETTINGSDATA_SOUND = 'sound';
  //音效
  public SETTINGSDATA_EFFECT = 'effected';
  //音量输出设备
  public SETTINGSDATA_OUTPUT = 'output';
  //按键音
  public SETTINGSDATA_ISVOLUME = 'isVolumed'

  //HDMI自适应
  public SETTINGSDATA_HDMIADAPATIVE = 'hdmiAdaptive';
  //HDMIcec
  public SETTINGSDATA_HDMICEC = 'hdmiCec';
  //HDCP
  public SETTINGSDATA_HDCP = 'hdmiHdcp';
  //HDMIcec唤醒屏幕
  public SETTINGSDATA_HDMICECAWAKE = 'hdmiCecawake';

  //HDMI选择
  public SETTINGSDATA_HDMISELECT = 'hdmiSelect';
  //输入源开关
  public SETTINGSDATA_INPUTSOURCEON = 'inputSourceOn';

  //机顶盒通道
  public SETTINGSDATA_WATCH_TV_SOURCE = 'watchTvSource';

  //Ipv4
  public SETTINGSDATA_IPV4 = 'manualIpv4';
  //子网掩码
  public SETTINGSDATA_NETMASK = 'manualNetMask';
  //默认网关
  public SETTINGSDATA_GATEWAY = 'manualGateWay'
  //DNS服务器
  public SETTINGSDATA_DNS = 'manualDns'
  //配置网络类型
  public SETTINGSDATA_NETTYPE = 'netType'

  //更多连接
  public MIRACAST_QUICK_PLAY_KEY = 'settings.wifi.miracast.quickplay';
}

let configData = new ConfigData();
export default configData as ConfigData;