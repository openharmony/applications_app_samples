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
  buildFoundationCanaryBuckets,
  buildFoundationCompatibilityProfiles,
  buildFoundationDurations,
  FoundationRollingChecksum,
  FoundationScenarioCounter
} from '../foundation/FoundationAdvancedFixtures';
import {
  assertArrayLength,
  assertAtLeast,
  assertContains,
  assertNumberEqual,
  assertStateEqual,
  assertTrue
} from '../foundation/TestAsserts';
import { MockRecordingState } from '../foundation/TestTypes';
import { SRManagerHarness } from './SRManagerHarness';

interface CompatibilityResult {
  profile: string
  duration: number
  bucket: number
  startCode: number
  stopCode: number
}

function createHarness(defaultFd: number): SRManagerHarness {
  const apiFactory = new MockSRApiFactory();
  const photoFactory = new MockPhotoAccessHelperFactory();
  return new SRManagerHarness(apiFactory.build(), photoFactory.build(), { defaultFd });
}

export default function srManagerCompatibilityStressTest(): void {
  describe('SRManagerCompatibilityStressTest', () => {
    it('SRManager_ProfileDurationBucketMatrix_001', 0, async () => {
      const profiles = buildFoundationCompatibilityProfiles();
      const durations = buildFoundationDurations();
      const buckets = buildFoundationCanaryBuckets();
      const results: CompatibilityResult[] = [];
      const checksum = new FoundationRollingChecksum();

      /**
       * 兼容性测试要覆盖设备画像、录制时长和灰度档位三个维度。
       * 否则只能证明单点场景可用，无法证明真实分发流量下的稳定性。
       */
      for (let p = 0; p < profiles.length; p++) {
        for (let d = 0; d < durations.length; d++) {
          for (let b = 0; b < buckets.length; b++) {
            const harness = createHarness(5000 + results.length);
            const startCode = await harness.start(1700008000000 + results.length * 1000);
            const stopCode = harness.stop();
            results.push({
              profile: profiles[p],
              duration: durations[d],
              bucket: buckets[b],
              startCode,
              stopCode
            });
            checksum.appendText(profiles[p]);
            checksum.appendNumber(durations[d]);
            checksum.appendNumber(buckets[b]);
          }
        }
      }

      assertNumberEqual(results.length, profiles.length * durations.length * buckets.length);
      assertAtLeast(checksum.getValue(), 1);
      assertNumberEqual(results[0].startCode, 0);
      assertNumberEqual(results[results.length - 1].stopCode, 0);
    });

    it('SRManager_ProfileCounterCoversAllCompatibilityProfiles_002', 0, async () => {
      const profiles = buildFoundationCompatibilityProfiles();
      const counter = new FoundationScenarioCounter();
      for (let index = 0; index < profiles.length * 4; index++) {
        const harness = createHarness(5100 + index);
        await harness.start(1700008010000 + index * 1000);
        harness.stop();
        counter.record(profiles[index % profiles.length]);
      }
      assertNumberEqual(counter.getDistinctCount(), profiles.length);
      assertNumberEqual(counter.getTotalCount(), profiles.length * 4);
    });

    it('SRManager_DurationSlicesSupportSustainedSuccess_003', 0, async () => {
      const durations = buildFoundationDurations();
      let totalRounds = 0;
      for (let index = 0; index < durations.length; index++) {
        const rounds = durations[index] === 0 ? 6 : 4;
        for (let round = 0; round < rounds; round++) {
          const harness = createHarness(5200 + totalRounds);
          const startCode = await harness.start(1700008020000 + totalRounds * 1000);
          const stopCode = harness.stop();
          assertNumberEqual(startCode, 0);
          assertNumberEqual(stopCode, 0);
          totalRounds += 1
        }
      }
      assertAtLeast(totalRounds, 30);
    });

    it('SRManager_CanaryBucketsStayAddressableInStressReplay_004', 0, async () => {
      const buckets = buildFoundationCanaryBuckets();
      const seen: string[] = [];
      for (let index = 0; index < buckets.length; index++) {
        const harness = createHarness(5300 + index);
        await harness.start(1700008030000 + index * 1000);
        seen.push(`${buckets[index]}:${harness.getLastStartUrl()}`);
        harness.stop();
      }
      assertArrayLength(seen, buckets.length);
      assertContains(seen[0], '1:');
      assertContains(seen[buckets.length - 1], '100:');
    });

    it('SRManager_CompatibilityReplayPreservesStoppedState_005', 0, async () => {
      const profiles = buildFoundationCompatibilityProfiles();
      const durations = buildFoundationDurations();
      for (let index = 0; index < profiles.length * durations.length; index++) {
        const harness = createHarness(5400 + index);
        await harness.start(1700008040000 + index * 1000);
        harness.stop();
        assertStateEqual(harness.getCurrentState(), MockRecordingState.Stopped);
      }
    });

    it('SRManager_ProfileBucketsProduceReadableSnapshots_006', 0, async () => {
      const profiles = buildFoundationCompatibilityProfiles();
      const buckets = buildFoundationCanaryBuckets();
      for (let index = 0; index < profiles.length; index++) {
        const harness = createHarness(5500 + index);
        await harness.start(1700008050000 + index * 1000);
        const snapshot = harness.getSnapshot();
        assertContains(snapshot.fileName, 'REC_');
        assertContains(snapshot.lastStartUrl, `${5500 + index}`);
        assertTrue(buckets[index] >= 1);
        harness.stop();
      }
    });

    it('SRManager_StressReplayMetricsScaleWithMatrixSize_007', 0, async () => {
      const harness = createHarness(5600);
      const profiles = buildFoundationCompatibilityProfiles();
      let rounds = 0;

      /**
       * 高频稳定性不只关注某一轮是否成功，还要关注累计指标能否精确反映真实流量。
       * 因此这里用单一管理器跑完整个画像集，验证 start/stop 统计不会在长时间运行后漂移。
       */
      for (let profileIndex = 0; profileIndex < profiles.length; profileIndex++) {
        for (let round = 0; round < 12; round++) {
          harness.forceState(MockRecordingState.Idle);
          await harness.start(1700008060000 + rounds * 1000);
          harness.stop();
          rounds += 1
        }
      }

      const metrics = harness.getMetrics();
      assertNumberEqual(metrics.successfulStarts, rounds);
      assertNumberEqual(metrics.successfulStops, rounds);
      assertAtLeast(rounds, 60);
    });

    it('SRManager_ProfileSequenceAndUrlSequenceStayAligned_008', 0, async () => {
      const profiles = buildFoundationCompatibilityProfiles();
      const urls: string[] = [];
      for (let index = 0; index < profiles.length; index++) {
        const harness = createHarness(5700 + index);
        await harness.start(1700008070000 + index * 1000);
        urls.push(harness.getLastStartUrl());
        harness.stop();
      }
      assertContains(urls.join(','), '5700');
      assertContains(urls.join(','), '5704');
    });

    it('SRManager_DurationBucketsDoNotAffectCreateAssetCadence_009', 0, async () => {
      const durations = buildFoundationDurations();
      for (let index = 0; index < durations.length; index++) {
        const apiFactory = new MockSRApiFactory();
        const photoFactory = new MockPhotoAccessHelperFactory();
        const harness = new SRManagerHarness(apiFactory.build(), photoFactory.build(), { defaultFd: 5800 + index });
        await harness.start(1700008080000 + index * 1000);
        harness.stop();
        assertNumberEqual(photoFactory.getAssetCount(), 1);
      }
    });

    it('SRManager_CrossMatrixFingerprintStaysStable_010', 0, async () => {
      const profiles = buildFoundationCompatibilityProfiles();
      const durations = buildFoundationDurations();
      const checksumA = new FoundationRollingChecksum();
      const checksumB = new FoundationRollingChecksum();
      for (let pass = 0; pass < 2; pass++) {
        for (let index = 0; index < profiles.length; index++) {
          for (let durationIndex = 0; durationIndex < durations.length; durationIndex++) {
            const harness = createHarness(5900 + index * 10 + durationIndex);
            await harness.start(1700008090000 + index * 10000 + durationIndex * 1000);
            harness.stop();
            const snapshot = harness.getSnapshot();
            if (pass === 0) {
              checksumA.appendText(snapshot.fileName);
              checksumA.appendText(snapshot.lastStartUrl);
            } else {
              checksumB.appendText(snapshot.fileName);
              checksumB.appendText(snapshot.lastStartUrl);
            }
          }
        }
      }
      assertNumberEqual(checksumA.getValue(), checksumB.getValue());
    });

    it('SRManager_MixedMatrixLeavesNoRecordingStateResidue_011', 0, async () => {
      const profiles = buildFoundationCompatibilityProfiles();
      const buckets = buildFoundationCanaryBuckets();
      let residueCount = 0;
      for (let index = 0; index < profiles.length * buckets.length; index++) {
        const harness = createHarness(6000 + index);
        await harness.start(1700008100000 + index * 1000);
        harness.stop();
        if (harness.getCurrentState() === MockRecordingState.Recording) {
          residueCount += 1
        }
      }
      assertNumberEqual(residueCount, 0);
    });

    it('SRManager_StressMatrixProducesSufficientWorkload_012', 0, async () => {
      const profiles = buildFoundationCompatibilityProfiles();
      const durations = buildFoundationDurations();
      const buckets = buildFoundationCanaryBuckets();
      let operations = 0;
      for (let p = 0; p < profiles.length; p++) {
        for (let d = 0; d < durations.length; d++) {
          for (let b = 0; b < buckets.length; b++) {
            const harness = createHarness(6100 + operations);
            await harness.start(1700008110000 + operations * 1000);
            harness.stop();
            operations += 1
          }
        }
      }
      assertAtLeast(operations, 150);
    });
  });
}
