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

interface FocusScenario {
  name: string;
  focusIndex: number;
  currentOffset: number;
  visibleHeight: number;
  itemHeight: number;
  itemSpace: number;
  bufferHeight: number;
  expectedOffset: number;
}

function calcAdjustOffsetY(
  focusIndex: number,
  currentOffset: number,
  visibleHeight: number,
  itemHeight: number,
  itemSpace: number,
  bufferHeight: number
): number {
  const enableAreaTop = currentOffset + bufferHeight;
  const enableAreaBottom = currentOffset + visibleHeight - bufferHeight;
  const currentTop = focusIndex * itemHeight + focusIndex * itemSpace;
  const currentBottom = currentTop + itemHeight;
  const inArea = currentTop >= enableAreaTop && currentBottom <= enableAreaBottom;
  if (inArea) {
    return currentOffset;
  }
  if (currentTop < enableAreaTop) {
    return Math.max(0, currentTop - bufferHeight);
  }
  return currentBottom - visibleHeight + bufferHeight;
}

export default function MegaFocusScrollBoundaryMatrixTest() {
  const casePrefix = 'Settings_MegaFocusScrollBoundary_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const focusScenarios: Array<FocusScenario> = [
    { name: 'focus_001', focusIndex: 0, currentOffset: 0, visibleHeight: 300, itemHeight: 60, itemSpace: 10, bufferHeight: 20, expectedOffset: 0 },
    { name: 'focus_002', focusIndex: 1, currentOffset: 0, visibleHeight: 300, itemHeight: 60, itemSpace: 10, bufferHeight: 20, expectedOffset: 0 },
    { name: 'focus_003', focusIndex: 2, currentOffset: 0, visibleHeight: 300, itemHeight: 60, itemSpace: 10, bufferHeight: 20, expectedOffset: 0 },
    { name: 'focus_004', focusIndex: 3, currentOffset: 0, visibleHeight: 300, itemHeight: 60, itemSpace: 10, bufferHeight: 20, expectedOffset: 0 },
    { name: 'focus_005', focusIndex: 4, currentOffset: 20, visibleHeight: 300, itemHeight: 60, itemSpace: 10, bufferHeight: 20, expectedOffset: 60 },
    { name: 'focus_006', focusIndex: 5, currentOffset: 90, visibleHeight: 300, itemHeight: 60, itemSpace: 10, bufferHeight: 20, expectedOffset: 130 },
    { name: 'focus_007', focusIndex: 6, currentOffset: 160, visibleHeight: 300, itemHeight: 60, itemSpace: 10, bufferHeight: 20, expectedOffset: 200 },
    { name: 'focus_008', focusIndex: 7, currentOffset: 230, visibleHeight: 300, itemHeight: 60, itemSpace: 10, bufferHeight: 20, expectedOffset: 270 },
    { name: 'focus_009', focusIndex: 8, currentOffset: 300, visibleHeight: 300, itemHeight: 60, itemSpace: 10, bufferHeight: 20, expectedOffset: 340 },
    { name: 'focus_010', focusIndex: 9, currentOffset: 370, visibleHeight: 300, itemHeight: 60, itemSpace: 10, bufferHeight: 20, expectedOffset: 410 },
    { name: 'focus_011', focusIndex: 10, currentOffset: 440, visibleHeight: 300, itemHeight: 60, itemSpace: 10, bufferHeight: 20, expectedOffset: 480 },
    { name: 'focus_012', focusIndex: 11, currentOffset: 510, visibleHeight: 300, itemHeight: 60, itemSpace: 10, bufferHeight: 20, expectedOffset: 550 }
  ];

  describe('MegaFocusScrollBoundaryMatrixSuite', () => {
    it(addCase(casePrefix + 'OffsetMatrix_001'), 0, () => {
      for (let i = 0; i < focusScenarios.length; i++) {
        const item = focusScenarios[i];
        expect(
          calcAdjustOffsetY(
            item.focusIndex,
            item.currentOffset,
            item.visibleHeight,
            item.itemHeight,
            item.itemSpace,
            item.bufferHeight
          )
        ).assertEqual(item.expectedOffset);
      }
    });

    it(addCase(casePrefix + 'StressOffset_002'), 0, () => {
      let okCount = 0;
      for (let i = 0; i < 1000; i++) {
        const item = focusScenarios[i % focusScenarios.length];
        const actual = calcAdjustOffsetY(
          item.focusIndex,
          item.currentOffset,
          item.visibleHeight,
          item.itemHeight,
          item.itemSpace,
          item.bufferHeight
        );
        if (actual === item.expectedOffset) {
          okCount++;
        }
      }
      expect(okCount).assertEqual(1000);
    });

    it(addCase(casePrefix + 'BoundaryCoverage_003'), 0, () => {
      expect(focusScenarios.some((item) => item.expectedOffset < 0)).assertEqual(false);
      expect(focusScenarios.some((item) => item.expectedOffset === 0)).assertEqual(true);
      expect(focusScenarios.some((item) => item.expectedOffset > 0)).assertEqual(true);
      expect(focusScenarios.length).assertEqual(12);
    });

    it(addCase(casePrefix + 'CaseNaming_004'), 0, () => {
      const regex = /^Settings_MegaFocusScrollBoundary_[A-Za-z0-9_]+_[0-9]{3}$/;
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

