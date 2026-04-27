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
  assertNumberEqual,
  assertStateEqual,
  assertTrue
} from '../foundation/TestAsserts';
import { MockRecordingState } from '../foundation/TestTypes';
import {
  buildCanaryBuckets,
  buildCompatibilityDevices,
  buildFailureCodes,
  buildResolutionMatrix,
  buildRotationMatrix
} from '../foundation/TestDataBuilder';
import { createScenarioSeeds, SRManagerHarness } from './SRManagerHarness';

export default function srManagerChaosTest(): void {
  describe('SRManagerChaosTest', () => {
    it('SRManager_Chaos_StartFailureBurst_001', 0, async () => {
      const failureCodes = buildFailureCodes();
      const seeds = createScenarioSeeds(60, 1700000100000);
      const apiFactory = new MockSRApiFactory();
      const api = apiFactory.build();
      const photoFactory = new MockPhotoAccessHelperFactory();
      const harness = new SRManagerHarness(api, photoFactory.build());
      let failureCounter = 0;
      for (let i = 0; i < seeds.length; i++) {
        harness.forceState(MockRecordingState.Idle);
        const code = i % 4 === 0 ? failureCodes[i % failureCodes.length] : 0;
        api.setStartReturn(code);
        const startCode = await harness.start(seeds[i]);
        if (code !== 0) {
          failureCounter += 1;
          assertNumberEqual(startCode, code);
          assertStateEqual(harness.getCurrentState(), MockRecordingState.Error);
        } else {
          assertNumberEqual(startCode, 0);
          const stopCode = harness.stop();
          assertNumberEqual(stopCode, 0);
        }
      }
      assertNumberEqual(failureCounter, 15);
    });

    it('SRManager_Chaos_StopFailureBurst_002', 0, async () => {
      const failureCodes = buildFailureCodes();
      const apiFactory = new MockSRApiFactory();
      const api = apiFactory.build();
      const photoFactory = new MockPhotoAccessHelperFactory();
      const harness = new SRManagerHarness(api, photoFactory.build());
      let stopFailureCount = 0;
      for (let i = 0; i < 48; i++) {
        harness.forceState(MockRecordingState.Idle);
        api.setStartReturn(0);
        await harness.start(1700000200000 + i * 1000);
        api.setStopReturn(i % 6 === 0 ? failureCodes[i % failureCodes.length] : 0);
        harness.forceState(MockRecordingState.Recording);
        const stopCode = harness.stop();
        if (i % 6 === 0) {
          stopFailureCount += 1;
          assertTrue(stopCode < 0);
          assertStateEqual(harness.getCurrentState(), MockRecordingState.Error);
        } else {
          assertNumberEqual(stopCode, 0);
          assertStateEqual(harness.getCurrentState(), MockRecordingState.Stopped);
        }
      }
      assertNumberEqual(stopFailureCount, 8);
    });

    it('SRManager_Chaos_PhotoAccessOutage_003', 0, async () => {
      const apiFactory = new MockSRApiFactory();
      const api = apiFactory.build();
      const photoFactory = new MockPhotoAccessHelperFactory();
      const harness = new SRManagerHarness(api, photoFactory.build());
      let outageCount = 0;
      for (let i = 0; i < 30; i++) {
        harness.forceState(MockRecordingState.Idle);
        const isOutage = i % 5 === 0;
        photoFactory.setThrowOnCreateAsset(isOutage);
        if (isOutage) {
          let thrown = false;
          try {
            await harness.start(1700000300000 + i * 1000);
          } catch (_) {
            thrown = true;
          }
          assertTrue(thrown);
          outageCount += 1;
        } else {
          const code = await harness.start(1700000300000 + i * 1000);
          assertNumberEqual(code, 0);
          harness.stop();
        }
      }
      assertNumberEqual(outageCount, 6);
    });

    it('SRManager_Chaos_CanaryBuckets_004', 0, async () => {
      const buckets = buildCanaryBuckets();
      const apiFactory = new MockSRApiFactory();
      const api = apiFactory.build();
      const photoFactory = new MockPhotoAccessHelperFactory();
      const harness = new SRManagerHarness(api, photoFactory.build());
      assertArrayLength(buckets, 6);
      let totalStarts = 0;
      for (let i = 0; i < buckets.length; i++) {
        const bucket = buckets[i];
        const rounds = bucket.indexOf('full') >= 0 ? 20 : 8 + i;
        for (let r = 0; r < rounds; r++) {
          harness.forceState(MockRecordingState.Idle);
          const code = await harness.start(1700000400000 + totalStarts * 1000);
          assertNumberEqual(code, 0);
          harness.stop();
          totalStarts += 1;
        }
      }
      assertAtLeast(totalStarts, 60);
    });

    it('SRManager_Chaos_CompatibilityMatrix_005', 0, async () => {
      const devices = buildCompatibilityDevices();
      const rotations = buildRotationMatrix();
      const resolutions = buildResolutionMatrix();
      const apiFactory = new MockSRApiFactory();
      const photoFactory = new MockPhotoAccessHelperFactory();
      const harness = new SRManagerHarness(apiFactory.build(), photoFactory.build());
      let pairCount = 0;
      for (let d = 0; d < devices.length; d++) {
        for (let r = 0; r < rotations.length; r++) {
          for (let s = 0; s < resolutions.length; s++) {
            const pair = `${devices[d]}_${rotations[r]}_${resolutions[s].width}x${resolutions[s].height}`;
            assertContains(pair, 'x');
            harness.forceState(MockRecordingState.Idle);
            const code = await harness.start(1700000500000 + pairCount * 1000);
            assertNumberEqual(code, 0);
            harness.stop();
            pairCount += 1;
          }
        }
      }
      assertNumberEqual(pairCount, devices.length * rotations.length * resolutions.length);
    });

    it('SRManager_Chaos_StateFlipStorm_006', 0, async () => {
      const apiFactory = new MockSRApiFactory();
      const api = apiFactory.build();
      const photoFactory = new MockPhotoAccessHelperFactory();
      const harness = new SRManagerHarness(api, photoFactory.build());
      let callbackCount = 0;
      harness.onStateChange(() => {
        callbackCount += 1;
      });
      for (let i = 0; i < 200; i++) {
        const mode = i % 4;
        if (mode === 0) {
          api.emitState(MockRecordingState.Idle);
        } else if (mode === 1) {
          api.emitState(MockRecordingState.Recording);
        } else if (mode === 2) {
          api.emitState(MockRecordingState.Stopped);
        } else {
          api.emitState(MockRecordingState.Error);
        }
      }
      const snapshot = harness.getSnapshot();
      assertAtLeast(snapshot.metrics.stateCallbackCount, 200);
      assertAtLeast(callbackCount, 200);
    });

    it('SRManager_Chaos_DataConsistency_007', 0, async () => {
      const apiFactory = new MockSRApiFactory();
      const photoFactory = new MockPhotoAccessHelperFactory();
      const harness = new SRManagerHarness(apiFactory.build(), photoFactory.build());
      let operationCount = 0;
      for (let i = 0; i < 70; i++) {
        harness.forceState(MockRecordingState.Idle);
        const startCode = await harness.start(1700000600000 + i * 1000);
        assertNumberEqual(startCode, 0);
        const stopCode = harness.stop();
        assertNumberEqual(stopCode, 0);
        operationCount += 1;
      }
      const snapshot = harness.getSnapshot();
      assertNumberEqual(snapshot.metrics.successfulStarts, operationCount);
      assertNumberEqual(snapshot.metrics.successfulStops, operationCount);
      assertNumberEqual(snapshot.metrics.createAssetCount, operationCount);
    });

    it('SRManager_Chaos_QueryFlood_008', 0, () => {
      const apiFactory = new MockSRApiFactory();
      const api = apiFactory.build();
      const photoFactory = new MockPhotoAccessHelperFactory();
      const harness = new SRManagerHarness(api, photoFactory.build());
      const states: MockRecordingState[] = [];
      for (let i = 0; i < 300; i++) {
        api.setState((i % 4) as MockRecordingState);
        states.push(harness.queryState());
      }
      assertArrayLength(states, 300);
      assertAtLeast(harness.getMetrics().queryCount, 300);
    });

    it('SRManager_Chaos_RecoverFromError_009', 0, async () => {
      const apiFactory = new MockSRApiFactory();
      const api = apiFactory.build();
      const photoFactory = new MockPhotoAccessHelperFactory();
      const harness = new SRManagerHarness(api, photoFactory.build());
      let recovered = 0;
      for (let i = 0; i < 80; i++) {
        harness.forceState(MockRecordingState.Idle);
        api.setStartReturn(i % 7 === 0 ? -100 : 0);
        const startCode = await harness.start(1700000700000 + i * 1000);
        if (startCode !== 0) {
          assertStateEqual(harness.getCurrentState(), MockRecordingState.Error);
          harness.forceState(MockRecordingState.Idle);
          continue;
        }
        const stopCode = harness.stop();
        assertNumberEqual(stopCode, 0);
        recovered += 1;
      }
      assertAtLeast(recovered, 60);
    });
  });
}
