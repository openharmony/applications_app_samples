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
import { buildResolutionMatrix, buildRotationMatrix } from '../foundation/TestDataBuilder';
import { MockWindowRect, MockWindowRectEntity } from '../foundation/TestTypes';
import { createRectSequence, WindowHarness } from './WindowHarness';

export default function windowManagerDomainTest(): void {
  describe('WindowManagerDomainTest', () => {
    it('Window_OpenTimerWindow_001', 0, () => {
      const harness = new WindowHarness();
      const code = harness.openTimerWindow('timer', 'pages/screenRecorderTimer', makeRect(96, 48, 624, 56));
      assertNumberEqual(code, 0);
      assertTrue(harness.hasWindow('timer'));
      assertTrue(harness.isVisible('timer'));
      const metrics = harness.getMetrics();
      assertNumberEqual(metrics.created, 1);
      assertNumberEqual(metrics.shown, 1);
    });

    it('Window_OpenTimerWindowIdempotent_002', 0, () => {
      const harness = new WindowHarness();
      const rect = makeRect(96, 48, 624, 56);
      harness.openTimerWindow('timer', 'pages/screenRecorderTimer', rect);
      harness.openTimerWindow('timer', 'pages/screenRecorderTimer', rect);
      harness.openTimerWindow('timer', 'pages/screenRecorderTimer', rect);
      const metrics = harness.getMetrics();
      assertNumberEqual(metrics.created, 1);
      assertNumberEqual(metrics.shown, 3);
      assertNumberEqual(metrics.loadCalls, 3);
    });

    it('Window_PopupRecorderTip_003', 0, () => {
      const harness = new WindowHarness();
      let callbackCounter = 0;
      const code = harness.popupRecorderTip('tip', 'pages/screenRecorderDialog', makeRect(1, 1, 100, 50), 3000, () => {
        callbackCounter += 1;
      });
      assertNumberEqual(code, 0);
      assertNumberEqual(callbackCounter, 1);
      assertTrue(harness.hasWindow('tip'));
      assertTrue(harness.isVisible('tip') === false);
      const metrics = harness.getMetrics();
      assertNumberEqual(metrics.hidden, 1);
    });

    it('Window_HideAndDestroy_004', 0, () => {
      const harness = new WindowHarness();
      harness.openTimerWindow('timer', 'pages/screenRecorderTimer', makeRect(1, 2, 3, 4));
      const hideCode = harness.hide('timer');
      const destroyCode = harness.destroy('timer');
      assertNumberEqual(hideCode, 0);
      assertNumberEqual(destroyCode, 0);
      assertTrue(harness.hasWindow('timer') === false);
      const metrics = harness.getMetrics();
      assertNumberEqual(metrics.hidden, 1);
      assertNumberEqual(metrics.destroyed, 1);
    });

    it('Window_ReleaseAll_005', 0, () => {
      const harness = new WindowHarness();
      harness.openTimerWindow('timer', 'pages/screenRecorderTimer', makeRect(1, 1, 11, 11));
      harness.openTimerWindow('tip', 'pages/screenRecorderDialog', makeRect(2, 2, 22, 22));
      harness.release();
      assertNumberEqual(harness.getWindowCount(), 0);
      const metrics = harness.getMetrics();
      assertNumberEqual(metrics.destroyed, 2);
    });

    it('Window_CreateFailure_006', 0, () => {
      const harness = new WindowHarness();
      harness.setThrowOnCreate(true);
      const code = harness.openTimerWindow('timer', 'pages/screenRecorderTimer', makeRect(0, 0, 10, 10));
      assertNumberEqual(code, -1);
      assertNumberEqual(harness.getWindowCount(), 0);
    });

    it('Window_LoadFailure_007', 0, () => {
      const harness = new WindowHarness();
      harness.setThrowOnLoad(true);
      const code = harness.openTimerWindow('timer', 'pages/screenRecorderTimer', makeRect(0, 0, 10, 10));
      assertNumberEqual(code, -2);
      assertTrue(harness.hasWindow('timer'));
    });

    it('Window_ShowFailure_008', 0, () => {
      const harness = new WindowHarness();
      harness.setThrowOnShow(true);
      const code = harness.openTimerWindow('timer', 'pages/screenRecorderTimer', makeRect(0, 0, 10, 10));
      assertNumberEqual(code, -3);
      assertTrue(harness.isVisible('timer') === false);
    });


    it('Window_RectSequence_010', 0, () => {
      const harness = new WindowHarness();
      const rects = createRectSequence(25);
      assertArrayLength(rects, 25);
      for (let i = 0; i < rects.length; i++) {
        const rect = rects[i];
        const code = harness.openTimerWindow(`timer_${i}`, 'pages/screenRecorderTimer', rect);
        assertNumberEqual(code, 0);
      }
      assertNumberEqual(harness.getWindowCount(), 25);
      const metrics = harness.getMetrics();
      assertNumberEqual(metrics.created, 25);
    });

    it('Window_RotationResolutionMatrix_011', 0, () => {
      const harness = new WindowHarness();
      const rotations = buildRotationMatrix();
      const resolutions = buildResolutionMatrix();
      let windowCount = 0;
      for (let r = 0; r < rotations.length; r++) {
        for (let s = 0; s < resolutions.length; s++) {
          const code = harness.openTimerWindow(
            `timer_${rotations[r]}_${resolutions[s].width}`,
            'pages/screenRecorderTimer',
            makeRect(0, 0, resolutions[s].width / 2, resolutions[s].height / 20)
          );
          assertNumberEqual(code, 0);
          windowCount += 1;
        }
      }
      assertNumberEqual(windowCount, 16);
      const metrics = harness.getMetrics();
      assertNumberEqual(metrics.created, 16);
      assertNumberEqual(metrics.moveCalls, 16);
      assertNumberEqual(metrics.resizeCalls, 16);
    });

    it('Window_MixedLifecycle_012', 0, () => {
      const harness = new WindowHarness();
      for (let i = 0; i < 60; i++) {
        const name = `mix_${i}`;
        harness.openTimerWindow(name, i % 2 === 0 ? 'pages/screenRecorderTimer' : 'pages/screenRecorderDialog', makeRect(i, i, 100 + i, 50 + (i % 5)));
        if (i % 3 === 0) {
          harness.hide(name);
        }
        if (i % 4 === 0) {
          harness.destroy(name);
        }
      }
      const metrics = harness.getMetrics();
      assertAtLeast(metrics.created, 60);
      assertAtLeast(metrics.hidden, 20);
      assertAtLeast(metrics.destroyed, 15);
    });
  });
}

function makeRect(x: number, y: number, width: number, height: number): MockWindowRect {
  return new MockWindowRectEntity(x, y, width, height)
}
