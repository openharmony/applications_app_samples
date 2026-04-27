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

interface SimpleDevice {
  deviceName: string;
  deviceId: string;
  connectionState: number;
}

interface OutputSelectionState {
  selectedCount: number;
  selectedHue: string;
  shouldClearStorage: boolean;
}

interface ControllerSummary {
  names: string[];
  detailDescription: string;
}

interface BluetoothOutputItem {
  id: string;
  selected: boolean;
}

interface AudioOutputPersistResult {
  keepSelection: boolean;
  toastMessage: string;
}

interface PairGuidanceContent {
  title: string;
  des: string;
  containsDeleteStep: boolean;
}

interface ImeSwitchResult {
  selectedIndex: number;
  changed: boolean;
}

function mapConnectedBluetoothOutput(devices: Array<SimpleDevice>, outputId: string): Array<BluetoothOutputItem> {
  return devices
    .filter((item) => item.connectionState === 2)
    .map((item) => {
      const nextItem: BluetoothOutputItem = {
        id: item.deviceId,
        selected: item.deviceId === outputId
      };
      return nextItem;
    });
}

function resolveBluetoothOutputSelection(devices: Array<SimpleDevice>, outputId: string, outputName: string): OutputSelectionState {
  const connected = mapConnectedBluetoothOutput(devices, outputId);
  const selectedCount = connected.filter((item) => item.selected).length;
  if (connected.length === 0 || selectedCount === 0) {
    return {
      selectedCount,
      selectedHue: '',
      shouldClearStorage: true
    };
  }
  return {
    selectedCount,
    selectedHue: `${outputId}#${outputName}`,
    shouldClearStorage: false
  };
}

function resolveAudioOutputPersistResult(apiSuccess: boolean, hasError: boolean): AudioOutputPersistResult {
  if (hasError) {
    return { keepSelection: false, toastMessage: '开发中' };
  }
  if (!apiSuccess) {
    return { keepSelection: false, toastMessage: '设置声音输出失败' };
  }
  return { keepSelection: true, toastMessage: '' };
}

function buildRemoteControllerSummary(isPoint: boolean, sensitivityIndex: number): ControllerSummary {
  if (isPoint) {
    return {
      names: ['光标灵敏度', '切换遥控器指引', '指向遥控器连接'],
      detailDescription: ['低', '中', '高'][sensitivityIndex] ?? '低'
    };
  }
  return {
    names: ['切换遥控器指引', '指向遥控器连接'],
    detailDescription: '蓝牙遥控器'
  };
}

function adjustSensitivity(current: number, direction: 'LEFT' | 'RIGHT'): number {
  if (direction === 'LEFT') {
    return current > 0 ? current - 1 : 0;
  }
  return current < 2 ? current + 1 : 2;
}

function resolvePairGuidanceContent(isPoint: boolean): PairGuidanceContent {
  if (isPoint) {
    return {
      title: '指向遥控器配对指导',
      des: '指向遥控器',
      containsDeleteStep: true
    };
  }
  return {
    title: '蓝牙遥控器配对指导',
    des: '蓝牙遥控器',
    containsDeleteStep: true
  };
}

function resolveImeSelectionState(labels: string[], currentName: string): number {
  for (let i = 0; i < labels.length; i++) {
    if (labels[i] === currentName) {
      return i;
    }
  }
  return -1;
}

function resolveImeItemStyleCount(count: number): string {
  return count === 1 ? 'info' : 'singleChoose';
}

function resolveImeSwitchResult(selectedLabel: string, labels: string[]): ImeSwitchResult {
  const selectedIndex = labels.findIndex((item) => item === selectedLabel);
  return {
    selectedIndex,
    changed: selectedIndex !== -1
  };
}

export default function RemainingScatteredPagesWrapUpTest() {
  const casePrefix = 'Settings_RemainingWrapUp_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('RemainingScatteredPagesWrapUpSuite', () => {
    it(addCase(casePrefix + 'BluetoothOutput_FilterConnected_001'), 0, () => {
      const devices: Array<SimpleDevice> = [
        { deviceName: 'A', deviceId: 'a', connectionState: 2 },
        { deviceName: 'B', deviceId: 'b', connectionState: 1 },
        { deviceName: 'C', deviceId: 'c', connectionState: 2 }
      ];
      const result = mapConnectedBluetoothOutput(devices, 'c');
      expect(result.length).assertEqual(2);
      expect(result[0].selected).assertEqual(false);
      expect(result[1].selected).assertEqual(true);
    });

    it(addCase(casePrefix + 'BluetoothOutput_ClearWhenNoConnected_002'), 0, () => {
      const result = resolveBluetoothOutputSelection([], 'a', '音箱');
      expect(result.shouldClearStorage).assertEqual(true);
      expect(result.selectedHue).assertEqual('');
    });

    it(addCase(casePrefix + 'BluetoothOutput_ClearWhenSelectionLost_003'), 0, () => {
      const devices: Array<SimpleDevice> = [
        { deviceName: 'A', deviceId: 'a', connectionState: 2 },
        { deviceName: 'C', deviceId: 'c', connectionState: 2 }
      ];
      const result = resolveBluetoothOutputSelection(devices, 'x', '音箱');
      expect(result.shouldClearStorage).assertEqual(true);
      expect(result.selectedCount).assertEqual(0);
    });

    it(addCase(casePrefix + 'BluetoothOutput_KeepWhenSelected_004'), 0, () => {
      const devices: Array<SimpleDevice> = [
        { deviceName: 'A', deviceId: 'a', connectionState: 2 }
      ];
      const result = resolveBluetoothOutputSelection(devices, 'a', '音箱');
      expect(result.shouldClearStorage).assertEqual(false);
      expect(result.selectedHue).assertEqual('a#音箱');
    });

    it(addCase(casePrefix + 'BluetoothOutput_PersistResult_005'), 0, () => {
      expect(resolveAudioOutputPersistResult(true, false).keepSelection).assertEqual(true);
      expect(resolveAudioOutputPersistResult(false, false).toastMessage).assertEqual('设置声音输出失败');
      expect(resolveAudioOutputPersistResult(false, true).toastMessage).assertEqual('开发中');
    });

    it(addCase(casePrefix + 'RemoteController_ListForPoint_006'), 0, () => {
      const result = buildRemoteControllerSummary(true, 2);
      expect(result.names.length).assertEqual(3);
      expect(result.names[0]).assertEqual('光标灵敏度');
      expect(result.detailDescription).assertEqual('高');
    });

    it(addCase(casePrefix + 'RemoteController_ListForBluetooth_007'), 0, () => {
      const result = buildRemoteControllerSummary(false, 1);
      expect(result.names.length).assertEqual(2);
      expect(result.names[0]).assertEqual('切换遥控器指引');
      expect(result.detailDescription).assertEqual('蓝牙遥控器');
    });

    it(addCase(casePrefix + 'RemoteController_SensitivityAdjust_008'), 0, () => {
      expect(adjustSensitivity(0, 'LEFT')).assertEqual(0);
      expect(adjustSensitivity(1, 'LEFT')).assertEqual(0);
      expect(adjustSensitivity(1, 'RIGHT')).assertEqual(2);
      expect(adjustSensitivity(2, 'RIGHT')).assertEqual(2);
    });

    it(addCase(casePrefix + 'PairGuidance_PointContent_009'), 0, () => {
      const result = resolvePairGuidanceContent(true);
      expect(result.title).assertEqual('指向遥控器配对指导');
      expect(result.des).assertEqual('指向遥控器');
      expect(result.containsDeleteStep).assertEqual(true);
    });

    it(addCase(casePrefix + 'PairGuidance_BluetoothContent_010'), 0, () => {
      const result = resolvePairGuidanceContent(false);
      expect(result.title).assertEqual('蓝牙遥控器配对指导');
      expect(result.des).assertEqual('蓝牙遥控器');
      expect(result.containsDeleteStep).assertEqual(true);
    });

    it(addCase(casePrefix + 'Ime_SelectedIndex_011'), 0, () => {
      const labels = ['输入法A', '输入法B', '输入法C'];
      expect(resolveImeSelectionState(labels, '输入法B')).assertEqual(1);
      expect(resolveImeSelectionState(labels, '输入法X')).assertEqual(-1);
    });

    it(addCase(casePrefix + 'Ime_ItemStyle_012'), 0, () => {
      expect(resolveImeItemStyleCount(1)).assertEqual('info');
      expect(resolveImeItemStyleCount(2)).assertEqual('singleChoose');
      expect(resolveImeItemStyleCount(5)).assertEqual('singleChoose');
    });

    it(addCase(casePrefix + 'Ime_SwitchResult_013'), 0, () => {
      const labels = ['输入法A', '输入法B'];
      const ok = resolveImeSwitchResult('输入法B', labels);
      const fail = resolveImeSwitchResult('输入法X', labels);
      expect(ok.selectedIndex).assertEqual(1);
      expect(ok.changed).assertEqual(true);
      expect(fail.changed).assertEqual(false);
    });

    it(addCase(casePrefix + 'Stress_SensitivityBounds_014'), 0, () => {
      let value = 1;
      for (let i = 0; i < 200; i++) {
        value = adjustSensitivity(value, i % 2 === 0 ? 'LEFT' : 'RIGHT');
      }
      expect(value >= 0 && value <= 2).assertEqual(true);
    });

    it(addCase(casePrefix + 'Contract_CaseNaming_015'), 0, () => {
      const regex = /^Settings_RemainingWrapUp_[A-Za-z0-9_]+_[0-9]{3}$/;
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

