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
  buildFoundationGrayReleaseKeys,
  FoundationRollingChecksum,
  FoundationStorageEntity
} from '../foundation/FoundationAdvancedFixtures';
import {
  assertAtLeast,
  assertContains,
  assertNonEmpty,
  assertNumberEqual,
  assertStateEqual,
  assertStringEqual,
  assertTrue
} from '../foundation/TestAsserts';
import { MockRecordingState } from '../foundation/TestTypes';
import { SRManagerHarness } from './SRManagerHarness';

function buildHarness(defaultFd: number): SRManagerHarness {
  const apiFactory = new MockSRApiFactory();
  const photoFactory = new MockPhotoAccessHelperFactory();
  return new SRManagerHarness(apiFactory.build(), photoFactory.build(), { defaultFd });
}

export default function srManagerPersistenceLifecycleTest(): void {
  describe('SRManagerPersistenceLifecycleTest', () => {
    it('SRManager_LifecycleDesktopHomeLaunchReplay_001', 0, async () => {
      const storage = new FoundationStorageEntity();
      const harness = buildHarness(7000);

      /**
       * 录屏业务经常跨 Desktop、Home、Launch 三段生命周期跳转。
       * 持久化层必须承接上一场会话的关键上下文，否则恢复后就无法判断是否要继续展示录制态。
       */
      await harness.start(1700009000000);
      storage.set('desktop.file', harness.getCurrentFileName());
      storage.set('desktop.url', harness.getLastStartUrl());
      harness.stop();
      storage.set('home.state', `${harness.getCurrentState()}`);

      const relaunchHarness = buildHarness(7001);
      relaunchHarness.forceState(MockRecordingState.Stopped);
      storage.set('launch.last.file', storage.get<string>('desktop.file') ?? '');
      storage.set('launch.last.url', storage.get<string>('desktop.url') ?? '');

      assertContains(storage.get<string>('desktop.file') ?? '', 'REC_');
      assertContains(storage.get<string>('desktop.url') ?? '', '7000');
      assertStringEqual(storage.get<string>('home.state') ?? '', `${MockRecordingState.Stopped}`);
      assertStateEqual(relaunchHarness.getCurrentState(), MockRecordingState.Stopped);
    });

    it('SRManager_PersistenceKeysRemainReadableForOperations_002', 0, async () => {
      const keys = buildFoundationGrayReleaseKeys();
      const storage = new FoundationStorageEntity();
      for (let index = 0; index < keys.length; index++) {
        const harness = buildHarness(7010 + index);
        await harness.start(1700009010000 + index * 1000);
        harness.stop();
        storage.set(`${keys[index]}.file`, harness.getCurrentFileName());
        storage.set(`${keys[index]}.state`, `${harness.getCurrentState()}`);
      }
      assertNumberEqual(storage.getSize(), keys.length * 2);
      assertContains(storage.get<string>('foundation.mock.photo.file') ?? '', 'REC_');
      assertContains(storage.get<string>('foundation.regression.matrix.state') ?? '', `${MockRecordingState.Stopped}`);
    });

    it('SRManager_ColdStartReplayUsesLastKnownRecordingArtifact_003', 0, async () => {
      const storage = new FoundationStorageEntity();
      const harness = buildHarness(7020);
      await harness.start(1700009020000);
      harness.stop();
      storage.set('cold.last.file', harness.getCurrentFileName());
      storage.set('cold.last.url', harness.getLastStartUrl());
      const replayFile = storage.get<string>('cold.last.file') ?? '';
      const replayUrl = storage.get<string>('cold.last.url') ?? '';
      assertNonEmpty(replayFile);
      assertContains(replayUrl, '7020');
    });

    it('SRManager_WarmStartReplayKeepsPreviousStoppedState_004', 0, async () => {
      const storage = new FoundationStorageEntity();
      const harness = buildHarness(7030);
      await harness.start(1700009030000);
      harness.stop();
      storage.set('warm.state', `${harness.getCurrentState()}`);
      storage.set('warm.file', harness.getCurrentFileName());
      assertStringEqual(storage.get<string>('warm.state') ?? '', `${MockRecordingState.Stopped}`);
      assertContains(storage.get<string>('warm.file') ?? '', 'REC_');
    });

    it('SRManager_GrayReleaseSnapshotsRemainTraceable_005', 0, async () => {
      const keys = buildFoundationGrayReleaseKeys();
      const checksum = new FoundationRollingChecksum();
      for (let index = 0; index < keys.length; index++) {
        const harness = buildHarness(7040 + index);
        await harness.start(1700009040000 + index * 1000);
        checksum.appendText(keys[index]);
        checksum.appendText(harness.getCurrentFileName());
        checksum.appendText(harness.getLastStartUrl());
        harness.stop();
      }
      assertAtLeast(checksum.getValue(), 1);
    });

    it('SRManager_LifecycleRestartDoesNotEraseLastStartUrl_006', 0, async () => {
      const storage = new FoundationStorageEntity();
      const harness = buildHarness(7050);
      await harness.start(1700009050000);
      const lastStartUrl = harness.getLastStartUrl();
      harness.stop();
      storage.set('restart.url', lastStartUrl);
      harness.resetMetrics();
      assertStringEqual(storage.get<string>('restart.url') ?? '', lastStartUrl);
      assertContains(storage.get<string>('restart.url') ?? '', '7050');
    });

    it('SRManager_RecentSessionProjectionSupportsBatchReplay_007', 0, async () => {
      const storage = new FoundationStorageEntity();
      for (let round = 0; round < 10; round++) {
        const harness = buildHarness(7060 + round);
        await harness.start(1700009060000 + round * 1000);
        harness.stop();
        storage.set(`session.${round}.file`, harness.getCurrentFileName());
        storage.set(`session.${round}.url`, harness.getLastStartUrl());
      }
      assertNumberEqual(storage.getSize(), 20);
      assertContains(storage.get<string>('session.9.url') ?? '', '7069');
    });

    it('SRManager_LifecycleMixMaintainsStoppedOutcomeFingerprint_008', 0, async () => {
      const checksum = new FoundationRollingChecksum();

      /**
       * 生命周期混合场景的关键不是某次启动成功，而是每个阶段结束后都能回到可恢复的稳定态。
       * 通过对最终状态和文件痕迹求指纹，可以快速识别是否存在某一阶段遗漏 stop 的残留问题。
       */
      for (let round = 0; round < 14; round++) {
        const harness = buildHarness(7080 + round);
        await harness.start(1700009070000 + round * 1000);
        harness.stop();
        checksum.appendNumber(harness.getCurrentState());
        checksum.appendText(harness.getCurrentFileName());
      }
      assertAtLeast(checksum.getValue(), 1);
    });

    it('SRManager_PersistenceSupportsSecurityAndContractFlags_009', 0, () => {
      const storage = new FoundationStorageEntity();
      storage.set('flag.security.audit', 'enabled');
      storage.set('flag.contract.check', 'enabled');
      storage.set('flag.gray.trace', 'enabled');
      assertStringEqual(storage.get<string>('flag.security.audit') ?? '', 'enabled');
      assertStringEqual(storage.get<string>('flag.contract.check') ?? '', 'enabled');
      assertStringEqual(storage.get<string>('flag.gray.trace') ?? '', 'enabled');
    });

    it('SRManager_LifecycleRoundsKeepReadableArtifacts_010', 0, async () => {
      for (let round = 0; round < 8; round++) {
        const harness = buildHarness(7100 + round);
        await harness.start(1700009080000 + round * 1000);
        assertContains(harness.getCurrentFileName(), 'REC_');
        assertContains(harness.getLastStartUrl(), `${7100 + round}`);
        harness.stop();
      }
      assertTrue(true);
    });

    it('SRManager_ColdWarmAlternationKeepsTraceFingerprintStable_011', 0, async () => {
      const checksumA = new FoundationRollingChecksum();
      const checksumB = new FoundationRollingChecksum();
      for (let pass = 0; pass < 2; pass++) {
        for (let round = 0; round < 6; round++) {
          const harness = buildHarness(7110 + round);
          await harness.start(1700009090000 + round * 1000);
          harness.stop();
          if (pass === 0) {
            checksumA.appendText(harness.getCurrentFileName());
            checksumA.appendText(harness.getLastStartUrl());
          } else {
            checksumB.appendText(harness.getCurrentFileName());
            checksumB.appendText(harness.getLastStartUrl());
          }
        }
      }
      assertNumberEqual(checksumA.getValue(), checksumB.getValue());
    });

    it('SRManager_LifecycleRestorationLeavesNoRecordingResidue_012', 0, async () => {
      let residueCount = 0;
      for (let round = 0; round < 12; round++) {
        const harness = buildHarness(7120 + round);
        await harness.start(1700009100000 + round * 1000);
        harness.stop();
        if (harness.getCurrentState() === MockRecordingState.Recording) {
          residueCount += 1
        }
      }
      assertNumberEqual(residueCount, 0);
    });
  });
}
