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
  buildFoundationFaultPatterns,
  buildFoundationGrayReleaseKeys,
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

interface AbilityRecoveryItem {
  round: number
  startCode: number
  stopCode: number
  recovered: boolean
}

class AbilityRecoveryHarness {
  private started: boolean = false
  private recent: string[] = []

  tryStart(code: number, name: string): number {
    if (this.started) {
      return -1000;
    }
    if (code === 0) {
      this.started = true;
      this.recent.push(name);
    }
    return code;
  }

  tryStop(code: number): number {
    if (!this.started) {
      return -1001;
    }
    if (code === 0) {
      this.started = false;
    }
    return code;
  }

  recover(): void {
    this.started = false;
  }

  isStarted(): boolean {
    return this.started;
  }

  getRecent(): string[] {
    return this.recent.slice();
  }
}

export default function abilityRecoveryRecentStressTest(): void {
  describe('AbilityRecoveryRecentStressTest', () => {
    it('AbilityRecovery_FaultQueueDrivesAlternatingRecoveryRounds_001', 0, () => {
      const queue = new FoundationFaultPatternQueue(buildFoundationFaultPatterns());
      const outcomes: AbilityRecoveryItem[] = [];

      /**
       * Ability 层恢复能力的关键在于失败后能否把界面重新带回可操作状态。
       * 这里把故障模式队列直接映射到 start/stop 编排，验证恢复动作是否足以支撑下一轮 Recent 写入。
       */
      for (let round = 0; round < 20; round++) {
        const harness = new AbilityRecoveryHarness();
        const pattern = queue.getPattern(round);
        const effectiveStartCode = pattern.failCreateAsset ? -200 : pattern.startReturnCode;
        const startCode = harness.tryStart(effectiveStartCode, `recent_${round}.mp4`);
        let stopCode = -1001;
        if (startCode === 0) {
          stopCode = harness.tryStop(pattern.failGetAssets ? -201 : pattern.stopReturnCode)
        }
        if (startCode !== 0 || stopCode !== 0) {
          harness.recover();
        }
        outcomes.push({
          round,
          startCode,
          stopCode,
          recovered: harness.isStarted() === false
        });
      }

      assertArrayLength(outcomes, 20);
      assertAtLeast(outcomes.filter((item: AbilityRecoveryItem) => item.recovered).length, 20);
      assertAtLeast(outcomes.filter((item: AbilityRecoveryItem) => item.startCode !== 0 || item.stopCode !== 0).length, 10);
    });

    it('AbilityRecovery_RecentStorageKeepsOnlySuccessfulStarts_002', 0, () => {
      const queue = new FoundationFaultPatternQueue(buildFoundationFaultPatterns());
      const storage = new FoundationStorageEntity();
      let successCount = 0;
      for (let round = 0; round < 14; round++) {
        const harness = new AbilityRecoveryHarness();
        const pattern = queue.getPattern(round);
        const startCode = harness.tryStart(pattern.startReturnCode, `artifact_${round}.mp4`);
        if (startCode === 0) {
          storage.set(`recent.${round}`, harness.getRecent()[0]);
          successCount += 1
        }
      }
      assertNumberEqual(storage.getSize(), successCount);
      assertContains(storage.get<string>('recent.0') ?? '', 'artifact_0');
    });

    it('AbilityRecovery_GrayKeyProjectionSupportsRecoveryAudit_003', 0, () => {
      const storage = new FoundationStorageEntity();
      const keys = buildFoundationGrayReleaseKeys();
      for (let index = 0; index < keys.length; index++) {
        storage.set(`${keys[index]}.recoverable`, index % 2 === 0 ? 'true' : 'false');
      }
      assertNumberEqual(storage.getSize(), keys.length);
      assertStringEqual(storage.get<string>('foundation.mock.window.recoverable') ?? '', 'false');
    });

    it('AbilityRecovery_LongRunRecentReplayProducesStableFingerprint_004', 0, () => {
      const checksumA = new FoundationRollingChecksum();
      const checksumB = new FoundationRollingChecksum();

      /**
       * 长稳压测关注的不只是最终 Recent 数量，更关注恢复序列是否可重复。
       * 通过双遍指纹校验可以拦截“第一遍能恢复、第二遍顺序错乱”的隐性问题。
       */
      for (let pass = 0; pass < 2; pass++) {
        for (let round = 0; round < 18; round++) {
          const harness = new AbilityRecoveryHarness();
          const name = `stress_${round}.mp4`;
          harness.tryStart(0, name);
          harness.tryStop(0);
          const summary = `${harness.getRecent().join(',')}|${harness.isStarted()}`;
          if (pass === 0) {
            checksumA.appendText(summary);
          } else {
            checksumB.appendText(summary);
          }
        }
      }
      assertNumberEqual(checksumA.getValue(), checksumB.getValue());
    });

    it('AbilityRecovery_RecoveryCounterSeparatesGreenAndFaultRounds_005', 0, () => {
      const queue = new FoundationFaultPatternQueue(buildFoundationFaultPatterns());
      const counter = new FoundationScenarioCounter();
      for (let round = 0; round < 24; round++) {
        const harness = new AbilityRecoveryHarness();
        const pattern = queue.getPattern(round);
        const startCode = harness.tryStart(pattern.failCreateAsset ? -200 : pattern.startReturnCode, `round_${round}.mp4`);
        if (startCode === 0) {
          const stopCode = harness.tryStop(pattern.failGetAssets ? -201 : pattern.stopReturnCode);
          counter.record(stopCode === 0 ? 'green' : 'fault');
        } else {
          counter.record('fault');
        }
        harness.recover();
      }
      assertNumberEqual(counter.getDistinctCount(), 2);
      assertAtLeast(counter.getCount('fault'), 10);
      assertAtLeast(counter.getCount('green'), 5);
    });

    it('AbilityRecovery_RecentSequenceRemainsReadableAfterRecovery_006', 0, () => {
      const harness = new AbilityRecoveryHarness();
      for (let round = 0; round < 16; round++) {
        if (round % 4 === 0) {
          harness.tryStart(-300, `bad_${round}.mp4`);
          harness.recover();
          continue;
        }
        harness.tryStart(0, `good_${round}.mp4`);
        harness.tryStop(0);
      }
      const recent = harness.getRecent();
      assertAtLeast(recent.length, 12);
      assertContains(recent[0], 'good_1');
    });

    it('AbilityRecovery_RecoverAlwaysLeavesStoppedSurface_007', 0, () => {
      const harness = new AbilityRecoveryHarness();
      for (let round = 0; round < 30; round++) {
        harness.tryStart(round % 3 === 0 ? -1 : 0, `surface_${round}.mp4`);
        if (harness.isStarted()) {
          harness.tryStop(round % 5 === 0 ? -2 : 0);
        }
        harness.recover();
      }
      assertTrue(harness.isStarted() === false);
    });

    it('AbilityRecovery_StorageAndRecentRemainAlignedDuringBurst_008', 0, () => {
      const harness = new AbilityRecoveryHarness();
      const storage = new FoundationStorageEntity();
      for (let round = 0; round < 22; round++) {
        const name = `burst_${round}.mp4`;
        if (harness.tryStart(0, name) === 0) {
          storage.set(`burst.${round}`, name);
          harness.tryStop(0);
        }
      }
      assertNumberEqual(storage.getSize(), 22);
      assertNumberEqual(harness.getRecent().length, 22);
      assertContains(storage.get<string>('burst.21') ?? '', 'burst_21');
    });

    it('AbilityRecovery_RepeatedFaultRoundsDoNotPolluteGreenRecent_009', 0, () => {
      const harness = new AbilityRecoveryHarness();
      for (let round = 0; round < 12; round++) {
        harness.tryStart(-9, `fault_${round}.mp4`);
        harness.recover();
      }
      assertArrayLength(harness.getRecent(), 0);
    });
  });
}
