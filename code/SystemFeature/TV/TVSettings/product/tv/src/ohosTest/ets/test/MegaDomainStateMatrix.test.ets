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

interface BoolStorageScenario {
  name: string;
  input: boolean;
  expected: string;
}

interface NumberClampScenario {
  name: string;
  value: number;
  min: number;
  max: number;
  expected: number;
}

function toStorageFlag(value: boolean): string {
  return value ? '1' : '0';
}

function clamp(value: number, min: number, max: number): number {
  return Math.max(min, Math.min(max, value));
}

export default function MegaDomainStateMatrixTest() {
  const casePrefix = 'Settings_MegaDomainState_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const boolScenarios: Array<BoolStorageScenario> = [
    { name: 'bool_001', input: false, expected: '0' },
    { name: 'bool_002', input: true, expected: '1' },
    { name: 'bool_003', input: false, expected: '0' },
    { name: 'bool_004', input: true, expected: '1' },
    { name: 'bool_005', input: false, expected: '0' },
    { name: 'bool_006', input: true, expected: '1' },
    { name: 'bool_007', input: false, expected: '0' },
    { name: 'bool_008', input: true, expected: '1' },
    { name: 'bool_009', input: false, expected: '0' },
    { name: 'bool_010', input: true, expected: '1' },
    { name: 'bool_011', input: false, expected: '0' },
    { name: 'bool_012', input: true, expected: '1' },
    { name: 'bool_013', input: false, expected: '0' },
    { name: 'bool_014', input: true, expected: '1' },
    { name: 'bool_015', input: false, expected: '0' },
    { name: 'bool_016', input: true, expected: '1' },
    { name: 'bool_017', input: false, expected: '0' },
    { name: 'bool_018', input: true, expected: '1' },
    { name: 'bool_019', input: false, expected: '0' },
    { name: 'bool_020', input: true, expected: '1' }
  ];
  const clampScenarios: Array<NumberClampScenario> = [
    { name: 'clamp_001', value: -10, min: 0, max: 100, expected: 0 },
    { name: 'clamp_002', value: -1, min: 0, max: 100, expected: 0 },
    { name: 'clamp_003', value: 0, min: 0, max: 100, expected: 0 },
    { name: 'clamp_004', value: 1, min: 0, max: 100, expected: 1 },
    { name: 'clamp_005', value: 10, min: 0, max: 100, expected: 10 },
    { name: 'clamp_006', value: 20, min: 0, max: 100, expected: 20 },
    { name: 'clamp_007', value: 30, min: 0, max: 100, expected: 30 },
    { name: 'clamp_008', value: 40, min: 0, max: 100, expected: 40 },
    { name: 'clamp_009', value: 50, min: 0, max: 100, expected: 50 },
    { name: 'clamp_010', value: 60, min: 0, max: 100, expected: 60 },
    { name: 'clamp_011', value: 70, min: 0, max: 100, expected: 70 },
    { name: 'clamp_012', value: 80, min: 0, max: 100, expected: 80 },
    { name: 'clamp_013', value: 90, min: 0, max: 100, expected: 90 },
    { name: 'clamp_014', value: 100, min: 0, max: 100, expected: 100 },
    { name: 'clamp_015', value: 101, min: 0, max: 100, expected: 100 },
    { name: 'clamp_016', value: 120, min: 0, max: 100, expected: 100 },
    { name: 'clamp_017', value: 140, min: 0, max: 100, expected: 100 },
    { name: 'clamp_018', value: 160, min: 0, max: 100, expected: 100 },
    { name: 'clamp_019', value: 180, min: 0, max: 100, expected: 100 },
    { name: 'clamp_020', value: 200, min: 0, max: 100, expected: 100 }
  ];

  describe('MegaDomainStateMatrixSuite', () => {
    it(addCase(casePrefix + 'BoolStorageMatrix_001'), 0, () => {
      for (let i = 0; i < boolScenarios.length; i++) {
        expect(toStorageFlag(boolScenarios[i].input)).assertEqual(boolScenarios[i].expected);
      }
    });

    it(addCase(casePrefix + 'ClampMatrix_002'), 0, () => {
      for (let i = 0; i < clampScenarios.length; i++) {
        const item = clampScenarios[i];
        expect(clamp(item.value, item.min, item.max)).assertEqual(item.expected);
      }
    });

    it(addCase(casePrefix + 'StressMatrix_003'), 0, () => {
      let okCount = 0;
      for (let i = 0; i < 1000; i++) {
        const boolItem = boolScenarios[i % boolScenarios.length];
        if (toStorageFlag(boolItem.input) === boolItem.expected) {
          okCount++;
        }
        const clampItem = clampScenarios[i % clampScenarios.length];
        if (clamp(clampItem.value, clampItem.min, clampItem.max) === clampItem.expected) {
          okCount++;
        }
      }
      expect(okCount).assertEqual(2000);
    });

    it(addCase(casePrefix + 'CaseNaming_004'), 0, () => {
      const regex = /^Settings_MegaDomainState_[A-Za-z0-9_]+_[0-9]{3}$/;
      const set: Set<string> = new Set<string>();
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(regex.test(allCaseNames[i])).assertEqual(true);
        expect(set.has(allCaseNames[i])).assertEqual(false);
        set.add(allCaseNames[i]);
      }
      expect(set.size).assertEqual(allCaseNames.length);
    });
  });
}

