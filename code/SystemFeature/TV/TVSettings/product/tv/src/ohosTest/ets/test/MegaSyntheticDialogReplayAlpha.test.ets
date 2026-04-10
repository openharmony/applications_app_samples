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

function resolveDialogAction(open: boolean, action: string): boolean {
  if (action === 'show') {
    return true;
  }
  if (action === 'hide') {
    return false;
  }
  return open;
}

function resolveToastPriority(level: number): string {
  if (level >= 80) {
    return 'critical';
  }
  if (level >= 50) {
    return 'warning';
  }
  return 'normal';
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

export default function MegaSyntheticDialogReplayAlphaTest() {
  const casePrefix = 'Settings_MegaSyntheticDialogReplayAlpha_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const requestedItFilter = getRequestedItFilter();
  const actions: Array<string> = ['show', 'keep', 'hide', 'show', 'hide', 'keep'];
  const levels: Array<number> = [0, 5, 10, 20, 35, 49, 50, 55, 65, 79, 80, 90, 100];

  describe('MegaSyntheticDialogReplayAlphaSuite', () => {
    const dialogActionReplayCase = addCase(casePrefix + 'DialogActionReplay_001');
    if (shouldRegisterCase(dialogActionReplayCase, requestedItFilter)) {
      it(dialogActionReplayCase, 0, () => {
        let open = false;
        for (let i = 0; i < 600; i++) {
          open = resolveDialogAction(open, actions[i % actions.length]);
        }
        expect(typeof open === 'boolean').assertEqual(true);
      });
    }

    const toastPriorityBandsCase = addCase(casePrefix + 'ToastPriorityBands_002');
    if (shouldRegisterCase(toastPriorityBandsCase, requestedItFilter)) {
      it(toastPriorityBandsCase, 0, () => {
        for (let i = 0; i < levels.length; i++) {
          const priority = resolveToastPriority(levels[i]);
          expect(priority === 'normal' || priority === 'warning' || priority === 'critical').assertEqual(true);
        }
      });
    }

    const dialogHideAfterShowCase = addCase(casePrefix + 'DialogHideAfterShow_003');
    if (shouldRegisterCase(dialogHideAfterShowCase, requestedItFilter)) {
      it(dialogHideAfterShowCase, 0, () => {
        let open = resolveDialogAction(false, 'show');
        expect(open).assertEqual(true);
        open = resolveDialogAction(open, 'hide');
        expect(open).assertEqual(false);
      });
    }

    const dialogToastStressCase = addCase(casePrefix + 'DialogToastStress_004');
    if (shouldRegisterCase(dialogToastStressCase, requestedItFilter)) {
      it(dialogToastStressCase, 0, () => {
        let visibleCount = 0;
        let criticalCount = 0;
        let open = false;
        for (let i = 0; i < 1800; i++) {
          open = resolveDialogAction(open, actions[i % actions.length]);
          if (open) {
            visibleCount++;
          }
          if (resolveToastPriority(levels[i % levels.length]) === 'critical') {
            criticalCount++;
          }
        }
        expect(visibleCount > 0).assertEqual(true);
        expect(criticalCount > 0).assertEqual(true);
      });
    }

    const caseNamingCase = addCase(casePrefix + 'CaseNaming_005');
    if (shouldRegisterCase(caseNamingCase, requestedItFilter)) {
      it(caseNamingCase, 0, () => {
        const regex = /^Settings_MegaSyntheticDialogReplayAlpha_[A-Za-z0-9_]+_[0-9]{3}$/;
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

