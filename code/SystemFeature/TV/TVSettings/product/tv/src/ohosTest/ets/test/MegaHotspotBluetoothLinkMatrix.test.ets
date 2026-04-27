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

interface DeviceScenario {
  name: string;
  inputName: string;
  maxLength: number;
  expected: string;
}

interface CastScenario {
  name: string;
  settingValue: string;
  isOn: boolean;
  storage: string;
}

interface FocusScenario {
  name: string;
  current: number;
  listLength: number;
  direction: 'UP' | 'DOWN';
  expected: number;
}

interface CastStateResult {
  isOn: boolean;
  storage: string;
}

function shortenName(value: string, maxLength: number): string {
  return value.length > maxLength ? `${value.substring(0, maxLength)}...` : value;
}

function resolveCastState(settingValue: string): CastStateResult {
  if (settingValue === '0') {
    return { isOn: false, storage: '0' };
  }
  if (settingValue === '' || settingValue === '1') {
    return { isOn: true, storage: '1' };
  }
  return { isOn: false, storage: settingValue };
}

function toggleCast(current: boolean): boolean {
  return !current;
}

function moveFocus(current: number, listLength: number, direction: 'UP' | 'DOWN'): number {
  if (listLength <= 0) {
    return -1;
  }
  if (direction === 'UP') {
    return current > 0 ? current - 1 : 0;
  }
  return current < listLength - 1 ? current + 1 : listLength - 1;
}

function canOpenTrustDialog(keyCode: number, eventTypeUp: boolean): boolean {
  return keyCode === 2054 && eventTypeUp;
}

export default function MegaHotspotBluetoothLinkMatrixTest() {
  const casePrefix = 'Settings_MegaHotspotBluetoothLink_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const deviceScenarios: Array<DeviceScenario> = [
    { name: 'device_001', inputName: 'tv', maxLength: 15, expected: 'tv' },
    { name: 'device_002', inputName: 'bluetooth_headset', maxLength: 15, expected: 'bluetooth_heads...' },
    { name: 'device_003', inputName: 'abcdefghijklmnop', maxLength: 15, expected: 'abcdefghijklmno...' },
    { name: 'device_004', inputName: 'speaker', maxLength: 15, expected: 'speaker' },
    { name: 'device_005', inputName: 'projector_screen', maxLength: 15, expected: 'projector_scree...' }
  ];
  const castScenarios: Array<CastScenario> = [
    { name: 'cast_001', settingValue: '0', isOn: false, storage: '0' },
    { name: 'cast_002', settingValue: '1', isOn: true, storage: '1' },
    { name: 'cast_003', settingValue: '', isOn: true, storage: '1' },
    { name: 'cast_004', settingValue: 'unexpected', isOn: false, storage: 'unexpected' },
    { name: 'cast_005', settingValue: '0', isOn: false, storage: '0' },
    { name: 'cast_006', settingValue: '1', isOn: true, storage: '1' },
    { name: 'cast_007', settingValue: '', isOn: true, storage: '1' },
    { name: 'cast_008', settingValue: 'unexpected', isOn: false, storage: 'unexpected' },
    { name: 'cast_009', settingValue: '0', isOn: false, storage: '0' },
    { name: 'cast_010', settingValue: '1', isOn: true, storage: '1' },
    { name: 'cast_011', settingValue: '', isOn: true, storage: '1' },
    { name: 'cast_012', settingValue: 'unexpected', isOn: false, storage: 'unexpected' },
    { name: 'cast_013', settingValue: '0', isOn: false, storage: '0' },
    { name: 'cast_014', settingValue: '1', isOn: true, storage: '1' },
    { name: 'cast_015', settingValue: '', isOn: true, storage: '1' },
    { name: 'cast_016', settingValue: 'unexpected', isOn: false, storage: 'unexpected' }
  ];
  const focusScenarios: Array<FocusScenario> = [
    { name: 'focus_001', current: 0, listLength: 5, direction: 'UP', expected: 0 },
    { name: 'focus_002', current: 0, listLength: 5, direction: 'DOWN', expected: 1 },
    { name: 'focus_003', current: 1, listLength: 5, direction: 'UP', expected: 0 },
    { name: 'focus_004', current: 1, listLength: 5, direction: 'DOWN', expected: 2 },
    { name: 'focus_005', current: 2, listLength: 5, direction: 'UP', expected: 1 },
    { name: 'focus_006', current: 2, listLength: 5, direction: 'DOWN', expected: 3 },
    { name: 'focus_007', current: 3, listLength: 5, direction: 'UP', expected: 2 },
    { name: 'focus_008', current: 3, listLength: 5, direction: 'DOWN', expected: 4 },
    { name: 'focus_009', current: 4, listLength: 5, direction: 'UP', expected: 3 },
    { name: 'focus_010', current: 4, listLength: 5, direction: 'DOWN', expected: 4 },
    { name: 'focus_011', current: 0, listLength: 1, direction: 'UP', expected: 0 },
    { name: 'focus_012', current: 0, listLength: 1, direction: 'DOWN', expected: 0 },
    { name: 'focus_013', current: 0, listLength: 0, direction: 'UP', expected: -1 },
    { name: 'focus_014', current: 0, listLength: 0, direction: 'DOWN', expected: -1 },
    { name: 'focus_015', current: 5, listLength: 8, direction: 'UP', expected: 4 },
    { name: 'focus_016', current: 5, listLength: 8, direction: 'DOWN', expected: 6 },
    { name: 'focus_017', current: 6, listLength: 8, direction: 'UP', expected: 5 },
    { name: 'focus_018', current: 6, listLength: 8, direction: 'DOWN', expected: 7 },
    { name: 'focus_019', current: 7, listLength: 8, direction: 'UP', expected: 6 },
    { name: 'focus_020', current: 7, listLength: 8, direction: 'DOWN', expected: 7 }
  ];

  describe('MegaHotspotBluetoothLinkMatrixSuite', () => {
    it(addCase(casePrefix + 'DeviceShortenMatrix_001'), 0, () => {
      for (let i = 0; i < deviceScenarios.length; i++) {
        const item = deviceScenarios[i];
        expect(shortenName(item.inputName, item.maxLength)).assertEqual(item.expected);
      }
    });

    it(addCase(casePrefix + 'CastMatrix_002'), 0, () => {
      for (let i = 0; i < castScenarios.length; i++) {
        const item = castScenarios[i];
        const result = resolveCastState(item.settingValue);
        expect(result.isOn).assertEqual(item.isOn);
        expect(result.storage).assertEqual(item.storage);
      }
    });

    it(addCase(casePrefix + 'FocusMatrix_003'), 0, () => {
      for (let i = 0; i < focusScenarios.length; i++) {
        const item = focusScenarios[i];
        expect(moveFocus(item.current, item.listLength, item.direction)).assertEqual(item.expected);
      }
    });

    it(addCase(casePrefix + 'ToggleStability_004'), 0, () => {
      let state = false;
      for (let i = 0; i < 200; i++) {
        state = toggleCast(state);
      }
      expect(state).assertEqual(false);
    });

    it(addCase(casePrefix + 'TrustDialogGate_005'), 0, () => {
      expect(canOpenTrustDialog(2054, true)).assertEqual(true);
      expect(canOpenTrustDialog(2054, false)).assertEqual(false);
      expect(canOpenTrustDialog(1000, true)).assertEqual(false);
    });

    it(addCase(casePrefix + 'StressDeviceAndCast_006'), 0, () => {
      let okCount = 0;
      for (let i = 0; i < 800; i++) {
        const device = deviceScenarios[i % deviceScenarios.length];
        if (shortenName(device.inputName, device.maxLength) === device.expected) {
          okCount++;
        }
        const cast = castScenarios[i % castScenarios.length];
        const result = resolveCastState(cast.settingValue);
        if (result.isOn === cast.isOn && result.storage === cast.storage) {
          okCount++;
        }
      }
      expect(okCount).assertEqual(1600);
    });

    it(addCase(casePrefix + 'StressFocus_007'), 0, () => {
      let okCount = 0;
      for (let i = 0; i < 600; i++) {
        const item = focusScenarios[i % focusScenarios.length];
        const next = moveFocus(item.current, item.listLength, item.direction);
        if ((item.listLength === 0 && next === -1) || (item.listLength > 0 && next >= 0 && next < item.listLength)) {
          okCount++;
        }
      }
      expect(okCount).assertEqual(600);
    });

    it(addCase(casePrefix + 'ScenarioUniqueness_008'), 0, () => {
      const set: Set<string> = new Set<string>();
      const groups = [deviceScenarios, castScenarios, focusScenarios];
      for (let g = 0; g < groups.length; g++) {
        const group = groups[g];
        for (let i = 0; i < group.length; i++) {
          const item = group[i] as DeviceScenario | CastScenario | FocusScenario;
          expect(set.has(item.name)).assertEqual(false);
          set.add(item.name);
        }
      }
      expect(set.size).assertEqual(deviceScenarios.length + castScenarios.length + focusScenarios.length);
    });

    it(addCase(casePrefix + 'BoundaryPresence_009'), 0, () => {
      expect(deviceScenarios.some((item) => item.inputName.length > item.maxLength)).assertEqual(true);
      expect(castScenarios.some((item) => item.settingValue === '0')).assertEqual(true);
      expect(focusScenarios.some((item) => item.expected === -1)).assertEqual(true);
    });

    it(addCase(casePrefix + 'CaseNaming_010'), 0, () => {
      const regex = /^Settings_MegaHotspotBluetoothLink_[A-Za-z0-9_]+_[0-9]{3}$/;
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

