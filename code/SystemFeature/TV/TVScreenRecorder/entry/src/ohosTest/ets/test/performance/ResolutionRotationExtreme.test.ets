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
import { buildResolutionMatrix, buildRotationMatrix } from '../foundation/TestDataBuilder';
import {
  buildFoundationCanaryBuckets,
  FoundationRollingChecksum,
  FoundationScenarioCounter
} from '../foundation/FoundationAdvancedFixtures';
import { assertArrayLength, assertAtLeast, assertContains, assertNumberEqual, assertTrue } from '../foundation/TestAsserts';
import { ResolutionRotationHarness } from './PerformanceSceneHarness';

export default function resolutionRotationExtremeTest(): void {
  describe('ResolutionRotationExtremeTest', () => {
    it('ResolutionExtreme_FourAnglesCoverAllBaselineResolutions_001', 0, () => {
      const harness = new ResolutionRotationHarness();
      const resolutions = buildResolutionMatrix();
      const rotations = buildRotationMatrix();
      let total = 0;
      for (let rotationIndex = 0; rotationIndex < rotations.length; rotationIndex++) {
        for (let resolutionIndex = 0; resolutionIndex < resolutions.length; resolutionIndex++) {
          const code = harness.apply(resolutions[resolutionIndex].width, resolutions[resolutionIndex].height, rotations[rotationIndex]);
          assertNumberEqual(code, 0);
          total += 1
        }
      }
      assertNumberEqual(total, 16);
      assertArrayLength(harness.getRecords(), 16);
    });

    it('ResolutionExtreme_Unsupported8KSurfacesAreCounted_002', 0, () => {
      const harness = new ResolutionRotationHarness();
      assertNumberEqual(harness.apply(7680, 4320, 0), -1);
      assertNumberEqual(harness.apply(7680, 4320, 90), -1);
      assertNumberEqual(harness.getUnsupportedCount(), 2);
    });

    it('ResolutionExtreme_BucketReplayKeepsReadableCoverage_003', 0, () => {
      const harness = new ResolutionRotationHarness();
      const buckets = buildFoundationCanaryBuckets();
      const rotations = buildRotationMatrix();
      const counter = new FoundationScenarioCounter();
      for (let bucketIndex = 0; bucketIndex < buckets.length; bucketIndex++) {
        for (let rotationIndex = 0; rotationIndex < rotations.length; rotationIndex++) {
          harness.apply(1920 + bucketIndex * 10, 1080 + bucketIndex * 5, rotations[rotationIndex]);
          counter.record(`${buckets[bucketIndex]}_${rotations[rotationIndex]}`);
        }
      }
      assertNumberEqual(counter.getDistinctCount(), buckets.length * rotations.length);
      assertAtLeast(harness.getRecords().length, 24);
    });

    it('ResolutionExtreme_DualPassFingerprintRemainsStable_004', 0, () => {
      const checksumA = new FoundationRollingChecksum();
      const checksumB = new FoundationRollingChecksum();
      const rotations = buildRotationMatrix();
      for (let pass = 0; pass < 2; pass++) {
        const harness = new ResolutionRotationHarness();
        for (let round = 0; round < 20; round++) {
          const rotation = rotations[round % rotations.length];
          harness.apply(1280 + round * 10, 720 + round * 5, rotation);
        }
        const summary = harness.getRecords().map((record) => `${record.width}_${record.height}_${record.rotation}_${record.code}`).join('|');
        if (pass === 0) {
          checksumA.appendText(summary);
        } else {
          checksumB.appendText(summary);
        }
      }
      assertNumberEqual(checksumA.getValue(), checksumB.getValue());
    });

    it('ResolutionExtreme_LongRunMatrixProducesEnoughTelemetry_005', 0, () => {
      const harness = new ResolutionRotationHarness();
      const rotations = buildRotationMatrix();
      for (let round = 0; round < 140; round++) {
        harness.apply(1000 + round * 8, 600 + round * 4, rotations[round % rotations.length]);
      }
      assertAtLeast(harness.getRecords().length, 140);
      assertTrue(harness.getUnsupportedCount() >= 0);
    });

    it('ResolutionExtreme_RecordTrailContainsAngleMarkers_006', 0, () => {
      const harness = new ResolutionRotationHarness();
      harness.apply(1920, 1080, 0);
      harness.apply(1920, 1080, 270);
      const summary = harness.getRecords().map((record) => `${record.width}x${record.height}@${record.rotation}`).join(',');
      assertContains(summary, '@0');
      assertContains(summary, '@270');
    });
  });
}
