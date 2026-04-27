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
  resolveHdmiBackDecision,
  resolveHdmiPageSourceId,
  resolveHdmiSignalDecision,
  shouldRebindHdmiSource
} from './HdmiDecisionTestHelper';

/**
 * Registers tests for HDMI page signal, CEC and back-key decisions.
 *
 * @returns void.
 */
export default function HdmiPageTest(): void {
  describe('HdmiPage_real', () => {
    it('should_start_playback_and_clear_timer_when_signal_becomes_available', 0, () => {
      const decision = resolveHdmiSignalDecision(true, 1001);

      // Once signal is available the page should leave search mode, resume
      // playback and cancel any pending timeout that would hide the loader.
      expect(decision.isPlay).assertEqual(true);
      expect(decision.isPlaying).assertEqual(true);
      expect(decision.shouldStartPlayer).assertEqual(true);
      expect(decision.shouldClearTimer).assertEqual(true);
    });

    it('should_stop_playback_and_restart_search_when_no_timer_exists', 0, () => {
      const decision = resolveHdmiSignalDecision(false, -1);

      expect(decision.isPlay).assertEqual(false);
      expect(decision.isPlaying).assertEqual(false);
      expect(decision.shouldStopPlayer).assertEqual(true);
      expect(decision.shouldStartSearch).assertEqual(true);
    });

    it('should_use_delayed_router_back_when_not_playing', 0, () => {
      const decision = resolveHdmiBackDecision(false);

      expect(decision.action).assertEqual('routerBackDelayed');
      expect(decision.delayMs).assertEqual(300);
      expect(decision.cecCommand).assertEqual(-1);
    });

    it('should_send_cec_back_command_when_playing', 0, () => {
      const decision = resolveHdmiBackDecision(true);

      // Active HDMI playback should hand the back action to CEC so the external
      // device receives the command instead of immediately leaving playback.
      expect(decision.action).assertEqual('cecMenuBack');
      expect(decision.cecCommand).assertEqual(5);
    });

    it('should_only_rebind_when_cec_selects_a_different_source', 0, () => {
      expect(shouldRebindHdmiSource(3, 3)).assertEqual(false);
      expect(shouldRebindHdmiSource(3, 4)).assertEqual(true);
    });

    it('should_use_router_source_when_reboot_cache_is_empty', 0, () => {
      const sourceId = resolveHdmiPageSourceId(-1, 4);

      expect(sourceId).assertEqual(4);
    });

    it('should_prefer_reboot_source_when_cache_exists', 0, () => {
      const sourceId = resolveHdmiPageSourceId(2, 4);

      // Reboot relaunch should keep the persisted source id so the HDMI page
      // restores the same input even before fresh router params are consumed.
      expect(sourceId).assertEqual(2);
    });
  });
}

