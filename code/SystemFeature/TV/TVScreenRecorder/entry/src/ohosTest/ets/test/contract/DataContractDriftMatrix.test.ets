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
  assertStringEqual
} from '../foundation/TestAsserts';
import { GrayReleaseHarness, PersistentIsolationHarness, SchemaContractHarness } from './ContractSecurityHarness';

export default function dataContractDriftMatrixTest(): void {
  describe('DataContractDriftMatrixTest', () => {
    it('ContractDrift_ProfileBucketDurationCrossProductRemainsAddressable_001', 0, () => {
      const profiles = buildFoundationCompatibilityProfiles();
      const buckets = buildFoundationCanaryBuckets();
      const durations = buildFoundationDurations();
      const contract = new SchemaContractHarness();
      let total = 0;
      for (let profileIndex = 0; profileIndex < profiles.length; profileIndex++) {
        for (let bucketIndex = 0; bucketIndex < buckets.length; bucketIndex++) {
          const key = `${profiles[profileIndex]}.${buckets[bucketIndex]}`;
          contract.setState(key, `${durations[(profileIndex + bucketIndex) % durations.length]}`);
          total += 1
        }
      }
      assertNumberEqual(total, profiles.length * buckets.length);
      assertAtLeast(contract.getRecords().length, total);
    });

    it('ContractDrift_PersistedBucketsCanBeRecheckedAfterColdStart_002', 0, () => {
      const release = new GrayReleaseHarness();
      const persist = new PersistentIsolationHarness();
      for (let index = 0; index < 20; index++) {
        release.assign(`user_${index}`, `${index % 5}`);
        persist.write('gray', `user_${index}`, release.getBucket(`user_${index}`));
      }
      const keys = persist.coldStart('gray');
      assertAtLeast(keys.length, 20);
      assertContains(keys.join(','), 'gray.user_0');
    });

    it('ContractDrift_DualPassPersistedSnapshotFingerprintRemainsStable_003', 0, () => {
      const checksumA = new FoundationRollingChecksum();
      const checksumB = new FoundationRollingChecksum();
      for (let pass = 0; pass < 2; pass++) {
        const persist = new PersistentIsolationHarness();
        for (let index = 0; index < 30; index++) {
          persist.write(index % 2 === 0 ? 'recent' : 'status', `${index}`, `value_${index}`);
        }
        const summary = persist.getStorage().getKeys().join('|');
        if (pass === 0) {
          checksumA.appendText(summary);
        } else {
          checksumB.appendText(summary);
        }
      }
      assertNumberEqual(checksumA.getValue(), checksumB.getValue());
    });

    it('ContractDrift_ProfileCounterKeepsFullCoverage_004', 0, () => {
      const profiles = buildFoundationCompatibilityProfiles();
      const counter = new FoundationScenarioCounter();
      for (let index = 0; index < profiles.length * 10; index++) {
        counter.record(profiles[index % profiles.length]);
      }
      assertNumberEqual(counter.getDistinctCount(), profiles.length);
      assertAtLeast(counter.getTotalCount(), profiles.length * 10);
      assertStringEqual(counter.getMostFrequentName(), profiles[0]);
    });
  });
}
