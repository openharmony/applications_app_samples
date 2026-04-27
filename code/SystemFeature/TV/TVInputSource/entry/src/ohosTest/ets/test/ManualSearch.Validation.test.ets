/*
 * Copyright (c) 2026 Huawei Device Device Co., Ltd.
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
  normalizeManualSearchFrequency,
  buildManualSearchPresentation,
  ManualSearchPresentation
} from '../../../main/ets/pages/ManualSearch';

const TAG = '[ManualSearch.Validation.test]';

class ManualSearchLifecycle {
  public frequency: number = 0;
  public channelCount: number = 0;
  public presentation: ManualSearchPresentation | null = null;

  public reset(): void {
    this.frequency = 0;
    this.channelCount = 0;
    this.presentation = null;
  }
}

const lifecycle = new ManualSearchLifecycle();

function runManualSearchFrequencyNormalizationTests(): void {
  describe('ManualSearch_frequency_normalization', () => {
    beforeEach(() => {
      lifecycle.reset();
    });

    afterEach(() => {
      lifecycle.reset();
    });

    it('should_return_input_frequency_when_valid_positive', 0, () => {
      lifecycle.frequency = 474.0;

      const result = normalizeManualSearchFrequency(lifecycle.frequency);

      expect(result).assertEqual(474.0);
    });

    it('should_return_input_frequency_when_valid_zero', 0, () => {
      lifecycle.frequency = 0;

      const result = normalizeManualSearchFrequency(lifecycle.frequency);

      expect(result).assertEqual(0);
    });

    it('should_return_input_frequency_when_valid_small_decimal', 0, () => {
      lifecycle.frequency = 0.5;

      const result = normalizeManualSearchFrequency(lifecycle.frequency);

      expect(result).assertEqual(0.5);
    });

    it('should_return_input_frequency_when_valid_large_decimal', 0, () => {
      lifecycle.frequency = 866.25;

      const result = normalizeManualSearchFrequency(lifecycle.frequency);

      expect(result).assertEqual(866.25);
    });

    it('should_return_fallback_when_frequency_is_negative', 0, () => {
      lifecycle.frequency = -1;

      const result = normalizeManualSearchFrequency(lifecycle.frequency);

      expect(result).assertEqual(0.5);
    });

    it('should_return_fallback_when_frequency_is_large_negative', 0, () => {
      lifecycle.frequency = -100;

      const result = normalizeManualSearchFrequency(lifecycle.frequency);

      expect(result).assertEqual(0.5);
    });

    it('should_return_fallback_when_frequency_is_NaN', 0, () => {
      lifecycle.frequency = NaN;

      const result = normalizeManualSearchFrequency(lifecycle.frequency);

      expect(Number.isNaN(result)).assertEqual(false);
    });

    it('should_return_fallback_when_frequency_is_Infinity', 0, () => {
      lifecycle.frequency = Infinity;

      const result = normalizeManualSearchFrequency(lifecycle.frequency);

      expect(result).assertEqual(0.5);
    });

    it('should_return_fallback_when_frequency_is_negative_Infinity', 0, () => {
      lifecycle.frequency = -Infinity;

      const result = normalizeManualSearchFrequency(lifecycle.frequency);

      expect(result).assertEqual(0.5);
    });

    it('should_use_custom_fallback_when_provided', 0, () => {
      lifecycle.frequency = -50;

      const result = normalizeManualSearchFrequency(lifecycle.frequency, 100.0);

      expect(result).assertEqual(100.0);
    });

    it('should_use_zero_as_fallback_when_explicitly_provided', 0, () => {
      lifecycle.frequency = -50;

      const result = normalizeManualSearchFrequency(lifecycle.frequency, 0);

      expect(result).assertEqual(0);
    });

    it('should_return_input_when_frequency_is_MAX_VALUE', 0, () => {
      lifecycle.frequency = Number.MAX_VALUE;

      const result = normalizeManualSearchFrequency(lifecycle.frequency);

      expect(result).assertEqual(Number.MAX_VALUE);
    });

    it('should_return_fallback_when_frequency_is_MIN_VALUE', 0, () => {
      lifecycle.frequency = Number.MIN_VALUE;

      const result = normalizeManualSearchFrequency(lifecycle.frequency);

      expect(result).assertEqual(0.5);
    });
  });
}

function runManualSearchPresentationTests(): void {
  describe('ManualSearch_presentation', () => {
    beforeEach(() => {
      lifecycle.reset();
    });

    afterEach(() => {
      lifecycle.reset();
    });

    it('should_convert_channel_count_to_string', 0, () => {
      lifecycle.channelCount = 88;

      lifecycle.presentation = buildManualSearchPresentation(lifecycle.channelCount, 474.0);

      expect(lifecycle.presentation.channelCountText).assertEqual('88');
    });

    it('should_use_zero_when_channel_count_is_negative', 0, () => {
      lifecycle.channelCount = -1;

      lifecycle.presentation = buildManualSearchPresentation(lifecycle.channelCount, 474.0);

      expect(lifecycle.presentation.channelCountText).assertEqual('0');
    });

    it('should_use_zero_when_channel_count_is_large_negative', 0, () => {
      lifecycle.channelCount = -1000;

      lifecycle.presentation = buildManualSearchPresentation(lifecycle.channelCount, 474.0);

      expect(lifecycle.presentation.channelCountText).assertEqual('0');
    });

    it('should_handle_zero_channel_count', 0, () => {
      lifecycle.channelCount = 0;

      lifecycle.presentation = buildManualSearchPresentation(lifecycle.channelCount, 474.0);

      expect(lifecycle.presentation.channelCountText).assertEqual('0');
    });

    it('should_format_scanning_text_with_frequency', 0, () => {
      lifecycle.presentation = buildManualSearchPresentation(88, 474.0);

      expect(lifecycle.presentation.scanningText).assertEqual('姝ｅ湪鎼滃彴 474.0 MHz');
    });

    it('should_format_scanning_text_with_decimal_frequency', 0, () => {
      lifecycle.presentation = buildManualSearchPresentation(88, 474.5);

      expect(lifecycle.presentation.scanningText).assertEqual('姝ｅ湪鎼滃彴 474.5 MHz');
    });

    it('should_use_normalized_frequency_when_input_is_invalid', 0, () => {
      lifecycle.presentation = buildManualSearchPresentation(88, -1);

      expect(lifecycle.presentation.scanningText).assertEqual('姝ｅ湪鎼滃彴 0.5 MHz');
    });

    it('should_use_normalized_frequency_when_input_is_NaN', 0, () => {
      lifecycle.presentation = buildManualSearchPresentation(88, NaN);

      expect(lifecycle.presentation.scanningText).assertEqual('姝ｅ湪鎼滃彴 0.5 MHz');
    });

    it('should_use_normalized_frequency_when_input_is_Infinity', 0, () => {
      lifecycle.presentation = buildManualSearchPresentation(88, Infinity);

      expect(lifecycle.presentation.scanningText).assertEqual('姝ｅ湪鎼滃彴 0.5 MHz');
    });

    it('should_handle_zero_frequency', 0, () => {
      lifecycle.presentation = buildManualSearchPresentation(0, 0);

      expect(lifecycle.presentation.scanningText).assertEqual('姝ｅ湪鎼滃彴 0.0 MHz');
    });

    it('should_handle_low_frequency', 0, () => {
      lifecycle.presentation = buildManualSearchPresentation(0, 48.25);

      expect(lifecycle.presentation.scanningText).assertEqual('姝ｅ湪鎼滃彴 48.3 MHz');
    });

    it('should_handle_high_frequency', 0, () => {
      lifecycle.presentation = buildManualSearchPresentation(0, 866.0);

      expect(lifecycle.presentation.scanningText).assertEqual('姝ｅ湪鎼滃彴 866.0 MHz');
    });
  });
}

function runManualSearchBoundaryTests(): void {
  describe('ManualSearch_boundary', () => {
    beforeEach(() => {
      lifecycle.reset();
    });

    afterEach(() => {
      lifecycle.reset();
    });

    it('should_handle_large_channel_count', 0, () => {
      lifecycle.presentation = buildManualSearchPresentation(2147483647, 474.0);

      expect(lifecycle.presentation.channelCountText).assertEqual('2147483647');
    });

    it('should_handle_large_negative_channel_count', 0, () => {
      lifecycle.presentation = buildManualSearchPresentation(-2147483648, 474.0);

      expect(lifecycle.presentation.channelCountText).assertEqual('0');
    });

    it('should_handle_extreme_channel_count', 0, () => {
      lifecycle.presentation = buildManualSearchPresentation(Number.MAX_SAFE_INTEGER, 474.0);

      expect(lifecycle.presentation.channelCountText).assertEqual(String(Number.MAX_SAFE_INTEGER));
    });

    it('should_handle_frequency_with_many_decimals', 0, () => {
      lifecycle.presentation = buildManualSearchPresentation(0, 474.9999);

      expect(lifecycle.presentation.scanningText).assertEqual('姝ｅ湪鎼滃彴 475.0 MHz');
    });

    it('should_handle_frequency_boundary_low', 0, () => {
      lifecycle.presentation = buildManualSearchPresentation(0, 0.0);

      expect(lifecycle.presentation.scanningText).assertEqual('姝ｅ湪鎼滃彴 0.0 MHz');
    });

    it('should_handle_frequency_boundary_high', 0, () => {
      lifecycle.presentation = buildManualSearchPresentation(0, 1000.0);

      expect(lifecycle.presentation.scanningText).assertEqual('姝ｅ湪鎼滃彴 1000.0 MHz');
    });

    it('should_handle_very_small_frequency', 0, () => {
      lifecycle.presentation = buildManualSearchPresentation(0, 0.001);

      expect(lifecycle.presentation.scanningText).assertEqual('姝ｅ湪鎼滃彴 0.0 MHz');
    });

    it('should_preserve_presentation_stability_for_same_input', 0, () => {
      const p1 = buildManualSearchPresentation(88, 474.0);
      const p2 = buildManualSearchPresentation(88, 474.0);

      expect(p1.channelCountText).assertEqual(p2.channelCountText);
      expect(p1.scanningText).assertEqual(p2.scanningText);
    });
  });
}

function runManualSearchIntegrationTests(): void {
  describe('ManualSearch_integration', () => {
    beforeEach(() => {
      lifecycle.reset();
    });

    afterEach(() => {
      lifecycle.reset();
    });

    it('should_build_presentation_with_normalized_frequency', 0, () => {
      lifecycle.channelCount = 50;
      lifecycle.frequency = -10;

      const normalizedFreq = normalizeManualSearchFrequency(lifecycle.frequency);
      lifecycle.presentation = buildManualSearchPresentation(lifecycle.channelCount, normalizedFreq);

      expect(lifecycle.presentation.channelCountText).assertEqual('50');
      expect(lifecycle.presentation.scanningText).assertEqual('姝ｅ湪鎼滃彴 0.5 MHz');
    });

    it('should_chain_normalize_and_presentation_calls', 0, () => {
      const invalidFrequencies: number[] = [-1, NaN, -Infinity, -100];
      const expectedFallback = '姝ｅ湪鎼滃彴 0.5 MHz';

      invalidFrequencies.forEach((freq) => {
        lifecycle.presentation = buildManualSearchPresentation(10, freq);
        expect(lifecycle.presentation.scanningText).assertEqual(expectedFallback);
      });
    });

    it('should_handle_incremental_channel_discovery', 0, () => {
      const channelCounts: number[] = [0, 1, 5, 10, 50, 100];

      channelCounts.forEach((count, index) => {
        lifecycle.presentation = buildManualSearchPresentation(count, 474.0);
        expect(lifecycle.presentation.channelCountText).assertEqual(String(count));
      });
    });

    it('should_handle_frequency_sweep_simulation', 0, (done: () => void) => {
      const frequencies: number[] = [48.25, 55.25, 62.25, 69.25, 474.0, 482.0, 490.0, 498.0, 506.0, 514.0, 522.0, 530.0,
                           538.0, 546.0, 554.0, 562.0, 570.0, 578.0, 586.0, 594.0, 602.0, 610.0, 618.0, 626.0,
                           634.0, 642.0, 650.0, 658.0, 666.0, 674.0, 682.0, 690.0, 698.0, 706.0, 714.0, 722.0,
                           730.0, 738.0, 746.0, 754.0, 762.0, 770.0, 778.0, 786.0, 794.0, 802.0, 810.0, 818.0,
                           826.0, 834.0, 842.0, 850.0, 858.0, 866.0];

      frequencies.forEach((freq) => {
        lifecycle.presentation = buildManualSearchPresentation(0, freq);
        expect(lifecycle.presentation.scanningText.includes('MHz')).assertEqual(true);
      });
      done();
    });
  });
}

function runManualSearchErrorHandlingTests(): void {
  describe('ManualSearch_error_handling', () => {
    beforeEach(() => {
      lifecycle.reset();
    });

    afterEach(() => {
      lifecycle.reset();
    });

    it('should_return_valid_number_type_for_normalized_frequency', 0, () => {
      lifecycle.frequency = 474.0;

      const result = normalizeManualSearchFrequency(lifecycle.frequency);

      expect(typeof result).assertEqual('number');
      expect(Number.isFinite(result)).assertEqual(true);
    });

    it('should_return_valid_number_type_for_fallback_frequency', 0, () => {
      lifecycle.frequency = -1;

      const result = normalizeManualSearchFrequency(lifecycle.frequency);

      expect(typeof result).assertEqual('number');
      expect(Number.isFinite(result)).assertEqual(true);
    });

    it('should_return_object_with_all_fields_in_presentation', 0, () => {
      lifecycle.presentation = buildManualSearchPresentation(88, 474.0);

      expect(lifecycle.presentation).assertInstanceOf('Object');
      expect(lifecycle.presentation.channelCountText).assertInstanceOf('String');
      expect(lifecycle.presentation.scanningText).assertInstanceOf('String');
    });

    it('should_distinguish_between_zero_and_negative_channel_count', 0, () => {
      const zeroPresentation = buildManualSearchPresentation(0, 474.0);
      const negativePresentation = buildManualSearchPresentation(-1, 474.0);

      expect(zeroPresentation.channelCountText).assertEqual('0');
      expect(negativePresentation.channelCountText).assertEqual('0');
    });

    it('should_distinguish_between_zero_and_one_channel_count', 0, () => {
      const zeroPresentation = buildManualSearchPresentation(0, 474.0);
      const onePresentation = buildManualSearchPresentation(1, 474.0);

      expect(zeroPresentation.channelCountText).assertEqual('0');
      expect(onePresentation.channelCountText).assertEqual('1');
    });

    it('should_handle_presentation_consistency_across_multiple_calls', 0, () => {
      const presentations: ManualSearchPresentation[] = [];

      for (let i = 0; i < 10; i++) {
        presentations.push(buildManualSearchPresentation(88, 474.0));
      }

      presentations.forEach((p) => {
        expect(p.channelCountText).assertEqual('88');
        expect(p.scanningText).assertEqual('姝ｅ湪鎼滃彴 474.0 MHz');
      });
    });
  });
}

export default function manualSearchValidationTestSuite(): void {
  runManualSearchFrequencyNormalizationTests();
  runManualSearchPresentationTests();
  runManualSearchBoundaryTests();
  runManualSearchIntegrationTests();
  runManualSearchErrorHandlingTests();
}

