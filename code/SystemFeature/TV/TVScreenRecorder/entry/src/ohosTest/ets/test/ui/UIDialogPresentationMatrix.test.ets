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
  assertArrayLength,
  assertAtLeast,
  assertContains,
  assertNumberEqual,
  assertStringEqual,
  assertTrue
} from '../foundation/TestAsserts';
import { DialogPresentationHarness } from '../service/ServiceSceneHarness';

export default function uiDialogPresentationMatrixTest(): void {
  describe('UIDialogPresentationMatrixTest', () => {
    it('UIDialog_ShowAndHideSingleDialog_001', 0, () => {
      const harness = new DialogPresentationHarness();
      harness.show('record-saved');
      assertTrue(harness.hide('record-saved'));
      assertArrayLength(harness.getDialogs(), 0);
    });

    it('UIDialog_HideMissingDialogReturnsFalse_002', 0, () => {
      const harness = new DialogPresentationHarness();
      assertTrue(harness.hide('missing') === false);
      assertStringEqual(harness.getRecords()[0].detail, 'missing');
    });

    it('UIDialog_ProfileBucketMatrixMaintainsReadableDialogCount_003', 0, () => {
      const profiles = buildFoundationCompatibilityProfiles();
      const buckets = buildFoundationCanaryBuckets();
      const counter = new FoundationScenarioCounter();
      const harness = new DialogPresentationHarness();
      for (let profileIndex = 0; profileIndex < profiles.length; profileIndex++) {
        for (let bucketIndex = 0; bucketIndex < buckets.length; bucketIndex++) {
          const name = `${profiles[profileIndex]}_${buckets[bucketIndex]}`;
          harness.show(name);
          counter.record(name);
        }
      }
      assertNumberEqual(counter.getDistinctCount(), profiles.length * buckets.length);
      assertAtLeast(harness.getDialogs().length, profiles.length * buckets.length);
    });

    it('UIDialog_DurationSliceReplayGeneratesStableFingerprint_004', 0, () => {
      const durations = buildFoundationDurations();
      const checksumA = new FoundationRollingChecksum();
      const checksumB = new FoundationRollingChecksum();
      for (let pass = 0; pass < 2; pass++) {
        const harness = new DialogPresentationHarness();
        for (let index = 0; index < durations.length; index++) {
          harness.show(`duration_${durations[index]}`);
          if (index % 2 === 0) {
            harness.hide(`duration_${durations[index]}`);
          }
        }
        const summary = harness.getRecords().map((record) => `${record.type}_${record.detail}_${record.code}`).join('|');
        if (pass === 0) {
          checksumA.appendText(summary);
        } else {
          checksumB.appendText(summary);
        }
      }
      assertNumberEqual(checksumA.getValue(), checksumB.getValue());
    });

    it('UIDialog_ClearRemovesAllDialogs_005', 0, () => {
      const harness = new DialogPresentationHarness();
      for (let round = 0; round < 10; round++) {
        harness.show(`dialog_${round}`);
      }
      harness.clear();
      assertArrayLength(harness.getDialogs(), 0);
      assertStringEqual(harness.getRecords()[10].type, 'clear');
    });

    it('UIDialog_MixedShowHideFlowLeavesExpectedResidue_006', 0, () => {
      const harness = new DialogPresentationHarness();
      for (let round = 0; round < 20; round++) {
        harness.show(`dialog_${round}`);
        if (round % 3 === 0) {
          harness.hide(`dialog_${round}`);
        }
      }
      assertAtLeast(harness.getDialogs().length, 13);
      assertContains(harness.getDialogs().join(','), 'dialog_19');
    });

    it('UIDialog_BurstPresentationProducesEnoughTelemetry_007', 0, () => {
      const harness = new DialogPresentationHarness();
      for (let round = 0; round < 120; round++) {
        harness.show(`burst_${round}`);
        if (round % 5 === 0) {
          harness.hide(`burst_${round}`);
        }
      }
      assertAtLeast(harness.getRecords().length, 144);
      assertAtLeast(harness.getDialogs().length, 90);
    });

    it('UIDialog_ActionTrailContainsShowHideMarkers_008', 0, () => {
      const harness = new DialogPresentationHarness();
      harness.show('resolution');
      harness.hide('resolution');
      const summary = harness.getRecords().map((record) => `${record.type}:${record.detail}`).join(',');
      assertContains(summary, 'show:resolution');
      assertContains(summary, 'hide:resolution');
    });

    it('UIDialog_DialogOrderRemainsReadableAfterPartialHide_009', 0, () => {
      const harness = new DialogPresentationHarness();
      harness.show('a');
      harness.show('b');
      harness.show('c');
      harness.hide('b');
      assertArrayLength(harness.getDialogs(), 2);
      assertStringEqual(harness.getDialogs()[0], 'a');
      assertStringEqual(harness.getDialogs()[1], 'c');
    });
  });
}
