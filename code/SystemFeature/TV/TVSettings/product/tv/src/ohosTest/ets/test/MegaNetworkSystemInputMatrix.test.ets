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

interface InputScenario {
  name: string;
  value: string;
  min: number;
  max: number;
  expectedValid: boolean;
}

interface IpScenario {
  name: string;
  value: string;
  expectedValid: boolean;
}

interface UpdateScenario {
  name: string;
  diffExists: boolean;
  fullExists: boolean;
  expectedPath: string;
  existed: boolean;
}

interface StatusScenario {
  name: string;
  state: number;
  text: string;
}

interface UpdatePathResult {
  existed: boolean;
  targetPath: string;
}

function validateLengthRange(value: string, min: number, max: number): boolean {
  return value.length >= min && value.length <= max;
}

function isValidIpv4(value: string): boolean {
  const ipv4Regex: RegExp =
    /^((2(5[0-5]|[0-4]\d))|[0-1]?\d{1,2})(\.((2(5[0-5]|[0-4]\d))|[0-1]?\d{1,2})){3}$/;
  return ipv4Regex.test(value);
}

function resolveUpdatePath(diffExists: boolean, fullExists: boolean): UpdatePathResult {
  if (diffExists) {
    return { existed: true, targetPath: '/storage/External/updater_diff.zip' };
  }
  if (fullExists) {
    return { existed: true, targetPath: '/storage/External/updater_full.zip' };
  }
  return { existed: false, targetPath: '' };
}

function resolveConnectionText(state: number): string {
  if (state === 0) {
    return '未连接';
  }
  if (state === 1) {
    return '连接中';
  }
  if (state === 2) {
    return '已连接';
  }
  if (state === 3) {
    return '断开中';
  }
  return '';
}

function trimText(value: string): string {
  return value.trim();
}

export default function MegaNetworkSystemInputMatrixTest() {
  const casePrefix = 'Settings_MegaNetworkSystemInput_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const inputScenarios: Array<InputScenario> = [
    { name: 'input_001', value: '', min: 1, max: 32, expectedValid: false },
    { name: 'input_002', value: 'a', min: 1, max: 32, expectedValid: true },
    { name: 'input_003', value: 'ab', min: 1, max: 32, expectedValid: true },
    { name: 'input_004', value: 'abc', min: 1, max: 32, expectedValid: true },
    { name: 'input_005', value: 'abcd', min: 1, max: 32, expectedValid: true },
    { name: 'input_006', value: 'abcde', min: 1, max: 32, expectedValid: true },
    { name: 'input_007', value: 'abcdef', min: 1, max: 32, expectedValid: true },
    { name: 'input_008', value: 'abcdefg', min: 1, max: 32, expectedValid: true },
    { name: 'input_009', value: 'abcdefgh', min: 8, max: 63, expectedValid: true },
    { name: 'input_010', value: 'abcdefghi', min: 8, max: 63, expectedValid: true },
    { name: 'input_011', value: 'abcdefghij', min: 8, max: 63, expectedValid: true },
    { name: 'input_012', value: 'abcdefghijk', min: 8, max: 63, expectedValid: true },
    { name: 'input_013', value: 'abcdefghijkl', min: 8, max: 63, expectedValid: true },
    { name: 'input_014', value: 'abcdefghijklm', min: 8, max: 63, expectedValid: true },
    { name: 'input_015', value: 'abcdefghijklmn', min: 8, max: 63, expectedValid: true },
    { name: 'input_016', value: 'abcdefghijklmno', min: 8, max: 63, expectedValid: true },
    { name: 'input_017', value: 'abcdefghijklmnop', min: 8, max: 63, expectedValid: true },
    { name: 'input_018', value: 'abcdefghijklmnopq', min: 8, max: 63, expectedValid: true },
    { name: 'input_019', value: 'abcdefghijklmnopqr', min: 8, max: 63, expectedValid: true },
    { name: 'input_020', value: 'abcdefghijklmnopqrs', min: 8, max: 63, expectedValid: true },
    { name: 'input_021', value: 'abcdefghijklmnopqrst', min: 8, max: 63, expectedValid: true },
    { name: 'input_022', value: 'abcdefghijklmnopqrstu', min: 8, max: 63, expectedValid: true },
    { name: 'input_023', value: 'abcdefghijklmnopqrstuv', min: 8, max: 63, expectedValid: true },
    { name: 'input_024', value: 'abcdefghijklmnopqrstuvw', min: 8, max: 63, expectedValid: true },
    { name: 'input_025', value: 'abcdefghijklmnopqrstuvwx', min: 8, max: 63, expectedValid: true },
    { name: 'input_026', value: 'abcdefghijklmnopqrstuvwxy', min: 8, max: 63, expectedValid: true },
    { name: 'input_027', value: 'abcdefghijklmnopqrstuvwxyz', min: 8, max: 63, expectedValid: true },
    { name: 'input_028', value: 'abcdefghijklmnopqrstuvwxyz1', min: 8, max: 63, expectedValid: true },
    { name: 'input_029', value: 'abcdefghijklmnopqrstuvwxyz12', min: 8, max: 63, expectedValid: true },
    { name: 'input_030', value: 'abcdefghijklmnopqrstuvwxyz123', min: 8, max: 63, expectedValid: true },
    { name: 'input_031', value: 'abcdefghijklmnopqrstuvwxyz1234', min: 8, max: 63, expectedValid: true },
    { name: 'input_032', value: 'abcdefghijklmnopqrstuvwxyz12345', min: 8, max: 63, expectedValid: true },
    { name: 'input_033', value: 'abcdefghijklmnopqrstuvwxyz123456', min: 8, max: 63, expectedValid: true },
    { name: 'input_034', value: 'abcdefghijklmnopqrstuvwxyz1234567', min: 8, max: 63, expectedValid: true },
    { name: 'input_035', value: 'abcdefghijklmnopqrstuvwxyz12345678', min: 8, max: 63, expectedValid: true },
    { name: 'input_036', value: 'abcdefghijklmnopqrstuvwxyz123456789', min: 8, max: 63, expectedValid: true },
    { name: 'input_037', value: 'abcdefghijklmnopqrstuvwxyz1234567890', min: 8, max: 63, expectedValid: true },
    { name: 'input_038', value: 'abcdefghijklmnopqrstuvwxyz12345678901', min: 8, max: 63, expectedValid: true },
    { name: 'input_039', value: 'abcdefghijklmnopqrstuvwxyz123456789012', min: 8, max: 63, expectedValid: true },
    { name: 'input_040', value: 'abcdefghijklmnopqrstuvwxyz1234567890123', min: 8, max: 63, expectedValid: true },
    { name: 'input_041', value: 'abcdefghijklmnopqrstuvwxyz12345678901234', min: 8, max: 63, expectedValid: true },
    { name: 'input_042', value: 'abcdefghijklmnopqrstuvwxyz123456789012345', min: 8, max: 63, expectedValid: true },
    { name: 'input_043', value: 'abcdefghijklmnopqrstuvwxyz1234567890123456', min: 8, max: 63, expectedValid: true },
    { name: 'input_044', value: 'abcdefghijklmnopqrstuvwxyz12345678901234567', min: 8, max: 63, expectedValid: true },
    { name: 'input_045', value: 'abcdefghijklmnopqrstuvwxyz123456789012345678', min: 8, max: 63, expectedValid: true },
    { name: 'input_046', value: 'abcdefghijklmnopqrstuvwxyz1234567890123456789', min: 8, max: 63, expectedValid: true },
    { name: 'input_047', value: 'abcdefghijklmnopqrstuvwxyz12345678901234567890', min: 8, max: 63, expectedValid: true },
    { name: 'input_048', value: 'abcdefghijklmnopqrstuvwxyz123456789012345678901', min: 8, max: 63, expectedValid: true },
    { name: 'input_049', value: 'abcdefghijklmnopqrstuvwxyz1234567890123456789012', min: 8, max: 63, expectedValid: true },
    { name: 'input_050', value: 'abcdefghijklmnopqrstuvwxyz12345678901234567890123', min: 8, max: 63, expectedValid: true }
  ];
  const ipScenarios: Array<IpScenario> = [
    { name: 'ip_001', value: '0.0.0.0', expectedValid: true },
    { name: 'ip_002', value: '1.1.1.1', expectedValid: true },
    { name: 'ip_003', value: '8.8.8.8', expectedValid: true },
    { name: 'ip_004', value: '10.0.0.1', expectedValid: true },
    { name: 'ip_005', value: '10.0.0.256', expectedValid: false },
    { name: 'ip_006', value: '127.0.0.1', expectedValid: true },
    { name: 'ip_007', value: '172.16.0.1', expectedValid: true },
    { name: 'ip_008', value: '172.16.0', expectedValid: false },
    { name: 'ip_009', value: '192.168.0.1', expectedValid: true },
    { name: 'ip_010', value: '192.168.0.256', expectedValid: false },
    { name: 'ip_011', value: '192.168.1.1', expectedValid: true },
    { name: 'ip_012', value: '192.168.1.300', expectedValid: false },
    { name: 'ip_013', value: '223.255.255.255', expectedValid: true },
    { name: 'ip_014', value: '224.0.0.1', expectedValid: true },
    { name: 'ip_015', value: '255.255.255.255', expectedValid: true },
    { name: 'ip_016', value: '256.255.255.255', expectedValid: false },
    { name: 'ip_017', value: '1.2.3', expectedValid: false },
    { name: 'ip_018', value: '1.2.3.4.5', expectedValid: false },
    { name: 'ip_019', value: '01.02.03.04', expectedValid: true },
    { name: 'ip_020', value: '300.2.3.4', expectedValid: false },
    { name: 'ip_021', value: '20.20.20.20', expectedValid: true },
    { name: 'ip_022', value: '30.30.30.30', expectedValid: true },
    { name: 'ip_023', value: '40.40.40.40', expectedValid: true },
    { name: 'ip_024', value: '50.50.50.50', expectedValid: true },
    { name: 'ip_025', value: '60.60.60.60', expectedValid: true },
    { name: 'ip_026', value: '70.70.70.70', expectedValid: true },
    { name: 'ip_027', value: '80.80.80.80', expectedValid: true },
    { name: 'ip_028', value: '90.90.90.90', expectedValid: true },
    { name: 'ip_029', value: '100.100.100.100', expectedValid: true },
    { name: 'ip_030', value: '110.110.110.110', expectedValid: true },
    { name: 'ip_031', value: '120.120.120.120', expectedValid: true },
    { name: 'ip_032', value: '130.130.130.130', expectedValid: true },
    { name: 'ip_033', value: '140.140.140.140', expectedValid: true },
    { name: 'ip_034', value: '150.150.150.150', expectedValid: true },
    { name: 'ip_035', value: '160.160.160.160', expectedValid: true },
    { name: 'ip_036', value: '170.170.170.170', expectedValid: true },
    { name: 'ip_037', value: '180.180.180.180', expectedValid: true },
    { name: 'ip_038', value: '190.190.190.190', expectedValid: true },
    { name: 'ip_039', value: '200.200.200.200', expectedValid: true },
    { name: 'ip_040', value: '210.210.210.210', expectedValid: true }
  ];
  const updateScenarios: Array<UpdateScenario> = [
    { name: 'update_001', diffExists: true, fullExists: true, expectedPath: '/storage/External/updater_diff.zip', existed: true },
    { name: 'update_002', diffExists: true, fullExists: false, expectedPath: '/storage/External/updater_diff.zip', existed: true },
    { name: 'update_003', diffExists: false, fullExists: true, expectedPath: '/storage/External/updater_full.zip', existed: true },
    { name: 'update_004', diffExists: false, fullExists: false, expectedPath: '', existed: false },
    { name: 'update_005', diffExists: true, fullExists: true, expectedPath: '/storage/External/updater_diff.zip', existed: true },
    { name: 'update_006', diffExists: false, fullExists: true, expectedPath: '/storage/External/updater_full.zip', existed: true },
    { name: 'update_007', diffExists: true, fullExists: false, expectedPath: '/storage/External/updater_diff.zip', existed: true },
    { name: 'update_008', diffExists: false, fullExists: false, expectedPath: '', existed: false },
    { name: 'update_009', diffExists: true, fullExists: true, expectedPath: '/storage/External/updater_diff.zip', existed: true },
    { name: 'update_010', diffExists: false, fullExists: true, expectedPath: '/storage/External/updater_full.zip', existed: true },
    { name: 'update_011', diffExists: true, fullExists: false, expectedPath: '/storage/External/updater_diff.zip', existed: true },
    { name: 'update_012', diffExists: false, fullExists: false, expectedPath: '', existed: false },
    { name: 'update_013', diffExists: true, fullExists: true, expectedPath: '/storage/External/updater_diff.zip', existed: true },
    { name: 'update_014', diffExists: false, fullExists: true, expectedPath: '/storage/External/updater_full.zip', existed: true },
    { name: 'update_015', diffExists: true, fullExists: false, expectedPath: '/storage/External/updater_diff.zip', existed: true },
    { name: 'update_016', diffExists: false, fullExists: false, expectedPath: '', existed: false }
  ];
  const statusScenarios: Array<StatusScenario> = [
    { name: 'status_001', state: 0, text: '未连接' },
    { name: 'status_002', state: 1, text: '连接中' },
    { name: 'status_003', state: 2, text: '已连接' },
    { name: 'status_004', state: 3, text: '断开中' },
    { name: 'status_005', state: 4, text: '' },
    { name: 'status_006', state: -1, text: '' },
    { name: 'status_007', state: 0, text: '未连接' },
    { name: 'status_008', state: 1, text: '连接中' },
    { name: 'status_009', state: 2, text: '已连接' },
    { name: 'status_010', state: 3, text: '断开中' },
    { name: 'status_011', state: 4, text: '' },
    { name: 'status_012', state: -1, text: '' }
  ];

  describe('MegaNetworkSystemInputMatrixSuite', () => {
    it(addCase(casePrefix + 'InputLengthMatrix_001'), 0, () => {
      for (let i = 0; i < inputScenarios.length; i++) {
        const item = inputScenarios[i];
        expect(validateLengthRange(item.value, item.min, item.max)).assertEqual(item.expectedValid);
      }
    });

    it(addCase(casePrefix + 'IpMatrix_002'), 0, () => {
      for (let i = 0; i < ipScenarios.length; i++) {
        expect(isValidIpv4(ipScenarios[i].value)).assertEqual(ipScenarios[i].expectedValid);
      }
    });

    it(addCase(casePrefix + 'UpdateMatrix_003'), 0, () => {
      for (let i = 0; i < updateScenarios.length; i++) {
        const item = updateScenarios[i];
        const result = resolveUpdatePath(item.diffExists, item.fullExists);
        expect(result.existed).assertEqual(item.existed);
        expect(result.targetPath).assertEqual(item.expectedPath);
      }
    });

    it(addCase(casePrefix + 'StatusMatrix_004'), 0, () => {
      for (let i = 0; i < statusScenarios.length; i++) {
        expect(resolveConnectionText(statusScenarios[i].state)).assertEqual(statusScenarios[i].text);
      }
    });

    it(addCase(casePrefix + 'TrimMatrix_005'), 0, () => {
      expect(trimText('  a  ')).assertEqual('a');
      expect(trimText('  abc')).assertEqual('abc');
      expect(trimText('abc  ')).assertEqual('abc');
      expect(trimText(' abc def ')).assertEqual('abc def');
    });

    it(addCase(casePrefix + 'StressInputAndIp_006'), 0, () => {
      let okCount = 0;
      for (let i = 0; i < 900; i++) {
        if (validateLengthRange(inputScenarios[i % inputScenarios.length].value,
          inputScenarios[i % inputScenarios.length].min,
          inputScenarios[i % inputScenarios.length].max) === inputScenarios[i % inputScenarios.length].expectedValid) {
          okCount++;
        }
        if (isValidIpv4(ipScenarios[i % ipScenarios.length].value) === ipScenarios[i % ipScenarios.length].expectedValid) {
          okCount++;
        }
      }
      expect(okCount).assertEqual(1800);
    });

    it(addCase(casePrefix + 'StressUpdateAndStatus_007'), 0, () => {
      let okCount = 0;
      for (let i = 0; i < 600; i++) {
        const update = updateScenarios[i % updateScenarios.length];
        const updateResult = resolveUpdatePath(update.diffExists, update.fullExists);
        if (updateResult.existed === update.existed && updateResult.targetPath === update.expectedPath) {
          okCount++;
        }
        const status = statusScenarios[i % statusScenarios.length];
        if (resolveConnectionText(status.state) === status.text) {
          okCount++;
        }
      }
      expect(okCount).assertEqual(1200);
    });

    it(addCase(casePrefix + 'MatrixUniqueness_008'), 0, () => {
      const names: Set<string> = new Set<string>();
      const sources = [inputScenarios, ipScenarios, updateScenarios, statusScenarios];
      for (let s = 0; s < sources.length; s++) {
        const list = sources[s];
        for (let i = 0; i < list.length; i++) {
          const item = list[i] as InputScenario | IpScenario | UpdateScenario | StatusScenario;
          expect(names.has(item.name)).assertEqual(false);
          names.add(item.name);
        }
      }
      expect(names.size).assertEqual(inputScenarios.length + ipScenarios.length + updateScenarios.length + statusScenarios.length);
    });

    it(addCase(casePrefix + 'BoundaryPresence_009'), 0, () => {
      expect(inputScenarios.some((item) => item.expectedValid === false)).assertEqual(true);
      expect(ipScenarios.some((item) => item.expectedValid === false)).assertEqual(true);
      expect(updateScenarios.some((item) => item.existed === false)).assertEqual(true);
      expect(statusScenarios.some((item) => item.text === '')).assertEqual(true);
    });

    it(addCase(casePrefix + 'CaseNaming_010'), 0, () => {
      const regex = /^Settings_MegaNetworkSystemInput_[A-Za-z0-9_]+_[0-9]{3}$/;
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

