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
import { bindKeyClick } from '../../../main/ets/utils/KeyEvent';

interface KeyBindingTarget {
  leftClick?: () => void;
  rightClick?: () => void;
  upClick?: () => void;
  downClick?: () => void;
  tabClick?: () => void;
}

/**
 * Registers tests for key helper binding semantics used by page test fixtures.
 *
 * @returns void.
 */
export default function KeyEventTest(): void {
  describe('KeyEvent_real', () => {
    it('should_bind_navigation_helpers_to_plain_object', 0, () => {
      const target: KeyBindingTarget = {};

      // Binding helper methods onto arbitrary objects lets legacy page tests
      // express remote-control intent without directly touching InputKit mocks.
      bindKeyClick(target as Object);

      expect(typeof target.leftClick === 'function').assertEqual(true);
      expect(typeof target.rightClick === 'function').assertEqual(true);
      expect(typeof target.upClick === 'function').assertEqual(true);
      expect(typeof target.downClick === 'function').assertEqual(true);
      expect(typeof target.tabClick === 'function').assertEqual(true);
    });

    it('should_ignore_non_object_targets_without_throwing', 0, () => {
      let didThrow = false;

      try {
        // Defensive no-op behavior matters because some generated tests pass
        // partial fixture handles before object assembly is fully complete.
        bindKeyClick(undefined);
        bindKeyClick('not-an-object');
        bindKeyClick(100);
      } catch (error) {
        didThrow = true;
      }

      expect(didThrow).assertEqual(false);
    });
  });
}

