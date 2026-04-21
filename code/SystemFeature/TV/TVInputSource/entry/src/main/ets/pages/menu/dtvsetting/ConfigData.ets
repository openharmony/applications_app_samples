/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { settings } from '@kit.BasicServicesKit';

export class ConfigData {
  public FILE_URI = '/data/accounts/account_0/applications/com.ohos.settings' +
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
  public SETTINGSDATA_BLUETOOTH = settings.wireless.BLUETOOTH_STATUS;//钃濈墮鏄惁鍙敤;
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

  // 浜害
  public SETTINGSDATA_BRIGHTNESS = settings.display.SCREEN_BRIGHTNESS_STATUS;
  // 鍥惧儚鐩稿叧
  public SETTINGSDATA_IMAGE = 'image';
  // 鎶ょ溂妯″紡
  public SETTINGSDATA_EYE = 'eye';
  // 瀵规瘮搴?  SETTINGSDATA_CONTRAST = 'contrast';
  // 浼介┈
  public SETTINGSDATA_GAMMA = 'gamma';
  // 榛戣壊绾у埆
  public SETTINGSDATA_BLACK = 'black';
  // 鍔ㄦ€佸姣斿害
  public SETTINGSDATA_DYNAMICCONTRAST = 'dynamicContrast';
  // 鍔ㄦ€佽儗鍏?  SETTINGSDATA_DYNAMICBACKLIGHT = 'dynamicBacklight';
  // 楗卞拰搴?  SETTINGSDATA_SATURATION = 'saturation';
  // 鑹茶皟
  public SETTINGSDATA_HUE = 'hue';
  // 鑹茶皟璋冭妭鏂瑰紡
  public SETTINGSDATA_COLORTEMPERATURESTYLE = 'colorTemperatureStyle';
  // 鑹叉俯鍊?鎶ょ溂)
  public SETTINGSDATA_COLORTEMPERATURE = 'colorTemperature';
  // 鑹叉俯鍊?鑷畾涔?
  public SETTINGSDATA_COLORTEMPERATURE_SEETING = 'colorTemperatureSetting';
  // 绾㈣壊娓?  SETTINGSDATA_RED = 'red';
  // 缁胯壊娓?  SETTINGSDATA_GREEN = 'green';
  // 钃濊壊娓?  SETTINGSDATA_BLUE = 'blue';
  // 閿愬埄搴?  SETTINGSDATA_SHARPNESS = 'sharpness';
  // 闅忔満闄嶅櫔
  public SETTINGSDATA_DENOISE = 'denoise';
  // MPEG闄嶅櫔
  public SETTINGSDATA_MPEGDENOISE = 'MPEGDenoise';

  //闊抽噺澶у皬
  public SETTINGSDATA_SOUND = 'sound';
  //闊虫晥
  public SETTINGSDATA_EFFECT = 'effected';
  //闊抽噺杈撳嚭璁惧
  public SETTINGSDATA_OUTPUT = 'output';
  //鎸夐敭闊?  SETTINGSDATA_ISVOLUME = 'isVolumed';

  //HDMI鑷€傚簲
  public SETTINGSDATA_HDMIADAPATIVE = 'hdmiAdaptive';
  //HDMIcec
  public SETTINGSDATA_HDMICEC = 'hdmiCec';
  //HDCP
  public SETTINGSDATA_HDCP = 'hdmiHdcp';
  //HDMIcec鍞ら啋灞忓箷
  public SETTINGSDATA_HDMICECAWAKE = 'hdmiCecawake';

  //HDMI閫夋嫨
  public SETTINGSDATA_HDMISELECT = 'hdmiSelect';
  //杈撳叆婧愬紑鍏?  SETTINGSDATA_INPUTSOURCEON = 'inputSourceOn';

  //Ipv4
  public SETTINGSDATA_IPV4 = 'manualIpv4';
  //瀛愮綉鎺╃爜
  public SETTINGSDATA_NETMASK = 'manualNetMask';
  //榛樿缃戝叧
  public SETTINGSDATA_GATEWAY = 'manualGateWay';
  //DNS鏈嶅姟鍣?  SETTINGSDATA_DNS = 'manualDns';
  //閰嶇疆缃戠粶绫诲瀷
  public SETTINGSDATA_NETTYPE = 'netType';

  //鏇村杩炴帴
  public MIRACAST_QUICK_PLAY_KEY = 'settings.wifi.miracast.quickplay';
}

let configData = new ConfigData();
export default configData as ConfigData;
