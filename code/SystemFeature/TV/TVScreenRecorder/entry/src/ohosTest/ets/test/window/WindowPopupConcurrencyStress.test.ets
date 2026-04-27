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
  buildFoundationDurations,
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
import { WindowHarness } from './WindowHarness';

export default function windowPopupConcurrencyStressTest(): void {
  describe('WindowPopupConcurrencyStressTest', () => {
    it('WindowPopup_ConcurrentTipBurstsKeepCallbackCadence_001', 0, () => {
      const harness = new WindowHarness();
      let callbackCount = 0;

      /**
       * 弹窗并发场景最核心的是回调节奏不能丢失。
       * 因为上层业务依赖回调驱动下一次提示或结束收尾动作，少一次都会造成悬浮层残留。
       */
      for (let round = 0; round < 80; round++) {
        const code = harness.popupRecorderTip(
          `tip_${round}`,
          round % 2 === 0 ? 'pages/ScreenRecorderDialog' : 'pages/ResolutionNotSupportedDialog',
          { x: 615, y: 46, width: 686, height: 100 },
          1000 + round,
          () => {
            callbackCount += 1
          }
        )
        assertNumberEqual(code, 0);
      }

      assertNumberEqual(callbackCount, 80);
      assertNumberEqual(harness.getMetrics().hidden, 80);
    });

    it('WindowPopup_CanaryBurstSeparatesBucketsAndEventTrail_002', 0, () => {
      const harness = new WindowHarness();
      const buckets = buildFoundationCanaryBuckets();
      const counter = new FoundationScenarioCounter();
      for (let index = 0; index < buckets.length; index++) {
        for (let round = 0; round < index + 4; round++) {
          const code = harness.popupRecorderTip(
            `bucket_${buckets[index]}_${round}`,
            'pages/ScreenRecorderDialog',
            { x: round, y: round, width: 400, height: 90 },
            2000
          )
          assertNumberEqual(code, 0);
          counter.record(`${buckets[index]}`);
        }
      }
      assertNumberEqual(counter.getDistinctCount(), buckets.length);
      assertAtLeast(counter.getTotalCount(), 39);
    });

    it('WindowPopup_DurationCrossProductCreatesEnoughStressWork_003', 0, () => {
      const harness = new WindowHarness();
      const durations = buildFoundationDurations();
      let operations = 0;
      for (let index = 0; index < durations.length; index++) {
        for (let round = 0; round < 9; round++) {
          const code = harness.popupRecorderTip(
            `duration_${index}_${round}`,
            'pages/ScreenRecorderDialog',
            { x: 615, y: 46, width: 686, height: 100 },
            durations[index]
          )
          assertNumberEqual(code, 0);
          operations += 1
        }
      }
      assertAtLeast(operations, 54);
      assertNumberEqual(harness.getMetrics().hidden, operations);
    });

    it('WindowPopup_MixedOpenHideDestroyConcurrency_004', 0, () => {
      const harness = new WindowHarness();
      for (let round = 0; round < 90; round++) {
        const name = `mix_${round}`;
        harness.openTimerWindow(name, 'pages/ScreenRecorderTimer', { x: round, y: round, width: 500, height: 60 });
        if (round % 2 === 0) {
          harness.hide(name);
        }
        if (round % 3 === 0) {
          harness.destroy(name);
        }
      }
      const metrics = harness.getMetrics();
      assertAtLeast(metrics.created, 90);
      assertAtLeast(metrics.hidden, 45);
      assertAtLeast(metrics.destroyed, 30);
    });

    it('WindowPopup_LoadFailureBurstKeepsWindowNodesTrackable_005', 0, () => {
      const harness = new WindowHarness();
      harness.setThrowOnLoad(true);
      const codes: number[] = [];
      for (let round = 0; round < 18; round++) {
        codes.push(harness.openTimerWindow(`load_${round}`, 'pages/ScreenRecorderTimer', { x: 0, y: 0, width: 120, height: 50 }));
      }
      assertArrayLength(codes, 18);
      for (let index = 0; index < codes.length; index++) {
        assertNumberEqual(codes[index], -2);
        assertTrue(harness.hasWindow(`load_${index}`));
      }
    });

    it('WindowPopup_ShowFailureBurstLeavesInvisibleResidueOnly_006', 0, () => {
      const harness = new WindowHarness();
      harness.setThrowOnShow(true);
      for (let round = 0; round < 20; round++) {
        const code = harness.openTimerWindow(`show_${round}`, 'pages/ScreenRecorderTimer', { x: 1, y: 1, width: 100, height: 50 });
        assertNumberEqual(code, -3);
      }
      for (let round = 0; round < 20; round++) {
        assertTrue(harness.isVisible(`show_${round}`) === false);
      }
    });

    it('WindowPopup_DualPassStressFingerprintRemainsStable_007', 0, () => {
      const checksumA = new FoundationRollingChecksum();
      const checksumB = new FoundationRollingChecksum();

      /**
       * 并发弹窗最容易暴露非确定性顺序问题。
       * 用双遍压力重放的事件指纹比对，可以快速识别同样输入下是否出现不同的事件尾序。
       */
      for (let pass = 0; pass < 2; pass++) {
        const harness = new WindowHarness();
        for (let round = 0; round < 22; round++) {
          harness.popupRecorderTip(`fp_${round}`, 'pages/ScreenRecorderDialog', { x: round, y: round, width: 300, height: 80 }, 1500);
        }
        const summary = harness.getEvents().map((event) => `${event.type}_${event.name}_${event.page}`).join('|');
        if (pass === 0) {
          checksumA.appendText(summary);
        } else {
          checksumB.appendText(summary);
        }
      }
      assertNumberEqual(checksumA.getValue(), checksumB.getValue());
    });

    it('WindowPopup_ResolutionDialogAndRecorderDialogBothAppear_008', 0, () => {
      const harness = new WindowHarness();
      for (let round = 0; round < 30; round++) {
        harness.popupRecorderTip(
          `page_${round}`,
          round % 2 === 0 ? 'pages/ScreenRecorderDialog' : 'pages/ResolutionNotSupportedDialog',
          { x: 615, y: 46, width: 686, height: 100 },
          3000
        )
      }
      const pages = harness.getEvents().map((event) => event.page).join(',');
      assertContains(pages, 'pages/ScreenRecorderDialog');
      assertContains(pages, 'pages/ResolutionNotSupportedDialog');
    });

    it('WindowPopup_LongRunningMixedSceneProducesSufficientLayoutCalls_009', 0, () => {
      const harness = new WindowHarness();
      let operations = 0;
      for (let round = 0; round < 140; round++) {
        const page = round % 4 === 0 ? 'pages/ResolutionNotSupportedDialog' : 'pages/ScreenRecorderDialog';
        const code = harness.popupRecorderTip(`long_${round}`, page, { x: round, y: round, width: 320 + round, height: 80 }, 2500);
        assertNumberEqual(code, 0);
        operations += 1
      }
      assertNumberEqual(operations, 140);
      assertAtLeast(harness.getMetrics().loadCalls, 140);
      assertAtLeast(harness.getMetrics().resizeCalls, 140);
    });
  });
}
