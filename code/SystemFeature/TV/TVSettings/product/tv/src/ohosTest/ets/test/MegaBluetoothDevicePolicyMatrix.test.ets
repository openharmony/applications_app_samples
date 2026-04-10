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

interface PairScenario {
  name: string;
  bonded: boolean;
  discoverable: boolean;
  expectedAction: string;
}

interface DeviceNameScenario {
  name: string;
  value: string;
  maxLength: number;
  expectedValid: boolean;
}

function resolvePairAction(bonded: boolean, discoverable: boolean): string {
  if (bonded) {
    return 'disconnect';
  }
  if (discoverable) {
    return 'pair';
  }
  return 'ignore';
}

function isDeviceNameValid(value: string, maxLength: number): boolean {
  return value.length > 0 && value.length <= maxLength;
}

export default function MegaBluetoothDevicePolicyMatrixTest() {
  const casePrefix = 'Settings_MegaBluetoothDevicePolicy_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const pairScenarios: Array<PairScenario> = [
    { name: 'pair_001', bonded: true, discoverable: true, expectedAction: 'disconnect' },
    { name: 'pair_002', bonded: true, discoverable: false, expectedAction: 'disconnect' },
    { name: 'pair_003', bonded: false, discoverable: true, expectedAction: 'pair' },
    { name: 'pair_004', bonded: false, discoverable: false, expectedAction: 'ignore' },
    { name: 'pair_005', bonded: true, discoverable: true, expectedAction: 'disconnect' },
    { name: 'pair_006', bonded: true, discoverable: false, expectedAction: 'disconnect' },
    { name: 'pair_007', bonded: false, discoverable: true, expectedAction: 'pair' },
    { name: 'pair_008', bonded: false, discoverable: false, expectedAction: 'ignore' },
    { name: 'pair_009', bonded: true, discoverable: true, expectedAction: 'disconnect' },
    { name: 'pair_010', bonded: true, discoverable: false, expectedAction: 'disconnect' },
    { name: 'pair_011', bonded: false, discoverable: true, expectedAction: 'pair' },
    { name: 'pair_012', bonded: false, discoverable: false, expectedAction: 'ignore' }
  ];
  const deviceNameScenarios: Array<DeviceNameScenario> = [
    { name: 'name_001', value: '', maxLength: 20, expectedValid: false },
    { name: 'name_002', value: 'A', maxLength: 20, expectedValid: true },
    { name: 'name_003', value: 'TV', maxLength: 20, expectedValid: true },
    { name: 'name_004', value: 'LivingRoomTV', maxLength: 20, expectedValid: true },
    { name: 'name_005', value: 'DeviceNameExactly20!', maxLength: 20, expectedValid: true },
    { name: 'name_006', value: 'DeviceNameMoreThanTwenty', maxLength: 20, expectedValid: false },
    { name: 'name_007', value: '蓝牙电视', maxLength: 20, expectedValid: true },
    { name: 'name_008', value: '蓝牙电视设备客厅版', maxLength: 20, expectedValid: true },
    { name: 'name_009', value: '蓝牙电视设备客厅版本超长', maxLength: 20, expectedValid: true },
    { name: 'name_010', value: 'Bedroom-TV', maxLength: 20, expectedValid: true },
    { name: 'name_011', value: 'Bedroom-TV-Extremely-Long', maxLength: 20, expectedValid: false },
    { name: 'name_012', value: 'GuestTV', maxLength: 20, expectedValid: true }
  ];

  describe('MegaBluetoothDevicePolicyMatrixSuite', () => {
    it(addCase(casePrefix + 'PairActionMatrix_001'), 0, () => {
      for (let i = 0; i < pairScenarios.length; i++) {
        const item = pairScenarios[i];
        expect(resolvePairAction(item.bonded, item.discoverable)).assertEqual(item.expectedAction);
      }
    });

    it(addCase(casePrefix + 'DeviceNameMatrix_002'), 0, () => {
      for (let i = 0; i < deviceNameScenarios.length; i++) {
        const item = deviceNameScenarios[i];
        expect(isDeviceNameValid(item.value, item.maxLength)).assertEqual(item.expectedValid);
      }
    });

    it(addCase(casePrefix + 'StressPolicy_003'), 0, () => {
      let okCount = 0;
      for (let i = 0; i < 1000; i++) {
        const pairItem = pairScenarios[i % pairScenarios.length];
        if (resolvePairAction(pairItem.bonded, pairItem.discoverable) === pairItem.expectedAction) {
          okCount++;
        }
        const nameItem = deviceNameScenarios[i % deviceNameScenarios.length];
        if (isDeviceNameValid(nameItem.value, nameItem.maxLength) === nameItem.expectedValid) {
          okCount++;
        }
      }
      expect(okCount).assertEqual(2000);
    });

    it(addCase(casePrefix + 'Coverage_004'), 0, () => {
      expect(pairScenarios.some((item) => item.expectedAction === 'disconnect')).assertEqual(true);
      expect(pairScenarios.some((item) => item.expectedAction === 'pair')).assertEqual(true);
      expect(pairScenarios.some((item) => item.expectedAction === 'ignore')).assertEqual(true);
      expect(deviceNameScenarios.some((item) => item.expectedValid === false)).assertEqual(true);
    });

    it(addCase(casePrefix + 'CaseNaming_005'), 0, () => {
      const regex = /^Settings_MegaBluetoothDevicePolicy_[A-Za-z0-9_]+_[0-9]{3}$/;
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

