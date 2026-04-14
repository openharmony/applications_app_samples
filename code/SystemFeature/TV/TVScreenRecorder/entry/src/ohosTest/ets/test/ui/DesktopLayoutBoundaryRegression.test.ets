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
  FoundationRollingChecksum,
  FoundationScenarioCounter
} from '../foundation/FoundationAdvancedFixtures';
import { buildResolutionMatrix, buildRotationMatrix } from '../foundation/TestDataBuilder';
import {
  assertAtLeast,
  assertContains,
  assertNumberEqual,
  assertTrue
} from '../foundation/TestAsserts';
import { DesktopLayoutHarness } from './AccessibilityLayoutHarness';

export default function desktopLayoutBoundaryRegressionTest(): void {
  describe('DesktopLayoutBoundaryRegressionTest', () => {
    it('DesktopLayout_ResolutionRotationCrossProductRemainsRenderable_001', 0, () => {
      const harness = new DesktopLayoutHarness();
      const resolutions = buildResolutionMatrix();
      const rotations = buildRotationMatrix();
      let total = 0;
      for (let resIndex = 0; resIndex < resolutions.length; resIndex++) {
        for (let rotIndex = 0; rotIndex < rotations.length; rotIndex++) {
          harness.render('pages/ScreenRecorderTimer', resolutions[resIndex].width, resolutions[resIndex].height, rotations[rotIndex]);
          total += 1
        }
      }
      assertNumberEqual(total, resolutions.length * rotations.length);
      assertAtLeast(harness.getRenders().length, total);
    });

    it('DesktopLayout_MinimumSizeOverflowIsVisible_002', 0, () => {
      const harness = new DesktopLayoutHarness();
      assertNumberEqual(harness.render('pages/ScreenRecorderDialog', 80, 50, 0), -1);
      assertNumberEqual(harness.getOverflowCount(), 1);
    });

    it('DesktopLayout_CanaryBucketReplayKeepsDistinctRenderSamples_003', 0, () => {
      const harness = new DesktopLayoutHarness();
      const buckets = buildFoundationCanaryBuckets();
      const counter = new FoundationScenarioCounter();
      for (let index = 0; index < buckets.length; index++) {
        const width = 1280 + buckets[index];
        const height = 720 + buckets[index];
        harness.render('pages/ScreenRecorderTimer', width, height, 0);
        counter.record(`${width}x${height}`);
      }
      assertNumberEqual(counter.getDistinctCount(), buckets.length);
      assertAtLeast(harness.getMaxArea(), 1281 * 721);
    });

    it('DesktopLayout_DualPassRenderFingerprintRemainsStable_004', 0, () => {
      const checksumA = new FoundationRollingChecksum();
      const checksumB = new FoundationRollingChecksum();
      for (let pass = 0; pass < 2; pass++) {
        const harness = new DesktopLayoutHarness();
        for (let round = 0; round < 32; round++) {
          harness.render('pages/ScreenRecorderDialog', 640 + round * 10, 360 + round * 5, round % 4 * 90);
        }
        const summary = harness.getRenders().map((item) => `${item.width}x${item.height}@${item.rotation}:${item.code}`).join('|');
        if (pass === 0) {
          checksumA.appendText(summary);
        } else {
          checksumB.appendText(summary);
        }
      }
      assertNumberEqual(checksumA.getValue(), checksumB.getValue());
    });

    it('DesktopLayout_8KOverflowAndStandardLayoutBothAppear_005', 0, () => {
      const harness = new DesktopLayoutHarness();
      harness.render('pages/ScreenRecorderTimer', 1920, 1080, 0);
      harness.render('pages/ScreenRecorderTimer', 9000, 6000, 90);
      const summary = harness.getRenders().map((item) => `${item.width}x${item.height}:${item.code}`).join(',');
      assertContains(summary, '1920x1080:0');
      assertContains(summary, '9000x6000:-1');
      assertTrue(harness.getOverflowCount() > 0);
    });
  });
}
