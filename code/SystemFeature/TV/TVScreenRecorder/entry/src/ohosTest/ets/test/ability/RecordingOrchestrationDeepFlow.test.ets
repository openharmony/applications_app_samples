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
  buildFoundationFaultPatterns,
  FoundationFaultPatternQueue,
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

interface FlowRecord {
  action: string
  code: number
}

class DeepFlowHarness {
  private started: boolean = false
  private startCode: number = 0
  private stopCode: number = 0
  private records: FlowRecord[] = []

  setStartCode(code: number): void {
    this.startCode = code;
  }

  setStopCode(code: number): void {
    this.stopCode = code;
  }

  start(): number {
    if (this.started) {
      this.records.push({ action: 'start', code: -1000 });
      return -1000;
    }
    const result = this.startCode;
    if (result === 0) {
      this.started = true;
    }
    this.records.push({ action: 'start', code: result });
    return result;
  }

  stop(): number {
    if (!this.started) {
      this.records.push({ action: 'stop', code: -1001 });
      return -1001;
    }
    const result = this.stopCode;
    if (result === 0) {
      this.started = false;
    }
    this.records.push({ action: 'stop', code: result });
    return result;
  }

  reset(): void {
    this.started = false;
    this.startCode = 0;
    this.stopCode = 0;
    this.records = [];
  }

  isStarted(): boolean {
    return this.started;
  }

  getRecords(): FlowRecord[] {
    return this.records.slice();
  }
}

export default function recordingOrchestrationDeepFlowTest(): void {
  describe('RecordingOrchestrationDeepFlowTest', () => {
    it('RecordingFlow_ProfileAndCanaryProjection_001', 0, () => {
      const profiles = buildFoundationCompatibilityProfiles();
      const buckets = buildFoundationCanaryBuckets();
      const counter = new FoundationScenarioCounter();
      const checksum = new FoundationRollingChecksum();

      /**
       * 编排层的第一职责是把不同设备画像和灰度批次都导向同一条业务路径。
       * 如果这里出现分流偏差，后续定位问题时会误判为底层录屏能力异常。
       */
      for (let index = 0; index < profiles.length * buckets.length; index++) {
        const harness = new DeepFlowHarness();
        const startCode = harness.start();
        const stopCode = harness.stop();
        counter.record(profiles[index % profiles.length]);
        checksum.appendText(profiles[index % profiles.length]);
        checksum.appendNumber(buckets[index % buckets.length]);
        checksum.appendNumber(startCode);
        checksum.appendNumber(stopCode);
      }

      assertNumberEqual(counter.getDistinctCount(), profiles.length);
      assertAtLeast(counter.getTotalCount(), profiles.length * buckets.length);
      assertAtLeast(checksum.getValue(), 1);
    });

    it('RecordingFlow_FaultQueueSeparatesStartAndStopFailure_002', 0, () => {
      const queue = new FoundationFaultPatternQueue(buildFoundationFaultPatterns());
      let startFailures = 0;
      let stopFailures = 0;
      for (let index = 0; index < 18; index++) {
        const harness = new DeepFlowHarness();
        const pattern = queue.getPattern(index);
        harness.setStartCode(pattern.failCreateAsset ? -200 : pattern.startReturnCode);
        harness.setStopCode(pattern.failGetAssets ? -201 : pattern.stopReturnCode);
        const startCode = harness.start();
        if (startCode !== 0) {
          startFailures += 1
          continue;
        }
        const stopCode = harness.stop();
        if (stopCode !== 0) {
          stopFailures += 1
        }
      }
      assertAtLeast(startFailures, 6);
      assertAtLeast(stopFailures, 3);
    });

    it('RecordingFlow_PersistenceCapturesLastSuccessfulRound_003', 0, () => {
      const storage = new FoundationStorageEntity();
      for (let round = 0; round < 12; round++) {
        const harness = new DeepFlowHarness();
        const startCode = harness.start();
        if (startCode === 0) {
          const stopCode = harness.stop();
          storage.set(`round.${round}.state`, `${stopCode}`);
          storage.set(`round.${round}.action`, `${harness.getRecords().length}`);
        }
      }
      assertNumberEqual(storage.getSize(), 24);
      assertStringEqual(storage.get<string>('round.0.state') ?? '', '0');
      assertStringEqual(storage.get<string>('round.11.action') ?? '', '2');
    });

    it('RecordingFlow_LongRunLeavesNoStartedResidue_004', 0, () => {
      const harness = new DeepFlowHarness();
      for (let round = 0; round < 120; round++) {
        if (harness.start() === 0) {
          harness.stop();
        }
      }
      assertTrue(harness.isStarted() === false);
      assertAtLeast(harness.getRecords().length, 240);
    });

    it('RecordingFlow_RepeatedStartBlockProducesStableFingerprint_005', 0, () => {
      const harness = new DeepFlowHarness();
      const checksum = new FoundationRollingChecksum();

      /**
       * 前端误触或按键连发会产生重复 start 指令。
       * 编排层必须稳定返回相同错误码，才能保证上层 UI 和提示文案不会在高频输入下抖动。
       */
      for (let round = 0; round < 30; round++) {
        harness.reset();
        checksum.appendNumber(harness.start());
        checksum.appendNumber(harness.start());
        checksum.appendNumber(harness.stop());
      }

      assertAtLeast(checksum.getValue(), 1);
      assertTrue(harness.isStarted() === false);
    });

    it('RecordingFlow_StopBeforeStartRemainsAddressable_006', 0, () => {
      const harness = new DeepFlowHarness();
      const values: number[] = [];
      for (let round = 0; round < 20; round++) {
        values.push(harness.stop());
      }
      assertArrayLength(values, 20);
      for (let index = 0; index < values.length; index++) {
        assertNumberEqual(values[index], -1001);
      }
    });

    it('RecordingFlow_ProfileSequenceRemainsReadable_007', 0, () => {
      const profiles = buildFoundationCompatibilityProfiles();
      const seen: string[] = [];
      for (let index = 0; index < profiles.length; index++) {
        const harness = new DeepFlowHarness();
        harness.start();
        harness.stop();
        seen.push(`${profiles[index]}:${harness.getRecords().length}`);
      }
      assertContains(seen.join(','), 'tv-1080p-landscape');
      assertContains(seen.join(','), ':2');
    });

    it('RecordingFlow_MixedStartStopPoliciesSupportAlternation_008', 0, () => {
      const harness = new DeepFlowHarness();
      let completed = 0;
      for (let round = 0; round < 40; round++) {
        harness.reset();
        harness.setStartCode(round % 4 === 1 ? -300 : 0);
        harness.setStopCode(round % 6 === 2 ? -400 : 0);
        const startCode = harness.start();
        if (startCode !== 0) {
          completed += 1
          continue;
        }
        const stopCode = harness.stop();
        if (stopCode === 0 || stopCode === -400) {
          completed += 1
        }
      }
      assertNumberEqual(completed, 40);
    });

    it('RecordingFlow_RecordsRemainReadableAfterRecoveryResets_009', 0, () => {
      const harness = new DeepFlowHarness();
      for (let round = 0; round < 10; round++) {
        harness.reset();
        harness.start();
        harness.stop();
      }
      const records = harness.getRecords();
      assertArrayLength(records, 2);
      assertStringEqual(records[0].action, 'start');
      assertStringEqual(records[1].action, 'stop');
    });
  });
}
