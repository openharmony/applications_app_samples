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
  static readonly MIN_ASPECT_RATIO = 4 / 3; // 4:MIN_ASPECT_RATIO, 3:MIN_ASPECT_RATIO
  static readonly MAX_ASPECT_RATIO = 16 / 9; // 16:MAX_ASPECT_RATIO, 9:MAX_ASPECT_RATIO

  static readonly VIDEO_MAX_WIDTH = 2048; // 2048: VIDEO_MAX_WIDTH
  static readonly PHOTO_MAX_WIDTH = 2048; // 2048: PHOTO_MAX_WIDTH
  static readonly SURFACE_BOTTOM_MARGIN = 50; // 50: SURFACE_BOTTOM_MARGIN

  // device type
  static readonly TABLET = 'tablet';
  static readonly DEFAULT = 'default';
  static readonly PHONE = 'phone';

  // video frame
  static readonly VIDEO_FRAME_30 = 30; // 30: VIDEO_FRAME_30
  static readonly VIDEO_FRAME_15 = 15; // 15: VIDEO_FRAME_15
};

export class SettingDataObj {
  mirrorBol = false; // Mirror Enable -> Off
  videoStabilizationMode = 0; // Video Anti Shake -> Off
  exposureMode = 1; // Exposure mode -> Automatic
  focusMode = 2; // 2:Focus mode -> Automatic
  photoQuality = 1; // Photo quality -> medium
  locationBol = false; // Show Geographic Location -> Off
  photoFormat = 1; // Photo Format -> JPG
  photoOrientation = 0; // Photo direction -> 0
  photoResolution = 0; // Photo resolution -> 1920 * 1080
  videoResolution = 0; // Photo resolution -> 1920 * 1080
  videoFrame = 0; // Recording frame rate -> 15
  referenceLineBol = false; // Divider -> Off
};

export let cameraDeviceIndex: number = 0;
export let photoResolutionWidth: number = 0;
export let photoResolutionHeight: number = 0;
export let videoResolutionWidth: number = 0;
export let videoResolutionHeight: number = 0;
export let videoFrame: string = '';