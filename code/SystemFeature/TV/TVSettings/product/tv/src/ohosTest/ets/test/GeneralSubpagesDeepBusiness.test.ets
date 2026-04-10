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

interface SwitchPersistenceResult {
  switchValue: string;
  screenOffTime: string;
}

interface SelectStateResult {
  selectedIndex: number;
}

interface RotationSwitchState {
  isShow: boolean;
  rotationValue: number;
}

function resolveStartupModeIndex(storageValue: number | undefined): number {
  if (storageValue === undefined || storageValue === null) {
    return 0;
  }
  return storageValue;
}

function mapStartupModeText(index: number): string {
  const list = ['开机', '待机', '记忆'];
  return list[index] ?? '开机';
}

function mapStandbyActionToIndex(action: number): number {
  return action - 2;
}

function mapStandbyIndexToAction(index: number): number {
  return index + 2;
}

function getScreenOffTimeValue(itemParam: string): number {
  switch (itemParam) {
    case '1':
      return 1800000;
    case '2':
      return 3600000;
    case '3':
      return 7200000;
    case '4':
      return 14400000;
    case '5':
      return 21600000;
    default:
      return 1800000;
  }
}

function resolveAutoScreenOffToggle(isOn: boolean, itemParam: string): SwitchPersistenceResult {
  if (!isOn) {
    return {
      switchValue: '0',
      screenOffTime: '-1'
    };
  }
  return {
    switchValue: '1',
    screenOffTime: getScreenOffTimeValue(itemParam).toString()
  };
}

function resolveFloatBallInitialState(storageValue: boolean | undefined, defaultValue: boolean): boolean {
  if (storageValue === undefined || storageValue === null) {
    return defaultValue;
  }
  return storageValue;
}

function resolveFloatBallTogglePersistValue(isOn: boolean): boolean {
  return isOn;
}

function mapRotationValueToDegreeName(rotation: number): string {
  if (rotation === 3) {
    return '90°';
  }
  if (rotation === 2) {
    return '180°';
  }
  if (rotation === 1) {
    return '270°';
  }
  return '';
}

function mapDegreeNameToRotationValue(name: string): number {
  if (name === '90°') {
    return 3;
  }
  if (name === '180°') {
    return 2;
  }
  if (name === '270°') {
    return 1;
  }
  return 0;
}

function resolveRotationSwitchState(itemIsOn: boolean): RotationSwitchState {
  if (itemIsOn) {
    return { isShow: false, rotationValue: 0 };
  }
  return { isShow: true, rotationValue: -1 };
}

function resolveChooseListSelectedIndex(rotation: number): SelectStateResult {
  if (rotation === 3) {
    return { selectedIndex: 0 };
  }
  if (rotation === 2) {
    return { selectedIndex: 1 };
  }
  if (rotation === 1) {
    return { selectedIndex: 2 };
  }
  return { selectedIndex: -1 };
}

export default function GeneralSubpagesDeepBusinessTest() {
  const casePrefix = 'Settings_GeneralSubDeep_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('GeneralSubpagesDeepBusinessSuite', () => {
    it(addCase(casePrefix + 'StartupMode_IndexResolve_001'), 0, () => {
      expect(resolveStartupModeIndex(undefined)).assertEqual(0);
      expect(resolveStartupModeIndex(0)).assertEqual(0);
      expect(resolveStartupModeIndex(2)).assertEqual(2);
    });

    it(addCase(casePrefix + 'StartupMode_TextMap_002'), 0, () => {
      expect(mapStartupModeText(0)).assertEqual('开机');
      expect(mapStartupModeText(1)).assertEqual('待机');
      expect(mapStartupModeText(2)).assertEqual('记忆');
      expect(mapStartupModeText(9)).assertEqual('开机');
    });

    it(addCase(casePrefix + 'Standby_ActionIndexMap_003'), 0, () => {
      expect(mapStandbyActionToIndex(2)).assertEqual(0);
      expect(mapStandbyActionToIndex(3)).assertEqual(1);
      expect(mapStandbyActionToIndex(4)).assertEqual(2);
      expect(mapStandbyIndexToAction(0)).assertEqual(2);
      expect(mapStandbyIndexToAction(2)).assertEqual(4);
    });

    it(addCase(casePrefix + 'AutoScreenOff_TimeMap_004'), 0, () => {
      expect(getScreenOffTimeValue('1')).assertEqual(1800000);
      expect(getScreenOffTimeValue('2')).assertEqual(3600000);
      expect(getScreenOffTimeValue('3')).assertEqual(7200000);
      expect(getScreenOffTimeValue('4')).assertEqual(14400000);
      expect(getScreenOffTimeValue('5')).assertEqual(21600000);
    });

    it(addCase(casePrefix + 'AutoScreenOff_DefaultFallback_005'), 0, () => {
      expect(getScreenOffTimeValue('0')).assertEqual(1800000);
      expect(getScreenOffTimeValue('abc')).assertEqual(1800000);
    });

    it(addCase(casePrefix + 'AutoScreenOff_TogglePersist_006'), 0, () => {
      const off = resolveAutoScreenOffToggle(false, '3');
      const on = resolveAutoScreenOffToggle(true, '4');
      expect(off.switchValue).assertEqual('0');
      expect(off.screenOffTime).assertEqual('-1');
      expect(on.switchValue).assertEqual('1');
      expect(on.screenOffTime).assertEqual('14400000');
    });

    it(addCase(casePrefix + 'FloatBall_InitState_007'), 0, () => {
      expect(resolveFloatBallInitialState(undefined, true)).assertEqual(true);
      expect(resolveFloatBallInitialState(false, true)).assertEqual(false);
      expect(resolveFloatBallInitialState(true, false)).assertEqual(true);
    });

    it(addCase(casePrefix + 'FloatBall_TogglePersist_008'), 0, () => {
      expect(resolveFloatBallTogglePersistValue(true)).assertEqual(true);
      expect(resolveFloatBallTogglePersistValue(false)).assertEqual(false);
    });

    it(addCase(casePrefix + 'ScreenRotation_ValueToName_009'), 0, () => {
      expect(mapRotationValueToDegreeName(3)).assertEqual('90°');
      expect(mapRotationValueToDegreeName(2)).assertEqual('180°');
      expect(mapRotationValueToDegreeName(1)).assertEqual('270°');
      expect(mapRotationValueToDegreeName(0)).assertEqual('');
    });

    it(addCase(casePrefix + 'ScreenRotation_NameToValue_010'), 0, () => {
      expect(mapDegreeNameToRotationValue('90°')).assertEqual(3);
      expect(mapDegreeNameToRotationValue('180°')).assertEqual(2);
      expect(mapDegreeNameToRotationValue('270°')).assertEqual(1);
      expect(mapDegreeNameToRotationValue('未知')).assertEqual(0);
    });

    it(addCase(casePrefix + 'ScreenRotation_SwitchState_011'), 0, () => {
      const off = resolveRotationSwitchState(true);
      const on = resolveRotationSwitchState(false);
      expect(off.isShow).assertEqual(false);
      expect(off.rotationValue).assertEqual(0);
      expect(on.isShow).assertEqual(true);
      expect(on.rotationValue).assertEqual(-1);
    });

    it(addCase(casePrefix + 'ScreenRotation_SelectedIndex_012'), 0, () => {
      expect(resolveChooseListSelectedIndex(3).selectedIndex).assertEqual(0);
      expect(resolveChooseListSelectedIndex(2).selectedIndex).assertEqual(1);
      expect(resolveChooseListSelectedIndex(1).selectedIndex).assertEqual(2);
      expect(resolveChooseListSelectedIndex(0).selectedIndex).assertEqual(-1);
    });

    it(addCase(casePrefix + 'Stress_TimeMapping_013'), 0, () => {
      let sum = 0;
      const inputs = ['1', '2', '3', '4', '5', '0'];
      for (let i = 0; i < 150; i++) {
        sum += getScreenOffTimeValue(inputs[i % inputs.length]);
      }
      expect(sum > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'Stress_RotationMapping_014'), 0, () => {
      const items = ['90°', '180°', '270°', '未知'];
      let ok = true;
      for (let i = 0; i < 180; i++) {
        const value = mapDegreeNameToRotationValue(items[i % items.length]);
        if (value < 0 || value > 3) {
          ok = false;
        }
      }
      expect(ok).assertEqual(true);
    });

    it(addCase(casePrefix + 'Contract_CaseNaming_015'), 0, () => {
      const regex = /^Settings_GeneralSubDeep_[A-Za-z0-9_]+_[0-9]{3}$/;
      const names: Set<string> = new Set<string>();
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(regex.test(allCaseNames[i])).assertEqual(true);
        expect(names.has(allCaseNames[i])).assertEqual(false);
        names.add(allCaseNames[i]);
      }
      expect(names.size).assertEqual(allCaseNames.length);
    });
  });
}

