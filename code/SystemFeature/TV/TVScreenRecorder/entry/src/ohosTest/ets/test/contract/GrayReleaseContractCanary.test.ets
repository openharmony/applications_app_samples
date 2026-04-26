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
  buildFoundationGrayReleaseKeys,
  FoundationRollingChecksum,
  FoundationScenarioCounter
} from '../foundation/FoundationAdvancedFixtures';
import {
  assertArrayLength,
  assertAtLeast,
  assertContains,
  assertNumberEqual,
  assertStringEqual
} from '../foundation/TestAsserts';
import { GrayReleaseHarness, SchemaContractHarness } from './ContractSecurityHarness';

export default function grayReleaseContractCanaryTest(): void {
  describe('GrayReleaseContractCanaryTest', () => {
    it('GrayRelease_UserAssignmentsRemainReadable_001', 0, () => {
      const harness = new GrayReleaseHarness();
      harness.assign('user_a', 'gray-1%');
      harness.assign('user_b', 'gray-10%');
      assertStringEqual(harness.getBucket('user_a'), 'gray-1%');
      assertStringEqual(harness.getBucket('user_b'), 'gray-10%');
    });

    it('GrayRelease_BucketAndProfileCrossProductBuildsEnoughCoverage_002', 0, () => {
      const buckets = buildFoundationCanaryBuckets();
      const profiles = buildFoundationCompatibilityProfiles();
      const harness = new GrayReleaseHarness();
      const counter = new FoundationScenarioCounter();
      let userIndex = 0;
      for (let bucketIndex = 0; bucketIndex < buckets.length; bucketIndex++) {
        for (let profileIndex = 0; profileIndex < profiles.length; profileIndex++) {
          const userId = `user_${userIndex++}`;
          harness.assign(userId, buckets[bucketIndex].toString());
          counter.record(`${buckets[bucketIndex]}_${profiles[profileIndex]}`);
        }
      }
      assertNumberEqual(counter.getDistinctCount(), buckets.length * profiles.length);
      assertAtLeast(harness.getRecords().length, buckets.length * profiles.length);
    });

    it('GrayRelease_PublishKeysCanBeProjectedIntoSchema_003', 0, () => {
      const release = new GrayReleaseHarness();
      const contract = new SchemaContractHarness();
      const keys = buildFoundationGrayReleaseKeys();
      for (let index = 0; index < keys.length; index++) {
        release.publish(keys[index], `bucket_${index}`);
        contract.setState(keys[index], `bucket_${index}`);
      }
      assertNumberEqual(contract.requireKeys(keys), 0);
      assertContains(release.getRecords().map((record) => record.key).join(','), 'foundation.mock.photo');
    });

    it('GrayRelease_DualPassAssignmentFingerprintRemainsStable_004', 0, () => {
      const checksumA = new FoundationRollingChecksum();
      const checksumB = new FoundationRollingChecksum();
      const buckets = buildFoundationCanaryBuckets();
      for (let pass = 0; pass < 2; pass++) {
        const harness = new GrayReleaseHarness();
        for (let index = 0; index < 40; index++) {
          harness.assign(`user_${index}`, buckets[index % buckets.length].toString());
        }
        const summary = harness.snapshot();
        if (pass === 0) {
          checksumA.appendText(summary);
        } else {
          checksumB.appendText(summary);
        }
      }
      assertNumberEqual(checksumA.getValue(), checksumB.getValue());
    });

    it('GrayRelease_UnknownUserFallsBackToUnknownBucket_005', 0, () => {
      const harness = new GrayReleaseHarness();
      assertStringEqual(harness.getBucket('missing_user'), 'unknown');
      assertArrayLength(harness.getRecords(), 0);
    });

    it('GrayRelease_LongRunPublishAndAssignBuildsTelemetry_006', 0, () => {
      const harness = new GrayReleaseHarness();
      const keys = buildFoundationGrayReleaseKeys();
      for (let round = 0; round < 90; round++) {
        harness.assign(`user_${round}`, `${round % 5}`);
        harness.publish(keys[round % keys.length], `${round % 5}`);
      }
      assertAtLeast(harness.getRecords().length, 180);
      assertContains(harness.snapshot(), 'user_0');
    });
  });
}
