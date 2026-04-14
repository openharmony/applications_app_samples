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
import { buildCanaryBuckets, buildCompatibilityDevices, buildStressDurationsMs } from '../foundation/TestDataBuilder';
import { createRectSequence, WindowHarness } from './WindowHarness';

export default function floatWindowSceneTest(): void {
  describe('FloatWindowSceneTest', () => {
    it('FloatWindow_TimerAndTipFlow_001', 0, () => {
      const harness = new WindowHarness();
      const openCode = harness.openTimerWindow('timer', 'pages/screenRecorderTimer', { x: 96, y: 48, width: 624, height: 56 });
      assertNumberEqual(openCode, 0);
      let callbackCount = 0;
      const tipCode = harness.popupRecorderTip('tip', 'pages/screenRecorderDialog', { x: 615, y: 46, width: 686, height: 100 }, 3000, () => {
        callbackCount += 1;
      });
      assertNumberEqual(tipCode, 0);
      assertNumberEqual(callbackCount, 1);
      const events = harness.getEvents();
      assertAtLeast(events.length, 4);
    });

    it('FloatWindow_ResolutionNotSupportedFlow_002', 0, () => {
      const harness = new WindowHarness();
      const code = harness.popupRecorderTip(
        'resolution_tip',
        'pages/resolutionNotSupportedDialog',
        { x: 500, y: 50, width: 800, height: 120 },
        2000
      );
      assertNumberEqual(code, 0);
      assertTrue(harness.hasWindow('resolution_tip'));
      assertTrue(harness.isVisible('resolution_tip') === false);
    });

    it('FloatWindow_StressPopup_003', 0, () => {
      const harness = new WindowHarness();
      let callbackCount = 0;
      for (let i = 0; i < 80; i++) {
        const code = harness.popupRecorderTip(
          `tip_${i}`,
          'pages/screenRecorderDialog',
          { x: 615, y: 46, width: 686, height: 100 },
          1000,
          () => {
            callbackCount += 1;
          }
        );
        assertNumberEqual(code, 0);
      }
      assertNumberEqual(callbackCount, 80);
      const metrics = harness.getMetrics();
      assertNumberEqual(metrics.hidden, 80);
    });

    it('FloatWindow_CanaryBucketScene_004', 0, () => {
      const harness = new WindowHarness();
      const buckets = buildCanaryBuckets();
      let total = 0;
      for (let i = 0; i < buckets.length; i++) {
        const rounds = i + 5;
        for (let r = 0; r < rounds; r++) {
          const code = harness.openTimerWindow(
            `${buckets[i]}_${r}`,
            'pages/screenRecorderTimer',
            { x: r, y: r, width: 600, height: 56 }
          );
          assertNumberEqual(code, 0);
          total += 1;
        }
      }
      assertAtLeast(total, 40);
      const metrics = harness.getMetrics();
      assertAtLeast(metrics.created, total);
    });

    it('FloatWindow_DeviceCompatibilityScene_005', 0, () => {
      const harness = new WindowHarness();
      const devices = buildCompatibilityDevices();
      for (let i = 0; i < devices.length; i++) {
        const code = harness.openTimerWindow(
          `timer_${devices[i]}`,
          'pages/screenRecorderTimer',
          { x: i * 10, y: i * 10, width: 500 + i * 50, height: 60 + i }
        );
        assertNumberEqual(code, 0);
      }
      assertNumberEqual(harness.getWindowCount(), devices.length);
      const events = harness.getEvents();
      assertAtLeast(events.length, devices.length * 2);
      assertContains(events[0].type, 'create');
    });

    it('FloatWindow_DurationPressureScene_006', 0, () => {
      const harness = new WindowHarness();
      const durations = buildStressDurationsMs();
      let counter = 0;
      for (let i = 0; i < durations.length; i++) {
        const round = durations[i] < 100 ? 20 : 10;
        for (let j = 0; j < round; j++) {
          const code = harness.popupRecorderTip(
            `dur_${i}_${j}`,
            'pages/screenRecorderDialog',
            { x: 615, y: 46, width: 686, height: 100 },
            durations[i]
          );
          assertNumberEqual(code, 0);
          counter += 1;
        }
      }
      assertAtLeast(counter, 100);
      const metrics = harness.getMetrics();
      assertAtLeast(metrics.hidden, counter);
    });

    it('FloatWindow_RectBatchLifecycle_007', 0, () => {
      const harness = new WindowHarness();
      const rects = createRectSequence(120);
      assertArrayLength(rects, 120);
      for (let i = 0; i < rects.length; i++) {
        const code = harness.openTimerWindow(`batch_${i}`, 'pages/screenRecorderTimer', rects[i]);
        assertNumberEqual(code, 0);
        if (i % 2 === 0) {
          harness.hide(`batch_${i}`);
        }
        if (i % 3 === 0) {
          harness.destroy(`batch_${i}`);
        }
      }
      const metrics = harness.getMetrics();
      assertAtLeast(metrics.created, 120);
      assertAtLeast(metrics.hidden, 60);
      assertAtLeast(metrics.destroyed, 40);
    });

    it('FloatWindow_ErrorInjectionMatrix_008', 0, () => {
      const harness = new WindowHarness();
      const createCode1 = harness.openTimerWindow('a', 'pages/screenRecorderTimer', { x: 0, y: 0, width: 10, height: 10 });
      assertNumberEqual(createCode1, 0);
      harness.setThrowOnLoad(true);
      const loadCode = harness.openTimerWindow('b', 'pages/screenRecorderTimer', { x: 0, y: 0, width: 10, height: 10 });
      assertNumberEqual(loadCode, -2);
      harness.setThrowOnLoad(false);
      harness.setThrowOnShow(true);
      const showCode = harness.openTimerWindow('c', 'pages/screenRecorderTimer', { x: 0, y: 0, width: 10, height: 10 });
      assertNumberEqual(showCode, -3);
      harness.setThrowOnShow(false);
      harness.setThrowOnCreate(true);
      const createCode2 = harness.openTimerWindow('d', 'pages/screenRecorderTimer', { x: 0, y: 0, width: 10, height: 10 });
      assertNumberEqual(createCode2, -1);
    });

    it('FloatWindow_LongRunningMixedScene_009', 0, () => {
      const harness = new WindowHarness();
      let opCount = 0;
      for (let round = 0; round < 200; round++) {
        const name = `mix_${round}`;
        const openCode = harness.openTimerWindow(name, round % 2 === 0 ? 'pages/screenRecorderTimer' : 'pages/screenRecorderDialog', {
          x: round,
          y: round,
          width: 400 + (round % 50),
          height: 40 + (round % 10)
        });
        assertNumberEqual(openCode, 0);
        if (round % 5 === 0) {
          harness.hide(name);
        }
        if (round % 7 === 0) {
          harness.destroy(name);
        }
        opCount += 1;
      }
      assertNumberEqual(opCount, 200);
      const metrics = harness.getMetrics();
      assertAtLeast(metrics.created, 200);
      assertAtLeast(metrics.moveCalls, 200);
      assertAtLeast(metrics.resizeCalls, 200);
      assertAtLeast(metrics.loadCalls, 200);
    });
  });
}
