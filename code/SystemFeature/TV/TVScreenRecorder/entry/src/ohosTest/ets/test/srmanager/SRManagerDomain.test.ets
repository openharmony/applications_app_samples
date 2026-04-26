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
  assertArrayLength,
  assertAtLeast,
  assertContains,
  assertNonEmpty,
  assertNumberEqual,
  assertStateEqual,
  assertStateIn,
  assertTrue
} from '../foundation/TestAsserts';
import { MockRecordingState } from '../foundation/TestTypes';
import { buildFailureCodes, buildRecorderScenarioCases } from '../foundation/TestDataBuilder';
import { createScenarioSeeds, SRManagerHarness } from './SRManagerHarness';

export default function srManagerDomainTest(): void {
  describe('SRManagerDomainTest', () => {
    it('SRManager_StartSuccess_001', 0, async () => {
      const apiFactory = new MockSRApiFactory();
      const photoFactory = new MockPhotoAccessHelperFactory();
      const harness = new SRManagerHarness(apiFactory.build(), photoFactory.build());
      const startCode = await harness.start();
      assertNumberEqual(startCode, 0);
      assertStateEqual(harness.getCurrentState(), MockRecordingState.Recording);
      assertContains(harness.getLastStartUrl(), 'fd://');
      assertNonEmpty(harness.getCurrentFileName());
      const metrics = harness.getMetrics();
      assertNumberEqual(metrics.startAttempts, 1);
      assertNumberEqual(metrics.successfulStarts, 1);
      assertNumberEqual(metrics.createAssetCount, 1);
    });

    it('SRManager_StartWhenRecording_002', 0, async () => {
      const apiFactory = new MockSRApiFactory();
      const photoFactory = new MockPhotoAccessHelperFactory();
      const harness = new SRManagerHarness(apiFactory.build(), photoFactory.build());
      await harness.start();
      const secondStartCode = await harness.start();
      assertNumberEqual(secondStartCode, -1000);
      const metrics = harness.getMetrics();
      assertNumberEqual(metrics.startAttempts, 2);
      assertNumberEqual(metrics.successfulStarts, 1);
      assertNumberEqual(metrics.createAssetCount, 1);
    });

    it('SRManager_StopSuccess_003', 0, async () => {
      const apiFactory = new MockSRApiFactory();
      const photoFactory = new MockPhotoAccessHelperFactory();
      const harness = new SRManagerHarness(apiFactory.build(), photoFactory.build());
      await harness.start();
      const stopCode = harness.stop();
      assertNumberEqual(stopCode, 0);
      assertStateEqual(harness.getCurrentState(), MockRecordingState.Stopped);
      const metrics = harness.getMetrics();
      assertNumberEqual(metrics.stopAttempts, 1);
      assertNumberEqual(metrics.successfulStops, 1);
    });

    it('SRManager_StopWhenIdle_004', 0, () => {
      const apiFactory = new MockSRApiFactory();
      const photoFactory = new MockPhotoAccessHelperFactory();
      const harness = new SRManagerHarness(apiFactory.build(), photoFactory.build());
      const stopCode = harness.stop();
      assertNumberEqual(stopCode, -1001);
      const metrics = harness.getMetrics();
      assertNumberEqual(metrics.stopAttempts, 1);
      assertNumberEqual(metrics.successfulStops, 0);
    });

    it('SRManager_StartFailByApi_005', 0, async () => {
      const apiFactory = new MockSRApiFactory();
      const api = apiFactory.build();
      api.setStartReturn(-500);
      const photoFactory = new MockPhotoAccessHelperFactory();
      const harness = new SRManagerHarness(api, photoFactory.build());
      const code = await harness.start();
      assertNumberEqual(code, -500);
      assertStateEqual(harness.getCurrentState(), MockRecordingState.Error);
      const metrics = harness.getMetrics();
      assertNumberEqual(metrics.successfulStarts, 0);
      assertNumberEqual(metrics.startAttempts, 1);
    });

    it('SRManager_StopFailByApi_006', 0, async () => {
      const apiFactory = new MockSRApiFactory();
      const api = apiFactory.build();
      api.setStopReturn(-501);
      const photoFactory = new MockPhotoAccessHelperFactory();
      const harness = new SRManagerHarness(api, photoFactory.build());
      await harness.start();
      const code = harness.stop();
      assertNumberEqual(code, -501);
      assertStateEqual(harness.getCurrentState(), MockRecordingState.Error);
      const metrics = harness.getMetrics();
      assertNumberEqual(metrics.stopAttempts, 1);
      assertNumberEqual(metrics.successfulStops, 0);
    });

    it('SRManager_CreateAssetFail_007', 0, async () => {
      const apiFactory = new MockSRApiFactory();
      const photoFactory = new MockPhotoAccessHelperFactory();
      photoFactory.setThrowOnCreateAsset(true);
      const harness = new SRManagerHarness(apiFactory.build(), photoFactory.build());
      let thrown = false;
      try {
        await harness.start();
      } catch (_) {
        thrown = true;
      }
      assertTrue(thrown);
      const metrics = harness.getMetrics();
      assertNumberEqual(metrics.startAttempts, 1);
      assertNumberEqual(metrics.createAssetCount, 0);
    });

    it('SRManager_QueryState_008', 0, () => {
      const apiFactory = new MockSRApiFactory();
      const api = apiFactory.build();
      const photoFactory = new MockPhotoAccessHelperFactory();
      const harness = new SRManagerHarness(api, photoFactory.build());
      harness.forceState(MockRecordingState.Recording);
      const state = harness.queryState();
      assertStateEqual(state, MockRecordingState.Recording);
      const metrics = harness.getMetrics();
      assertNumberEqual(metrics.queryCount, 1);
    });

    it('SRManager_StateCallback_009', 0, async () => {
      const apiFactory = new MockSRApiFactory();
      const api = apiFactory.build();
      const photoFactory = new MockPhotoAccessHelperFactory();
      const harness = new SRManagerHarness(api, photoFactory.build());
      const history: MockRecordingState[] = [];
      harness.onStateChange((state: MockRecordingState) => {
        history.push(state);
      });
      await harness.start();
      harness.stop();
      assertArrayLength(history, 2);
      assertStateEqual(history[0], MockRecordingState.Recording);
      assertStateEqual(history[1], MockRecordingState.Stopped);
    });

    it('SRManager_CustomFdAndPrefix_010', 0, async () => {
      const apiFactory = new MockSRApiFactory();
      const photoFactory = new MockPhotoAccessHelperFactory();
      const harness = new SRManagerHarness(apiFactory.build(), photoFactory.build(), { fdPrefix: 'stream://', defaultFd: 66 });
      harness.setFd(77);
      await harness.start();
      assertStringEndsWith(harness.getLastStartUrl(), '77');
      assertContains(harness.getLastStartUrl(), 'stream://');
    });

    it('SRManager_ScenarioCases_011', 0, async () => {
      const scenarioCases = buildRecorderScenarioCases();
      assertAtLeast(scenarioCases.length, 6);
      for (let i = 0; i < scenarioCases.length; i++) {
        const current = scenarioCases[i];
        const apiFactory = new MockSRApiFactory();
        const api = apiFactory.build();
        api.setStartReturn(current.startReturnCode);
        api.setStopReturn(current.stopReturnCode);
        const photoFactory = new MockPhotoAccessHelperFactory();
        const harness = new SRManagerHarness(api, photoFactory.build());
        harness.forceState(current.initialState);
        if (current.action === 'start') {
          try {
            await harness.start(1700000000000 + i * 1000);
          } catch (_) {
          }
        } else if (current.action === 'stop') {
          harness.stop();
        } else {
          harness.queryState();
        }
        const finalState = harness.getCurrentState();
        assertStateIn(finalState, [
          current.expectedState,
          current.expectError ? MockRecordingState.Error : current.expectedState
        ]);
      }
    });

    it('SRManager_FailureCodeCoverage_012', 0, async () => {
      const failureCodes = buildFailureCodes();
      assertAtLeast(failureCodes.length, 6);
      for (let i = 0; i < failureCodes.length; i++) {
        const apiFactory = new MockSRApiFactory();
        const api = apiFactory.build();
        api.setStartReturn(failureCodes[i]);
        const photoFactory = new MockPhotoAccessHelperFactory();
        const harness = new SRManagerHarness(api, photoFactory.build());
        const result = await harness.start(1700000000000 + i * 1000);
        assertNumberEqual(result, failureCodes[i]);
        assertStateEqual(harness.getCurrentState(), MockRecordingState.Error);
      }
    });

    it('SRManager_SnapshotIntegrity_013', 0, async () => {
      const apiFactory = new MockSRApiFactory();
      const photoFactory = new MockPhotoAccessHelperFactory();
      const harness = new SRManagerHarness(apiFactory.build(), photoFactory.build());
      await harness.start();
      const snapshot = harness.getSnapshot();
      assertStateEqual(snapshot.state, MockRecordingState.Recording);
      assertNumberEqual(snapshot.metrics.startAttempts, 1);
      assertNonEmpty(snapshot.fileName);
      assertContains(snapshot.lastStartUrl, 'fd://');
    });

    it('SRManager_ResetMetrics_014', 0, async () => {
      const apiFactory = new MockSRApiFactory();
      const photoFactory = new MockPhotoAccessHelperFactory();
      const harness = new SRManagerHarness(apiFactory.build(), photoFactory.build());
      await harness.start();
      harness.stop();
      harness.queryState();
      harness.resetMetrics();
      const metrics = harness.getMetrics();
      assertNumberEqual(metrics.startAttempts, 0);
      assertNumberEqual(metrics.stopAttempts, 0);
      assertNumberEqual(metrics.queryCount, 0);
    });

    it('SRManager_MultiSeedFileName_015', 0, async () => {
      const apiFactory = new MockSRApiFactory();
      const photoFactory = new MockPhotoAccessHelperFactory();
      const harness = new SRManagerHarness(apiFactory.build(), photoFactory.build());
      const seeds = createScenarioSeeds(5, 1700000000000);
      const names: string[] = [];
      for (let i = 0; i < seeds.length; i++) {
        harness.forceState(MockRecordingState.Idle);
        await harness.start(seeds[i]);
        names.push(harness.getCurrentFileName());
        harness.stop();
      }
      assertArrayLength(names, 5);
      for (let i = 0; i < names.length; i++) {
        assertContains(names[i], 'REC_');
        assertContains(names[i], '.mp4');
      }
    });

    it('SRManager_StateCallbackCount_016', 0, async () => {
      const apiFactory = new MockSRApiFactory();
      const api = apiFactory.build();
      const photoFactory = new MockPhotoAccessHelperFactory();
      const harness = new SRManagerHarness(api, photoFactory.build());
      await harness.start();
      harness.stop();
      const metrics = harness.getMetrics();
      assertAtLeast(metrics.stateCallbackCount, 2);
    });

    it('SRManager_StressStartStop_017', 0, async () => {
      const apiFactory = new MockSRApiFactory();
      const photoFactory = new MockPhotoAccessHelperFactory();
      const harness = new SRManagerHarness(apiFactory.build(), photoFactory.build());
      let successCount = 0;
      for (let round = 1; round <= 30; round++) {
        harness.forceState(MockRecordingState.Idle);
        const startCode = await harness.start(1700000000000 + round * 1000);
        if (startCode === 0) {
          successCount += 1;
          const stopCode = harness.stop();
          assertNumberEqual(stopCode, 0);
        }
      }
      assertNumberEqual(successCount, 30);
      const metrics = harness.getMetrics();
      assertNumberEqual(metrics.successfulStarts, 30);
      assertNumberEqual(metrics.successfulStops, 30);
    });
  });
}

function assertStringEndsWith(value: string, suffix: string): void {
  const startIndex = value.length - suffix.length
  const isEndsWith = startIndex >= 0 && value.indexOf(suffix, startIndex) >= 0
  assertTrue(isEndsWith)
}
