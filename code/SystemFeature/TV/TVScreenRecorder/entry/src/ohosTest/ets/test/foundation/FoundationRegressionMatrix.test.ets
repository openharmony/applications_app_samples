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
import { createDefaultClock, MockInputConsumerFactory, MockPhotoAccessHelperFactory, MockSRApiFactory, MockWindowManagerFactory } from './MockFactories';
import {
  buildFoundationAssetNames,
  buildFoundationCanaryBuckets,
  buildFoundationCompatibilityProfiles,
  buildFoundationFaultPatterns,
  buildFoundationGrayReleaseKeys,
  FoundationFaultPattern,
  FoundationFaultPatternQueue,
  FoundationRollingChecksum,
  FoundationScenarioCounter,
  FoundationStorageEntity
} from './FoundationAdvancedFixtures';
import {
  assertArrayLength,
  assertAtLeast,
  assertContains,
  assertNumberEqual,
  assertStringEqual,
  assertTrue
} from './TestAsserts';
import { MockContextData, MockRecordingState, MockWindowRectEntity } from './TestTypes';

interface RegressionRoundResult {
  round: number
  profile: string
  bucket: number
  assetCount: number
  callbackCount: number
  stateHistoryLength: number
  finalState: MockRecordingState
}

async function executeRegressionRound(
  round: number,
  profile: string,
  bucket: number,
  pattern: FoundationFaultPattern
): Promise<RegressionRoundResult> {
  const photoFactory = new MockPhotoAccessHelperFactory(createDefaultClock(1700003000000 + round * 100));
  const windowFactory = new MockWindowManagerFactory();
  const inputFactory = new MockInputConsumerFactory(23, 24, createDefaultClock(1700003100000 + round * 50));
  const srApiFactory = new MockSRApiFactory();
  const storage = new FoundationStorageEntity();
  const input = inputFactory.build();
  const windowMgr = windowFactory.build();
  const srApi = srApiFactory.build();
  let callbackCount = 0;

  srApi.setStartReturn(pattern.startReturnCode);
  srApi.setStopReturn(pattern.stopReturnCode);
  input.setCallback(() => {
    callbackCount += 1
  });

  storage.set('profile', profile);
  storage.set('bucket', bucket);
  storage.set('round', round);

  windowMgr.openTimerWindow(
    `timer_${round}`,
    'pages/ScreenRecorderTimer',
    new MockWindowRectEntity(96 + round, 48 + round, 624, 56),
    new MockContextData(),
    storage.snapshot()
  );

  input.triggerDown(23);
  input.triggerDown(24);
  input.triggerUp(23);
  input.triggerUp(24);

  if (!pattern.failCreateAsset) {
    const helper = photoFactory.build();
    await helper.createAsset(`REG_${profile}_${bucket}_${round}.mp4`, { subtype: bucket % 3 });
    if (pattern.failGetAssets) {
      photoFactory.setThrowOnGetAssets(true);
    }
    try {
      await helper.getAssets({});
    } catch (_) {
    }
  } else {
    photoFactory.setThrowOnCreateAsset(true);
    try {
      await photoFactory.build().createAsset(`BROKEN_${round}.mp4`, { subtype: 0 });
    } catch (_) {
    }
  }

  srApi.onStateChange((_state: number) => {
  });
  srApi.startRecording(`fd://${500 + round}`);
  srApi.stopRecording();

  windowMgr.popupRecorderTip(
    `tip_${round}`,
    pattern.expectedState === MockRecordingState.Error ? 'pages/ResolutionNotSupportedDialog' : 'pages/ScreenRecorderDialog',
    new MockWindowRectEntity(615, 46, 686, 100),
    3000,
    new MockContextData()
  );

  const history = srApi.getStateHistory();
  return {
    round,
    profile,
    bucket,
    assetCount: photoFactory.getAssetCount(),
    callbackCount,
    stateHistoryLength: history.length,
    finalState: history[history.length - 1]
  }
}

export default function foundationRegressionMatrixTest(): void {
  describe('FoundationRegressionMatrixTest', () => {
    it('FoundationRegression_MixedCanaryCompatibilityRounds_001', 0, async () => {
      const profiles = buildFoundationCompatibilityProfiles();
      const buckets = buildFoundationCanaryBuckets();
      const queue = new FoundationFaultPatternQueue(buildFoundationFaultPatterns());
      const counter = new FoundationScenarioCounter();
      const checksum = new FoundationRollingChecksum();
      const results: RegressionRoundResult[] = [];

      /**
       * 真实发布不是单维度验证，而是设备画像、灰度档位、故障模式三者交叉。
       * 这个矩阵回归通过固定映射把多维组合压成稳定样本，确保批量扩容时仍可复现。
       */
      for (let round = 0; round < 24; round++) {
        const profile = profiles[round % profiles.length];
        const bucket = buckets[round % buckets.length];
        const pattern = queue.getPattern(round);
        const result = await executeRegressionRound(round, profile, bucket, pattern);
        results.push(result);
        counter.record(profile);
        checksum.appendText(profile);
        checksum.appendNumber(bucket);
        checksum.appendNumber(result.assetCount);
        checksum.appendNumber(result.callbackCount);
        checksum.appendNumber(result.finalState);
      }

      assertArrayLength(results, 24);
      assertNumberEqual(counter.getDistinctCount(), profiles.length);
      assertAtLeast(counter.getTotalCount(), 24);
      assertAtLeast(checksum.getValue(), 1);
    });

    it('FoundationRegression_GrayReleaseKeysStayAddressable_002', 0, () => {
      const keys = buildFoundationGrayReleaseKeys();
      const storage = new FoundationStorageEntity();
      for (let index = 0; index < keys.length; index++) {
        storage.set(keys[index], `${index}`);
      }
      assertNumberEqual(storage.getSize(), keys.length);
      assertStringEqual(storage.get<string>('foundation.mock.photo') ?? '', '0');
      assertStringEqual(storage.get<string>('foundation.regression.matrix') ?? '', '4');
    });

    it('FoundationRegression_AssetNamePoolSupportsMassExpansion_003', 0, () => {
      const names = buildFoundationAssetNames('POOL', 80);
      const checksum = new FoundationRollingChecksum();
      for (let index = 0; index < names.length; index++) {
        checksum.appendText(names[index]);
      }
      assertArrayLength(names, 80);
      assertStringEqual(names[0], 'POOL_000.mp4');
      assertStringEqual(names[79], 'POOL_079.mp4');
      assertAtLeast(checksum.getValue(), 1);
    });

    it('FoundationRegression_WindowAndInputCoverageIsBalanced_004', 0, () => {
      const counter = new FoundationScenarioCounter();
      const windowFactory = new MockWindowManagerFactory();
      const windowMgr = windowFactory.build();
      const inputFactory = new MockInputConsumerFactory(23, 24, createDefaultClock(1700003200000));
      const input = inputFactory.build();
      let callbackCount = 0;
      input.setCallback(() => {
        callbackCount += 1
      });

      /**
       * 悬浮窗和按键是停止录屏的前后两个关键节点。
       * 通过交替执行创建、提示、按键触发，可以验证基础桩在交织调用时不会互相污染状态。
       */
      for (let round = 0; round < 36; round++) {
        windowMgr.openTimerWindow(`timer_${round}`, 'pages/ScreenRecorderTimer', new MockWindowRectEntity(round, round, 100, 50), new MockContextData());
        if (round % 3 === 0) {
          windowMgr.popupRecorderTip(`tip_${round}`, 'pages/ScreenRecorderDialog', new MockWindowRectEntity(0, 0, 200, 80), 3000, new MockContextData());
        }
        input.triggerDown(23);
        input.triggerDown(24);
        input.triggerUp(23);
        input.triggerUp(24);
        counter.record(`segment_${round % 6}`);
      }

      assertNumberEqual(counter.getDistinctCount(), 6);
      assertNumberEqual(callbackCount, 36);
      assertNumberEqual(windowFactory.getOpenRecords().length, 36);
      assertNumberEqual(windowFactory.getPopupRecords().length, 12);
    });

    it('FoundationRegression_SRApiFaultOutcomesMatchPatternExpectation_005', 0, () => {
      const patterns = buildFoundationFaultPatterns();
      for (let index = 0; index < patterns.length; index++) {
        const pattern = patterns[index];
        const factory = new MockSRApiFactory();
        const controller = factory.build();
        controller.setStartReturn(pattern.startReturnCode);
        controller.setStopReturn(pattern.stopReturnCode);
        controller.onStateChange((_state: number) => {
        });
        controller.startRecording(`fd://${900 + index}`);
        controller.stopRecording();
        const history = controller.getStateHistory();
        const lastState = history[history.length - 1];
        const expectedState = pattern.stopReturnCode === 0
          ? MockRecordingState.Stopped
          : MockRecordingState.Error;
        assertNumberEqual(lastState, expectedState);
      }
    });

    it('FoundationRegression_PhotoFactoryVolumeAgainstProfiles_006', 0, async () => {
      const profiles = buildFoundationCompatibilityProfiles();
      const counter = new FoundationScenarioCounter();
      const checksum = new FoundationRollingChecksum();

      /**
       * 不同设备画像下，基础资产工厂必须表现一致，否则后续业务域测试会把基础设施缺陷误判成业务问题。
       * 这里将设备画像与资产创建绑定，验证跨画像扩容时工厂行为仍可预测。
       */
      for (let index = 0; index < profiles.length; index++) {
        const factory = new MockPhotoAccessHelperFactory(createDefaultClock(1700003300000 + index * 10));
        const helper = factory.build();
        for (let round = 0; round < 12; round++) {
          const asset = await helper.createAsset(`${profiles[index]}_${round}.mp4`, { subtype: round % 2 });
          checksum.appendText(asset.fileName);
          checksum.appendNumber(asset.createdAt);
        }
        counter.record(profiles[index]);
        assertNumberEqual(factory.getAssetCount(), 12);
      }

      assertNumberEqual(counter.getDistinctCount(), profiles.length);
      assertAtLeast(checksum.getValue(), 1);
    });

    it('FoundationRegression_ResultProjectionContainsGreenAndErrorPaths_007', 0, async () => {
      const profiles = buildFoundationCompatibilityProfiles();
      const buckets = buildFoundationCanaryBuckets();
      const queue = new FoundationFaultPatternQueue(buildFoundationFaultPatterns());
      const results: RegressionRoundResult[] = [];
      for (let round = 0; round < 10; round++) {
        results.push(await executeRegressionRound(round, profiles[round % profiles.length], buckets[round % buckets.length], queue.getPattern(round)));
      }
      const finalStates = results.map((item) => item.finalState).join(',');
      assertContains(finalStates, `${MockRecordingState.Error}`);
      assertTrue(finalStates.indexOf(`${MockRecordingState.Stopped}`) >= 0 || finalStates.indexOf(`${MockRecordingState.Recording}`) >= 0);
    });
  });
}
