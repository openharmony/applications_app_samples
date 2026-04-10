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
 
import { photoAccessHelper } from "@kit.MediaLibraryKit";

export class Constants {
  // Step size. When the last obtained data index deviates from the center of the current sliding window by more
  // than this step, adjust the start and end of the window and re initiate the data request
  static readonly APP_KEY_INSTANCE_MEDIA_LIBRARY_ACCESS: string = 'app_key_instance_media_library_access';
  static readonly PHOTO_TYPE_IMAGE = photoAccessHelper.PhotoType.IMAGE;
  static readonly PHOTO_TYPE_VIDEO = photoAccessHelper.PhotoType.VIDEO;
  // Angle
  static readonly ANGLE_360: number = 360;
  static readonly ANGLE_270: number = 270;
  static readonly ANGLE_180: number = 180;
  static readonly ANGLE_90: number = 90;
  // fileAsset path data
  static readonly KEY_FILE_DATA: string = 'data';

  static readonly PHOTO_DATA_CHANGE: string = 'photo_data_change';

  static readonly MENU_KEY = 2067;
  static readonly TAB_KEY = 2090;
  static readonly KEY_DOWN_DURATION = 800;

  static readonly GRID_GUTTER: number = 5;
  static readonly GRID_CACHE_ROW_COUNT: number = 18;
  static readonly SOURCE_TOOL_MOUSE_CLICK: number = 7;
}