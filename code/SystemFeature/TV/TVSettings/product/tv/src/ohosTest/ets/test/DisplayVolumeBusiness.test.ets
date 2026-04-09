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

interface EffectResult {
  effect: string;
  effectEnabled: boolean;
}

function mapPictureMode(mode: number): string {
  const pictureModeMap: Record<number, string> = {
    8: '自动',
    1: '鲜艳',
    0: '标准',
    2: '电影',
    3: '体育',
    6: '电脑',
    4: '照片',
    5: '游戏',
    7: '大师模式'
  };
  return pictureModeMap[mode] ? pictureModeMap[mode] : '自动';
}

function mapEyeMode(colorTempMode: number): string {
  return colorTempMode === 2 ? '已开启' : '已关闭';
}

function applyBrightnessStep(origin: number, direction: 'LEFT' | 'RIGHT'): number {
  if (direction === 'LEFT') {
    return origin > 0 ? origin - 1 : 0;
  }
  return origin < 100 ? origin + 1 : 100;
}

function mapDisplayModeType(itemName: string, displayMode: string): string {
  return itemName === '高级图像设置' ? displayMode : '';
}

function mapAudioChannelType(channel: number): string {
  if (channel === 4) {
    return 'S/PDIF';
  }
  if (channel === 3) {
    return 'HDMI(ARC)';
  }
  if (channel === 0) {
    return '本机扬声器';
  }
  if (channel === 2) {
    return '蓝牙';
  }
  return '';
}

function mapAudioEffectMode(effect: number): EffectResult {
  if (effect === 0) {
    return { effect: '自动', effectEnabled: true };
  }
  if (effect === 1) {
    return { effect: '标准', effectEnabled: true };
  }
  if (effect === 2) {
    return { effect: '影院', effectEnabled: true };
  }
  if (effect === 3) {
    return { effect: '音乐', effectEnabled: true };
  }
  if (effect === 4) {
    return { effect: '新闻', effectEnabled: true };
  }
  if (effect === 5) {
    return { effect: '自定义音效', effectEnabled: true };
  }
  if (effect === -1) {
    return { effect: '关闭', effectEnabled: false };
  }
  return { effect: '自动', effectEnabled: true };
}

function nextDigitalOutputValue(current: string, direction: 'LEFT' | 'RIGHT'): string {
  if (direction === 'LEFT') {
    if (current === 'PCM') {
      return '自动';
    }
    if (current === '源码') {
      return 'PCM';
    }
    return '源码';
  }
  if (current === 'PCM') {
    return '源码';
  }
  if (current === '源码') {
    return '自动';
  }
  return 'PCM';
}

function mapArcModeValue(dynamicContrast: string): number {
  return dynamicContrast === 'PCM' ? 0 : dynamicContrast === '源码' ? 1 : dynamicContrast === '自动' ? 3 : 4;
}

function mapSpdifModeValue(dynamicContrast: string): number {
  return dynamicContrast === 'PCM' ? 0 : dynamicContrast === '源码' ? 1 : dynamicContrast === '自动' ? 2 : 4;
}

function mapOutputOption(name: string): number {
  if (name === '本机扬声器') {
    return 0;
  }
  if (name === 'S/PDIF') {
    return 4;
  }
  if (name === 'HDMI(ARC)') {
    return 3;
  }
  return -1;
}

function stepVolume(origin: number, direction: 'LEFT' | 'RIGHT'): number {
  if (direction === 'LEFT') {
    return origin > 0 ? origin - 1 : 0;
  }
  return origin < 15 ? origin + 1 : 15;
}

function keyToneStorage(flag: boolean): boolean {
  return flag;
}

export default function DisplayVolumeBusinessTest() {
  const casePrefix = 'Settings_DisplayVolume_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('DisplayVolumeBusinessSuite', () => {
    it(addCase(casePrefix + 'Display_PictureModeMap_001'), 0, () => {
      expect(mapPictureMode(8)).assertEqual('自动');
      expect(mapPictureMode(1)).assertEqual('鲜艳');
      expect(mapPictureMode(0)).assertEqual('标准');
      expect(mapPictureMode(7)).assertEqual('大师模式');
    });

    it(addCase(casePrefix + 'Display_PictureModeFallback_002'), 0, () => {
      expect(mapPictureMode(99)).assertEqual('自动');
      expect(mapPictureMode(-1)).assertEqual('自动');
    });

    it(addCase(casePrefix + 'Display_EyeModeMap_003'), 0, () => {
      expect(mapEyeMode(2)).assertEqual('已开启');
      expect(mapEyeMode(0)).assertEqual('已关闭');
      expect(mapEyeMode(1)).assertEqual('已关闭');
    });

    it(addCase(casePrefix + 'Display_BrightnessClamp_004'), 0, () => {
      expect(applyBrightnessStep(0, 'LEFT')).assertEqual(0);
      expect(applyBrightnessStep(100, 'RIGHT')).assertEqual(100);
      expect(applyBrightnessStep(50, 'LEFT')).assertEqual(49);
      expect(applyBrightnessStep(50, 'RIGHT')).assertEqual(51);
    });

    it(addCase(casePrefix + 'Display_ModeTypeRouting_005'), 0, () => {
      expect(mapDisplayModeType('高级图像设置', '电影')).assertEqual('电影');
      expect(mapDisplayModeType('图像模式', '电影')).assertEqual('');
    });

    it(addCase(casePrefix + 'Volume_ChannelTypeMap_006'), 0, () => {
      expect(mapAudioChannelType(4)).assertEqual('S/PDIF');
      expect(mapAudioChannelType(3)).assertEqual('HDMI(ARC)');
      expect(mapAudioChannelType(0)).assertEqual('本机扬声器');
      expect(mapAudioChannelType(2)).assertEqual('蓝牙');
      expect(mapAudioChannelType(100)).assertEqual('');
    });

    it(addCase(casePrefix + 'Volume_AudioEffectMap_007'), 0, () => {
      const e0 = mapAudioEffectMode(0);
      const e3 = mapAudioEffectMode(3);
      const e5 = mapAudioEffectMode(5);
      expect(e0.effect).assertEqual('自动');
      expect(e3.effect).assertEqual('音乐');
      expect(e5.effect).assertEqual('自定义音效');
      expect(e0.effectEnabled).assertEqual(true);
      expect(e3.effectEnabled).assertEqual(true);
      expect(e5.effectEnabled).assertEqual(true);
    });

    it(addCase(casePrefix + 'Volume_AudioEffectOff_008'), 0, () => {
      const e = mapAudioEffectMode(-1);
      expect(e.effect).assertEqual('关闭');
      expect(e.effectEnabled).assertEqual(false);
    });

    it(addCase(casePrefix + 'Output_DigitalCycleLeft_009'), 0, () => {
      expect(nextDigitalOutputValue('PCM', 'LEFT')).assertEqual('自动');
      expect(nextDigitalOutputValue('源码', 'LEFT')).assertEqual('PCM');
      expect(nextDigitalOutputValue('自动', 'LEFT')).assertEqual('源码');
    });

    it(addCase(casePrefix + 'Output_DigitalCycleRight_010'), 0, () => {
      expect(nextDigitalOutputValue('PCM', 'RIGHT')).assertEqual('源码');
      expect(nextDigitalOutputValue('源码', 'RIGHT')).assertEqual('自动');
      expect(nextDigitalOutputValue('自动', 'RIGHT')).assertEqual('PCM');
    });

    it(addCase(casePrefix + 'Output_ArcModeValueMap_011'), 0, () => {
      expect(mapArcModeValue('PCM')).assertEqual(0);
      expect(mapArcModeValue('源码')).assertEqual(1);
      expect(mapArcModeValue('自动')).assertEqual(3);
      expect(mapArcModeValue('unknown')).assertEqual(4);
    });

    it(addCase(casePrefix + 'Output_SpdifModeValueMap_012'), 0, () => {
      expect(mapSpdifModeValue('PCM')).assertEqual(0);
      expect(mapSpdifModeValue('源码')).assertEqual(1);
      expect(mapSpdifModeValue('自动')).assertEqual(2);
      expect(mapSpdifModeValue('unknown')).assertEqual(4);
    });

    it(addCase(casePrefix + 'Output_OptionMap_013'), 0, () => {
      expect(mapOutputOption('本机扬声器')).assertEqual(0);
      expect(mapOutputOption('S/PDIF')).assertEqual(4);
      expect(mapOutputOption('HDMI(ARC)')).assertEqual(3);
      expect(mapOutputOption('蓝牙')).assertEqual(-1);
    });

    it(addCase(casePrefix + 'Volume_RangeClamp_014'), 0, () => {
      expect(stepVolume(0, 'LEFT')).assertEqual(0);
      expect(stepVolume(15, 'RIGHT')).assertEqual(15);
      expect(stepVolume(7, 'LEFT')).assertEqual(6);
      expect(stepVolume(7, 'RIGHT')).assertEqual(8);
    });

    it(addCase(casePrefix + 'Volume_KeyToneStorage_015'), 0, () => {
      expect(keyToneStorage(true)).assertEqual(true);
      expect(keyToneStorage(false)).assertEqual(false);
    });

    it(addCase(casePrefix + 'Stress_DigitalSwitch_016'), 0, () => {
      let current = 'PCM';
      for (let i = 0; i < 200; i++) {
        current = nextDigitalOutputValue(current, i % 2 === 0 ? 'LEFT' : 'RIGHT');
      }
      expect(['PCM', '源码', '自动'].includes(current)).assertEqual(true);
    });

    it(addCase(casePrefix + 'Stress_BrightnessStep_017'), 0, () => {
      let value = 50;
      for (let i = 0; i < 1000; i++) {
        value = applyBrightnessStep(value, i % 3 === 0 ? 'LEFT' : 'RIGHT');
      }
      expect(value >= 0 && value <= 100).assertEqual(true);
    });

    it(addCase(casePrefix + 'Contract_CaseNaming_018'), 0, () => {
      const regex = /^Settings_DisplayVolume_[A-Za-z0-9_]+_[0-9]{3}$/;
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
