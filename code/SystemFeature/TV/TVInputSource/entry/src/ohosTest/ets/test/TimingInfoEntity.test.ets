/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { describe, it, expect } from '@ohos/hypium';
import { TimingInfoEntity } from '../../../main/ets/entity/TimingInfoEntity';

/**
 * Registers tests for timing metadata mutation used by source information views.
 *
 * @returns void.
 */
export default function TimingInfoEntityTest(): void {
  describe('TimingInfoEntity_real', () => {
    it('should_store_resolution_frame_rate_and_scan_type', 0, () => {
      const entity = new TimingInfoEntity();

      // Timing values are read back independently by formatting utilities, so
      // every field needs a direct getter/setter assertion to stay trustworthy.
      entity.setWidth(1920);
      entity.setHeight(1080);
      entity.setFrameRate(60);
      entity.setIsInterlace(true);

      expect(entity.getWidth()).assertEqual(1920);
      expect(entity.getHeight()).assertEqual(1080);
      expect(entity.getFrameRate()).assertEqual(60);
      expect(entity.getIsInterlace()).assertEqual(true);
    });
  });
}

