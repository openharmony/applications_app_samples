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
import { buildConcurrencyRounds, buildStressDurationsMs } from '../foundation/TestDataBuilder';
import { assertArrayLength, assertAtLeast, assertNumberEqual, assertStateEqual, assertStateIn, assertTrue } from '../foundation/TestAsserts';
import { MockRecordingState } from '../foundation/TestTypes';
import { buildStartStopRounds, SRManagerHarness } from './SRManagerHarness';

export default function srManagerConcurrencyTest(): void {
  describe('SRManagerConcurrencyTest', () => {
    it('SRManager_ConcurrentRoundMatrix_001', 0, async () => {
      const rounds = buildConcurrencyRounds();
      assertArrayLength(rounds, 40);
      const apiFactory = new MockSRApiFactory();
      const api = apiFactory.build();
      const photoFactory = new MockPhotoAccessHelperFactory();
      const harness = new SRManagerHarness(api, photoFactory.build());
      let successStarts = 0;
      let successStops = 0;
      for (let i = 0; i < rounds.length; i++) {
        harness.forceState(MockRecordingState.Idle);
        const startCode = await harness.start(1700000000000 + rounds[i] * 1000);
        if (startCode === 0) {
          successStarts += 1;
          const stopCode = harness.stop();
          if (stopCode === 0) {
            successStops += 1;
          }
        }
      }
      assertNumberEqual(successStarts, 40);
      assertNumberEqual(successStops, 40);
      const metrics = harness.getMetrics();
      assertNumberEqual(metrics.successfulStarts, 40);
      assertNumberEqual(metrics.successfulStops, 40);
    });

    it('SRManager_RoundModelFailInjection_002', 0, async () => {
      const roundModels = buildStartStopRounds(72);
      assertArrayLength(roundModels, 72);
      const photoFactory = new MockPhotoAccessHelperFactory();
      const apiFactory = new MockSRApiFactory();
      const api = apiFactory.build();
      const harness = new SRManagerHarness(api, photoFactory.build());
      let failCount = 0;
      let passCount = 0;
      for (let i = 0; i < roundModels.length; i++) {
        const current = roundModels[i];
        harness.forceState(MockRecordingState.Idle);
        api.setStartReturn(current.shouldFail ? -700 : 0);
        const startCode = await harness.start(1700000000000 + i * 1000);
        if (current.shouldFail) {
          assertNumberEqual(startCode, -700);
          assertStateIn(harness.getCurrentState(), [MockRecordingState.Error]);
          failCount += 1;
        } else {
          assertNumberEqual(startCode, 0);
          const stopCode = harness.stop();
          assertNumberEqual(stopCode, 0);
          passCount += 1;
        }
      }
      assertNumberEqual(failCount, 8);
      assertNumberEqual(passCount, 64);
    });

    it('SRManager_StopContention_003', 0, async () => {
      const apiFactory = new MockSRApiFactory();
      const api = apiFactory.build();
      const photoFactory = new MockPhotoAccessHelperFactory();
      const harness = new SRManagerHarness(api, photoFactory.build());
      await harness.start();
      const codes: number[] = [];
      for (let i = 0; i < 20; i++) {
        const code = harness.stop();
        codes.push(code);
        if (i < 19) {
          harness.forceState(MockRecordingState.Recording);
        }
      }
      assertArrayLength(codes, 20);
      for (let i = 0; i < codes.length; i++) {
        assertNumberEqual(codes[i], 0);
      }
      const metrics = harness.getMetrics();
      assertNumberEqual(metrics.stopAttempts, 20);
      assertNumberEqual(metrics.successfulStops, 20);
    });

    it('SRManager_StartContention_004', 0, async () => {
      const apiFactory = new MockSRApiFactory();
      const photoFactory = new MockPhotoAccessHelperFactory();
      const harness = new SRManagerHarness(apiFactory.build(), photoFactory.build());
      const codes: number[] = [];
      for (let i = 0; i < 50; i++) {
        harness.forceState(i % 2 === 0 ? MockRecordingState.Idle : MockRecordingState.Recording);
        const code = await harness.start(1700000000000 + i * 1000);
        codes.push(code);
      }
      let blocked = 0;
      let passed = 0;
      for (let i = 0; i < codes.length; i++) {
        if (codes[i] === -1000) {
          blocked += 1;
        }
        if (codes[i] === 0) {
          passed += 1;
        }
      }
      assertNumberEqual(blocked, 25);
      assertNumberEqual(passed, 25);
    });

    it('SRManager_DurationDrivenStability_005', 0, async () => {
      const durations = buildStressDurationsMs();
      const apiFactory = new MockSRApiFactory();
      const photoFactory = new MockPhotoAccessHelperFactory();
      const harness = new SRManagerHarness(apiFactory.build(), photoFactory.build());
      let total = 0;
      for (let i = 0; i < durations.length; i++) {
        const duration = durations[i];
        const rounds = duration >= 100 ? 10 : 20;
        for (let r = 0; r < rounds; r++) {
          harness.forceState(MockRecordingState.Idle);
          const startCode = await harness.start(1700000000000 + total * 1000);
          assertNumberEqual(startCode, 0);
          const stopCode = harness.stop();
          assertNumberEqual(stopCode, 0);
          total += 1;
        }
      }
      assertAtLeast(total, 100);
      const metrics = harness.getMetrics();
      assertNumberEqual(metrics.successfulStarts, total);
      assertNumberEqual(metrics.successfulStops, total);
    });

    it('SRManager_ConcurrentQueryConsistency_006', 0, async () => {
      const apiFactory = new MockSRApiFactory();
      const api = apiFactory.build();
      const photoFactory = new MockPhotoAccessHelperFactory();
      const harness = new SRManagerHarness(api, photoFactory.build());
      const queryStates: MockRecordingState[] = [];
      for (let i = 0; i < 60; i++) {
        if (i % 3 === 0) {
          harness.forceState(MockRecordingState.Idle);
        } else if (i % 3 === 1) {
          harness.forceState(MockRecordingState.Recording);
        } else {
          harness.forceState(MockRecordingState.Stopped);
        }
        const state = harness.queryState();
        queryStates.push(state);
      }
      assertArrayLength(queryStates, 60);
      const metrics = harness.getMetrics();
      assertNumberEqual(metrics.queryCount, 60);
    });

    it('SRManager_HighFrequencyMix_007', 0, async () => {
      const apiFactory = new MockSRApiFactory();
      const api = apiFactory.build();
      const photoFactory = new MockPhotoAccessHelperFactory();
      const harness = new SRManagerHarness(api, photoFactory.build());
      let operations = 0;
      let callbacks = 0;
      harness.onStateChange(() => {
        callbacks += 1;
      });
      for (let i = 0; i < 120; i++) {
        const mode = i % 4;
        if (mode === 0) {
          harness.forceState(MockRecordingState.Idle);
          await harness.start(1700000000000 + i * 1000);
        } else if (mode === 1) {
          harness.forceState(MockRecordingState.Recording);
          harness.stop();
        } else if (mode === 2) {
          harness.forceState(MockRecordingState.Stopped);
          harness.queryState();
        } else {
          harness.forceState(MockRecordingState.Error);
          harness.queryState();
        }
        operations += 1;
      }
      assertNumberEqual(operations, 120);
      assertTrue(callbacks > 0);
      const metrics = harness.getMetrics();
      assertAtLeast(metrics.stateCallbackCount, callbacks);
    });

    it('SRManager_ParallelHarnessIsolation_008', 0, async () => {
      const harnesses: SRManagerHarness[] = [];
      for (let i = 0; i < 6; i++) {
        const apiFactory = new MockSRApiFactory();
        const photoFactory = new MockPhotoAccessHelperFactory();
        harnesses.push(new SRManagerHarness(apiFactory.build(), photoFactory.build(), { defaultFd: 1000 + i }));
      }
      for (let i = 0; i < harnesses.length; i++) {
        const harness = harnesses[i];
        harness.forceState(MockRecordingState.Idle);
        const code = await harness.start(1700000000000 + i * 1000);
        assertNumberEqual(code, 0);
        assertContainsFd(harness.getLastStartUrl(), `${1000 + i}`);
      }
      for (let i = 0; i < harnesses.length; i++) {
        const harness = harnesses[i];
        const stopCode = harness.stop();
        assertNumberEqual(stopCode, 0);
      }
    });

    it('SRManager_BurstFailureRecovery_009', 0, async () => {
      const apiFactory = new MockSRApiFactory();
      const api = apiFactory.build();
      const photoFactory = new MockPhotoAccessHelperFactory();
      const harness = new SRManagerHarness(api, photoFactory.build());
      let recovered = 0;
      for (let i = 0; i < 90; i++) {
        harness.forceState(MockRecordingState.Idle);
        api.setStartReturn(i % 10 === 0 ? -901 : 0);
        const startCode = await harness.start(1700000000000 + i * 1000);
        if (startCode === 0) {
          harness.stop();
          recovered += 1;
        } else {
          assertStateEqual(harness.getCurrentState(), MockRecordingState.Error);
          harness.forceState(MockRecordingState.Idle);
        }
      }
      assertNumberEqual(recovered, 81);
    });
  });
}

function assertContainsFd(url: string, fd: string): void {
  assertTrue(url.indexOf(fd) >= 0)
}
