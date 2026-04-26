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
  buildFoundationFaultPatterns,
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
import { AbilityRequestHarness } from './ServiceSceneHarness';

export default function abilityCommandFlowTest(): void {
  describe('AbilityCommandFlowTest', () => {
    it('AbilityCommand_RequestStartThenStopTransitionsCleanly_001', 0, () => {
      const harness = new AbilityRequestHarness();
      assertNumberEqual(harness.request(1), 0);
      assertTrue(harness.isRecording());
      assertNumberEqual(harness.request(2), 0);
      assertTrue(harness.isRecording() === false);
      assertNumberEqual(harness.getTerminateCount(), 1);
    });

    it('AbilityCommand_RepeatedStartIsBlocked_002', 0, () => {
      const harness = new AbilityRequestHarness();
      assertNumberEqual(harness.start(), 0);
      assertNumberEqual(harness.start(), -1000);
      assertArrayLength(harness.getRecords(), 2);
      assertStringEqual(harness.getRecords()[1].detail, 'blocked');
    });

    it('AbilityCommand_StopWhenIdleReturnsGuardCode_003', 0, () => {
      const harness = new AbilityRequestHarness();
      assertNumberEqual(harness.stop(), -1001);
      assertTrue(harness.isRecording() === false);
    });

    it('AbilityCommand_ErrorSchedulingTerminatesOnFlush_004', 0, () => {
      const harness = new AbilityRequestHarness();
      harness.scheduleErrorTermination();
      harness.flushError();
      assertNumberEqual(harness.getTerminateCount(), 1);
      assertStringEqual(harness.getRecords()[1].detail, 'terminate');
    });

    it('AbilityCommand_FaultPatternReplayKeepsTerminationCountReadable_005', 0, () => {
      const patterns = buildFoundationFaultPatterns();
      const counter = new FoundationScenarioCounter();
      for (let index = 0; index < patterns.length; index++) {
        const harness = new AbilityRequestHarness();
        if (patterns[index].startReturnCode === 0) {
          harness.start();
        }
        if (patterns[index].expectedState !== 0) {
          harness.scheduleErrorTermination();
          harness.flushError();
        }
        counter.record(`${harness.getTerminateCount()}`);
      }
      assertAtLeast(counter.getTotalCount(), patterns.length);
      assertAtLeast(counter.getDistinctCount(), 1);
    });

    it('AbilityCommand_CanaryRequestMatrixProducesEnoughSessions_006', 0, () => {
      const buckets = buildFoundationCanaryBuckets();
      const harness = new AbilityRequestHarness();
      let success = 0;
      for (let index = 0; index < buckets.length; index++) {
        for (let round = 0; round < index + 3; round++) {
          if (harness.start() === 0) {
            success += 1
          }
          harness.stop();
        }
      }
      assertAtLeast(success, 30);
      assertAtLeast(harness.getTerminateCount(), 30);
    });

    it('AbilityCommand_DualPassRequestFingerprintRemainsStable_007', 0, () => {
      const checksumA = new FoundationRollingChecksum();
      const checksumB = new FoundationRollingChecksum();
      for (let pass = 0; pass < 2; pass++) {
        const harness = new AbilityRequestHarness();
        for (let round = 0; round < 20; round++) {
          if (round % 4 === 0) {
            harness.scheduleErrorTermination();
            harness.flushError();
          } else if (round % 2 === 0) {
            harness.request(1);
          } else {
            harness.request(2);
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

    it('AbilityCommand_LongRunningMixGeneratesEnoughActions_008', 0, () => {
      const harness = new AbilityRequestHarness();
      for (let round = 0; round < 120; round++) {
        if (round % 6 === 0) {
          harness.scheduleErrorTermination();
          harness.flushError();
        } else if (round % 2 === 0) {
          harness.start();
        } else {
          harness.stop();
        }
      }
      assertAtLeast(harness.getRecords().length, 120);
      assertAtLeast(harness.getTerminateCount(), 20);
    });

    it('AbilityCommand_ActionTrailContainsStartStopAndErrorMarkers_009', 0, () => {
      const harness = new AbilityRequestHarness();
      harness.start();
      harness.stop();
      harness.scheduleErrorTermination();
      harness.flushError();
      const summary = harness.getRecords().map((record) => `${record.type}:${record.detail}`).join(',');
      assertContains(summary, 'start:recording');
      assertContains(summary, 'stop:terminate');
      assertContains(summary, 'error:terminate');
    });
  });
}
