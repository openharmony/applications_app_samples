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
import {
  resolveIndexFocusMove,
  resolveIndexNavigationDecision,
  shouldHandleIndexTouchSelection
} from '../../../main/ets/pages/Index';

/**
 * Registers tests for index-page input handling decisions.
 *
 * @returns void.
 */
export default function InputHandlingTest(): void {
  describe('InputHandling_real', () => {
    it('should_move_focus_left_without_scrolling_when_target_stays_visible', 0, () => {
      const decision = resolveIndexFocusMove(2, 2, 6, 'left');

      // Remote left navigation should stay lightweight while the next target is
      // still inside the current viewport of the horizontal source list.
      expect(decision.nextFocusIndex).assertEqual(1);
      expect(decision.shouldScroll).assertEqual(false);
      expect(decision.scrollTarget).assertEqual(1);
    });

    it('should_block_hdmi_navigation_when_touch_tool_is_not_allowed', 0, () => {
      const canHandleTouch = shouldHandleIndexTouchSelection(true, -1);
      const navigation = resolveIndexNavigationDecision(3, [
        { name: 'HDMI3', status: true, visibility: true }
      ]);

      expect(canHandleTouch).assertEqual(false);
      expect(navigation.action).assertEqual('navigateHdmi');
    });

    it('should_show_settings_toast_for_disabled_hdmi_after_valid_input', 0, () => {
      const canHandleTouch = shouldHandleIndexTouchSelection(true, 7);
      const navigation = resolveIndexNavigationDecision(1, [
        { name: 'HDMI1', status: false, visibility: true }
      ]);

      expect(canHandleTouch).assertEqual(true);
      expect(navigation.action).assertEqual('toast');
      expect(navigation.toastMessage).assertEqual('请打开设置HDMI1输入开关!');
    });
  });
}

