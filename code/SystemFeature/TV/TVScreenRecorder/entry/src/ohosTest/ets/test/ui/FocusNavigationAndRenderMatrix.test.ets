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
  buildFoundationCompatibilityProfiles,
  FoundationRollingChecksum,
  FoundationScenarioCounter
} from '../foundation/FoundationAdvancedFixtures';
import {
  assertArrayLength,
  assertAtLeast,
  assertContains,
  assertNumberEqual,
  assertStringEqual
} from '../foundation/TestAsserts';
import { DesktopLayoutHarness } from './AccessibilityLayoutHarness';

export default function focusNavigationAndRenderMatrixTest(): void {
  describe('FocusNavigationAndRenderMatrixTest', () => {
    it('FocusNavigation_HorizontalMovesReachExpectedTargets_001', 0, () => {
      const harness = new DesktopLayoutHarness();
      assertStringEqual(harness.getCurrentFocus(), 'start');
      assertNumberEqual(harness.moveFocus('right'), 0);
      assertStringEqual(harness.getCurrentFocus(), 'recent');
      assertNumberEqual(harness.moveFocus('right'), 0);
      assertStringEqual(harness.getCurrentFocus(), 'dialog');
    });

    it('FocusNavigation_LeftBoundaryReturnsGuardCode_002', 0, () => {
      const harness = new DesktopLayoutHarness();
      assertNumberEqual(harness.moveFocus('left'), -1);
      assertNumberEqual(harness.getFocusIndex(), 0);
      assertArrayLength(harness.getFocusActions(), 1);
    });

    it('FocusNavigation_ProfileReplayBuildsDistinctFocusCoverage_003', 0, () => {
      const harness = new DesktopLayoutHarness();
      const profiles = buildFoundationCompatibilityProfiles();
      const counter = new FoundationScenarioCounter();
      for (let index = 0; index < profiles.length; index++) {
        harness.render(`page_${profiles[index]}`, 1280 + index * 10, 720 + index * 10, 0);
        harness.moveFocus('right');
        counter.record(harness.getCurrentFocus());
      }
      assertAtLeast(counter.getDistinctCount(), 3);
      assertAtLeast(harness.getRenders().length, profiles.length);
    });

    it('FocusNavigation_DualPassActionFingerprintRemainsStable_004', 0, () => {
      const checksumA = new FoundationRollingChecksum();
      const checksumB = new FoundationRollingChecksum();
      for (let pass = 0; pass < 2; pass++) {
        const harness = new DesktopLayoutHarness();
        for (let round = 0; round < 12; round++) {
          harness.moveFocus('right');
        }
        for (let round = 0; round < 12; round++) {
          harness.moveFocus('left');
        }
        const summary = harness.getFocusActions().map((item) => `${item.direction}:${item.code}:${item.index}`).join('|');
        if (pass === 0) {
          checksumA.appendText(summary);
        } else {
          checksumB.appendText(summary);
        }
      }
      assertNumberEqual(checksumA.getValue(), checksumB.getValue());
    });

    it('FocusNavigation_UnknownDirectionIsRecorded_005', 0, () => {
      const harness = new DesktopLayoutHarness();
      assertNumberEqual(harness.moveFocus('diagonal'), -3);
      const summary = harness.getFocusActions().map((item) => `${item.direction}:${item.code}`).join(',');
      assertContains(summary, 'diagonal:-3');
    });

    it('FocusNavigation_LongRunMixedMovementBuildsTelemetry_006', 0, () => {
      const harness = new DesktopLayoutHarness();
      for (let round = 0; round < 140; round++) {
        const direction = round % 3 === 0 ? 'right' : round % 3 === 1 ? 'left' : 'down';
        harness.moveFocus(direction);
      }
      assertAtLeast(harness.getFocusActions().length, 140);
      assertAtLeast(harness.getFocusIndex(), 0);
    });
  });
}
