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

function resolveDirectionalOffset(direction: string): number {
  if (direction === 'up') {
    return -10;
  }
  if (direction === 'down') {
    return 10;
  }
  if (direction === 'left') {
    return -1;
  }
  if (direction === 'right') {
    return 1;
  }
  return 0;
}

function applyDirectionalSequence(origin: number, directions: Array<string>): number {
  let cursor = origin;
  for (let i = 0; i < directions.length; i++) {
    cursor += resolveDirectionalOffset(directions[i]);
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

export default function MegaSyntheticNavigationStateReplayGammaTest() {
  const casePrefix = 'Settings_MegaSyntheticNavigationStateReplayGamma_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const requestedItFilter = getRequestedItFilter();

  describe('MegaSyntheticNavigationStateReplayGammaSuite', () => {
    const offsetLookupCase = addCase(casePrefix + 'OffsetLookup_001');
    if (shouldRegisterCase(offsetLookupCase, requestedItFilter)) {
      it(offsetLookupCase, 0, () => {
        expect(resolveDirectionalOffset('up')).assertEqual(-10);
        expect(resolveDirectionalOffset('down')).assertEqual(10);
        expect(resolveDirectionalOffset('left')).assertEqual(-1);
        expect(resolveDirectionalOffset('right')).assertEqual(1);
        expect(resolveDirectionalOffset('idle')).assertEqual(0);
      });
    }

    const sequenceReplayCase = addCase(casePrefix + 'SequenceReplay_002');
    if (shouldRegisterCase(sequenceReplayCase, requestedItFilter)) {
      it(sequenceReplayCase, 0, () => {
        const directions: Array<string> = ['right', 'right', 'down', 'left', 'up', 'down'];
        expect(applyDirectionalSequence(25, directions)).assertEqual(35);
      });
    }

    const reverseBalanceCase = addCase(casePrefix + 'ReverseBalance_003');
    if (shouldRegisterCase(reverseBalanceCase, requestedItFilter)) {
      it(reverseBalanceCase, 0, () => {
        const directions: Array<string> = ['left', 'left', 'right', 'up', 'down', 'right'];
        expect(applyDirectionalSequence(40, directions)).assertEqual(40);
      });
    }

    const stressReplayCase = addCase(casePrefix + 'StressReplay_004');
    if (shouldRegisterCase(stressReplayCase, requestedItFilter)) {
      it(stressReplayCase, 0, () => {
        const directions: Array<string> = ['right', 'down', 'left', 'up'];
        let cursor = 100;
        for (let i = 0; i < 300; i++) {
          cursor = applyDirectionalSequence(cursor, directions);
        }
        expect(cursor).assertEqual(100);
      });
    }

    const caseNamingCase = addCase(casePrefix + 'CaseNaming_005');
    if (shouldRegisterCase(caseNamingCase, requestedItFilter)) {
      it(caseNamingCase, 0, () => {
        const regex = /^Settings_MegaSyntheticNavigationStateReplayGamma_[A-Za-z0-9_]+_[0-9]{3}$/;
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

