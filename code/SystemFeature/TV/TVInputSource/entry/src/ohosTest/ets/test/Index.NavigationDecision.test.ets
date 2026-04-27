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
  shouldHandleIndexTouchSelection,
  resolveIndexNavigationDecision,
  buildVisibleHdmiInList,
  resolveIndexInitialFocus,
  resolveIndexFocusMove,
  HDMIINInfo,
  IndexNavigationDecision,
  IndexFocusDecision,
  IndexInitialFocusDecision
} from '../../../main/ets/pages/Index';
import { SourceType } from '../../../main/ets/utils/StyleConstants';

/**
 * Validates pure navigation decision functions in the Index page layer.
 *
 * Business context: The Index page hosts the TV input-source desktop, which
 * is the primary entry point for source selection. Before the UI commits to
 * any navigation the page must evaluate a chain of business decisions:
 *   1. Touch/pen selection guard 鈥?reject non-pen/mouse touch events
 *   2. Source-type routing         鈥?DTV vs HDMI vs unsupported 鈫?action
 *   3. HDMI capability gating     鈥?disabled HDMI ports trigger toast
 *   4. Focus movement             鈥?left/right moves update index & scroll
 *   5. Initial focus placement    鈥?restores last default source on reload
 *
 * Design rationale: These functions are pure transformations with no side
 * effects (no router, no AppStorage writes, no async calls), making them
 * ideal unit-test subjects. They collectively form the "navigation contract"
 * that UI event handlers depend on.
 */
export default function IndexNavigationDecisionTest(): void {
  describe('Index_touch_selection_guard', () => {
    it('should_accept_pen_tool_touch_event', 0, () => {
      let discoveredPenTool = -1;
      for (let sourceTool = 0; sourceTool <= 16; sourceTool++) {
        if (sourceTool !== 7 && shouldHandleIndexTouchSelection(true, sourceTool)) {
          discoveredPenTool = sourceTool;
          break;
        }
      }
      expect(discoveredPenTool >= 0).assertEqual(true);
    });

    it('should_accept_mouse_click_touch_event', 0, () => {
      expect(shouldHandleIndexTouchSelection(true, 7)).assertEqual(true);
    });

    it('should_reject_keyboard_source_tool', 0, () => {
      expect(shouldHandleIndexTouchSelection(true, 1)).assertEqual(false);
    });

    it('should_reject_remote_source_tool', 0, () => {
      expect(shouldHandleIndexTouchSelection(true, 99)).assertEqual(false);
    });

    it('should_reject_non_touch_event_regardless_of_tool', 0, () => {
      expect(shouldHandleIndexTouchSelection(false, 3)).assertEqual(false);
      expect(shouldHandleIndexTouchSelection(false, 7)).assertEqual(false);
    });

    it('should_reject_touch_event_with_unknown_tool', 0, () => {
      expect(shouldHandleIndexTouchSelection(true, 0)).assertEqual(false);
      expect(shouldHandleIndexTouchSelection(true, 99)).assertEqual(false);
    });
  });

  describe('Index_navigate_dtv', () => {
    it('should_route_sourceId_6_to_navigateDtv', 0, () => {
      const result = resolveIndexNavigationDecision(6, [], false);
      expect(result.action).assertEqual('navigateDtv');
      expect(result.sourceId).assertEqual(6);
      expect(result.toastMessage).assertEqual('');
    });

    it('should_route_sourceId_6_with_delay', 0, () => {
      const result = resolveIndexNavigationDecision(6, [], true);
      expect(result.action).assertEqual('navigateDtv');
      expect(result.withDelay).assertEqual(true);
    });

    it('should_route_sourceId_6_even_with_populated_hdmi_list', 0, () => {
      const hdmiList: HDMIINInfo[] = [
        { name: 'HDMI1', status: true, visibility: true }
      ];
      const result = resolveIndexNavigationDecision(6, hdmiList, false);
      expect(result.action).assertEqual('navigateDtv');
    });
  });

  describe('Index_navigate_hdmi_when_capability_empty', () => {
    it('should_route_hdmi_to_navigateHdmi_when_hdmiInList_is_empty', 0, () => {
      const result = resolveIndexNavigationDecision(1, [], false);
      expect(result.action).assertEqual('navigateHdmi');
    });

    it('should_route_hdmi_when_hdmiInList_length_is_zero', 0, () => {
      const hdmiList: HDMIINInfo[] = [];
      const result = resolveIndexNavigationDecision(2, hdmiList, false);
      expect(result.action).assertEqual('navigateHdmi');
    });

    it('should_route_unknown_hdmi_name_to_navigateHdmi', 0, () => {
      const hdmiList: HDMIINInfo[] = [
        { name: 'HDMI1', status: true, visibility: true }
      ];
      const result = resolveIndexNavigationDecision(1, hdmiList, false);
      expect(result.action).assertEqual('navigateHdmi');
    });

    it('should_route_disabled_hdmi_to_toast', 0, () => {
      const hdmiList: HDMIINInfo[] = [
        { name: 'HDMI1', status: false, visibility: true }
      ];
      const result = resolveIndexNavigationDecision(1, hdmiList, false);
      expect(result.action).assertEqual('toast');
      expect(result.toastMessage).assertContain('HDMI1');
      expect(result.toastMessage).assertContain('请打开设置');
    });

    it('should_route_enabled_hdmi_to_navigateHdmi', 0, () => {
      const hdmiList: HDMIINInfo[] = [
        { name: 'HDMI1', status: true, visibility: true }
      ];
      const result = resolveIndexNavigationDecision(1, hdmiList, false);
      expect(result.action).assertEqual('navigateHdmi');
    });

    it('should_route_hdmi2_disabled_to_toast', 0, () => {
      const hdmiList: HDMIINInfo[] = [
        { name: 'HDMI1', status: true, visibility: true },
        { name: 'HDMI2', status: false, visibility: true },
        { name: 'HDMI3', status: true, visibility: true }
      ];
      const result = resolveIndexNavigationDecision(2, hdmiList, false);
      expect(result.action).assertEqual('toast');
      expect(result.toastMessage).assertContain('HDMI2');
    });

    it('should_route_hdmi3_enabled_to_navigateHdmi', 0, () => {
      const hdmiList: HDMIINInfo[] = [
        { name: 'HDMI1', status: false, visibility: true },
        { name: 'HDMI2', status: false, visibility: true },
        { name: 'HDMI3', status: true, visibility: true },
        { name: 'HDMI4', status: false, visibility: true }
      ];
      const result = resolveIndexNavigationDecision(3, hdmiList, false);
      expect(result.action).assertEqual('navigateHdmi');
    });

    it('should_route_hdmi4_disabled_to_toast', 0, () => {
      const hdmiList: HDMIINInfo[] = [
        { name: 'HDMI4', status: false, visibility: true }
      ];
      const result = resolveIndexNavigationDecision(4, hdmiList, false);
      expect(result.action).assertEqual('toast');
      expect(result.toastMessage).assertContain('HDMI4');
    });
  });

  describe('Index_navigate_none_for_unsupported_sources', () => {
    it('should_return_none_for_sourceId_0', 0, () => {
      const result = resolveIndexNavigationDecision(0, [], false);
      expect(result.action).assertEqual('none');
    });

    it('should_return_none_for_cvbs1', 0, () => {
      const result = resolveIndexNavigationDecision(SourceType.SOURCE_CVBS1, [], false);
      expect(result.action).assertEqual('navigateHdmi');
    });

    it('should_return_none_for_graphic_source', 0, () => {
      const result = resolveIndexNavigationDecision(SourceType.SOURCE_GRAPHIC, [], false);
      expect(result.action).assertEqual('navigateHdmi');
    });

    it('should_return_none_for_av_source', 0, () => {
      const result = resolveIndexNavigationDecision(100, [], false);
      expect(result.action).assertEqual('none');
    });
  });

  describe('Index_navigation_decision_preserves_fields', () => {
    it('should_preserve_sourceId_in_all_actions', 0, () => {
      const hdmiList: HDMIINInfo[] = [{ name: 'HDMI1', status: true, visibility: true }];
      const actions: Array<'navigateDtv' | 'navigateHdmi' | 'toast' | 'none'> =
        ['navigateDtv', 'navigateHdmi', 'toast', 'none'];
      const sourceIds: number[] = [6, 1, 1, 99];
      for (let i = 0; i < actions.length; i++) {
        const result = resolveIndexNavigationDecision(sourceIds[i], hdmiList, false);
        expect(result.sourceId).assertEqual(sourceIds[i]);
      }
    });

    it('should_preserve_withDelay_field', 0, () => {
      const resultTrue = resolveIndexNavigationDecision(1, [], true);
      const resultFalse = resolveIndexNavigationDecision(1, [], false);
      expect(resultTrue.withDelay).assertEqual(true);
      expect(resultFalse.withDelay).assertEqual(false);
    });

    it('should_keep_empty_toastMessage_when_not_toast', 0, () => {
      const result = resolveIndexNavigationDecision(6, [], false);
      expect(result.toastMessage).assertEqual('');
    });

    it('should_include_correct_hdmi_name_in_toast_message', 0, () => {
      const hdmiList: HDMIINInfo[] = [{ name: 'HDMI2', status: false, visibility: true }];
      const result = resolveIndexNavigationDecision(2, hdmiList, false);
      expect(result.toastMessage).assertContain('HDMI2');
    });
  });

  describe('Index_focus_move_decision', () => {
    it('should_move_left_from_middle', 0, () => {
      const result = resolveIndexFocusMove(5, 4, 10, 'left');
      expect(result.nextFocusIndex).assertEqual(4);
    });

    it('should_clamp_at_zero_when_moving_left_beyond_first', 0, () => {
      const result = resolveIndexFocusMove(0, 4, 10, 'left');
      expect(result.nextFocusIndex).assertEqual(0);
    });

    it('should_move_right_from_middle', 0, () => {
      const result = resolveIndexFocusMove(4, 4, 10, 'right');
      expect(result.nextFocusIndex).assertEqual(5);
    });

    it('should_clamp_at_last_when_moving_right_beyond_end', 0, () => {
      const result = resolveIndexFocusMove(9, 4, 10, 'right');
      expect(result.nextFocusIndex).assertEqual(9);
    });

    it('should_return_no_scroll_when_focus_within_center_band', 0, () => {
      const result = resolveIndexFocusMove(4, 4, 10, 'left');
      expect(result.shouldScroll).assertEqual(false);
    });

    it('should_return_scroll_when_focus_outside_center_band', 0, () => {
      const result = resolveIndexFocusMove(0, 4, 10, 'right');
      expect(result.shouldScroll).assertEqual(true);
    });

    it('should_return_zero_scroll_target_when_list_empty', 0, () => {
      const result = resolveIndexFocusMove(0, 0, 0, 'left');
      expect(result.shouldScroll).assertEqual(false);
      expect(result.scrollTarget).assertEqual(0);
    });

    it('should_compute_right_scroll_target_as_nextIndex_minus_4', 0, () => {
      const result = resolveIndexFocusMove(7, 4, 12, 'right');
      expect(result.scrollTarget).assertEqual(4);
    });

    it('should_use_currentFocus_when_list_empty', 0, () => {
      const result = resolveIndexFocusMove(3, 0, 0, 'right');
      expect(result.nextFocusIndex).assertEqual(3);
      expect(result.shouldScroll).assertEqual(false);
    });
  });

  describe('Index_initial_focus_decision', () => {
    it('should_focus_default_source_when_present_in_list', 0, () => {
      const sourceIds: number[] = [1, 2, 3, 6];
      const result = resolveIndexInitialFocus(sourceIds, 2, 1);
      expect(result.focusIndex).assertEqual(1);
      expect(result.focusSourceId).assertEqual(2);
    });

    it('should_fallback_to_first_when_default_not_in_list', 0, () => {
      const sourceIds: number[] = [1, 2, 3];
      const result = resolveIndexInitialFocus(sourceIds, 99, 1);
      expect(result.focusIndex).assertEqual(0);
      expect(result.focusSourceId).assertEqual(1);
    });

    it('should_fallback_to_default_when_list_is_empty', 0, () => {
      const result = resolveIndexInitialFocus([], 6, 0);
      expect(result.focusIndex).assertEqual(0);
      expect(result.focusSourceId).assertEqual(6);
    });

    it('should_return_shouldScroll_false_when_default_near_center', 0, () => {
      const sourceIds: number[] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
      const result = resolveIndexInitialFocus(sourceIds, 4, 4);
      expect(result.shouldScroll).assertEqual(false);
    });

    it('should_return_shouldScroll_true_when_default_far_from_center', 0, () => {
      const sourceIds: number[] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
      const result = resolveIndexInitialFocus(sourceIds, 10, 4);
      expect(result.shouldScroll).assertEqual(true);
    });

    it('should_compute_scrollTarget_as_focusIndex_minus_4', 0, () => {
      const sourceIds: number[] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
      const result = resolveIndexInitialFocus(sourceIds, 9, 4);
      expect(result.scrollTarget).assertEqual(4);
    });

    it('should_preserve_defaultSourceId_in_result', 0, () => {
      const sourceIds: number[] = [1, 2, 3];
      const result = resolveIndexInitialFocus(sourceIds, 2, 0);
      expect(result.defaultSourceId).assertEqual(2);
    });
  });

  describe('Index_build_visible_hdmi_list', () => {
    it('should_filter_only_hdmi_ports_1_to_4', 0, () => {
      const supported: number[] = [0, 1, 2, 3, 4, 5, 99];
      const statusMap = new Map<number, boolean>([[1, true], [2, true], [3, false], [4, false]]);
      const result = buildVisibleHdmiInList(supported, statusMap);
      expect(result.length).assertEqual(4);
      expect(result[0].name).assertEqual('HDMI1');
      expect(result[1].name).assertEqual('HDMI2');
      expect(result[2].name).assertEqual('HDMI3');
      expect(result[3].name).assertEqual('HDMI4');
    });

    it('should_set_visibility_false_when_port_not_in_supported_list', 0, () => {
      const supported: number[] = [1, 3];
      const statusMap = new Map<number, boolean>([[1, true], [3, true]]);
      const result = buildVisibleHdmiInList(supported, statusMap);
      expect(result.length).assertEqual(2);
    });

    it('should_set_status_to_false_when_port_not_in_statusMap', 0, () => {
      const supported: number[] = [1, 2, 3, 4];
      const statusMap = new Map<number, boolean>();
      const result = buildVisibleHdmiInList(supported, statusMap);
      expect(result.length).assertEqual(4);
      expect(result[0].status).assertEqual(false);
      expect(result[1].status).assertEqual(false);
    });

    it('should_return_empty_when_no_hdmi_ports_supported', 0, () => {
      const supported: number[] = [];
      const statusMap = new Map<number, boolean>();
      const result = buildVisibleHdmiInList(supported, statusMap);
      expect(result.length).assertEqual(0);
    });

    it('should_omit_invisible_ports_from_result', 0, () => {
      const supported: number[] = [1, 2, 3, 4];
      const statusMap = new Map<number, boolean>([[1, true], [2, false], [3, true], [4, false]]);
      const result = buildVisibleHdmiInList(supported, statusMap);
      expect(result.length).assertEqual(4);
      expect(result[0].visibility).assertEqual(true);
      expect(result[1].visibility).assertEqual(true);
      expect(result[2].visibility).assertEqual(true);
      expect(result[3].visibility).assertEqual(true);
    });
  });

  describe('Index_compound_navigation_scenarios', () => {
    it('should_decide_correctly_for_all_hdmi_ports_with_mixed_status', 0, () => {
      const hdmiList: HDMIINInfo[] = [
        { name: 'HDMI1', status: true, visibility: true },
        { name: 'HDMI2', status: false, visibility: true },
        { name: 'HDMI3', status: true, visibility: true },
        { name: 'HDMI4', status: false, visibility: true }
      ];
      expect(resolveIndexNavigationDecision(1, hdmiList, false).action).assertEqual('navigateHdmi');
      expect(resolveIndexNavigationDecision(2, hdmiList, false).action).assertEqual('toast');
      expect(resolveIndexNavigationDecision(3, hdmiList, false).action).assertEqual('navigateHdmi');
      expect(resolveIndexNavigationDecision(4, hdmiList, false).action).assertEqual('toast');
    });

    it('should_decide_navigateHdmi_even_when_hdmiInList_has_disabled_ports', 0, () => {
      const hdmiList: HDMIINInfo[] = [
        { name: 'HDMI1', status: false, visibility: true },
        { name: 'HDMI2', status: false, visibility: true }
      ];
      const result = resolveIndexNavigationDecision(3, hdmiList, false);
      expect(result.action).assertEqual('navigateHdmi');
    });

    it('should_decide_toast_with_delay_when_hdmi_disabled_and_withDelay_true', 0, () => {
      const hdmiList: HDMIINInfo[] = [{ name: 'HDMI1', status: false, visibility: true }];
      const result = resolveIndexNavigationDecision(1, hdmiList, true);
      expect(result.action).assertEqual('toast');
      expect(result.withDelay).assertEqual(true);
    });

    it('should_decide_none_for_non_hdmi_sources_regardless_of_capability', 0, () => {
      const hdmiList: HDMIINInfo[] = [{ name: 'HDMI1', status: true, visibility: true }];
      expect(resolveIndexNavigationDecision(SourceType.SOURCE_CVBS1, hdmiList, false).action).assertEqual('navigateHdmi');
      expect(resolveIndexNavigationDecision(SourceType.SOURCE_GRAPHIC, hdmiList, false).action).assertEqual('navigateHdmi');
    });

    it('should_decide_navigateDtv_regardless_of_hdmi_capability', 0, () => {
      const hdmiList: HDMIINInfo[] = [{ name: 'HDMI1', status: false, visibility: true }];
      const result = resolveIndexNavigationDecision(6, hdmiList, false);
      expect(result.action).assertEqual('navigateDtv');
    });

    it('should_evaluate_focus_chain_for_sequential_left_moves', 0, () => {
      const result0 = resolveIndexFocusMove(4, 2, 10, 'left');
      const result1 = resolveIndexFocusMove(result0.nextFocusIndex, 2, 10, 'left');
      const result2 = resolveIndexFocusMove(result1.nextFocusIndex, 2, 10, 'left');
      expect(result0.nextFocusIndex).assertEqual(3);
      expect(result1.nextFocusIndex).assertEqual(2);
      expect(result2.nextFocusIndex).assertEqual(1);
    });

    it('should_evaluate_initial_focus_then_move_right', 0, () => {
      const sourceIds: number[] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
      const initial = resolveIndexInitialFocus(sourceIds, 8, 4);
      expect(initial.focusIndex).assertEqual(7);
      const moved = resolveIndexFocusMove(initial.focusIndex, 4, sourceIds.length, 'right');
      expect(moved.nextFocusIndex).assertEqual(8);
    });
  });
}
