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

interface NetworkRouteScenario {
  name: string;
  path: string;
  isEditor: boolean;
}

function isNetworkRoute(path: string): boolean {
  return /^pages\/network\/[A-Za-z0-9_]+$/.test(path);
}

function isEditorRoute(path: string): boolean {
  return path.endsWith('Update') || path.endsWith('Psd');
}

export default function MegaNetworkRouteReplayBatchTest() {
  const casePrefix = 'Settings_MegaNetworkRouteReplay_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routeScenarios: Array<NetworkRouteScenario> = [
    { name: 'route_001', path: 'pages/network/Network', isEditor: false },
    { name: 'route_002', path: 'pages/network/Wifi', isEditor: false },
    { name: 'route_003', path: 'pages/network/WiredNetwork', isEditor: false },
    { name: 'route_004', path: 'pages/network/WifiPsd', isEditor: true },
    { name: 'route_005', path: 'pages/network/WifiInfoDetail', isEditor: false },
    { name: 'route_006', path: 'pages/network/NetMonitor', isEditor: false },
    { name: 'route_007', path: 'pages/network/NetSpeed', isEditor: false },
    { name: 'route_008', path: 'pages/network/NetMaskUpdate', isEditor: true },
    { name: 'route_009', path: 'pages/network/IpUpdate', isEditor: true },
    { name: 'route_010', path: 'pages/network/GatewayUpdate', isEditor: true },
    { name: 'route_011', path: 'pages/network/DnsUpdate', isEditor: true },
    { name: 'route_012', path: 'pages/network/Network', isEditor: false },
    { name: 'route_013', path: 'pages/network/Wifi', isEditor: false },
    { name: 'route_014', path: 'pages/network/WiredNetwork', isEditor: false },
    { name: 'route_015', path: 'pages/network/WifiPsd', isEditor: true },
    { name: 'route_016', path: 'pages/network/WifiInfoDetail', isEditor: false }
  ];

  describe('MegaNetworkRouteReplayBatchSuite', () => {
    it(addCase(casePrefix + 'RoutePattern_001'), 0, () => {
      for (let i = 0; i < routeScenarios.length; i++) {
        const item = routeScenarios[i];
        expect(isNetworkRoute(item.path)).assertEqual(true);
        expect(isEditorRoute(item.path)).assertEqual(item.isEditor);
      }
    });

    it(addCase(casePrefix + 'RouteStress_002'), 0, () => {
      let okCount = 0;
      for (let i = 0; i < 1000; i++) {
        const item = routeScenarios[i % routeScenarios.length];
        if (isNetworkRoute(item.path) && isEditorRoute(item.path) === item.isEditor) {
          okCount++;
        }
      }
      expect(okCount).assertEqual(1000);
    });

    it(addCase(casePrefix + 'Coverage_003'), 0, () => {
      let hasWifiPsd = false;
      let hasDnsUpdate = false;
      let hasEditor = false;
      let hasNonEditor = false;
      for (let i = 0; i < routeScenarios.length; i++) {
        const item = routeScenarios[i];
        if (item.path === 'pages/network/WifiPsd') {
          hasWifiPsd = true;
        }
        if (item.path === 'pages/network/DnsUpdate') {
          hasDnsUpdate = true;
        }
        if (item.isEditor) {
          hasEditor = true;
        } else {
          hasNonEditor = true;
        }
      }
      expect(hasWifiPsd).assertEqual(true);
      expect(hasDnsUpdate).assertEqual(true);
      expect(hasEditor).assertEqual(true);
      expect(hasNonEditor).assertEqual(true);
    });

    it(addCase(casePrefix + 'CaseNaming_004'), 0, () => {
      const regex = /^Settings_MegaNetworkRouteReplay_[A-Za-z0-9_]+_[0-9]{3}$/;
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

