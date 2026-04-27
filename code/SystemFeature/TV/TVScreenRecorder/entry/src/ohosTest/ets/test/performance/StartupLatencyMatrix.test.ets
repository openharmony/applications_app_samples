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
  buildFoundationCompatibilityProfiles,
  FoundationRollingChecksum,
  FoundationScenarioCounter
} from '../foundation/FoundationAdvancedFixtures';
import { assertArrayLength, assertAtLeast, assertContains, assertNumberEqual, assertTrue } from '../foundation/TestAsserts';
import { StartupPerformanceHarness } from './PerformanceSceneHarness';

export default function startupLatencyMatrixTest(): void {
  describe('StartupLatencyMatrixTest', () => {
    it('StartupLatency_AveragesRemainWithinExpectedBands_001', 0, () => {
      const harness = new StartupPerformanceHarness();
      for (let index = 0; index < 20; index++) {
        harness.recordStart(120 + index);
        harness.recordStop(80 + index);
        harness.recordFocus(30 + index);
      }
      assertAtLeast(harness.getAverageStart(), 120);
      assertAtLeast(harness.getAverageStop(), 80);
      assertAtLeast(harness.getAverageFocus(), 30);
    });

    it('StartupLatency_ProfileBucketCrossProductProducesEnoughSamples_002', 0, () => {
      const profiles = buildFoundationCompatibilityProfiles();
      const buckets = buildFoundationCanaryBuckets();
      const counter = new FoundationScenarioCounter();
      const harness = new StartupPerformanceHarness();
      for (let profileIndex = 0; profileIndex < profiles.length; profileIndex++) {
        for (let bucketIndex = 0; bucketIndex < buckets.length; bucketIndex++) {
          harness.recordStart(100 + profileIndex * 10 + bucketIndex);
          harness.recordStop(70 + profileIndex * 8 + bucketIndex);
          counter.record(`${profiles[profileIndex]}_${buckets[bucketIndex]}`);
        }
      }
      assertNumberEqual(counter.getDistinctCount(), profiles.length * buckets.length);
      assertArrayLength(harness.getStartDurations(), profiles.length * buckets.length);
    });

    it('StartupLatency_DualPassFingerprintRemainsStable_003', 0, () => {
      const checksumA = new FoundationRollingChecksum();
      const checksumB = new FoundationRollingChecksum();
      for (let pass = 0; pass < 2; pass++) {
        const harness = new StartupPerformanceHarness();
        for (let round = 0; round < 24; round++) {
          harness.recordStart(140 + round);
          harness.recordStop(90 + round);
          harness.recordFocus(40 + round);
        }
        const summary = harness.getStartDurations().join(',') + '|' + harness.getStopDurations().join(',') + '|' + harness.getFocusDurations().join(',');
        if (pass === 0) {
          checksumA.appendText(summary);
        } else {
          checksumB.appendText(summary);
        }
      }
      assertNumberEqual(checksumA.getValue(), checksumB.getValue());
    });

    it('StartupLatency_LongRunSamplingBuildsSufficientTelemetry_004', 0, () => {
      const harness = new StartupPerformanceHarness();
      for (let round = 0; round < 160; round++) {
        harness.recordStart(100 + (round % 25));
        harness.recordStop(70 + (round % 20));
        harness.recordFocus(25 + (round % 15));
      }
      assertAtLeast(harness.getStartDurations().length, 160);
      assertAtLeast(harness.getStopDurations().length, 160);
      assertAtLeast(harness.getFocusDurations().length, 160);
    });

    it('StartupLatency_SampleTrailContainsExpectedBands_005', 0, () => {
      const harness = new StartupPerformanceHarness();
      for (let round = 0; round < 12; round++) {
        harness.recordStart(150 + round);
      }
      const summary = harness.getStartDurations().join(',');
      assertContains(summary, '150');
      assertContains(summary, '161');
      assertTrue(harness.getAverageStart() > 0);
    });

    it('StartupLatency_FocusDistributionNeverDropsToZero_006', 0, () => {
      const harness = new StartupPerformanceHarness();
      for (let round = 0; round < 60; round++) {
        harness.recordFocus(35 + (round % 8));
      }
      assertAtLeast(harness.getAverageFocus(), 35);
      assertTrue(harness.getFocusDurations()[0] > 0);
    });
  });
}
