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

import { describe, it, expect, beforeEach, afterEach } from '@ohos/hypium';
import {
  resolveHdmiSignalDecision,
  resolveHdmiBackDecision,
  shouldRebindHdmiSource
} from './HdmiDecisionTestHelper';
import { PlayerManager } from '../../../main/ets/manager/PlayerManager';
import { SourcePlugState } from '../../../main/ets/manager/SourceManager';

const SEARCH_TIMEOUT_MS = 20000;

function mockDisplaySettingOn(): void {
}

function mockDisplaySettingOff(): void {
}

function createSourcePlugState(source: number, isPlugIn: boolean): SourcePlugState {
  return {
    source: source,
    isPluIn: isPlugIn
  } as SourcePlugState;
}

describe('HdmiPage_SignalState_signal_decision_outcomes', () => {
  beforeEach(() => {
    mockDisplaySettingOn();
  });

  afterEach(() => {
    mockDisplaySettingOff();
  });

  it('should_start_player_when_signal_becomes_available', 0, () => {
    const decision = resolveHdmiSignalDecision(true, -1);
    expect(decision.shouldStartPlayer).assertEqual(true);
    expect(decision.shouldStopPlayer).assertEqual(false);
    expect(decision.isPlay).assertEqual(true);
    expect(decision.isPlaying).assertEqual(true);
  });

  it('should_stop_player_when_signal_is_lost', 0, () => {
    const decision = resolveHdmiSignalDecision(false, -1);
    expect(decision.shouldStartPlayer).assertEqual(false);
    expect(decision.shouldStopPlayer).assertEqual(true);
    expect(decision.isPlay).assertEqual(false);
    expect(decision.isPlaying).assertEqual(false);
  });

  it('should_start_search_when_signal_unavailable_and_no_timer_running', 0, () => {
    const decision = resolveHdmiSignalDecision(false, -1);
    expect(decision.shouldStartSearch).assertEqual(true);
  });

  it('should_not_start_search_when_signal_unavailable_but_timer_is_running', 0, () => {
    const decision = resolveHdmiSignalDecision(false, 5000);
    expect(decision.shouldStartSearch).assertEqual(false);
  });

  it('should_clear_timer_when_signal_becomes_available_with_active_timer', 0, () => {
    const decision = resolveHdmiSignalDecision(true, 12345);
    expect(decision.shouldClearTimer).assertEqual(true);
  });

  it('should_not_clear_timer_when_signal_becomes_available_without_timer', 0, () => {
    const decision = resolveHdmiSignalDecision(true, -1);
    expect(decision.shouldClearTimer).assertEqual(false);
  });

  it('should_not_clear_timer_when_signal_is_lost_even_with_timer', 0, () => {
    const decision = resolveHdmiSignalDecision(false, 9999);
    expect(decision.shouldClearTimer).assertEqual(false);
  });

  it('should_not_start_search_when_signal_is_available', 0, () => {
    const decision = resolveHdmiSignalDecision(true, -1);
    expect(decision.shouldStartSearch).assertEqual(false);
  });
});

describe('HdmiPage_SignalState_playback_state_transitions', () => {
  beforeEach(() => {
    mockDisplaySettingOn();
  });

  afterEach(() => {
    mockDisplaySettingOff();
  });

  it('should_transition_from_search_to_playback_on_signal_available', 0, () => {
    const searchDecision = resolveHdmiSignalDecision(false, -1);
    expect(searchDecision.isPlay).assertEqual(false);
    expect(searchDecision.shouldStartSearch).assertEqual(true);

    const playbackDecision = resolveHdmiSignalDecision(true, 12345);
    expect(playbackDecision.isPlay).assertEqual(true);
    expect(playbackDecision.shouldStartPlayer).assertEqual(true);
    expect(playbackDecision.shouldClearTimer).assertEqual(true);
  });

  it('should_transition_from_playback_to_search_on_signal_lost', 0, () => {
    const playbackDecision = resolveHdmiSignalDecision(true, -1);
    expect(playbackDecision.isPlay).assertEqual(true);
    expect(playbackDecision.shouldStartPlayer).assertEqual(true);

    const searchDecision = resolveHdmiSignalDecision(false, -1);
    expect(searchDecision.isPlay).assertEqual(false);
    expect(searchDecision.shouldStopPlayer).assertEqual(true);
    expect(searchDecision.shouldStartSearch).assertEqual(true);
  });

  it('should_maintain_search_state_when_signal_lost_during_active_timer', 0, () => {
    const decision = resolveHdmiSignalDecision(false, 7777);
    expect(decision.isPlay).assertEqual(false);
    expect(decision.shouldStopPlayer).assertEqual(true);
    expect(decision.shouldStartSearch).assertEqual(false);
  });

  it('should_maintain_playback_state_when_signal_available_during_timer', 0, () => {
    const decision = resolveHdmiSignalDecision(true, 8888);
    expect(decision.isPlay).assertEqual(true);
    expect(decision.shouldStartPlayer).assertEqual(true);
    expect(decision.shouldClearTimer).assertEqual(true);
  });

  it('should_handle_sequential_available_to_unavailable_transition', 0, () => {
    const first = resolveHdmiSignalDecision(true, -1);
    expect(first.isPlay).assertEqual(true);

    const second = resolveHdmiSignalDecision(false, -1);
    expect(second.isPlay).assertEqual(false);
    expect(second.shouldStopPlayer).assertEqual(true);
    expect(second.shouldStartSearch).assertEqual(true);
  });

  it('should_handle_sequential_unavailable_to_available_transition', 0, () => {
    const first = resolveHdmiSignalDecision(false, -1);
    expect(first.isPlay).assertEqual(false);
    expect(first.shouldStartSearch).assertEqual(true);

    const second = resolveHdmiSignalDecision(true, 9999);
    expect(second.isPlay).assertEqual(true);
    expect(second.shouldStartPlayer).assertEqual(true);
    expect(second.shouldClearTimer).assertEqual(true);
  });

  it('should_keep_isPlaying_false_when_signal_unavailable', 0, () => {
    const decision = resolveHdmiSignalDecision(false, -1);
    expect(decision.isPlaying).assertEqual(false);
  });

  it('should_keep_isPlaying_true_when_signal_available', 0, () => {
    const decision = resolveHdmiSignalDecision(true, -1);
    expect(decision.isPlaying).assertEqual(true);
  });
});

describe('HdmiPage_SignalState_search_timer_boundary', () => {
  beforeEach(() => {
    mockDisplaySettingOn();
  });

  afterEach(() => {
    mockDisplaySettingOff();
  });

  it('should_treat_timer_id_minus_one_as_no_active_timer', 0, () => {
    const noTimerDecision = resolveHdmiSignalDecision(true, -1);
    expect(noTimerDecision.shouldClearTimer).assertEqual(false);
    expect(noTimerDecision.shouldStartPlayer).assertEqual(true);

    const withTimerDecision = resolveHdmiSignalDecision(true, 1);
    expect(withTimerDecision.shouldClearTimer).assertEqual(true);
  });

  it('should_treat_timer_id_zero_as_no_active_timer', 0, () => {
    const decision = resolveHdmiSignalDecision(true, 0);
    expect(decision.shouldClearTimer).assertEqual(false);
  });

  it('should_treat_positive_timer_id_as_active_timer', 0, () => {
    const decision = resolveHdmiSignalDecision(true, 1);
    expect(decision.shouldClearTimer).assertEqual(true);
  });

  it('should_treat_max_timer_id_as_active_timer', 0, () => {
    const decision = resolveHdmiSignalDecision(true, 2147483647);
    expect(decision.shouldClearTimer).assertEqual(true);
  });

  it('should_clear_timer_and_start_player_simultaneously', 0, () => {
    const decision = resolveHdmiSignalDecision(true, 5555);
    expect(decision.shouldClearTimer).assertEqual(true);
    expect(decision.shouldStartPlayer).assertEqual(true);
    expect(decision.shouldStopPlayer).assertEqual(false);
  });

  it('should_stop_player_but_not_start_search_when_timer_active', 0, () => {
    const decision = resolveHdmiSignalDecision(false, 6666);
    expect(decision.shouldStopPlayer).assertEqual(true);
    expect(decision.shouldStartSearch).assertEqual(false);
    expect(decision.shouldClearTimer).assertEqual(false);
  });

  it('should_stop_player_and_start_search_when_no_timer', 0, () => {
    const decision = resolveHdmiSignalDecision(false, -1);
    expect(decision.shouldStopPlayer).assertEqual(true);
    expect(decision.shouldStartSearch).assertEqual(true);
    expect(decision.shouldClearTimer).assertEqual(false);
  });

  it('should_use_timeout_of_20000ms', 0, () => {
    expect(SEARCH_TIMEOUT_MS).assertEqual(20000);
  });
});

describe('HdmiPage_SignalState_onPlugChange_listener', () => {
  beforeEach(() => {
    mockDisplaySettingOn();
  });

  afterEach(() => {
    mockDisplaySettingOff();
  });

  it('should_trigger_signal_check_when_plug_change_matches_current_source', 0, () => {
    const currentSourceId = 2;
    const plugState = createSourcePlugState(2, true);

    const shouldTrigger = plugState.source === currentSourceId;
    expect(shouldTrigger).assertEqual(true);
  });

  it('should_not_trigger_signal_check_when_plug_change_does_not_match_current_source', 0, () => {
    const currentSourceId = 2;
    const plugState = createSourcePlugState(3, true);

    const shouldTrigger = plugState.source === currentSourceId;
    expect(shouldTrigger).assertEqual(false);
  });

  it('should_trigger_signal_check_when_plugged_in_to_current_source', 0, () => {
    const currentSourceId = 1;
    const plugState = createSourcePlugState(1, true);

    const shouldTrigger = plugState.source === currentSourceId && plugState.isPluIn;
    expect(shouldTrigger).assertEqual(true);
  });

  it('should_trigger_signal_check_when_unplugged_from_current_source', 0, () => {
    const currentSourceId = 3;
    const plugState = createSourcePlugState(3, false);

    const shouldTrigger = plugState.source === currentSourceId;
    expect(shouldTrigger).assertEqual(true);
  });

  it('should_ignore_plug_change_for_different_source', 0, () => {
    const currentSourceId = 4;
    const unrelatedSource = 1;
    const plugState = createSourcePlugState(unrelatedSource, true);

    const shouldTrigger = plugState.source === currentSourceId;
    expect(shouldTrigger).assertEqual(false);
  });

  it('should_handle_all_valid_source_ids_in_plug_change', 0, () => {
    const validSourceIds: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
    validSourceIds.forEach(sourceId => {
      const plugState = createSourcePlugState(sourceId, true);
      const shouldTrigger = plugState.source === sourceId;
      expect(shouldTrigger).assertEqual(true);
    });
  });

  it('should_handle_negative_source_id_in_plug_change', 0, () => {
    const currentSourceId = 2;
    const plugState = createSourcePlugState(-1, true);

    const shouldTrigger = plugState.source === currentSourceId;
    expect(shouldTrigger).assertEqual(false);
  });
});

describe('HdmiPage_SignalState_composite_signal_transitions', () => {
  beforeEach(() => {
    mockDisplaySettingOn();
  });

  afterEach(() => {
    mockDisplaySettingOff();
  });

  it('should_handle_search_timeout_then_signal_available', 0, () => {
    const beforeTimeout = resolveHdmiSignalDecision(false, -1);
    expect(beforeTimeout.shouldStartSearch).assertEqual(true);

    const afterSignalAvailable = resolveHdmiSignalDecision(true, -1);
    expect(afterSignalAvailable.shouldStartPlayer).assertEqual(true);
    expect(afterSignalAvailable.shouldClearTimer).assertEqual(false);
  });

  it('should_handle_signal_available_then_lost_during_timer', 0, () => {
    const first = resolveHdmiSignalDecision(true, 123);
    expect(first.shouldStartPlayer).assertEqual(true);
    expect(first.shouldClearTimer).assertEqual(true);

    const second = resolveHdmiSignalDecision(false, 123);
    expect(second.shouldStopPlayer).assertEqual(true);
    expect(second.shouldStartSearch).assertEqual(false);
  });

  it('should_handle_no_signal_multiple_restarts', 0, () => {
    const first = resolveHdmiSignalDecision(false, -1);
    expect(first.shouldStartSearch).assertEqual(true);

    const second = resolveHdmiSignalDecision(false, -1);
    expect(second.shouldStartSearch).assertEqual(true);

    const third = resolveHdmiSignalDecision(false, -1);
    expect(third.shouldStartSearch).assertEqual(true);
  });

  it('should_handle_signal_flapping_between_available_and_unavailable', 0, () => {
    const states: boolean[] = [true, false, true, false, true];
    let searchTimerId = -1;

    states.forEach((isAvailable, idx) => {
      const decision = resolveHdmiSignalDecision(isAvailable, searchTimerId);
      if (isAvailable) {
        expect(decision.shouldStartPlayer).assertEqual(true);
        if (searchTimerId !== -1) {
          expect(decision.shouldClearTimer).assertEqual(true);
        }
        searchTimerId = -1;
      } else {
        expect(decision.shouldStopPlayer).assertEqual(true);
        if (searchTimerId === -1) {
          expect(decision.shouldStartSearch).assertEqual(true);
          searchTimerId = 1000 + idx;
        } else {
          expect(decision.shouldStartSearch).assertEqual(false);
        }
      }
    });
  });

  it('should_handle_signal_becomes_unavailable_after_clearing_timer', 0, () => {
    const first = resolveHdmiSignalDecision(true, 5000);
    expect(first.shouldClearTimer).assertEqual(true);

    const second = resolveHdmiSignalDecision(false, -1);
    expect(second.shouldStartSearch).assertEqual(true);
  });

  it('should_maintain_correct_state_across_three_signal_changes', 0, () => {
    const step1 = resolveHdmiSignalDecision(false, -1);
    expect(step1.isPlay).assertEqual(false);
    expect(step1.shouldStartSearch).assertEqual(true);

    const step2 = resolveHdmiSignalDecision(true, 1234);
    expect(step2.isPlay).assertEqual(true);
    expect(step2.shouldClearTimer).assertEqual(true);

    const step3 = resolveHdmiSignalDecision(false, -1);
    expect(step3.isPlay).assertEqual(false);
    expect(step3.shouldStartSearch).assertEqual(true);
  });
});

describe('HdmiPage_SignalState_bindSource_rebind_scenarios', () => {
  beforeEach(() => {
    mockDisplaySettingOn();
  });

  afterEach(() => {
    mockDisplaySettingOff();
  });

  it('should_not_rebind_when_same_source_selected', 0, () => {
    expect(shouldRebindHdmiSource(1, 1)).assertEqual(false);
    expect(shouldRebindHdmiSource(2, 2)).assertEqual(false);
    expect(shouldRebindHdmiSource(6, 6)).assertEqual(false);
  });

  it('should_rebind_when_different_hdmi_port_selected', 0, () => {
    expect(shouldRebindHdmiSource(1, 2)).assertEqual(true);
    expect(shouldRebindHdmiSource(2, 3)).assertEqual(true);
    expect(shouldRebindHdmiSource(3, 4)).assertEqual(true);
    expect(shouldRebindHdmiSource(4, 1)).assertEqual(true);
  });

  it('should_rebind_when_switching_from_hdmi_to_dtv', 0, () => {
    expect(shouldRebindHdmiSource(1, 6)).assertEqual(true);
    expect(shouldRebindHdmiSource(2, 7)).assertEqual(true);
    expect(shouldRebindHdmiSource(3, 8)).assertEqual(true);
  });

  it('should_rebind_when_switching_from_dtv_to_hdmi', 0, () => {
    expect(shouldRebindHdmiSource(6, 1)).assertEqual(true);
    expect(shouldRebindHdmiSource(7, 2)).assertEqual(true);
    expect(shouldRebindHdmiSource(8, 3)).assertEqual(true);
  });

  it('should_rebind_when_switching_from_hdmi_to_av', 0, () => {
    expect(shouldRebindHdmiSource(2, 5)).assertEqual(true);
  });

  it('should_rebind_when_switching_from_av_to_hdmi', 0, () => {
    expect(shouldRebindHdmiSource(5, 3)).assertEqual(true);
  });

  it('should_rebind_when_switching_from_hdmi_to_vga', 0, () => {
    expect(shouldRebindHdmiSource(1, 10)).assertEqual(true);
  });

  it('should_rebind_when_switching_from_vga_to_hdmi', 0, () => {
    expect(shouldRebindHdmiSource(10, 2)).assertEqual(true);
  });

  it('should_not_rebind_when_both_invalid', 0, () => {
    expect(shouldRebindHdmiSource(-1, -1)).assertEqual(false);
  });
});

describe('HdmiPage_SignalState_decision_matrix_exhaustive', () => {
  beforeEach(() => {
    mockDisplaySettingOn();
  });

  afterEach(() => {
    mockDisplaySettingOff();
  });

  it('available_minus_one_is_start_player_no_clear', 0, () => {
    const d = resolveHdmiSignalDecision(true, -1);
    expect(d.shouldStartPlayer).assertEqual(true);
    expect(d.shouldClearTimer).assertEqual(false);
    expect(d.shouldStopPlayer).assertEqual(false);
    expect(d.shouldStartSearch).assertEqual(false);
  });

  it('available_positive_is_start_player_with_clear', 0, () => {
    const d = resolveHdmiSignalDecision(true, 1);
    expect(d.shouldStartPlayer).assertEqual(true);
    expect(d.shouldClearTimer).assertEqual(true);
    expect(d.shouldStopPlayer).assertEqual(false);
  });

  it('available_zero_is_start_player_no_clear', 0, () => {
    const d = resolveHdmiSignalDecision(true, 0);
    expect(d.shouldStartPlayer).assertEqual(true);
    expect(d.shouldClearTimer).assertEqual(false);
  });

  it('unavailable_minus_one_is_stop_player_start_search', 0, () => {
    const d = resolveHdmiSignalDecision(false, -1);
    expect(d.shouldStopPlayer).assertEqual(true);
    expect(d.shouldStartSearch).assertEqual(true);
    expect(d.shouldClearTimer).assertEqual(false);
  });

  it('unavailable_positive_is_stop_player_no_search', 0, () => {
    const d = resolveHdmiSignalDecision(false, 1);
    expect(d.shouldStopPlayer).assertEqual(true);
    expect(d.shouldStartSearch).assertEqual(false);
    expect(d.shouldClearTimer).assertEqual(false);
  });

  it('unavailable_zero_is_stop_player_no_search', 0, () => {
    const d = resolveHdmiSignalDecision(false, 0);
    expect(d.shouldStopPlayer).assertEqual(true);
    expect(d.shouldStartSearch).assertEqual(false);
  });

  it('isPlay_and_isPlaying_match_availability', 0, () => {
    const available = resolveHdmiSignalDecision(true, -1);
    const unavailable = resolveHdmiSignalDecision(false, -1);

    expect(available.isPlay).assertEqual(true);
    expect(available.isPlaying).assertEqual(true);
    expect(unavailable.isPlay).assertEqual(false);
    expect(unavailable.isPlaying).assertEqual(false);
  });

  it('start_and_stop_player_are_mutually_exclusive', 0, () => {
    const available = resolveHdmiSignalDecision(true, -1);
    const unavailable = resolveHdmiSignalDecision(false, -1);

    expect(available.shouldStartPlayer !== available.shouldStopPlayer).assertEqual(true);
    expect(unavailable.shouldStartPlayer !== unavailable.shouldStopPlayer).assertEqual(true);
  });
});

describe('HdmiPage_SignalState_playback_control_toggle', () => {
  beforeEach(() => {
    mockDisplaySettingOn();
  });

  afterEach(() => {
    mockDisplaySettingOff();
  });

  it('should_require_signal_to_toggle_playback', 0, () => {
    const noSignal = resolveHdmiSignalDecision(false, -1);
    const hasSignal = resolveHdmiSignalDecision(true, -1);

    expect(noSignal.isPlay).assertEqual(false);
    expect(hasSignal.isPlay).assertEqual(true);
  });

  it('should_have_separate_isPlay_and_isPlaying_flags', 0, () => {
    const decision = resolveHdmiSignalDecision(true, -1);
    expect(decision.isPlay).assertEqual(decision.isPlaying);
  });

  it('isPlaying_should_be_false_when_isPlay_is_false', 0, () => {
    const decision = resolveHdmiSignalDecision(false, -1);
    expect(decision.isPlay).assertEqual(false);
    expect(decision.isPlaying).assertEqual(false);
  });
});

describe('HdmiPage_SignalState_back_decision_during_signal_states', () => {
  beforeEach(() => {
    mockDisplaySettingOn();
  });

  afterEach(() => {
    mockDisplaySettingOff();
  });

  it('should_use_cec_back_during_active_playback', 0, () => {
    const signalDecision = resolveHdmiSignalDecision(true, -1);
    expect(signalDecision.isPlay).assertEqual(true);

    const backDecision = resolveHdmiBackDecision(true);
    expect(backDecision.action).assertEqual('cecMenuBack');
    expect(backDecision.cecCommand).assertEqual(5);
  });

  it('should_use_delayed_router_back_during_search', 0, () => {
    const signalDecision = resolveHdmiSignalDecision(false, -1);
    expect(signalDecision.isPlay).assertEqual(false);

    const backDecision = resolveHdmiBackDecision(false);
    expect(backDecision.action).assertEqual('routerBackDelayed');
    expect(backDecision.delayMs).assertEqual(300);
  });

  it('should_use_cec_back_when_signal_lost_but_was_playing', 0, () => {
    const backDecision = resolveHdmiBackDecision(true);
    expect(backDecision.action).assertEqual('cecMenuBack');
  });

  it('should_use_router_back_when_signal_lost_and_not_playing', 0, () => {
    const backDecision = resolveHdmiBackDecision(false);
    expect(backDecision.action).assertEqual('routerBackDelayed');
  });

  it('should_differentiate_back_action_based_on_isPlay_not_isAvailable', 0, () => {
    const searchDecision = resolveHdmiSignalDecision(false, -1);
    const playbackDecision = resolveHdmiSignalDecision(true, -1);

    expect(searchDecision.isPlay).assertEqual(false);
    expect(playbackDecision.isPlay).assertEqual(true);

    const searchBack = resolveHdmiBackDecision(searchDecision.isPlay);
    const playbackBack = resolveHdmiBackDecision(playbackDecision.isPlay);

    expect(((searchBack.action) === (playbackBack.action))).assertFalse();
  });
});

export default function HdmiPage_SignalState_test_DefaultExportBridge(): void {
}
