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
  buildFoundationDurations,
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
import { TimerProjectionHarness } from '../service/ServiceSceneHarness';

export default function uiTimerProjectionDeepTest(): void {
  describe('UITimerProjectionDeepTest', () => {
    it('UITimer_RecordingTicksUpdateLabel_001', 0, () => {
      const harness = new TimerProjectionHarness();
      harness.setRecording(true);
      harness.tick(1);
      harness.tick(2);
      assertStringEqual(harness.getTimerLabel(), '00:02');
      assertArrayLength(harness.getRecords(), 3);
    });

    it('UITimer_IdleTickDoesNotAdvanceLabel_002', 0, () => {
      const harness = new TimerProjectionHarness();
      harness.tick(10);
      assertStringEqual(harness.getTimerLabel(), '00:00');
      assertStringEqual(harness.getRecords()[0].detail, 'ignored');
    });

    it('UITimer_IconVisibilityAlternatesAcrossTicks_003', 0, () => {
      const harness = new TimerProjectionHarness();
      harness.setRecording(true);
      harness.tick(1);
      const first = harness.isIconHidden();
      harness.tick(2);
      const second = harness.isIconHidden();
      assertTrue(first !== second);
    });

    it('UITimer_StopResetsLabelAndIcon_004', 0, () => {
      const harness = new TimerProjectionHarness();
      harness.setRecording(true);
      harness.tick(75);
      harness.setRecording(false);
      assertStringEqual(harness.getTimerLabel(), '00:00');
      assertTrue(harness.isIconHidden() === false);
    });

    it('UITimer_DurationSlicesProduceReadableTimerStates_005', 0, () => {
      const durations = buildFoundationDurations();
      const counter = new FoundationScenarioCounter();
      const harness = new TimerProjectionHarness();
      harness.setRecording(true);
      for (let index = 0; index < durations.length; index++) {
        harness.tick(durations[index]);
        counter.record(harness.getTimerLabel());
      }
      assertAtLeast(counter.getDistinctCount(), 8);
      assertContains(harness.getTimerLabel(), ':');
    });

    it('UITimer_DualPassTickFingerprintRemainsStable_006', 0, () => {
      const checksumA = new FoundationRollingChecksum();
      const checksumB = new FoundationRollingChecksum();
      for (let pass = 0; pass < 2; pass++) {
        const harness = new TimerProjectionHarness();
        harness.setRecording(true);
        for (let second = 1; second <= 20; second++) {
          harness.tick(second);
        }
        const summary = harness.getRecords().map((record) => `${record.type}_${record.detail}_${record.code}`).join('|');
        if (pass === 0) {
          checksumA.appendText(summary);
        } else {
          checksumB.appendText(summary);
        }
      }
      assertNumberEqual(checksumA.getValue(), checksumB.getValue());
    });

    it('UITimer_LongRunTicksGenerateEnoughTelemetry_007', 0, () => {
      const harness = new TimerProjectionHarness();
      harness.setRecording(true);
      for (let second = 1; second <= 180; second++) {
        harness.tick(second);
      }
      assertAtLeast(harness.getRecords().length, 181);
      assertStringEqual(harness.getTimerLabel(), '03:00');
    });

    it('UITimer_MinuteBoundaryIsFormattedCorrectly_008', 0, () => {
      const harness = new TimerProjectionHarness();
      harness.setRecording(true);
      harness.tick(60);
      assertStringEqual(harness.getTimerLabel(), '01:00');
    });

    it('UITimer_ActionTrailContainsStateAndTickMarkers_009', 0, () => {
      const harness = new TimerProjectionHarness();
      harness.setRecording(true);
      harness.tick(5);
      const summary = harness.getRecords().map((record) => `${record.type}:${record.detail}`).join(',');
      assertContains(summary, 'state:recording');
      assertContains(summary, 'tick:00:05');
    });
  });
}
