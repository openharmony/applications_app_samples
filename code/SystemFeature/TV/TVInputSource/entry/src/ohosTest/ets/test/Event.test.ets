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

import { describe, beforeEach, afterEach, it, expect } from '@ohos/hypium';
import { EventUtil } from '../../../main/ets/common/EventUtil';
import { PointerUtil } from '../../../main/ets/common/PointerUtil';
import { patchMember, restoreAll } from './Batch1TestHelper';

/**
 * Registers tests for touch-event filtering and pointer style side effects.
 *
 * @returns void.
 */
export default function EventTest(): void {
  describe('EventUtil_real', () => {
    let restores: Array<() => void> = [];
    let pointerStates: boolean[] = [];

    beforeEach(() => {
      restores = [];
      pointerStates = [];
      restores.push(
        patchMember(PointerUtil as Object, 'changePointStyle', (isClick: boolean): void => {
          pointerStates.push(isClick);
        }),
      );
    });

    afterEach(() => {
      restoreAll(restores);
    });

    it('should_reject_touch_down_and_mark_pointer_as_pressed', 0, () => {
      const event = {
        type: TouchType.Down,
        source: SourceType.Mouse
      } as TouchEvent;

      // Down events are filtered because page logic wants the completed action,
      // but pointer visuals still need immediate feedback for responsiveness.
      const result = EventUtil.isTouchEvent(event);

      expect(result).assertEqual(false);
      expect(pointerStates.join(',')).assertEqual('true');
    });

    it('should_accept_mouse_or_touchscreen_release_events', 0, () => {
      const mouseUp = {
        type: TouchType.Up,
        source: SourceType.Mouse
      } as TouchEvent;
      const touchUp = {
        type: TouchType.Up,
        source: SourceType.TouchScreen
      } as TouchEvent;

      expect(EventUtil.isTouchEvent(mouseUp)).assertEqual(true);
      expect(EventUtil.isTouchEvent(touchUp)).assertEqual(true);
      expect(pointerStates.join(',')).assertEqual('false,false');
    });

    it('should_reject_non_pointer_sources_even_after_release', 0, () => {
      const event = {
        type: TouchType.Up,
        source: 999
      } as TouchEvent;

      // This guard prevents keyboard-originated interactions from being treated
      // as touch taps, which would break focus-driven TV navigation semantics.
      const result = EventUtil.isTouchEvent(event);

      expect(result).assertEqual(false);
      expect(pointerStates.join(',')).assertEqual('false');
    });
  });
}

