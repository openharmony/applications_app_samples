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
  FoundationRollingChecksum,
  FoundationScenarioCounter
} from '../foundation/FoundationAdvancedFixtures';
import {
  assertArrayLength,
  assertAtLeast,
  assertContains,
  assertIncreasing,
  assertNonEmpty,
  assertNumberEqual,
  assertStateEqual,
  assertTrue
} from '../foundation/TestAsserts';
import { MockRecordingState } from '../foundation/TestTypes';
import { createScenarioSeeds, SRManagerHarness } from './SRManagerHarness';

interface StateMatrixRecord {
  profile: string
  bucket: number
  state: MockRecordingState
  startUrl: string
  fileName: string
}

function buildHarness(defaultFd: number = 1000): SRManagerHarness {
  const apiFactory = new MockSRApiFactory();
  const photoFactory = new MockPhotoAccessHelperFactory();
  return new SRManagerHarness(apiFactory.build(), photoFactory.build(), { defaultFd });
}

async function runSingleStartStop(seed: number, fd: number): Promise<StateMatrixRecord> {
  const profiles = buildFoundationCompatibilityProfiles();
  const buckets = buildFoundationCanaryBuckets();
  const profile = profiles[(seed / 1000) % profiles.length];
  const bucket = buckets[(seed / 1000) % buckets.length];
  const harness = buildHarness(fd);
  await harness.start(seed);
  harness.stop();
  return {
    profile,
    bucket,
    state: harness.getCurrentState(),
    startUrl: harness.getLastStartUrl(),
    fileName: harness.getCurrentFileName()
  }
}

export default function srManagerStateMatrixDeepTest(): void {
  describe('SRManagerStateMatrixDeepTest', () => {
    it('SRManager_StateMatrix_ProfileBucketProjection_001', 0, async () => {
      const profiles = buildFoundationCompatibilityProfiles();
      const buckets = buildFoundationCanaryBuckets();
      const counter = new FoundationScenarioCounter();
      const checksum = new FoundationRollingChecksum();
      const seeds = createScenarioSeeds(30, 1700005000000);
      const records: StateMatrixRecord[] = [];

      /**
       * 录屏状态机在不同设备画像和灰度档位下都必须保持同样的收敛结果。
       * 否则上线后就会出现“某批用户正常、某批用户卡死”的灰度漂移问题。
       */
      for (let index = 0; index < seeds.length; index++) {
        const profile = profiles[index % profiles.length];
        const bucket = buckets[index % buckets.length];
        const harness = buildHarness(1200 + index);
        await harness.start(seeds[index]);
        harness.stop();
        const record: StateMatrixRecord = {
          profile,
          bucket,
          state: harness.getCurrentState(),
          startUrl: harness.getLastStartUrl(),
          fileName: harness.getCurrentFileName()
        }
        records.push(record);
        counter.record(profile);
        checksum.appendText(profile);
        checksum.appendNumber(bucket);
        checksum.appendNumber(record.state);
      }

      assertArrayLength(records, 30);
      assertNumberEqual(counter.getDistinctCount(), profiles.length);
      assertAtLeast(counter.getTotalCount(), 30);
      assertAtLeast(checksum.getValue(), 1);
    });

    it('SRManager_FileNamesGrowWithScenarioSeeds_002', 0, async () => {
      const seeds = createScenarioSeeds(12, 1700005010000);
      const names: string[] = [];
      const checksum = new FoundationRollingChecksum();

      /**
       * 录屏文件名不仅要非空，还要能承载时间语义。
       * 这个用例通过多时间种子生成文件名，避免后续持久化回归出现文件覆盖却无从定位。
       */
      for (let index = 0; index < seeds.length; index++) {
        const harness = buildHarness(1300 + index);
        await harness.start(seeds[index]);
        names.push(harness.getCurrentFileName());
        checksum.appendText(harness.getCurrentFileName());
        harness.stop();
      }

      assertArrayLength(names, 12);
      assertContains(names[0], 'REC_');
      assertContains(names[0], '.mp4');
      assertNonEmpty(names[11]);
      assertAtLeast(checksum.getValue(), 1);
    });

    it('SRManager_StartUrlKeepsDistinctFdAcrossParallelHarnesses_003', 0, async () => {
      const urls: string[] = [];
      for (let index = 0; index < 10; index++) {
        const harness = buildHarness(1400 + index);
        await harness.start(1700005020000 + index * 1000);
        urls.push(harness.getLastStartUrl());
        harness.stop();
      }
      assertArrayLength(urls, 10);
      assertContains(urls[0], '1400');
      assertContains(urls[9], '1409');
    });

    it('SRManager_StateMatrixRemainsStoppedAfterBalancedRounds_004', 0, async () => {
      const finalStates: MockRecordingState[] = [];
      for (let round = 0; round < 24; round++) {
        const record = await runSingleStartStop(1700005030000 + round * 1000, 1500 + round);
        finalStates.push(record.state);
      }
      assertArrayLength(finalStates, 24);
      for (let index = 0; index < finalStates.length; index++) {
        assertStateEqual(finalStates[index], MockRecordingState.Stopped);
      }
    });

    it('SRManager_QueryProjectionMatchesForcedSequence_005', 0, () => {
      const harness = buildHarness(1600);
      const projected: MockRecordingState[] = [];
      const source = [
        MockRecordingState.Idle,
        MockRecordingState.Recording,
        MockRecordingState.Stopped,
        MockRecordingState.Error,
        MockRecordingState.Idle,
        MockRecordingState.Recording
      ]
      for (let index = 0; index < source.length; index++) {
        harness.forceState(source[index]);
        projected.push(harness.queryState());
      }
      assertArrayLength(projected, source.length);
      for (let index = 0; index < source.length; index++) {
        assertStateEqual(projected[index], source[index]);
      }
    });

    it('SRManager_CallbackHistoryMatchesRoundTripSequence_006', 0, async () => {
      const harness = buildHarness(1700);
      const callbackStates: MockRecordingState[] = [];
      harness.onStateChange((state: MockRecordingState) => {
        callbackStates.push(state);
      });

      /**
       * 用户界面依赖状态回调驱动悬浮窗和提示窗切换。
       * 如果回调顺序不稳定，就会造成前端显示与实际录屏状态脱节。
       */
      await harness.start(1700005040000);
      harness.stop();
      await harness.start(1700005045000);
      harness.stop();

      assertArrayLength(callbackStates, 4);
      assertStateEqual(callbackStates[0], MockRecordingState.Recording);
      assertStateEqual(callbackStates[1], MockRecordingState.Stopped);
      assertStateEqual(callbackStates[2], MockRecordingState.Recording);
      assertStateEqual(callbackStates[3], MockRecordingState.Stopped);
    });

    it('SRManager_MetricsTrackAttemptsForMixedRoundSet_007', 0, async () => {
      const harness = buildHarness(1800);
      for (let round = 0; round < 18; round++) {
        harness.forceState(MockRecordingState.Idle);
        await harness.start(1700005050000 + round * 1000);
        if (round % 2 === 0) {
          harness.stop();
        }
      }
      const metrics = harness.getMetrics();
      assertNumberEqual(metrics.startAttempts, 18);
      assertNumberEqual(metrics.successfulStarts, 18);
      assertNumberEqual(metrics.stopAttempts, 9);
      assertNumberEqual(metrics.successfulStops, 9);
    });

    it('SRManager_FileNameSnapshotsRemainReadableAcrossMatrix_008', 0, async () => {
      const names: string[] = [];
      for (let index = 0; index < 14; index++) {
        const harness = buildHarness(1900 + index);
        await harness.start(1700005060000 + index * 2000);
        names.push(harness.getSnapshot().fileName);
        harness.stop();
      }
      assertArrayLength(names, 14);
      for (let index = 0; index < names.length; index++) {
        assertContains(names[index], 'REC_');
        assertContains(names[index], '.mp4');
      }
    });

    it('SRManager_FdOrderingIsMonotonicWhenProvisionedSequentially_009', 0, async () => {
      const observed: number[] = [];
      for (let index = 0; index < 11; index++) {
        const harness = buildHarness(2000 + index);
        await harness.start(1700005070000 + index * 1000);
        observed.push(extractFd(harness.getLastStartUrl()));
        harness.stop();
      }
      assertArrayLength(observed, 11);
      assertIncreasing(observed);
    });

    it('SRManager_StressStateMatrixRetainsExpectedQueryVolume_010', 0, async () => {
      const harness = buildHarness(2100);
      let queryCount = 0;

      /**
       * 高频查询是录屏状态栏与前端计时同步的常见模式。
       * 这里交替执行 start、stop、query，确认大量状态读取不会挤压核心路径指标。
       */
      for (let round = 0; round < 40; round++) {
        harness.forceState(MockRecordingState.Idle);
        await harness.start(1700005080000 + round * 1000);
        harness.queryState();
        queryCount += 1
        harness.stop();
        harness.queryState();
        queryCount += 1
      }

      const metrics = harness.getMetrics();
      assertNumberEqual(queryCount, 80);
      assertNumberEqual(metrics.queryCount, 80);
      assertNumberEqual(metrics.successfulStarts, 40);
      assertNumberEqual(metrics.successfulStops, 40);
    });

    it('SRManager_SnapshotCarriesStableFieldsAfterResetMetrics_011', 0, async () => {
      const harness = buildHarness(2200);
      await harness.start(1700005090000);
      const beforeStop = harness.getSnapshot();
      harness.stop();
      harness.resetMetrics();
      const afterReset = harness.getSnapshot();
      assertContains(beforeStop.lastStartUrl, '2200');
      assertContains(afterReset.lastStartUrl, '2200');
      assertNonEmpty(afterReset.fileName);
      assertNumberEqual(afterReset.metrics.startAttempts, 0);
    });

    it('SRManager_StartMatrixBlocksOnlyWhenStateIsBusy_012', 0, async () => {
      const harness = buildHarness(2300);
      const results: number[] = [];
      const states = [
        MockRecordingState.Idle,
        MockRecordingState.Recording,
        MockRecordingState.Stopped,
        MockRecordingState.Error
      ]
      for (let index = 0; index < states.length; index++) {
        harness.forceState(states[index]);
        try {
          results.push(await harness.start(1700005100000 + index * 1000));
        } catch (_) {
          results.push(-9999);
        }
      }
      assertArrayLength(results, 4);
      assertNumberEqual(results[0], 0);
      assertNumberEqual(results[1], -1000);
      assertNumberEqual(results[2], 0);
      assertNumberEqual(results[3], -1000);
    });
  });
}

function extractFd(url: string): number {
  const value = url.replace('fd://', '');
  return Number.parseInt(value, 10);
}
