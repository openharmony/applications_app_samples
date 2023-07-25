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

export class Constants {
  // Immersive animation duration
  static readonly IMMERSE_ANIM_DURATION = 300;

  // click event
  static readonly TOGGLE_BAR = 'single_photo_toggle_bar';

  // hide bars
  static readonly HIDE_BARS = 'single_photo_hide_bars';

  // pull down to return start
  static readonly PULL_DOWN_START = 'single_photo_pull_down_start';

  // pull down to return end
  static readonly PULL_DOWN_END = 'single_photo_pull_down_end';

  // pull down to return cancel
  static readonly PULL_DOWN_CANCEL = 'single_photo_pull_down_cancel';

  // pull down to return threshold
  static readonly PULL_DOWN_THRESHOLD = 200;

  // touch event
  static readonly TOUCH_EVENT = 'single_photo_touch_event';

  // direction change event
  static readonly DIRECTION_CHANGE = 'single_photo_direction_change';

  // animation event
  static readonly ANIMATION_EVENT = 'single_photo_animation_event';

  // data quantity change
  static readonly DATA_SIZE_CHANGED = 'photo_data_size_changed';

  // current data change
  static readonly DATA_CONTENT_CHANGED = 'photo_data_content_changed';

  // video play
  static readonly VIDEO_PLAY = 'single_photo_video_play';

  // video pause
  static readonly VIDEO_PAUSE = 'single_photo_video_pause';

  // popup show
  static readonly POP_APPEAR = 'single_photo_popup_appear';

  // popup disappear
  static readonly POP_DISAPPEAR = 'single_photo_popup_disappear';

  // set favor photo
  static readonly SET_FAVOR = 'single_photo_set_favor';

  // rename photo
  static readonly RENAME = 'single_photo_rename';

  // rotate photo
  static readonly ROTATE = 'single_photo_rotate';

  // delete photo
  static readonly DELETE = 'single_photo_delete';

  // photo show state
  static readonly PHOTO_SHOW_STATE = 'single_photo_show_state';

  // set swiper can swipe
  static readonly SET_DISABLE_SWIPE = 'set_disable_swipe';

  // Scale lower limit
  static readonly COMPONENT_SCALE_FLOOR = 0.5;

  // scale upper limit
  static readonly COMPONENT_SCALE_CEIL = 2.0;

  // when the double-click scale is larger than maxScale, the maxScale is adjusted to 1.2 times the double-click scale
  static readonly MAX_SCALE_EXTRA_FACTOR = 1.2;

  // After reaching max scale, you can also scale an additional 0.2x max scale, and rebound after letting go
  static readonly OVER_SCALE_EXTRA_FACTOR = 1.5;

  // If the aspect ratio of the picture is the same as the display area,
  // double-click to adjust the zoom factor to 4 / 3
  static readonly SAME_RATIO_SCALE_FACTOR = 4 / 3;

  // overScale animation duration
  static readonly OVER_SCALE_ANIME_DURATION = 500;
  static readonly SHARE_TRANSITION_DURATION = 200;
  static readonly PAGE_SHOW_ANIMATION_DURATION = 200;
  static readonly RESERVED_DIGITS = 6;
  static readonly CENTER_DEFAULT = 0.5;
  static readonly NUMBER_2 = 2;
  static readonly NUMBER_3 = 3;
  static readonly NUMBER_12 = 12;
  static readonly NUMBER_13 = 13;
  static readonly DEFAULT_TRANSITION_ID: string = 'default_id';
}