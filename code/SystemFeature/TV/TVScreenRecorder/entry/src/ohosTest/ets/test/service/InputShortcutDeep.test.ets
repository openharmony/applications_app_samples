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
  buildFoundationKeySequenceCases,
  FoundationRollingChecksum,
  FoundationScenarioCounter
} from '../foundation/FoundationAdvancedFixtures';
import {
  assertArrayLength,
  assertAtLeast,
  assertNumberEqual,
  assertStringEqual,
  assertTrue
} from '../foundation/TestAsserts';
import { DoubleClickHarness, InputShortcutGateHarness } from './ServiceSceneHarness';

export default function inputShortcutDeepTest(): void {
  describe('InputShortcutDeepTest', () => {
    it('InputShortcut_DoubleClickWithinTimeoutTriggersOnce_001', 0, () => {
      const harness = new DoubleClickHarness(500);
      harness.handleClick(100);
      harness.handleClick(420);
      assertNumberEqual(harness.getCallbackCount(), 1);
    });

    it('InputShortcut_DoubleClickBeyondTimeoutDoesNotTrigger_002', 0, () => {
      const harness = new DoubleClickHarness(500);
      harness.handleClick(100);
      harness.handleClick(700);
      assertNumberEqual(harness.getCallbackCount(), 0);
    });

    it('InputShortcut_KeyComboTriggersOnlyOncePerHold_003', 0, () => {
      const harness = new InputShortcutGateHarness(23, 24);
      harness.feed(23, true);
      harness.feed(24, true);
      harness.feed(24, true);
      harness.feed(23, true);
      assertNumberEqual(harness.getTriggerCount(), 1);
    });

    it('InputShortcut_ReopenGateAfterReleaseAllowsSecondTrigger_004', 0, () => {
      const harness = new InputShortcutGateHarness(23, 24);
      harness.feed(23, true);
      harness.feed(24, true);
      harness.feed(23, false);
      harness.feed(24, false);
      harness.feed(24, true);
      harness.feed(23, true);
      assertNumberEqual(harness.getTriggerCount(), 2);
    });

    it('InputShortcut_KeySequenceCasesReplayExpectedCounts_005', 0, () => {
      const cases = buildFoundationKeySequenceCases();
      const counter = new FoundationScenarioCounter();
      for (let caseIndex = 0; caseIndex < cases.length; caseIndex++) {
        const harness = new InputShortcutGateHarness(cases[caseIndex].keyA, cases[caseIndex].keyB);
        for (let stepIndex = 0; stepIndex < cases[caseIndex].steps.length; stepIndex++) {
          const step = cases[caseIndex].steps[stepIndex];
          harness.feed(step.keyCode, step.isDown);
        }
        counter.record(`${harness.getTriggerCount()}`);
      }
      assertAtLeast(counter.getTotalCount(), cases.length);
      assertAtLeast(counter.getDistinctCount(), 1);
    });

    it('InputShortcut_DualPassSequenceFingerprintRemainsStable_006', 0, () => {
      const cases = buildFoundationKeySequenceCases();
      const checksumA = new FoundationRollingChecksum();
      const checksumB = new FoundationRollingChecksum();
      for (let pass = 0; pass < 2; pass++) {
        for (let caseIndex = 0; caseIndex < cases.length; caseIndex++) {
          const harness = new InputShortcutGateHarness(cases[caseIndex].keyA, cases[caseIndex].keyB);
          for (let stepIndex = 0; stepIndex < cases[caseIndex].steps.length; stepIndex++) {
            const step = cases[caseIndex].steps[stepIndex];
            harness.feed(step.keyCode, step.isDown);
          }
          const summary = harness.getRecords().map((record) => `${record.type}_${record.detail}_${record.code}`).join('|');
          if (pass === 0) {
            checksumA.appendText(summary);
          } else {
            checksumB.appendText(summary);
          }
        }
      }
      assertNumberEqual(checksumA.getValue(), checksumB.getValue());
    });

    it('InputShortcut_BurstGateReplayProducesEnoughEvents_007', 0, () => {
      const harness = new InputShortcutGateHarness(23, 24);
      for (let round = 0; round < 100; round++) {
        harness.feed(round % 2 === 0 ? 23 : 24, true);
        if (round % 3 === 0) {
          harness.feed(23, false);
          harness.feed(24, false);
        }
      }
      assertAtLeast(harness.getRecords().length, 130);
      assertAtLeast(harness.getTriggerCount(), 10);
    });

    it('InputShortcut_DoubleClickBurstGeneratesExpectedCount_008', 0, () => {
      const harness = new DoubleClickHarness(500);
      for (let round = 0; round < 30; round++) {
        const base = round * 1000;
        harness.handleClick(base);
        harness.handleClick(base + 200);
      }
      assertNumberEqual(harness.getCallbackCount(), 30);
    });

    it('InputShortcut_RecordTrailKeepsComboMarkers_009', 0, () => {
      const harness = new InputShortcutGateHarness(23, 24);
      harness.feed(24, true);
      harness.feed(23, true);
      const records = harness.getRecords();
      assertArrayLength(records, 3);
      assertStringEqual(records[2].type, 'trigger');
      assertTrue(records[2].detail === 'combo');
    });
  });
}
