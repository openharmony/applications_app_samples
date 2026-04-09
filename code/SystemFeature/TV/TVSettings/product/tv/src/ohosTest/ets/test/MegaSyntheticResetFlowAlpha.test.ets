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

function resolveResetResult(code: number): string {
  if (code === 0) {
    return 'success';
  }
  if (code > 0) {
    return 'retry';
  }
  return 'blocked';
}

function shouldCloseDialog(result: string): boolean {
  return result === 'success' || result === 'blocked';
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

export default function MegaSyntheticResetFlowAlphaTest() {
  const casePrefix = 'Settings_MegaSyntheticResetFlowAlpha_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const requestedItFilter = getRequestedItFilter();
  const codes: Array<number> = [-5, -3, -1, 0, 1, 2, 3, 5, 8];

  describe('MegaSyntheticResetFlowAlphaSuite', () => {
    const resetResultBandsCase = addCase(casePrefix + 'ResetResultBands_001');
    if (shouldRegisterCase(resetResultBandsCase, requestedItFilter)) {
      it(resetResultBandsCase, 0, () => {
        for (let i = 0; i < codes.length; i++) {
          const result = resolveResetResult(codes[i]);
          expect(result === 'success' || result === 'retry' || result === 'blocked').assertEqual(true);
        }
      });
    }

    const dialogCloseRulesCase = addCase(casePrefix + 'DialogCloseRules_002');
    if (shouldRegisterCase(dialogCloseRulesCase, requestedItFilter)) {
      it(dialogCloseRulesCase, 0, () => {
        expect(shouldCloseDialog('success')).assertEqual(true);
        expect(shouldCloseDialog('blocked')).assertEqual(true);
        expect(shouldCloseDialog('retry')).assertEqual(false);
      });
    }

    const resetReplayLoopCase = addCase(casePrefix + 'ResetReplayLoop_003');
    if (shouldRegisterCase(resetReplayLoopCase, requestedItFilter)) {
      it(resetReplayLoopCase, 0, () => {
        let closeCount = 0;
        for (let i = 0; i < 1500; i++) {
          const result = resolveResetResult(codes[i % codes.length]);
          if (shouldCloseDialog(result)) {
            closeCount++;
          }
        }
        expect(closeCount > 0).assertEqual(true);
      });
    }

    const resetSuccessPathCase = addCase(casePrefix + 'ResetSuccessPath_004');
    if (shouldRegisterCase(resetSuccessPathCase, requestedItFilter)) {
      it(resetSuccessPathCase, 0, () => {
        const result = resolveResetResult(0);
        expect(result).assertEqual('success');
        expect(shouldCloseDialog(result)).assertEqual(true);
      });
    }

    const caseNamingCase = addCase(casePrefix + 'CaseNaming_005');
    if (shouldRegisterCase(caseNamingCase, requestedItFilter)) {
      it(caseNamingCase, 0, () => {
        const regex = /^Settings_MegaSyntheticResetFlowAlpha_[A-Za-z0-9_]+_[0-9]{3}$/;
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

