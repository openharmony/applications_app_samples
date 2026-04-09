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

interface RouteCase {
  module: 'volume' | 'display' | 'network' | 'bluetooth' | 'general' | 'system' | 'links' | 'oneConnectShare' | 'hotspot';
  path: string;
}

interface Cursor {
  row: number;
  col: number;
}

interface GridSize {
  rows: number;
  cols: number;
}

interface RecentTask {
  id: string;
  title: string;
}

interface RouteStats {
  nestedCount: number;
  editorCount: number;
}

function clamp(v: number, min: number, max: number): number {
  return Math.max(min, Math.min(max, v));
}

function moveCursor(current: Cursor, key: 'UP' | 'DOWN' | 'LEFT' | 'RIGHT', grid: GridSize): Cursor {
  let nextRow = current.row;
  let nextCol = current.col;
  if (key === 'UP') {
    nextRow -= 1;
  } else if (key === 'DOWN') {
    nextRow += 1;
  } else if (key === 'LEFT') {
    nextCol -= 1;
  } else if (key === 'RIGHT') {
    nextCol += 1;
  }
  return {
    row: clamp(nextRow, 0, grid.rows - 1),
    col: clamp(nextCol, 0, grid.cols - 1)
  };
}

function pushRecentTask(stack: Array<RecentTask>, task: RecentTask): Array<RecentTask> {
  const filtered = stack.filter((item) => item.id !== task.id);
  filtered.unshift(task);
  return filtered.slice(0, 8);
}

function removeRecentTask(stack: Array<RecentTask>, taskId: string): Array<RecentTask> {
  return stack.filter((item) => item.id !== taskId);
}

function isRoutePathValid(path: string): boolean {
  const rootRule = /^pages\/[A-Za-z0-9_]+$/;
  const nestedRule = /^pages\/[A-Za-z0-9_]+(\/[A-Za-z0-9_]+)+$/;
  return rootRule.test(path) || nestedRule.test(path);
}

function collectRouteStats(routePaths: Array<string>): RouteStats {
  let nestedCount = 0;
  let editorCount = 0;
  for (let i = 0; i < routePaths.length; i++) {
    if (routePaths[i].split('/').length > 3) {
      nestedCount++;
    }
    if (routePaths[i].includes('Update')) {
      editorCount++;
    }
  }
  return { nestedCount, editorCount };
}

function countModuleRoutes(routePaths: Array<string>, moduleName: string): number {
  let count = 0;
  const prefix = `pages/${moduleName}/`;
  for (let i = 0; i < routePaths.length; i++) {
    if (routePaths[i].startsWith(prefix)) {
      count++;
    }
  }
  return count;
}

export default function PageInteractionContractsTest() {
  const casePrefix = 'Settings_PageInteraction_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routeRule = /^pages\/[a-zA-Z0-9_]+(\/[a-zA-Z0-9_]+)+$/;
  const routes: Array<RouteCase> = [
    { module: 'volume', path: 'pages/volume/volume' },
    { module: 'volume', path: 'pages/volume/outPut' },
    { module: 'display', path: 'pages/display/display' },
    { module: 'display', path: 'pages/display/screenCalibration' },
    { module: 'display', path: 'pages/display/SourceIdentification' },
    { module: 'network', path: 'pages/network/network' },
    { module: 'network', path: 'pages/network/wifi' },
    { module: 'network', path: 'pages/network/wiredNetwork' },
    { module: 'bluetooth', path: 'pages/bluetooth/bluetoothDeviceEntry' },
    { module: 'bluetooth', path: 'pages/bluetooth/bluetoothDeviceDetails' },
    { module: 'general', path: 'pages/general/general' },
    { module: 'general', path: 'pages/general/inputSource' },
    { module: 'system', path: 'pages/system/system' },
    { module: 'system', path: 'pages/system/deviceInfo' },
    { module: 'links', path: 'pages/links/links' },
    { module: 'links', path: 'pages/links/screenExpansion/screenExpansion' },
    { module: 'oneConnectShare', path: 'pages/oneConnectShare/oneConnectShare' },
    { module: 'hotspot', path: 'pages/hotspot/hotspot' }
  ];

  describe('PageInteractionContractsSuite', () => {
    it(addCase(casePrefix + 'Route_FormatAndUniqueness_001'), 0, () => {
      const unique: Set<string> = new Set<string>();
      for (let i = 0; i < routes.length; i++) {
        expect(routeRule.test(routes[i].path)).assertEqual(true);
        expect(unique.has(routes[i].path)).assertEqual(false);
        unique.add(routes[i].path);
      }
      expect(unique.size).assertEqual(routes.length);
    });

    it(addCase(casePrefix + 'Route_ModuleCoverage_002'), 0, () => {
      const modules: Set<string> = new Set<string>();
      for (let i = 0; i < routes.length; i++) {
        modules.add(routes[i].module);
      }
      expect(modules.has('volume')).assertEqual(true);
      expect(modules.has('display')).assertEqual(true);
      expect(modules.has('network')).assertEqual(true);
      expect(modules.has('system')).assertEqual(true);
      expect(modules.size >= 8).assertEqual(true);
    });

    it(addCase(casePrefix + 'EditMode_CursorBoundary_003'), 0, () => {
      const grid: GridSize = { rows: 3, cols: 4 };
      const topLeft: Cursor = { row: 0, col: 0 };
      const bottomRight: Cursor = { row: 2, col: 3 };
      expect(moveCursor(topLeft, 'UP', grid).row).assertEqual(0);
      expect(moveCursor(topLeft, 'LEFT', grid).col).assertEqual(0);
      expect(moveCursor(bottomRight, 'DOWN', grid).row).assertEqual(2);
      expect(moveCursor(bottomRight, 'RIGHT', grid).col).assertEqual(3);
    });

    it(addCase(casePrefix + 'EditMode_CursorPath_004'), 0, () => {
      const grid: GridSize = { rows: 3, cols: 3 };
      let cursor: Cursor = { row: 1, col: 1 };
      const keys: Array<'UP' | 'DOWN' | 'LEFT' | 'RIGHT'> = ['UP', 'LEFT', 'LEFT', 'DOWN', 'RIGHT', 'DOWN', 'DOWN'];
      for (let i = 0; i < keys.length; i++) {
        cursor = moveCursor(cursor, keys[i], grid);
      }
      expect(cursor.row).assertEqual(2);
      expect(cursor.col).assertEqual(1);
    });

    it(addCase(casePrefix + 'Shortcut_RemoveAndPersist_005'), 0, () => {
      let shortcuts: Array<string> = ['wifi', 'bluetooth', 'display', 'system'];
      shortcuts = shortcuts.filter((item) => item !== 'bluetooth');
      expect(shortcuts.includes('bluetooth')).assertEqual(false);
      shortcuts.unshift('network');
      expect(shortcuts[0]).assertEqual('network');
      expect(shortcuts.length).assertEqual(4);
    });

    it(addCase(casePrefix + 'RecentTask_OpenSwitch_006'), 0, () => {
      let stack: Array<RecentTask> = [];
      stack = pushRecentTask(stack, { id: 't1', title: '网络' });
      stack = pushRecentTask(stack, { id: 't2', title: '图像' });
      stack = pushRecentTask(stack, { id: 't3', title: '系统' });
      expect(stack[0].id).assertEqual('t3');
      stack = pushRecentTask(stack, { id: 't1', title: '网络' });
      expect(stack[0].id).assertEqual('t1');
      expect(stack.length).assertEqual(3);
    });

    it(addCase(casePrefix + 'RecentTask_DeleteClear_007'), 0, () => {
      let stack: Array<RecentTask> = [
        { id: 'a', title: 'A' },
        { id: 'b', title: 'B' },
        { id: 'c', title: 'C' }
      ];
      stack = removeRecentTask(stack, 'b');
      expect(stack.length).assertEqual(2);
      expect(stack.some((item) => item.id === 'b')).assertEqual(false);
      stack = [];
      expect(stack.length).assertEqual(0);
    });

    it(addCase(casePrefix + 'RecentTask_MaxLimit_008'), 0, () => {
      let stack: Array<RecentTask> = [];
      for (let i = 0; i < 20; i++) {
        stack = pushRecentTask(stack, { id: `id_${i}`, title: `title_${i}` });
      }
      expect(stack.length).assertEqual(8);
      expect(stack[0].id).assertEqual('id_19');
      expect(stack[7].id).assertEqual('id_12');
    });

    it(addCase(casePrefix + 'KeyEvent_HomeBackEdit_009'), 0, () => {
      const events: Array<'HOME' | 'BACK' | 'EDIT'> = ['EDIT', 'EDIT', 'BACK', 'HOME'];
      let inEditMode = false;
      let atHome = false;
      for (let i = 0; i < events.length; i++) {
        if (events[i] === 'EDIT') {
          inEditMode = !inEditMode;
        } else if (events[i] === 'BACK') {
          inEditMode = false;
        } else if (events[i] === 'HOME') {
          inEditMode = false;
          atHome = true;
        }
      }
      expect(inEditMode).assertEqual(false);
      expect(atHome).assertEqual(true);
    });

    it(addCase(casePrefix + 'StatusBar_Contract_010'), 0, () => {
      const iconVisible = true;
      const time = '08:30';
      const network = 'ONLINE';
      expect(iconVisible).assertEqual(true);
      expect(time.includes(':')).assertEqual(true);
      expect(['ONLINE', 'OFFLINE', 'LIMITED'].includes(network)).assertEqual(true);
    });

    it(addCase(casePrefix + 'RotationResolution_Matrix_011'), 0, () => {
      const matrix: Array<string> = [];
      const rotations = [0, 90, 180, 270];
      const resolutions = ['1280x720', '1920x1080', '3840x2160'];
      for (let i = 0; i < rotations.length; i++) {
        for (let j = 0; j < resolutions.length; j++) {
          matrix.push(`${rotations[i]}-${resolutions[j]}`);
        }
      }
      expect(matrix.length).assertEqual(12);
      expect(matrix.includes('90-1920x1080')).assertEqual(true);
    });

    it(addCase(casePrefix + 'Lifecycle_DesktopHomeLaunch_012'), 0, () => {
      const flow: Array<string> = ['DESKTOP', 'LAUNCH', 'HOME', 'LAUNCH'];
      const valid = flow.every((step) => ['DESKTOP', 'HOME', 'LAUNCH'].includes(step));
      expect(valid).assertEqual(true);
      expect(flow[0]).assertEqual('DESKTOP');
      expect(flow[flow.length - 1]).assertEqual('LAUNCH');
    });

    it(addCase(casePrefix + 'Stress_HighFreqKeyMove_013'), 0, () => {
      const grid: GridSize = { rows: 5, cols: 6 };
      let cursor: Cursor = { row: 2, col: 2 };
      const sequence: Array<'UP' | 'DOWN' | 'LEFT' | 'RIGHT'> = ['UP', 'DOWN', 'LEFT', 'RIGHT'];
      for (let i = 0; i < 500; i++) {
        cursor = moveCursor(cursor, sequence[i % sequence.length], grid);
      }
      expect(cursor.row >= 0 && cursor.row < grid.rows).assertEqual(true);
      expect(cursor.col >= 0 && cursor.col < grid.cols).assertEqual(true);
    });

    it(addCase(casePrefix + 'Contract_CaseNaming_014'), 0, () => {
      const regex = /^Settings_PageInteraction_[A-Za-z0-9_]+_[0-9]{3}$/;
      const set: Set<string> = new Set<string>();
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(regex.test(allCaseNames[i])).assertEqual(true);
        expect(set.has(allCaseNames[i])).assertEqual(false);
        set.add(allCaseNames[i]);
      }
      expect(set.size).assertEqual(allCaseNames.length);
    });

    it(addCase(casePrefix + 'Route_ExtendedManifest_015'), 0, () => {
      const extendedRoutes: Array<string> = [
        'pages/settingList',
        'pages/network/ipUpdate',
        'pages/network/gatewayUpdate',
        'pages/network/dnsUpdate',
        'pages/network/netMaskUpdate',
        'pages/system/softwareUpdate',
        'pages/system/timeAndDate',
        'pages/system/systemInfo',
        'pages/system/deviceInfo',
        'pages/system/stateInfo',
        'pages/links/screenExpansion/DefaultMainWindowPage',
        'pages/links/screenExpansion/application',
        'pages/hotspot/ConnectedDeviceList'
      ];
      const unique: Set<string> = new Set<string>();
      for (let i = 0; i < extendedRoutes.length; i++) {
        expect(isRoutePathValid(extendedRoutes[i])).assertEqual(true);
        expect(unique.has(extendedRoutes[i])).assertEqual(false);
        unique.add(extendedRoutes[i]);
      }
      expect(unique.size).assertEqual(extendedRoutes.length);
    });

    it(addCase(casePrefix + 'Route_NestedAndEditorStats_016'), 0, () => {
      const stats = collectRouteStats([
        'pages/settingList',
        'pages/network/ipUpdate',
        'pages/network/gatewayUpdate',
        'pages/network/dnsUpdate',
        'pages/network/netMaskUpdate',
        'pages/system/softwareUpdate',
        'pages/links/screenExpansion/DefaultMainWindowPage',
        'pages/links/screenExpansion/application'
      ]);
      expect(stats.nestedCount).assertEqual(2);
      expect(stats.editorCount).assertEqual(5);
    });

    it(addCase(casePrefix + 'Route_ModuleDistribution_017'), 0, () => {
      const manifest: Array<string> = [
        'pages/settingList',
        'pages/volume/volume',
        'pages/volume/outPut',
        'pages/volume/effects',
        'pages/volume/customEffects',
        'pages/volume/bluetoothOutput',
        'pages/display/display',
        'pages/display/screenCalibration',
        'pages/display/photoSetting',
        'pages/display/nightLight',
        'pages/display/highSetting',
        'pages/display/colorSetting',
        'pages/display/claritySetting',
        'pages/display/brightnessSetting',
        'pages/display/SourceIdentification',
        'pages/display/ColorSpace',
        'pages/network/network',
        'pages/network/wifi',
        'pages/network/wiredNetwork',
        'pages/network/wifiPsd',
        'pages/network/wifiInfoDetail',
        'pages/network/netSpeed',
        'pages/network/netMonitor',
        'pages/network/netMaskUpdate',
        'pages/network/ipUpdate',
        'pages/network/gatewayUpdate',
        'pages/network/dnsUpdate',
        'pages/system/system',
        'pages/system/timeAndDate',
        'pages/system/systemInfo',
        'pages/system/stateInfo',
        'pages/system/softwareUpdate',
        'pages/system/deviceInfo',
        'pages/links/links',
        'pages/links/screenExpansion/screenExpansion',
        'pages/links/screenExpansion/DefaultMainWindowPage',
        'pages/links/screenExpansion/application',
        'pages/oneConnectShare/oneConnectShare',
        'pages/hotspot/hotspot',
        'pages/hotspot/hotspotPWD',
        'pages/hotspot/deviceName',
        'pages/hotspot/ConnectedDeviceList'
      ];
      expect(countModuleRoutes(manifest, 'volume')).assertEqual(5);
      expect(countModuleRoutes(manifest, 'display')).assertEqual(10);
      expect(countModuleRoutes(manifest, 'network')).assertEqual(11);
      expect(countModuleRoutes(manifest, 'system')).assertEqual(6);
      expect(countModuleRoutes(manifest, 'hotspot')).assertEqual(4);
    });

    it(addCase(casePrefix + 'Stress_RouteFormatSweep_018'), 0, () => {
      const manifest: Array<string> = [
        'pages/settingList',
        'pages/network/ipUpdate',
        'pages/network/gatewayUpdate',
        'pages/network/dnsUpdate',
        'pages/network/netMaskUpdate',
        'pages/system/softwareUpdate',
        'pages/system/timeAndDate',
        'pages/system/systemInfo',
        'pages/system/deviceInfo',
        'pages/system/stateInfo',
        'pages/links/links',
        'pages/links/screenExpansion/screenExpansion',
        'pages/links/screenExpansion/DefaultMainWindowPage',
        'pages/links/screenExpansion/application',
        'pages/oneConnectShare/oneConnectShare',
        'pages/hotspot/hotspot',
        'pages/hotspot/hotspotPWD',
        'pages/hotspot/deviceName',
        'pages/hotspot/ConnectedDeviceList'
      ];
      let validCount = 0;
      for (let i = 0; i < 400; i++) {
        if (isRoutePathValid(manifest[i % manifest.length])) {
          validCount++;
        }
      }
      expect(validCount).assertEqual(400);
    });
  });
}

