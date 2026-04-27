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
import { WindowHarness } from './WindowHarness';

interface StatusRecord {
  icon: string
  timer: string
  network: string
}

class WindowStatusHarness {
  private status: StatusRecord = { icon: 'idle', timer: '00:00', network: 'wifi' }
  private records: StatusRecord[] = []

  sync(icon: string, timer: string, network: string): void {
    this.status = { icon, timer, network }
    this.records.push({ icon, timer, network });
  }

  getStatus(): StatusRecord {
    return {
      icon: this.status.icon,
      timer: this.status.timer,
      network: this.status.network
    }
  }

  getRecords(): StatusRecord[] {
    return this.records.slice();
  }
}

export default function windowStatusBarLinkageTest(): void {
  describe('WindowStatusBarLinkageTest', () => {
    it('WindowStatus_TimerWindowAndStatusBarKeepSameTimeLabel_001', 0, () => {
      const harness = new WindowHarness();
      const statusHarness = new WindowStatusHarness();
      const timeLabel = '00:18';
      harness.openTimerWindow('timer', 'pages/ScreenRecorderTimer', { x: 96, y: 48, width: 624, height: 56 });
      statusHarness.sync('recording', timeLabel, 'wifi');
      assertTrue(harness.isVisible('timer'));
      assertStringEqual(statusHarness.getStatus().timer, timeLabel);
    });

    it('WindowStatus_GrayReleaseKeysPersistStatusSnapshots_002', 0, () => {
      const storage = new FoundationStorageEntity();
      const keys = buildFoundationGrayReleaseKeys();
      for (let index = 0; index < keys.length; index++) {
        storage.set(`${keys[index]}.icon`, index % 2 === 0 ? 'recording' : 'idle');
        storage.set(`${keys[index]}.timer`, `00:0${index}`);
      }
      assertNumberEqual(storage.getSize(), keys.length * 2);
      assertContains(storage.get<string>('foundation.mock.input.icon') ?? '', 'recording');
      assertContains(storage.get<string>('foundation.mock.srapi.timer') ?? '', '00:03');
    });

    it('WindowStatus_LinkageRecordsRemainReadableAcrossBursts_003', 0, () => {
      const statusHarness = new WindowStatusHarness();
      const counter = new FoundationScenarioCounter();
      const checksum = new FoundationRollingChecksum();

      /**
       * 悬浮窗与状态栏联动最怕出现展示频率不同步。
       * 因为用户会先看到状态栏计时变化，再看到浮窗延迟刷新，从而误判录屏状态异常。
       */
      for (let round = 0; round < 40; round++) {
        const icon = round % 2 === 0 ? 'recording' : 'paused';
        const timer = `01:${round}`;
        const network = round % 3 === 0 ? 'wifi' : 'ethernet';
        statusHarness.sync(icon, timer, network);
        counter.record(icon);
        checksum.appendText(timer);
        checksum.appendText(network);
      }

      assertArrayLength(statusHarness.getRecords(), 40);
      assertNumberEqual(counter.getDistinctCount(), 2);
      assertAtLeast(checksum.getValue(), 1);
    });

    it('WindowStatus_WindowHideDoesNotEraseStatusProjection_004', 0, () => {
      const harness = new WindowHarness();
      const statusHarness = new WindowStatusHarness();
      harness.openTimerWindow('timer', 'pages/ScreenRecorderTimer', { x: 96, y: 48, width: 624, height: 56 });
      statusHarness.sync('recording', '00:40', 'wifi');
      harness.hide('timer');
      assertTrue(harness.isVisible('timer') === false);
      assertStringEqual(statusHarness.getStatus().icon, 'recording');
      assertStringEqual(statusHarness.getStatus().timer, '00:40');
    });

    it('WindowStatus_PopupTipFlowKeepsPreviousStatusTail_005', 0, () => {
      const harness = new WindowHarness();
      const statusHarness = new WindowStatusHarness();
      statusHarness.sync('recording', '00:59', 'wifi');
      let callbackCount = 0;
      harness.popupRecorderTip('tip', 'pages/ScreenRecorderDialog', { x: 615, y: 46, width: 686, height: 100 }, 3000, () => {
        callbackCount += 1
      });
      assertNumberEqual(callbackCount, 1);
      assertStringEqual(statusHarness.getStatus().timer, '00:59');
    });

    it('WindowStatus_LongRunLinkageFingerprintRemainsStable_006', 0, () => {
      const checksumA = new FoundationRollingChecksum();
      const checksumB = new FoundationRollingChecksum();
      for (let pass = 0; pass < 2; pass++) {
        const statusHarness = new WindowStatusHarness();
        for (let round = 0; round < 14; round++) {
          statusHarness.sync(round % 2 === 0 ? 'recording' : 'idle', `02:${round}`, round % 2 === 0 ? 'wifi' : 'ethernet');
        }
        const summary = statusHarness.getRecords().map((record) => `${record.icon}_${record.timer}_${record.network}`).join('|');
        if (pass === 0) {
          checksumA.appendText(summary);
        } else {
          checksumB.appendText(summary);
        }
      }
      assertNumberEqual(checksumA.getValue(), checksumB.getValue());
    });

    it('WindowStatus_DestroyedWindowAllowsStatusToRemainAddressable_007', 0, () => {
      const harness = new WindowHarness();
      const statusHarness = new WindowStatusHarness();
      harness.openTimerWindow('timer', 'pages/ScreenRecorderTimer', { x: 0, y: 0, width: 100, height: 56 });
      statusHarness.sync('recording', '03:00', 'wifi');
      harness.destroy('timer');
      assertTrue(harness.hasWindow('timer') === false);
      assertStringEqual(statusHarness.getStatus().icon, 'recording');
    });

    it('WindowStatus_BurstStatusSyncProducesEnoughProjectionSamples_008', 0, () => {
      const statusHarness = new WindowStatusHarness();
      let operations = 0;
      for (let round = 0; round < 120; round++) {
        statusHarness.sync(round % 2 === 0 ? 'recording' : 'idle', `04:${round}`, round % 5 === 0 ? 'wifi' : 'ethernet');
        operations += 1
      }
      assertAtLeast(operations, 120);
      assertAtLeast(statusHarness.getRecords().length, 120);
    });

    it('WindowStatus_StorageProjectionKeepsRecentWindowPairs_009', 0, () => {
      const storage = new FoundationStorageEntity();
      for (let round = 0; round < 16; round++) {
        storage.set(`window.${round}.page`, round % 2 === 0 ? 'pages/ScreenRecorderTimer' : 'pages/ScreenRecorderDialog');
        storage.set(`status.${round}.icon`, round % 2 === 0 ? 'recording' : 'idle');
      }
      assertNumberEqual(storage.getSize(), 32);
      assertContains(storage.get<string>('window.15.page') ?? '', 'Dialog');
      assertContains(storage.get<string>('status.14.icon') ?? '', 'recording');
    });
  });
}
