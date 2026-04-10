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

function pushRecentStack(stack: Array<string>, item: string, limit: number): Array<string> {
  const next = stack.slice();
  next.unshift(item);
  if (next.length > limit) {
    next.length = limit;
  }
  return next;
}

function isLifoOrder(stack: Array<string>): boolean {
  for (let i = 1; i < stack.length; i++) {
    if (stack[i - 1] === stack[i]) {
      return false;
    }
  }
  return true;
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

export default function MegaSyntheticStateReplayBetaTest() {
  const casePrefix = 'Settings_MegaSyntheticStateReplayBeta_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const requestedItFilter = getRequestedItFilter();
  const pages: Array<string> = [
    'network', 'bluetooth', 'display', 'sound', 'system', 'general', 'input', 'hotspot',
    'projection', 'about', 'device', 'storage', 'security', 'language', 'time', 'reset'
  ];

  describe('MegaSyntheticStateReplayBetaSuite', () => {
    const recentStackLimitCase = addCase(casePrefix + 'RecentStackLimit_001');
    if (shouldRegisterCase(recentStackLimitCase, requestedItFilter)) {
      it(recentStackLimitCase, 0, () => {
        let stack: Array<string> = [];
        for (let i = 0; i < pages.length; i++) {
          stack = pushRecentStack(stack, pages[i], 8);
          expect(stack.length <= 8).assertEqual(true);
        }
        expect(stack.length).assertEqual(8);
      });
    }

    const recentStackTopCase = addCase(casePrefix + 'RecentStackTop_002');
    if (shouldRegisterCase(recentStackTopCase, requestedItFilter)) {
      it(recentStackTopCase, 0, () => {
        let stack: Array<string> = [];
        for (let i = 0; i < pages.length; i++) {
          stack = pushRecentStack(stack, pages[i], 8);
          expect(stack[0]).assertEqual(pages[i]);
        }
      });
    }

    const recentStackLifoCase = addCase(casePrefix + 'RecentStackLifo_003');
    if (shouldRegisterCase(recentStackLifoCase, requestedItFilter)) {
      it(recentStackLifoCase, 0, () => {
        let stack: Array<string> = [];
        for (let i = 0; i < 40; i++) {
          stack = pushRecentStack(stack, pages[i % pages.length] + '_' + i, 8);
        }
        expect(isLifoOrder(stack)).assertEqual(true);
        expect(stack.length).assertEqual(8);
      });
    }

    const stackStressReplayCase = addCase(casePrefix + 'StackStressReplay_004');
    if (shouldRegisterCase(stackStressReplayCase, requestedItFilter)) {
      it(stackStressReplayCase, 0, () => {
        let stack: Array<string> = [];
        for (let i = 0; i < 1500; i++) {
          stack = pushRecentStack(stack, pages[i % pages.length] + '_' + i, 8);
        }
        expect(stack.length).assertEqual(8);
        expect(stack[0]).assertEqual('reset_1499');
      });
    }

    const caseNamingCase = addCase(casePrefix + 'CaseNaming_005');
    if (shouldRegisterCase(caseNamingCase, requestedItFilter)) {
      it(caseNamingCase, 0, () => {
        const regex = /^Settings_MegaSyntheticStateReplayBeta_[A-Za-z0-9_]+_[0-9]{3}$/;
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

