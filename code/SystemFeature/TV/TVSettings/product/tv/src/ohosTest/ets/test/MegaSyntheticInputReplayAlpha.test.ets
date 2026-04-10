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

function clampInputValue(value: number, min: number, max: number): number {
  return Math.min(max, Math.max(min, value));
}

function buildReplayToken(group: string, index: number): string {
  return group + '_' + index.toString().padStart(3, '0');
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

export default function MegaSyntheticInputReplayAlphaTest() {
  const casePrefix = 'Settings_MegaSyntheticInputReplayAlpha_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const requestedItFilter = getRequestedItFilter();
  const samples: Array<number> = [
    -15, -12, -10, -8, -6, -4, -2, -1,
    0, 1, 2, 3, 4, 5, 6, 7,
    8, 9, 10, 11, 12, 13, 14, 15,
    16, 18, 20, 22, 24, 26, 28, 30,
    32, 34, 36, 38, 40, 42, 44, 46,
    48, 50, 52, 54, 56, 58, 60, 62,
    64, 66, 68, 70, 72, 74, 76, 78,
    80, 82, 84, 86, 88, 90, 92, 95
  ];
  const ranges: Array<[number, number]> = [
    [0, 10],
    [5, 20],
    [10, 30],
    [15, 40],
    [20, 50],
    [25, 60],
    [30, 70],
    [35, 80]
  ];

  describe('MegaSyntheticInputReplayAlphaSuite', () => {
    const clampWithinBoundsCase = addCase(casePrefix + 'ClampWithinBounds_001');
    if (shouldRegisterCase(clampWithinBoundsCase, requestedItFilter)) {
      it(clampWithinBoundsCase, 0, () => {
        for (let i = 0; i < ranges.length; i++) {
          const min = ranges[i][0];
          const max = ranges[i][1];
          for (let j = 0; j < samples.length; j++) {
            const result = clampInputValue(samples[j], min, max);
            expect(result >= min).assertEqual(true);
            expect(result <= max).assertEqual(true);
          }
        }
      });
    }

    const clampBoundaryReplayCase = addCase(casePrefix + 'ClampBoundaryReplay_002');
    if (shouldRegisterCase(clampBoundaryReplayCase, requestedItFilter)) {
      it(clampBoundaryReplayCase, 0, () => {
        let boundaryHits = 0;
        for (let i = 0; i < ranges.length; i++) {
          const min = ranges[i][0];
          const max = ranges[i][1];
          for (let j = 0; j < samples.length; j++) {
            const result = clampInputValue(samples[j], min, max);
            if (samples[j] < min) {
              expect(result).assertEqual(min);
              boundaryHits++;
            }
            if (samples[j] > max) {
              expect(result).assertEqual(max);
              boundaryHits++;
            }
          }
        }
        expect(boundaryHits > 0).assertEqual(true);
      });
    }

    const replayTokenOrderCase = addCase(casePrefix + 'ReplayTokenOrder_003');
    if (shouldRegisterCase(replayTokenOrderCase, requestedItFilter)) {
      it(replayTokenOrderCase, 0, () => {
        const tokens: Array<string> = [];
        for (let i = 0; i < samples.length; i++) {
          tokens.push(buildReplayToken('alpha', i + 1));
        }
        expect(tokens[0]).assertEqual('alpha_001');
        expect(tokens[9]).assertEqual('alpha_010');
        expect(tokens[tokens.length - 1]).assertEqual('alpha_064');
      });
    }

    const replayStressAccumulatorCase = addCase(casePrefix + 'ReplayStressAccumulator_004');
    if (shouldRegisterCase(replayStressAccumulatorCase, requestedItFilter)) {
      it(replayStressAccumulatorCase, 0, () => {
        let sum = 0;
        for (let i = 0; i < 1200; i++) {
          const sample = samples[i % samples.length];
          const range = ranges[i % ranges.length];
          sum += clampInputValue(sample, range[0], range[1]);
        }
        expect(sum > 0).assertEqual(true);
      });
    }

    const caseNamingCase = addCase(casePrefix + 'CaseNaming_005');
    if (shouldRegisterCase(caseNamingCase, requestedItFilter)) {
      it(caseNamingCase, 0, () => {
        const regex = /^Settings_MegaSyntheticInputReplayAlpha_[A-Za-z0-9_]+_[0-9]{3}$/;
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

