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
  buildFoundationAssetNames,
  buildFoundationCanaryBuckets,
  buildFoundationCompatibilityProfiles,
  buildFoundationDurations,
  buildFoundationFaultPatterns,
  buildFoundationGrayReleaseKeys,
  buildFoundationKeySequenceCases,
  FoundationFaultPatternQueue,
  FoundationRollingChecksum,
  FoundationScenarioCounter,
  FoundationStorageEntity
} from './FoundationAdvancedFixtures';
import {
  assertArrayLength,
  assertAtLeast,
  assertContains,
  assertIncreasing,
  assertNonEmpty,
  assertNumberEqual,
  assertStringEqual,
  assertTrue
} from './TestAsserts';
import { MockRecordingState } from './TestTypes';

function computeSequenceChecksum(): number {
  const cases = buildFoundationKeySequenceCases();
  const checksum = new FoundationRollingChecksum();
  for (let caseIndex = 0; caseIndex < cases.length; caseIndex++) {
    const testCase = cases[caseIndex];
    checksum.appendText(testCase.name);
    checksum.appendNumber(testCase.expectedTriggerCount);
    for (let stepIndex = 0; stepIndex < testCase.steps.length; stepIndex++) {
      const step = testCase.steps[stepIndex];
      checksum.appendNumber(step.keyCode);
      checksum.appendNumber(step.isDown ? 1 : 0);
      checksum.appendNumber(step.delayMs);
    }
  }
  return checksum.getValue();
}

function recordCounterMatrix(counter: FoundationScenarioCounter, names: string[], roundCount: number): void {
  for (let round = 0; round < roundCount; round++) {
    for (let index = 0; index < names.length; index++) {
      if ((round + index) % 2 === 0) {
        counter.record(names[index]);
      }
    }
  }
}

export default function foundationAdvancedFixturesTest(): void {
  describe('FoundationAdvancedFixturesTest', () => {
    it('FoundationStorage_SetOrCreateAndSnapshot_001', 0, () => {
      const storage = new FoundationStorageEntity();

      /**
       * 录屏服务的状态传播依赖共享存储。
       * 这一测试先验证写入、覆盖、快照三个能力，确保后续生命周期和冷启动测试使用该桩时，状态来源不会因为共享引用而失真。
       */
      storage.setOrCreate('recorderState', 0);
      storage.setOrCreate('recorderState', 1);
      storage.set('lastPage', 'pages/ScreenRecorderTimer');

      const snapshot = storage.snapshot();
      assertNumberEqual(storage.getSize(), 2);
      assertNumberEqual(storage.get<number>('recorderState') ?? -1, 1);
      assertStringEqual(storage.get<string>('lastPage') ?? '', 'pages/ScreenRecorderTimer');
      assertNumberEqual(snapshot.size, 2);
      assertNumberEqual(snapshot.get('recorderState') as number, 1);
    });

    it('FoundationStorage_KeysRemainStableAcrossUpdates_002', 0, () => {
      const storage = new FoundationStorageEntity();
      storage.set('abilityContext', 'ctx_a');
      storage.set('abilityContext', 'ctx_b');
      storage.setOrCreate('recorderState', 2);
      storage.setOrCreate('recorderState', 3);

      const keys = storage.getKeys();
      assertArrayLength(keys, 2);
      assertContains(keys.join(','), 'abilityContext');
      assertContains(keys.join(','), 'recorderState');
    });

    it('FoundationScenarioCounter_CollectsCoverageAndHotspot_003', 0, () => {
      const profiles = buildFoundationCompatibilityProfiles();
      const counter = new FoundationScenarioCounter();

      /**
       * 灰度与兼容性矩阵测试关心覆盖面是否均衡。
       * 这里构造多轮采样，确认计数器既能汇总总量，也能识别最热点场景。
       */
      recordCounterMatrix(counter, profiles, 9);
      assertNumberEqual(counter.getDistinctCount(), profiles.length);
      assertAtLeast(counter.getTotalCount(), profiles.length * 4);
      assertNonEmpty(counter.getMostFrequentName());
      assertAtLeast(counter.getCount(profiles[0]), 4);
    });

    it('FoundationRollingChecksum_IsDeterministic_004', 0, () => {
      const checksumA = computeSequenceChecksum();
      const checksumB = computeSequenceChecksum();
      assertNumberEqual(checksumA, checksumB);
      assertAtLeast(checksumA, 1);
    });

    it('FoundationRollingChecksum_ChangesWhenInputChanges_005', 0, () => {
      const checksum = new FoundationRollingChecksum();
      checksum.appendText('foundation');
      checksum.appendNumber(2026);
      const baseline = checksum.getValue();

      checksum.appendText('delta');
      const mutated = checksum.getValue();
      assertTrue(mutated !== baseline);
    });

    it('FoundationFaultPatternQueue_CyclesPredictably_006', 0, () => {
      const patterns = buildFoundationFaultPatterns();
      const queue = new FoundationFaultPatternQueue(patterns);

      /**
       * 混沌测试最怕同一轮次注入不同故障，导致问题无法回放。
       * 通过验证循环队列取模行为，确保长时回归时每一轮的故障画像保持稳定。
       */
      assertNumberEqual(queue.getSize(), patterns.length);
      assertStringEqual(queue.getPattern(0).name, patterns[0].name);
      assertStringEqual(queue.getPattern(patterns.length).name, patterns[0].name);
      assertStringEqual(queue.getPattern(patterns.length + 1).name, patterns[1].name);
      assertStateEqualByNumber(queue.getPattern(1).expectedState, MockRecordingState.Error);
    });

    it('FoundationFaultPatternQueue_DefaultPatternWhenEmpty_007', 0, () => {
      const queue = new FoundationFaultPatternQueue([]);
      const pattern = queue.getPattern(17);
      assertStringEqual(pattern.name, 'default-idle');
      assertNumberEqual(pattern.startReturnCode, 0);
      assertNumberEqual(pattern.stopReturnCode, 0);
      assertStateEqualByNumber(pattern.expectedState, MockRecordingState.Idle);
    });

    it('FoundationAssetNames_HaveStablePaddingAndCount_008', 0, () => {
      const names = buildFoundationAssetNames('REC', 12);
      assertArrayLength(names, 12);
      assertStringEqual(names[0], 'REC_000.mp4');
      assertStringEqual(names[11], 'REC_011.mp4');
      assertContains(names.join('|'), '.mp4');
    });

    it('FoundationDurations_AreMonotonicForPerformanceBucketing_009', 0, () => {
      const durations = buildFoundationDurations();
      assertArrayLength(durations, 12);
      assertIncreasing(durations);
      assertNumberEqual(durations[0], 0);
      assertNumberEqual(durations[durations.length - 1], 10000);
    });

    it('FoundationCanaryBuckets_AreSafeForProgressiveRollout_010', 0, () => {
      const buckets = buildFoundationCanaryBuckets();

      /**
       * 金丝雀比例必须从小到大递进，才能在问题出现时把影响范围压到最小。
       * 这里校验比例有序且包含 100%，为后续灰度回归提供稳定基线。
       */
      assertArrayLength(buckets, 6);
      assertIncreasing(buckets);
      assertNumberEqual(buckets[0], 1);
      assertNumberEqual(buckets[buckets.length - 1], 100);
    });

    it('FoundationGrayReleaseKeys_AreReadableAndUnique_011', 0, () => {
      const keys = buildFoundationGrayReleaseKeys();
      const checksum = new FoundationRollingChecksum();
      for (let index = 0; index < keys.length; index++) {
        checksum.appendText(keys[index]);
      }
      assertArrayLength(keys, 5);
      assertContains(keys.join(','), 'foundation.mock.photo');
      assertContains(keys.join(','), 'foundation.regression.matrix');
      assertAtLeast(checksum.getValue(), 1);
    });

    it('FoundationCompatibilityProfiles_CoverLegacyAndHighEnd_012', 0, () => {
      const profiles = buildFoundationCompatibilityProfiles();
      assertArrayLength(profiles, 5);
      assertContains(profiles.join(','), 'tv-4k-landscape');
      assertContains(profiles.join(','), 'tv-720p-legacy');
      assertContains(profiles.join(','), 'emulator-1080p-debug');
    });

    it('FoundationKeySequenceCases_ContainBidirectionalAndReentryScenarios_013', 0, () => {
      const cases = buildFoundationKeySequenceCases();
      let totalSteps = 0;
      for (let index = 0; index < cases.length; index++) {
        totalSteps += cases[index].steps.length
      }
      assertArrayLength(cases, 4);
      assertAtLeast(totalSteps, 22);
      assertStringEqual(cases[0].name, 'a-then-b-once');
      assertStringEqual(cases[1].name, 'b-then-a-once');
      assertNumberEqual(cases[3].expectedTriggerCount, 2);
    });

    it('FoundationFaultPatterns_CoverCoreFailureModes_014', 0, () => {
      const patterns = buildFoundationFaultPatterns();
      const names = patterns.map((pattern: Object) => JSON.stringify(pattern)).join('|');
      assertArrayLength(patterns, 5);
      assertContains(names, 'create-asset-failed');
      assertContains(names, 'fetch-assets-failed');
      assertContains(names, 'start-call-failed');
      assertContains(names, 'stop-call-failed');
    });

    it('FoundationCounterAndChecksum_WorkTogetherForRegressionFingerprint_015', 0, () => {
      const counter = new FoundationScenarioCounter();
      const checksum = new FoundationRollingChecksum();
      const names = buildFoundationGrayReleaseKeys();

      /**
       * 回归套件不能只知道“执行过”，还要能够快速判断执行分布是否偏斜。
       * 这里把频次统计和校验组合起来，模拟后续自动化平台的轻量基线指纹。
       */
      for (let round = 0; round < 20; round++) {
        for (let index = 0; index < names.length; index++) {
          if ((round + index) % 3 !== 0) {
            counter.record(names[index]);
            checksum.appendText(names[index]);
            checksum.appendNumber(round);
          }
        }
      }

      assertNumberEqual(counter.getDistinctCount(), names.length);
      assertAtLeast(counter.getTotalCount(), 60);
      assertNonEmpty(counter.getMostFrequentName());
      assertAtLeast(checksum.getValue(), 1);
    });
  });
}

function assertStateEqualByNumber(actual: MockRecordingState, expected: MockRecordingState): void {
  assertNumberEqual(actual as number, expected as number);
}
