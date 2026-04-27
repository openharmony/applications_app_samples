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

function resolveWrapCursorIndex(index: number, length: number): number {
  if (length <= 0) {
    return 0;
  }
  if (index < 0) {
    return (length + (index % length)) % length;
  }
  return index % length;
}

function replayCircularNavigation(origin: number, steps: Array<number>, length: number): number {
  let cursor = origin;
  for (let i = 0; i < steps.length; i++) {
    cursor = resolveWrapCursorIndex(cursor + steps[i], length);
  }
  return cursor;
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

export default function MegaSyntheticNavigationStateReplayDeltaTest() {
  const casePrefix = 'Settings_MegaSyntheticNavigationStateReplayDelta_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const requestedItFilter = getRequestedItFilter();

  describe('MegaSyntheticNavigationStateReplayDeltaSuite', () => {
    const wrapNegativeCase = addCase(casePrefix + 'WrapNegative_001');
    if (shouldRegisterCase(wrapNegativeCase, requestedItFilter)) {
      it(wrapNegativeCase, 0, () => {
        expect(resolveWrapCursorIndex(-1, 8)).assertEqual(7);
        expect(resolveWrapCursorIndex(-9, 8)).assertEqual(7);
        expect(resolveWrapCursorIndex(-16, 8)).assertEqual(0);
      });
    }

    const wrapPositiveCase = addCase(casePrefix + 'WrapPositive_002');
    if (shouldRegisterCase(wrapPositiveCase, requestedItFilter)) {
      it(wrapPositiveCase, 0, () => {
        expect(resolveWrapCursorIndex(8, 8)).assertEqual(0);
        expect(resolveWrapCursorIndex(9, 8)).assertEqual(1);
        expect(resolveWrapCursorIndex(18, 8)).assertEqual(2);
      });
    }

    const replayLoopCase = addCase(casePrefix + 'ReplayLoop_003');
    if (shouldRegisterCase(replayLoopCase, requestedItFilter)) {
      it(replayLoopCase, 0, () => {
        const steps: Array<number> = [1, 1, 1, -2, 4, -5, 3];
        expect(replayCircularNavigation(2, steps, 10)).assertEqual(5);
      });
    }

    const replayStressCase = addCase(casePrefix + 'ReplayStress_004');
    if (shouldRegisterCase(replayStressCase, requestedItFilter)) {
      it(replayStressCase, 0, () => {
        const steps: Array<number> = [1, -1, 2, -2, 3, -3];
        let cursor = 0;
        for (let i = 0; i < 500; i++) {
          cursor = replayCircularNavigation(cursor, steps, 12);
        }
        expect(cursor).assertEqual(0);
      });
    }

    const caseNamingCase = addCase(casePrefix + 'CaseNaming_005');
    if (shouldRegisterCase(caseNamingCase, requestedItFilter)) {
      it(caseNamingCase, 0, () => {
        const regex = /^Settings_MegaSyntheticNavigationStateReplayDelta_[A-Za-z0-9_]+_[0-9]{3}$/;
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

