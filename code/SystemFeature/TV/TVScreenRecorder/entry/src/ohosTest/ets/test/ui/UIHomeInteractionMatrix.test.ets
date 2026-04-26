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
import {
  assertAtLeast,
  assertContains,
  assertNumberEqual,
  assertStringEqual,
  assertTrue
} from '../foundation/TestAsserts';
import { UIHomeInteractionHarness } from './UISceneHarness';

export default function uiHomeInteractionMatrixTest(): void {
  describe('UIHomeInteractionMatrixTest', () => {
    it('UIHome_ProfileBucketStartStopMatrix_001', 0, () => {
      const profiles = buildFoundationCompatibilityProfiles();
      const buckets = buildFoundationCanaryBuckets();
      const counter = new FoundationScenarioCounter();
      for (let profileIndex = 0; profileIndex < profiles.length; profileIndex++) {
        for (let bucketIndex = 0; bucketIndex < buckets.length; bucketIndex++) {
          const harness = new UIHomeInteractionHarness();
          assertNumberEqual(harness.start(), 0);
          assertNumberEqual(harness.stop(), 0);
          counter.record(`${profiles[profileIndex]}_${buckets[bucketIndex]}`);
        }
      }
      assertNumberEqual(counter.getDistinctCount(), profiles.length * buckets.length);
      assertAtLeast(counter.getTotalCount(), profiles.length * buckets.length);
    });

    it('UIHome_DurationSlicesKeepStatusConsistent_002', 0, () => {
      const durations = buildFoundationDurations();
      const checksum = new FoundationRollingChecksum();
      for (let index = 0; index < durations.length; index++) {
        const harness = new UIHomeInteractionHarness();
        harness.start();
        if (durations[index] % 2 === 0) {
          harness.switchNetwork('wifi');
        } else {
          harness.switchNetwork('ethernet');
        }
        checksum.appendText(harness.getStatus().icon);
        checksum.appendText(harness.getStatus().network);
      }
      assertAtLeast(checksum.getValue(), 1);
    });

    it('UIHome_RepeatedResolutionWarningsDoNotBlockFutureStart_003', 0, () => {
      const harness = new UIHomeInteractionHarness();
      for (let round = 0; round < 12; round++) {
        harness.showResolutionNotSupported();
      }
      assertStringEqual(harness.getLastToast(), 'resolution-not-supported');
      assertNumberEqual(harness.start(), 0);
      assertTrue(harness.isStarted());
    });

    it('UIHome_DualPassActionFingerprintRemainsStable_004', 0, () => {
      const checksumA = new FoundationRollingChecksum();
      const checksumB = new FoundationRollingChecksum();
      for (let pass = 0; pass < 2; pass++) {
        const harness = new UIHomeInteractionHarness();
        for (let round = 0; round < 16; round++) {
          if (round % 5 === 0) {
            harness.showResolutionNotSupported();
          } else if (round % 2 === 0) {
            harness.start();
          } else {
            harness.stop();
          }
          harness.switchNetwork(round % 3 === 0 ? 'wifi' : 'ethernet');
        }
        const summary = harness.getActions().map((action) => `${action.type}_${action.target}_${action.code}`).join('|');
        if (pass === 0) {
          checksumA.appendText(summary);
        } else {
          checksumB.appendText(summary);
        }
      }
      assertNumberEqual(checksumA.getValue(), checksumB.getValue());
    });

    it('UIHome_LongRunningMixedActionsProduceEnoughTelemetry_005', 0, () => {
      const harness = new UIHomeInteractionHarness();
      let operations = 0;
      for (let round = 0; round < 100; round++) {
        if (round % 7 === 0) {
          harness.showResolutionNotSupported();
        } else if (round % 2 === 0) {
          harness.start();
        } else {
          harness.stop();
        }
        harness.switchNetwork(round % 4 === 0 ? 'wifi' : 'ethernet');
        operations += 1
      }
      assertNumberEqual(operations, 100);
      assertAtLeast(harness.getActions().length, 180);
    });

    it('UIHome_ActionTrailContainsDialogAndNetworkMarkers_006', 0, () => {
      const harness = new UIHomeInteractionHarness();
      harness.showResolutionNotSupported();
      harness.switchNetwork('ethernet');
      harness.start();
      const trail = harness.getActions().map((action) => `${action.type}:${action.target}`).join(',');
      assertContains(trail, 'dialog:resolution');
      assertContains(trail, 'network:ethernet');
      assertContains(trail, 'start:record');
    });
  });
}
