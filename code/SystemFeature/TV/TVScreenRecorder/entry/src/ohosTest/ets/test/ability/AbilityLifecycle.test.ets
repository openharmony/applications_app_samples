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
import { assertArrayLength, assertAtLeast, assertContains, assertNumberEqual, assertTrue } from '../foundation/TestAsserts';

enum AbilityState {
  Init = 0,
  Created = 1,
  Foreground = 2,
  Background = 3,
  Destroyed = 4
}

interface AbilityEvent {
  name: string
  value: string
  ts: number
}

class AbilityLifecycleHarness {
  private state: AbilityState = AbilityState.Init
  private events: AbilityEvent[] = []
  private now: number = 1700000000000
  private startCount: number = 0
  private stopCount: number = 0
  private throwOnCreate: boolean = false
  private throwOnForeground: boolean = false

  setThrowOnCreate(value: boolean): void {
    this.throwOnCreate = value
  }

  setThrowOnForeground(value: boolean): void {
    this.throwOnForeground = value
  }

  onCreate(bundleName: string): number {
    if (this.throwOnCreate) {
      this.push('onCreate', 'error')
      return -1
    }
    this.state = AbilityState.Created
    this.push('onCreate', bundleName)
    return 0
  }

  onForeground(reason: string): number {
    if (this.throwOnForeground) {
      this.push('onForeground', 'error')
      return -2
    }
    this.state = AbilityState.Foreground
    this.push('onForeground', reason)
    return 0
  }

  onBackground(reason: string): number {
    this.state = AbilityState.Background
    this.push('onBackground', reason)
    return 0
  }

  onDestroy(reason: string): number {
    this.state = AbilityState.Destroyed
    this.push('onDestroy', reason)
    return 0
  }

  startRecord(): number {
    if (this.state !== AbilityState.Foreground) {
      return -10
    }
    this.startCount += 1
    this.push('startRecord', `${this.startCount}`)
    return 0
  }

  stopRecord(): number {
    if (this.startCount <= this.stopCount) {
      return -11
    }
    this.stopCount += 1
    this.push('stopRecord', `${this.stopCount}`)
    return 0
  }

  getState(): AbilityState {
    return this.state
  }

  getEvents(): AbilityEvent[] {
    return this.events.slice()
  }

  getStartCount(): number {
    return this.startCount
  }

  getStopCount(): number {
    return this.stopCount
  }

  private push(name: string, value: string): void {
    this.events.push({ name, value, ts: this.now++ })
  }
}

export default function abilityLifecycleTest(): void {
  describe('AbilityLifecycleTest', () => {
    it('Ability_LifecycleHappyPath_001', 0, () => {
      const harness = new AbilityLifecycleHarness();
      assertNumberEqual(harness.onCreate('ohos.samples.screenrecorder'), 0);
      assertNumberEqual(harness.onForeground('launch'), 0);
      assertNumberEqual(harness.startRecord(), 0);
      assertNumberEqual(harness.stopRecord(), 0);
      assertNumberEqual(harness.onBackground('home'), 0);
      assertNumberEqual(harness.onDestroy('finish'), 0);
      assertNumberEqual(harness.getState(), AbilityState.Destroyed);
      assertNumberEqual(harness.getStartCount(), 1);
      assertNumberEqual(harness.getStopCount(), 1);
    });

    it('Ability_StartBeforeForeground_002', 0, () => {
      const harness = new AbilityLifecycleHarness();
      harness.onCreate('ohos.samples.screenrecorder');
      const code = harness.startRecord();
      assertNumberEqual(code, -10);
    });

    it('Ability_StopWithoutStart_003', 0, () => {
      const harness = new AbilityLifecycleHarness();
      harness.onCreate('ohos.samples.screenrecorder');
      harness.onForeground('resume');
      const code = harness.stopRecord();
      assertNumberEqual(code, -11);
    });

    it('Ability_CreateFailure_004', 0, () => {
      const harness = new AbilityLifecycleHarness();
      harness.setThrowOnCreate(true);
      const code = harness.onCreate('ohos.samples.screenrecorder');
      assertNumberEqual(code, -1);
      const events = harness.getEvents();
      assertArrayLength(events, 1);
      assertContains(events[0].value, 'error');
    });

    it('Ability_ForegroundFailure_005', 0, () => {
      const harness = new AbilityLifecycleHarness();
      harness.onCreate('ohos.samples.screenrecorder');
      harness.setThrowOnForeground(true);
      const code = harness.onForeground('launch');
      assertNumberEqual(code, -2);
      assertNumberEqual(harness.getState(), AbilityState.Created);
    });

    it('Ability_RepeatedStartStop_006', 0, () => {
      const harness = new AbilityLifecycleHarness();
      harness.onCreate('ohos.samples.screenrecorder');
      harness.onForeground('launch');
      for (let i = 0; i < 40; i++) {
        assertNumberEqual(harness.startRecord(), 0);
        assertNumberEqual(harness.stopRecord(), 0);
      }
      assertNumberEqual(harness.getStartCount(), 40);
      assertNumberEqual(harness.getStopCount(), 40);
      const events = harness.getEvents();
      assertAtLeast(events.length, 82);
    });

    it('Ability_BackgroundRecovery_007', 0, () => {
      const harness = new AbilityLifecycleHarness();
      harness.onCreate('ohos.samples.screenrecorder');
      harness.onForeground('first');
      harness.startRecord();
      harness.stopRecord();
      harness.onBackground('switch');
      harness.onForeground('return');
      assertNumberEqual(harness.startRecord(), 0);
      assertNumberEqual(harness.stopRecord(), 0);
      assertNumberEqual(harness.getStartCount(), 2);
      assertNumberEqual(harness.getStopCount(), 2);
    });

    it('Ability_EventTimeOrder_008', 0, () => {
      const harness = new AbilityLifecycleHarness();
      harness.onCreate('ohos.samples.screenrecorder');
      harness.onForeground('launch');
      harness.startRecord();
      harness.stopRecord();
      harness.onBackground('home');
      harness.onDestroy('finish');
      const events = harness.getEvents();
      for (let i = 1; i < events.length; i++) {
        assertTrue(events[i].ts > events[i - 1].ts);
      }
    });

    it('Ability_LongSessionState_009', 0, () => {
      const harness = new AbilityLifecycleHarness();
      harness.onCreate('ohos.samples.screenrecorder');
      for (let i = 0; i < 120; i++) {
        harness.onForeground(`fg_${i}`);
        harness.startRecord();
        harness.stopRecord();
        harness.onBackground(`bg_${i}`);
      }
      harness.onDestroy('done');
      assertNumberEqual(harness.getState(), AbilityState.Destroyed);
      assertNumberEqual(harness.getStartCount(), 120);
      assertNumberEqual(harness.getStopCount(), 120);
    });
  });
}
