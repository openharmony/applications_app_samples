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
  buildVisibleHdmiInList,
  resolveIndexFocusMove,
  resolveIndexInitialFocus,
  resolveIndexNavigationDecision,
  resolveVisibleHdmiInList
} from '../../../main/ets/pages/Index';

/**
 * Registers tests for index page focus movement and route decisions.
 *
 * @returns void.
 */
export default function IndexPageTest(): void {
  describe('IndexPage_real', () => {
    it('should_keep_focus_inside_visible_range_without_scroll_on_left_move', 0, () => {
      const decision = resolveIndexFocusMove(3, 4, 8, 'left');

      // Visible-range movement should only update focus and avoid unnecessary
      // list scrolling so remote navigation feels stable.
      expect(decision.nextFocusIndex).assertEqual(2);
      expect(decision.shouldScroll).assertEqual(false);
      expect(decision.scrollTarget).assertEqual(2);
    });

    it('should_request_scroll_when_right_move_exits_visible_range', 0, () => {
      const decision = resolveIndexFocusMove(6, 2, 10, 'right');

      expect(decision.nextFocusIndex).assertEqual(7);
      expect(decision.shouldScroll).assertEqual(true);
      expect(decision.scrollTarget).assertEqual(3);
    });

    it('should_navigate_to_dtv_for_source_six', 0, () => {
      const decision = resolveIndexNavigationDecision(6, []);

      expect(decision.action).assertEqual('navigateDtv');
      expect(decision.sourceId).assertEqual(6);
    });

    it('should_show_toast_when_hdmi_switch_is_disabled', 0, () => {
      const decision = resolveIndexNavigationDecision(2, [
        { name: 'HDMI2', status: false, visibility: true }
      ]);

      // Disabled HDMI inputs must block navigation and surface a clear settings
      // hint so users know why CEC or click navigation did not continue.
      expect(decision.action).assertEqual('toast');
      expect(decision.toastMessage).assertEqual('请打开设置HDMI2输入开关!');
    });

    it('should_navigate_to_hdmi_when_hdmi_list_is_empty', 0, () => {
      const decision = resolveIndexNavigationDecision(4, [], true);

      expect(decision.action).assertEqual('navigateHdmi');
      expect(decision.withDelay).assertEqual(true);
      expect(decision.sourceId).assertEqual(4);
    });

    it('should_focus_default_source_and_request_scroll_when_it_is_outside_center_range', 0, () => {
      const decision = resolveIndexInitialFocus([1, 2, 3, 4, 6], 6, 0);

      // Initial landing should restore the configured default source even when
      // it sits outside the visible window, and ask the list to scroll to it.
      expect(decision.defaultSourceId).assertEqual(6);
      expect(decision.focusIndex).assertEqual(4);
      expect(decision.focusSourceId).assertEqual(6);
      expect(decision.shouldScroll).assertEqual(true);
      expect(decision.scrollTarget).assertEqual(0);
    });

    it('should_fall_back_to_first_source_when_default_source_is_missing', 0, () => {
      const decision = resolveIndexInitialFocus([1, 2, 3], 6, 1);

      expect(decision.focusIndex).assertEqual(0);
      expect(decision.focusSourceId).assertEqual(1);
      expect(decision.shouldScroll).assertEqual(false);
    });

    it('should_build_visible_hdmi_list_from_supported_ports_and_statuses', 0, () => {
      const decision = buildVisibleHdmiInList([1, 3, 5], new Map<number, boolean>([
        [1, true],
        [3, false]
      ]));

      // Only HDMI1-4 remain visible, and unsupported ports are excluded from
      // AppStorage so later route decisions read a clean capability list.
      expect(decision.length).assertEqual(2);
      expect(decision[0].name).assertEqual('HDMI1');
      expect(decision[0].status).assertEqual(true);
      expect(decision[1].name).assertEqual('HDMI3');
      expect(decision[1].status).assertEqual(false);
    });

    it('should_resolve_visible_hdmi_list_from_async_capability_provider', 0, async () => {
      const decision = await resolveVisibleHdmiInList({
        getSupportSourceList: async (): Promise<number[]> => [1, 2, 6],
        isHdmiRxEnable: async (portId: number): Promise<boolean> => portId === 1
      });

      // The async helper keeps only HDMI1-4 and preserves each queried enable
      // state so later page routing can reuse one normalized capability list.
      expect(decision.length).assertEqual(2);
      expect(decision[0].name).assertEqual('HDMI1');
      expect(decision[0].status).assertEqual(true);
      expect(decision[1].name).assertEqual('HDMI2');
      expect(decision[1].status).assertEqual(false);
    });

    it('should_fall_back_to_disabled_status_when_hdmi_query_fails', 0, async () => {
      const decision = await resolveVisibleHdmiInList({
        getSupportSourceList: async (): Promise<number[]> => [3],
        isHdmiRxEnable: async (_portId: number): Promise<boolean> => {
          throw new Error('query failed');
        }
      });

      expect(decision.length).assertEqual(1);
      expect(decision[0].name).assertEqual('HDMI3');
      expect(decision[0].status).assertEqual(false);
    });

    it('should_return_empty_list_when_supported_source_query_fails', 0, async () => {
      const decision = await resolveVisibleHdmiInList({
        getSupportSourceList: async (): Promise<number[]> => {
          throw new Error('service unavailable');
        },
        isHdmiRxEnable: async (_portId: number): Promise<boolean> => true
      });

      expect(decision.length).assertEqual(0);
    });
  });
}

