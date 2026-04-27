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
import { resolveIndexFocusMove, resolveIndexInitialFocus } from '../../../main/ets/pages/Index';

/**
 * Registers tests for index-page focus restoration and boundary movement.
 *
 * @returns void.
 */
export default function FocusTest(): void {
  describe('Focus_real', () => {
    it('should_keep_focus_at_zero_when_moving_left_from_first_item', 0, () => {
      const decision = resolveIndexFocusMove(0, 0, 5, 'left');

      // Boundary navigation should clamp to the first item and avoid negative
      // indices that would break focus restoration in the horizontal list.
      expect(decision.nextFocusIndex).assertEqual(0);
      expect(decision.shouldScroll).assertEqual(false);
    });

    it('should_keep_focus_at_last_item_when_moving_right_from_end', 0, () => {
      const decision = resolveIndexFocusMove(4, 4, 5, 'right');

      expect(decision.nextFocusIndex).assertEqual(4);
      expect(decision.shouldScroll).assertEqual(false);
    });

    it('should_preserve_requested_default_source_when_it_is_already_visible', 0, () => {
      const decision = resolveIndexInitialFocus([1, 2, 3, 4], 3, 2);

      expect(decision.defaultSourceId).assertEqual(3);
      expect(decision.focusIndex).assertEqual(2);
      expect(decision.focusSourceId).assertEqual(3);
      expect(decision.shouldScroll).assertEqual(false);
    });
  });
}

