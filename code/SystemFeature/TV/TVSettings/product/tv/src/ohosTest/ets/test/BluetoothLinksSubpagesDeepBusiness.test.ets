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

interface DeviceLike {
  deviceName?: string;
  deviceId?: string;
  connectionState?: number;
  connectRet?: boolean;
}

interface BluetoothOperationResult {
  openErrorDialog: boolean;
  selectedDeviceId: string;
}

interface ConnectionLabelResult {
  text: string;
}

interface CastToggleBatchResult {
  finalState: boolean;
  onCount: number;
  offCount: number;
}

interface CastSwitchState {
  isCastOn: boolean;
  dlnaEnabled: string;
  quickPlayValue: string;
}

interface MiraCastToggleState {
  nextOn: boolean;
  statusValue: string;
}

interface CastPersistenceResult {
  dlnaEnabled: string;
  castSwitch: string;
  quickPlay: string;
}

function shortenDeviceName(name: string, maxLength: number = 15): string {
  return name.length > maxLength ? `${name.substring(0, maxLength)}...` : name;
}

function resolveConnectOperationResult(item: DeviceLike, connectResults: DeviceLike[]): BluetoothOperationResult {
  const hasSuccess = connectResults.some((dev) => dev.connectRet === true);
  return {
    openErrorDialog: !hasSuccess,
    selectedDeviceId: item.deviceId ?? ''
  };
}

function resolveDialogConnectedState(connectionState: number, connectedState: number): boolean {
  return connectionState === connectedState;
}

function resolvePairStateText(connectionState: number, bondingState: number): string {
  return connectionState === bondingState ? '配对中' : '';
}

function resolveConnectionStateText(connectionState: number): ConnectionLabelResult {
  if (connectionState === 0) {
    return { text: '未连接' };
  }
  if (connectionState === 1) {
    return { text: '连接中' };
  }
  if (connectionState === 2) {
    return { text: '已连接' };
  }
  if (connectionState === 3) {
    return { text: '断开中' };
  }
  return { text: '' };
}

function resolveConfirmPairingResult(accept: boolean, availableLength: number): number {
  return accept ? Math.max(availableLength - 1, 0) : availableLength;
}

function resolveCastSwitchState(settingValue: string): CastSwitchState {
  if (settingValue === '0') {
    return { isCastOn: false, dlnaEnabled: 'false', quickPlayValue: '0' };
  }
  return { isCastOn: true, dlnaEnabled: 'true', quickPlayValue: '1' };
}

function toggleMiraCastState(isOn: boolean): MiraCastToggleState {
  const nextOn = !isOn;
  return { nextOn, statusValue: nextOn ? '1' : '0' };
}

function resolveScreenExpansionVisibility(productModel: string): boolean {
  return productModel !== 'Hi3751V352';
}

function resolveCastPersistenceByToggle(isCastOn: boolean): CastPersistenceResult {
  if (isCastOn) {
    return { dlnaEnabled: 'true', castSwitch: '1', quickPlay: '1' };
  }
  return { dlnaEnabled: 'false', castSwitch: '0', quickPlay: '0' };
}

function shouldOpenTrustDeviceDialog(keyCode: number, eventTypeUp: boolean): boolean {
  return keyCode === 2054 && eventTypeUp;
}

function resolveBatchCastToggle(initialState: boolean, times: number): CastToggleBatchResult {
  let state = initialState;
  let onCount = 0;
  let offCount = 0;
  for (let i = 0; i < times; i++) {
    state = toggleMiraCastState(state).nextOn;
    if (state) {
      onCount++;
    } else {
      offCount++;
    }
  }
  return { finalState: state, onCount, offCount };
}

function shouldShowDisconnectLabel(connectionState: number): boolean {
  return resolveConnectionStateText(connectionState).text === '已连接';
}

function resolveDeviceSelectionKey(device: DeviceLike): string {
  if (device.deviceId && device.deviceId !== '') {
    return device.deviceId;
  }
  return device.deviceName ?? '';
}

export default function BluetoothLinksSubpagesDeepBusinessTest() {
  const casePrefix = 'Settings_BluetoothLinksSubDeep_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('BluetoothLinksSubpagesDeepBusinessSuite', () => {
    it(addCase(casePrefix + 'Bluetooth_DeviceNameShorten_001'), 0, () => {
      expect(shortenDeviceName('ShortName')).assertEqual('ShortName');
      expect(shortenDeviceName('123456789012345')).assertEqual('123456789012345');
      expect(shortenDeviceName('1234567890123456')).assertEqual('123456789012345...');
    });

    it(addCase(casePrefix + 'Bluetooth_ConnectResultSuccess_002'), 0, () => {
      const result = resolveConnectOperationResult(
        { deviceId: 'A' },
        [{ connectRet: false }, { connectRet: true }]
      );
      expect(result.openErrorDialog).assertEqual(false);
      expect(result.selectedDeviceId).assertEqual('A');
    });

    it(addCase(casePrefix + 'Bluetooth_ConnectResultFail_003'), 0, () => {
      const result = resolveConnectOperationResult(
        { deviceId: 'B' },
        [{ connectRet: false }, { connectRet: false }]
      );
      expect(result.openErrorDialog).assertEqual(true);
      expect(result.selectedDeviceId).assertEqual('B');
    });

    it(addCase(casePrefix + 'Bluetooth_DialogConnectedState_004'), 0, () => {
      expect(resolveDialogConnectedState(2, 2)).assertEqual(true);
      expect(resolveDialogConnectedState(1, 2)).assertEqual(false);
    });

    it(addCase(casePrefix + 'Bluetooth_PairStateText_005'), 0, () => {
      expect(resolvePairStateText(1, 1)).assertEqual('配对中');
      expect(resolvePairStateText(2, 1)).assertEqual('');
    });

    it(addCase(casePrefix + 'Bluetooth_ConnectionStateText_006'), 0, () => {
      expect(resolveConnectionStateText(0).text).assertEqual('未连接');
      expect(resolveConnectionStateText(1).text).assertEqual('连接中');
      expect(resolveConnectionStateText(2).text).assertEqual('已连接');
      expect(resolveConnectionStateText(3).text).assertEqual('断开中');
    });

    it(addCase(casePrefix + 'Bluetooth_ConfirmPairing_007'), 0, () => {
      expect(resolveConfirmPairingResult(true, 5)).assertEqual(4);
      expect(resolveConfirmPairingResult(false, 5)).assertEqual(5);
      expect(resolveConfirmPairingResult(true, 0)).assertEqual(0);
    });

    it(addCase(casePrefix + 'Links_CastSwitchRead_008'), 0, () => {
      const on = resolveCastSwitchState('1');
      const off = resolveCastSwitchState('0');
      const empty = resolveCastSwitchState('');
      expect(on.isCastOn).assertEqual(true);
      expect(off.isCastOn).assertEqual(false);
      expect(empty.quickPlayValue).assertEqual('1');
    });

    it(addCase(casePrefix + 'Links_MiraCastToggle_009'), 0, () => {
      const offToOn = toggleMiraCastState(false);
      const onToOff = toggleMiraCastState(true);
      expect(offToOn.nextOn).assertEqual(true);
      expect(offToOn.statusValue).assertEqual('1');
      expect(onToOff.statusValue).assertEqual('0');
    });

    it(addCase(casePrefix + 'Links_ScreenExpansionVisible_010'), 0, () => {
      expect(resolveScreenExpansionVisibility('Hi3751V352')).assertEqual(false);
      expect(resolveScreenExpansionVisibility('OtherModel')).assertEqual(true);
    });

    it(addCase(casePrefix + 'Links_CastPersistence_011'), 0, () => {
      const on = resolveCastPersistenceByToggle(true);
      const off = resolveCastPersistenceByToggle(false);
      expect(on.dlnaEnabled).assertEqual('true');
      expect(on.castSwitch).assertEqual('1');
      expect(off.quickPlay).assertEqual('0');
    });

    it(addCase(casePrefix + 'Links_TrustDialogEnter_012'), 0, () => {
      expect(shouldOpenTrustDeviceDialog(2054, true)).assertEqual(true);
      expect(shouldOpenTrustDeviceDialog(2054, false)).assertEqual(false);
      expect(shouldOpenTrustDeviceDialog(1000, true)).assertEqual(false);
    });

    it(addCase(casePrefix + 'Stress_MiraCastToggle_013'), 0, () => {
      let state = false;
      for (let i = 0; i < 180; i++) {
        state = toggleMiraCastState(state).nextOn;
      }
      expect(state).assertEqual(false);
    });

    it(addCase(casePrefix + 'Stress_DeviceShorten_014'), 0, () => {
      let ok = true;
      for (let i = 0; i < 120; i++) {
        const raw = `device_${i}_12345678901234567890`;
        const result = shortenDeviceName(raw);
        if (result.length < 3 || result.length > 18) {
          ok = false;
        }
      }
      expect(ok).assertEqual(true);
    });

    it(addCase(casePrefix + 'Contract_CaseNaming_015'), 0, () => {
      const regex = /^Settings_BluetoothLinksSubDeep_[A-Za-z0-9_]+_[0-9]{3}$/;
      const names: Set<string> = new Set<string>();
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(regex.test(allCaseNames[i])).assertEqual(true);
        expect(names.has(allCaseNames[i])).assertEqual(false);
        names.add(allCaseNames[i]);
      }
      expect(names.size).assertEqual(allCaseNames.length);
    });

    it(addCase(casePrefix + 'Bluetooth_UnknownConnectionState_016'), 0, () => {
      expect(resolveConnectionStateText(-1).text).assertEqual('');
      expect(resolveConnectionStateText(9).text).assertEqual('');
    });

    it(addCase(casePrefix + 'Bluetooth_DisconnectLabelGate_017'), 0, () => {
      expect(shouldShowDisconnectLabel(2)).assertEqual(true);
      expect(shouldShowDisconnectLabel(1)).assertEqual(false);
      expect(shouldShowDisconnectLabel(0)).assertEqual(false);
    });

    it(addCase(casePrefix + 'Bluetooth_DeviceSelectionKey_018'), 0, () => {
      expect(resolveDeviceSelectionKey({ deviceId: 'dev_1', deviceName: '音箱A' })).assertEqual('dev_1');
      expect(resolveDeviceSelectionKey({ deviceId: '', deviceName: '音箱B' })).assertEqual('音箱B');
      expect(resolveDeviceSelectionKey({})).assertEqual('');
    });

    it(addCase(casePrefix + 'Links_CastDefaultFallback_019'), 0, () => {
      const fallback = resolveCastSwitchState('unexpected');
      expect(fallback.isCastOn).assertEqual(true);
      expect(fallback.dlnaEnabled).assertEqual('true');
      expect(fallback.quickPlayValue).assertEqual('1');
    });

    it(addCase(casePrefix + 'Links_BatchToggleBalance_020'), 0, () => {
      const even = resolveBatchCastToggle(false, 20);
      const odd = resolveBatchCastToggle(false, 21);
      expect(even.finalState).assertEqual(false);
      expect(even.onCount).assertEqual(10);
      expect(even.offCount).assertEqual(10);
      expect(odd.finalState).assertEqual(true);
    });

    it(addCase(casePrefix + 'Links_ScreenExpansionMatrix_021'), 0, () => {
      const models = ['Hi3751V352', 'Hi3751V353', 'Other', ''];
      let visibleCount = 0;
      for (let i = 0; i < models.length; i++) {
        if (resolveScreenExpansionVisibility(models[i])) {
          visibleCount++;
        }
      }
      expect(visibleCount).assertEqual(3);
    });

    it(addCase(casePrefix + 'Stress_TrustDialogGate_022'), 0, () => {
      let openCount = 0;
      const keys = [2054, 1000, 2054, 3000];
      const ups = [true, true, false, false];
      for (let i = 0; i < 160; i++) {
        if (shouldOpenTrustDeviceDialog(keys[i % keys.length], ups[i % ups.length])) {
          openCount++;
        }
      }
      expect(openCount > 0).assertEqual(true);
      expect(openCount < 160).assertEqual(true);
    });
  });
}

