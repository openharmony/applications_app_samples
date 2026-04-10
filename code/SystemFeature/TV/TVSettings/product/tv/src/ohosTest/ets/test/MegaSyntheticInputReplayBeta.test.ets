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

function normalizeCursorIndex(index: number, max: number): number {
  if (max <= 0) {
    return 0;
  }
  if (index < 0) {
    return 0;
  }
  if (index >= max) {
    return max - 1;
  }
  return index;
}

function replayWindow(start: number, length: number, limit: number): Array<number> {
  const result: Array<number> = [];
  for (let i = 0; i < length; i++) {
    result.push(normalizeCursorIndex(start + i, limit));
  }
  return result;
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

export default function MegaSyntheticInputReplayBetaTest() {
  const casePrefix = 'Settings_MegaSyntheticInputReplayBeta_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const requestedItFilter = getRequestedItFilter();
  const seeds: Array<number> = [
    -20, -15, -10, -5, -1, 0, 1, 2, 3, 4, 5, 6,
    7, 8, 9, 10, 11, 12, 14, 16, 18, 20, 22, 24,
    26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48
  ];
  const limits: Array<number> = [1, 2, 3, 4, 5, 6, 8, 10, 12];

  describe('MegaSyntheticInputReplayBetaSuite', () => {
    const normalizeCursorCase = addCase(casePrefix + 'NormalizeCursor_001');
    if (shouldRegisterCase(normalizeCursorCase, requestedItFilter)) {
      it(normalizeCursorCase, 0, () => {
        for (let i = 0; i < limits.length; i++) {
          for (let j = 0; j < seeds.length; j++) {
            const result = normalizeCursorIndex(seeds[j], limits[i]);
            expect(result >= 0).assertEqual(true);
            expect(result < limits[i]).assertEqual(true);
          }
        }
      });
    }

    const replayWindowLengthCase = addCase(casePrefix + 'ReplayWindowLength_002');
    if (shouldRegisterCase(replayWindowLengthCase, requestedItFilter)) {
      it(replayWindowLengthCase, 0, () => {
        for (let i = 0; i < limits.length; i++) {
          const window = replayWindow(seeds[i], 12, limits[i]);
          expect(window.length).assertEqual(12);
          for (let j = 0; j < window.length; j++) {
            expect(window[j] >= 0).assertEqual(true);
            expect(window[j] < limits[i]).assertEqual(true);
          }
        }
      });
    }

    const replayWindowTailClampCase = addCase(casePrefix + 'ReplayWindowTailClamp_003');
    if (shouldRegisterCase(replayWindowTailClampCase, requestedItFilter)) {
      it(replayWindowTailClampCase, 0, () => {
        for (let i = 0; i < limits.length; i++) {
          const window = replayWindow(100 + i, 6, limits[i]);
          for (let j = 0; j < window.length; j++) {
            expect(window[j]).assertEqual(limits[i] - 1);
          }
        }
      });
    }

    const longReplayPassCase = addCase(casePrefix + 'LongReplayPass_004');
    if (shouldRegisterCase(longReplayPassCase, requestedItFilter)) {
      it(longReplayPassCase, 0, () => {
        let accumulator = 0;
        for (let i = 0; i < 1600; i++) {
          const limit = limits[i % limits.length];
          accumulator += normalizeCursorIndex(seeds[i % seeds.length], limit);
        }
        expect(accumulator >= 0).assertEqual(true);
      });
    }

    const caseNamingCase = addCase(casePrefix + 'CaseNaming_005');
    if (shouldRegisterCase(caseNamingCase, requestedItFilter)) {
      it(caseNamingCase, 0, () => {
        const regex = /^Settings_MegaSyntheticInputReplayBeta_[A-Za-z0-9_]+_[0-9]{3}$/;
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

