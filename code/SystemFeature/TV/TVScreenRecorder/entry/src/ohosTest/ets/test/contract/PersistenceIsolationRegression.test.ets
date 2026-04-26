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
import { PersistentIsolationHarness } from './ContractSecurityHarness';

export default function persistenceIsolationRegressionTest(): void {
  describe('PersistenceIsolationRegressionTest', () => {
    it('PersistenceIsolation_NamespaceClearDoesNotTouchOthers_001', 0, () => {
      const harness = new PersistentIsolationHarness();
      harness.write('recent', '0', 'video_a.mp4');
      harness.write('status', 'icon', 'recording');
      harness.clearNamespace('recent');
      assertStringEqual(harness.getValue('status.icon'), 'recording');
      assertStringEqual(harness.getValue('recent.0'), '');
    });

    it('PersistenceIsolation_ColdStartOnlyLoadsTargetNamespace_002', 0, () => {
      const harness = new PersistentIsolationHarness();
      harness.write('recent', '0', 'video_a.mp4');
      harness.write('recent', '1', 'video_b.mp4');
      harness.write('status', 'timer', '00:20');
      const keys = harness.coldStart('recent');
      assertArrayLength(keys, 2);
      assertContains(keys.join(','), 'recent.0');
      assertContains(keys.join(','), 'recent.1');
    });

    it('PersistenceIsolation_AssetPoolReplayBuildsStableFingerprint_003', 0, () => {
      const names = buildFoundationAssetNames('persist', 30);
      const checksumA = new FoundationRollingChecksum();
      const checksumB = new FoundationRollingChecksum();
      for (let pass = 0; pass < 2; pass++) {
        const harness = new PersistentIsolationHarness();
        for (let index = 0; index < names.length; index++) {
          harness.write('recent', `${index}`, names[index]);
        }
        const summary = harness.coldStart('recent').join('|');
        if (pass === 0) {
          checksumA.appendText(summary);
        } else {
          checksumB.appendText(summary);
        }
      }
      assertNumberEqual(checksumA.getValue(), checksumB.getValue());
    });

    it('PersistenceIsolation_LongRunMixedWritesBuildDistinctCounters_004', 0, () => {
      const harness = new PersistentIsolationHarness();
      const counter = new FoundationScenarioCounter();
      for (let round = 0; round < 120; round++) {
        const namespace = round % 2 === 0 ? 'recent' : 'status';
        harness.write(namespace, `${round}`, `value_${round}`);
        counter.record(namespace);
      }
      assertNumberEqual(counter.getDistinctCount(), 2);
      assertAtLeast(harness.getStorage().getSize(), 120);
    });

    it('PersistenceIsolation_ClearNamespaceLeavesReadableRecordTrail_005', 0, () => {
      const harness = new PersistentIsolationHarness();
      harness.write('gray', 'bucket', '10');
      harness.write('gray', 'key', 'foundation.mock.photo');
      harness.clearNamespace('gray');
      const records = harness.getRecords();
      assertAtLeast(records.length, 3);
      assertStringEqual(records[2].type, 'clear');
    });

    it('PersistenceIsolation_ColdStartAfterClearReturnsNoPollutedKeys_006', 0, () => {
      const harness = new PersistentIsolationHarness();
      harness.write('recent', '0', 'movie.mp4');
      harness.clearNamespace('recent');
      assertArrayLength(harness.coldStart('recent'), 0);
      assertTrue(harness.getStorage().getSize() === 0);
    });

    it('PersistenceIsolation_MultipleNamespacesRemainQueryable_007', 0, () => {
      const harness = new PersistentIsolationHarness();
      harness.write('recent', '0', 'movie_a.mp4');
      harness.write('status', 'network', 'wifi');
      harness.write('gray', 'bucket', 'gray-10%');
      assertContains(harness.getStorage().getKeys().join(','), 'recent.0');
      assertContains(harness.getStorage().getKeys().join(','), 'status.network');
      assertContains(harness.getStorage().getKeys().join(','), 'gray.bucket');
    });
  });
}
