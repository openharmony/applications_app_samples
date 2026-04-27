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

export class CommonConstants {

  /**
   * dock space
   */
  static DOCK_SPACE = 0.1;

  /**
   * Bundle name of launcher
   */
  static LAUNCHER_BUNDLE = 'com.ohos.launcher';

  /**
  * Module name of AppCenter.
  */
  static MODULE_NAME = 'pad-launcher';

  /**
   * Ability name of AppCenter.
   */
  static APPCENTER_ABILITY = 'com.ohos.launcher.appcenter.MainAbility';

  /**
   * Ability name of launcher settings.
   */
  static SETTING_ABILITY = 'com.ohos.launcher.settings.MainAbility';

  /**
  * Module name of launcher settings.
  */
  static SETTING_MODULE = 'launcher_settings';

  /**
   * Ability name of launcher Recents.
   */
  static RECENT_ABILITY = 'com.ohos.launcher.recents.MainAbility';

  /**
   * Launcher Ability name.
   */
  static LAUNCHER_ABILITY = 'com.ohos.launcher.MainAbility';

  /**
   * Default invalid value.
   */
  static INVALID_VALUE = -1;

  /**
   * folder min app count
   */
  static FOLDER_APP_VALUE = 1;

  /**
   * Status code if uninstal succeeded, success, successful.
   */
  static UNINSTALL_SUCCESS = 0;

  /**
   * Status code if uninstall is forbidden.
   */
  static UNINSTALL_FORBID = 1;

  /**
   * Grid item type for apps.
   */
  static TYPE_APP = 0;

  /**
   * Grid item type for cards.
   */
  static TYPE_CARD = 1;

  /**
   * Grid item type for functions.
   */
  static TYPE_FUNCTION = 2;

  /**
   * folder type in desktop
   */
  static TYPE_FOLDER = 3;

  /**
   * add icon type in opening folder
   */
  static TYPE_ADD = 4;

  /**
   * Card dimension constants for 1 row 2 columns.
   */
  static CARD_DIMENSION_1x2 = 1;

  /**
   * Card dimension constants for 2 rows 2 columns.
   */
  static CARD_DIMENSION_2x2 = 2;

  /**
   * Card dimension constants for 2 rows 4 columns.
   */
  static CARD_DIMENSION_2x4 = 3;

  /**
   * Card dimension constants for 4 rows 4 columns.
   */
  static CARD_DIMENSION_4x4 = 4;

  /**
   * Common level layout config. Default config for common components.
   */
  static LAYOUT_CONFIG_LEVEL_COMMON = 'common';

  /**
   * Feature level layout config. Default config for components in this feature.
   */
  static LAYOUT_CONFIG_LEVEL_FEATURE = 'feature';

  /**
   * Product level layout config. Custom config for this product.
   */
  static LAYOUT_CONFIG_LEVEL_PRODUCT = 'product';

  /**
   * Layout config type for layout mode.
   */
  static LAYOUT_CONFIG_TYPE_MODE = 0;

  /**
   * Layout config type for layout style.
   */
  static LAYOUT_CONFIG_TYPE_STYLE = 1;

  /**
   * Layout config type for layout function.
   */
  static LAYOUT_CONFIG_TYPE_FUNCTION = 2;

  /**
   * Default device type constant.
   */
  static DEFAULT_DEVICE_TYPE = 'phone';

  /**
   * Device type constant for tablet.
   */
  static PAD_DEVICE_TYPE = 'pad';

  /**
   * Overlay blur radius.
   */
  static OVERLAY_BLUR_RADIUS = 20;

  /**
   * Overlay type for hidden items.
   */
  static OVERLAY_TYPE_HIDE = -1;

  /**
   * Overlay type for app menus.
   */
  static OVERLAY_TYPE_APP_MENU = 0;

  /**
   * Overlay type for app icons.
   */
  static OVERLAY_TYPE_APP_ICON = 1;

  /**
   * Overlay type for folders.
   */
  static OVERLAY_TYPE_FOLDER = 2;

  /**
   * Overlay type for forms
   */
  static OVERLAY_TYPE_CARD = 3;

  /**
   * Overlay type for residential.
   */
  static OVERLAY_TYPE_APP_RESIDENTIAL = 4;

  /**
 * Overlay type for recentdock.
 */
  static OVERLAY_TYPE_APP_RECENT = 5;

  /**
   * Menu type for fixed items.
   */
  static MENU_TYPE_FIXED = 0;

  /**
   * Menu type for dynamic items.
   */
  static MENU_TYPE_DYNAMIC = 1;

  /**
   * Light mode menus.
   */
  static MENU_UI_MODE_LIGHT = 0;

  /**
   * Dark mode menus.
   */
  static MENU_UI_MODE_DARK = 1;

  /**
   * Drag item type for apps.
   */
  static APP_TYPE_DRAG_ITEM = 0;

  /**
   * Touch event type for down events.
   */
  static TOUCH_TYPE_DOWN = 0;

  /**
   * Touch event type for move events.
   */
  static TOUCH_TYPE_MOVE = 2;

  /**
   * Touch event type for up events.
   */
  static TOUCH_TYPE_UP = 1;

  /**
   * FolderComponent max show length
   */
  static FOLDER_STATIC_SHOW_LENGTH = 11;

  /**
   * FolderComponent superpose app length
   */
  static FOLDER_STATIC_SUPERPOSEAPP_LENGTH = 3;

  /**
   * folder name max length
   */
  static FOLDER_NAME_MAX_LENGTH = 100;

  /**
   * hide badge
   */
  static BADGE_DISPLAY_HIDE = 0;

  /**
   * show badge
   */
  static BADGE_DISPLAY_SHOW = 1;

  /**
   * default user id
   */
  static DEFAULT_USER_ID = 0;

  /**
   * form config ability prefix
   */
  static FORM_CONFIG_ABILITY_PREFIX: string = 'ability://';

  /**
   * navigationbar status settingDataKey.
   */
  static NAVIGATION_BAR_STATUS_KEY: string = 'settings.display.navigationbar_status';

  /**
   * setting data ability uri
   */
  static SETTING_DATA_ABILITY_URI: string = 'datashare:///com.ohos.settingsdata.DataAbility';

  /**
   * Drag events from the smartDock.
   */
  static DRAG_FROM_DOCK = 1;

  /**
   * Drag events from the workspace.
   */
  static DRAG_FROM_DESKTOP = 2;
}
