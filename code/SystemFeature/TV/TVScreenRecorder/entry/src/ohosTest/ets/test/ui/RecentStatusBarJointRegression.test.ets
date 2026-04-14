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
  buildFoundationAssetNames,
  FoundationRollingChecksum,
  FoundationScenarioCounter,
  FoundationStorageEntity
} from '../foundation/FoundationAdvancedFixtures';
import {
  assertArrayLength,
  assertAtLeast,
  assertContains,
  assertNumberEqual,
  assertStringEqual,
  assertTrue
} from '../foundation/TestAsserts';
import { RecentStatusJointHarness } from './AccessibilityLayoutHarness';

export default function recentStatusBarJointRegressionTest(): void {
  describe('RecentStatusBarJointRegressionTest', () => {
    it('RecentStatus_OpenRecentSyncsStatusProjection_001', 0, () => {
      const harness = new RecentStatusJointHarness();
      harness.openRecent('video_a.mp4', 'recording');
      harness.syncStatus('recording', '00:10', 'wifi');
      assertArrayLength(harness.getRecents(), 1);
      assertStringEqual(harness.getStatus().icon, 'recording');
      assertStringEqual(harness.getStatus().timer, '00:10');
    });

    it('RecentStatus_RemoveExistingRecentLeavesAuditTrail_002', 0, () => {
      const harness = new RecentStatusJointHarness();
      const id = harness.openRecent('video_b.mp4', 'stopped');
      assertTrue(harness.removeRecent(id));
      assertArrayLength(harness.getRecents(), 0);
      assertContains(harness.getActions().join(','), 'remove:');
    });

    it('RecentStatus_PersistAndRecoverReplaysJointKeys_003', 0, () => {
      const harness = new RecentStatusJointHarness();
      const storage = new FoundationStorageEntity();
      harness.openRecent('video_c.mp4', 'recording');
      harness.openRecent('video_d.mp4', 'stopped');
      harness.syncStatus('recording', '00:20', 'ethernet');
      harness.persist(storage);
      assertAtLeast(harness.recover(storage), 7);
    });

    it('RecentStatus_AssetReplayBuildsStableSnapshotFingerprint_004', 0, () => {
      const names = buildFoundationAssetNames('joint', 24);
      const checksumA = new FoundationRollingChecksum();
      const checksumB = new FoundationRollingChecksum();
      for (let pass = 0; pass < 2; pass++) {
        const harness = new RecentStatusJointHarness();
        const storage = new FoundationStorageEntity();
        for (let index = 0; index < names.length; index++) {
          harness.openRecent(names[index], index % 2 === 0 ? 'recording' : 'stopped');
        }
        harness.syncStatus('recording', '01:00', 'wifi');
        harness.persist(storage);
        const summary = storage.getKeys().join('|');
        if (pass === 0) {
          checksumA.appendText(summary);
        } else {
          checksumB.appendText(summary);
        }
      }
      assertNumberEqual(checksumA.getValue(), checksumB.getValue());
    });

    it('RecentStatus_LongRunMixedReplayMaintainsDistinctStates_005', 0, () => {
      const harness = new RecentStatusJointHarness();
      const counter = new FoundationScenarioCounter();
      for (let round = 0; round < 100; round++) {
        harness.openRecent(`video_${round}.mp4`, round % 2 === 0 ? 'recording' : 'stopped');
        counter.record(round % 2 === 0 ? 'recording' : 'stopped');
      }
      assertNumberEqual(counter.getDistinctCount(), 2);
      assertAtLeast(harness.getRecents().length, 100);
    });

    it('RecentStatus_StatusTrailContainsIconTimerAndNetwork_006', 0, () => {
      const harness = new RecentStatusJointHarness();
      harness.syncStatus('recording', '00:03', 'wifi');
      const summary = harness.getActions().join(',');
      assertContains(summary, 'status:recording:00:03:wifi');
    });
  });
}
