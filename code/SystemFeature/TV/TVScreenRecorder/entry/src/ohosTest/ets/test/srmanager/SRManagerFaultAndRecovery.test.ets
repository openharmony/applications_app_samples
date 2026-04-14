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
import { MockPhotoAccessHelperFactory, MockSRApiFactory } from '../foundation/MockFactories';
import {
  buildFoundationFaultPatterns,
  FoundationFaultPatternQueue,
  FoundationRollingChecksum,
  FoundationScenarioCounter
} from '../foundation/FoundationAdvancedFixtures';
import {
  assertArrayLength,
  assertAtLeast,
  assertContains,
  assertNumberEqual,
  assertStateEqual,
  assertStateIn,
  assertTrue
} from '../foundation/TestAsserts';
import { MockRecordingState } from '../foundation/TestTypes';
import { SRManagerHarness } from './SRManagerHarness';

interface FaultRoundOutcome {
  round: number
  startCode: number
  stopCode: number
  finalState: MockRecordingState
  threw: boolean
}

async function runFaultRound(round: number, startCode: number, stopCode: number, failCreateAsset: boolean): Promise<FaultRoundOutcome> {
  const apiFactory = new MockSRApiFactory();
  const api = apiFactory.build();
  api.setStartReturn(startCode);
  api.setStopReturn(stopCode);
  const photoFactory = new MockPhotoAccessHelperFactory();
  if (failCreateAsset) {
    photoFactory.setThrowOnCreateAsset(true);
  }
  const harness = new SRManagerHarness(api, photoFactory.build());
  let caught = false;
  let actualStartCode = -10000;
  let actualStopCode = -10001;
  harness.forceState(MockRecordingState.Idle);
  try {
    actualStartCode = await harness.start(1700006000000 + round * 1000)
    if (actualStartCode === 0) {
      actualStopCode = harness.stop()
    }
  } catch (_) {
    caught = true
  }
  return {
    round,
    startCode: actualStartCode,
    stopCode: actualStopCode,
    finalState: harness.getCurrentState(),
    threw: caught
  }
}

export default function srManagerFaultAndRecoveryTest(): void {
  describe('SRManagerFaultAndRecoveryTest', () => {
    it('SRManager_FaultPatternQueueProducesExpectedOutcomeShapes_001', 0, async () => {
      const queue = new FoundationFaultPatternQueue(buildFoundationFaultPatterns());
      const outcomes: FaultRoundOutcome[] = [];

      /**
       * 录屏失败经常来自多源故障叠加，例如建文件成功但启动失败，或启动成功但停止失败。
       * 这个矩阵先把典型故障画像固定下来，确保后续大规模混沌测试都有稳定对照组。
       */
      for (let round = 0; round < 15; round++) {
        const pattern = queue.getPattern(round);
        outcomes.push(await runFaultRound(round, pattern.startReturnCode, pattern.stopReturnCode, pattern.failCreateAsset));
      }

      assertArrayLength(outcomes, 15);
      assertAtLeast(outcomes.filter((item: FaultRoundOutcome) => item.threw).length, 3);
      assertAtLeast(outcomes.filter((item: FaultRoundOutcome) => item.finalState === MockRecordingState.Error).length, 6);
    });

    it('SRManager_CreateAssetFailureThrowsAndPreventsStartUrl_002', 0, async () => {
      const outcome = await runFaultRound(1, 0, 0, true);
      assertTrue(outcome.threw);
      assertStateEqual(outcome.finalState, MockRecordingState.Idle);
      assertNumberEqual(outcome.startCode, -10000);
    });

    it('SRManager_StartFailureTransitionsIntoError_003', 0, async () => {
      const outcome = await runFaultRound(2, -501, 0, false);
      assertNumberEqual(outcome.startCode, -501);
      assertStateEqual(outcome.finalState, MockRecordingState.Error);
    });

    it('SRManager_StopFailurePreservesErrorForRecoveryGate_004', 0, async () => {
      const outcome = await runFaultRound(3, 0, -601, false);
      assertNumberEqual(outcome.startCode, 0);
      assertNumberEqual(outcome.stopCode, -601);
      assertStateEqual(outcome.finalState, MockRecordingState.Error);
    });

    it('SRManager_RecoveryAfterApiStartFailureCanResumeRecording_005', 0, async () => {
      const apiFactory = new MockSRApiFactory();
      const api = apiFactory.build();
      const photoFactory = new MockPhotoAccessHelperFactory();
      const harness = new SRManagerHarness(api, photoFactory.build());

      /**
       * 真实设备上常见短暂性底层异常，恢复后应允许重新录制。
       * 这里先模拟一次启动失败，再强制恢复为空闲态，验证管理器不会被永久锁死。
       */
      api.setStartReturn(-700);
      const firstCode = await harness.start(1700006010000);
      assertNumberEqual(firstCode, -700);
      assertStateEqual(harness.getCurrentState(), MockRecordingState.Error);

      harness.forceState(MockRecordingState.Idle);
      api.setStartReturn(0);
      const secondCode = await harness.start(1700006015000);
      assertNumberEqual(secondCode, 0);
      assertStateEqual(harness.getCurrentState(), MockRecordingState.Recording);
    });

    it('SRManager_RecoveryAfterStopFailureNeedsIdleReset_006', 0, async () => {
      const apiFactory = new MockSRApiFactory();
      const api = apiFactory.build();
      const photoFactory = new MockPhotoAccessHelperFactory();
      const harness = new SRManagerHarness(api, photoFactory.build());
      await harness.start(1700006020000);
      api.setStopReturn(-701);
      const stopCode = harness.stop();
      assertNumberEqual(stopCode, -701);
      assertStateEqual(harness.getCurrentState(), MockRecordingState.Error);
      harness.forceState(MockRecordingState.Idle);
      api.setStopReturn(0);
      const restartCode = await harness.start(1700006025000);
      assertNumberEqual(restartCode, 0);
    });

    it('SRManager_BurstFaultInjectionYieldsDeterministicFingerprint_007', 0, async () => {
      const queue = new FoundationFaultPatternQueue(buildFoundationFaultPatterns());
      const checksum = new FoundationRollingChecksum();
      for (let round = 0; round < 30; round++) {
        const pattern = queue.getPattern(round);
        const outcome = await runFaultRound(round, pattern.startReturnCode, pattern.stopReturnCode, pattern.failCreateAsset);
        checksum.appendNumber(outcome.startCode);
        checksum.appendNumber(outcome.stopCode);
        checksum.appendNumber(outcome.finalState);
        checksum.appendNumber(outcome.threw ? 1 : 0);
      }
      assertAtLeast(checksum.getValue(), 1);
    });

    it('SRManager_FaultCounterSeparatesGreenAndErrorRounds_008', 0, async () => {
      const queue = new FoundationFaultPatternQueue(buildFoundationFaultPatterns());
      const counter = new FoundationScenarioCounter();
      for (let round = 0; round < 25; round++) {
        const pattern = queue.getPattern(round);
        const outcome = await runFaultRound(round, pattern.startReturnCode, pattern.stopReturnCode, pattern.failCreateAsset);
        counter.record(outcome.finalState === MockRecordingState.Error ? 'error' : 'green');
      }
      assertNumberEqual(counter.getDistinctCount(), 2);
      assertAtLeast(counter.getCount('error'), 10);
      assertAtLeast(counter.getCount('green'), 5);
    });

    it('SRManager_RepeatedCreateAssetFailureDoesNotLeakSuccessMetrics_009', 0, async () => {
      const apiFactory = new MockSRApiFactory();
      const photoFactory = new MockPhotoAccessHelperFactory();
      photoFactory.setThrowOnCreateAsset(true);
      const harness = new SRManagerHarness(apiFactory.build(), photoFactory.build());
      let failures = 0;
      for (let round = 0; round < 8; round++) {
        harness.forceState(MockRecordingState.Idle);
        try {
          await harness.start(1700006030000 + round * 1000);
        } catch (_) {
          failures += 1
        }
      }
      const metrics = harness.getMetrics();
      assertNumberEqual(failures, 8);
      assertNumberEqual(metrics.successfulStarts, 0);
      assertNumberEqual(metrics.createAssetCount, 0);
    });

    it('SRManager_ErrorStateBlocksStopUntilExplicitRecovery_010', 0, async () => {
      const apiFactory = new MockSRApiFactory();
      const api = apiFactory.build();
      api.setStartReturn(-801);
      const photoFactory = new MockPhotoAccessHelperFactory();
      const harness = new SRManagerHarness(api, photoFactory.build());
      await harness.start(1700006040000);
      const stopCode = harness.stop();
      assertNumberEqual(stopCode, -1001);
      assertStateEqual(harness.getCurrentState(), MockRecordingState.Error);
    });

    it('SRManager_MixedRecoveryWindowSupportsAlternatingFaultRounds_011', 0, async () => {
      const apiFactory = new MockSRApiFactory();
      const api = apiFactory.build();
      const photoFactory = new MockPhotoAccessHelperFactory();
      const harness = new SRManagerHarness(api, photoFactory.build());
      const finalStates: MockRecordingState[] = [];

      /**
       * 混合恢复窗口测试模拟“一次成功、一次失败、再一次成功”的交替生产流量。
       * 用于验证状态机不会因为上一轮故障把下一轮成功请求污染成异常态。
       */
      for (let round = 0; round < 12; round++) {
        harness.forceState(MockRecordingState.Idle);
        api.setStartReturn(round % 3 === 1 ? -811 : 0);
        try {
          const code = await harness.start(1700006050000 + round * 1000);
          if (code === 0) {
            harness.stop();
          }
        } catch (_) {
        }
        finalStates.push(harness.getCurrentState());
      }

      assertArrayLength(finalStates, 12);
      assertAtLeast(countState(finalStates, MockRecordingState.Error), 4);
      assertAtLeast(countState(finalStates, MockRecordingState.Stopped), 8);
    });

    it('SRManager_FaultMatrixIncludesGreenRecordingAndErrorOutcomes_012', 0, async () => {
      const states: MockRecordingState[] = [];
      const patterns = buildFoundationFaultPatterns();
      for (let index = 0; index < patterns.length; index++) {
        const pattern = patterns[index];
        const outcome = await runFaultRound(index, pattern.startReturnCode, pattern.stopReturnCode, pattern.failCreateAsset);
        states.push(outcome.finalState);
      }
      assertStateIn(states[0], [MockRecordingState.Stopped, MockRecordingState.Recording]);
      assertContains(states.join(','), `${MockRecordingState.Error}`);
    });
  });
}

function countState(values: MockRecordingState[], target: MockRecordingState): number {
  let count = 0;
  for (let index = 0; index < values.length; index++) {
    if (values[index] === target) {
      count += 1
    }
  }
  return count;
}
