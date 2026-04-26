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
  buildFoundationCanaryBuckets,
  buildFoundationCompatibilityProfiles,
  buildFoundationDurations,
  buildFoundationGrayReleaseKeys,
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
import { MockContextData, MockWindowRectEntity } from './TestTypes';

function buildStressNames(profile: string, count: number): string[] {
  const values: string[] = [];
  for (let index = 0; index < count; index++) {
    values.push(`${profile}_stress_${index}.mp4`);
  }
  return values;
}

export default function foundationStressCanaryTest(): void {
  describe('FoundationStressCanaryTest', () => {
    it('FoundationStress_StorageSupportsColdAndWarmReplay_001', 0, () => {
      const storage = new FoundationStorageEntity();

      /**
       * 冷启动与热恢复都依赖同一份持久化状态。
       * 如果基础存储桩无法稳定复现覆盖写入，后续生命周期测试就无法区分业务错误和基建误差。
       */
      for (let round = 0; round < 40; round++) {
        storage.setOrCreate('recorderState', round % 4);
        storage.set('round', round);
        storage.set('isColdStart', round % 2 === 0);
      }

      assertNumberEqual(storage.getSize(), 3);
      assertNumberEqual(storage.get<number>('recorderState') ?? -1, 3);
      assertNumberEqual(storage.get<number>('round') ?? -1, 39);
      assertTrue((storage.get<boolean>('isColdStart') ?? true) === false);
    });

    it('FoundationStress_GrayReleaseKeyProjectionStaysUnique_002', 0, () => {
      const keys = buildFoundationGrayReleaseKeys();
      const counter = new FoundationScenarioCounter();
      for (let round = 0; round < 60; round++) {
        counter.record(keys[round % keys.length]);
      }
      assertNumberEqual(counter.getDistinctCount(), keys.length);
      assertNumberEqual(counter.getTotalCount(), 60);
      assertContains(keys.join(','), 'foundation.mock.input');
    });

    it('FoundationStress_PhotoWindowInputMixedBurnIn_003', 0, async () => {
      const checksum = new FoundationRollingChecksum();
      const counter = new FoundationScenarioCounter();
      const profiles = buildFoundationCompatibilityProfiles();

      /**
       * 长稳压测的价值在于验证多种基础桩叠加后不会产生级联污染。
       * 这里把照片、窗口、按键三个子系统串起来，模拟持续录屏期间的高频基础操作。
       */
      for (let round = 0; round < 45; round++) {
        const profile = profiles[round % profiles.length];
        const photoFactory = new MockPhotoAccessHelperFactory(createDefaultClock(1700004000000 + round));
        const windowFactory = new MockWindowManagerFactory();
        const inputFactory = new MockInputConsumerFactory(23, 24, createDefaultClock(1700004100000 + round));
        const input = inputFactory.build();
        let callbackCount = 0;
        input.setCallback(() => {
          callbackCount += 1
        });
        await photoFactory.build().createAsset(`${profile}_${round}.mp4`, { subtype: round % 3 });
        windowFactory.build().openTimerWindow(`timer_${round}`, 'pages/ScreenRecorderTimer', new MockWindowRectEntity(96, 48, 624, 56), new MockContextData());
        input.triggerDown(23);
        input.triggerDown(24);
        input.triggerUp(23);
        input.triggerUp(24);
        counter.record(profile);
        checksum.appendText(profile);
        checksum.appendNumber(photoFactory.getAssetCount());
        checksum.appendNumber(windowFactory.getOpenRecords().length);
        checksum.appendNumber(callbackCount);
      }

      assertNumberEqual(counter.getDistinctCount(), profiles.length);
      assertAtLeast(counter.getTotalCount(), 45);
      assertAtLeast(checksum.getValue(), 1);
    });

    it('FoundationStress_SRApiCanaryBurnInMaintainsStateHistory_004', 0, () => {
      const buckets = buildFoundationCanaryBuckets();
      const checksum = new FoundationRollingChecksum();
      let totalHistoryLength = 0;
      let expectedTotalHistoryLength = 0;
      for (let index = 0; index < buckets.length; index++) {
        const factory = new MockSRApiFactory();
        const controller = factory.build();
        controller.onStateChange((_state: number) => {
        });
        for (let round = 0; round < buckets[index]; round++) {
          controller.startRecording(`fd://${index}_${round}`);
          controller.stopRecording();
        }
        const history = controller.getStateHistory();
        totalHistoryLength += history.length
        expectedTotalHistoryLength += buckets[index] * 2 + 1
        checksum.appendNumber(history.length);
      }
      assertNumberEqual(totalHistoryLength, expectedTotalHistoryLength);
      assertAtLeast(checksum.getValue(), 1);
    });

    it('FoundationStress_ProfileDurationCrossProductIsLargeEnough_005', 0, () => {
      const profiles = buildFoundationCompatibilityProfiles();
      const durations = buildFoundationDurations();
      const checksum = new FoundationRollingChecksum();
      let combinations = 0;
      for (let p = 0; p < profiles.length; p++) {
        for (let d = 0; d < durations.length; d++) {
          combinations += 1
          checksum.appendText(profiles[p]);
          checksum.appendNumber(durations[d]);
        }
      }
      assertNumberEqual(combinations, profiles.length * durations.length);
      assertAtLeast(combinations, 60);
      assertAtLeast(checksum.getValue(), 1);
    });

    it('FoundationStress_WindowPopupDurationMatrixCoversBoundaryBuckets_006', 0, () => {
      const durations = buildFoundationDurations();
      const factory = new MockWindowManagerFactory();
      const manager = factory.build();
      for (let index = 0; index < durations.length; index++) {
        manager.popupRecorderTip(
          `tip_${index}`,
          index % 2 === 0 ? 'pages/ScreenRecorderDialog' : 'pages/ResolutionNotSupportedDialog',
          new MockWindowRectEntity(615, 46, 686, 100),
          durations[index],
          new MockContextData()
        )
      }
      assertNumberEqual(factory.getPopupRecords().length, durations.length);
      assertNumberEqual(factory.getPopupRecords()[0].duration, 0);
      assertNumberEqual(factory.getPopupRecords()[durations.length - 1].duration, 10000);
    });

    it('FoundationStress_AssetPoolsRemainReadableAcrossProfiles_007', 0, async () => {
      const profiles = buildFoundationCompatibilityProfiles();
      const checksum = new FoundationRollingChecksum();
      let totalAssets = 0;

      /**
       * 多设备画像扩容时，命名可读性直接决定故障样本能否人工回溯。
       * 这里专门验证不同画像下批量资产名称都保留可识别前缀，避免海量样本难以定位。
       */
      for (let index = 0; index < profiles.length; index++) {
        const factory = new MockPhotoAccessHelperFactory(createDefaultClock(1700004200000 + index));
        const helper = factory.build();
        const names = buildStressNames(profiles[index], 10);
        for (let assetIndex = 0; assetIndex < names.length; assetIndex++) {
          const asset = await helper.createAsset(names[assetIndex], { subtype: assetIndex % 2 });
          checksum.appendText(asset.fileName);
        }
        totalAssets += factory.getAssetCount()
        assertContains(factory.getAssetsSnapshot()[0].fileName, profiles[index]);
      }

      assertNumberEqual(totalAssets, 50);
      assertAtLeast(checksum.getValue(), 1);
    });

    it('FoundationStress_InputBurstAndWindowBurstRemainInSync_008', 0, () => {
      const inputFactory = new MockInputConsumerFactory(23, 24, createDefaultClock(1700004300000));
      const input = inputFactory.build();
      const windowFactory = new MockWindowManagerFactory();
      const windowMgr = windowFactory.build();
      let callbackCount = 0;
      input.setCallback(() => {
        callbackCount += 1
      });
      for (let round = 0; round < 70; round++) {
        windowMgr.openTimerWindow(`timer_${round}`, 'pages/ScreenRecorderTimer', new MockWindowRectEntity(round, round, 120, 50), new MockContextData());
        input.triggerDown(23);
        input.triggerDown(24);
        input.triggerUp(23);
        input.triggerUp(24);
      }
      assertNumberEqual(windowFactory.getOpenRecords().length, 70);
      assertNumberEqual(callbackCount, 70);
      assertNumberEqual(input.getTriggerHistory().length, 280);
    });

    it('FoundationStress_CanaryBucketsRemainSortedAndAddressable_009', 0, () => {
      const buckets = buildFoundationCanaryBuckets();
      assertArrayLength(buckets, 6);
      assertNumberEqual(buckets[0], 1);
      assertNumberEqual(buckets[5], 100);
      assertTrue(buckets[0] < buckets[5]);
    });

    it('FoundationStress_ProfilePoolChecksumIsStable_010', 0, () => {
      const profiles = buildFoundationCompatibilityProfiles();
      const checksumA = new FoundationRollingChecksum();
      const checksumB = new FoundationRollingChecksum();
      for (let index = 0; index < profiles.length; index++) {
        checksumA.appendText(profiles[index]);
        checksumB.appendText(profiles[index]);
      }
      assertNumberEqual(checksumA.getValue(), checksumB.getValue());
      assertAtLeast(checksumA.getValue(), 1);
    });

    it('FoundationStress_StorageProjectionSupportsSecurityFlags_011', 0, () => {
      const storage = new FoundationStorageEntity();
      storage.set('feature.security.scan', 'enabled');
      storage.set('feature.data.contract', 'enabled');
      storage.set('feature.gray.release', 'enabled');
      assertStringEqual(storage.get<string>('feature.security.scan') ?? '', 'enabled');
      assertStringEqual(storage.get<string>('feature.data.contract') ?? '', 'enabled');
      assertStringEqual(storage.get<string>('feature.gray.release') ?? '', 'enabled');
    });
  });
}
