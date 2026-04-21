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

import { describe, it, expect, beforeEach, afterEach } from '@ohos/hypium';
import { ConfigData } from '../../../main/ets/common/ConfigData';
import { ConfigData as MenuConfigData } from '../../../main/ets/pages/menu/dtvsetting/ConfigData';

const WH_100_PERCENT = '100%';
const BRIGHTNESS_DEFAULT = 50;
const DURATION_TIME = 200;
const LAYOUT_WEIGHT_1 = 1;

function hasOwnField(target: Object, key: string): boolean {
  return Object.keys(target).indexOf(key) !== -1;
}

class ConfigDataLifecycle {
  public commonConfig: ConfigData;
  public menuConfig: MenuConfigData;

  constructor() {
    this.commonConfig = new ConfigData();
    this.menuConfig = new MenuConfigData();
  }

  getCommonFileUri(): string {
    return this.commonConfig.FILE_URI;
  }

  getMenuFileUri(): string {
    return this.menuConfig.FILE_URI;
  }

  getCommonPreferencesPath(): string {
    return this.commonConfig.PREFERENCES_PATH;
  }

  getMenuPreferencesPath(): string {
    return this.menuConfig.PREFERENCES_PATH;
  }

  getCommonBrightnessSaveKey(): string {
    return this.commonConfig.BRIGHTNESS_SAVE_VALUE_KEY;
  }

  getMenuBrightnessSaveKey(): string {
    return this.menuConfig.BRIGHTNESS_SAVE_VALUE_KEY;
  }

  getCommonWidthPercent100(): string {
    return this.commonConfig.WH_100_100;
  }

  getMenuWidthPercent100(): string {
    return this.menuConfig.WH_100_100;
  }

  getCommonBrightnessDefault(): number {
    return this.commonConfig.BRIGHTNESS_DEFAULT_VALUE;
  }

  getMenuBrightnessDefault(): number {
    return this.menuConfig.BRIGHTNESS_DEFAULT_VALUE;
  }

  getCommonTag(): string {
    return this.commonConfig.TAG;
  }

  getMenuTag(): string {
    return this.menuConfig.TAG;
  }

  hasCommonWifiConnectName(): boolean {
    return hasOwnField(this.commonConfig as Object, 'SENT_EVENT_WIFI_CONNECT_NAME');
  }

  hasMenuWifiConnectName(): boolean {
    return hasOwnField(this.menuConfig as Object, 'SENT_EVENT_WIFI_CONNECT_NAME');
  }

  getCommonGridGutter(): number {
    return this.commonConfig.GRID_CONTAINER_GUTTER_24;
  }

  getMenuGridGutter(): number {
    return this.menuConfig.GRID_CONTAINER_GUTTER_24;
  }

  getCommonGridMargin(): number {
    return this.commonConfig.GRID_CONTAINER_MARGIN_24;
  }

  getMenuGridMargin(): number {
    return this.menuConfig.GRID_CONTAINER_MARGIN_24;
  }

  getCommonDurationTime(): number {
    return this.commonConfig.DURATION_TIME;
  }

  getMenuDurationTime(): number {
    return this.menuConfig.DURATION_TIME;
  }

  getCommonLayoutWeight(): number {
    return this.commonConfig.LAYOUT_WEIGHT_1;
  }

  getMenuLayoutWeight(): number {
    return this.menuConfig.LAYOUT_WEIGHT_1;
  }
}

describe('ConfigData_FileUri_Consistency_Test', () => {
  let lifecycle: ConfigDataLifecycle;

  beforeEach(() => {
    lifecycle = new ConfigDataLifecycle();
  });

  afterEach(() => {
  });

  it('should_common_config_have_valid_file_uri', 0, () => {
    expect(lifecycle.getCommonFileUri().length).assertLarger(0);
  });

  it('should_menu_config_have_valid_file_uri', 0, () => {
    expect(lifecycle.getMenuFileUri().length).assertLarger(0);
  });

  it('should_both_configs_have_identical_file_uri', 0, () => {
    expect(lifecycle.getCommonFileUri()).assertEqual(lifecycle.getMenuFileUri());
  });

  it('should_file_uri_contain_settings_bundle_path', 0, () => {
    const uri = lifecycle.getCommonFileUri();
    expect(uri.includes('com.ohos.settings')).assertEqual(true);
  });

  it('should_file_uri_contain_phone_resources_path', 0, () => {
    const uri = lifecycle.getCommonFileUri();
    expect(uri.includes('phone/resources/rawfile')).assertEqual(true);
  });
});

describe('ConfigData_PreferencesPath_Consistency_Test', () => {
  let lifecycle: ConfigDataLifecycle;

  beforeEach(() => {
    lifecycle = new ConfigDataLifecycle();
  });

  afterEach(() => {
  });

  it('should_common_config_have_valid_preferences_path', 0, () => {
    expect(lifecycle.getCommonPreferencesPath().length).assertLarger(0);
  });

  it('should_menu_config_have_valid_preferences_path', 0, () => {
    expect(lifecycle.getMenuPreferencesPath().length).assertLarger(0);
  });

  it('should_both_configs_have_identical_preferences_path', 0, () => {
    expect(lifecycle.getCommonPreferencesPath()).assertEqual(lifecycle.getMenuPreferencesPath());
  });

  it('should_preferences_path_contain_account_0', 0, () => {
    const path = lifecycle.getCommonPreferencesPath();
    expect(path.includes('account_0')).assertEqual(true);
  });

  it('should_preferences_path_contain_settings_appdata', 0, () => {
    const path = lifecycle.getCommonPreferencesPath();
    expect(path.includes('com.ohos.settings')).assertEqual(true);
  });

  it('should_preferences_path_end_with_sharedPreference', 0, () => {
    const path = lifecycle.getCommonPreferencesPath();
    expect(path.endsWith('sharedPreference')).assertEqual(true);
  });
});

describe('ConfigData_Brightness_Consistency_Test', () => {
  let lifecycle: ConfigDataLifecycle;

  beforeEach(() => {
    lifecycle = new ConfigDataLifecycle();
  });

  afterEach(() => {
  });

  it('should_common_config_have_brightness_save_key', 0, () => {
    expect(lifecycle.getCommonBrightnessSaveKey().length).assertLarger(0);
  });

  it('should_menu_config_have_brightness_save_key', 0, () => {
    expect(lifecycle.getMenuBrightnessSaveKey().length).assertLarger(0);
  });

  it('should_both_configs_have_identical_brightness_save_key', 0, () => {
    expect(lifecycle.getCommonBrightnessSaveKey()).assertEqual(lifecycle.getMenuBrightnessSaveKey());
  });

  it('should_common_config_brightness_default_be_50', 0, () => {
    expect(lifecycle.getCommonBrightnessDefault()).assertEqual(BRIGHTNESS_DEFAULT);
  });

  it('should_menu_config_brightness_default_be_50', 0, () => {
    expect(lifecycle.getMenuBrightnessDefault()).assertEqual(BRIGHTNESS_DEFAULT);
  });

  it('should_both_configs_have_identical_brightness_default', 0, () => {
    expect(lifecycle.getCommonBrightnessDefault()).assertEqual(lifecycle.getMenuBrightnessDefault());
  });
});

describe('ConfigData_WidthPercent_Consistency_Test', () => {
  let lifecycle: ConfigDataLifecycle;

  beforeEach(() => {
    lifecycle = new ConfigDataLifecycle();
  });

  afterEach(() => {
  });

  it('should_common_config_wh_100_100_be_100_percent', 0, () => {
    expect(lifecycle.getCommonWidthPercent100()).assertEqual(WH_100_PERCENT);
  });

  it('should_menu_config_wh_100_100_be_100_percent', 0, () => {
    expect(lifecycle.getMenuWidthPercent100()).assertEqual(WH_100_PERCENT);
  });

  it('should_both_configs_have_identical_wh_100_100', 0, () => {
    expect(lifecycle.getCommonWidthPercent100()).assertEqual(lifecycle.getMenuWidthPercent100());
  });

  it('should_common_config_have_multiple_width_percentages', 0, () => {
    const config = new ConfigData();
    expect(config.WH_25_100).assertEqual('25%');
    expect(config.WH_30_100).assertEqual('30%');
    expect(config.WH_50_100).assertEqual('50%');
  });

  it('should_menu_config_have_multiple_width_percentages', 0, () => {
    const config = new MenuConfigData();
    expect(config.WH_25_100).assertEqual('25%');
    expect(config.WH_30_100).assertEqual('30%');
    expect(config.WH_50_100).assertEqual('50%');
  });
});

describe('ConfigData_Grid_Consistency_Test', () => {
  let lifecycle: ConfigDataLifecycle;

  beforeEach(() => {
    lifecycle = new ConfigDataLifecycle();
  });

  afterEach(() => {
  });

  it('should_common_config_grid_gutter_be_24', 0, () => {
    expect(lifecycle.getCommonGridGutter()).assertEqual(24);
  });

  it('should_menu_config_grid_gutter_be_24', 0, () => {
    expect(lifecycle.getMenuGridGutter()).assertEqual(24);
  });

  it('should_both_configs_have_identical_grid_gutter', 0, () => {
    expect(lifecycle.getCommonGridGutter()).assertEqual(lifecycle.getMenuGridGutter());
  });

  it('should_common_config_grid_margin_be_24', 0, () => {
    expect(lifecycle.getCommonGridMargin()).assertEqual(24);
  });

  it('should_menu_config_grid_margin_be_24', 0, () => {
    expect(lifecycle.getMenuGridMargin()).assertEqual(24);
  });

  it('should_both_configs_have_identical_grid_margin', 0, () => {
    expect(lifecycle.getCommonGridMargin()).assertEqual(lifecycle.getMenuGridMargin());
  });
});

describe('ConfigData_Layout_Consistency_Test', () => {
  let lifecycle: ConfigDataLifecycle;

  beforeEach(() => {
    lifecycle = new ConfigDataLifecycle();
  });

  afterEach(() => {
  });

  it('should_common_config_layout_weight_be_1', 0, () => {
    expect(lifecycle.getCommonLayoutWeight()).assertEqual(LAYOUT_WEIGHT_1);
  });

  it('should_menu_config_layout_weight_be_1', 0, () => {
    expect(lifecycle.getMenuLayoutWeight()).assertEqual(LAYOUT_WEIGHT_1);
  });

  it('should_both_configs_have_identical_layout_weight', 0, () => {
    expect(lifecycle.getCommonLayoutWeight()).assertEqual(lifecycle.getMenuLayoutWeight());
  });

  it('should_common_config_value_20_be_20', 0, () => {
    expect(new ConfigData().value_20).assertEqual(20);
  });

  it('should_menu_config_value_20_be_20', 0, () => {
    expect(new MenuConfigData().value_20).assertEqual(20);
  });

  it('should_common_config_font_20_be_20', 0, () => {
    expect(new ConfigData().font_20).assertEqual(20);
  });

  it('should_menu_config_font_20_be_20', 0, () => {
    expect(new MenuConfigData().font_20).assertEqual(20);
  });
});

describe('ConfigData_Duration_Consistency_Test', () => {
  let lifecycle: ConfigDataLifecycle;

  beforeEach(() => {
    lifecycle = new ConfigDataLifecycle();
  });

  afterEach(() => {
  });

  it('should_common_config_duration_time_be_200', 0, () => {
    expect(lifecycle.getCommonDurationTime()).assertEqual(DURATION_TIME);
  });

  it('should_menu_config_duration_time_be_200', 0, () => {
    expect(lifecycle.getMenuDurationTime()).assertEqual(DURATION_TIME);
  });

  it('should_both_configs_have_identical_duration_time', 0, () => {
    expect(lifecycle.getCommonDurationTime()).assertEqual(lifecycle.getMenuDurationTime());
  });
});

describe('ConfigData_PageRequest_Consistency_Test', () => {
  let lifecycle: ConfigDataLifecycle;

  beforeEach(() => {
    lifecycle = new ConfigDataLifecycle();
  });

  afterEach(() => {
  });

  it('should_common_config_page_request_code_key', 0, () => {
    const config = new ConfigData();
    expect(config.PAGE_REQUEST_CODE_KEY).assertEqual('pageRequestCode');
  });

  it('should_menu_config_page_request_code_key', 0, () => {
    const config = new MenuConfigData();
    expect(config.PAGE_REQUEST_CODE_KEY).assertEqual('pageRequestCode');
  });

  it('should_common_config_page_result_key', 0, () => {
    const config = new ConfigData();
    expect(config.PAGE_RESULT_KEY).assertEqual('pageResult');
  });

  it('should_menu_config_page_result_key', 0, () => {
    const config = new MenuConfigData();
    expect(config.PAGE_RESULT_KEY).assertEqual('pageResult');
  });

  it('should_common_config_page_result_ok_be_minus1', 0, () => {
    const config = new ConfigData();
    expect(config.PAGE_RESULT_OK).assertEqual(-1);
  });

  it('should_menu_config_page_result_ok_be_minus1', 0, () => {
    const config = new MenuConfigData();
    expect(config.PAGE_RESULT_OK).assertEqual(-1);
  });

  it('should_common_config_page_result_ng_be_0', 0, () => {
    const config = new ConfigData();
    expect(config.PAGE_RESULT_NG).assertEqual(0);
  });

  it('should_menu_config_page_result_ng_be_0', 0, () => {
    const config = new MenuConfigData();
    expect(config.PAGE_RESULT_NG).assertEqual(0);
  });
});

describe('ConfigData_PasswordRequest_Consistency_Test', () => {
  let lifecycle: ConfigDataLifecycle;

  beforeEach(() => {
    lifecycle = new ConfigDataLifecycle();
  });

  afterEach(() => {
  });

  it('should_common_config_password_create_code', 0, () => {
    const config = new ConfigData();
    expect(config.PAGE_REQUEST_CODE_PASSWORD_CREATE).assertEqual(20001);
  });

  it('should_menu_config_password_create_code', 0, () => {
    const config = new MenuConfigData();
    expect(config.PAGE_REQUEST_CODE_PASSWORD_CREATE).assertEqual(20001);
  });

  it('should_common_config_password_change_code', 0, () => {
    const config = new ConfigData();
    expect(config.PAGE_REQUEST_CODE_PASSWORD_CHANGE).assertEqual(20003);
  });

  it('should_menu_config_password_change_code', 0, () => {
    const config = new MenuConfigData();
    expect(config.PAGE_REQUEST_CODE_PASSWORD_CHANGE).assertEqual(20003);
  });

  it('should_common_config_password_disable_code', 0, () => {
    const config = new ConfigData();
    expect(config.PAGE_REQUEST_CODE_PASSWORD_DISABLE).assertEqual(20004);
  });

  it('should_menu_config_password_disable_code', 0, () => {
    const config = new MenuConfigData();
    expect(config.PAGE_REQUEST_CODE_PASSWORD_DISABLE).assertEqual(20004);
  });
});

describe('ConfigData_Tag_Consistency_Test', () => {
  let lifecycle: ConfigDataLifecycle;

  beforeEach(() => {
    lifecycle = new ConfigDataLifecycle();
  });

  afterEach(() => {
  });

  it('should_common_config_tag_contain_Settings', 0, () => {
    expect(lifecycle.getCommonTag().includes('Settings')).assertEqual(true);
  });

  it('should_menu_config_tag_contain_Settings', 0, () => {
    expect(lifecycle.getMenuTag().includes('Settings')).assertEqual(true);
  });

  it('should_both_configs_have_identical_tag', 0, () => {
    expect(lifecycle.getCommonTag()).assertEqual(lifecycle.getMenuTag());
  });
});

describe('ConfigData_MaxLines_Consistency_Test', () => {
  let lifecycle: ConfigDataLifecycle;

  beforeEach(() => {
    lifecycle = new ConfigDataLifecycle();
  });

  afterEach(() => {
  });

  it('should_common_config_max_lines_1', 0, () => {
    const config = new ConfigData();
    expect(config.MAX_LINES_1).assertEqual(1);
  });

  it('should_menu_config_max_lines_1', 0, () => {
    const config = new MenuConfigData();
    expect(config.MAX_LINES_1).assertEqual(1);
  });

  it('should_common_config_max_lines_2', 0, () => {
    const config = new ConfigData();
    expect(config.MAX_LINES_2).assertEqual(2);
  });

  it('should_menu_config_max_lines_2', 0, () => {
    const config = new MenuConfigData();
    expect(config.MAX_LINES_2).assertEqual(2);
  });

  it('should_common_config_max_lines_3', 0, () => {
    const config = new ConfigData();
    expect(config.MAX_LINES_3).assertEqual(3);
  });

  it('should_menu_config_max_lines_3', 0, () => {
    const config = new MenuConfigData();
    expect(config.MAX_LINES_3).assertEqual(3);
  });

  it('should_both_configs_have_identical_max_lines', 0, () => {
    const common = new ConfigData();
    const menu = new MenuConfigData();
    expect(common.MAX_LINES_1).assertEqual(menu.MAX_LINES_1);
    expect(common.MAX_LINES_2).assertEqual(menu.MAX_LINES_2);
    expect(common.MAX_LINES_3).assertEqual(menu.MAX_LINES_3);
  });
});

describe('ConfigData_TimeFormat_Consistency_Test', () => {
  let lifecycle: ConfigDataLifecycle;

  beforeEach(() => {
    lifecycle = new ConfigDataLifecycle();
  });

  afterEach(() => {
  });

  it('should_common_config_time_format_24', 0, () => {
    const config = new ConfigData();
    expect(config.TIME_FORMAT_24).assertEqual('24');
  });

  it('should_menu_config_time_format_24', 0, () => {
    const config = new MenuConfigData();
    expect(config.TIME_FORMAT_24).assertEqual('24');
  });

  it('should_common_config_time_format_12', 0, () => {
    const config = new ConfigData();
    expect(config.TIME_FORMAT_12).assertEqual('12');
  });

  it('should_menu_config_time_format_12', 0, () => {
    const config = new MenuConfigData();
    expect(config.TIME_FORMAT_12).assertEqual('12');
  });

  it('should_both_configs_have_identical_time_format_constants', 0, () => {
    const common = new ConfigData();
    const menu = new MenuConfigData();
    expect(common.TIME_FORMAT_24).assertEqual(menu.TIME_FORMAT_24);
    expect(common.TIME_FORMAT_12).assertEqual(menu.TIME_FORMAT_12);
  });
});

describe('ConfigData_SliderMode_Consistency_Test', () => {
  let lifecycle: ConfigDataLifecycle;

  beforeEach(() => {
    lifecycle = new ConfigDataLifecycle();
  });

  afterEach(() => {
  });

  it('should_common_config_slider_moving_mode', 0, () => {
    const config = new ConfigData();
    expect(config.SLIDER_CHANG_MODE_MOVING).assertEqual(1);
  });

  it('should_menu_config_slider_moving_mode', 0, () => {
    const config = new MenuConfigData();
    expect(config.SLIDER_CHANG_MODE_MOVING).assertEqual(1);
  });

  it('should_common_config_slider_end_mode', 0, () => {
    const config = new ConfigData();
    expect(config.SLIDER_CHANG_MODE_END).assertEqual(2);
  });

  it('should_menu_config_slider_end_mode', 0, () => {
    const config = new MenuConfigData();
    expect(config.SLIDER_CHANG_MODE_END).assertEqual(2);
  });

  it('should_both_configs_have_identical_slider_modes', 0, () => {
    const common = new ConfigData();
    const menu = new MenuConfigData();
    expect(common.SLIDER_CHANG_MODE_MOVING).assertEqual(menu.SLIDER_CHANG_MODE_MOVING);
    expect(common.SLIDER_CHANG_MODE_END).assertEqual(menu.SLIDER_CHANG_MODE_END);
  });
});

describe('ConfigData_MenuSpecific_WidthPercent_Test', () => {
  let lifecycle: ConfigDataLifecycle;

  beforeEach(() => {
    lifecycle = new ConfigDataLifecycle();
  });

  afterEach(() => {
  });

  it('should_menu_config_have_wh_48_100', 0, () => {
    const config = new MenuConfigData();
    expect(config.WH_48_100).assertEqual('48%');
  });

  it('should_menu_config_have_wh_52_100', 0, () => {
    const config = new MenuConfigData();
    expect(config.WH_52_100).assertEqual('52%');
  });

  it('should_menu_config_have_wh_58_100', 0, () => {
    const config = new MenuConfigData();
    expect(config.WH_58_100).assertEqual('58%');
  });

  it('should_common_config_not_have_wh_48_100', 0, () => {
    const common = new ConfigData();
    expect(hasOwnField(common as Object, 'WH_48_100')).assertEqual(false);
  });

  it('should_common_config_not_have_wh_52_100', 0, () => {
    const common = new ConfigData();
    expect(hasOwnField(common as Object, 'WH_52_100')).assertEqual(false);
  });

  it('should_common_config_not_have_wh_58_100', 0, () => {
    const common = new ConfigData();
    expect(hasOwnField(common as Object, 'WH_58_100')).assertEqual(false);
  });
});

describe('ConfigData_MenuSpecific_Wifi_Test', () => {
  let lifecycle: ConfigDataLifecycle;

  beforeEach(() => {
    lifecycle = new ConfigDataLifecycle();
  });

  afterEach(() => {
  });

  it('should_menu_config_have_settingsdata_wifi', 0, () => {
    const config = new MenuConfigData();
    expect(!!config.SETTINGSDATA_WIFI).assertTrue();
  });

  it('should_common_config_not_have_settingsdata_wifi', 0, () => {
    const common = new ConfigData();
    expect(hasOwnField(common as Object, 'SETTINGSDATA_WIFI')).assertEqual(false);
  });

  it('should_menu_config_have_settingsdata_bluetooth', 0, () => {
    const config = new MenuConfigData();
    expect(!!config.SETTINGSDATA_BLUETOOTH).assertTrue();
  });

  it('should_common_config_not_have_settingsdata_bluetooth', 0, () => {
    const common = new ConfigData();
    expect(hasOwnField(common as Object, 'SETTINGSDATA_BLUETOOTH')).assertEqual(false);
  });

  it('should_menu_config_have_settingsdata_inputsource', 0, () => {
    const config = new MenuConfigData();
    expect(!!config.SETTINGDATA_INPUTSOURCE).assertTrue();
  });

  it('should_common_config_not_have_settingsdata_inputsource', 0, () => {
    const common = new ConfigData();
    expect(hasOwnField(common as Object, 'SETTINGDATA_INPUTSOURCE')).assertEqual(false);
  });
});

describe('ConfigData_CommonSpecific_BroadcastEvent_Test', () => {
  let lifecycle: ConfigDataLifecycle;

  beforeEach(() => {
    lifecycle = new ConfigDataLifecycle();
  });

  afterEach(() => {
  });

  it('should_common_config_have_sent_event_wifi_connect_name', 0, () => {
    const config = new ConfigData();
    expect(config.SENT_EVENT_WIFI_CONNECT_NAME).assertEqual('WIFI_CONNECT_NAME');
  });

  it('should_menu_config_not_have_sent_event_wifi_connect_name', 0, () => {
    const menu = new MenuConfigData();
    expect(hasOwnField(menu as Object, 'SENT_EVENT_WIFI_CONNECT_NAME')).assertEqual(false);
  });
});

describe('ConfigData_BundleName_Consistency_Test', () => {
  let lifecycle: ConfigDataLifecycle;

  beforeEach(() => {
    lifecycle = new ConfigDataLifecycle();
  });

  afterEach(() => {
  });

  it('should_common_config_default_bundle_name', 0, () => {
    const config = new ConfigData();
    expect(config.DEFAULT_BUNDLE_NAME).assertEqual('com.ohos.settings');
  });

  it('should_menu_config_default_bundle_name', 0, () => {
    const config = new MenuConfigData();
    expect(config.DEFAULT_BUNDLE_NAME).assertEqual('com.ohos.settings');
  });

  it('should_both_configs_have_identical_default_bundle_name', 0, () => {
    const common = new ConfigData();
    const menu = new MenuConfigData();
    expect(common.DEFAULT_BUNDLE_NAME).assertEqual(menu.DEFAULT_BUNDLE_NAME);
  });
});

describe('ConfigData_StartAbility_Consistency_Test', () => {
  let lifecycle: ConfigDataLifecycle;

  beforeEach(() => {
    lifecycle = new ConfigDataLifecycle();
  });

  afterEach(() => {
  });

  it('should_common_config_faceauth_bundle_name', 0, () => {
    const config = new ConfigData();
    expect(config.FACEAUTH_BUNDLE_NAME).assertEqual('com.ohos.settings.faceauth');
  });

  it('should_menu_config_faceauth_bundle_name', 0, () => {
    const config = new MenuConfigData();
    expect(config.FACEAUTH_BUNDLE_NAME).assertEqual('com.ohos.settings.faceauth');
  });

  it('should_common_config_faceauth_ability_name', 0, () => {
    const config = new ConfigData();
    expect(config.FACEAUTH_ABILITY_NAME).assertEqual('com.ohos.settings.faceauth.enrollmentstartview');
  });

  it('should_menu_config_faceauth_ability_name', 0, () => {
    const config = new MenuConfigData();
    expect(config.FACEAUTH_ABILITY_NAME).assertEqual('com.ohos.settings.faceauth.enrollmentstartview');
  });

  it('should_common_config_permission_manager_bundle', 0, () => {
    const config = new ConfigData();
    expect(config.PERMISSION_MANAGER_BUNDLE_NAME).assertEqual('com.ohos.permissionmanager');
  });

  it('should_menu_config_permission_manager_bundle', 0, () => {
    const config = new MenuConfigData();
    expect(config.PERMISSION_MANAGER_BUNDLE_NAME).assertEqual('com.ohos.permissionmanager');
  });

  it('should_common_config_mobile_data_bundle', 0, () => {
    const config = new ConfigData();
    expect(config.MOBILE_DATA_BUNDLE_NAME).assertEqual('com.ohos.callui');
  });

  it('should_menu_config_mobile_data_bundle', 0, () => {
    const config = new MenuConfigData();
    expect(config.MOBILE_DATA_BUNDLE_NAME).assertEqual('com.ohos.callui');
  });
});

describe('ConfigData_DateTime_Consistency_Test', () => {
  let lifecycle: ConfigDataLifecycle;

  beforeEach(() => {
    lifecycle = new ConfigDataLifecycle();
  });

  afterEach(() => {
  });

  it('should_common_config_date_year_key', 0, () => {
    const config = new ConfigData();
    expect(config.DATE_AND_TIME_YEAR).assertEqual('DATE_AND_TIME_YEAR');
  });

  it('should_menu_config_date_year_key', 0, () => {
    const config = new MenuConfigData();
    expect(config.DATE_AND_TIME_YEAR).assertEqual('DATE_AND_TIME_YEAR');
  });

  it('should_common_config_date_month_key', 0, () => {
    const config = new ConfigData();
    expect(config.DATE_AND_TIME_MONTH).assertEqual('DATE_AND_TIME_MONTH');
  });

  it('should_menu_config_date_month_key', 0, () => {
    const config = new MenuConfigData();
    expect(config.DATE_AND_TIME_MONTH).assertEqual('DATE_AND_TIME_MONTH');
  });

  it('should_common_config_date_day_key', 0, () => {
    const config = new ConfigData();
    expect(config.DATE_AND_TIME_DAY).assertEqual('DATE_AND_TIME_DAY');
  });

  it('should_menu_config_date_day_key', 0, () => {
    const config = new MenuConfigData();
    expect(config.DATE_AND_TIME_DAY).assertEqual('DATE_AND_TIME_DAY');
  });

  it('should_both_configs_have_identical_date_keys', 0, () => {
    const common = new ConfigData();
    const menu = new MenuConfigData();
    expect(common.DATE_AND_TIME_YEAR).assertEqual(menu.DATE_AND_TIME_YEAR);
    expect(common.DATE_AND_TIME_MONTH).assertEqual(menu.DATE_AND_TIME_MONTH);
    expect(common.DATE_AND_TIME_DAY).assertEqual(menu.DATE_AND_TIME_DAY);
  });
});

describe('ConfigData_Language_Consistency_Test', () => {
  let lifecycle: ConfigDataLifecycle;

  beforeEach(() => {
    lifecycle = new ConfigDataLifecycle();
  });

  afterEach(() => {
  });

  it('should_common_config_add_languages_key', 0, () => {
    const config = new ConfigData();
    expect(config.ADDLANGUAGES).assertEqual('addedLanguages');
  });

  it('should_menu_config_add_languages_key', 0, () => {
    const config = new MenuConfigData();
    expect(config.ADDLANGUAGES).assertEqual('addedLanguages');
  });

  it('should_common_config_current_region_key', 0, () => {
    const config = new ConfigData();
    expect(config.CURRENTREGION).assertEqual('currentRegion');
  });

  it('should_menu_config_current_region_key', 0, () => {
    const config = new MenuConfigData();
    expect(config.CURRENTREGION).assertEqual('currentRegion');
  });

  it('should_both_configs_have_identical_language_keys', 0, () => {
    const common = new ConfigData();
    const menu = new MenuConfigData();
    expect(common.ADDLANGUAGES).assertEqual(menu.ADDLANGUAGES);
    expect(common.CURRENTREGION).assertEqual(menu.CURRENTREGION);
  });
});

describe('ConfigData_StoragePath_Consistency_Test', () => {
  let lifecycle: ConfigDataLifecycle;

  beforeEach(() => {
    lifecycle = new ConfigDataLifecycle();
  });

  afterEach(() => {
  });

  it('should_common_config_storage_path_key', 0, () => {
    const config = new ConfigData();
    expect(config.STORAGEPATHKEY).assertEqual('storagePath');
  });

  it('should_menu_config_storage_path_key', 0, () => {
    const config = new MenuConfigData();
    expect(config.STORAGEPATHKEY).assertEqual('storagePath');
  });

  it('should_both_configs_have_identical_storage_path_key', 0, () => {
    const common = new ConfigData();
    const menu = new MenuConfigData();
    expect(common.STORAGEPATHKEY).assertEqual(menu.STORAGEPATHKEY);
  });
});

describe('ConfigData_FunctionType_Consistency_Test', () => {
  let lifecycle: ConfigDataLifecycle;

  beforeEach(() => {
    lifecycle = new ConfigDataLifecycle();
  });

  afterEach(() => {
  });

  it('should_common_config_function_type_hdc', 0, () => {
    const config = new ConfigData();
    expect(config.FUNCTION_TYPE_HDC).assertEqual(4);
  });

  it('should_menu_config_function_type_hdc', 0, () => {
    const config = new MenuConfigData();
    expect(config.FUNCTION_TYPE_HDC).assertEqual(4);
  });

  it('should_both_configs_have_identical_function_type', 0, () => {
    const common = new ConfigData();
    const menu = new MenuConfigData();
    expect(common.FUNCTION_TYPE_HDC).assertEqual(menu.FUNCTION_TYPE_HDC);
  });
});

export default function ConfigData_Contract_test_DefaultExportBridge(): void {
}
