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
  resolveHdmiBackDecision
} from './HdmiDecisionTestHelper';

const HDMI_PAGE_URL = 'pages/HdmiPage';
const CEC_MENU_BACK_COMMAND = 5;
const ROUTER_BACK_DELAY_MS = 300;
const CEC_COMMAND_INVALID = -1;

class HdmiBackStrategyLifecycle {
  public isPlay: boolean = false;
  public isSearch: boolean = false;
  public backActionInvoked: boolean = false;
  public routerBackDelayed: boolean = false;
  public cecCommandSent: number = CEC_COMMAND_INVALID;
  public delayMs: number = 0;
  public backPressCount: number = 0;
  public lastBackDecision: string = '';
  public pendingRouterBack: boolean = false;
  public routerBackTimeoutId: number = -1;

  constructor(isPlay: boolean = false, isSearch: boolean = false) {
    this.isPlay = isPlay;
    this.isSearch = isSearch;
  }

  resolveBackDecision(): void {
    const decision = resolveHdmiBackDecision(this.isPlay);
    this.lastBackDecision = decision.action;
    this.delayMs = decision.delayMs;
    this.cecCommandSent = decision.cecCommand;
    this.backActionInvoked = true;
  }

  executeOnBackPress(): boolean {
    this.backPressCount++;
    this.resolveBackDecision();

    if (this.lastBackDecision === 'routerBackDelayed') {
      this.routerBackDelayed = true;
      this.pendingRouterBack = true;
      return true;
    }

    if (this.lastBackDecision === 'cecMenuBack') {
      this.cecCommandSent = CEC_MENU_BACK_COMMAND;
      return true;
    }

    return false;
  }

  simulateRouterBackTimeout(): void {
    if (this.pendingRouterBack) {
      this.pendingRouterBack = false;
      this.routerBackDelayed = false;
    }
  }

  cancelPendingRouterBack(): void {
    this.pendingRouterBack = false;
  }

  reset(): void {
    this.isPlay = false;
    this.isSearch = false;
    this.backActionInvoked = false;
    this.routerBackDelayed = false;
    this.cecCommandSent = CEC_COMMAND_INVALID;
    this.delayMs = 0;
    this.backPressCount = 0;
    this.lastBackDecision = '';
    this.pendingRouterBack = false;
    this.routerBackTimeoutId = -1;
  }
}

function mockDisplaySettingOn(): void {
}

function mockDisplaySettingOff(): void {
}

describe('HdmiPage_BackStrategy_onBackPress_return_key_behavior', () => {
  let lifecycle: HdmiBackStrategyLifecycle;

  beforeEach(() => {
    mockDisplaySettingOn();
    lifecycle = new HdmiBackStrategyLifecycle();
  });

  afterEach(() => {
    mockDisplaySettingOff();
  });

  it('should_return_true_when_back_pressed_during_playback', 0, () => {
    lifecycle.isPlay = true;
    const result = lifecycle.executeOnBackPress();
    expect(result).assertEqual(true);
  });

  it('should_return_true_when_back_pressed_during_search', 0, () => {
    lifecycle.isPlay = false;
    lifecycle.isSearch = true;
    const result = lifecycle.executeOnBackPress();
    expect(result).assertEqual(true);
  });

  it('should_increment_back_press_count_on_each_press', 0, () => {
    lifecycle.isPlay = true;
    lifecycle.executeOnBackPress();
    lifecycle.executeOnBackPress();
    expect(lifecycle.backPressCount).assertEqual(2);
  });

  it('should_set_cec_command_during_playback', 0, () => {
    lifecycle.isPlay = true;
    lifecycle.executeOnBackPress();
    expect(lifecycle.cecCommandSent).assertEqual(CEC_MENU_BACK_COMMAND);
  });

  it('should_have_zero_delay_during_playback', 0, () => {
    lifecycle.isPlay = true;
    lifecycle.resolveBackDecision();
    expect(lifecycle.delayMs).assertEqual(0);
  });

  it('should_have_300ms_delay_during_search', 0, () => {
    lifecycle.isPlay = false;
    lifecycle.resolveBackDecision();
    expect(lifecycle.delayMs).assertEqual(ROUTER_BACK_DELAY_MS);
  });

  it('should_have_invalid_cec_command_during_search', 0, () => {
    lifecycle.isPlay = false;
    lifecycle.resolveBackDecision();
    expect(lifecycle.cecCommandSent).assertEqual(CEC_COMMAND_INVALID);
  });

  it('should_trigger_router_back_delayed_during_search', 0, () => {
    lifecycle.isPlay = false;
    lifecycle.executeOnBackPress();
    expect(lifecycle.routerBackDelayed).assertEqual(true);
  });

  it('should_trigger_cec_menu_back_during_playback', 0, () => {
    lifecycle.isPlay = true;
    lifecycle.executeOnBackPress();
    expect(lifecycle.lastBackDecision).assertEqual('cecMenuBack');
  });

  it('should_not_trigger_router_back_during_playback', 0, () => {
    lifecycle.isPlay = true;
    lifecycle.executeOnBackPress();
    expect(lifecycle.routerBackDelayed).assertEqual(false);
  });
});

describe('HdmiPage_BackStrategy_cea_menu_control', () => {
  let lifecycle: HdmiBackStrategyLifecycle;

  beforeEach(() => {
    mockDisplaySettingOn();
    lifecycle = new HdmiBackStrategyLifecycle();
  });

  afterEach(() => {
    mockDisplaySettingOff();
  });

  it('should_send_cec_command_5_when_playing', 0, () => {
    lifecycle.isPlay = true;
    lifecycle.executeOnBackPress();
    expect(lifecycle.cecCommandSent).assertEqual(5);
  });

  it('should_not_send_cec_command_when_not_playing', 0, () => {
    lifecycle.isPlay = false;
    lifecycle.executeOnBackPress();
    expect(lifecycle.cecCommandSent).assertEqual(CEC_COMMAND_INVALID);
  });

  it('should_send_cec_menu_back_action_during_playback', 0, () => {
    lifecycle.isPlay = true;
    lifecycle.executeOnBackPress();
    expect(lifecycle.lastBackDecision).assertEqual('cecMenuBack');
  });

  it('should_send_router_back_delayed_action_during_search', 0, () => {
    lifecycle.isPlay = false;
    lifecycle.executeOnBackPress();
    expect(lifecycle.lastBackDecision).assertEqual('routerBackDelayed');
  });

  it('should_have_symmetric_behavior_between_playback_and_search', 0, () => {
    lifecycle.isPlay = true;
    lifecycle.resolveBackDecision();
    const playbackDecision = lifecycle.lastBackDecision;

    lifecycle.reset();
    lifecycle.isPlay = false;
    lifecycle.resolveBackDecision();
    const searchDecision = lifecycle.lastBackDecision;

    expect(((playbackDecision) === (searchDecision))).assertFalse();
  });

  it('should_maintain_zero_delay_for_cec_menu', 0, () => {
    lifecycle.isPlay = true;
    lifecycle.resolveBackDecision();
    expect(lifecycle.delayMs).assertEqual(0);
  });

  it('should_maintain_positive_delay_for_router_back', 0, () => {
    lifecycle.isPlay = false;
    lifecycle.resolveBackDecision();
    expect(lifecycle.delayMs > 0).assertEqual(true);
  });

  it('should_handle_multiple_back_presses_during_playback', 0, () => {
    lifecycle.isPlay = true;
    lifecycle.executeOnBackPress();
    lifecycle.executeOnBackPress();
    expect(lifecycle.backPressCount).assertEqual(2);
    expect(lifecycle.cecCommandSent).assertEqual(CEC_MENU_BACK_COMMAND);
  });
});

describe('HdmiPage_BackStrategy_no_signal_return_window', () => {
  let lifecycle: HdmiBackStrategyLifecycle;

  beforeEach(() => {
    mockDisplaySettingOn();
    lifecycle = new HdmiBackStrategyLifecycle();
  });

  afterEach(() => {
    mockDisplaySettingOff();
  });

  it('should_use_router_back_when_no_signal', 0, () => {
    lifecycle.isPlay = false;
    lifecycle.isSearch = false;
    lifecycle.executeOnBackPress();
    expect(lifecycle.lastBackDecision).assertEqual('routerBackDelayed');
  });

  it('should_use_delayed_router_back_for_no_signal_state', 0, () => {
    lifecycle.isPlay = false;
    lifecycle.isSearch = false;
    lifecycle.resolveBackDecision();
    expect(lifecycle.delayMs).assertEqual(ROUTER_BACK_DELAY_MS);
  });

  it('should_not_use_cec_command_for_no_signal_state', 0, () => {
    lifecycle.isPlay = false;
    lifecycle.isSearch = false;
    lifecycle.resolveBackDecision();
    expect(lifecycle.cecCommandSent).assertEqual(CEC_COMMAND_INVALID);
  });

  it('should_transition_to_no_signal_on_signal_loss', 0, () => {
    lifecycle.isPlay = true;
    lifecycle.resolveBackDecision();
    const playbackDecision = lifecycle.lastBackDecision;

    lifecycle.isPlay = false;
    lifecycle.resolveBackDecision();
    const noSignalDecision = lifecycle.lastBackDecision;

    expect(((playbackDecision) === (noSignalDecision))).assertFalse();
  });

  it('should_return_immediately_for_no_signal_window', 0, () => {
    lifecycle.isPlay = false;
    lifecycle.isSearch = false;
    lifecycle.resolveBackDecision();
    expect(lifecycle.delayMs).assertEqual(300);
  });

  it('should_handle_signal_timeout_transition', 0, () => {
    lifecycle.isPlay = false;
    lifecycle.isSearch = true;
    lifecycle.resolveBackDecision();
    expect(lifecycle.lastBackDecision).assertEqual('routerBackDelayed');

    lifecycle.isSearch = false;
    lifecycle.resolveBackDecision();
    expect(lifecycle.lastBackDecision).assertEqual('routerBackDelayed');
  });
});

describe('HdmiPage_BackStrategy_state_transitions', () => {
  let lifecycle: HdmiBackStrategyLifecycle;

  beforeEach(() => {
    mockDisplaySettingOn();
    lifecycle = new HdmiBackStrategyLifecycle();
  });

  afterEach(() => {
    mockDisplaySettingOff();
  });

  it('should_transition_from_playback_to_search_on_signal_loss', 0, () => {
    lifecycle.isPlay = true;
    lifecycle.resolveBackDecision();
    const playbackAction = lifecycle.lastBackDecision;

    lifecycle.isPlay = false;
    lifecycle.resolveBackDecision();
    const searchAction = lifecycle.lastBackDecision;

    expect(((playbackAction) === (searchAction))).assertFalse();
  });

  it('should_transition_from_search_to_playback_on_signal_recovery', 0, () => {
    lifecycle.isPlay = false;
    lifecycle.resolveBackDecision();
    const searchAction = lifecycle.lastBackDecision;

    lifecycle.isPlay = true;
    lifecycle.resolveBackDecision();
    const playbackAction = lifecycle.lastBackDecision;

    expect(((searchAction) === (playbackAction))).assertFalse();
  });

  it('should_maintain_consistent_cec_command_during_playback', 0, () => {
    lifecycle.isPlay = true;
    lifecycle.resolveBackDecision();
    const firstCecCommand = lifecycle.cecCommandSent;

    lifecycle.resolveBackDecision();
    const secondCecCommand = lifecycle.cecCommandSent;

    expect(firstCecCommand).assertEqual(secondCecCommand);
  });

  it('should_maintain_consistent_delay_during_search', 0, () => {
    lifecycle.isPlay = false;
    lifecycle.resolveBackDecision();
    const firstDelay = lifecycle.delayMs;

    lifecycle.resolveBackDecision();
    const secondDelay = lifecycle.delayMs;

    expect(firstDelay).assertEqual(secondDelay);
  });

  it('should_handle_signal_flapping_consistently', 0, () => {
    lifecycle.isPlay = true;
    lifecycle.resolveBackDecision();
    expect(lifecycle.lastBackDecision).assertEqual('cecMenuBack');

    lifecycle.isPlay = false;
    lifecycle.resolveBackDecision();
    expect(lifecycle.lastBackDecision).assertEqual('routerBackDelayed');

    lifecycle.isPlay = true;
    lifecycle.resolveBackDecision();
    expect(lifecycle.lastBackDecision).assertEqual('cecMenuBack');
  });
});

describe('HdmiPage_BackStrategy_pending_router_back_handling', () => {
  let lifecycle: HdmiBackStrategyLifecycle;

  beforeEach(() => {
    mockDisplaySettingOn();
    lifecycle = new HdmiBackStrategyLifecycle();
  });

  afterEach(() => {
    mockDisplaySettingOff();
  });

  it('should_set_pending_router_back_when_back_pressed_in_search', 0, () => {
    lifecycle.isPlay = false;
    lifecycle.executeOnBackPress();
    expect(lifecycle.pendingRouterBack).assertEqual(true);
  });

  it('should_clear_pending_router_back_after_timeout', 0, () => {
    lifecycle.isPlay = false;
    lifecycle.executeOnBackPress();
    expect(lifecycle.pendingRouterBack).assertEqual(true);

    lifecycle.simulateRouterBackTimeout();
    expect(lifecycle.pendingRouterBack).assertEqual(false);
  });

  it('should_not_set_pending_router_back_when_playing', 0, () => {
    lifecycle.isPlay = true;
    lifecycle.executeOnBackPress();
    expect(lifecycle.pendingRouterBack).assertEqual(false);
  });

  it('should_cancel_pending_router_back_on_intervening_action', 0, () => {
    lifecycle.isPlay = false;
    lifecycle.executeOnBackPress();
    expect(lifecycle.pendingRouterBack).assertEqual(true);

    lifecycle.cancelPendingRouterBack();
    expect(lifecycle.pendingRouterBack).assertEqual(false);
  });
});

describe('HdmiPage_BackStrategy_back_decision_consistency', () => {
  let lifecycle: HdmiBackStrategyLifecycle;

  beforeEach(() => {
    mockDisplaySettingOn();
    lifecycle = new HdmiBackStrategyLifecycle();
  });

  afterEach(() => {
    mockDisplaySettingOff();
  });

  it('should_have_deterministic_back_decision_for_playback', 0, () => {
    lifecycle.isPlay = true;
    lifecycle.resolveBackDecision();
    const decision1 = lifecycle.lastBackDecision;

    lifecycle.reset();
    lifecycle.isPlay = true;
    lifecycle.resolveBackDecision();
    const decision2 = lifecycle.lastBackDecision;

    expect(decision1).assertEqual(decision2);
  });

  it('should_have_deterministic_back_decision_for_search', 0, () => {
    lifecycle.isPlay = false;
    lifecycle.resolveBackDecision();
    const decision1 = lifecycle.lastBackDecision;

    lifecycle.reset();
    lifecycle.isPlay = false;
    lifecycle.resolveBackDecision();
    const decision2 = lifecycle.lastBackDecision;

    expect(decision1).assertEqual(decision2);
  });

  it('should_have_mutually_exclusive_back_decisions', 0, () => {
    lifecycle.isPlay = true;
    lifecycle.resolveBackDecision();
    const playbackDecision = lifecycle.lastBackDecision;

    lifecycle.reset();
    lifecycle.isPlay = false;
    lifecycle.resolveBackDecision();
    const searchDecision = lifecycle.lastBackDecision;

    expect(((playbackDecision) === (searchDecision))).assertFalse();
    expect(playbackDecision === 'cecMenuBack' || playbackDecision === 'routerBackDelayed').assertEqual(true);
    expect(searchDecision === 'cecMenuBack' || searchDecision === 'routerBackDelayed').assertEqual(true);
  });

  it('should_never_return_cec_command_during_search', 0, () => {
    lifecycle.isPlay = false;
    for (let i = 0; i < 10; i++) {
      lifecycle.resolveBackDecision();
      expect(lifecycle.cecCommandSent).assertEqual(CEC_COMMAND_INVALID);
    }
  });

  it('should_never_return_router_back_during_playback', 0, () => {
    lifecycle.isPlay = true;
    for (let i = 0; i < 10; i++) {
      lifecycle.resolveBackDecision();
      expect(lifecycle.lastBackDecision).assertEqual('cecMenuBack');
    }
  });
});

describe('HdmiPage_BackStrategy_boundary_conditions', () => {
  let lifecycle: HdmiBackStrategyLifecycle;

  beforeEach(() => {
    mockDisplaySettingOn();
    lifecycle = new HdmiBackStrategyLifecycle();
  });

  afterEach(() => {
    mockDisplaySettingOff();
  });

  it('should_handle_exact_300ms_delay_boundary', 0, () => {
    lifecycle.isPlay = false;
    lifecycle.resolveBackDecision();
    expect(lifecycle.delayMs).assertEqual(300);
  });

  it('should_handle_zero_signal_availability_transition', 0, () => {
    lifecycle.isPlay = false;
    lifecycle.resolveBackDecision();
    const noSignalCec = lifecycle.cecCommandSent;

    lifecycle.isPlay = true;
    lifecycle.resolveBackDecision();
    const signalCec = lifecycle.cecCommandSent;

    expect(((noSignalCec) === (signalCec))).assertFalse();
  });

  it('should_handle_max_back_press_count', 0, () => {
    lifecycle.isPlay = true;
    for (let i = 0; i < 100; i++) {
      lifecycle.executeOnBackPress();
    }
    expect(lifecycle.backPressCount).assertEqual(100);
    expect(lifecycle.cecCommandSent).assertEqual(CEC_MENU_BACK_COMMAND);
  });

  it('should_maintain_state_consistency_after_many_transitions', 0, () => {
    for (let i = 0; i < 50; i++) {
      lifecycle.isPlay = !lifecycle.isPlay;
      lifecycle.resolveBackDecision();
    }
    expect(lifecycle.backActionInvoked).assertEqual(true);
  });
});

describe('HdmiPage_BackStrategy_back_press_isolation', () => {
  let lifecycle1: HdmiBackStrategyLifecycle;
  let lifecycle2: HdmiBackStrategyLifecycle;

  beforeEach(() => {
    mockDisplaySettingOn();
    lifecycle1 = new HdmiBackStrategyLifecycle(true);
    lifecycle2 = new HdmiBackStrategyLifecycle(false);
  });

  afterEach(() => {
    mockDisplaySettingOff();
  });

  it('should_isolate_playback_back_state_between_instances', 0, () => {
    lifecycle1.executeOnBackPress();
    lifecycle2.executeOnBackPress();

    expect(lifecycle1.lastBackDecision).assertEqual('cecMenuBack');
    expect(lifecycle2.lastBackDecision).assertEqual('routerBackDelayed');
  });

  it('should_isolate_back_press_counts_between_instances', 0, () => {
    lifecycle1.executeOnBackPress();
    lifecycle1.executeOnBackPress();
    lifecycle2.executeOnBackPress();

    expect(lifecycle1.backPressCount).assertEqual(2);
    expect(lifecycle2.backPressCount).assertEqual(1);
  });

  it('should_isolate_pending_state_between_instances', 0, () => {
    lifecycle1.executeOnBackPress();
    lifecycle2.executeOnBackPress();

    expect(lifecycle1.pendingRouterBack).assertEqual(false);
    expect(lifecycle2.pendingRouterBack).assertEqual(true);
  });
});

export default function HdmiPage_BackStrategy_test_DefaultExportBridge(): void {
}
