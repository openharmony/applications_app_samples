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

export class Constants {
  static readonly SOURCE_TOOL_MOUSE_CLICK: number = 7;
  static readonly SOURCE_TOOL_REMOTE_CLICK: number = 6;
  static readonly SOURCE_TOOL_TOUCH_CLICK: number = 8;
  static readonly SOURCE_TOOL_KEYBOARD_CLICK: number = 9;
  static readonly SOURCE_TOOL_SYSTEM: number = 10;
  static readonly SOURCE_TOOL_PROJ: number = 11;

  static readonly STATE_IDLE: string = 'idle';
  static readonly STATE_LOADING: string = 'loading';
  static readonly STATE_PLAY: string = 'play';
  static readonly STATE_PAUSE: string = 'pause';
  static readonly STATE_STOP: string = 'stop';
  static readonly STATE_ERROR: string = 'error';
  static readonly STATE_BUFFERING: string = 'buffering';

  static readonly QUALITY_AUTO: string = 'auto';
  static readonly QUALITY_1080P: string = '1080p';
  static readonly QUALITY_720P: string = '720p';
  static readonly QUALITY_480P: string = '480p';
  static readonly QUALITY_360P: string = '360p';
  static readonly QUALITY_SD: string = 'sd';

  static readonly ASPECT_FIT: string = 'fit';
  static readonly ASPECT_FILL: string = 'fill';
  static readonly ASPECT_RATIO_16V9: string = '16:9';
  static readonly ASPECT_RATIO_4V3: string = '4:3';
}
