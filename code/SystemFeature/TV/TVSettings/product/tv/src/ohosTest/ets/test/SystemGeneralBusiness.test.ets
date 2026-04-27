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

interface RemoteState {
  connVal: number;
  isPoint: boolean;
  chooseDes: string;
}

interface ChargeState {
  isCharge: boolean;
}

interface ReceiverState {
  isReport: boolean;
  isPoint: boolean;
  chooseDes: string;
}

interface BatteryState {
  level: number;
}

interface UsbPortInfo {
  name: string;
  status: boolean;
  visibility: boolean;
}

function resolveConnectStatus(changeVal: number, batteryLevel: number): RemoteState {
  if (changeVal === 1) {
    return { connVal: changeVal, isPoint: true, chooseDes: `${batteryLevel}%` };
  }
  if (changeVal === 0) {
    return { connVal: changeVal, isPoint: false, chooseDes: '' };
  }
  return { connVal: changeVal, isPoint: false, chooseDes: '' };
}

function resolveChargeStatus(changeVal: number): ChargeState {
  return { isCharge: changeVal !== 0 };
}

function resolveReceiverStatus(changeVal: number): ReceiverState {
  if (changeVal === 0) {
    return { isReport: false, isPoint: false, chooseDes: '' };
  }
  return { isReport: true, isPoint: true, chooseDes: '' };
}

function resolveBatteryValue(changeVal: number): BatteryState {
  return { level: changeVal < 0 ? 0 : changeVal > 100 ? 100 : changeVal };
}

function resolveDeviceName(settingsName: string, fallbackName: string): string {
  const source = settingsName !== '' ? settingsName : fallbackName;
  return source.slice(0, 6).toUpperCase();
}

function shouldShowRemoteAndInput(deviceName: string): boolean {
  return deviceName !== 'GK6320';
}

function shouldShowHaiBao(productModel: string): boolean {
  return productModel === 'Hi3751V352';
}

function buildGeneralRouteNames(
  deviceName: string,
  productModel: string,
  support3ModeRemote: boolean,
  sourceListEmpty: boolean
): string[] {
  const names: string[] = [];
  if (shouldShowRemoteAndInput(deviceName)) {
    names.push('遥控器');
  }
  names.push('自动熄屏');
  names.push('HDMI设置');
  if (shouldShowRemoteAndInput(deviceName)) {
    names.push('输入源设置');
  }
  names.push('输入法设置');
  names.push('悬浮球设置');
  if (support3ModeRemote && !sourceListEmpty) {
    names.push('看电视按键设置');
  }
  names.push('屏幕旋转');
  names.push('开机模式');
  names.push('待机模式');
  names.push('待机');
  if (shouldShowHaiBao(productModel)) {
    names.push('风行海报开关');
  }
  return names;
}

function buildUsbPortList(
  supportedUsbList: number[],
  statusByPort: Record<number, boolean>,
  errorPortList: number[]
): UsbPortInfo[] {
  const names = ['USB1', 'USB2', 'USB3', 'USB4'];
  const visibleSet: Set<number> = new Set<number>();
  for (let i = 0; i < supportedUsbList.length; i++) {
    if (supportedUsbList[i] >= 0 && supportedUsbList[i] < 4) {
      visibleSet.add(supportedUsbList[i]);
    }
  }
  const errorSet: Set<number> = new Set<number>();
  for (let i = 0; i < errorPortList.length; i++) {
    if (errorPortList[i] >= 0 && errorPortList[i] < 4) {
      errorSet.add(errorPortList[i]);
    }
  }
  const list: UsbPortInfo[] = [];
  for (let i = 0; i < 4; i++) {
    const visible = visibleSet.has(i);
    const status = !visible ? false : errorSet.has(i) ? false : !!statusByPort[i];
    list.push({ name: names[i], status, visibility: visible });
  }
  return list.filter(item => item.visibility);
}

function resolveCurrentVersion(softwareVersion: string, hasError: boolean): string {
  if (hasError) {
    return '软件更新';
  }
  return `当前版本${softwareVersion}`;
}

function systemClickAction(itemName: string): string {
  return itemName === '恢复出厂设置' ? 'open_reset_dialog' : 'route';
}

function resolveBluetoothMacDesc(bluetoothOn: boolean, mac: string): string {
  return bluetoothOn ? mac.toUpperCase() : '请先开启蓝牙';
}

function resolveSnDesc(sn: string, hasError: boolean): string {
  return hasError ? '获取失败' : sn.toUpperCase();
}

export default function SystemGeneralBusinessTest() {
  const casePrefix = 'Settings_SystemGeneral_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('SystemGeneralBusinessSuite', () => {
    it(addCase(casePrefix + 'General_ConnectStatus_001'), 0, () => {
      const c1 = resolveConnectStatus(1, 67);
      const c0 = resolveConnectStatus(0, 67);
      const cx = resolveConnectStatus(2, 67);
      expect(c1.connVal).assertEqual(1);
      expect(c1.isPoint).assertEqual(true);
      expect(c1.chooseDes).assertEqual('67%');
      expect(c0.isPoint).assertEqual(false);
      expect(c0.chooseDes).assertEqual('');
      expect(cx.isPoint).assertEqual(false);
    });

    it(addCase(casePrefix + 'General_ChargeStatus_002'), 0, () => {
      expect(resolveChargeStatus(0).isCharge).assertEqual(false);
      expect(resolveChargeStatus(1).isCharge).assertEqual(true);
      expect(resolveChargeStatus(2).isCharge).assertEqual(true);
    });

    it(addCase(casePrefix + 'General_ReceiverStatus_003'), 0, () => {
      const out = resolveReceiverStatus(0);
      const inx = resolveReceiverStatus(1);
      expect(out.isReport).assertEqual(false);
      expect(out.isPoint).assertEqual(false);
      expect(out.chooseDes).assertEqual('');
      expect(inx.isReport).assertEqual(true);
      expect(inx.isPoint).assertEqual(true);
    });

    it(addCase(casePrefix + 'General_BatteryClamp_004'), 0, () => {
      expect(resolveBatteryValue(-1).level).assertEqual(0);
      expect(resolveBatteryValue(55).level).assertEqual(55);
      expect(resolveBatteryValue(130).level).assertEqual(100);
    });

    it(addCase(casePrefix + 'General_DeviceNameResolve_005'), 0, () => {
      expect(resolveDeviceName('abc123xyz', 'fallback')).assertEqual('ABC123');
      expect(resolveDeviceName('', 'gk6320-dev')).assertEqual('GK6320');
    });

    it(addCase(casePrefix + 'General_DeviceGate_006'), 0, () => {
      expect(shouldShowRemoteAndInput('GK6320')).assertEqual(false);
      expect(shouldShowRemoteAndInput('HI3751')).assertEqual(true);
    });

    it(addCase(casePrefix + 'General_HaiBaoGate_007'), 0, () => {
      expect(shouldShowHaiBao('Hi3751V352')).assertEqual(true);
      expect(shouldShowHaiBao('Hi3751V353')).assertEqual(false);
    });

    it(addCase(casePrefix + 'General_MenuBuild_008'), 0, () => {
      const names = buildGeneralRouteNames('HI3751', 'Hi3751V352', true, false);
      expect(names.includes('遥控器')).assertEqual(true);
      expect(names.includes('输入源设置')).assertEqual(true);
      expect(names.includes('看电视按键设置')).assertEqual(true);
      expect(names.includes('风行海报开关')).assertEqual(true);
    });

    it(addCase(casePrefix + 'General_MenuBuild6320_009'), 0, () => {
      const names = buildGeneralRouteNames('GK6320', 'Hi3751V353', true, false);
      expect(names.includes('遥控器')).assertEqual(false);
      expect(names.includes('输入源设置')).assertEqual(false);
      expect(names.includes('风行海报开关')).assertEqual(false);
    });

    it(addCase(casePrefix + 'General_UsbVisibleList_010'), 0, () => {
      const list = buildUsbPortList([0, 2, 4, -1], { 0: true, 2: true }, []);
      expect(list.length).assertEqual(2);
      expect(list[0].name).assertEqual('USB1');
      expect(list[0].status).assertEqual(true);
      expect(list[1].name).assertEqual('USB3');
      expect(list[1].status).assertEqual(true);
    });

    it(addCase(casePrefix + 'General_UsbErrorFallback_011'), 0, () => {
      const list = buildUsbPortList([0, 1, 2], { 0: true, 1: true, 2: true }, [1]);
      expect(list.length).assertEqual(3);
      expect(list[1].name).assertEqual('USB2');
      expect(list[1].status).assertEqual(false);
    });

    it(addCase(casePrefix + 'System_VersionInfo_012'), 0, () => {
      expect(resolveCurrentVersion('6.0.1', false)).assertEqual('当前版本6.0.1');
      expect(resolveCurrentVersion('6.0.1', true)).assertEqual('软件更新');
    });

    it(addCase(casePrefix + 'System_ClickAction_013'), 0, () => {
      expect(systemClickAction('恢复出厂设置')).assertEqual('open_reset_dialog');
      expect(systemClickAction('软件更新')).assertEqual('route');
    });

    it(addCase(casePrefix + 'StateInfo_BluetoothMac_014'), 0, () => {
      expect(resolveBluetoothMacDesc(true, 'aa:bb:cc')).assertEqual('AA:BB:CC');
      expect(resolveBluetoothMacDesc(false, 'aa:bb:cc')).assertEqual('请先开启蓝牙');
    });

    it(addCase(casePrefix + 'StateInfo_SnDesc_015'), 0, () => {
      expect(resolveSnDesc('abc123', false)).assertEqual('ABC123');
      expect(resolveSnDesc('abc123', true)).assertEqual('获取失败');
    });

    it(addCase(casePrefix + 'Stress_MenuCombinations_016'), 0, () => {
      let total = 0;
      for (let i = 0; i < 200; i++) {
        const names = buildGeneralRouteNames(
          i % 2 === 0 ? 'GK6320' : 'HI3751',
          i % 3 === 0 ? 'Hi3751V352' : 'OTHER',
          i % 5 !== 0,
          i % 7 === 0
        );
        total += names.length;
      }
      expect(total > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'Stress_UsbCombinations_017'), 0, () => {
      let visibleCount = 0;
      for (let i = 0; i < 120; i++) {
        const list = buildUsbPortList(
          [i % 4, (i + 1) % 4, 9],
          { 0: i % 2 === 0, 1: true, 2: false, 3: true },
          i % 3 === 0 ? [i % 4] : []
        );
        visibleCount += list.length;
      }
      expect(visibleCount > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'Contract_CaseNaming_018'), 0, () => {
      const regex = /^Settings_SystemGeneral_[A-Za-z0-9_]+_[0-9]{3}$/;
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

