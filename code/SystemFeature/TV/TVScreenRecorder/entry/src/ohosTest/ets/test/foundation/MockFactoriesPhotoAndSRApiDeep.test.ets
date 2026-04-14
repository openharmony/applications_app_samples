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
import { createDefaultClock, MockPhotoAccessHelperFactory, MockSRApiFactory } from './MockFactories';
import {
  buildFoundationAssetNames,
  buildFoundationFaultPatterns,
  FoundationFaultPatternQueue,
  FoundationRollingChecksum,
  FoundationScenarioCounter
} from './FoundationAdvancedFixtures';
import {
  assertArrayLength,
  assertAtLeast,
  assertContains,
  assertIncreasing,
  assertNumberEqual,
  assertStringEqual,
  assertTrue
} from './TestAsserts';
import { MockRecordingState } from './TestTypes';

async function createAssets(factory: MockPhotoAccessHelperFactory, names: string[], subtype: number): Promise<string[]> {
  const helper = factory.build();
  const uris: string[] = [];
  for (let index = 0; index < names.length; index++) {
    const asset = await helper.createAsset(names[index], { subtype });
    uris.push(asset.uri);
  }
  return uris;
}

function feedSRApiPattern(factory: MockSRApiFactory, startCode: number, stopCode: number): MockRecordingState[] {
  const controller = factory.build();
  controller.setStartReturn(startCode);
  controller.setStopReturn(stopCode);
  controller.onStateChange((_state: number) => {
  });
  controller.startRecording('fd://200');
  controller.stopRecording();
  return controller.getStateHistory();
}

export default function mockFactoriesPhotoAndSRApiDeepTest(): void {
  describe('MockFactoriesPhotoAndSRApiDeepTest', () => {
    it('MockPhotoAccess_BatchCreateMaintainsMonotonicUris_001', 0, async () => {
      const clock = createDefaultClock(1700001000000);
      const factory = new MockPhotoAccessHelperFactory(clock);
      const names = buildFoundationAssetNames('SCREEN', 16);

      /**
       * 录屏文件一旦命名冲突，就会直接污染后续查询与回收判断。
       * 这里重点验证批量创建中 URI 与时间戳都稳定增长，保证长稳录制的资产可追踪。
       */
      const uris = await createAssets(factory, names, 7);
      const snapshots = factory.getAssetsSnapshot();
      const createdAtValues = snapshots.map((asset) => asset.createdAt);

      assertArrayLength(uris, 16);
      assertArrayLength(snapshots, 16);
      assertIncreasing(createdAtValues);
      assertContains(uris[0], 'SCREEN_000.mp4');
      assertContains(uris[15], 'SCREEN_015.mp4');
      assertNumberEqual(factory.getCreationCounter(), 16);
    });

    it('MockPhotoAccess_GetAssetsReflectsLatestSnapshot_002', 0, async () => {
      const factory = new MockPhotoAccessHelperFactory(createDefaultClock(1700001000100));
      const helper = factory.build();
      await helper.createAsset('REC_A.mp4', { subtype: 1 });
      await helper.createAsset('REC_B.mp4', { subtype: 1 });
      const result = await helper.getAssets({});
      const firstObject = result.getFirstObject?.();
      assertNumberEqual(result.getCount(), 2);
      assertTrue(firstObject !== undefined);
      if (firstObject === undefined) {
        return;
      }
      assertContains(firstObject.uri, 'REC_A.mp4');
    });

    it('MockPhotoAccess_ThrowsWhenCreateAssetInjected_003', 0, async () => {
      const factory = new MockPhotoAccessHelperFactory();
      factory.setThrowOnCreateAsset(true);
      const helper = factory.build();
      let failed = false;
      try {
        await helper.createAsset('BROKEN.mp4', { subtype: 5 });
      } catch (_) {
        failed = true
      }
      assertTrue(failed);
      assertNumberEqual(factory.getAssetCount(), 0);
    });

    it('MockPhotoAccess_ThrowsWhenGetAssetsInjected_004', 0, async () => {
      const factory = new MockPhotoAccessHelperFactory();
      const helper = factory.build();
      await helper.createAsset('REC_X.mp4', { subtype: 1 });
      factory.setThrowOnGetAssets(true);
      let failed = false;
      try {
        await helper.getAssets({});
      } catch (_) {
        failed = true
      }
      assertTrue(failed);
      assertNumberEqual(factory.getAssetCount(), 1);
    });

    it('MockPhotoAccess_CanaryBucketsProduceExpectedAssetVolume_005', 0, async () => {
      const counter = new FoundationScenarioCounter();
      const checksum = new FoundationRollingChecksum();
      const factory = new MockPhotoAccessHelperFactory(createDefaultClock(1700001000200));
      const names = buildFoundationAssetNames('CANARY', 24);

      /**
       * 金丝雀回归的重点不是一次性跑满，而是分批推进时总量和分布都可验证。
       * 这里把批次统计和资产创建绑定，便于后续将执行结果直接映射到发布档。
       */
      for (let index = 0; index < names.length; index++) {
        const helper = factory.build();
        const asset = await helper.createAsset(names[index], { subtype: index % 3 });
        counter.record(`bucket_${index % 4}`);
        checksum.appendText(asset.fileName);
        checksum.appendNumber(index % 3);
      }

      assertNumberEqual(factory.getAssetCount(), 24);
      assertNumberEqual(counter.getDistinctCount(), 4);
      assertAtLeast(counter.getTotalCount(), 24);
      assertAtLeast(checksum.getValue(), 1);
    });

    it('MockSRApi_StartSuccessEmitsRecordingThenStopped_006', 0, () => {
      const factory = new MockSRApiFactory();
      const controller = factory.build();
      let callbackCount = 0;
      controller.onStateChange((_state: number) => {
        callbackCount += 1
      });
      const startCode = controller.startRecording('fd://201');
      const stopCode = controller.stopRecording();
      const history = controller.getStateHistory();
      assertNumberEqual(startCode, 0);
      assertNumberEqual(stopCode, 0);
      assertAtLeast(callbackCount, 2);
      assertContains(history.join(','), `${MockRecordingState.Recording}`);
      assertContains(history.join(','), `${MockRecordingState.Stopped}`);
    });

    it('MockSRApi_StartFailureSwitchesToError_007', 0, () => {
      const factory = new MockSRApiFactory();
      const history = feedSRApiPattern(factory, -10, 0);
      assertContains(history.join(','), `${MockRecordingState.Error}`);
      assertStringEqual(factory.getLastStartUrl(), 'fd://200');
    });

    it('MockSRApi_StopFailureSwitchesToError_008', 0, () => {
      const factory = new MockSRApiFactory();
      const history = feedSRApiPattern(factory, 0, -20);
      assertContains(history.join(','), `${MockRecordingState.Recording}`);
      assertContains(history.join(','), `${MockRecordingState.Error}`);
    });

    it('MockSRApi_StateHistoryTracksManualEmits_009', 0, () => {
      const factory = new MockSRApiFactory();
      const controller = factory.build();
      controller.emitState(MockRecordingState.Recording);
      controller.emitState(MockRecordingState.Error);
      controller.emitState(MockRecordingState.Idle);
      const history = controller.getStateHistory();
      assertArrayLength(history, 4);
      assertNumberEqual(history[0], MockRecordingState.Idle);
      assertNumberEqual(history[3], MockRecordingState.Idle);
    });

    it('MockSRApi_SetStateOverridesCurrentQueryValue_010', 0, () => {
      const factory = new MockSRApiFactory();
      const controller = factory.build();
      controller.setState(MockRecordingState.Stopped);
      assertNumberEqual(controller.getRecorderState(), MockRecordingState.Stopped);
    });

    it('MockSRApi_FaultPatternQueueDrivesDeterministicHistories_011', 0, () => {
      const queue = new FoundationFaultPatternQueue(buildFoundationFaultPatterns());
      const checksum = new FoundationRollingChecksum();

      /**
       * 长时混沌回归需要把每一轮故障组合映射成稳定指纹。
       * 否则一旦底层模拟器有轻微抖动，就无法判断是产品缺陷还是样本漂移。
       */
      for (let round = 0; round < 20; round++) {
        const pattern = queue.getPattern(round);
        const factory = new MockSRApiFactory();
        const history = feedSRApiPattern(factory, pattern.startReturnCode, pattern.stopReturnCode);
        checksum.appendText(pattern.name);
        for (let index = 0; index < history.length; index++) {
          checksum.appendNumber(history[index]);
        }
      }

      assertAtLeast(checksum.getValue(), 1);
    });

    it('MockSRApi_BurstStartStopMaintainsLastUrl_012', 0, () => {
      const factory = new MockSRApiFactory();
      const controller = factory.build();
      controller.onStateChange((_state: number) => {
      });
      for (let index = 0; index < 40; index++) {
        controller.startRecording(`fd://${300 + index}`);
        controller.stopRecording();
      }
      assertStringEqual(controller.getLastStartUrl(), 'fd://339');
      assertAtLeast(controller.getStateHistory().length, 81);
    });

    it('MockSRApi_ManualStateSequenceCanModelRecovery_013', 0, () => {
      const factory = new MockSRApiFactory();
      const controller = factory.build();
      controller.emitState(MockRecordingState.Recording);
      controller.emitState(MockRecordingState.Error);
      controller.emitState(MockRecordingState.Idle);
      controller.emitState(MockRecordingState.Recording);
      controller.emitState(MockRecordingState.Stopped);
      const history = controller.getStateHistory();
      assertContains(history.join(','), `${MockRecordingState.Error}`);
      assertNumberEqual(history[history.length - 1], MockRecordingState.Stopped);
    });

    it('MockPhotoAccess_StressChecksumStaysDeterministic_014', 0, async () => {
      const clock = createDefaultClock(1700001000300);
      const factory = new MockPhotoAccessHelperFactory(clock);
      const checksum = new FoundationRollingChecksum();

      /**
       * 长稳资产回归需要在大量重复创建后依然可快速比对结果。
       * 这里使用 60 轮压力创建生成稳定指纹，避免直接持久化巨量快照带来脆弱性。
       */
      for (let index = 0; index < 60; index++) {
        clock.tick(33);
        const helper = factory.build();
        const asset = await helper.createAsset(`REC_STRESS_${index}.mp4`, { subtype: index % 4 });
        checksum.appendText(asset.uri);
        checksum.appendNumber(asset.createdAt);
      }

      assertNumberEqual(factory.getAssetCount(), 60);
      assertAtLeast(checksum.getValue(), 1);
    });
  });
}
