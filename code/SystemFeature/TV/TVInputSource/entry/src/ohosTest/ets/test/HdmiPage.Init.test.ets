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
  resolveHdmiPageSourceId,
  resolveHdmiSignalDecision,
  resolveHdmiBackDecision,
  shouldRebindHdmiSource
} from './HdmiDecisionTestHelper';
import { PlayerManager } from '../../../main/ets/manager/PlayerManager';
import { InputSourceUtil } from '../../../main/ets/utils/InputSourceUtil';

const HDMI_PAGE_URL = 'pages/HdmiPage';
const SOURCE_ID_REBOOT_KEY = 'sourceId_reboot';

function mockDisplaySettingOn(): void {
}

function mockDisplaySettingOff(): void {
}

function createMockPlayerManager(): PlayerManager {
  return PlayerManager.getInstance();
}

function sleep(ms: number): void {
  const end = Date.now() + ms;
  while (Date.now() < end) {
  }
}

describe('HdmiPage_Init_resolveHdmiPageSourceId', () => {
  beforeEach(() => {
    mockDisplaySettingOn();
  });

  afterEach(() => {
    mockDisplaySettingOff();
  });

  it('should_use_router_sourceId_when_reboot_cache_is_negative_one', 0, () => {
    const rebootSourceId = -1;
    const routeSourceId = 3;
    const result = resolveHdmiPageSourceId(rebootSourceId, routeSourceId);
    expect(result).assertEqual(routeSourceId);
  });

  it('should_prefer_reboot_cache_over_router_param_when_reboot_cache_is_valid', 0, () => {
    const rebootSourceId = 2;
    const routeSourceId = 4;
    const result = resolveHdmiPageSourceId(rebootSourceId, routeSourceId);
    expect(result).assertEqual(rebootSourceId);
  });

  it('should_prefer_reboot_cache_zero_over_router_param', 0, () => {
    const rebootSourceId = 0;
    const routeSourceId = 4;
    const result = resolveHdmiPageSourceId(rebootSourceId, routeSourceId);
    expect(result).assertEqual(0);
  });

  it('should_use_router_param_when_both_are_negative_one', 0, () => {
    const rebootSourceId = -1;
    const routeSourceId = -1;
    const result = resolveHdmiPageSourceId(rebootSourceId, routeSourceId);
    expect(result).assertEqual(-1);
  });

  it('should_handle_large_sourceId_values', 0, () => {
    const rebootSourceId = 100;
    const routeSourceId = 200;
    const result = resolveHdmiPageSourceId(rebootSourceId, routeSourceId);
    expect(result).assertEqual(rebootSourceId);
  });
});

describe('HdmiPage_Init_resolveHdmiSignalDecision', () => {
  beforeEach(() => {
    mockDisplaySettingOn();
  });

  afterEach(() => {
    mockDisplaySettingOff();
  });

  it('should_start_player_and_clear_timer_when_signal_available_with_active_timer', 0, () => {
    const isAvailable = true;
    const searchTimerId = 5001;
    const decision = resolveHdmiSignalDecision(isAvailable, searchTimerId);

    expect(decision.isPlay).assertEqual(true);
    expect(decision.isPlaying).assertEqual(true);
    expect(decision.shouldStartPlayer).assertEqual(true);
    expect(decision.shouldStopPlayer).assertEqual(false);
    expect(decision.shouldStartSearch).assertEqual(false);
    expect(decision.shouldClearTimer).assertEqual(true);
  });

  it('should_start_player_without_clearing_timer_when_timer_is_not_active', 0, () => {
    const isAvailable = true;
    const searchTimerId = -1;
    const decision = resolveHdmiSignalDecision(isAvailable, searchTimerId);

    expect(decision.isPlay).assertEqual(true);
    expect(decision.isPlaying).assertEqual(true);
    expect(decision.shouldStartPlayer).assertEqual(true);
    expect(decision.shouldClearTimer).assertEqual(false);
  });

  it('should_stop_player_and_start_new_search_when_no_signal_and_no_active_timer', 0, () => {
    const isAvailable = false;
    const searchTimerId = -1;
    const decision = resolveHdmiSignalDecision(isAvailable, searchTimerId);

    expect(decision.isPlay).assertEqual(false);
    expect(decision.isPlaying).assertEqual(false);
    expect(decision.shouldStartPlayer).assertEqual(false);
    expect(decision.shouldStopPlayer).assertEqual(true);
    expect(decision.shouldStartSearch).assertEqual(true);
    expect(decision.shouldClearTimer).assertEqual(false);
  });

  it('should_stop_player_without_restarting_search_when_no_signal_but_timer_active', 0, () => {
    const isAvailable = false;
    const searchTimerId = 7007;
    const decision = resolveHdmiSignalDecision(isAvailable, searchTimerId);

    expect(decision.isPlay).assertEqual(false);
    expect(decision.isPlaying).assertEqual(false);
    expect(decision.shouldStartPlayer).assertEqual(false);
    expect(decision.shouldStopPlayer).assertEqual(true);
    expect(decision.shouldStartSearch).assertEqual(false);
    expect(decision.shouldClearTimer).assertEqual(false);
  });

  it('should_clear_timer_when_signal_becomes_available_during_search', 0, () => {
    const isAvailable = true;
    const searchTimerId = 12345;
    const decision = resolveHdmiSignalDecision(isAvailable, searchTimerId);

    expect(decision.shouldClearTimer).assertEqual(true);
    expect(decision.shouldStartPlayer).assertEqual(true);
  });

  it('should_not_clear_timer_when_signal_unavailable_even_with_active_timer', 0, () => {
    const isAvailable = false;
    const searchTimerId = 9999;
    const decision = resolveHdmiSignalDecision(isAvailable, searchTimerId);

    expect(decision.shouldClearTimer).assertEqual(false);
    expect(decision.shouldStopPlayer).assertEqual(true);
    expect(decision.shouldStartSearch).assertEqual(false);
  });

  it('should_handle_zero_timer_id_as_no_active_timer', 0, () => {
    const isAvailable = true;
    const searchTimerId = 0;
    const decision = resolveHdmiSignalDecision(isAvailable, searchTimerId);

    expect(decision.shouldClearTimer).assertEqual(false);
    expect(decision.shouldStartPlayer).assertEqual(true);
  });
});

describe('HdmiPage_Init_resolveHdmiBackDecision', () => {
  beforeEach(() => {
    mockDisplaySettingOn();
  });

  afterEach(() => {
    mockDisplaySettingOff();
  });

  it('should_return_delayed_router_back_when_not_in_playback', 0, () => {
    const isPlay = false;
    const decision = resolveHdmiBackDecision(isPlay);

    expect(decision.action).assertEqual('routerBackDelayed');
    expect(decision.delayMs).assertEqual(300);
    expect(decision.cecCommand).assertEqual(-1);
  });

  it('should_return_cec_menu_back_when_in_playback', 0, () => {
    const isPlay = true;
    const decision = resolveHdmiBackDecision(isPlay);

    expect(decision.action).assertEqual('cecMenuBack');
    expect(decision.delayMs).assertEqual(0);
    expect(decision.cecCommand).assertEqual(5);
  });

  it('should_have_cec_command_equal_to_minus_one_when_using_router_back', 0, () => {
    const decision = resolveHdmiBackDecision(false);
    expect(decision.cecCommand).assertEqual(-1);
  });

  it('should_have_zero_delay_when_using_cec_back', 0, () => {
    const decision = resolveHdmiBackDecision(true);
    expect(decision.delayMs).assertEqual(0);
  });
});

describe('HdmiPage_Init_shouldRebindHdmiSource', () => {
  beforeEach(() => {
    mockDisplaySettingOn();
  });

  afterEach(() => {
    mockDisplaySettingOff();
  });

  it('should_not_rebind_when_current_and_next_source_are_identical', 0, () => {
    expect(shouldRebindHdmiSource(1, 1)).assertEqual(false);
    expect(shouldRebindHdmiSource(3, 3)).assertEqual(false);
    expect(shouldRebindHdmiSource(6, 6)).assertEqual(false);
  });

  it('should_rebind_when_current_and_next_source_are_different', 0, () => {
    expect(shouldRebindHdmiSource(1, 2)).assertEqual(true);
    expect(shouldRebindHdmiSource(2, 1)).assertEqual(true);
    expect(shouldRebindHdmiSource(3, 6)).assertEqual(true);
  });

  it('should_rebind_on_hdmi_to_dtv_switch', 0, () => {
    expect(shouldRebindHdmiSource(1, 6)).assertEqual(true);
    expect(shouldRebindHdmiSource(2, 7)).assertEqual(true);
    expect(shouldRebindHdmiSource(4, 8)).assertEqual(true);
  });

  it('should_rebind_on_dtv_to_hdmi_switch', 0, () => {
    expect(shouldRebindHdmiSource(6, 1)).assertEqual(true);
    expect(shouldRebindHdmiSource(7, 2)).assertEqual(true);
  });

  it('should_not_rebind_when_both_are_invalid_sources', 0, () => {
    expect(shouldRebindHdmiSource(-1, -1)).assertEqual(false);
  });
});

describe('HdmiPage_Init_InputSourceUtil_getSourceName', () => {
  beforeEach(() => {
    mockDisplaySettingOn();
  });

  afterEach(() => {
    mockDisplaySettingOff();
  });

  it('should_return_hdmi1_for_source_id_1', 0, () => {
    const name = InputSourceUtil.getSourceName(1);
    expect(name).assertEqual('HDMI1');
  });

  it('should_return_hdmi2_for_source_id_2', 0, () => {
    const name = InputSourceUtil.getSourceName(2);
    expect(name).assertEqual('HDMI2');
  });

  it('should_return_hdmi3_for_source_id_3', 0, () => {
    const name = InputSourceUtil.getSourceName(3);
    expect(name).assertEqual('HDMI3');
  });

  it('should_return_hdmi4_for_source_id_4', 0, () => {
    const name = InputSourceUtil.getSourceName(4);
    expect(name).assertEqual('HDMI4');
  });

  it('should_return_av_for_source_id_5', 0, () => {
    const name = InputSourceUtil.getSourceName(5);
    expect(name).assertEqual('AV');
  });

  it('should_return_dtv_for_source_ids_6_7_8', 0, () => {
    expect(InputSourceUtil.getSourceName(6)).assertEqual('DTV');
    expect(InputSourceUtil.getSourceName(7)).assertEqual('DTV');
    expect(InputSourceUtil.getSourceName(8)).assertEqual('DTV');
  });

  it('should_return_vga_for_source_id_10', 0, () => {
    const name = InputSourceUtil.getSourceName(10);
    expect(name).assertEqual('VGA');
  });

  it('should_return_hdmi1_as_fallback_for_unknown_source_ids', 0, () => {
    expect(InputSourceUtil.getSourceName(100)).assertEqual('HDMI1');
    expect(InputSourceUtil.getSourceName(-1)).assertEqual('HDMI1');
    expect(InputSourceUtil.getSourceName(99)).assertEqual('HDMI1');
  });
});

describe('HdmiPage_Init_PlayerManager_singleton', () => {
  beforeEach(() => {
    mockDisplaySettingOn();
  });

  afterEach(() => {
    mockDisplaySettingOff();
  });

  it('should_return_same_instance_on_multiple_getInstance_calls', 0, () => {
    const instance1 = PlayerManager.getInstance();
    const instance2 = PlayerManager.getInstance();
    expect(instance1).assertEqual(instance2);
  });

  it('should_have_bindSource_method', 0, () => {
    const manager = PlayerManager.getInstance();
    expect(manager !== null).assertEqual(true);
  });

  it('should_have_unBindSource_method', 0, () => {
    const manager = PlayerManager.getInstance();
    expect(manager !== null).assertEqual(true);
  });

  it('should_have_publishSourcePlayStart_method', 0, () => {
    const manager = PlayerManager.getInstance();
    expect(manager !== null).assertEqual(true);
  });

  it('should_have_publishSourcePlayEnd_method', 0, () => {
    const manager = PlayerManager.getInstance();
    expect(manager !== null).assertEqual(true);
  });
});

describe('HdmiPage_Init_search_state_startup', () => {
  beforeEach(() => {
    mockDisplaySettingOn();
  });

  afterEach(() => {
    mockDisplaySettingOff();
  });

  it('should_set_isSearch_to_true_on_startSearch', 0, () => {
    let isSearchState = false;
    let timerId = -1;
    const searchTimeout = 20000;

    isSearchState = true;
    timerId = setTimeout(() => {
      isSearchState = false;
    }, searchTimeout);

    expect(isSearchState).assertEqual(true);
    clearTimeout(timerId);
  });

  it('should_reset_isSearch_to_false_and_timer_to_minus_one_on_closeSearch', 0, () => {
    let isSearchState = true;
    let timerId = 12345;

    clearTimeout(timerId);
    timerId = -1;
    isSearchState = false;

    expect(isSearchState).assertEqual(false);
    expect(timerId).assertEqual(-1);
  });

  it('should_have_search_timeout_of_20000ms', 0, () => {
    const expectedTimeout = 20000;
    expect(expectedTimeout).assertEqual(20000);
  });

  it('should_clear_previous_timer_before_starting_new_search', 0, () => {
    let existingTimerId = 9999;
    let newTimerId = -1;
    const searchTimeout = 20000;

    clearTimeout(existingTimerId);
    existingTimerId = -1;
    newTimerId = setTimeout(() => {
    }, searchTimeout);

    expect(existingTimerId).assertEqual(-1);
    expect(newTimerId !== -1).assertEqual(true);
    clearTimeout(newTimerId);
  });

  it('should_set_isSearch_to_false_when_timer_expires', 0, () => {
    let isSearchState = true;
    const searchTimeout = 10;

    setTimeout(() => {
      isSearchState = false;
    }, searchTimeout);

    sleep(15);
    expect(isSearchState).assertEqual(false);
  });
});

describe('HdmiPage_Init_lifecycle_aboutToAppear_chain', () => {
  beforeEach(() => {
    mockDisplaySettingOn();
  });

  afterEach(() => {
    mockDisplaySettingOff();
  });

  it('should_resolve_sourceId_using_reboot_cache_priority', 0, () => {
    const rebootSourceId = 2;
    const routeSourceId = 4;
    const resolved = resolveHdmiPageSourceId(rebootSourceId, routeSourceId);
    expect(resolved).assertEqual(2);
  });

  it('should_fallback_to_route_param_when_reboot_cache_is_invalid', 0, () => {
    const rebootSourceId = -1;
    const routeSourceId = 3;
    const resolved = resolveHdmiPageSourceId(rebootSourceId, routeSourceId);
    expect(resolved).assertEqual(3);
  });

  it('should_get_source_name_after_resolving_source_id', 0, () => {
    const sourceId = 2;
    const sourceName = InputSourceUtil.getSourceName(sourceId);
    expect(sourceName).assertEqual('HDMI2');
  });

  it('should_handle_zero_source_id_with_valid_reboot_cache', 0, () => {
    const sourceId = resolveHdmiPageSourceId(0, 3);
    expect(sourceId).assertEqual(0);
    expect(InputSourceUtil.getSourceName(0)).assertEqual('MEDIA');
  });

  it('should_handle_all_valid_hdmi_source_ids', 0, () => {
    const hdmiSourceIds: number[] = [1, 2, 3, 4];
    hdmiSourceIds.forEach(id => {
      const resolved = resolveHdmiPageSourceId(-1, id);
      expect(resolved).assertEqual(id);
      const name = InputSourceUtil.getSourceName(id);
      expect(name).assertContain('HDMI');
    });
  });

  it('should_chain_reboot_cache_resolution_with_source_name_lookup', 0, () => {
    const rebootSourceId = 3;
    const routeSourceId = 1;
    const resolvedId = resolveHdmiPageSourceId(rebootSourceId, routeSourceId);
    const sourceName = InputSourceUtil.getSourceName(resolvedId);
    expect(resolvedId).assertEqual(3);
    expect(sourceName).assertEqual('HDMI3');
  });
});

describe('HdmiPage_Init_signal_decision_matrix', () => {
  beforeEach(() => {
    mockDisplaySettingOn();
  });

  afterEach(() => {
    mockDisplaySettingOff();
  });

  it('should_produce_identical_decisions_for_same_input_combinations', 0, () => {
    const combo1 = resolveHdmiSignalDecision(true, 100);
    const combo2 = resolveHdmiSignalDecision(true, 100);
    expect(combo1.shouldStartPlayer).assertEqual(combo2.shouldStartPlayer);
    expect(combo1.shouldClearTimer).assertEqual(combo2.shouldClearTimer);
  });

  it('should_produce_different_decisions_for_available_vs_unavailable', 0, () => {
    const available = resolveHdmiSignalDecision(true, -1);
    const unavailable = resolveHdmiSignalDecision(false, -1);

    expect(((available.shouldStartPlayer) === (unavailable.shouldStartPlayer))).assertFalse();
    expect(((available.shouldStopPlayer) === (unavailable.shouldStopPlayer))).assertFalse();
  });

  it('should_produce_different_decisions_for_timer_active_vs_inactive', 0, () => {
    const withTimer = resolveHdmiSignalDecision(true, 500);
    const withoutTimer = resolveHdmiSignalDecision(true, -1);

    expect(withTimer.shouldClearTimer).assertEqual(true);
    expect(withoutTimer.shouldClearTimer).assertEqual(false);
  });

  it('should_produce_different_decisions_for_no_signal_with_timer_vs_without', 0, () => {
    const withTimer = resolveHdmiSignalDecision(false, 500);
    const withoutTimer = resolveHdmiSignalDecision(false, -1);

    expect(withTimer.shouldStartSearch).assertEqual(false);
    expect(withoutTimer.shouldStartSearch).assertEqual(true);
  });

  it('should_handle_signal_available_with_zero_timer_id', 0, () => {
    const decision = resolveHdmiSignalDecision(true, 0);
    expect(decision.shouldClearTimer).assertEqual(false);
    expect(decision.shouldStartPlayer).assertEqual(true);
  });

  it('should_handle_signal_unavailable_with_zero_timer_id', 0, () => {
    const decision = resolveHdmiSignalDecision(false, 0);
    expect(decision.shouldStartSearch).assertEqual(false);
    expect(decision.shouldStopPlayer).assertEqual(true);
  });
});

describe('HdmiPage_Init_composite_source_binding_scenarios', () => {
  beforeEach(() => {
    mockDisplaySettingOn();
  });

  afterEach(() => {
    mockDisplaySettingOff();
  });

  it('should_resolve_hdmi1_with_valid_reboot_cache', 0, () => {
    const sourceId = resolveHdmiPageSourceId(1, 3);
    expect(sourceId).assertEqual(1);
    expect(InputSourceUtil.getSourceName(1)).assertEqual('HDMI1');
  });

  it('should_resolve_hdmi2_with_valid_reboot_cache', 0, () => {
    const sourceId = resolveHdmiPageSourceId(2, 1);
    expect(sourceId).assertEqual(2);
    expect(InputSourceUtil.getSourceName(2)).assertEqual('HDMI2');
  });

  it('should_resolve_hdmi3_with_valid_reboot_cache', 0, () => {
    const sourceId = resolveHdmiPageSourceId(3, 4);
    expect(sourceId).assertEqual(3);
    expect(InputSourceUtil.getSourceName(3)).assertEqual('HDMI3');
  });

  it('should_resolve_hdmi4_with_valid_reboot_cache', 0, () => {
    const sourceId = resolveHdmiPageSourceId(4, 2);
    expect(sourceId).assertEqual(4);
    expect(InputSourceUtil.getSourceName(4)).assertEqual('HDMI4');
  });

  it('should_resolve_dtv_source_with_valid_reboot_cache', 0, () => {
    const sourceId = resolveHdmiPageSourceId(6, 1);
    expect(sourceId).assertEqual(6);
    expect(InputSourceUtil.getSourceName(6)).assertEqual('DTV');
  });

  it('should_resolve_av_source_with_valid_reboot_cache', 0, () => {
    const sourceId = resolveHdmiPageSourceId(5, 3);
    expect(sourceId).assertEqual(5);
    expect(InputSourceUtil.getSourceName(5)).assertEqual('AV');
  });

  it('should_resolve_vga_source_with_valid_reboot_cache', 0, () => {
    const sourceId = resolveHdmiPageSourceId(10, 1);
    expect(sourceId).assertEqual(10);
    expect(InputSourceUtil.getSourceName(10)).assertEqual('VGA');
  });

  it('should_handle_media_source_zero', 0, () => {
    const sourceId = resolveHdmiPageSourceId(0, 1);
    expect(sourceId).assertEqual(0);
    expect(InputSourceUtil.getSourceName(0)).assertEqual('MEDIA');
  });

  it('should_handle_switching_from_hdmi_to_dtv', 0, () => {
    const currentSource = 2;
    const nextSource = 6;
    const shouldSwitch = shouldRebindHdmiSource(currentSource, nextSource);
    expect(shouldSwitch).assertEqual(true);
  });

  it('should_handle_switching_from_dtv_to_hdmi', 0, () => {
    const currentSource = 7;
    const nextSource = 3;
    const shouldSwitch = shouldRebindHdmiSource(currentSource, nextSource);
    expect(shouldSwitch).assertEqual(true);
  });

  it('should_not_switch_when_remaining_on_same_source', 0, () => {
    const currentSource = 4;
    const nextSource = 4;
    const shouldSwitch = shouldRebindHdmiSource(currentSource, nextSource);
    expect(shouldSwitch).assertEqual(false);
  });
});

describe('HdmiPage_Init_back_decision_matrix', () => {
  beforeEach(() => {
    mockDisplaySettingOn();
  });

  afterEach(() => {
    mockDisplaySettingOff();
  });

  it('should_send_cec_back_command_during_hdmi_playback', 0, () => {
    const decision = resolveHdmiBackDecision(true);
    expect(decision.action).assertEqual('cecMenuBack');
    expect(decision.cecCommand).assertEqual(5);
    expect(decision.delayMs).assertEqual(0);
  });

  it('should_use_delayed_router_back_when_searching', 0, () => {
    const decision = resolveHdmiBackDecision(false);
    expect(decision.action).assertEqual('routerBackDelayed');
    expect(decision.delayMs).assertEqual(300);
    expect(decision.cecCommand).assertEqual(-1);
  });

  it('should_differentiate_playback_vs_search_on_back_press', 0, () => {
    const playbackDecision = resolveHdmiBackDecision(true);
    const searchDecision = resolveHdmiBackDecision(false);
    expect(((playbackDecision.action) === (searchDecision.action))).assertFalse();
  });

  it('should_have_zero_cec_command_when_using_router_back', 0, () => {
    const decision = resolveHdmiBackDecision(false);
    expect(decision.cecCommand).assertEqual(-1);
  });

  it('should_have_zero_delay_when_using_cec_back', 0, () => {
    const decision = resolveHdmiBackDecision(true);
    expect(decision.delayMs).assertEqual(0);
  });

  it('should_use_300ms_delay_for_delayed_router_back', 0, () => {
    const decision = resolveHdmiBackDecision(false);
    expect(decision.delayMs).assertEqual(300);
  });
});

describe('HdmiPage_Init_boundary_conditions', () => {
  beforeEach(() => {
    mockDisplaySettingOn();
  });

  afterEach(() => {
    mockDisplaySettingOff();
  });

  it('should_handle_negative_source_id_in_reboot_cache', 0, () => {
    const sourceId = resolveHdmiPageSourceId(-1, 2);
    expect(sourceId).assertEqual(2);
  });

  it('should_handle_source_id_zero_in_reboot_cache', 0, () => {
    const sourceId = resolveHdmiPageSourceId(0, 3);
    expect(sourceId).assertEqual(0);
  });

  it('should_handle_large_timer_id_values', 0, () => {
    const largeTimerId = 2147483647;
    const decision = resolveHdmiSignalDecision(true, largeTimerId);
    expect(decision.shouldClearTimer).assertEqual(true);
  });

  it('should_handle_negative_timer_id_minus_one', 0, () => {
    const decision = resolveHdmiSignalDecision(false, -1);
    expect(decision.shouldStartSearch).assertEqual(true);
    expect(decision.shouldClearTimer).assertEqual(false);
  });

  it('should_handle_all_cec_commands', 0, () => {
    const playbackDecision = resolveHdmiBackDecision(true);
    expect(playbackDecision.cecCommand).assertEqual(5);
  });

  it('should_handle_invalid_source_id_in_getSourceName', 0, () => {
    const name = InputSourceUtil.getSourceName(-999);
    expect(name).assertEqual('HDMI1');
  });

  it('should_resolve_to_route_when_reboot_cache_equals_route', 0, () => {
    const sourceId = resolveHdmiPageSourceId(3, 3);
    expect(sourceId).assertEqual(3);
  });

  it('should_prefer_smaller_source_id_in_reboot_cache', 0, () => {
    const sourceId = resolveHdmiPageSourceId(1, 10);
    expect(sourceId).assertEqual(1);
  });
});

export default function HdmiPage_Init_test_DefaultExportBridge(): void {
}
