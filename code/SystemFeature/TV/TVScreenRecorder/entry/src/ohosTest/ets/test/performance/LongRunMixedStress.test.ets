/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { describe, it } from '@ohos/hypium';
import {
  buildFoundationCanaryBuckets,
  buildFoundationDurations,
  FoundationRollingChecksum,
  FoundationScenarioCounter
} from '../foundation/FoundationAdvancedFixtures';
import { assertAtLeast, assertContains, assertNumberEqual, assertTrue } from '../foundation/TestAsserts';
import { LongRunMixHarness } from './PerformanceSceneHarness';

export default function longRunMixedStressTest(): void {
  describe('LongRunMixedStressTest', () => {
    it('LongRunMix_StartStopFocusMixBuildsEnoughSamples_001', 0, () => {
      const harness = new LongRunMixHarness();
      for (let round = 0; round < 180; round++) {
        harness.push('start', 100 + (round % 17));
        harness.push('focus', 30 + (round % 7));
        if (round % 2 === 0) {
          harness.push('stop', 80 + (round % 13));
        }
      }
      assertAtLeast(harness.getRecords().length, 450);
      assertAtLeast(harness.getCountByType('start'), 180);
      assertAtLeast(harness.getCountByType('stop'), 90);
    });

    it('LongRunMix_DurationBucketsMaintainDistinctCoverage_002', 0, () => {
      const durations = buildFoundationDurations();
      const buckets = buildFoundationCanaryBuckets();
      const harness = new LongRunMixHarness();
      const counter = new FoundationScenarioCounter();
      for (let durationIndex = 0; durationIndex < durations.length; durationIndex++) {
        for (let bucketIndex = 0; bucketIndex < buckets.length; bucketIndex++) {
          const label = `${durations[durationIndex]}_${buckets[bucketIndex]}`;
          harness.push(label, durations[durationIndex] + bucketIndex);
          counter.record(label);
        }
      }
      assertNumberEqual(counter.getDistinctCount(), durations.length * buckets.length);
      assertAtLeast(harness.getRecords().length, durations.length * buckets.length);
    });

    it('LongRunMix_DualPassFingerprintRemainsStable_003', 0, () => {
      const checksumA = new FoundationRollingChecksum();
      const checksumB = new FoundationRollingChecksum();
      for (let pass = 0; pass < 2; pass++) {
        const harness = new LongRunMixHarness();
        for (let round = 0; round < 50; round++) {
          harness.push('start', 110 + (round % 9));
          harness.push('focus', 28 + (round % 5));
          harness.push('stop', 82 + (round % 6));
        }
        const summary = harness.getRecords().map((record) => `${record.type}_${record.durationMs}`).join('|');
        if (pass === 0) {
          checksumA.appendText(summary);
        } else {
          checksumB.appendText(summary);
        }
      }
      assertNumberEqual(checksumA.getValue(), checksumB.getValue());
    });

    it('LongRunMix_MaxDurationRemainsTrackable_004', 0, () => {
      const harness = new LongRunMixHarness();
      for (let round = 0; round < 70; round++) {
        harness.push('focus', 25 + round);
      }
      assertAtLeast(harness.getMaxDuration(), 94);
      assertTrue(harness.getMaxDuration() > 0);
    });

    it('LongRunMix_ActionTrailContainsStartFocusStopMarkers_005', 0, () => {
      const harness = new LongRunMixHarness();
      harness.push('start', 100);
      harness.push('focus', 30);
      harness.push('stop', 80);
      const summary = harness.getRecords().map((record) => `${record.type}:${record.durationMs}`).join(',');
      assertContains(summary, 'start:100');
      assertContains(summary, 'focus:30');
      assertContains(summary, 'stop:80');
    });
  });
}
