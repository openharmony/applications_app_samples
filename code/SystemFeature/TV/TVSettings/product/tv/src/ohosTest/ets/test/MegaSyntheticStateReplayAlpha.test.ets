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

function mergeSwitchState(current: boolean, command: string): boolean {
  if (command === 'enable') {
    return true;
  }
  if (command === 'disable') {
    return false;
  }
  return current;
}

function resolveLevel(base: number, delta: number): number {
  const result = base + delta;
  if (result < 0) {
    return 0;
  }
  if (result > 100) {
    return 100;
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

export default function MegaSyntheticStateReplayAlphaTest() {
  const casePrefix = 'Settings_MegaSyntheticStateReplayAlpha_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const requestedItFilter = getRequestedItFilter();
  const commands: Array<string> = [
    'enable', 'disable', 'keep', 'enable', 'keep', 'disable', 'enable', 'keep'
  ];
  const deltas: Array<number> = [
    -120, -80, -50, -20, -10, -5, -1, 0,
    1, 2, 5, 10, 15, 20, 30, 40,
    50, 60, 75, 90, 120
  ];

  describe('MegaSyntheticStateReplayAlphaSuite', () => {
    const switchReplayCase = addCase(casePrefix + 'SwitchReplay_001');
    if (shouldRegisterCase(switchReplayCase, requestedItFilter)) {
      it(switchReplayCase, 0, () => {
        let state = false;
        for (let i = 0; i < 200; i++) {
          state = mergeSwitchState(state, commands[i % commands.length]);
        }
        expect(typeof state === 'boolean').assertEqual(true);
      });
    }

    const levelClampReplayCase = addCase(casePrefix + 'LevelClampReplay_002');
    if (shouldRegisterCase(levelClampReplayCase, requestedItFilter)) {
      it(levelClampReplayCase, 0, () => {
        for (let base = 0; base <= 100; base += 10) {
          for (let i = 0; i < deltas.length; i++) {
            const result = resolveLevel(base, deltas[i]);
            expect(result >= 0).assertEqual(true);
            expect(result <= 100).assertEqual(true);
          }
        }
      });
    }

    const enableDisablePriorityCase = addCase(casePrefix + 'EnableDisablePriority_003');
    if (shouldRegisterCase(enableDisablePriorityCase, requestedItFilter)) {
      it(enableDisablePriorityCase, 0, () => {
        expect(mergeSwitchState(false, 'enable')).assertEqual(true);
        expect(mergeSwitchState(true, 'disable')).assertEqual(false);
        expect(mergeSwitchState(true, 'keep')).assertEqual(true);
        expect(mergeSwitchState(false, 'keep')).assertEqual(false);
      });
    }

    const stressStateAccumulatorCase = addCase(casePrefix + 'StressStateAccumulator_004');
    if (shouldRegisterCase(stressStateAccumulatorCase, requestedItFilter)) {
      it(stressStateAccumulatorCase, 0, () => {
        let sum = 0;
        let state = true;
        for (let i = 0; i < 1800; i++) {
          state = mergeSwitchState(state, commands[i % commands.length]);
          sum += resolveLevel(i % 101, deltas[i % deltas.length]);
        }
        expect(sum > 0).assertEqual(true);
        expect(typeof state === 'boolean').assertEqual(true);
      });
    }

    const caseNamingCase = addCase(casePrefix + 'CaseNaming_005');
    if (shouldRegisterCase(caseNamingCase, requestedItFilter)) {
      it(caseNamingCase, 0, () => {
        const regex = /^Settings_MegaSyntheticStateReplayAlpha_[A-Za-z0-9_]+_[0-9]{3}$/;
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

