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

import { describe, it } from '@ohos/hypium';
import { TVDeviceManagerUiHarness } from './base/UiTestHarness';
import { TestAsserts } from './base/TestAsserts';

export default function rotationAndResolutionMatrixTest(): void {
  describe('TVDeviceManagerUiRotationAndResolutionMatrixTest', () => {
    it('should expose four display rotations and four display matrices', 0, () => {
      TestAsserts.assertRotationMatrix(TVDeviceManagerUiHarness.getRotationNames());
      TestAsserts.assertArrayLength(TVDeviceManagerUiHarness.createDisplayMatrix(), 4);
    });
  });
}
