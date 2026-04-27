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

function resolveGridIndex(row: number, column: number, columns: number): number {
  if (columns <= 0) {
    return 0;
  }
  if (row < 0 || column < 0) {
    return 0;
  }
  return row * columns + column;
}

function replayGridMoves(originRow: number, originColumn: number, moves: Array<string>, columns: number): number {
  let row = originRow;
  let column = originColumn;
  for (let i = 0; i < moves.length; i++) {
    if (moves[i] === 'up') {
      row--;
    } else if (moves[i] === 'down') {
      row++;
    } else if (moves[i] === 'left') {
      column--;
    } else if (moves[i] === 'right') {
      column++;
    }
    if (row < 0) {
      row = 0;
    }
    if (column < 0) {
      column = 0;
    }
  }
  return resolveGridIndex(row, column, columns);
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

export default function MegaSyntheticNavigationStateReplayZetaTest() {
  const casePrefix = 'Settings_MegaSyntheticNavigationStateReplayZeta_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const requestedItFilter = getRequestedItFilter();

  describe('MegaSyntheticNavigationStateReplayZetaSuite', () => {
    const gridIndexCase = addCase(casePrefix + 'GridIndex_001');
    if (shouldRegisterCase(gridIndexCase, requestedItFilter)) {
      it(gridIndexCase, 0, () => {
        expect(resolveGridIndex(0, 0, 5)).assertEqual(0);
        expect(resolveGridIndex(2, 3, 5)).assertEqual(13);
        expect(resolveGridIndex(-1, 4, 5)).assertEqual(0);
      });
    }

    const replayMovesCase = addCase(casePrefix + 'ReplayMoves_002');
    if (shouldRegisterCase(replayMovesCase, requestedItFilter)) {
      it(replayMovesCase, 0, () => {
        const moves: Array<string> = ['right', 'right', 'down', 'down', 'left'];
        expect(replayGridMoves(0, 0, moves, 6)).assertEqual(13);
      });
    }

    const replayClampCase = addCase(casePrefix + 'ReplayClamp_003');
    if (shouldRegisterCase(replayClampCase, requestedItFilter)) {
      it(replayClampCase, 0, () => {
        const moves: Array<string> = ['left', 'left', 'up', 'right'];
        expect(replayGridMoves(0, 0, moves, 4)).assertEqual(1);
      });
    }

    const replayStressCase = addCase(casePrefix + 'ReplayStress_004');
    if (shouldRegisterCase(replayStressCase, requestedItFilter)) {
      it(replayStressCase, 0, () => {
        const moves: Array<string> = ['right', 'down', 'left', 'up'];
        let index = 0;
        for (let i = 0; i < 250; i++) {
          index = replayGridMoves(0, 0, moves, 7);
        }
        expect(index).assertEqual(0);
      });
    }

    const caseNamingCase = addCase(casePrefix + 'CaseNaming_005');
    if (shouldRegisterCase(caseNamingCase, requestedItFilter)) {
      it(caseNamingCase, 0, () => {
        const regex = /^Settings_MegaSyntheticNavigationStateReplayZeta_[A-Za-z0-9_]+_[0-9]{3}$/;
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

