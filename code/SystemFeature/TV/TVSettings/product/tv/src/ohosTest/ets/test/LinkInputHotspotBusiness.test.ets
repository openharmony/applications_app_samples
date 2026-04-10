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

interface CastInitState {
  isCastOn: boolean;
  dlnaEnable: string;
  castSwitch: string;
  miraCastQuickPlay: string;
}

interface HotspotTogglePlan {
  enabledAfterToggle: boolean;
  needDialog: boolean;
  shouldStartHotspot: boolean;
  shouldStopHotspot: boolean;
  discoverableValue: string;
}

interface InputSourceItem {
  name: string;
  selected: boolean;
}

interface OneConnectWant {
  bundleName: string;
  abilityName: string;
  stopFlag: string;
}

interface CastPersistenceState {
  dlnaEnable: string;
  castSwitch: string;
  miraCastQuickPlay: string;
}

function getSourceNameById(id: number): string {
  if (id === 0) {
    return 'MEDIA';
  }
  if (id === 1) {
    return 'HDMI1';
  }
  if (id === 2) {
    return 'HDMI2';
  }
  if (id === 3) {
    return 'HDMI3';
  }
  if (id === 4) {
    return 'HDMI4';
  }
  if (id === 5) {
    return 'AV';
  }
  if (id === 6 || id === 7 || id === 8) {
    return 'DTV';
  }
  if (id === 9 || id === 10) {
    return 'VGA';
  }
  return 'HDMI1';
}

function buildInputSourceList(supportSourceList: number[], selectedName: string): Array<InputSourceItem> {
  const filtered = supportSourceList.filter(item => item !== 0);
  const result: Array<InputSourceItem> = [];
  for (let i = 0; i < filtered.length; i++) {
    const name = getSourceNameById(filtered[i]);
    result.push({ name, selected: name === selectedName });
  }
  return result;
}

function shouldShowInputSourceOptions(defaultInputSource: boolean): boolean {
  return defaultInputSource;
}

function applySingleSelect(list: Array<InputSourceItem>, name: string): Array<InputSourceItem> {
  return list.map(item => {
    const nextItem: InputSourceItem = {
      name: item.name,
      selected: item.name === name
    };
    return nextItem;
  });
}

function resolveOpeningTimeText(shareOpenTime: number): string {
  return shareOpenTime === 0 ? 'unlimited' : `${shareOpenTime}min`;
}

function buildOneConnectWant(stopFlag: '0' | '1'): OneConnectWant {
  return {
    bundleName: 'com.ohos.oneconnect.share',
    abilityName: 'ServiceExtAbility',
    stopFlag
  };
}

function resolveOnShareEvent(isOn: boolean, managerExists: boolean): string {
  if (!managerExists) {
    return 'noop';
  }
  return isOn ? 'enable_and_start' : 'disable_and_stop';
}

function resolveCastInit(rawValue: string): CastInitState {
  if (rawValue === '0') {
    return { isCastOn: false, dlnaEnable: 'false', castSwitch: '0', miraCastQuickPlay: '0' };
  }
  return { isCastOn: true, dlnaEnable: 'true', castSwitch: '1', miraCastQuickPlay: '1' };
}

function resolveSwitchCastPersistence(isCastOn: boolean): CastPersistenceState {
  return isCastOn
    ? { dlnaEnable: 'true', castSwitch: '1', miraCastQuickPlay: '1' }
    : { dlnaEnable: 'false', castSwitch: '0', miraCastQuickPlay: '0' };
}

function parseDiffDisplayEnabled(value: string): boolean {
  return value === '1';
}

function toDiffDisplayParam(enabled: boolean): string {
  return enabled ? '1' : '0';
}

function parseStoredFlag(value: string): boolean {
  return value === 'true';
}

function setDiscoverableValue(enable: boolean): string {
  return enable ? '1' : '0';
}

function resolveToggleHotspotPlan(currentEnabled: boolean, wifiEnabled: boolean): HotspotTogglePlan {
  const next = !currentEnabled;
  if (next) {
    if (wifiEnabled) {
      return {
        enabledAfterToggle: true,
        needDialog: true,
        shouldStartHotspot: false,
        shouldStopHotspot: false,
        discoverableValue: '0'
      };
    }
    return {
      enabledAfterToggle: true,
      needDialog: false,
      shouldStartHotspot: true,
      shouldStopHotspot: false,
      discoverableValue: '0'
    };
  }
  return {
    enabledAfterToggle: false,
    needDialog: false,
    shouldStartHotspot: false,
    shouldStopHotspot: true,
    discoverableValue: '1'
  };
}

function buildHotspotShareText(ssid: string, pwd: string): string {
  return `WIFI:S:${ssid};T:WPA;P:${pwd};;`;
}

function clampConnectedDeviceNumber(value: number): number {
  if (value < 0) {
    return 0;
  }
  if (value > 9) {
    return 9;
  }
  return value;
}

export default function LinkInputHotspotBusinessTest() {
  const casePrefix = 'Settings_LinkInputHotspot_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('LinkInputHotspotBusinessSuite', () => {
    it(addCase(casePrefix + 'InputSource_IdMap_001'), 0, () => {
      expect(getSourceNameById(1)).assertEqual('HDMI1');
      expect(getSourceNameById(4)).assertEqual('HDMI4');
      expect(getSourceNameById(6)).assertEqual('DTV');
      expect(getSourceNameById(9)).assertEqual('VGA');
      expect(getSourceNameById(100)).assertEqual('HDMI1');
    });

    it(addCase(casePrefix + 'InputSource_FilterAndSelect_002'), 0, () => {
      const list = buildInputSourceList([0, 1, 2, 6], 'HDMI2');
      expect(list.length).assertEqual(3);
      expect(list[0].name).assertEqual('HDMI1');
      expect(list[1].selected).assertEqual(true);
      expect(list[2].name).assertEqual('DTV');
    });

    it(addCase(casePrefix + 'InputSource_RenderGate_003'), 0, () => {
      expect(shouldShowInputSourceOptions(true)).assertEqual(true);
      expect(shouldShowInputSourceOptions(false)).assertEqual(false);
    });

    it(addCase(casePrefix + 'InputSource_SingleSelect_004'), 0, () => {
      const list = applySingleSelect(
        [{ name: 'HDMI1', selected: false }, { name: 'HDMI2', selected: false }, { name: 'AV', selected: true }],
        'HDMI1'
      );
      expect(list[0].selected).assertEqual(true);
      expect(list[1].selected).assertEqual(false);
      expect(list[2].selected).assertEqual(false);
    });

    it(addCase(casePrefix + 'OneConnect_OpeningTimeText_005'), 0, () => {
      expect(resolveOpeningTimeText(10)).assertEqual('10min');
      expect(resolveOpeningTimeText(0)).assertEqual('unlimited');
    });

    it(addCase(casePrefix + 'OneConnect_WantBuild_006'), 0, () => {
      const start = buildOneConnectWant('0');
      const stop = buildOneConnectWant('1');
      expect(start.bundleName).assertEqual('com.ohos.oneconnect.share');
      expect(start.stopFlag).assertEqual('0');
      expect(stop.stopFlag).assertEqual('1');
    });

    it(addCase(casePrefix + 'OneConnect_ShareEventPlan_007'), 0, () => {
      expect(resolveOnShareEvent(true, true)).assertEqual('enable_and_start');
      expect(resolveOnShareEvent(false, true)).assertEqual('disable_and_stop');
      expect(resolveOnShareEvent(true, false)).assertEqual('noop');
    });

    it(addCase(casePrefix + 'Links_CastInitMap_008'), 0, () => {
      const s1 = resolveCastInit('');
      const s2 = resolveCastInit('1');
      const s3 = resolveCastInit('0');
      expect(s1.isCastOn).assertEqual(true);
      expect(s2.dlnaEnable).assertEqual('true');
      expect(s3.isCastOn).assertEqual(false);
      expect(s3.miraCastQuickPlay).assertEqual('0');
    });

    it(addCase(casePrefix + 'Links_SwitchCastPersist_009'), 0, () => {
      const on = resolveSwitchCastPersistence(true);
      const off = resolveSwitchCastPersistence(false);
      expect(on.castSwitch).assertEqual('1');
      expect(on.dlnaEnable).assertEqual('true');
      expect(off.castSwitch).assertEqual('0');
      expect(off.dlnaEnable).assertEqual('false');
    });

    it(addCase(casePrefix + 'Expansion_ParamConvert_010'), 0, () => {
      expect(parseDiffDisplayEnabled('1')).assertEqual(true);
      expect(parseDiffDisplayEnabled('0')).assertEqual(false);
      expect(toDiffDisplayParam(true)).assertEqual('1');
      expect(toDiffDisplayParam(false)).assertEqual('0');
    });

    it(addCase(casePrefix + 'Hotspot_StoredStatusParse_011'), 0, () => {
      expect(parseStoredFlag('true')).assertEqual(true);
      expect(parseStoredFlag('false')).assertEqual(false);
      expect(parseStoredFlag('other')).assertEqual(false);
    });

    it(addCase(casePrefix + 'Hotspot_DiscoverableValue_012'), 0, () => {
      expect(setDiscoverableValue(true)).assertEqual('1');
      expect(setDiscoverableValue(false)).assertEqual('0');
    });

    it(addCase(casePrefix + 'Hotspot_TogglePlan_013'), 0, () => {
      const p1 = resolveToggleHotspotPlan(false, true);
      const p2 = resolveToggleHotspotPlan(false, false);
      const p3 = resolveToggleHotspotPlan(true, false);
      expect(p1.needDialog).assertEqual(true);
      expect(p1.discoverableValue).assertEqual('0');
      expect(p2.shouldStartHotspot).assertEqual(true);
      expect(p3.shouldStopHotspot).assertEqual(true);
      expect(p3.discoverableValue).assertEqual('1');
    });

    it(addCase(casePrefix + 'Hotspot_ShareTextBuild_014'), 0, () => {
      expect(buildHotspotShareText('MyTv', '12345678')).assertEqual('WIFI:S:MyTv;T:WPA;P:12345678;;');
    });

    it(addCase(casePrefix + 'Hotspot_ConnectedClamp_015'), 0, () => {
      expect(clampConnectedDeviceNumber(-1)).assertEqual(0);
      expect(clampConnectedDeviceNumber(3)).assertEqual(3);
      expect(clampConnectedDeviceNumber(99)).assertEqual(9);
    });

    it(addCase(casePrefix + 'Stress_TogglePlan_016'), 0, () => {
      let starts = 0;
      let stops = 0;
      for (let i = 0; i < 300; i++) {
        const p = resolveToggleHotspotPlan(i % 2 === 0, i % 3 === 0);
        if (p.shouldStartHotspot) {
          starts++;
        }
        if (p.shouldStopHotspot) {
          stops++;
        }
      }
      expect(starts > 0).assertEqual(true);
      expect(stops > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'Stress_SourceBuild_017'), 0, () => {
      let count = 0;
      for (let i = 0; i < 180; i++) {
        const list = buildInputSourceList([0, i % 11, (i + 1) % 11, 4], i % 2 === 0 ? 'HDMI1' : 'DTV');
        count += list.length;
      }
      expect(count > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'Contract_CaseNaming_018'), 0, () => {
      const regex = /^Settings_LinkInputHotspot_[A-Za-z0-9_]+_[0-9]{3}$/;
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

