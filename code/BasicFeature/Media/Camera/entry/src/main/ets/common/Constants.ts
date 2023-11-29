/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
  static readonly VIDEO_FRAME_30 = 30;
  static readonly VIDEO_FRAME_15 = 15;
};

export class SettingDataObj {
  MIRRORBOL = false;            // Mirror Enable -> Off
  VIDEO_STABILIZATION_MODE = 0; // Video Anti Shake -> Off
  EXPOSURE_MODE = 1;            // Exposure mode -> Automatic
  FOCUS_MODE = 2;               // Focus mode -> Automatic
  PHOTO_QUALITY = 1;            // Photo quality -> medium
  LOCATION_BOL = false;         // Show Geographic Location -> Off
  PHOTO_FORMAT = 1;             // Photo Format -> JPG
  PHOTO_ORIENTATION = 0;        // Photo direction -> 0
  PHOTO_RESOLUTION = 0;         // Photo resolution -> 1920 * 1080
  VIDEO_RESOLUTION = 0;         // Photo resolution -> 1920 * 1080
  VIDEO_FRAME = 0;              // Recording frame rate -> 15
  REFERENCElINE_BOL = false;    // Divider -> Off
};

export let cameraDeviceIndex: number = 0;
export let photoResolutionWidth: number = 0;
export let photoResolutionHeight: number = 0;
export let videoResolutionWidth: number = 0;
export let videoResolutionHeight: number = 0;
export let videoFrame: string = '';