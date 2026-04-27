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

interface LevelScenario {
  name: string;
  current: number;
  delta: number;
  min: number;
  max: number;
  expected: number;
}

interface LabelScenario {
  name: string;
  level: number;
  label: string;
}

function clampLevel(current: number, delta: number, min: number, max: number): number {
  const next = current + delta;
  if (next < min) {
    return min;
  }
  if (next > max) {
    return max;
  }
  return next;
}

function resolveLevelLabel(level: number): string {
  if (level <= 0) {
    return 'off';
  }
  if (level <= 20) {
    return 'low';
  }
  if (level <= 60) {
    return 'medium';
  }
  return 'high';
}

export default function MegaDisplayVolumeStateReplayTest() {
  const casePrefix = 'Settings_MegaDisplayVolumeReplay_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const levelScenarios: Array<LevelScenario> = [
    { name: 'level_001', current: 0, delta: -1, min: 0, max: 100, expected: 0 },
    { name: 'level_002', current: 0, delta: 1, min: 0, max: 100, expected: 1 },
    { name: 'level_003', current: 1, delta: 1, min: 0, max: 100, expected: 2 },
    { name: 'level_004', current: 2, delta: 1, min: 0, max: 100, expected: 3 },
    { name: 'level_005', current: 3, delta: 1, min: 0, max: 100, expected: 4 },
    { name: 'level_006', current: 4, delta: 1, min: 0, max: 100, expected: 5 },
    { name: 'level_007', current: 5, delta: 1, min: 0, max: 100, expected: 6 },
    { name: 'level_008', current: 6, delta: 1, min: 0, max: 100, expected: 7 },
    { name: 'level_009', current: 7, delta: 1, min: 0, max: 100, expected: 8 },
    { name: 'level_010', current: 8, delta: 1, min: 0, max: 100, expected: 9 },
    { name: 'level_011', current: 9, delta: 1, min: 0, max: 100, expected: 10 },
    { name: 'level_012', current: 10, delta: 5, min: 0, max: 100, expected: 15 },
    { name: 'level_013', current: 15, delta: 5, min: 0, max: 100, expected: 20 },
    { name: 'level_014', current: 20, delta: 5, min: 0, max: 100, expected: 25 },
    { name: 'level_015', current: 25, delta: 5, min: 0, max: 100, expected: 30 },
    { name: 'level_016', current: 30, delta: 5, min: 0, max: 100, expected: 35 },
    { name: 'level_017', current: 35, delta: 5, min: 0, max: 100, expected: 40 },
    { name: 'level_018', current: 40, delta: 5, min: 0, max: 100, expected: 45 },
    { name: 'level_019', current: 45, delta: 5, min: 0, max: 100, expected: 50 },
    { name: 'level_020', current: 50, delta: 5, min: 0, max: 100, expected: 55 },
    { name: 'level_021', current: 55, delta: 5, min: 0, max: 100, expected: 60 },
    { name: 'level_022', current: 60, delta: 5, min: 0, max: 100, expected: 65 },
    { name: 'level_023', current: 65, delta: 5, min: 0, max: 100, expected: 70 },
    { name: 'level_024', current: 70, delta: 5, min: 0, max: 100, expected: 75 },
    { name: 'level_025', current: 75, delta: 5, min: 0, max: 100, expected: 80 },
    { name: 'level_026', current: 80, delta: 5, min: 0, max: 100, expected: 85 },
    { name: 'level_027', current: 85, delta: 5, min: 0, max: 100, expected: 90 },
    { name: 'level_028', current: 90, delta: 5, min: 0, max: 100, expected: 95 },
    { name: 'level_029', current: 95, delta: 5, min: 0, max: 100, expected: 100 },
    { name: 'level_030', current: 100, delta: 5, min: 0, max: 100, expected: 100 },
    { name: 'level_031', current: 100, delta: -5, min: 0, max: 100, expected: 95 },
    { name: 'level_032', current: 95, delta: -5, min: 0, max: 100, expected: 90 },
    { name: 'level_033', current: 90, delta: -5, min: 0, max: 100, expected: 85 },
    { name: 'level_034', current: 85, delta: -5, min: 0, max: 100, expected: 80 },
    { name: 'level_035', current: 80, delta: -5, min: 0, max: 100, expected: 75 },
    { name: 'level_036', current: 75, delta: -5, min: 0, max: 100, expected: 70 },
    { name: 'level_037', current: 70, delta: -5, min: 0, max: 100, expected: 65 },
    { name: 'level_038', current: 65, delta: -5, min: 0, max: 100, expected: 60 },
    { name: 'level_039', current: 60, delta: -5, min: 0, max: 100, expected: 55 },
    { name: 'level_040', current: 55, delta: -5, min: 0, max: 100, expected: 50 },
    { name: 'level_041', current: 50, delta: -5, min: 0, max: 100, expected: 45 },
    { name: 'level_042', current: 45, delta: -5, min: 0, max: 100, expected: 40 },
    { name: 'level_043', current: 40, delta: -5, min: 0, max: 100, expected: 35 },
    { name: 'level_044', current: 35, delta: -5, min: 0, max: 100, expected: 30 },
    { name: 'level_045', current: 30, delta: -5, min: 0, max: 100, expected: 25 },
    { name: 'level_046', current: 25, delta: -5, min: 0, max: 100, expected: 20 },
    { name: 'level_047', current: 20, delta: -5, min: 0, max: 100, expected: 15 },
    { name: 'level_048', current: 15, delta: -5, min: 0, max: 100, expected: 10 },
    { name: 'level_049', current: 10, delta: -5, min: 0, max: 100, expected: 5 },
    { name: 'level_050', current: 5, delta: -5, min: 0, max: 100, expected: 0 }
  ];
  const labelScenarios: Array<LabelScenario> = [
    { name: 'label_001', level: 0, label: 'off' },
    { name: 'label_002', level: 1, label: 'low' },
    { name: 'label_003', level: 10, label: 'low' },
    { name: 'label_004', level: 20, label: 'low' },
    { name: 'label_005', level: 21, label: 'medium' },
    { name: 'label_006', level: 30, label: 'medium' },
    { name: 'label_007', level: 40, label: 'medium' },
    { name: 'label_008', level: 50, label: 'medium' },
    { name: 'label_009', level: 60, label: 'medium' },
    { name: 'label_010', level: 61, label: 'high' },
    { name: 'label_011', level: 70, label: 'high' },
    { name: 'label_012', level: 80, label: 'high' },
    { name: 'label_013', level: 90, label: 'high' },
    { name: 'label_014', level: 100, label: 'high' }
  ];

  describe('MegaDisplayVolumeStateReplaySuite', () => {
    it(addCase(casePrefix + 'LevelClampMatrix_001'), 0, () => {
      for (let i = 0; i < levelScenarios.length; i++) {
        const item = levelScenarios[i];
        expect(clampLevel(item.current, item.delta, item.min, item.max)).assertEqual(item.expected);
      }
    });

    it(addCase(casePrefix + 'LabelMatrix_002'), 0, () => {
      for (let i = 0; i < labelScenarios.length; i++) {
        expect(resolveLevelLabel(labelScenarios[i].level)).assertEqual(labelScenarios[i].label);
      }
    });

    it(addCase(casePrefix + 'StressReplay_003'), 0, () => {
      let okCount = 0;
      for (let i = 0; i < 1200; i++) {
        const levelItem = levelScenarios[i % levelScenarios.length];
        if (clampLevel(levelItem.current, levelItem.delta, levelItem.min, levelItem.max) === levelItem.expected) {
          okCount++;
        }
        const labelItem = labelScenarios[i % labelScenarios.length];
        if (resolveLevelLabel(labelItem.level) === labelItem.label) {
          okCount++;
        }
      }
      expect(okCount).assertEqual(2400);
    });

    it(addCase(casePrefix + 'BoundaryPresence_004'), 0, () => {
      expect(levelScenarios.some((item) => item.expected === 0)).assertEqual(true);
      expect(levelScenarios.some((item) => item.expected === 100)).assertEqual(true);
      expect(labelScenarios.some((item) => item.label === 'off')).assertEqual(true);
      expect(labelScenarios.some((item) => item.label === 'high')).assertEqual(true);
    });

    it(addCase(casePrefix + 'CaseNaming_005'), 0, () => {
      const regex = /^Settings_MegaDisplayVolumeReplay_[A-Za-z0-9_]+_[0-9]{3}$/;
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

