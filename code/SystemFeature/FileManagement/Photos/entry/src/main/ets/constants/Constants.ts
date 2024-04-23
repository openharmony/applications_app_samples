/*
 * Copyright (c) 2023 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import deviceInfo from '@ohos.deviceInfo';

enum EntryForm {
  NORMAL = 0,
  CAMERA = 1,
  SINGLE_SELECT = 2,
  MULTIPLE_SELECT = 3,
  RECYCLE = 4,
  CARD = 6,
  VIEW_DATA = 7
}

export class Constants {
  // illegal value
  static readonly INVALID = -1;

  // Index of and other operations, the index returned when it is not found
  static readonly NOT_FOUND = -1;

  // delay 1s
  static readonly DELAY_ONE_SECOND = 1000;

  // delay 500ms
  static readonly DELAY_HALF_SECOND = 500;

  // delay 250ms
  static readonly DELAY_QUARTER_SECOND = 250;

  // delay 100ms
  static readonly DELAY_TENTH_SECOND = 100;

  // delay 50ms
  static readonly DELAY_TWENTIETH_SECOND = 50;

  // Default sliding window size
  static readonly DEFAULT_SLIDING_WIN_SIZE = 500;
  static readonly DEFAULT_ROTATE_VALUE = 90;
  static readonly ROTATE_AROUND = 360;
  static readonly ANGLE_90 = 90;
  static readonly ANGLE_270 = 270;

  // Step size. When the last obtained data index deviates from the center of the current sliding window by more
  // than this step, adjust the start and end of the window and re initiate the data request
  static readonly STEP = 100;
  static readonly KEY_VIEW_TYPE = 'type';
  static readonly KEY_VIEW_DATA = 'data';
  static readonly ActionBarHeight: number = 56;
  static readonly APP_KEY_PHOTO_BROWSER = 'app_key_photo_browser';
  static readonly APP_KEY_MENU_OPERATION_FACTORY = 'app_key_menu_operation_factory';
  static readonly APP_KEY_MENU_MEDIA_OBSERVER = 'app_key_menu_media_observer';
  static readonly APP_KEY_WORKER_MANAGER = 'app_key_worker_manager';
  static readonly APP_KEY_SLIDE_SHOW = 'app_key_slide_show';
  static readonly THIRD_SELECT_MANAGER = 'third_select_manager';
  static readonly APP_KEY_STATUS_BAR_COLOR_CONTROLLER = 'app_key_status_bar_color_controller';
  static readonly APP_KEY_NEW_ALBUM = 'app_key_new_album';
  static readonly APP_KEY_NEW_ALBUM_TARGET = 'app_key_new_album_target';
  static readonly APP_KEY_NEW_ALBUM_SELECTED = 'app_key_new_album_selected';
  static readonly APP_KEY_INSTANCE_MEDIA_LIBRARY_ACCESS = 'app_key_instance_media_library_access';
  static readonly FROM_DATA_STORE_UTIL = 'form_data_store_util';

  // Broadcast
  static readonly APP_KEY_EVENT_BUS = 'app_key_event_bus';
  static readonly SCREEN_MANAGER = 'screen_manager';
  static readonly PIXEL_MAP_MANAGER = 'pixel_map_manager';

  // Load completion event
  static readonly ON_LOADING_FINISHED = 'on_loading_finished';
  static readonly FIRST_PATCH_LOAD_FINISH = 'first_patch_load_finish';

  // Large jump source: timeline
  static readonly PHOTO_TRANSITION_TIMELINE: string = 'TimelinePage';

  // Large jump source: album
  static readonly PHOTO_TRANSITION_ALBUM: string = 'PhotoGridPage';

  // Large jump source: camera
  static readonly PHOTO_TRANSITION_CAMERA: string = 'Camera';
  static readonly PHOTO_TRANSITION_EDIT: string = 'EditPage';

  // Timeline page index
  static readonly TIMELINE_PAGE_INDEX: number = 0;

  // Album page index
  static readonly ALBUM_PAGE_INDEX: number = 1;
  static readonly IMAGE_GIF = 'gif';
  static readonly GRID_CACHE_ROW_COUNT: number = 4;

  // Press animation duration
  static readonly PRESS_ANIM_DURATION = 100;

  // Press to scale the value at the end of the animation
  static readonly PRESS_ANIM_SCALE = 0.9;

  // Default maximum number of external selection pages
  static readonly DEFAULT_MAX_THIRD_SELECT_COUNT: number = 50;

  // Column flag
  static readonly SCREEN_COLUMNS: string = 'screen_columns';
  static readonly ADD_NOTES_MAX_LENGTH: number = 140;
  static readonly RENAME_MAX_LENGTH: number = 82;
  static readonly ENTRY_FROM_NONE = 0;
  static readonly ENTRY_FROM_CAMERA = 1;
  static readonly ENTRY_FROM_SINGLE_SELECT = 2;
  static readonly ENTRY_FROM_MULTIPLE_SELECT = 3;
  static readonly ENTRY_FROM_RECYCLE = 4;
  static readonly ENTRY_FROM_NORMAL = 6;
  static readonly ENTRY_FROM_FORM_ABILITY = 7;
  static readonly ENTRY_FROM_FORM_FORM_EDITOR = 8;
  static readonly ENTRY_FROM_VIEW_DATA = 9;
  static readonly ENTRY_FROM_FORM_ABILITY_NONE = 12;
  static readonly ENTRY_FROM = EntryForm;
  static readonly DIALOG_BOTTOM_OFFSET: number = 48;

  // Local tab index
  static readonly LOCAL_TAB_INDEX: number = 0;

  // Other equipment tab index
  static readonly OTHER_EQUIPMENT_TAB_INDEX: number = 1;

  //the constant for action of the want
  static readonly ACTION_DELETE_DATA: string = 'ohos.want.action.deleteDialog';

  // editor used
  static readonly UPDATE_MENU = 'updateMenu';
  static readonly UPDATE_DOODLE_STYLE = 'update_doodle_style';
  static readonly ADJUST_PARAMS_VALUE_CHANGED = 'adjust_params_value_changed';
  static readonly ADJUST_PARAMS_ID_CHANGED = 'adjust_params_id_changed';
  static readonly IS_IMMERSIVE = 'is_immersive';
  static readonly UPDATE_DOODLE_STROKE_STYLE = 'update_doodle_stroke_style';
  static readonly PHOTO_EDITOR_MANAGER: string = 'photo_editor_manager';
  static readonly PHOTO_EDITOR_EVENT_MANAGER: string = 'photo_editor_event_manager';
  static readonly INTI_RULER: string = 'inti_ruler';
  static readonly RULER_CHANGED: string = 'inti_ruler';
  static readonly LABEL_STYLE_CHANGED: string = 'label_style_changed';
  static readonly LABEL_TEXT_STYLE_CHANGED: string = 'label_text_style_changed';
  static readonly LABEL_TEXT_COLOR_CHANGED: string = 'label_text_color_changed';
  static readonly LABEL_GET_CLIP_RECT: string = 'label_get_clip_rect';
  static readonly CROP_RESET_CLICKED: string = 'crop_reset_clicked';
  static readonly IS_BIG_TEXT_SHOW: string = 'is_big_text_show';
  static readonly RULER_BAR_INTI: string = 'ruler_bar_inti';
  static readonly COLOR_SLIDER_CHANGED: string = 'color_slider_changed';
  static readonly MOSAIC_STYLE_CHANGED: string = 'mosaic_style_changed';
  static readonly LABEL_DELETE: string = 'label_delete';
  static readonly UPDATE_LABEL_STYLE: string = 'update_label_style';
  static readonly IS_LABEL_ACTIVE: string = 'is_label_active';
  static readonly NOT_MAX_INDEX_CLICK_OF_LABEL: string = 'not_max_index_click_of_label';
  static readonly IS_LABEL_MODE: string = 'is_label_mode';
  static readonly RESET_LABEL_STYLE_INFO: string = 'reset_label_style_info';
  static readonly UPDATE_TOUCH_EVENT: string = 'update_touch_event';
  static readonly PHOTO_COLLAGE_MANAGER: string = 'photo_collage_manager';
  static readonly RETURN_TO_MAIN: string = 'return_to_main';
  static readonly NEGATIVE_FORTY: string = '-40.0°';
  static readonly NEGATIVE_THIRTY: string = '-30.0°';
  static readonly NEGATIVE_TWENTY: string = '-20.0°';
  static readonly NEGATIVE_TEN: string = '-10.0°';
  static readonly ZERO_STR: string = '0.0°';
  static readonly POSITIVE_TEN: string = '10.0°';
  static readonly POSITIVE_TWENTY: string = '20.0°';
  static readonly POSITIVE_THIRTY: string = '30.0°';
  static readonly POSITIVE_FORTY: string = '40.0°';
  static readonly RULER_CONTEXT_FONT_10PX: string = '10px SimSun, Songti SC';
  static readonly RULER_CONTEXT_FONT_20PX: string = '20px SimSun, Songti SC';
  static readonly RULER_CONTEXT_FONT_30PX: string = '30px SimSun, Songti SC';
  static readonly RULER_FILL_STYLE_100: string = '#FFFFFF';
  static readonly RULER_FILL_STYLE_90: string = '#E5FFFFFF';
  static readonly RULER_FILL_STYLE_40: string = '#66FFFFFF';
  static readonly RULER_TEXT_ALIGN: string = 'center';

  /**
   * @deprecated
   */
  static readonly MEDIA_TYPE_IMAGE: string = 'image';
  /**
   * @deprecated
   */
  static readonly MEDIA_TYPE_VIDEO: string = 'video';
  /**
   * @deprecated
   */
  static readonly MEDIA_TYPE_ALBUM: string = 'album';
  /**
   * @deprecated
   */
  static readonly MEDIA_TYPE_DEVICE: string = 'device';
  /**
   * @deprecated
   */
  static readonly MEDIA_TYPE_REMOTE: string = 'remote';
  static readonly DEVICE_STATE_ONLINE: string = 'online';
  static readonly DEVICE_STATE_OFFLINE: string = 'offline';
  static readonly DEVICE_STATE_CHANGE: string = 'change';
  static readonly TOP_BAR_SIZE: number = 56;
  static readonly TOOL_BAR_SIZE: number = 72;
  static readonly BOTTOM_TOOL_BAR_SIZE: number = 196;
  static readonly FILTER_BOTTOM_TOOL_BAR_SIZE: number = 232;
  static readonly DEFAULT_WIDTH: number = 360;
  static readonly RESET_SIZE: number = 20;
  static readonly RESET_SIZE_HORIZONTAL: number = 48;
  static readonly TIMEOUT: number = 50;
  static readonly PADDING_VERTICAL: number = 140;
  static readonly PADDING_HORIZONTAL: number = 160;
  static readonly MID_LINE_WIDTH: number = 1.5;
  static readonly MID_LINE_HEIGHT: number = 20;
  static readonly RULER_LINE_WIDTH: number = 1;
  static readonly NEGATIVE_1: number = -1;
  static readonly NEGATIVE_2: number = -2;
  static readonly NUMBER_1: number = 1;
  static readonly NUMBER_2: number = 2;
  static readonly NUMBER_3: number = 3;
  static readonly NUMBER_4: number = 4;
  static readonly NUMBER_5: number = 5;
  static readonly NUMBER_5_5: number = 5.5;
  static readonly NUMBER_6: number = 6;
  static readonly NUMBER_6_5: number = 6.5;
  static readonly NUMBER_7: number = 7;
  static readonly NUMBER_7_5: number = 7.5;
  static readonly NUMBER_8: number = 8;
  static readonly NUMBER_8_5: number = 8.5;
  static readonly NUMBER_9: number = 9;
  static readonly NUMBER_9_5: number = 9.5;
  static readonly NUMBER_10: number = 10;
  static readonly NUMBER_10_5: number = 10.5;
  static readonly NUMBER_11_5: number = 11.5;
  static readonly NUMBER_15: number = 15;
  static readonly EDGE_ANGLE: number = 45;
  static readonly LITTLE_CANVAS_SIZE: number = 60;
  static readonly NUMBER_40: number = 40;
  static readonly NUMBER_30: number = 30;
  static readonly NUMBER_20: number = 20;
  static readonly NUMBER_0: number = 0;

  // Grid Constants
  static readonly TAB_BAR_WIDTH: number = 96;
  static readonly ACTION_BAR_HEIGHT: number = 56;
  static readonly GRID_GUTTER: number = 2;
  static readonly GRID_IMAGE_SIZE: number = 128;
  static readonly GRID_MAX_SIZE_RATIO: number = 1.2;
  static readonly TIME_GRID_MAX_SIZE_RATIO: number = 1.5;
  static readonly GRID_MIN_COUNT: number = 2;
  static readonly SCROLL_BAR_SIDE_MIN_GAP: number = 12;
  static readonly SCROLL_MARGIN: number = 24;
  static readonly SCROLL_BAR_VISIBLE_THRESHOLD: number = deviceInfo.deviceType === 'phone' || deviceInfo.deviceType === 'default' ? 7 : 9;
  static readonly GRID_SCROLL_BAR_VISIBLE_THRESHOLD: number = deviceInfo.deviceType === 'phone' || deviceInfo.deviceType === 'default' ? 7 : 13;

  // Album Card Constants
  static readonly CARD_ASPECT_RATIO: number = 0.75;
  static readonly ALBUM_SET_NEW_ICON_SIZE: number = 22;
  static readonly ALBUM_SET_NEW_ICON_MARGIN: number = 8;
  static readonly ALBUM_SET_MARGIN: number = 24;
  static readonly ALBUM_SET_GUTTER: number = 12;
  static readonly ALBUM_SET_COVER_SIZE: number = 220;

  // System Resource Constants
  static readonly TEXT_SIZE_SUB_TITLE1: number = 18; // ohos_id_text_size_sub_title1
  static readonly TEXT_SIZE_BODY2: number = 14; // ohos_id_text_size_body2
  static readonly TEXT_SIZE_SUB_TITLE2: number = 16; // ohos_id_text_size_sub_title2

  // Empty Page
  static readonly EMPTY_PAGE_OFFSET_RADIO: number = 0.4;
  static readonly EMPTY_PAGE_DEFAULT_OFFSET: number = 300;
  static readonly EMPTY_PAGE_MARGIN: number = 12;

  // Dialog
  static readonly DETAILS_DIALOG_PATH_MAX_LINE: number = 7;
  static readonly DETAILS_DIALOG_NAME_MAX_LINE: number = 5;
  static readonly PROGRESS_MAX: number = 100;
  static readonly BYTE_TO_MB: number = 1024 * 1024;
  static readonly BIG_SCREEN_WIDTH: number = 600;
  static readonly BIG_EMPTY_ICON_SIZE: number = 160;
  static readonly SMALL_EMPTY_ICON_SIZE: number = 120;
  // Menu
  static readonly MENU_DIVIDER_STROKE_WIDTH: number = 1;

  // Duration
  static readonly SHARE_TRANSITION_DURATION: number = 200;
  static readonly DELETE_ANIMATE_DURATION: number = 150;

  // Percent
  static readonly PERCENT_HUNDRED: number = 100;
  static readonly PERCENT_ONE_THIRD: string = (100 / 3) + '%';

  // AppStorage constants
  static readonly ENTRY_FROM_HAP: string = 'entryFromHap';
  static readonly FROM_ALBUM_ID: string = 'form_albumId';
  static readonly FROM_CURRENT_INDEX: string = 'form_currentIndex';
  static readonly FA_SETTING_FROM_ID: string = 'FASetting_FormId';
  static readonly VIEW_DATA_URI: string = 'viewDataUri';
  static readonly VIEW_DATA_POS: string = 'viewDataPos';

  static readonly FORM_ITEM_NAME: string = 'form_itemName';
  static readonly FORM_ITEM_ALBUM_ID: string = 'form_itemAlbumId';
  static readonly FORM_ITEM_DISPLAY_NAME: string = 'form_itemDisplayName';
  static readonly MAIN_WINDOW: string = 'mainWindow';
  static readonly ACTION_URI_FORM_ABILITY: string = 'formAbility';
  static readonly ACTION_URI_FORM_ABILITY_NONE: string = 'formAbilityNone';
  static readonly PROGRESS_LENGTH_DIFF: number = 88;
  static readonly ALBUM_NAME_MAX_LENGTH = 82;
  static readonly BACK_FROM_FORM_DETAIL: string = 'back_from_form_detail';

  // ApplictionInfo
  static readonly BUNDLE_NAME: string = 'com.ohos.photos';

  // get want info with key
  static readonly KEY_WANT_PARAMETERS_CALLER_BUNDLE_NAME: string = 'ohos.aafwk.param.callerBundleName';
  static readonly KEY_WANT_PARAMETERS_CALLERUID: string = 'ohos.aafwk.param.callerUid';

  // camera mainAbility
  static readonly CAMERA_TYPE_CAPTURE: string = 'capture';

  // camera mainAbility
  static readonly CAMERA_TYPE_VIDEO: string = 'video';

  // camera bundleName
  static readonly CAMERA_BUNDLE_NAME: string = 'com.ohos.camera';

  // camera mainAbility
  static readonly CAMERA_MAIN_ABILITY: string = 'com.ohos.camera.MainAbility';

  // maximum number limit of external selection pages
  static readonly LIMIT_MAX_THIRD_SELECT_COUNT: number = 500;

  static readonly DEFAULT_DIVIDER_COLOR: string = 'rgb(207, 195, 195)';
  static readonly DEFAULT_DIVIDER_HEIGHT: string = '24vp';
  static readonly NAME_PATTERN: RegExp = /[\\.\\\\/:*?"'`<>|\[\]{}]/;
}
