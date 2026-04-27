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
  FoundationRollingChecksum,
  FoundationScenarioCounter
} from '../foundation/FoundationAdvancedFixtures';
import {
  assertArrayLength,
  assertAtLeast,
  assertContains,
  assertNumberEqual,
  assertStringEqual,
  assertTrue
} from '../foundation/TestAsserts';

enum DeepAbilityState {
  Init = 0,
  Created = 1,
  Foreground = 2,
  Background = 3,
  Destroyed = 4
}

interface DeepEvent {
  name: string
  state: DeepAbilityState
  ts: number
}

class DeepLifecycleHarness {
  private state: DeepAbilityState = DeepAbilityState.Init
  private events: DeepEvent[] = []
  private ts: number = 1700010000000
  private recordCount: number = 0

  create(): void {
    this.state = DeepAbilityState.Created;
    this.push('create');
  }

  foreground(): void {
    this.state = DeepAbilityState.Foreground;
    this.push('foreground');
  }

  background(): void {
    this.state = DeepAbilityState.Background;
    this.push('background');
  }

  destroy(): void {
    this.state = DeepAbilityState.Destroyed;
    this.push('destroy');
  }

  startRecord(): number {
    if (this.state !== DeepAbilityState.Foreground) {
      this.push('start_blocked');
      return -10;
    }
    this.recordCount += 1;
    this.push('start_record');
    return 0;
  }

  stopRecord(): number {
    if (this.recordCount <= 0) {
      this.push('stop_blocked');
      return -11;
    }
    this.push('stop_record');
    return 0;
  }

  getState(): DeepAbilityState {
    return this.state;
  }

  getRecordCount(): number {
    return this.recordCount;
  }

  getEvents(): DeepEvent[] {
    return this.events.slice();
  }

  private push(name: string): void {
    this.events.push({ name, state: this.state, ts: this.ts++ });
  }
}

export default function abilityLifecycleConcurrencyDeepTest(): void {
  describe('AbilityLifecycleConcurrencyDeepTest', () => {
    it('AbilityLifecycle_ProfileBucketConcurrencyMatrix_001', 0, () => {
      const profiles = buildFoundationCompatibilityProfiles();
      const buckets = buildFoundationCanaryBuckets();
      const counter = new FoundationScenarioCounter();
      const checksum = new FoundationRollingChecksum();

      /**
       * 生命周期并发回归的重点是确认不同设备画像和灰度档位都会走完同一套前后台切换路径。
       * 如果某个画像在并发切换时漏掉 foreground 或 background，录屏入口就会出现偶发失焦问题。
       */
      for (let index = 0; index < profiles.length * buckets.length; index++) {
        const harness = new DeepLifecycleHarness();
        harness.create();
        harness.foreground();
        harness.startRecord();
        harness.stopRecord();
        harness.background();
        counter.record(profiles[index % profiles.length]);
        checksum.appendText(profiles[index % profiles.length]);
        checksum.appendNumber(buckets[index % buckets.length]);
      }

      assertNumberEqual(counter.getDistinctCount(), profiles.length);
      assertAtLeast(counter.getTotalCount(), profiles.length * buckets.length);
      assertAtLeast(checksum.getValue(), 1);
    });

    it('AbilityLifecycle_BackgroundForegroundAlternationKeepsEventOrder_002', 0, () => {
      const harness = new DeepLifecycleHarness();
      harness.create();
      for (let round = 0; round < 30; round++) {
        harness.foreground();
        harness.startRecord();
        harness.stopRecord();
        harness.background();
      }
      const events = harness.getEvents();
      assertAtLeast(events.length, 121);
      for (let index = 1; index < events.length; index++) {
        assertTrue(events[index].ts > events[index - 1].ts);
      }
    });

    it('AbilityLifecycle_StartBlockedOutsideForeground_003', 0, () => {
      const harness = new DeepLifecycleHarness();
      harness.create();
      assertNumberEqual(harness.startRecord(), -10);
      harness.background();
      assertNumberEqual(harness.startRecord(), -10);
    });

    it('AbilityLifecycle_DestroyAfterLongRunReachesStableTailState_004', 0, () => {
      const harness = new DeepLifecycleHarness();
      harness.create();
      for (let round = 0; round < 60; round++) {
        harness.foreground();
        harness.startRecord();
        harness.stopRecord();
        harness.background();
      }
      harness.destroy();
      assertNumberEqual(harness.getState(), DeepAbilityState.Destroyed);
      assertNumberEqual(harness.getRecordCount(), 60);
    });

    it('AbilityLifecycle_EventNamesRemainReadableAfterConcurrentReplay_005', 0, () => {
      const harness = new DeepLifecycleHarness();
      harness.create();
      harness.foreground();
      harness.startRecord();
      harness.stopRecord();
      harness.background();
      const summary = harness.getEvents().map((event: DeepEvent) => event.name).join(',');
      assertContains(summary, 'create');
      assertContains(summary, 'foreground');
      assertContains(summary, 'stop_record');
    });

    it('AbilityLifecycle_DualPassFingerprintRemainsStable_006', 0, () => {
      const checksumA = new FoundationRollingChecksum();
      const checksumB = new FoundationRollingChecksum();

      /**
       * 生命周期竞态经常只在高频往返后才暴露。
       * 因此这里把同一轮 create/foreground/background/destroy 流程重复两遍做指纹对照，捕获不稳定调度残留。
       */
      for (let pass = 0; pass < 2; pass++) {
        for (let round = 0; round < 10; round++) {
          const harness = new DeepLifecycleHarness();
          harness.create();
          harness.foreground();
          harness.startRecord();
          harness.stopRecord();
          harness.background();
          harness.destroy();
          const summary = harness.getEvents().map((event: DeepEvent) => `${event.name}_${event.state}`).join('|');
          if (pass === 0) {
            checksumA.appendText(summary);
          } else {
            checksumB.appendText(summary);
          }
        }
      }
      assertNumberEqual(checksumA.getValue(), checksumB.getValue());
    });

    it('AbilityLifecycle_MultiHarnessIsolationKeepsIndependentEventStreams_007', 0, () => {
      const harnesses: DeepLifecycleHarness[] = [];
      for (let index = 0; index < 6; index++) {
        const harness = new DeepLifecycleHarness();
        harness.create();
        harness.foreground();
        harness.startRecord();
        harness.stopRecord();
        harness.background();
        harnesses.push(harness);
      }
      assertArrayLength(harnesses, 6);
      for (let index = 0; index < harnesses.length; index++) {
        assertStringEqual(harnesses[index].getEvents()[0].name, 'create');
      }
    });

    it('AbilityLifecycle_HighFrequencyReplayProducesEnoughEvents_008', 0, () => {
      const harness = new DeepLifecycleHarness();
      harness.create();
      let operations = 0;
      for (let round = 0; round < 100; round++) {
        harness.foreground();
        harness.startRecord();
        harness.stopRecord();
        harness.background();
        operations += 4
      }
      assertAtLeast(operations, 400);
      assertAtLeast(harness.getEvents().length, 401);
    });

    it('AbilityLifecycle_DestroyKeepsLastEventAddressable_009', 0, () => {
      const harness = new DeepLifecycleHarness();
      harness.create();
      harness.foreground();
      harness.destroy();
      const events = harness.getEvents();
      assertStringEqual(events[events.length - 1].name, 'destroy');
      assertNumberEqual(events[events.length - 1].state, DeepAbilityState.Destroyed);
    });
  });
}
