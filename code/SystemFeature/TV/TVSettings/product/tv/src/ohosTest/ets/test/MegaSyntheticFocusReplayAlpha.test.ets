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

function moveFocus(index: number, step: number, count: number): number {
  if (count <= 0) {
    return 0;
  }
  const next = index + step;
  if (next < 0) {
    return 0;
  }
  if (next >= count) {
    return count - 1;
  }
  return next;
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

export default function MegaSyntheticFocusReplayAlphaTest() {
  const casePrefix = 'Settings_MegaSyntheticFocusReplayAlpha_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const requestedItFilter = getRequestedItFilter();
  const steps: Array<number> = [
    -9, -7, -5, -3, -2, -1, 0, 1, 2, 3, 4, 5, 7, 9
  ];
  const counts: Array<number> = [1, 2, 3, 4, 5, 6, 8, 10, 12];

  describe('MegaSyntheticFocusReplayAlphaSuite', () => {
    const moveFocusClampCase = addCase(casePrefix + 'MoveFocusClamp_001');
    if (shouldRegisterCase(moveFocusClampCase, requestedItFilter)) {
      it(moveFocusClampCase, 0, () => {
        for (let i = 0; i < counts.length; i++) {
          for (let j = 0; j < steps.length; j++) {
            const result = moveFocus(j, steps[j], counts[i]);
            expect(result >= 0).assertEqual(true);
            expect(result < counts[i]).assertEqual(true);
          }
        }
      });
    }

    const leftBoundaryCase = addCase(casePrefix + 'LeftBoundary_002');
    if (shouldRegisterCase(leftBoundaryCase, requestedItFilter)) {
      it(leftBoundaryCase, 0, () => {
        for (let i = 0; i < counts.length; i++) {
          expect(moveFocus(0, -100, counts[i])).assertEqual(0);
        }
      });
    }

    const rightBoundaryCase = addCase(casePrefix + 'RightBoundary_003');
    if (shouldRegisterCase(rightBoundaryCase, requestedItFilter)) {
      it(rightBoundaryCase, 0, () => {
        for (let i = 0; i < counts.length; i++) {
          expect(moveFocus(counts[i] - 1, 100, counts[i])).assertEqual(counts[i] - 1);
        }
      });
    }

    const longReplayCase = addCase(casePrefix + 'LongReplay_004');
    if (shouldRegisterCase(longReplayCase, requestedItFilter)) {
      it(longReplayCase, 0, () => {
        let cursor = 0;
        for (let i = 0; i < 2000; i++) {
          const count = counts[i % counts.length];
          cursor = moveFocus(cursor, steps[i % steps.length], count);
          expect(cursor >= 0).assertEqual(true);
          expect(cursor < count).assertEqual(true);
        }
      });
    }

    const caseNamingCase = addCase(casePrefix + 'CaseNaming_005');
    if (shouldRegisterCase(caseNamingCase, requestedItFilter)) {
      it(caseNamingCase, 0, () => {
        const regex = /^Settings_MegaSyntheticFocusReplayAlpha_[A-Za-z0-9_]+_[0-9]{3}$/;
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

