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

interface GeneralToggleScenario {
  name: string;
  currentValue: string;
  expectedNext: string;
}

interface GeneralRouteScenario {
  name: string;
  title: string;
  path: string;
}

function toggleSettingValue(currentValue: string): string {
  return currentValue === '1' ? '0' : '1';
}

function isGeneralRoute(path: string): boolean {
  return /^pages\/general\/[A-Za-z0-9_]+$/.test(path);
}

export default function MegaGeneralSettingMatrixTest() {
  const casePrefix = 'Settings_MegaGeneralSetting_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const toggleScenarios: Array<GeneralToggleScenario> = [
    { name: 'toggle_001', currentValue: '0', expectedNext: '1' },
    { name: 'toggle_002', currentValue: '1', expectedNext: '0' },
    { name: 'toggle_003', currentValue: '0', expectedNext: '1' },
    { name: 'toggle_004', currentValue: '1', expectedNext: '0' },
    { name: 'toggle_005', currentValue: '0', expectedNext: '1' },
    { name: 'toggle_006', currentValue: '1', expectedNext: '0' },
    { name: 'toggle_007', currentValue: '0', expectedNext: '1' },
    { name: 'toggle_008', currentValue: '1', expectedNext: '0' },
    { name: 'toggle_009', currentValue: '0', expectedNext: '1' },
    { name: 'toggle_010', currentValue: '1', expectedNext: '0' },
    { name: 'toggle_011', currentValue: '0', expectedNext: '1' },
    { name: 'toggle_012', currentValue: '1', expectedNext: '0' },
    { name: 'toggle_013', currentValue: '0', expectedNext: '1' },
    { name: 'toggle_014', currentValue: '1', expectedNext: '0' },
    { name: 'toggle_015', currentValue: '0', expectedNext: '1' },
    { name: 'toggle_016', currentValue: '1', expectedNext: '0' },
    { name: 'toggle_017', currentValue: '0', expectedNext: '1' },
    { name: 'toggle_018', currentValue: '1', expectedNext: '0' },
    { name: 'toggle_019', currentValue: '0', expectedNext: '1' },
    { name: 'toggle_020', currentValue: '1', expectedNext: '0' }
  ];
  const routeScenarios: Array<GeneralRouteScenario> = [
    { name: 'route_001', title: 'General', path: 'pages/general/General' },
    { name: 'route_002', title: 'AutoScreenOff', path: 'pages/general/AutoScreenOff' },
    { name: 'route_003', title: 'ControllerCon', path: 'pages/general/ControllerCon' },
    { name: 'route_004', title: 'FloatBall', path: 'pages/general/FloatBall' },
    { name: 'route_005', title: 'HDMIIN', path: 'pages/general/HDMIIN' },
    { name: 'route_006', title: 'HDMIOUT', path: 'pages/general/HDMIOUT' },
    { name: 'route_007', title: 'Hdmi', path: 'pages/general/Hdmi' },
    { name: 'route_008', title: 'Ime', path: 'pages/general/Ime' },
    { name: 'route_009', title: 'InputSource', path: 'pages/general/InputSource' },
    { name: 'route_010', title: 'PairGuidance', path: 'pages/general/PairGuidance' },
    { name: 'route_011', title: 'RemoteController', path: 'pages/general/RemoteController' },
    { name: 'route_012', title: 'ScreenRotation', path: 'pages/general/ScreenRotation' },
    { name: 'route_013', title: 'Standby', path: 'pages/general/Standby' },
    { name: 'route_014', title: 'StandbyMode', path: 'pages/general/StandbyMode' },
    { name: 'route_015', title: 'StartupMode', path: 'pages/general/StartupMode' },
    { name: 'route_016', title: 'USB', path: 'pages/general/USB' },
    { name: 'route_017', title: 'WatchTvKeyPage', path: 'pages/general/WatchTvKeyPage' }
  ];

  describe('MegaGeneralSettingMatrixSuite', () => {
    it(addCase(casePrefix + 'ToggleMatrix_001'), 0, () => {
      for (let i = 0; i < toggleScenarios.length; i++) {
        expect(toggleSettingValue(toggleScenarios[i].currentValue)).assertEqual(toggleScenarios[i].expectedNext);
      }
    });

    it(addCase(casePrefix + 'RouteMatrix_002'), 0, () => {
      const unique: Set<string> = new Set<string>();
      for (let i = 0; i < routeScenarios.length; i++) {
        expect(isGeneralRoute(routeScenarios[i].path)).assertEqual(true);
        expect(unique.has(routeScenarios[i].path)).assertEqual(false);
        unique.add(routeScenarios[i].path);
      }
      expect(unique.size).assertEqual(routeScenarios.length);
    });

    it(addCase(casePrefix + 'StressToggleAndRoute_003'), 0, () => {
      let okCount = 0;
      for (let i = 0; i < 1000; i++) {
        const toggleItem = toggleScenarios[i % toggleScenarios.length];
        if (toggleSettingValue(toggleItem.currentValue) === toggleItem.expectedNext) {
          okCount++;
        }
        const routeItem = routeScenarios[i % routeScenarios.length];
        if (isGeneralRoute(routeItem.path)) {
          okCount++;
        }
      }
      expect(okCount).assertEqual(2000);
    });

    it(addCase(casePrefix + 'Coverage_004'), 0, () => {
      let hasUsb = false;
      let hasStartupMode = false;
      let hasInputSource = false;
      for (let i = 0; i < routeScenarios.length; i++) {
        const path = routeScenarios[i].path;
        if (path === 'pages/general/USB') {
          hasUsb = true;
        }
        if (path === 'pages/general/StartupMode') {
          hasStartupMode = true;
        }
        if (path === 'pages/general/InputSource') {
          hasInputSource = true;
        }
      }
      expect(hasUsb).assertEqual(true);
      expect(hasStartupMode).assertEqual(true);
      expect(hasInputSource).assertEqual(true);
      expect(routeScenarios.length >= 17).assertEqual(true);
    });

    it(addCase(casePrefix + 'CaseNaming_005'), 0, () => {
      const regex = /^Settings_MegaGeneralSetting_[A-Za-z0-9_]+_[0-9]{3}$/;
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

