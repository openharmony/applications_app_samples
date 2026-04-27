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
  buildFoundationDurations,
  FoundationRollingChecksum,
  FoundationScenarioCounter
} from '../foundation/FoundationAdvancedFixtures';
import { buildRotationMatrix } from '../foundation/TestDataBuilder';
import { assertAtLeast, assertContains, assertNumberEqual, assertTrue } from '../foundation/TestAsserts';
import { LongRunMixHarness, ResolutionRotationHarness, StartupPerformanceHarness } from './PerformanceSceneHarness';

export default function performanceCanaryAndExtremeSweepTest(): void {
  describe('PerformanceCanaryAndExtremeSweepTest', () => {
    it('PerformanceSweep_ProfileBucketLatencyAndRotationCrossProduct_001', 0, () => {
      const profiles = buildFoundationCompatibilityProfiles();
      const buckets = buildFoundationCanaryBuckets();
      const rotations = buildRotationMatrix();
      const latency = new StartupPerformanceHarness();
      const resolution = new ResolutionRotationHarness();
      let total = 0;
      for (let profileIndex = 0; profileIndex < profiles.length; profileIndex++) {
        for (let bucketIndex = 0; bucketIndex < buckets.length; bucketIndex++) {
          for (let rotationIndex = 0; rotationIndex < rotations.length; rotationIndex++) {
            latency.recordStart(100 + profileIndex + bucketIndex + rotationIndex);
            latency.recordStop(80 + profileIndex + bucketIndex + rotationIndex);
            resolution.apply(1920 + bucketIndex * 20, 1080 + profileIndex * 10, rotations[rotationIndex]);
            total += 1
          }
        }
      }
      assertNumberEqual(total, profiles.length * buckets.length * rotations.length);
      assertAtLeast(latency.getStartDurations().length, total);
      assertAtLeast(resolution.getRecords().length, total);
    });

    it('PerformanceSweep_DurationReplayBuildsStableMixedFingerprint_002', 0, () => {
      const durations = buildFoundationDurations();
      const checksumA = new FoundationRollingChecksum();
      const checksumB = new FoundationRollingChecksum();
      for (let pass = 0; pass < 2; pass++) {
        const harness = new LongRunMixHarness();
        for (let index = 0; index < durations.length; index++) {
          harness.push('start', durations[index] + 100);
          harness.push('focus', durations[index] + 20);
          harness.push('stop', durations[index] + 80);
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

    it('PerformanceSweep_ExtremeMatrixProducesDistinctCoverageCounters_003', 0, () => {
      const profiles = buildFoundationCompatibilityProfiles();
      const rotations = buildRotationMatrix();
      const counter = new FoundationScenarioCounter();
      for (let profileIndex = 0; profileIndex < profiles.length; profileIndex++) {
        for (let rotationIndex = 0; rotationIndex < rotations.length; rotationIndex++) {
          counter.record(`${profiles[profileIndex]}_${rotations[rotationIndex]}`);
        }
      }
      assertNumberEqual(counter.getDistinctCount(), profiles.length * rotations.length);
      assertAtLeast(counter.getTotalCount(), profiles.length * rotations.length);
    });

    it('PerformanceSweep_LongRunTelemetryContainsMultipleOperationKinds_004', 0, () => {
      const harness = new LongRunMixHarness();
      for (let round = 0; round < 200; round++) {
        harness.push('start', 100 + (round % 12));
        harness.push('focus', 28 + (round % 9));
        if (round % 2 === 0) {
          harness.push('stop', 78 + (round % 11));
        }
      }
      const summary = harness.getRecords().map((record) => record.type).join(',');
      assertContains(summary, 'start');
      assertContains(summary, 'focus');
      assertContains(summary, 'stop');
      assertTrue(harness.getMaxDuration() > 0);
    });

    it('PerformanceSweep_8KAnd4KMixedReplayKeepsUnsupportedVisible_005', 0, () => {
      const harness = new ResolutionRotationHarness();
      harness.apply(3840, 2160, 0);
      harness.apply(7680, 4320, 90);
      harness.apply(7680, 4320, 180);
      assertNumberEqual(harness.getUnsupportedCount(), 2);
      const summary = harness.getRecords().map((record) => `${record.width}x${record.height}:${record.code}`).join(',');
      assertContains(summary, '3840x2160:0');
      assertContains(summary, '7680x4320:-1');
    });
  });
}
