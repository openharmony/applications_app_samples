/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 ("the License");
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

import { Permissions } from '@kit.AbilityKit';

class CameraConstant {
  static readonly RATIO_PHOTO: number = 4 / 3;
  static readonly RATIO_VIDEO: number = 16 / 9;
  static readonly PERMISSIONS: Permissions[] = [
    'ohos.permission.CAMERA',
    'ohos.permission.MICROPHONE',
    'ohos.permission.WRITE_IMAGEVIDEO',
    'ohos.permission.READ_IMAGEVIDEO',
    'ohos.permission.APPROXIMATELY_LOCATION',
    'ohos.permission.MEDIA_LOCATION',
  ];
}

export default CameraConstant;