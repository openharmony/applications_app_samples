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
import { assertArrayLength, assertAtLeast, assertContains, assertNumberEqual, assertTrue } from '../foundation/TestAsserts';
import { buildConcurrencyRounds, buildFailureCodes } from '../foundation/TestDataBuilder';

interface StepRecord {
  action: string
  code: number
}

class RecordingOrchestrationHarness {
  private taskStarted: boolean = false
  private records: StepRecord[] = []
  private startReturnCode: number = 0
  private stopReturnCode: number = 0

  setStartReturnCode(code: number): void {
    this.startReturnCode = code
  }

  setStopReturnCode(code: number): void {
    this.stopReturnCode = code
  }

  executeStart(): number {
    if (this.taskStarted) {
      this.records.push({ action: 'start', code: -1000 })
      return -1000
    }
    const result = this.startReturnCode
    if (result === 0) {
      this.taskStarted = true
    }
    this.records.push({ action: 'start', code: result })
    return result
  }

  executeStop(): number {
    if (!this.taskStarted) {
      this.records.push({ action: 'stop', code: -1001 })
      return -1001
    }
    const result = this.stopReturnCode
    if (result === 0) {
      this.taskStarted = false
    }
    this.records.push({ action: 'stop', code: result })
    return result
  }

  reset(): void {
    this.taskStarted = false
    this.records = []
    this.startReturnCode = 0
    this.stopReturnCode = 0
  }

  getRecords(): StepRecord[] {
    return this.records.slice()
  }

  isTaskStarted(): boolean {
    return this.taskStarted
  }
}

export default function recordingOrchestrationTest(): void {
  describe('RecordingOrchestrationTest', () => {
    it('Orchestration_BasicStartStop_001', 0, () => {
      const harness = new RecordingOrchestrationHarness();
      assertNumberEqual(harness.executeStart(), 0);
      assertTrue(harness.isTaskStarted());
      assertNumberEqual(harness.executeStop(), 0);
      assertTrue(harness.isTaskStarted() === false);
      const records = harness.getRecords();
      assertArrayLength(records, 2);
    });

    it('Orchestration_RepeatedStartBlock_002', 0, () => {
      const harness = new RecordingOrchestrationHarness();
      assertNumberEqual(harness.executeStart(), 0);
      assertNumberEqual(harness.executeStart(), -1000);
      const records = harness.getRecords();
      assertArrayLength(records, 2);
      assertNumberEqual(records[1].code, -1000);
    });

    it('Orchestration_StopBeforeStart_003', 0, () => {
      const harness = new RecordingOrchestrationHarness();
      const code = harness.executeStop();
      assertNumberEqual(code, -1001);
    });

    it('Orchestration_StartFailurePolicy_004', 0, () => {
      const harness = new RecordingOrchestrationHarness();
      const failureCodes = buildFailureCodes();
      let failCount = 0;
      for (let i = 0; i < failureCodes.length; i++) {
        harness.reset();
        harness.setStartReturnCode(failureCodes[i]);
        const code = harness.executeStart();
        assertNumberEqual(code, failureCodes[i]);
        assertTrue(harness.isTaskStarted() === false);
        failCount += 1;
      }
      assertNumberEqual(failCount, failureCodes.length);
    });

    it('Orchestration_StopFailurePolicy_005', 0, () => {
      const harness = new RecordingOrchestrationHarness();
      const failureCodes = buildFailureCodes();
      let failCount = 0;
      for (let i = 0; i < failureCodes.length; i++) {
        harness.reset();
        harness.executeStart();
        harness.setStopReturnCode(failureCodes[i]);
        const code = harness.executeStop();
        assertNumberEqual(code, failureCodes[i]);
        assertTrue(harness.isTaskStarted());
        failCount += 1;
      }
      assertNumberEqual(failCount, failureCodes.length);
    });

    it('Orchestration_ConcurrencyRounds_006', 0, () => {
      const harness = new RecordingOrchestrationHarness();
      const rounds = buildConcurrencyRounds();
      assertArrayLength(rounds, 40);
      let success = 0;
      for (let i = 0; i < rounds.length; i++) {
        if (harness.executeStart() === 0) {
          success += 1;
        }
        if (harness.executeStop() === 0) {
          success += 1;
        }
      }
      assertNumberEqual(success, 80);
      const records = harness.getRecords();
      assertArrayLength(records, 80);
    });

    it('Orchestration_ChaosAlternation_007', 0, () => {
      const harness = new RecordingOrchestrationHarness();
      let passCount = 0;
      for (let i = 0; i < 100; i++) {
        harness.reset();
        harness.setStartReturnCode(i % 5 === 0 ? -300 : 0);
        const startCode = harness.executeStart();
        if (startCode !== 0) {
          passCount += 1;
          continue;
        }
        harness.setStopReturnCode(i % 7 === 0 ? -400 : 0);
        const stopCode = harness.executeStop();
        if (stopCode === 0 || stopCode === -400) {
          passCount += 1;
        }
      }
      assertNumberEqual(passCount, 100);
    });

    it('Orchestration_RecordContent_008', 0, () => {
      const harness = new RecordingOrchestrationHarness();
      harness.executeStart();
      harness.executeStop();
      harness.executeStop();
      const records = harness.getRecords();
      assertAtLeast(records.length, 3);
      assertContains(records[0].action, 'start');
      assertContains(records[1].action, 'stop');
      assertTrue(records[2].code < 0);
    });

    it('Orchestration_LongRun_009', 0, () => {
      const harness = new RecordingOrchestrationHarness();
      let rounds = 0;
      for (let i = 0; i < 180; i++) {
        const startCode = harness.executeStart();
        if (startCode === 0) {
          const stopCode = harness.executeStop();
          assertNumberEqual(stopCode, 0);
        } else {
          assertNumberEqual(startCode, -1000);
          harness.executeStop();
        }
        rounds += 1;
      }
      assertNumberEqual(rounds, 180);
      const records = harness.getRecords();
      assertAtLeast(records.length, 180);
    });
  });
}
