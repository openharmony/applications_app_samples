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
  buildFoundationGrayReleaseKeys,
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
import { PersistentIsolationHarness, SchemaContractHarness } from './ContractSecurityHarness';

export default function coldStartPollutionIsolationTest(): void {
  describe('ColdStartPollutionIsolationTest', () => {
    it('ColdStart_RecentNamespaceDoesNotLeakIntoStatusNamespace_001', 0, () => {
      const harness = new PersistentIsolationHarness();
      harness.write('recent', '0', 'alpha.mp4');
      harness.write('status', 'timer', '00:30');
      const statusKeys = harness.coldStart('status');
      assertArrayLength(statusKeys, 1);
      assertContains(statusKeys[0], 'status.timer');
    });

    it('ColdStart_ClearBeforeRestartEliminatesStaleRecentKeys_002', 0, () => {
      const harness = new PersistentIsolationHarness();
      harness.write('recent', '0', 'stale.mp4');
      harness.clearNamespace('recent');
      assertArrayLength(harness.coldStart('recent'), 0);
      assertStringEqual(harness.getValue('recent.0'), '');
    });

    it('ColdStart_GrayReleaseKeysCanBeRehydratedWithoutPollution_003', 0, () => {
      const harness = new PersistentIsolationHarness();
      const contract = new SchemaContractHarness();
      const keys = buildFoundationGrayReleaseKeys();
      for (let index = 0; index < keys.length; index++) {
        harness.write('gray', keys[index], `bucket_${index}`);
        contract.setState(keys[index], `bucket_${index}`);
      }
      assertAtLeast(harness.coldStart('gray').length, keys.length);
      assertNumberEqual(contract.requireKeys(keys), 0);
    });

    it('ColdStart_AssetReplayBuildsStableRecoveryFingerprint_004', 0, () => {
      const names = buildFoundationAssetNames('cold', 26);
      const checksumA = new FoundationRollingChecksum();
      const checksumB = new FoundationRollingChecksum();
      for (let pass = 0; pass < 2; pass++) {
        const harness = new PersistentIsolationHarness();
        for (let index = 0; index < names.length; index++) {
          harness.write(index % 2 === 0 ? 'recent' : 'status', `${index}`, names[index]);
        }
        const summary = harness.coldStart('recent').join('|') + '|' + harness.coldStart('status').join('|');
        if (pass === 0) {
          checksumA.appendText(summary);
        } else {
          checksumB.appendText(summary);
        }
      }
      assertNumberEqual(checksumA.getValue(), checksumB.getValue());
    });

    it('ColdStart_LongRunNamespaceReplayMaintainsDistinctCounters_005', 0, () => {
      const harness = new PersistentIsolationHarness();
      const counter = new FoundationScenarioCounter();
      for (let round = 0; round < 140; round++) {
        const namespace = round % 3 === 0 ? 'recent' : round % 3 === 1 ? 'status' : 'gray';
        harness.write(namespace, `${round}`, `value_${round}`);
        counter.record(namespace);
      }
      assertNumberEqual(counter.getDistinctCount(), 3);
      assertAtLeast(counter.getTotalCount(), 140);
    });

    it('ColdStart_ClearSingleNamespaceKeepsOthersIntact_006', 0, () => {
      const harness = new PersistentIsolationHarness();
      harness.write('recent', '0', 'movie.mp4');
      harness.write('status', 'icon', 'recording');
      harness.write('gray', 'bucket', '10');
      harness.clearNamespace('status');
      assertContains(harness.getStorage().getKeys().join(','), 'recent.0');
      assertContains(harness.getStorage().getKeys().join(','), 'gray.bucket');
      assertTrue(harness.getStorage().getKeys().join(',').indexOf('status.icon') < 0);
    });
  });
}
