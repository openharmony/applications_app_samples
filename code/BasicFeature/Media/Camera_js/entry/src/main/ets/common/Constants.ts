/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
  // aspect ratio: width/height
  static readonly MIN_ASPECT_RATIO = 4 / 3;
  static readonly MAX_ASPECT_RATIO = 16 / 9;

  static readonly VIDEO_MAX_WIDTH = 2048;
  static readonly PHOTO_MAX_WIDTH = 2048;
  static readonly SURFACE_BOTTOM_MARGIN = 50;

  // device type
  static readonly TABLET = 'tablet';
  static readonly DEFAULT = 'default';
  static readonly PHONE = 'phone';

  // video frame
  static readonly VIDEO_FRAME_60 = 60;
  static readonly VIDEO_FRAME_30 = 30;
  static readonly VIDEO_FRAME_15 = 15;
}

