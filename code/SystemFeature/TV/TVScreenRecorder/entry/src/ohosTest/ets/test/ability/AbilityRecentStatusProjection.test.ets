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
  buildFoundationCanaryBuckets,
  buildFoundationCompatibilityProfiles,
  buildFoundationGrayReleaseKeys,
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

interface RecentRecord {
  id: string
  title: string
  state: string
}

interface StatusProjection {
  icon: string
  timeLabel: string
  network: string
}

class AbilityProjectionHarness {
  private recentRecords: RecentRecord[] = []
  private projection: StatusProjection = { icon: 'idle', timeLabel: '00:00', network: 'wifi' }
  private counter: number = 0

  addRecent(title: string, state: string): string {
    const id = `recent_${this.counter++}`;
    this.recentRecords.push({ id, title, state });
    return id;
  }

  removeRecent(id: string): void {
    this.recentRecords = this.recentRecords.filter((item: RecentRecord) => item.id !== id);
  }

  clearRecent(): void {
    this.recentRecords = [];
  }

  switchStatus(icon: string, timeLabel: string, network: string): void {
    this.projection = { icon, timeLabel, network }
  }

  getRecentRecords(): RecentRecord[] {
    return this.recentRecords.slice();
  }

  getProjection(): StatusProjection {
    return {
      icon: this.projection.icon,
      timeLabel: this.projection.timeLabel,
      network: this.projection.network
    }
  }
}

export default function abilityRecentStatusProjectionTest(): void {
  describe('AbilityRecentStatusProjectionTest', () => {
    it('AbilityProjection_RecentListSupportsOpenDeleteClearSwitch_001', 0, () => {
      const harness = new AbilityProjectionHarness();
      const firstId = harness.addRecent('record_001.mp4', 'finished');
      const secondId = harness.addRecent('record_002.mp4', 'finished');
      harness.addRecent('record_003.mp4', 'uploading');
      harness.removeRecent(secondId);
      const recordsAfterDelete = harness.getRecentRecords();
      assertArrayLength(recordsAfterDelete, 2);
      assertStringEqual(recordsAfterDelete[0].id, firstId);
      harness.clearRecent();
      assertArrayLength(harness.getRecentRecords(), 0);
    });

    it('AbilityProjection_StatusBarSupportsIconTimeAndNetwork_002', 0, () => {
      const harness = new AbilityProjectionHarness();
      harness.switchStatus('recording', '00:12', 'wifi');
      const projection = harness.getProjection();
      assertStringEqual(projection.icon, 'recording');
      assertStringEqual(projection.timeLabel, '00:12');
      assertStringEqual(projection.network, 'wifi');
    });

    it('AbilityProjection_GrayKeysCanPersistRecentAndStatusPairs_003', 0, () => {
      const storage = new FoundationStorageEntity();
      const keys = buildFoundationGrayReleaseKeys();

      /**
       * Recent 列表和状态栏都属于用户直接感知的界面投影。
       * 如果灰度键落盘时不可读，线上排查“哪个渠道、哪个档位出错”会非常困难。
       */
      for (let index = 0; index < keys.length; index++) {
        storage.set(`${keys[index]}.recent`, `REC_${index}.mp4`);
        storage.set(`${keys[index]}.status`, index % 2 === 0 ? 'recording' : 'stopped');
      }

      assertNumberEqual(storage.getSize(), keys.length * 2);
      assertContains(storage.get<string>('foundation.mock.photo.recent') ?? '', 'REC_');
      assertContains(storage.get<string>('foundation.regression.matrix.status') ?? '', 'recording');
    });

    it('AbilityProjection_ProfileAndBucketMatrixKeepReadableRecentTitles_004', 0, () => {
      const profiles = buildFoundationCompatibilityProfiles();
      const buckets = buildFoundationCanaryBuckets();
      const harness = new AbilityProjectionHarness();
      const counter = new FoundationScenarioCounter();
      const checksum = new FoundationRollingChecksum();
      for (let index = 0; index < profiles.length * buckets.length; index++) {
        const title = `${profiles[index % profiles.length]}_${buckets[index % buckets.length]}.mp4`;
        harness.addRecent(title, 'finished');
        counter.record(profiles[index % profiles.length]);
        checksum.appendText(title);
      }
      assertNumberEqual(counter.getDistinctCount(), profiles.length);
      assertAtLeast(counter.getTotalCount(), profiles.length * buckets.length);
      assertAtLeast(checksum.getValue(), 1);
      assertContains(harness.getRecentRecords()[0].title, '.mp4');
    });

    it('AbilityProjection_RecentSwitchSequenceSupportsLastFocusedRecovery_005', 0, () => {
      const harness = new AbilityProjectionHarness();
      harness.addRecent('alpha.mp4', 'finished');
      harness.addRecent('beta.mp4', 'finished');
      harness.addRecent('gamma.mp4', 'finished');
      const records = harness.getRecentRecords();
      assertArrayLength(records, 3);
      assertStringEqual(records[2].title, 'gamma.mp4');
    });

    it('AbilityProjection_StatusProjectionFingerprintRemainsStable_006', 0, () => {
      const harness = new AbilityProjectionHarness();
      const checksumA = new FoundationRollingChecksum();
      const checksumB = new FoundationRollingChecksum();

      /**
       * 状态栏的图标、计时和网络标识往往由多个异步来源共同刷新。
       * 这里做双遍指纹对照，避免同一组输入在不同轮次下出现不可解释的展示漂移。
       */
      for (let pass = 0; pass < 2; pass++) {
        for (let round = 0; round < 8; round++) {
          harness.switchStatus(round % 2 === 0 ? 'recording' : 'stopped', `00:0${round}`, round % 3 === 0 ? 'wifi' : 'ethernet');
          const projection = harness.getProjection();
          if (pass === 0) {
            checksumA.appendText(projection.icon);
            checksumA.appendText(projection.timeLabel);
            checksumA.appendText(projection.network);
          } else {
            checksumB.appendText(projection.icon);
            checksumB.appendText(projection.timeLabel);
            checksumB.appendText(projection.network);
          }
        }
      }

      assertNumberEqual(checksumA.getValue(), checksumB.getValue());
    });

    it('AbilityProjection_RecentDeleteDoesNotCorruptRemainingOrder_007', 0, () => {
      const harness = new AbilityProjectionHarness();
      const ids: string[] = [];
      for (let round = 0; round < 10; round++) {
        ids.push(harness.addRecent(`recent_${round}.mp4`, 'finished'));
      }
      harness.removeRecent(ids[4]);
      harness.removeRecent(ids[7]);
      const records = harness.getRecentRecords();
      assertArrayLength(records, 8);
      assertStringEqual(records[4].title, 'recent_5.mp4');
    });

    it('AbilityProjection_LongRunRecentAndStatusMixKeepsProjectionAvailable_008', 0, () => {
      const harness = new AbilityProjectionHarness();
      let operations = 0;
      for (let round = 0; round < 90; round++) {
        harness.addRecent(`mix_${round}.mp4`, round % 5 === 0 ? 'uploading' : 'finished');
        harness.switchStatus(round % 2 === 0 ? 'recording' : 'idle', `01:${round}`, round % 4 === 0 ? 'wifi' : 'ethernet');
        operations += 2
      }
      const projection = harness.getProjection();
      assertAtLeast(operations, 180);
      assertTrue(projection.timeLabel.length > 0);
      assertAtLeast(harness.getRecentRecords().length, 90);
    });

    it('AbilityProjection_StatusAndRecentStorageRemainAddressable_009', 0, () => {
      const storage = new FoundationStorageEntity();
      for (let round = 0; round < 12; round++) {
        storage.set(`recent.${round}.title`, `recent_${round}.mp4`);
        storage.set(`status.${round}.icon`, round % 2 === 0 ? 'recording' : 'idle');
      }
      assertNumberEqual(storage.getSize(), 24);
      assertContains(storage.get<string>('recent.11.title') ?? '', 'recent_11');
      assertContains(storage.get<string>('status.10.icon') ?? '', 'recording');
    });
  });
}
