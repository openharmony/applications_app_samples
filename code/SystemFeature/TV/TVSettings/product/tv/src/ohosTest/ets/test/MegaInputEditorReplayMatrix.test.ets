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

interface EditorInputScenario {
  name: string;
  value: string;
  expectedIpValid: boolean;
}

interface ConfirmScenario {
  name: string;
  length: number;
  min: number;
  expectedTarget: string;
}

function isValidIpv4(value: string): boolean {
  const ipv4Regex: RegExp =
    /^((2(5[0-5]|[0-4]\d))|[0-1]?\d{1,2})(\.((2(5[0-5]|[0-4]\d))|[0-1]?\d{1,2})){3}$/;
  return ipv4Regex.test(value);
}

function nextFocusTarget(length: number, min: number): string {
  return length >= min ? 'confirm' : 'back';
}

export default function MegaInputEditorReplayMatrixTest() {
  const casePrefix = 'Settings_MegaInputEditorReplay_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const editorScenarios: Array<EditorInputScenario> = [
    { name: 'editor_001', value: '0.0.0.0', expectedIpValid: true },
    { name: 'editor_002', value: '1.1.1.1', expectedIpValid: true },
    { name: 'editor_003', value: '8.8.8.8', expectedIpValid: true },
    { name: 'editor_004', value: '10.0.0.1', expectedIpValid: true },
    { name: 'editor_005', value: '10.0.0.256', expectedIpValid: false },
    { name: 'editor_006', value: '172.16.0.1', expectedIpValid: true },
    { name: 'editor_007', value: '172.16.0.300', expectedIpValid: false },
    { name: 'editor_008', value: '192.168.0.1', expectedIpValid: true },
    { name: 'editor_009', value: '192.168.0.256', expectedIpValid: false },
    { name: 'editor_010', value: '255.255.255.255', expectedIpValid: true },
    { name: 'editor_011', value: '256.255.255.255', expectedIpValid: false },
    { name: 'editor_012', value: '1.2.3', expectedIpValid: false },
    { name: 'editor_013', value: '1.2.3.4.5', expectedIpValid: false },
    { name: 'editor_014', value: '11.22.33.44', expectedIpValid: true },
    { name: 'editor_015', value: '22.33.44.55', expectedIpValid: true },
    { name: 'editor_016', value: '33.44.55.66', expectedIpValid: true },
    { name: 'editor_017', value: '44.55.66.77', expectedIpValid: true },
    { name: 'editor_018', value: '55.66.77.88', expectedIpValid: true },
    { name: 'editor_019', value: '66.77.88.99', expectedIpValid: true },
    { name: 'editor_020', value: '77.88.99.100', expectedIpValid: true },
    { name: 'editor_021', value: '88.99.100.111', expectedIpValid: true },
    { name: 'editor_022', value: '99.100.111.122', expectedIpValid: true },
    { name: 'editor_023', value: '111.122.133.144', expectedIpValid: true },
    { name: 'editor_024', value: '122.133.144.155', expectedIpValid: true },
    { name: 'editor_025', value: '133.144.155.166', expectedIpValid: true },
    { name: 'editor_026', value: '144.155.166.177', expectedIpValid: true },
    { name: 'editor_027', value: '155.166.177.188', expectedIpValid: true },
    { name: 'editor_028', value: '166.177.188.199', expectedIpValid: true },
    { name: 'editor_029', value: '177.188.199.210', expectedIpValid: true },
    { name: 'editor_030', value: '188.199.210.221', expectedIpValid: true }
  ];
  const confirmScenarios: Array<ConfirmScenario> = [
    { name: 'confirm_001', length: 0, min: 1, expectedTarget: 'back' },
    { name: 'confirm_002', length: 1, min: 1, expectedTarget: 'confirm' },
    { name: 'confirm_003', length: 7, min: 8, expectedTarget: 'back' },
    { name: 'confirm_004', length: 8, min: 8, expectedTarget: 'confirm' },
    { name: 'confirm_005', length: 9, min: 8, expectedTarget: 'confirm' },
    { name: 'confirm_006', length: 2, min: 3, expectedTarget: 'back' },
    { name: 'confirm_007', length: 3, min: 3, expectedTarget: 'confirm' },
    { name: 'confirm_008', length: 4, min: 3, expectedTarget: 'confirm' },
    { name: 'confirm_009', length: 5, min: 6, expectedTarget: 'back' },
    { name: 'confirm_010', length: 6, min: 6, expectedTarget: 'confirm' }
  ];

  describe('MegaInputEditorReplayMatrixSuite', () => {
    it(addCase(casePrefix + 'EditorIpMatrix_001'), 0, () => {
      for (let i = 0; i < editorScenarios.length; i++) {
        expect(isValidIpv4(editorScenarios[i].value)).assertEqual(editorScenarios[i].expectedIpValid);
      }
    });

    it(addCase(casePrefix + 'FocusTargetMatrix_002'), 0, () => {
      for (let i = 0; i < confirmScenarios.length; i++) {
        expect(nextFocusTarget(confirmScenarios[i].length, confirmScenarios[i].min)).assertEqual(confirmScenarios[i].expectedTarget);
      }
    });

    it(addCase(casePrefix + 'StressEditorReplay_003'), 0, () => {
      let okCount = 0;
      for (let i = 0; i < 1200; i++) {
        const editor = editorScenarios[i % editorScenarios.length];
        if (isValidIpv4(editor.value) === editor.expectedIpValid) {
          okCount++;
        }
        const confirm = confirmScenarios[i % confirmScenarios.length];
        if (nextFocusTarget(confirm.length, confirm.min) === confirm.expectedTarget) {
          okCount++;
        }
      }
      expect(okCount).assertEqual(2400);
    });

    it(addCase(casePrefix + 'Coverage_004'), 0, () => {
      expect(editorScenarios.some((item) => item.expectedIpValid === false)).assertEqual(true);
      expect(editorScenarios.some((item) => item.expectedIpValid === true)).assertEqual(true);
      expect(confirmScenarios.some((item) => item.expectedTarget === 'back')).assertEqual(true);
      expect(confirmScenarios.some((item) => item.expectedTarget === 'confirm')).assertEqual(true);
    });

    it(addCase(casePrefix + 'CaseNaming_005'), 0, () => {
      const regex = /^Settings_MegaInputEditorReplay_[A-Za-z0-9_]+_[0-9]{3}$/;
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

