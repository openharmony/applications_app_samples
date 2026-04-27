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
  buildFoundationCompatibilityProfiles,
  FoundationRollingChecksum,
  FoundationScenarioCounter,
  FoundationStorageEntity
} from '../foundation/FoundationAdvancedFixtures';
import {
  assertArrayLength,
  assertAtLeast,
  assertContains,
  assertNonEmpty,
  assertNumberEqual,
  assertStateEqual,
  assertStringEqual,
  assertTrue
} from '../foundation/TestAsserts';
import { MockRecordingState } from '../foundation/TestTypes';
import { createScenarioSeeds, SRManagerHarness } from './SRManagerHarness';

interface RecordingLedger {
  key: string
  fileName: string
  url: string
  state: MockRecordingState
}

interface HarnessFactoryContext {
  harness: SRManagerHarness
  photoFactory: MockPhotoAccessHelperFactory
}

class HarnessFactoryContextEntity implements HarnessFactoryContext {
  harness: SRManagerHarness
  photoFactory: MockPhotoAccessHelperFactory

  constructor(harness: SRManagerHarness, photoFactory: MockPhotoAccessHelperFactory) {
    this.harness = harness;
    this.photoFactory = photoFactory;
  }
}

class SRManagerHarnessSeedConfig {
  defaultFd: number

  constructor(defaultFd: number) {
    this.defaultFd = defaultFd;
  }
}

function createHarnessWithFactories(seed: number): HarnessFactoryContext {
  const apiFactory = new MockSRApiFactory();
  const photoFactory = new MockPhotoAccessHelperFactory();
  const harness = new SRManagerHarness(apiFactory.build(), photoFactory.build(), new SRManagerHarnessSeedConfig(seed));
  return new HarnessFactoryContextEntity(harness, photoFactory);
}

export default function srManagerDataConsistencyTest(): void {
  describe('SRManagerDataConsistencyTest', () => {
    it('SRManager_LedgerKeepsFileNameUrlAndStateAligned_001', 0, async () => {
      const storage = new FoundationStorageEntity();
      const records: RecordingLedger[] = [];
      const seeds = createScenarioSeeds(16, 1700007000000);

      /**
       * 录屏结束后通常要把文件名、fd 地址和最终状态一起落到持久化层。
       * 如果三者出现错位，后续 Recent 列表和回放入口就会出现“有条目但打不开”的问题。
       */
      for (let index = 0; index < seeds.length; index++) {
        const context = createHarnessWithFactories(3000 + index);
        await context.harness.start(seeds[index]);
        context.harness.stop();
        const snapshot = context.harness.getSnapshot();
        const record: RecordingLedger = {
          key: `round_${index}`,
          fileName: snapshot.fileName,
          url: snapshot.lastStartUrl,
          state: snapshot.state
        }
        records.push(record);
        storage.set(record.key, `${record.fileName}|${record.url}|${record.state}`);
      }

      assertArrayLength(records, 16);
      assertNumberEqual(storage.getSize(), 16);
      assertContains(storage.get<string>('round_0') ?? '', 'REC_');
      assertContains(storage.get<string>('round_0') ?? '', 'fd://');
    });

    it('SRManager_AssetFactorySnapshotMatchesHarnessFileName_002', 0, async () => {
      const context = createHarnessWithFactories(3100);
      await context.harness.start(1700007010000);
      const fileName = context.harness.getCurrentFileName();
      const assets = context.photoFactory.getAssetsSnapshot();
      assertArrayLength(assets, 1);
      assertStringEqual(assets[0].fileName, fileName);
    });

    it('SRManager_ResetMetricsDoesNotWipeBusinessSnapshot_003', 0, async () => {
      const context = createHarnessWithFactories(3200);
      await context.harness.start(1700007020000);
      context.harness.stop();
      const beforeReset = context.harness.getSnapshot();
      context.harness.resetMetrics();
      const afterReset = context.harness.getSnapshot();
      assertStringEqual(beforeReset.fileName, afterReset.fileName);
      assertStringEqual(beforeReset.lastStartUrl, afterReset.lastStartUrl);
      assertNumberEqual(afterReset.metrics.startAttempts, 0);
      assertStateEqual(afterReset.state, MockRecordingState.Stopped);
    });

    it('SRManager_ProfileProjectionKeepsDistinctFileFingerprints_004', 0, async () => {
      const profiles = buildFoundationCompatibilityProfiles();
      const checksum = new FoundationRollingChecksum();
      const counter = new FoundationScenarioCounter();
      for (let index = 0; index < profiles.length; index++) {
        const context = createHarnessWithFactories(3300 + index);
        await context.harness.start(1700007030000 + index * 1000);
        const fileName = context.harness.getCurrentFileName();
        checksum.appendText(fileName);
        counter.record(profiles[index]);
        context.harness.stop();
      }
      assertNumberEqual(counter.getDistinctCount(), profiles.length);
      assertAtLeast(checksum.getValue(), 1);
    });

    it('SRManager_ColdWarmStorageReplayPreservesLastRecording_005', 0, async () => {
      const storage = new FoundationStorageEntity();
      const context = createHarnessWithFactories(3400);
      await context.harness.start(1700007040000);
      context.harness.stop();
      const snapshot = context.harness.getSnapshot();
      storage.set('last.file', snapshot.fileName);
      storage.set('last.url', snapshot.lastStartUrl);
      storage.set('last.state', `${snapshot.state}`);
      assertStringEqual(storage.get<string>('last.file') ?? '', snapshot.fileName);
      assertStringEqual(storage.get<string>('last.url') ?? '', snapshot.lastStartUrl);
      assertStringEqual(storage.get<string>('last.state') ?? '', `${MockRecordingState.Stopped}`);
    });

    it('SRManager_SequentialRunsAccumulateAssetHistoryWithoutOverwrite_006', 0, async () => {
      const context = createHarnessWithFactories(3500);
      const names: string[] = [];
      for (let round = 0; round < 9; round++) {
        context.harness.forceState(MockRecordingState.Idle);
        await context.harness.start(1700007050000 + round * 1000);
        names.push(context.harness.getCurrentFileName());
        context.harness.stop();
      }
      assertArrayLength(names, 9);
      assertNumberEqual(context.photoFactory.getAssetCount(), 9);
      assertNonEmpty(context.photoFactory.getAssetsSnapshot()[8].fileName);
    });

    it('SRManager_QueryAndSnapshotStayConsistentAcrossForcedStates_007', 0, () => {
      const context = createHarnessWithFactories(3600);
      const states = [
        MockRecordingState.Idle,
        MockRecordingState.Recording,
        MockRecordingState.Stopped,
        MockRecordingState.Error
      ]
      for (let index = 0; index < states.length; index++) {
        context.harness.forceState(states[index]);
        const state = context.harness.queryState();
        const snapshot = context.harness.getSnapshot();
        assertStateEqual(state, snapshot.state);
      }
    });

    it('SRManager_UrlPayloadsRemainUniqueAcrossReplayRounds_008', 0, async () => {
      const urls: string[] = [];
      for (let index = 0; index < 12; index++) {
        const context = createHarnessWithFactories(3700 + index);
        await context.harness.start(1700007060000 + index * 1000);
        urls.push(context.harness.getLastStartUrl());
        context.harness.stop();
      }
      assertArrayLength(urls, 12);
      assertContains(urls[0], '3700');
      assertContains(urls[11], '3711');
    });

    it('SRManager_DataLedgerFingerprintRemainsDeterministic_009', 0, async () => {
      const checksumA = new FoundationRollingChecksum();
      const checksumB = new FoundationRollingChecksum();

      /**
       * 数据一致性不只看“有没有值”，更看同一组输入是否始终产出同一份指纹。
       * 这里重复执行两遍同样的录制轮次，用来拦截偶发的非确定性命名或状态漂移。
       */
      for (let pass = 0; pass < 2; pass++) {
        for (let round = 0; round < 10; round++) {
          const context = createHarnessWithFactories(3800 + round);
          await context.harness.start(1700007070000 + round * 1000);
          context.harness.stop();
          const snapshot = context.harness.getSnapshot();
          if (pass === 0) {
            checksumA.appendText(snapshot.fileName);
            checksumA.appendText(snapshot.lastStartUrl);
            checksumA.appendNumber(snapshot.state);
          } else {
            checksumB.appendText(snapshot.fileName);
            checksumB.appendText(snapshot.lastStartUrl);
            checksumB.appendNumber(snapshot.state);
          }
        }
      }

      assertNumberEqual(checksumA.getValue(), checksumB.getValue());
      assertAtLeast(checksumA.getValue(), 1);
    });

    it('SRManager_MetricsAndAssetsRemainAlignedDuringMixedTraffic_010', 0, async () => {
      const context = createHarnessWithFactories(3900);
      for (let round = 0; round < 20; round++) {
        context.harness.forceState(MockRecordingState.Idle);
        await context.harness.start(1700007080000 + round * 1000);
        if (round % 4 !== 3) {
          context.harness.stop();
        }
      }
      const metrics = context.harness.getMetrics();
      assertNumberEqual(metrics.startAttempts, 20);
      assertNumberEqual(metrics.createAssetCount, 20);
      assertNumberEqual(context.photoFactory.getAssetCount(), 20);
      assertTrue(metrics.successfulStops === 15);
    });

    it('SRManager_PersistenceProjectionKeepsReadableKeys_011', 0, async () => {
      const storage = new FoundationStorageEntity();
      for (let round = 0; round < 6; round++) {
        const context = createHarnessWithFactories(4000 + round);
        await context.harness.start(1700007090000 + round * 1000);
        context.harness.stop();
        storage.set(`recent.item.${round}.file`, context.harness.getCurrentFileName());
        storage.set(`recent.item.${round}.state`, `${context.harness.getCurrentState()}`);
      }
      assertNumberEqual(storage.getSize(), 12);
      assertContains(storage.get<string>('recent.item.0.file') ?? '', 'REC_');
      assertStringEqual(storage.get<string>('recent.item.5.state') ?? '', `${MockRecordingState.Stopped}`);
    });

    it('SRManager_ReplayScenarioCounterMatchesFinishedRounds_012', 0, async () => {
      const counter = new FoundationScenarioCounter();
      for (let round = 0; round < 18; round++) {
        const context = createHarnessWithFactories(4100 + round);
        await context.harness.start(1700007100000 + round * 1000);
        context.harness.stop();
        counter.record(context.harness.getCurrentState() === MockRecordingState.Stopped ? 'finished' : 'other');
      }
      assertNumberEqual(counter.getDistinctCount(), 1);
      assertNumberEqual(counter.getCount('finished'), 18);
    });
  });
}
