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
  buildFoundationCanaryBuckets,
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
import { UIRecentHarness } from './UISceneHarness';

export default function uiRecentTaskCompositeTest(): void {
  describe('UIRecentTaskCompositeTest', () => {
    it('UIRecent_AddOpenDeleteMaintainsReadableList_001', 0, () => {
      const harness = new UIRecentHarness();
      const firstId = harness.addRecent('movie_a.mp4', 'finished');
      harness.addRecent('movie_b.mp4', 'finished');
      assertTrue(harness.removeRecent(firstId));
      const items = harness.getRecents();
      assertArrayLength(items, 1);
      assertStringEqual(items[0].title, 'movie_b.mp4');
    });

    it('UIRecent_ClearRemovesAllTasks_002', 0, () => {
      const harness = new UIRecentHarness();
      for (let round = 0; round < 5; round++) {
        harness.addRecent(`clip_${round}.mp4`, 'finished');
      }
      harness.clear();
      assertArrayLength(harness.getRecents(), 0);
    });

    it('UIRecent_StatusSwitchAndPersistenceKeepProjectionReadable_003', 0, () => {
      const harness = new UIRecentHarness();
      const storage = new FoundationStorageEntity();
      harness.addRecent('alpha.mp4', 'finished');
      harness.addRecent('beta.mp4', 'uploading');
      harness.switchStatus('recording', '08:15', 'ethernet');
      harness.persist(storage);
      assertContains(storage.get<string>('recent.0.title') ?? '', 'alpha');
      assertContains(storage.get<string>('recent.1.state') ?? '', 'uploading');
      assertStringEqual(storage.get<string>('status.network') ?? '', 'ethernet');
    });

    it('UIRecent_CanaryBucketsDistributeAcrossRecentInsertions_004', 0, () => {
      const buckets = buildFoundationCanaryBuckets();
      const harness = new UIRecentHarness();
      const counter = new FoundationScenarioCounter();
      for (let index = 0; index < buckets.length; index++) {
        for (let round = 0; round < index + 3; round++) {
          harness.addRecent(`bucket_${buckets[index]}_${round}.mp4`, 'finished');
          counter.record(`${buckets[index]}`);
        }
      }
      assertNumberEqual(counter.getDistinctCount(), buckets.length);
      assertAtLeast(counter.getTotalCount(), 33);
      assertAtLeast(harness.getRecents().length, 33);
    });

    it('UIRecent_RemovingMissingTaskReturnsFalseButLogsAction_005', 0, () => {
      const harness = new UIRecentHarness();
      const result = harness.removeRecent('missing-id');
      assertTrue(result === false);
      assertArrayLength(harness.getActions(), 1);
      assertStringEqual(harness.getActions()[0].type, 'recent-remove');
    });

    it('UIRecent_LongRunStatusMixKeepsEventFingerprintStable_006', 0, () => {
      const checksumA = new FoundationRollingChecksum();
      const checksumB = new FoundationRollingChecksum();
      for (let pass = 0; pass < 2; pass++) {
        const harness = new UIRecentHarness();
        for (let round = 0; round < 15; round++) {
          harness.addRecent(`long_${round}.mp4`, round % 2 === 0 ? 'finished' : 'failed');
          harness.switchStatus(round % 2 === 0 ? 'recording' : 'idle', `09:${round}`, round % 3 === 0 ? 'wifi' : 'ethernet');
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

    it('UIRecent_MassCreateDeleteLeavesExpectedRemainingTail_007', 0, () => {
      const harness = new UIRecentHarness();
      const ids: string[] = [];
      for (let round = 0; round < 18; round++) {
        ids.push(harness.addRecent(`tail_${round}.mp4`, 'finished'));
      }
      harness.removeRecent(ids[2]);
      harness.removeRecent(ids[9]);
      harness.removeRecent(ids[16]);
      const items = harness.getRecents();
      assertArrayLength(items, 15);
      assertContains(items[2].title, 'tail_3');
      assertContains(items[8].title, 'tail_10');
    });

    it('UIRecent_AssetPoolSupportsLargeRecentProjection_008', 0, () => {
      const harness = new UIRecentHarness();
      const names = buildFoundationAssetNames('recent_pool', 48);
      for (let index = 0; index < names.length; index++) {
        harness.addRecent(names[index], index % 2 === 0 ? 'finished' : 'queued');
      }
      assertArrayLength(harness.getRecents(), 48);
      assertContains(harness.getRecents()[47].title, 'recent_pool_047');
    });

    it('UIRecent_ClearAfterPersistenceKeepsStatusSnapshot_009', 0, () => {
      const harness = new UIRecentHarness();
      const storage = new FoundationStorageEntity();
      harness.addRecent('clear_a.mp4', 'finished');
      harness.switchStatus('recording', '10:10', 'wifi');
      harness.persist(storage);
      harness.clear();
      assertArrayLength(harness.getRecents(), 0);
      assertStringEqual(storage.get<string>('status.icon') ?? '', 'recording');
    });

    it('UIRecent_BurstScenarioGeneratesEnoughActions_010', 0, () => {
      const harness = new UIRecentHarness();
      let operations = 0;
      for (let round = 0; round < 120; round++) {
        const id = harness.addRecent(`burst_${round}.mp4`, round % 2 === 0 ? 'finished' : 'failed');
        if (round % 4 === 0) {
          harness.removeRecent(id);
        }
        if (round % 6 === 0) {
          harness.switchStatus('recording', `11:${round}`, 'ethernet');
        }
        operations += 1
      }
      assertNumberEqual(operations, 120);
      assertAtLeast(harness.getActions().length, 150);
    });
  });
}
