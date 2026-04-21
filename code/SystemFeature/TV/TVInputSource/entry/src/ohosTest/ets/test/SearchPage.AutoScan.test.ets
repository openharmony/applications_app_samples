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
  resolveSearchPageShowDecision,
  resolveSearchPageHideDecision,
  buildSearchProgressPresentation,
  SearchPageShowDecision,
  SearchPageHideDecision,
  SearchProgressPresentation
} from '../../../main/ets/pages/SearchPage';

const TAG = '[SearchPage.AutoScan.test]';

class SearchPageLifecycle {
  public showDecision: SearchPageShowDecision | null = null;
  public hideDecision: SearchPageHideDecision | null = null;
  public presentation: SearchProgressPresentation | null = null;
  public currentTimerId: number = -1;

  public reset(): void {
    this.showDecision = null;
    this.hideDecision = null;
    this.presentation = null;
    this.currentTimerId = -1;
  }
}

const lifecycle = new SearchPageLifecycle();

function runSearchPageShowDecisionTests(): void {
  describe('SearchPage_show_decision', () => {
    beforeEach(() => {
      lifecycle.reset();
    });

    afterEach(() => {
      lifecycle.reset();
    });

    it('should_open_dialog_when_timer_id_is_negative_one', 0, () => {
      lifecycle.currentTimerId = -1;

      lifecycle.showDecision = resolveSearchPageShowDecision(lifecycle.currentTimerId);

      expect(lifecycle.showDecision.shouldOpenDialog).assertEqual(true);
    });

    it('should_clear_previous_timer_when_timer_id_is_negative_one', 0, () => {
      lifecycle.currentTimerId = -1;

      lifecycle.showDecision = resolveSearchPageShowDecision(lifecycle.currentTimerId);

      expect(lifecycle.showDecision.shouldClearPreviousTimer).assertEqual(false);
    });

    it('should_open_dialog_when_timer_id_is_zero', 0, () => {
      lifecycle.currentTimerId = 0;

      lifecycle.showDecision = resolveSearchPageShowDecision(lifecycle.currentTimerId);

      expect(lifecycle.showDecision.shouldOpenDialog).assertEqual(true);
    });

    it('should_clear_previous_timer_when_timer_id_is_zero', 0, () => {
      lifecycle.currentTimerId = 0;

      lifecycle.showDecision = resolveSearchPageShowDecision(lifecycle.currentTimerId);

      expect(lifecycle.showDecision.shouldClearPreviousTimer).assertEqual(true);
    });

    it('should_open_dialog_when_timer_id_is_positive', 0, () => {
      lifecycle.currentTimerId = 12345;

      lifecycle.showDecision = resolveSearchPageShowDecision(lifecycle.currentTimerId);

      expect(lifecycle.showDecision.shouldOpenDialog).assertEqual(true);
    });

    it('should_clear_previous_timer_when_timer_id_is_positive', 0, () => {
      lifecycle.currentTimerId = 12345;

      lifecycle.showDecision = resolveSearchPageShowDecision(lifecycle.currentTimerId);

      expect(lifecycle.showDecision.shouldClearPreviousTimer).assertEqual(true);
    });

    it('should_set_back_delay_to_8000ms', 0, () => {
      lifecycle.currentTimerId = -1;

      lifecycle.showDecision = resolveSearchPageShowDecision(lifecycle.currentTimerId);

      expect(lifecycle.showDecision.backDelayMs).assertEqual(8000);
    });

    it('should_maintain_consistent_decision_for_same_timer_id', 0, () => {
      lifecycle.currentTimerId = 100;

      const decision1 = resolveSearchPageShowDecision(lifecycle.currentTimerId);
      const decision2 = resolveSearchPageShowDecision(lifecycle.currentTimerId);

      expect(decision1.shouldOpenDialog).assertEqual(decision2.shouldOpenDialog);
      expect(decision1.shouldClearPreviousTimer).assertEqual(decision2.shouldClearPreviousTimer);
      expect(decision1.backDelayMs).assertEqual(decision2.backDelayMs);
    });
  });
}

function runSearchPageHideDecisionTests(): void {
  describe('SearchPage_hide_decision', () => {
    beforeEach(() => {
      lifecycle.reset();
    });

    afterEach(() => {
      lifecycle.reset();
    });

    it('should_not_clear_timer_when_timer_id_is_negative_one', 0, () => {
      lifecycle.currentTimerId = -1;

      lifecycle.hideDecision = resolveSearchPageHideDecision(lifecycle.currentTimerId);

      expect(lifecycle.hideDecision.shouldClearTimer).assertEqual(false);
    });

    it('should_set_next_timer_id_to_negative_one_when_current_is_negative_one', 0, () => {
      lifecycle.currentTimerId = -1;

      lifecycle.hideDecision = resolveSearchPageHideDecision(lifecycle.currentTimerId);

      expect(lifecycle.hideDecision.nextTimerId).assertEqual(-1);
    });

    it('should_clear_timer_when_timer_id_is_zero', 0, () => {
      lifecycle.currentTimerId = 0;

      lifecycle.hideDecision = resolveSearchPageHideDecision(lifecycle.currentTimerId);

      expect(lifecycle.hideDecision.shouldClearTimer).assertEqual(true);
    });

    it('should_set_next_timer_id_to_negative_one_when_current_is_zero', 0, () => {
      lifecycle.currentTimerId = 0;

      lifecycle.hideDecision = resolveSearchPageHideDecision(lifecycle.currentTimerId);

      expect(lifecycle.hideDecision.nextTimerId).assertEqual(-1);
    });

    it('should_clear_timer_when_timer_id_is_positive', 0, () => {
      lifecycle.currentTimerId = 12345;

      lifecycle.hideDecision = resolveSearchPageHideDecision(lifecycle.currentTimerId);

      expect(lifecycle.hideDecision.shouldClearTimer).assertEqual(true);
    });

    it('should_set_next_timer_id_to_negative_one_when_current_is_positive', 0, () => {
      lifecycle.currentTimerId = 12345;

      lifecycle.hideDecision = resolveSearchPageHideDecision(lifecycle.currentTimerId);

      expect(lifecycle.hideDecision.nextTimerId).assertEqual(-1);
    });

    it('should_maintain_consistent_decision_for_same_timer_id', 0, () => {
      lifecycle.currentTimerId = 200;

      const decision1 = resolveSearchPageHideDecision(lifecycle.currentTimerId);
      const decision2 = resolveSearchPageHideDecision(lifecycle.currentTimerId);

      expect(decision1.shouldClearTimer).assertEqual(decision2.shouldClearTimer);
      expect(decision1.nextTimerId).assertEqual(decision2.nextTimerId);
    });
  });
}

function runSearchProgressPresentationTests(): void {
  describe('SearchPage_progress_presentation', () => {
    beforeEach(() => {
      lifecycle.reset();
    });

    afterEach(() => {
      lifecycle.reset();
    });

    it('should_convert_channel_count_to_string', 0, () => {
      lifecycle.presentation = buildSearchProgressPresentation(88, 474.0, 50);

      expect(lifecycle.presentation.channelCountText).assertEqual('88');
    });

    it('should_use_zero_when_channel_count_is_negative', 0, () => {
      lifecycle.presentation = buildSearchProgressPresentation(-1, 474.0, 50);

      expect(lifecycle.presentation.channelCountText).assertEqual('0');
    });

    it('should_use_zero_when_channel_count_is_negative_hundred', 0, () => {
      lifecycle.presentation = buildSearchProgressPresentation(-100, 474.0, 50);

      expect(lifecycle.presentation.channelCountText).assertEqual('0');
    });

    it('should_handle_zero_channel_count', 0, () => {
      lifecycle.presentation = buildSearchProgressPresentation(0, 474.0, 50);

      expect(lifecycle.presentation.channelCountText).assertEqual('0');
    });

    it('should_format_scanning_text_with_frequency', 0, () => {
      lifecycle.presentation = buildSearchProgressPresentation(88, 474.0, 50);

      expect(lifecycle.presentation.scanningText).assertEqual('姝ｅ湪鎼滃彴 474.0 MHz');
    });

    it('should_format_scanning_text_with_decimal_frequency', 0, () => {
      lifecycle.presentation = buildSearchProgressPresentation(88, 474.5, 50);

      expect(lifecycle.presentation.scanningText).assertEqual('姝ｅ湪鎼滃彴 474.5 MHz');
    });

    it('should_format_scanning_text_with_low_frequency', 0, () => {
      lifecycle.presentation = buildSearchProgressPresentation(0, 48.25, 10);

      expect(lifecycle.presentation.scanningText).assertEqual('姝ｅ湪鎼滃彴 48.3 MHz');
    });

    it('should_format_scanning_text_with_high_frequency', 0, () => {
      lifecycle.presentation = buildSearchProgressPresentation(0, 866.0, 90);

      expect(lifecycle.presentation.scanningText).assertEqual('姝ｅ湪鎼滃彴 866.0 MHz');
    });

    it('should_format_progress_text_with_default_mode', 0, () => {
      lifecycle.presentation = buildSearchProgressPresentation(88, 474.0, 50);

      expect(lifecycle.presentation.progressText).assertEqual('鑷姩鎼滃彴 50%');
    });

    it('should_format_progress_text_with_custom_mode', 0, () => {
      lifecycle.presentation = buildSearchProgressPresentation(88, 474.0, 75, '鎵嬪姩鎼滃彴');

      expect(lifecycle.presentation.progressText).assertEqual('鎵嬪姩鎼滃彴 75%');
    });

    it('should_use_zero_when_progress_is_negative', 0, () => {
      lifecycle.presentation = buildSearchProgressPresentation(88, 474.0, -1);

      expect(lifecycle.presentation.progressText).assertEqual('鑷姩鎼滃彴 0%');
    });

    it('should_use_zero_when_progress_is_negative_hundred', 0, () => {
      lifecycle.presentation = buildSearchProgressPresentation(88, 474.0, -100);

      expect(lifecycle.presentation.progressText).assertEqual('鑷姩鎼滃彴 0%');
    });

    it('should_handle_zero_progress', 0, () => {
      lifecycle.presentation = buildSearchProgressPresentation(0, 474.0, 0);

      expect(lifecycle.presentation.progressText).assertEqual('鑷姩鎼滃彴 0%');
    });

    it('should_handle_full_progress', 0, () => {
      lifecycle.presentation = buildSearchProgressPresentation(100, 866.0, 100);

      expect(lifecycle.presentation.progressText).assertEqual('鑷姩鎼滃彴 100%');
    });
  });
}

function runSearchPageIntegrationTests(): void {
  describe('SearchPage_integration', () => {
    beforeEach(() => {
      lifecycle.reset();
    });

    afterEach(() => {
      lifecycle.reset();
    });

    it('should_follow_show_then_hide_lifecycle_for_new_timer', 0, () => {
      lifecycle.currentTimerId = -1;

      lifecycle.showDecision = resolveSearchPageShowDecision(lifecycle.currentTimerId);
      lifecycle.hideDecision = resolveSearchPageHideDecision(1);

      expect(lifecycle.showDecision.shouldOpenDialog).assertEqual(true);
      expect(lifecycle.showDecision.shouldClearPreviousTimer).assertEqual(false);
      expect(lifecycle.showDecision.backDelayMs).assertEqual(8000);
      expect(lifecycle.hideDecision.shouldClearTimer).assertEqual(true);
      expect(lifecycle.hideDecision.nextTimerId).assertEqual(-1);
    });

    it('should_follow_show_then_hide_lifecycle_for_existing_timer', 0, () => {
      lifecycle.currentTimerId = 12345;

      lifecycle.showDecision = resolveSearchPageShowDecision(lifecycle.currentTimerId);
      lifecycle.hideDecision = resolveSearchPageHideDecision(12346);

      expect(lifecycle.showDecision.shouldOpenDialog).assertEqual(true);
      expect(lifecycle.showDecision.shouldClearPreviousTimer).assertEqual(true);
      expect(lifecycle.hideDecision.shouldClearTimer).assertEqual(true);
      expect(lifecycle.hideDecision.nextTimerId).assertEqual(-1);
    });

    it('should_handle_rapid_timer_restart', 0, () => {
      lifecycle.currentTimerId = 100;
      lifecycle.showDecision = resolveSearchPageShowDecision(lifecycle.currentTimerId);
      lifecycle.hideDecision = resolveSearchPageHideDecision(lifecycle.currentTimerId);

      expect(lifecycle.hideDecision.shouldClearTimer).assertEqual(true);
      expect(lifecycle.hideDecision.nextTimerId).assertEqual(-1);

      lifecycle.currentTimerId = lifecycle.hideDecision.nextTimerId;
      lifecycle.showDecision = resolveSearchPageShowDecision(lifecycle.currentTimerId);

      expect(lifecycle.showDecision.shouldClearPreviousTimer).assertEqual(false);
    });

    it('should_maintain_presentation_stability_across_multiple_builds', 0, () => {
      const presentation1 = buildSearchProgressPresentation(88, 474.0, 50, '鑷姩鎼滃彴');
      const presentation2 = buildSearchProgressPresentation(88, 474.0, 50, '鑷姩鎼滃彴');
      const presentation3 = buildSearchProgressPresentation(88, 474.0, 50, '鑷姩鎼滃彴');

      expect(presentation1.channelCountText).assertEqual(presentation2.channelCountText);
      expect(presentation2.channelCountText).assertEqual(presentation3.channelCountText);
      expect(presentation1.scanningText).assertEqual(presentation2.scanningText);
      expect(presentation2.scanningText).assertEqual(presentation3.scanningText);
      expect(presentation1.progressText).assertEqual(presentation2.progressText);
      expect(presentation2.progressText).assertEqual(presentation3.progressText);
    });
  });
}

function runSearchPageBoundaryTests(): void {
  describe('SearchPage_boundary', () => {
    beforeEach(() => {
      lifecycle.reset();
    });

    afterEach(() => {
      lifecycle.reset();
    });

    it('should_handle_large_channel_count', 0, () => {
      lifecycle.presentation = buildSearchProgressPresentation(2147483647, 474.0, 50);

      expect(lifecycle.presentation.channelCountText).assertEqual('2147483647');
    });

    it('should_handle_large_negative_channel_count', 0, () => {
      lifecycle.presentation = buildSearchProgressPresentation(-2147483648, 474.0, 50);

      expect(lifecycle.presentation.channelCountText).assertEqual('0');
    });

    it('should_handle_extreme_progress_values', 0, () => {
      lifecycle.presentation = buildSearchProgressPresentation(0, 474.0, 2147483647);

      expect(lifecycle.presentation.progressText).assertEqual('鑷姩鎼滃彴 2147483647%');
    });

    it('should_handle_frequency_boundary_values', 0, () => {
      lifecycle.presentation = buildSearchProgressPresentation(0, 0.0, 0);

      expect(lifecycle.presentation.scanningText).assertEqual('姝ｅ湪鎼滃彴 0.0 MHz');
    });

    it('should_handle_frequency_with_many_decimals', 0, () => {
      lifecycle.presentation = buildSearchProgressPresentation(0, 474.999, 50);

      expect(lifecycle.presentation.scanningText).assertEqual('姝ｅ湪鎼滃彴 475.0 MHz');
    });

    it('should_handle_maximum_timer_id', 0, () => {
      lifecycle.currentTimerId = 2147483647;

      lifecycle.showDecision = resolveSearchPageShowDecision(lifecycle.currentTimerId);
      lifecycle.hideDecision = resolveSearchPageHideDecision(lifecycle.currentTimerId);

      expect(lifecycle.showDecision.shouldClearPreviousTimer).assertEqual(true);
      expect(lifecycle.hideDecision.shouldClearTimer).assertEqual(true);
    });

    it('should_handle_minimum_timer_id', 0, () => {
      lifecycle.currentTimerId = -2147483648;

      lifecycle.showDecision = resolveSearchPageShowDecision(lifecycle.currentTimerId);
      lifecycle.hideDecision = resolveSearchPageHideDecision(lifecycle.currentTimerId);

      expect(lifecycle.showDecision.shouldClearPreviousTimer).assertEqual(false);
      expect(lifecycle.hideDecision.shouldClearTimer).assertEqual(false);
    });
  });
}

function runSearchPageErrorHandlingTests(): void {
  describe('SearchPage_error_handling', () => {
    beforeEach(() => {
      lifecycle.reset();
    });

    afterEach(() => {
      lifecycle.reset();
    });

    it('should_return_all_fields_in_show_decision', 0, () => {
      lifecycle.currentTimerId = 100;

      lifecycle.showDecision = resolveSearchPageShowDecision(lifecycle.currentTimerId);

      expect(lifecycle.showDecision).assertInstanceOf('Object');
      expect(lifecycle.showDecision.shouldOpenDialog).assertInstanceOf('Boolean');
      expect(lifecycle.showDecision.shouldClearPreviousTimer).assertInstanceOf('Boolean');
      expect(lifecycle.showDecision.backDelayMs).assertInstanceOf('Number');
    });

    it('should_return_all_fields_in_hide_decision', 0, () => {
      lifecycle.currentTimerId = 100;

      lifecycle.hideDecision = resolveSearchPageHideDecision(lifecycle.currentTimerId);

      expect(lifecycle.hideDecision).assertInstanceOf('Object');
      expect(lifecycle.hideDecision.shouldClearTimer).assertInstanceOf('Boolean');
      expect(lifecycle.hideDecision.nextTimerId).assertInstanceOf('Number');
    });

    it('should_return_all_fields_in_presentation', 0, () => {
      lifecycle.presentation = buildSearchProgressPresentation(88, 474.0, 50);

      expect(lifecycle.presentation).assertInstanceOf('Object');
      expect(lifecycle.presentation.channelCountText).assertInstanceOf('String');
      expect(lifecycle.presentation.scanningText).assertInstanceOf('String');
      expect(lifecycle.presentation.progressText).assertInstanceOf('String');
    });

    it('should_preserve_mode_label_in_progress_text', 0, () => {
      const customModes: string[] = ['auto search', 'manual search', 'full band scan', 'quick scan', 'direct scan'];

      customModes.forEach((mode) => {
        lifecycle.presentation = buildSearchProgressPresentation(0, 474.0, 50, mode);
        expect(lifecycle.presentation.progressText.includes(mode)).assertEqual(true);
      });
    });
  });
}

export default function searchPageAutoScanTestSuite(): void {
  runSearchPageShowDecisionTests();
  runSearchPageHideDecisionTests();
  runSearchProgressPresentationTests();
  runSearchPageIntegrationTests();
  runSearchPageBoundaryTests();
  runSearchPageErrorHandlingTests();
}

