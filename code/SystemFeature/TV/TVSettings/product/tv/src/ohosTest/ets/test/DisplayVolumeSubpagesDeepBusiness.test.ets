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

interface NumberAdjustResult {
  value: number;
}

interface OutputStateResolveResult {
  outPut: string;
  selectedIndex: number;
  enableDigitalOutput: boolean;
}

interface DynamicBacklightState {
  isShow: boolean;
  isOn: boolean;
}

function adjustNumberByDirection(value: number, direction: 'LEFT' | 'RIGHT', min: number, max: number): NumberAdjustResult {
  if (direction === 'LEFT' && value > min) {
    return { value: value - 1 };
  }
  if (direction === 'RIGHT' && value < max) {
    return { value: value + 1 };
  }
  return { value };
}

function cycleLevelText(current: string, direction: 'LEFT' | 'RIGHT'): string {
  const origins = ['关闭', '低', '中', '高'];
  let index = origins.indexOf(current);
  if (index < 0) {
    index = 0;
  }
  if (direction === 'LEFT') {
    index = index === 0 ? origins.length - 1 : index - 1;
  } else {
    index = index === origins.length - 1 ? 0 : index + 1;
  }
  return origins[index];
}

function mapGammaTypeToText(gammaType: number): string {
  const map: Record<number, string> = {
    0: '1.8',
    1: '1.9',
    2: '2.0',
    3: '2.1',
    4: '2.2',
    5: '2.3',
    6: '2.4',
    7: '2.5',
    8: '2.6'
  };
  return map[gammaType] ?? '2.2';
}

function resolveDynamicBacklightState(supported: boolean, rawState: number): DynamicBacklightState {
  if (!supported) {
    return { isShow: false, isOn: false };
  }
  return { isShow: true, isOn: rawState === 1 };
}

function mapCustomReferMode(mode: number): string {
  const map: Record<number, string> = {
    1: '标准',
    2: '影院',
    3: '音乐',
    4: '新闻'
  };
  return map[mode] ?? '标准';
}

function cycleCustomReferMode(current: string, direction: 'LEFT' | 'RIGHT'): string {
  const list = ['标准', '影院', '音乐', '新闻'];
  let index = list.indexOf(current);
  if (index < 0) {
    index = 0;
  }
  if (direction === 'LEFT') {
    index = index === 0 ? list.length - 1 : index - 1;
  } else {
    index = index === list.length - 1 ? 0 : index + 1;
  }
  return list[index];
}

function shouldOpenCustomEffectPage(currentEffect: string): boolean {
  return currentEffect === '自定义音效';
}

function mapOutputDeviceTypeToState(type: number): OutputStateResolveResult {
  if (type === 4) {
    return { outPut: 'S/PDIF', selectedIndex: 1, enableDigitalOutput: true };
  }
  if (type === 3) {
    return { outPut: 'HDMI(ARC)', selectedIndex: 2, enableDigitalOutput: true };
  }
  if (type === 0) {
    return { outPut: '本机扬声器', selectedIndex: 0, enableDigitalOutput: false };
  }
  return { outPut: '蓝牙', selectedIndex: -1, enableDigitalOutput: false };
}

function cycleDigitalOutputValue(current: string, direction: 'LEFT' | 'RIGHT'): string {
  const list = ['PCM', '源码', '自动'];
  let index = list.indexOf(current);
  if (index < 0) {
    index = 0;
  }
  if (direction === 'LEFT') {
    index = index === 0 ? list.length - 1 : index - 1;
  } else {
    index = index === list.length - 1 ? 0 : index + 1;
  }
  return list[index];
}

function mapDigitalOutputToArcMode(value: string): number {
  if (value === 'PCM') {
    return 0;
  }
  if (value === '源码') {
    return 1;
  }
  if (value === '自动') {
    return 3;
  }
  return 4;
}

function mapDigitalOutputToSpdifMode(value: string): number {
  if (value === 'PCM') {
    return 0;
  }
  if (value === '源码') {
    return 1;
  }
  if (value === '自动') {
    return 2;
  }
  return 4;
}

export default function DisplayVolumeSubpagesDeepBusinessTest() {
  const casePrefix = 'Settings_DisplayVolumeSubDeep_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('DisplayVolumeSubpagesDeepBusinessSuite', () => {
    it(addCase(casePrefix + 'Brightness_Boundary_001'), 0, () => {
      expect(adjustNumberByDirection(0, 'LEFT', 0, 100).value).assertEqual(0);
      expect(adjustNumberByDirection(100, 'RIGHT', 0, 100).value).assertEqual(100);
      expect(adjustNumberByDirection(50, 'LEFT', 0, 100).value).assertEqual(49);
      expect(adjustNumberByDirection(50, 'RIGHT', 0, 100).value).assertEqual(51);
    });

    it(addCase(casePrefix + 'DynamicContrast_Cycle_002'), 0, () => {
      expect(cycleLevelText('关闭', 'LEFT')).assertEqual('高');
      expect(cycleLevelText('高', 'RIGHT')).assertEqual('关闭');
      expect(cycleLevelText('低', 'LEFT')).assertEqual('关闭');
    });

    it(addCase(casePrefix + 'Gamma_Map_003'), 0, () => {
      expect(mapGammaTypeToText(0)).assertEqual('1.8');
      expect(mapGammaTypeToText(4)).assertEqual('2.2');
      expect(mapGammaTypeToText(8)).assertEqual('2.6');
      expect(mapGammaTypeToText(99)).assertEqual('2.2');
    });

    it(addCase(casePrefix + 'Backlight_SupportGate_004'), 0, () => {
      const noSupport = resolveDynamicBacklightState(false, 1);
      const onState = resolveDynamicBacklightState(true, 1);
      const offState = resolveDynamicBacklightState(true, 0);
      expect(noSupport.isShow).assertEqual(false);
      expect(onState.isOn).assertEqual(true);
      expect(offState.isOn).assertEqual(false);
    });

    it(addCase(casePrefix + 'CustomEffect_OpenGate_005'), 0, () => {
      expect(shouldOpenCustomEffectPage('自定义音效')).assertEqual(true);
      expect(shouldOpenCustomEffectPage('标准')).assertEqual(false);
    });

    it(addCase(casePrefix + 'CustomRefer_Map_006'), 0, () => {
      expect(mapCustomReferMode(1)).assertEqual('标准');
      expect(mapCustomReferMode(2)).assertEqual('影院');
      expect(mapCustomReferMode(4)).assertEqual('新闻');
      expect(mapCustomReferMode(99)).assertEqual('标准');
    });

    it(addCase(casePrefix + 'CustomRefer_Cycle_007'), 0, () => {
      expect(cycleCustomReferMode('标准', 'LEFT')).assertEqual('新闻');
      expect(cycleCustomReferMode('新闻', 'RIGHT')).assertEqual('标准');
      expect(cycleCustomReferMode('影院', 'RIGHT')).assertEqual('音乐');
    });

    it(addCase(casePrefix + 'OutputType_StateMap_008'), 0, () => {
      const spdif = mapOutputDeviceTypeToState(4);
      const arc = mapOutputDeviceTypeToState(3);
      const speaker = mapOutputDeviceTypeToState(0);
      const bt = mapOutputDeviceTypeToState(2);
      expect(spdif.outPut).assertEqual('S/PDIF');
      expect(arc.enableDigitalOutput).assertEqual(true);
      expect(speaker.enableDigitalOutput).assertEqual(false);
      expect(bt.outPut).assertEqual('蓝牙');
    });

    it(addCase(casePrefix + 'DigitalOutput_Cycle_009'), 0, () => {
      expect(cycleDigitalOutputValue('PCM', 'LEFT')).assertEqual('自动');
      expect(cycleDigitalOutputValue('自动', 'RIGHT')).assertEqual('PCM');
      expect(cycleDigitalOutputValue('源码', 'LEFT')).assertEqual('PCM');
    });

    it(addCase(casePrefix + 'DigitalOutput_ArcModeMap_010'), 0, () => {
      expect(mapDigitalOutputToArcMode('PCM')).assertEqual(0);
      expect(mapDigitalOutputToArcMode('源码')).assertEqual(1);
      expect(mapDigitalOutputToArcMode('自动')).assertEqual(3);
      expect(mapDigitalOutputToArcMode('未知')).assertEqual(4);
    });

    it(addCase(casePrefix + 'DigitalOutput_SpdifModeMap_011'), 0, () => {
      expect(mapDigitalOutputToSpdifMode('PCM')).assertEqual(0);
      expect(mapDigitalOutputToSpdifMode('源码')).assertEqual(1);
      expect(mapDigitalOutputToSpdifMode('自动')).assertEqual(2);
      expect(mapDigitalOutputToSpdifMode('未知')).assertEqual(4);
    });

    it(addCase(casePrefix + 'Stress_NumberAdjust_012'), 0, () => {
      let value = 50;
      for (let i = 0; i < 200; i++) {
        value = adjustNumberByDirection(value, i % 2 === 0 ? 'RIGHT' : 'LEFT', 0, 100).value;
      }
      expect(value >= 0 && value <= 100).assertEqual(true);
    });

    it(addCase(casePrefix + 'Stress_DigitalCycle_013'), 0, () => {
      let value = 'PCM';
      for (let i = 0; i < 150; i++) {
        value = cycleDigitalOutputValue(value, i % 2 === 0 ? 'RIGHT' : 'LEFT');
      }
      expect(value === 'PCM' || value === '源码' || value === '自动').assertEqual(true);
    });

    it(addCase(casePrefix + 'Contract_CaseNaming_014'), 0, () => {
      const regex = /^Settings_DisplayVolumeSubDeep_[A-Za-z0-9_]+_[0-9]{3}$/;
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

