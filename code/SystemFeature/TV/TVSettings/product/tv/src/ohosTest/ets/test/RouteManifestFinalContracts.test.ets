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

interface RouteEntry {
  path: string;
  category: 'entry' | 'page';
}

interface ModuleStat {
  moduleName: string;
  count: number;
}

interface RouteShapeStat {
  rootCount: number;
  nestedCount: number;
  editorCount: number;
}

function isRoutePathValid(path: string): boolean {
  const rootRule = /^pages\/[A-Za-z0-9_]+$/;
  const nestedRule = /^pages\/[A-Za-z0-9_]+(\/[A-Za-z0-9_]+)+$/;
  return rootRule.test(path) || nestedRule.test(path);
}

function extractModule(path: string): string {
  const segments = path.split('/');
  return segments.length >= 3 ? segments[1] : 'root';
}

function extractLeaf(path: string): string {
  const segments = path.split('/');
  return segments[segments.length - 1];
}

function isNestedRoute(path: string): boolean {
  return path.split('/').length > 3;
}

function isEditorRoute(path: string): boolean {
  const leaf = extractLeaf(path);
  return leaf.endsWith('Update') || leaf.endsWith('PWD');
}

function countModuleRoutes(routes: Array<RouteEntry>, moduleName: string): number {
  let count = 0;
  const prefix = `pages/${moduleName}/`;
  for (let i = 0; i < routes.length; i++) {
    if (routes[i].path.startsWith(prefix)) {
      count++;
    }
  }
  return count;
}

function collectRouteShapeStats(routes: Array<RouteEntry>): RouteShapeStat {
  let rootCount = 0;
  let nestedCount = 0;
  let editorCount = 0;
  for (let i = 0; i < routes.length; i++) {
    if (routes[i].path.split('/').length === 2) {
      rootCount++;
    }
    if (isNestedRoute(routes[i].path)) {
      nestedCount++;
    }
    if (isEditorRoute(routes[i].path)) {
      editorCount++;
    }
  }
  return { rootCount, nestedCount, editorCount };
}

function collectModuleStats(routes: Array<RouteEntry>): Array<ModuleStat> {
  const counter: Record<string, number> = {};
  for (let i = 0; i < routes.length; i++) {
    const moduleName = extractModule(routes[i].path);
    counter[moduleName] = (counter[moduleName] ?? 0) + 1;
  }
  const modules = Object.keys(counter).sort();
  const result: Array<ModuleStat> = [];
  for (let i = 0; i < modules.length; i++) {
    result.push({ moduleName: modules[i], count: counter[modules[i]] });
  }
  return result;
}

function containsLeaf(routes: Array<RouteEntry>, leafName: string): boolean {
  for (let i = 0; i < routes.length; i++) {
    if (extractLeaf(routes[i].path) === leafName) {
      return true;
    }
  }
  return false;
}

function countCategory(routes: Array<RouteEntry>, category: 'entry' | 'page'): number {
  let count = 0;
  for (let i = 0; i < routes.length; i++) {
    if (routes[i].category === category) {
      count++;
    }
  }
  return count;
}

export default function RouteManifestFinalContractsTest() {
  const casePrefix = 'Settings_RouteManifestFinal_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<RouteEntry> = [
    { path: 'pages/SettingList', category: 'entry' },
    { path: 'pages/volume/Volume', category: 'entry' },
    { path: 'pages/volume/OutPut', category: 'page' },
    { path: 'pages/volume/Effects', category: 'page' },
    { path: 'pages/volume/CustomEffects', category: 'page' },
    { path: 'pages/volume/BluetoothOutput', category: 'page' },
    { path: 'pages/display/Display', category: 'entry' },
    { path: 'pages/display/ScreenCalibration', category: 'page' },
    { path: 'pages/display/PhotoSetting', category: 'page' },
    { path: 'pages/display/NightLight', category: 'page' },
    { path: 'pages/display/HighSetting', category: 'page' },
    { path: 'pages/display/ColorSetting', category: 'page' },
    { path: 'pages/display/ClaritySetting', category: 'page' },
    { path: 'pages/display/BrightnessSetting', category: 'page' },
    { path: 'pages/display/SourceIdentification', category: 'page' },
    { path: 'pages/display/ColorSpace', category: 'page' },
    { path: 'pages/network/Network', category: 'entry' },
    { path: 'pages/network/Wifi', category: 'page' },
    { path: 'pages/network/WiredNetwork', category: 'page' },
    { path: 'pages/network/WifiPsd', category: 'page' },
    { path: 'pages/network/WifiInfoDetail', category: 'page' },
    { path: 'pages/network/NetMonitor', category: 'page' },
    { path: 'pages/network/NetSpeed', category: 'page' },
    { path: 'pages/network/NetMaskUpdate', category: 'page' },
    { path: 'pages/network/IpUpdate', category: 'page' },
    { path: 'pages/network/GatewayUpdate', category: 'page' },
    { path: 'pages/network/DnsUpdate', category: 'page' },
    { path: 'pages/system/System', category: 'entry' },
    { path: 'pages/system/TimeAndDate', category: 'page' },
    { path: 'pages/system/SystemInfo', category: 'page' },
    { path: 'pages/system/StateInfo', category: 'page' },
    { path: 'pages/system/SoftwareUpdate', category: 'page' },
    { path: 'pages/system/DeviceInfo', category: 'page' },
    { path: 'pages/links/Links', category: 'entry' },
    { path: 'pages/links/screenExpansion/ScreenExpansion', category: 'page' },
    { path: 'pages/links/screenExpansion/DefaultMainWindowPage', category: 'page' },
    { path: 'pages/links/screenExpansion/Application', category: 'page' },
    { path: 'pages/oneConnectShare/OneConnectShare', category: 'entry' },
    { path: 'pages/hotspot/Hotspot', category: 'entry' },
    { path: 'pages/hotspot/HotspotPWD', category: 'page' },
    { path: 'pages/hotspot/DeviceName', category: 'page' },
    { path: 'pages/hotspot/ConnectedDeviceList', category: 'page' },
    { path: 'pages/general/General', category: 'entry' },
    { path: 'pages/general/AutoScreenOff', category: 'page' },
    { path: 'pages/general/ControllerCon', category: 'page' },
    { path: 'pages/general/FloatBall', category: 'page' },
    { path: 'pages/general/HDMIIN', category: 'page' },
    { path: 'pages/general/HDMIOUT', category: 'page' },
    { path: 'pages/general/Hdmi', category: 'page' },
    { path: 'pages/general/Ime', category: 'page' },
    { path: 'pages/general/InputSource', category: 'page' },
    { path: 'pages/general/PairGuidance', category: 'page' },
    { path: 'pages/general/RemoteController', category: 'page' },
    { path: 'pages/general/ScreenRotation', category: 'page' },
    { path: 'pages/general/Standby', category: 'page' },
    { path: 'pages/general/StandbyMode', category: 'page' },
    { path: 'pages/general/StartupMode', category: 'page' },
    { path: 'pages/general/USB', category: 'page' },
    { path: 'pages/general/WatchTvKeyPage', category: 'page' },
    { path: 'pages/bluetooth/BluetoothDeviceEntry', category: 'entry' }
  ];

  describe('RouteManifestFinalContractsSuite', () => {
    it(addCase(casePrefix + 'Manifest_FormatAndUniqueness_001'), 0, () => {
      const unique: Set<string> = new Set<string>();
      for (let i = 0; i < routes.length; i++) {
        expect(isRoutePathValid(routes[i].path)).assertEqual(true);
        expect(unique.has(routes[i].path)).assertEqual(false);
        unique.add(routes[i].path);
      }
      expect(unique.size).assertEqual(routes.length);
    });

    it(addCase(casePrefix + 'Manifest_TotalRouteCount_002'), 0, () => {
      expect(routes.length).assertEqual(60);
      expect(countCategory(routes, 'entry')).assertEqual(10);
      expect(countCategory(routes, 'page')).assertEqual(50);
    });

    it(addCase(casePrefix + 'Manifest_ModuleCoverage_003'), 0, () => {
      const stats = collectModuleStats(routes);
      const modules = stats.map((item) => item.moduleName);
      expect(modules.includes('root')).assertEqual(true);
      expect(modules.includes('volume')).assertEqual(true);
      expect(modules.includes('display')).assertEqual(true);
      expect(modules.includes('network')).assertEqual(true);
      expect(modules.includes('system')).assertEqual(true);
      expect(modules.includes('links')).assertEqual(true);
      expect(modules.includes('oneConnectShare')).assertEqual(true);
      expect(modules.includes('hotspot')).assertEqual(true);
      expect(modules.includes('general')).assertEqual(true);
      expect(modules.includes('bluetooth')).assertEqual(true);
    });

    it(addCase(casePrefix + 'Manifest_VolumeDistribution_004'), 0, () => {
      expect(countModuleRoutes(routes, 'volume')).assertEqual(5);
      expect(containsLeaf(routes, 'volume')).assertEqual(true);
      expect(containsLeaf(routes, 'bluetoothOutput')).assertEqual(true);
      expect(containsLeaf(routes, 'customEffects')).assertEqual(true);
    });

    it(addCase(casePrefix + 'Manifest_DisplayDistribution_005'), 0, () => {
      expect(countModuleRoutes(routes, 'display')).assertEqual(10);
      expect(containsLeaf(routes, 'screenCalibration')).assertEqual(true);
      expect(containsLeaf(routes, 'brightnessSetting')).assertEqual(true);
      expect(containsLeaf(routes, 'ColorSpace')).assertEqual(true);
    });

    it(addCase(casePrefix + 'Manifest_NetworkDistribution_006'), 0, () => {
      expect(countModuleRoutes(routes, 'network')).assertEqual(11);
      expect(containsLeaf(routes, 'wifi')).assertEqual(true);
      expect(containsLeaf(routes, 'wiredNetwork')).assertEqual(true);
      expect(containsLeaf(routes, 'wifiInfoDetail')).assertEqual(true);
      expect(containsLeaf(routes, 'dnsUpdate')).assertEqual(true);
    });

    it(addCase(casePrefix + 'Manifest_SystemDistribution_007'), 0, () => {
      expect(countModuleRoutes(routes, 'system')).assertEqual(6);
      expect(containsLeaf(routes, 'softwareUpdate')).assertEqual(true);
      expect(containsLeaf(routes, 'timeAndDate')).assertEqual(true);
      expect(containsLeaf(routes, 'deviceInfo')).assertEqual(true);
      expect(containsLeaf(routes, 'stateInfo')).assertEqual(true);
    });

    it(addCase(casePrefix + 'Manifest_LinksDistribution_008'), 0, () => {
      expect(countModuleRoutes(routes, 'links')).assertEqual(4);
      expect(containsLeaf(routes, 'links')).assertEqual(true);
      expect(containsLeaf(routes, 'screenExpansion')).assertEqual(true);
      expect(containsLeaf(routes, 'DefaultMainWindowPage')).assertEqual(true);
      expect(containsLeaf(routes, 'application')).assertEqual(true);
    });

    it(addCase(casePrefix + 'Manifest_GeneralDistribution_009'), 0, () => {
      expect(countModuleRoutes(routes, 'general')).assertEqual(17);
      expect(containsLeaf(routes, 'general')).assertEqual(true);
      expect(containsLeaf(routes, 'startupMode')).assertEqual(true);
      expect(containsLeaf(routes, 'pairGuidance')).assertEqual(true);
      expect(containsLeaf(routes, 'USB')).assertEqual(true);
      expect(containsLeaf(routes, 'WatchTvKeyPage')).assertEqual(true);
    });

    it(addCase(casePrefix + 'Manifest_HotspotAndBluetoothDistribution_010'), 0, () => {
      expect(countModuleRoutes(routes, 'hotspot')).assertEqual(4);
      expect(countModuleRoutes(routes, 'bluetooth')).assertEqual(1);
      expect(countModuleRoutes(routes, 'oneConnectShare')).assertEqual(1);
      expect(containsLeaf(routes, 'hotspotPWD')).assertEqual(true);
      expect(containsLeaf(routes, 'ConnectedDeviceList')).assertEqual(true);
      expect(containsLeaf(routes, 'bluetoothDeviceEntry')).assertEqual(true);
    });

    it(addCase(casePrefix + 'Manifest_ShapeStats_011'), 0, () => {
      const stat = collectRouteShapeStats(routes);
      expect(stat.rootCount).assertEqual(1);
      expect(stat.nestedCount).assertEqual(3);
      expect(stat.editorCount).assertEqual(6);
    });

    it(addCase(casePrefix + 'Manifest_RouteCasePolicy_012'), 0, () => {
      let upperCaseLeafCount = 0;
      for (let i = 0; i < routes.length; i++) {
        const leaf = extractLeaf(routes[i].path);
        if (/[A-Z]/.test(leaf)) {
          upperCaseLeafCount++;
        }
      }
      expect(upperCaseLeafCount > 0).assertEqual(true);
      expect(containsLeaf(routes, 'HDMIIN')).assertEqual(true);
      expect(containsLeaf(routes, 'HDMIOUT')).assertEqual(true);
      expect(containsLeaf(routes, 'SourceIdentification')).assertEqual(true);
    });

    it(addCase(casePrefix + 'Manifest_ModuleStatsSorted_013'), 0, () => {
      const stats = collectModuleStats(routes);
      for (let i = 1; i < stats.length; i++) {
        expect(stats[i - 1].moduleName <= stats[i].moduleName).assertEqual(true);
      }
      expect(stats.length).assertEqual(10);
    });

    it(addCase(casePrefix + 'Manifest_EntryRoutePresence_014'), 0, () => {
      const entries = routes.filter((item) => item.category === 'entry').map((item) => item.path);
      expect(entries.includes('pages/SettingList')).assertEqual(true);
      expect(entries.includes('pages/general/General')).assertEqual(true);
      expect(entries.includes('pages/system/System')).assertEqual(true);
      expect(entries.includes('pages/network/Network')).assertEqual(true);
      expect(entries.includes('pages/hotspot/Hotspot')).assertEqual(true);
    });

    it(addCase(casePrefix + 'Manifest_NoUtilityRoutesMixedIn_015'), 0, () => {
      let hasInvalid = false;
      for (let i = 0; i < routes.length; i++) {
        if (routes[i].path.includes('/utils/') || routes[i].path.includes('CustomDialogComponent') ||
          routes[i].path.includes('BluetoothPairDialog')) {
          hasInvalid = true;
        }
      }
      expect(hasInvalid).assertEqual(false);
    });

    it(addCase(casePrefix + 'Manifest_EditorRouteSet_016'), 0, () => {
      const editors = routes.filter((item) => isEditorRoute(item.path)).map((item) => extractLeaf(item.path));
      expect(editors.length).assertEqual(6);
      expect(editors.includes('ipUpdate')).assertEqual(true);
      expect(editors.includes('gatewayUpdate')).assertEqual(true);
      expect(editors.includes('dnsUpdate')).assertEqual(true);
      expect(editors.includes('netMaskUpdate')).assertEqual(true);
      expect(editors.includes('hotspotPWD')).assertEqual(true);
    });

    it(addCase(casePrefix + 'Manifest_NestedRouteSet_017'), 0, () => {
      const nested = routes.filter((item) => isNestedRoute(item.path)).map((item) => item.path);
      expect(nested.length).assertEqual(3);
      expect(nested.includes('pages/links/screenExpansion/ScreenExpansion')).assertEqual(true);
      expect(nested.includes('pages/links/screenExpansion/DefaultMainWindowPage')).assertEqual(true);
      expect(nested.includes('pages/links/screenExpansion/Application')).assertEqual(true);
    });

    it(addCase(casePrefix + 'Manifest_StressFormatSweep_018'), 0, () => {
      let validCount = 0;
      for (let i = 0; i < 1000; i++) {
        if (isRoutePathValid(routes[i % routes.length].path)) {
          validCount++;
        }
      }
      expect(validCount).assertEqual(1000);
    });

    it(addCase(casePrefix + 'Manifest_StressModuleCounting_019'), 0, () => {
      let networkCount = 0;
      let generalCount = 0;
      for (let i = 0; i < 600; i++) {
        const route = routes[i % routes.length].path;
        if (extractModule(route) === 'network') {
          networkCount++;
        }
        if (extractModule(route) === 'general') {
          generalCount++;
        }
      }
      expect(networkCount > 0).assertEqual(true);
      expect(generalCount > networkCount).assertEqual(true);
    });

    it(addCase(casePrefix + 'Manifest_CaseNaming_020'), 0, () => {
      const regex = /^Settings_RouteManifestFinal_[A-Za-z0-9_]+_[0-9]{3}$/;
      const unique: Set<string> = new Set<string>();
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(regex.test(allCaseNames[i])).assertEqual(true);
        expect(unique.has(allCaseNames[i])).assertEqual(false);
        unique.add(allCaseNames[i]);
      }
      expect(unique.size).assertEqual(allCaseNames.length);
    });
  });
}

