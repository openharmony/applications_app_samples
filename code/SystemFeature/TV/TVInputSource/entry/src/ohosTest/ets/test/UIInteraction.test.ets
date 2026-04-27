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
import { shouldHandleIndexTouchSelection } from '../../../main/ets/pages/Index';

/**
 * Registers tests for index-page touch interaction filtering.
 *
 * @returns void.
 */
export default function UIInteractionTest(): void {
  describe('UIInteraction_real', () => {
    it('should_reject_selection_when_event_is_not_a_valid_touch_event', 0, () => {
      const result = shouldHandleIndexTouchSelection(false, 7);

      // The page should stop before tool-specific checks if the generic touch
      // filter already decided the incoming event is not actionable.
      expect(result).assertEqual(false);
    });

    it('should_accept_mouse_click_tool_after_touch_validation', 0, () => {
      const result = shouldHandleIndexTouchSelection(true, 7);

      expect(result).assertEqual(true);
    });

    it('should_reject_other_tools_after_touch_validation', 0, () => {
      const result = shouldHandleIndexTouchSelection(true, -1);

      expect(result).assertEqual(false);
    });
  });
}

