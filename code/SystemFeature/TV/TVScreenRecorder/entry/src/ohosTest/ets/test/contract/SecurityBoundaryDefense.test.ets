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
  assertNotContains,
  assertNumberEqual,
  assertTrue
} from '../foundation/TestAsserts';
import { InputSanitizerHarness } from './ContractSecurityHarness';

export default function securityBoundaryDefenseTest(): void {
  describe('SecurityBoundaryDefenseTest', () => {
    it('SecurityBoundary_NewlineAndTagPayloadAreSanitized_001', 0, () => {
      const harness = new InputSanitizerHarness();
      const value = harness.sanitize('record\n<script>alert(1)</script>');
      assertNotContains(value, '\n');
      assertNotContains(value, '<');
      assertNotContains(value, '>');
    });

    it('SecurityBoundary_PathTraversalIsRejected_002', 0, () => {
      const harness = new InputSanitizerHarness();
      assertNumberEqual(harness.rejectDangerous('../secret/file'), -1);
      assertNumberEqual(harness.rejectDangerous('safe_file.mp4'), 0);
    });

    it('SecurityBoundary_CommandLikePayloadIsRejected_003', 0, () => {
      const harness = new InputSanitizerHarness();
      assertNumberEqual(harness.rejectDangerous('rm -rf /tmp'), -1);
      assertNumberEqual(harness.rejectDangerous('drop table records'), -1);
      assertNumberEqual(harness.rejectDangerous('record_save'), 0);
    });

    it('SecurityBoundary_AssetPoolSanitizationBuildsStableFingerprint_004', 0, () => {
      const harness = new InputSanitizerHarness();
      const names = buildFoundationAssetNames('unsafe name ', 24);
      const checksumA = new FoundationRollingChecksum();
      const checksumB = new FoundationRollingChecksum();
      for (let index = 0; index < names.length; index++) {
        checksumA.appendText(harness.sanitize(names[index]));
      }
      for (let index = 0; index < names.length; index++) {
        checksumB.appendText(harness.sanitize(names[index]));
      }
      assertNumberEqual(checksumA.getValue(), checksumB.getValue());
    });

    it('SecurityBoundary_BulkDangerousPayloadReplayCountsDistinctModes_005', 0, () => {
      const harness = new InputSanitizerHarness();
      const payloads = ['../trace', 'rm user', 'drop table demo', 'safe_value', 'normal-title'];
      const counter = new FoundationScenarioCounter();
      for (let round = 0; round < 20; round++) {
        const code = harness.rejectDangerous(payloads[round % payloads.length]);
        counter.record(code === 0 ? 'safe' : 'blocked');
      }
      assertNumberEqual(counter.getDistinctCount(), 2);
      assertAtLeast(counter.getTotalCount(), 20);
    });

    it('SecurityBoundary_LongInputIsTrimmedToSafeLength_006', 0, () => {
      const harness = new InputSanitizerHarness();
      const longValue = 'abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_more_payload';
      const sanitized = harness.sanitize(longValue);
      assertTrue(sanitized.length <= 64);
      assertContains(sanitized, 'abcdefghijklmnopqrstuvwxyz');
    });

    it('SecurityBoundary_EventTrailKeepsSanitizeAndDangerRecords_007', 0, () => {
      const harness = new InputSanitizerHarness();
      harness.sanitize(' ok ');
      harness.rejectDangerous('../bad');
      const records = harness.getRecords();
      assertArrayLength(records, 2);
      assertStringRecord(records[0].type, 'sanitize');
      assertStringRecord(records[1].type, 'danger');
    });
  });
}

function assertStringRecord(actual: string, expected: string): void {
  assertTrue(actual === expected);
}
