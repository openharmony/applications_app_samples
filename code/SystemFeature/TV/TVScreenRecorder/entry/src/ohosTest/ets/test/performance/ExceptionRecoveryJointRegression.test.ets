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
  buildFoundationFaultPatterns,
  FoundationRollingChecksum,
  FoundationScenarioCounter
} from '../foundation/FoundationAdvancedFixtures';
import { assertArrayLength, assertAtLeast, assertContains, assertNumberEqual, assertStringEqual, assertTrue } from '../foundation/TestAsserts';
import { RecoveryPressureHarness } from './PerformanceSceneHarness';

export default function exceptionRecoveryJointRegressionTest(): void {
  describe('ExceptionRecoveryJointRegressionTest', () => {
    it('RecoveryJoint_StartFailureCanRecoverToIdle_001', 0, () => {
      const harness = new RecoveryPressureHarness();
      assertNumberEqual(harness.start('broken_start.mp4', -1), -1);
      assertStringEqual(harness.getState(), 'error');
      harness.recover();
      assertStringEqual(harness.getState(), 'idle');
      assertNumberEqual(harness.getRecoveryCount(), 1);
    });

    it('RecoveryJoint_StopFailureDoesNotCreateRecentResidue_002', 0, () => {
      const harness = new RecoveryPressureHarness();
      assertNumberEqual(harness.start('stop_fail.mp4', 0), 0);
      assertNumberEqual(harness.stop('stop_fail.mp4', -2), -2);
      assertArrayLength(harness.getRecent(), 0);
      assertStringEqual(harness.getState(), 'error');
    });

    it('RecoveryJoint_FaultPatternReplayBuildsRecoveryTelemetry_003', 0, () => {
      const harness = new RecoveryPressureHarness();
      const patterns = buildFoundationFaultPatterns();
      const counter = new FoundationScenarioCounter();
      for (let index = 0; index < patterns.length; index++) {
        const title = `pattern_${patterns[index].name}.mp4`;
        if (harness.start(title, patterns[index].startReturnCode) !== 0) {
          harness.recover();
          counter.record('start-fail');
          continue;
        }
        if (harness.stop(title, patterns[index].stopReturnCode) !== 0) {
          harness.recover();
          counter.record('stop-fail');
        } else {
          counter.record('green');
        }
      }
      assertAtLeast(counter.getDistinctCount(), 2);
      assertAtLeast(harness.getRecoveryCount(), 2);
    });

    it('RecoveryJoint_DualPassRecentFingerprintRemainsStable_004', 0, () => {
      const names = buildFoundationAssetNames('recover', 18);
      const checksumA = new FoundationRollingChecksum();
      const checksumB = new FoundationRollingChecksum();
      for (let pass = 0; pass < 2; pass++) {
        const harness = new RecoveryPressureHarness();
        for (let index = 0; index < names.length; index++) {
          if (index % 5 === 0) {
            harness.start(names[index], -1);
            harness.recover();
          } else {
            harness.start(names[index], 0);
            harness.stop(names[index], 0);
          }
        }
        const summary = harness.getRecent().join('|') + '|' + harness.getFailureCount().toString() + '|' + harness.getRecoveryCount().toString();
        if (pass === 0) {
          checksumA.appendText(summary);
        } else {
          checksumB.appendText(summary);
        }
      }
      assertNumberEqual(checksumA.getValue(), checksumB.getValue());
    });

    it('RecoveryJoint_LongRunRecoveryDoesNotPolluteGreenRecent_005', 0, () => {
      const harness = new RecoveryPressureHarness();
      for (let round = 0; round < 120; round++) {
        const title = `long_${round}.mp4`;
        if (round % 6 === 0) {
          harness.start(title, -1);
          harness.recover();
        } else {
          harness.start(title, 0);
          harness.stop(title, 0);
        }
      }
      assertAtLeast(harness.getRecent().length, 90);
      assertAtLeast(harness.getFailureCount(), 20);
    });

    it('RecoveryJoint_StorageTrailContainsRecoveryMarkers_006', 0, () => {
      const harness = new RecoveryPressureHarness();
      harness.start('trace.mp4', -1);
      harness.recover();
      const keys = harness.getStorage().getKeys().join(',');
      assertContains(keys, 'recovery.lastError');
      assertContains(keys, 'recovery.lastAction');
      assertStringEqual(harness.getStorage().get<string>('recovery.lastAction') ?? '', 'recover');
    });

    it('RecoveryJoint_ClearRecentAfterRecoveryLeavesIdleState_007', 0, () => {
      const harness = new RecoveryPressureHarness();
      harness.start('saved.mp4', 0);
      harness.stop('saved.mp4', 0);
      harness.start('fault.mp4', -1);
      harness.recover();
      harness.clearRecent();
      assertArrayLength(harness.getRecent(), 0);
      assertStringEqual(harness.getState(), 'idle');
      assertTrue(harness.getRecoveryCount() >= 1);
    });
  });
}
