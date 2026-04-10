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

function normalizeGridIndex(row: number, column: number, rowCount: number, columnCount: number): number {
  const safeRow = Math.min(Math.max(row, 0), rowCount - 1);
  const safeColumn = Math.min(Math.max(column, 0), columnCount - 1);
  return safeRow * columnCount + safeColumn;
}

function splitGridIndex(index: number, columnCount: number): [number, number] {
  return [Math.floor(index / columnCount), index % columnCount];
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

export default function MegaSyntheticFocusReplayBetaTest() {
  const casePrefix = 'Settings_MegaSyntheticFocusReplayBeta_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const requestedItFilter = getRequestedItFilter();
  const rows: Array<number> = [-2, -1, 0, 1, 2, 3, 4, 5, 6];
  const columns: Array<number> = [-3, -1, 0, 1, 2, 3, 4, 5, 7];

  describe('MegaSyntheticFocusReplayBetaSuite', () => {
    const gridClampCase = addCase(casePrefix + 'GridClamp_001');
    if (shouldRegisterCase(gridClampCase, requestedItFilter)) {
      it(gridClampCase, 0, () => {
        for (let i = 0; i < rows.length; i++) {
          for (let j = 0; j < columns.length; j++) {
            const index = normalizeGridIndex(rows[i], columns[j], 4, 5);
            expect(index >= 0).assertEqual(true);
            expect(index < 20).assertEqual(true);
          }
        }
      });
    }

    const gridSplitMergeCase = addCase(casePrefix + 'GridSplitMerge_002');
    if (shouldRegisterCase(gridSplitMergeCase, requestedItFilter)) {
      it(gridSplitMergeCase, 0, () => {
        for (let i = 0; i < 20; i++) {
          const pair = splitGridIndex(i, 5);
          expect(normalizeGridIndex(pair[0], pair[1], 4, 5)).assertEqual(i);
        }
      });
    }

    const gridReplayStressCase = addCase(casePrefix + 'GridReplayStress_003');
    if (shouldRegisterCase(gridReplayStressCase, requestedItFilter)) {
      it(gridReplayStressCase, 0, () => {
        let result = 0;
        for (let i = 0; i < 1800; i++) {
          result = normalizeGridIndex(rows[i % rows.length], columns[i % columns.length], 4, 5);
        }
        expect(result >= 0).assertEqual(true);
        expect(result < 20).assertEqual(true);
      });
    }

    const topLeftBottomRightCase = addCase(casePrefix + 'TopLeftBottomRight_004');
    if (shouldRegisterCase(topLeftBottomRightCase, requestedItFilter)) {
      it(topLeftBottomRightCase, 0, () => {
        expect(normalizeGridIndex(-50, -50, 4, 5)).assertEqual(0);
        expect(normalizeGridIndex(50, 50, 4, 5)).assertEqual(19);
      });
    }

    const caseNamingCase = addCase(casePrefix + 'CaseNaming_005');
    if (shouldRegisterCase(caseNamingCase, requestedItFilter)) {
      it(caseNamingCase, 0, () => {
        const regex = /^Settings_MegaSyntheticFocusReplayBeta_[A-Za-z0-9_]+_[0-9]{3}$/;
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

