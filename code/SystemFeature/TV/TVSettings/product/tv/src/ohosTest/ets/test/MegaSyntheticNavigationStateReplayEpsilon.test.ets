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

import { describe, it, expect } from '@ohos/hypium';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

function normalizeStep(step: number): number {
  if (step > 1) {
    return 1;
  }
  if (step < -1) {
    return -1;
  }
  return step;
}

function replayLinearFocus(origin: number, steps: Array<number>, min: number, max: number): number {
  let focus = origin;
  for (let i = 0; i < steps.length; i++) {
    focus += normalizeStep(steps[i]);
    if (focus < min) {
      focus = min;
    }
    if (focus > max) {
      focus = max;
    }
  }
  return focus;
}

function getRequestedItFilter(): string {
  const args = AbilityDelegatorRegistry.getArguments();
  if (args === undefined || args === null || args.parameters === undefined || args.parameters === null) {
    return '';
  }
  const rawItValue = args.parameters['-s rawIt'];
  if (typeof rawItValue === 'string' && rawItValue.length > 0) {
    return rawItValue;
  }
  const itValue = args.parameters['-s it'];
  return typeof itValue === 'string' ? itValue : '';
}

function shouldRegisterCase(caseName: string, requestedItFilter: string): boolean {
  if (requestedItFilter.length === 0) {
    return true;
  }
  return caseName === requestedItFilter
    || caseName.indexOf(requestedItFilter) >= 0
    || requestedItFilter.indexOf(caseName) >= 0;
}

export default function MegaSyntheticNavigationStateReplayEpsilonTest() {
  const casePrefix = 'Settings_MegaSyntheticNavigationStateReplayEpsilon_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const requestedItFilter = getRequestedItFilter();

  describe('MegaSyntheticNavigationStateReplayEpsilonSuite', () => {
    const normalizeStepCase = addCase(casePrefix + 'NormalizeStep_001');
    if (shouldRegisterCase(normalizeStepCase, requestedItFilter)) {
      it(normalizeStepCase, 0, () => {
        expect(normalizeStep(4)).assertEqual(1);
        expect(normalizeStep(-3)).assertEqual(-1);
        expect(normalizeStep(0)).assertEqual(0);
      });
    }

    const clampMinCase = addCase(casePrefix + 'ClampMin_002');
    if (shouldRegisterCase(clampMinCase, requestedItFilter)) {
      it(clampMinCase, 0, () => {
        const steps: Array<number> = [-1, -1, -1, -1];
        expect(replayLinearFocus(2, steps, 0, 5)).assertEqual(0);
      });
    }

    const clampMaxCase = addCase(casePrefix + 'ClampMax_003');
    if (shouldRegisterCase(clampMaxCase, requestedItFilter)) {
      it(clampMaxCase, 0, () => {
        const steps: Array<number> = [1, 1, 1, 1, 1];
        expect(replayLinearFocus(3, steps, 0, 5)).assertEqual(5);
      });
    }

    const replayBalanceCase = addCase(casePrefix + 'ReplayBalance_004');
    if (shouldRegisterCase(replayBalanceCase, requestedItFilter)) {
      it(replayBalanceCase, 0, () => {
        const steps: Array<number> = [1, 1, -1, -1, 1, -1];
        expect(replayLinearFocus(4, steps, 0, 9)).assertEqual(4);
      });
    }

    const caseNamingCase = addCase(casePrefix + 'CaseNaming_005');
    if (shouldRegisterCase(caseNamingCase, requestedItFilter)) {
      it(caseNamingCase, 0, () => {
        const regex = /^Settings_MegaSyntheticNavigationStateReplayEpsilon_[A-Za-z0-9_]+_[0-9]{3}$/;
        const unique: Set<string> = new Set<string>();
        for (let i = 0; i < allCaseNames.length; i++) {
          expect(regex.test(allCaseNames[i])).assertEqual(true);
          expect(unique.has(allCaseNames[i])).assertEqual(false);
          unique.add(allCaseNames[i]);
        }
        expect(unique.size).assertEqual(allCaseNames.length);
      });
    }
  });
}

