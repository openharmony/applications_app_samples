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
import { SourcePlugStateEntity } from '../../../main/ets/entity/SourcePlugStateEntity';

/**
 * Registers tests for source plug entity state mutation and retrieval.
 *
 * @returns void.
 */
export default function SourcePlugStateEntityTest(): void {
  describe('SourcePlugStateEntity_real', () => {
    it('should_store_constructor_values_and_allow_updates', 0, () => {
      const entity = new SourcePlugStateEntity(3, true, 2, 'HDMI3');

      // Entity setters are heavily used by page-level observers, so these
      // tests guard against accidental refactors that break observation state.
      expect(entity.getSourceId()).assertEqual(3);
      expect(entity.getIsPlugIn()).assertEqual(true);
      expect(entity.getDisplayOrder()).assertEqual(2);
      expect(entity.getSourceName()).assertEqual('HDMI3');

      entity.setSourceId(5);
      entity.setIsPlugIn(false);
      entity.setDisplayOrder(4);
      entity.setSourceName('AV');

      expect(entity.getSourceId()).assertEqual(5);
      expect(entity.getIsPlugIn()).assertEqual(false);
      expect(entity.getDisplayOrder()).assertEqual(4);
      expect(entity.getSourceName()).assertEqual('AV');
    });
  });
}

