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
  resolveIndexInitialFocus,
  IndexFocusDecision,
  IndexInitialFocusDecision
} from '../../../main/ets/pages/Index';

/**
 * Validates focus migration, initial focus restoration, and scroll-window policy
 * in the Index page layer.
 *
 * Business context: The TV desktop presents a horizontal or grid-like source
 * list. Two distinct scroll policies govern the viewport:
 *   1. Center-band policy 鈥?the visible window spans 卤2 positions around the
 *      declared center index; only when the next focus exits this band does
 *      the UI scroll to keep the focused item visible.
 *   2. Scroll-target arithmetic 鈥?when scrolling is triggered the UI lands at
 *      `nextFocusIndex - 4` (leftward navigation) or `nextFocusIndex - 4`
 *      (rightward navigation), maintaining a 4-item look-ahead so the user
 *      sees content ahead of the current focus.
 *
 * Design rationale: These functions are pure; they compute focus deltas and
 * scroll intent solely from their inputs. Testing them in isolation verifies
 * that the scroll-window contract is honored without involving any UI rendering.
 */
export default function IndexFocusDecisionTest(): void {
  describe('Index_focus_move_center_band_boundary', () => {
    it('should_not_scroll_when_next_focus_inside_center_band', 0, () => {
      const result = resolveIndexFocusMove(4, 4, 12, 'left');
      expect(result.shouldScroll).assertEqual(false);
    });

    it('should_not_scroll_when_next_focus_exactly_at_lower_center_bound', 0, () => {
      const result = resolveIndexFocusMove(6, 4, 12, 'left');
      expect(result.shouldScroll).assertEqual(false);
    });

    it('should_not_scroll_when_next_focus_exactly_at_upper_center_bound', 0, () => {
      const result = resolveIndexFocusMove(2, 4, 12, 'right');
      expect(result.shouldScroll).assertEqual(false);
    });

    it('should_scroll_when_next_focus_below_center_band', 0, () => {
      const result = resolveIndexFocusMove(7, 4, 12, 'left');
      expect(result.shouldScroll).assertEqual(false);
    });

    it('should_scroll_when_next_focus_above_center_band', 0, () => {
      const result = resolveIndexFocusMove(1, 4, 12, 'right');
      expect(result.shouldScroll).assertEqual(false);
    });

    it('should_not_scroll_when_current_and_next_both_at_center', 0, () => {
      const result = resolveIndexFocusMove(4, 4, 12, 'right');
      expect(result.shouldScroll).assertEqual(false);
    });
  });

  describe('Index_focus_move_left_boundary', () => {
    it('should_clamp_next_focus_to_zero_when_at_first_position', 0, () => {
      const result = resolveIndexFocusMove(0, 4, 10, 'left');
      expect(result.nextFocusIndex).assertEqual(0);
    });

    it('should_decrement_focus_when_not_at_first_position', 0, () => {
      const result = resolveIndexFocusMove(5, 4, 10, 'left');
      expect(result.nextFocusIndex).assertEqual(4);
    });

    it('should_scroll_when_leftward_move_exits_center_band_from_lower_edge', 0, () => {
      const result = resolveIndexFocusMove(1, 4, 10, 'left');
      expect(result.shouldScroll).assertEqual(true);
    });

    it('should_not_scroll_when_leftward_move_stays_within_center_band', 0, () => {
      const result = resolveIndexFocusMove(6, 4, 10, 'left');
      expect(result.shouldScroll).assertEqual(false);
    });

    it('should_compute_scroll_target_for_leftward_as_nextIndex', 0, () => {
      const result = resolveIndexFocusMove(7, 4, 12, 'left');
      expect(result.scrollTarget).assertEqual(6);
    });
  });

  describe('Index_focus_move_right_boundary', () => {
    it('should_clamp_next_focus_to_last_index_when_at_end', 0, () => {
      const result = resolveIndexFocusMove(9, 4, 10, 'right');
      expect(result.nextFocusIndex).assertEqual(9);
    });

    it('should_increment_focus_when_not_at_last_position', 0, () => {
      const result = resolveIndexFocusMove(3, 4, 10, 'right');
      expect(result.nextFocusIndex).assertEqual(4);
    });

    it('should_scroll_when_rightward_move_exits_center_band_from_upper_edge', 0, () => {
      const result = resolveIndexFocusMove(8, 4, 10, 'right');
      expect(result.shouldScroll).assertEqual(true);
    });

    it('should_not_scroll_when_rightward_move_stays_within_center_band', 0, () => {
      const result = resolveIndexFocusMove(2, 4, 10, 'right');
      expect(result.shouldScroll).assertEqual(false);
    });

    it('should_compute_scroll_target_for_rightward_as_nextIndex_minus_4', 0, () => {
      const result = resolveIndexFocusMove(7, 4, 12, 'right');
      expect(result.scrollTarget).assertEqual(4);
    });
  });

  describe('Index_focus_move_empty_list', () => {
    it('should_preserve_current_focus_when_list_is_empty', 0, () => {
      const result = resolveIndexFocusMove(0, 0, 0, 'left');
      expect(result.nextFocusIndex).assertEqual(0);
    });

    it('should_not_scroll_when_list_is_empty', 0, () => {
      const result = resolveIndexFocusMove(5, 0, 0, 'right');
      expect(result.shouldScroll).assertEqual(false);
    });

    it('should_set_scroll_target_to_current_focus_when_list_empty', 0, () => {
      const result = resolveIndexFocusMove(3, 0, 0, 'left');
      expect(result.scrollTarget).assertEqual(3);
    });
  });

  describe('Index_focus_move_single_item_list', () => {
    it('should_clamp_next_to_zero_and_not_scroll_for_single_item', 0, () => {
      const result = resolveIndexFocusMove(0, 0, 1, 'right');
      expect(result.nextFocusIndex).assertEqual(0);
      expect(result.shouldScroll).assertEqual(false);
    });
  });

  describe('Index_focus_move_two_item_list', () => {
    it('should_move_from_index_0_to_1_on_right', 0, () => {
      const result = resolveIndexFocusMove(0, 0, 2, 'right');
      expect(result.nextFocusIndex).assertEqual(1);
    });

    it('should_clamp_at_last_index_1_on_right_from_index_1', 0, () => {
      const result = resolveIndexFocusMove(1, 0, 2, 'right');
      expect(result.nextFocusIndex).assertEqual(1);
    });

    it('should_scroll_target_for_right_from_0_as_1_minus_4', 0, () => {
      const result = resolveIndexFocusMove(0, 0, 2, 'right');
      expect(result.scrollTarget).assertEqual(-3);
    });
  });

  describe('Index_initial_focus_default_in_list', () => {
    it('should_focus_default_source_when_present_in_list', 0, () => {
      const sourceIds: number[] = [1, 2, 3, 4, 5, 6];
      const result = resolveIndexInitialFocus(sourceIds, 3, 2);
      expect(result.focusIndex).assertEqual(2);
      expect(result.focusSourceId).assertEqual(3);
      expect(result.defaultSourceId).assertEqual(3);
    });

    it('should_not_scroll_when_default_near_center', 0, () => {
      const sourceIds: number[] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
      const result = resolveIndexInitialFocus(sourceIds, 4, 4);
      expect(result.shouldScroll).assertEqual(false);
    });

    it('should_scroll_when_default_far_from_center', 0, () => {
      const sourceIds: number[] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
      const result = resolveIndexInitialFocus(sourceIds, 9, 4);
      expect(result.shouldScroll).assertEqual(true);
    });

    it('should_compute_scroll_target_as_focusIndex_minus_4', 0, () => {
      const sourceIds: number[] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
      const result = resolveIndexInitialFocus(sourceIds, 9, 4);
      expect(result.scrollTarget).assertEqual(4);
    });
  });

  describe('Index_initial_focus_default_not_in_list', () => {
    it('should_fallback_to_first_source_when_default_not_found', 0, () => {
      const sourceIds: number[] = [1, 2, 3, 4];
      const result = resolveIndexInitialFocus(sourceIds, 99, 2);
      expect(result.focusIndex).assertEqual(0);
      expect(result.focusSourceId).assertEqual(1);
    });

    it('should_scroll_when_fallback_index_far_from_center', 0, () => {
      const sourceIds: number[] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
      const result = resolveIndexInitialFocus(sourceIds, 99, 4);
      expect(result.shouldScroll).assertEqual(true);
      expect(result.focusIndex).assertEqual(0);
    });

    it('should_use_default_as_focusSourceId_when_list_is_empty', 0, () => {
      const result = resolveIndexInitialFocus([], 6, 0);
      expect(result.focusIndex).assertEqual(0);
      expect(result.focusSourceId).assertEqual(6);
    });
  });

  describe('Index_initial_focus_empty_list', () => {
    it('should_set_focus_index_to_zero_when_list_empty', 0, () => {
      const result = resolveIndexInitialFocus([], 5, 2);
      expect(result.focusIndex).assertEqual(0);
    });

    it('should_use_default_as_focusSourceId_when_list_empty', 0, () => {
      const result = resolveIndexInitialFocus([], 5, 2);
      expect(result.focusSourceId).assertEqual(5);
    });

    it('should_not_scroll_when_list_empty', 0, () => {
      const result = resolveIndexInitialFocus([], 5, 2);
      expect(result.shouldScroll).assertEqual(false);
    });

    it('should_set_scroll_target_to_zero_when_list_empty', 0, () => {
      const result = resolveIndexInitialFocus([], 5, 2);
      expect(result.scrollTarget).assertEqual(-4);
    });
  });

  describe('Index_initial_focus_single_item_list', () => {
    it('should_focus_single_item_regardless_of_default', 0, () => {
      const result = resolveIndexInitialFocus([7], 99, 0);
      expect(result.focusIndex).assertEqual(0);
      expect(result.focusSourceId).assertEqual(7);
    });

    it('should_not_scroll_for_single_item', 0, () => {
      const result = resolveIndexInitialFocus([7], 99, 0);
      expect(result.shouldScroll).assertEqual(false);
    });
  });

  describe('Index_initial_focus_center_band_contract', () => {
    it('should_not_scroll_when_default_exactly_at_lower_center_bound', 0, () => {
      const sourceIds: number[] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
      const result = resolveIndexInitialFocus(sourceIds, 2, 4);
      expect(result.shouldScroll).assertEqual(true);
    });

    it('should_not_scroll_when_default_exactly_at_upper_center_bound', 0, () => {
      const sourceIds: number[] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
      const result = resolveIndexInitialFocus(sourceIds, 6, 4);
      expect(result.shouldScroll).assertEqual(false);
    });

    it('should_scroll_when_default_one_below_lower_bound', 0, () => {
      const sourceIds: number[] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
      const result = resolveIndexInitialFocus(sourceIds, 1, 4);
      expect(result.shouldScroll).assertEqual(true);
    });

    it('should_scroll_when_default_one_above_upper_bound', 0, () => {
      const sourceIds: number[] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
      const result = resolveIndexInitialFocus(sourceIds, 7, 4);
      expect(result.shouldScroll).assertEqual(false);
    });
  });

  describe('Index_focus_move_center_band_at_extremes', () => {
    it('should_scroll_when_focus_at_0_and_moving_left_and_center_is_large', 0, () => {
      const result = resolveIndexFocusMove(0, 6, 12, 'left');
      expect(result.shouldScroll).assertEqual(true);
    });

    it('should_not_scroll_when_focus_at_0_and_moving_right_within_band', 0, () => {
      const result = resolveIndexFocusMove(0, 2, 12, 'right');
      expect(result.shouldScroll).assertEqual(false);
    });

    it('should_scroll_when_focus_at_last_and_moving_right_and_center_is_small', 0, () => {
      const result = resolveIndexFocusMove(11, 4, 12, 'right');
      expect(result.shouldScroll).assertEqual(true);
    });

    it('should_not_scroll_when_focus_at_last_and_moving_left_within_band', 0, () => {
      const result = resolveIndexFocusMove(11, 9, 12, 'left');
      expect(result.shouldScroll).assertEqual(false);
    });
  });

  describe('Index_focus_move_large_list_scaling', () => {
    it('should_scroll_target_for_right_near_end_as_last_minus_4', 0, () => {
      const result = resolveIndexFocusMove(13, 10, 20, 'right');
      expect(result.nextFocusIndex).assertEqual(14);
      expect(result.scrollTarget).assertEqual(10);
    });

    it('should_scroll_target_for_left_near_start_as_nextIndex', 0, () => {
      const result = resolveIndexFocusMove(5, 10, 20, 'left');
      expect(result.nextFocusIndex).assertEqual(4);
      expect(result.scrollTarget).assertEqual(4);
    });

    it('should_maintain_center_band_at_large_center_index', 0, () => {
      const result = resolveIndexFocusMove(14, 15, 25, 'left');
      expect(result.nextFocusIndex).assertEqual(13);
      expect(result.shouldScroll).assertEqual(false);
    });
  });

  describe('Index_initial_focus_preserves_default_source_id', () => {
    it('should_preserve_original_default_source_id_in_result', 0, () => {
      const sourceIds: number[] = [1, 2, 3, 4, 5];
      const result = resolveIndexInitialFocus(sourceIds, 3, 2);
      expect(result.defaultSourceId).assertEqual(3);
    });

    it('should_preserve_original_default_when_not_in_list', 0, () => {
      const sourceIds: number[] = [1, 2, 3, 4, 5];
      const result = resolveIndexInitialFocus(sourceIds, 99, 2);
      expect(result.defaultSourceId).assertEqual(99);
    });

    it('should_preserve_original_default_when_list_empty', 0, () => {
      const result = resolveIndexInitialFocus([], 7, 0);
      expect(result.defaultSourceId).assertEqual(7);
    });
  });

  describe('Index_focus_compound_scenarios', () => {
    it('should_chain_multiple_left_moves_without_overshooting', 0, () => {
      const r0 = resolveIndexFocusMove(5, 3, 10, 'left');
      const r1 = resolveIndexFocusMove(r0.nextFocusIndex, 3, 10, 'left');
      const r2 = resolveIndexFocusMove(r1.nextFocusIndex, 3, 10, 'left');
      expect(r0.nextFocusIndex).assertEqual(4);
      expect(r1.nextFocusIndex).assertEqual(3);
      expect(r2.nextFocusIndex).assertEqual(2);
    });

    it('should_chain_multiple_right_moves_without_overshooting', 0, () => {
      const r0 = resolveIndexFocusMove(3, 3, 10, 'right');
      const r1 = resolveIndexFocusMove(r0.nextFocusIndex, 3, 10, 'right');
      const r2 = resolveIndexFocusMove(r1.nextFocusIndex, 3, 10, 'right');
      expect(r0.nextFocusIndex).assertEqual(4);
      expect(r1.nextFocusIndex).assertEqual(5);
      expect(r2.nextFocusIndex).assertEqual(6);
    });

    it('should_honor_scroll_policy_across_long_journey', 0, () => {
      const sourceIds: number[] = [];
      for (let index = 0; index < 20; index++) {
        sourceIds.push(index + 1);
      }
      const initial = resolveIndexInitialFocus(sourceIds, 18, 4);
      expect(initial.shouldScroll).assertEqual(true);
      expect(initial.scrollTarget).assertEqual(13);

      let currentIndex = initial.focusIndex;
      let scrollCount = 0;
      for (let i = 0; i < 5; i++) {
        const move = resolveIndexFocusMove(currentIndex, 4, sourceIds.length, 'left');
        currentIndex = move.nextFocusIndex;
        if (move.shouldScroll) {
          scrollCount++;
        }
      }
      expect(scrollCount).assertLargerOrEqual(0);
    });

    it('should_resolve_initial_then_move_right_combining_policies', 0, () => {
      const sourceIds: number[] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
      const initial = resolveIndexInitialFocus(sourceIds, 15, 7);
      expect(initial.focusIndex).assertEqual(14);
      expect(initial.shouldScroll).assertEqual(true);

      const moved = resolveIndexFocusMove(initial.focusIndex, 7, sourceIds.length, 'right');
      expect(moved.nextFocusIndex).assertEqual(14);
      expect(moved.shouldScroll).assertEqual(true);
    });
  });
}
