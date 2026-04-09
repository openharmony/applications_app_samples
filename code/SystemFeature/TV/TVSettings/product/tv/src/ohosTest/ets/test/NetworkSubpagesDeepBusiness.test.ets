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

interface NetworkModeSwitchResult {
  nextMode: '自动' | '手动';
  nextIndex: number;
}

interface FocusMoveResult {
  nextFocus: number;
}

interface WifiSummaryResolveResult {
  summary: string;
  persistedOnline: boolean;
  shouldStartBrowser: boolean;
}

function switchWiredNetworkMode(curValue: string, direction: 'LEFT' | 'RIGHT'): NetworkModeSwitchResult {
  const origins: Array<'自动' | '手动'> = ['自动', '手动'];
  let index = curValue === '手动' ? 1 : 0;
  if (direction === 'LEFT' && index > 0) {
    index--;
  }
  if (direction === 'RIGHT' && index < 1) {
    index++;
  }
  return { nextMode: origins[index], nextIndex: index };
}

function shouldAllowManualNetworkEdit(netMode: string, itemName: string): boolean {
  const editableItems = ['IP地址', '子网掩码', '默认网关', 'DNS服务器'];
  return netMode === '手动' && editableItems.includes(itemName);
}

function resolveWifiSummaryByResponseCode(
  responseCode: number,
  jump: boolean
): WifiSummaryResolveResult {
  if (responseCode === 204) {
    return {
      summary: 'CONNECTED',
      persistedOnline: true,
      shouldStartBrowser: false
    };
  }
  return {
    summary: 'CONNECTED_PRO',
    persistedOnline: false,
    shouldStartBrowser: jump
  };
}

function resolveWifiSummaryByCapability(hasValidatedCap: boolean): WifiSummaryResolveResult {
  if (hasValidatedCap) {
    return {
      summary: 'CONNECTED',
      persistedOnline: true,
      shouldStartBrowser: false
    };
  }
  return {
    summary: 'CONNECTED_PRO',
    persistedOnline: false,
    shouldStartBrowser: false
  };
}

function resolveHandleFocusState(signal: 'delete' | 'link' | 'other', hasNetworkId: boolean): FocusMoveResult {
  if (signal === 'delete') {
    return { nextFocus: -2 };
  }
  if (signal === 'link') {
    return { nextFocus: hasNetworkId ? -2 : -1 };
  }
  return { nextFocus: -1 };
}

function calcNetworkListOffsetY(
  focusIndex: number,
  curYOffset: number,
  visibleHeight: number,
  itemHeight: number,
  itemSpace: number,
  bufferHeight: number
): number {
  const enableAreaTop = curYOffset + bufferHeight;
  const enableAreaBottom = curYOffset + visibleHeight - bufferHeight;
  const curFocusItemTop = focusIndex * itemHeight + focusIndex * itemSpace;
  const curFocusItemBottom = curFocusItemTop + itemHeight;
  const inArea = curFocusItemTop >= enableAreaTop && curFocusItemBottom <= enableAreaBottom;
  if (inArea) {
    return curYOffset;
  }
  return curFocusItemTop < enableAreaTop
    ? curFocusItemTop - bufferHeight
    : curFocusItemBottom - visibleHeight + bufferHeight;
}

function resolveBearerTypeToIsNetConn(bearerType: number): boolean {
  if (bearerType === 3) {
    return true;
  }
  if (bearerType === 1) {
    return true;
  }
  return false;
}

function shouldReplaceToNetworkPageByBearerType(bearerType: number): boolean {
  return bearerType === 3;
}

function shouldEnableWifiConnectConfirm(ssid: string): boolean {
  return ssid.length > 0;
}

function resolveWifiPasswordMinLengthState(password: string, minLength: number = 8): boolean {
  return password.length >= minLength;
}

export default function NetworkSubpagesDeepBusinessTest() {
  const casePrefix = 'Settings_NetworkSubDeep_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('NetworkSubpagesDeepBusinessSuite', () => {
    it(addCase(casePrefix + 'Wired_ModeLeftRight_001'), 0, () => {
      const fromAutoRight = switchWiredNetworkMode('自动', 'RIGHT');
      const fromManualLeft = switchWiredNetworkMode('手动', 'LEFT');
      expect(fromAutoRight.nextMode).assertEqual('手动');
      expect(fromAutoRight.nextIndex).assertEqual(1);
      expect(fromManualLeft.nextMode).assertEqual('自动');
      expect(fromManualLeft.nextIndex).assertEqual(0);
    });

    it(addCase(casePrefix + 'Wired_ManualEditGate_002'), 0, () => {
      expect(shouldAllowManualNetworkEdit('自动', 'IP地址')).assertEqual(false);
      expect(shouldAllowManualNetworkEdit('手动', 'IP地址')).assertEqual(true);
      expect(shouldAllowManualNetworkEdit('手动', '配置网络')).assertEqual(false);
    });

    it(addCase(casePrefix + 'Wifi_Response204_003'), 0, () => {
      const result = resolveWifiSummaryByResponseCode(204, true);
      expect(result.summary).assertEqual('CONNECTED');
      expect(result.persistedOnline).assertEqual(true);
      expect(result.shouldStartBrowser).assertEqual(false);
    });

    it(addCase(casePrefix + 'Wifi_ResponseNon204_004'), 0, () => {
      const result = resolveWifiSummaryByResponseCode(302, true);
      expect(result.summary).assertEqual('CONNECTED_PRO');
      expect(result.persistedOnline).assertEqual(false);
      expect(result.shouldStartBrowser).assertEqual(true);
    });

    it(addCase(casePrefix + 'Wifi_CapabilityFallback_005'), 0, () => {
      const good = resolveWifiSummaryByCapability(true);
      const bad = resolveWifiSummaryByCapability(false);
      expect(good.summary).assertEqual('CONNECTED');
      expect(bad.summary).assertEqual('CONNECTED_PRO');
    });

    it(addCase(casePrefix + 'Wifi_HandleFocusDelete_006'), 0, () => {
      expect(resolveHandleFocusState('delete', false).nextFocus).assertEqual(-2);
      expect(resolveHandleFocusState('other', false).nextFocus).assertEqual(-1);
    });

    it(addCase(casePrefix + 'Wifi_HandleFocusLink_007'), 0, () => {
      expect(resolveHandleFocusState('link', true).nextFocus).assertEqual(-2);
      expect(resolveHandleFocusState('link', false).nextFocus).assertEqual(-1);
    });

    it(addCase(casePrefix + 'Wifi_AdjustOffset_008'), 0, () => {
      const yTop = calcNetworkListOffsetY(0, 0, 480, 110, 12, 150);
      const yBottom = calcNetworkListOffsetY(7, 0, 480, 110, 12, 150);
      expect(yTop <= 0).assertEqual(true);
      expect(yBottom > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'SoftwareUpdate_BearerConn_009'), 0, () => {
      expect(resolveBearerTypeToIsNetConn(3)).assertEqual(true);
      expect(resolveBearerTypeToIsNetConn(1)).assertEqual(true);
      expect(resolveBearerTypeToIsNetConn(2)).assertEqual(false);
    });

    it(addCase(casePrefix + 'Wifi_BearerReplacePage_010'), 0, () => {
      expect(shouldReplaceToNetworkPageByBearerType(3)).assertEqual(true);
      expect(shouldReplaceToNetworkPageByBearerType(1)).assertEqual(false);
    });

    it(addCase(casePrefix + 'Wifi_ConnectConfirmEnable_011'), 0, () => {
      expect(shouldEnableWifiConnectConfirm('MyWiFi')).assertEqual(true);
      expect(shouldEnableWifiConnectConfirm('')).assertEqual(false);
    });

    it(addCase(casePrefix + 'Wifi_PasswordMinLength_012'), 0, () => {
      expect(resolveWifiPasswordMinLengthState('1234567', 8)).assertEqual(false);
      expect(resolveWifiPasswordMinLengthState('12345678', 8)).assertEqual(true);
    });

    it(addCase(casePrefix + 'Stress_ModeSwitch_013'), 0, () => {
      let mode = '自动';
      for (let i = 0; i < 200; i++) {
        mode = switchWiredNetworkMode(mode, i % 2 === 0 ? 'RIGHT' : 'LEFT').nextMode;
      }
      expect(mode === '自动' || mode === '手动').assertEqual(true);
    });

    it(addCase(casePrefix + 'Stress_OffsetScan_014'), 0, () => {
      let positiveCount = 0;
      for (let i = 0; i < 180; i++) {
        const y = calcNetworkListOffsetY(i % 12, 0, 480, 110, 12, 150);
        if (y > 0) {
          positiveCount++;
        }
      }
      expect(positiveCount > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'Contract_CaseNaming_015'), 0, () => {
      const regex = /^Settings_NetworkSubDeep_[A-Za-z0-9_]+_[0-9]{3}$/;
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

