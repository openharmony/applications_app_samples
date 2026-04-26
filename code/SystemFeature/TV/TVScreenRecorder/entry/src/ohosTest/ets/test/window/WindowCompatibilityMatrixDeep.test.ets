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
  buildFoundationDurations,
  generateWindowRectMatrix,
  FoundationRollingChecksum,
  FoundationScenarioCounter
} from '../foundation/FoundationAdvancedFixtures';
import {
  assertArrayLength,
  assertAtLeast,
  assertContains,
  assertNumberEqual,
  assertTrue
} from '../foundation/TestAsserts';
import { createRectSequence, WindowHarness } from './WindowHarness';

export default function windowCompatibilityMatrixDeepTest(): void {
  describe('WindowCompatibilityMatrixDeepTest', () => {
    it('WindowCompatibility_ProfileBucketRectMatrix_001', 0, () => {
      const profiles = buildFoundationCompatibilityProfiles();
      const buckets = buildFoundationCanaryBuckets();
      const rects = createRectSequence(24);
      const counter = new FoundationScenarioCounter();
      const checksum = new FoundationRollingChecksum();
      const harness = new WindowHarness();

      /**
       * 浮窗在不同画像和灰度档位上的行为必须可预测。
       * 否则相同页面在不同批次设备上会出现悬浮控件偏移或创建次数不一致的问题。
       */
      for (let index = 0; index < profiles.length * buckets.length; index++) {
        const name = `${profiles[index % profiles.length]}_${buckets[index % buckets.length]}_${index}`;
        const code = harness.openTimerWindow(name, 'pages/ScreenRecorderTimer', rects[index % rects.length]);
        assertNumberEqual(code, 0);
        counter.record(profiles[index % profiles.length]);
        checksum.appendText(name);
        checksum.appendNumber(buckets[index % buckets.length]);
      }

      assertNumberEqual(counter.getDistinctCount(), profiles.length);
      assertAtLeast(counter.getTotalCount(), profiles.length * buckets.length);
      assertAtLeast(checksum.getValue(), 1);
    });

    it('WindowCompatibility_RectGeneratorCoversLargeBoundaryArea_002', 0, () => {
      const matrix = generateWindowRectMatrix();
      const harness = new WindowHarness();
      assertAtLeast(matrix.length, 600);
      for (let index = 0; index < 30; index++) {
        const rect = matrix[index * 5];
        const code = harness.openTimerWindow(`matrix_${index}`, 'pages/ScreenRecorderTimer', rect);
        assertNumberEqual(code, 0);
      }
      const metrics = harness.getMetrics();
      assertNumberEqual(metrics.created, 30);
      assertNumberEqual(metrics.moveCalls, 30);
    });

    it('WindowCompatibility_DurationSlicesDoNotAffectVisibilityContract_003', 0, () => {
      const durations = buildFoundationDurations();
      const harness = new WindowHarness();
      let callbackCount = 0;
      for (let index = 0; index < durations.length; index++) {
        const code = harness.popupRecorderTip(
          `duration_${index}`,
          index % 2 === 0 ? 'pages/ScreenRecorderDialog' : 'pages/ResolutionNotSupportedDialog',
          { x: 615, y: 46, width: 686, height: 100 },
          durations[index],
          () => {
            callbackCount += 1
          }
        )
        assertNumberEqual(code, 0);
      }
      assertNumberEqual(callbackCount, durations.length);
      assertNumberEqual(harness.getMetrics().hidden, durations.length);
    });

    it('WindowCompatibility_MatrixReplayLeavesReadableEventTrail_004', 0, () => {
      const harness = new WindowHarness();
      const profiles = buildFoundationCompatibilityProfiles();
      for (let index = 0; index < profiles.length * 6; index++) {
        const page = index % 2 === 0 ? 'pages/ScreenRecorderTimer' : 'pages/ScreenRecorderDialog';
        const code = harness.openTimerWindow(`trail_${profiles[index % profiles.length]}_${index}`, page, { x: index, y: index, width: 480, height: 56 });
        assertNumberEqual(code, 0);
      }
      const summary = harness.getEvents().map((event) => event.page).join(',');
      assertContains(summary, 'pages/ScreenRecorderTimer');
      assertContains(summary, 'pages/ScreenRecorderDialog');
    });

    it('WindowCompatibility_SequentialRectsRemainAddressableAfterRelease_005', 0, () => {
      const rects = createRectSequence(40);
      const harness = new WindowHarness();
      for (let index = 0; index < rects.length; index++) {
        harness.openTimerWindow(`release_${index}`, 'pages/ScreenRecorderTimer', rects[index]);
      }
      assertNumberEqual(harness.getWindowCount(), 40);
      harness.release();
      assertNumberEqual(harness.getWindowCount(), 0);
      assertNumberEqual(harness.getMetrics().destroyed, 40);
    });

    it('WindowCompatibility_HighResolutionRectsRemainShowable_006', 0, () => {
      const matrix = generateWindowRectMatrix().filter((rect) => rect.width >= 1920 && rect.height >= 1080);
      const harness = new WindowHarness();
      for (let index = 0; index < 20; index++) {
        const code = harness.openTimerWindow(`hires_${index}`, 'pages/ScreenRecorderTimer', matrix[index]);
        assertNumberEqual(code, 0);
        assertTrue(harness.isVisible(`hires_${index}`));
      }
      assertNumberEqual(harness.getMetrics().shown, 20);
    });

    it('WindowCompatibility_ProfileCrossProductCreatesEnoughSurfaceWork_007', 0, () => {
      const profiles = buildFoundationCompatibilityProfiles();
      const durations = buildFoundationDurations();
      const buckets = buildFoundationCanaryBuckets();
      const harness = new WindowHarness();
      let operations = 0;

      /**
       * 兼容矩阵不是简单地把窗口创建成功一次即可，
       * 更关键的是在画像、时长和档位交叉后依旧能维持足够的创建与布局调用规模。
       */
      for (let p = 0; p < profiles.length; p++) {
        for (let d = 0; d < durations.length; d++) {
          for (let b = 0; b < buckets.length; b++) {
            const code = harness.openTimerWindow(
              `matrix_${profiles[p]}_${durations[d]}_${buckets[b]}`,
              'pages/ScreenRecorderTimer',
              { x: b, y: d, width: 500 + d, height: 50 + p }
            )
            assertNumberEqual(code, 0);
            operations += 1
          }
        }
      }

      assertAtLeast(operations, 150);
      assertNumberEqual(harness.getMetrics().created, operations);
    });

    it('WindowCompatibility_EventTimestampsStayIncreasingDuringMatrixReplay_008', 0, () => {
      const harness = new WindowHarness();
      for (let index = 0; index < 36; index++) {
        harness.openTimerWindow(`ts_${index}`, 'pages/ScreenRecorderTimer', { x: 10, y: 10, width: 100 + index, height: 50 });
      }
      const events = harness.getEvents();
      assertAtLeast(events.length, 72);
      for (let index = 1; index < events.length; index++) {
        assertTrue(events[index].ts > events[index - 1].ts);
      }
    });

    it('WindowCompatibility_ShowFailuresDoNotCreateVisibleResidue_009', 0, () => {
      const harness = new WindowHarness();
      harness.setThrowOnShow(true);
      const codes: number[] = [];
      for (let index = 0; index < 12; index++) {
        codes.push(harness.openTimerWindow(`showfail_${index}`, 'pages/ScreenRecorderTimer', { x: 0, y: 0, width: 100, height: 50 }));
      }
      assertArrayLength(codes, 12);
      for (let index = 0; index < codes.length; index++) {
        assertNumberEqual(codes[index], -3);
        assertTrue(harness.isVisible(`showfail_${index}`) === false);
      }
    });
  });
}
