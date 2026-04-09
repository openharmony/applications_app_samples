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

interface ReplayRouteScenario {
  name: string;
  path: string;
  valid: boolean;
  nested: boolean;
  editor: boolean;
}

const registeredRoutes: Set<string> = new Set<string>([
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
  'pages/network/netMonitor',
  'pages/network/netSpeed',
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
  'pages/hotspot/hotspot',
  'pages/hotspot/hotspotPWD',
  'pages/hotspot/deviceName',
  'pages/hotspot/ConnectedDeviceList',
  'pages/general/general',
  'pages/general/autoScreenOff',
  'pages/general/controllerCon',
  'pages/general/floatBall',
  'pages/general/HDMIIN',
  'pages/general/HDMIOUT',
  'pages/general/hdmi',
  'pages/general/ime',
  'pages/general/inputSource',
  'pages/general/pairGuidance',
  'pages/general/remoteController',
  'pages/general/ScreenRotation',
  'pages/general/standby',
  'pages/general/standbyMode',
  'pages/general/startupMode',
  'pages/general/USB',
  'pages/general/WatchTvKeyPage',
  'pages/oneConnectShare/oneConnectShare',
  'pages/bluetooth/bluetoothDeviceEntry'
]);

function isNested(path: string): boolean {
  return path.split('/').length > 3;
}

function isEditor(path: string): boolean {
  const routeName = path.substring(path.lastIndexOf('/') + 1);
  return routeName === 'netMaskUpdate' ||
    routeName === 'ipUpdate' ||
    routeName === 'gatewayUpdate' ||
    routeName === 'dnsUpdate' ||
    routeName === 'hotspotPWD';
}

function isValid(path: string): boolean {
  return registeredRoutes.has(path);
}

export default function MegaRouteManifestReplayMatrixTest() {
  const casePrefix = 'Settings_MegaRouteManifestReplay_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const scenarios: Array<ReplayRouteScenario> = [
    { name: 'replay_001', path: 'pages/settingList', valid: true, nested: false, editor: false },
    { name: 'replay_002', path: 'pages/volume/volume', valid: true, nested: false, editor: false },
    { name: 'replay_003', path: 'pages/volume/outPut', valid: true, nested: false, editor: false },
    { name: 'replay_004', path: 'pages/volume/effects', valid: true, nested: false, editor: false },
    { name: 'replay_005', path: 'pages/volume/customizesounds', valid: false, nested: false, editor: false },
    { name: 'replay_006', path: 'pages/volume/customEffects', valid: true, nested: false, editor: false },
    { name: 'replay_007', path: 'pages/volume/bluetoothOutput', valid: true, nested: false, editor: false },
    { name: 'replay_008', path: 'pages/display/display', valid: true, nested: false, editor: false },
    { name: 'replay_009', path: 'pages/display/screenCalibration', valid: true, nested: false, editor: false },
    { name: 'replay_010', path: 'pages/display/photoSetting', valid: true, nested: false, editor: false },
    { name: 'replay_011', path: 'pages/display/nightLight', valid: true, nested: false, editor: false },
    { name: 'replay_012', path: 'pages/display/highSetting', valid: true, nested: false, editor: false },
    { name: 'replay_013', path: 'pages/display/colorSetting', valid: true, nested: false, editor: false },
    { name: 'replay_014', path: 'pages/display/claritySetting', valid: true, nested: false, editor: false },
    { name: 'replay_015', path: 'pages/display/brightnessSetting', valid: true, nested: false, editor: false },
    { name: 'replay_016', path: 'pages/display/SourceIdentification', valid: true, nested: false, editor: false },
    { name: 'replay_017', path: 'pages/display/ColorSpace', valid: true, nested: false, editor: false },
    { name: 'replay_018', path: 'pages/network/network', valid: true, nested: false, editor: false },
    { name: 'replay_019', path: 'pages/network/wifi', valid: true, nested: false, editor: false },
    { name: 'replay_020', path: 'pages/network/wiredNetwork', valid: true, nested: false, editor: false },
    { name: 'replay_021', path: 'pages/network/wifiPsd', valid: true, nested: false, editor: false },
    { name: 'replay_022', path: 'pages/network/wifiInfoDetail', valid: true, nested: false, editor: false },
    { name: 'replay_023', path: 'pages/network/netMonitor', valid: true, nested: false, editor: false },
    { name: 'replay_024', path: 'pages/network/netSpeed', valid: true, nested: false, editor: false },
    { name: 'replay_025', path: 'pages/network/netMaskUpdate', valid: true, nested: false, editor: true },
    { name: 'replay_026', path: 'pages/network/ipUpdate', valid: true, nested: false, editor: true },
    { name: 'replay_027', path: 'pages/network/gatewayUpdate', valid: true, nested: false, editor: true },
    { name: 'replay_028', path: 'pages/network/dnsUpdate', valid: true, nested: false, editor: true },
    { name: 'replay_029', path: 'pages/system/system', valid: true, nested: false, editor: false },
    { name: 'replay_030', path: 'pages/system/timeAndDate', valid: true, nested: false, editor: false },
    { name: 'replay_031', path: 'pages/system/systemInfo', valid: true, nested: false, editor: false },
    { name: 'replay_032', path: 'pages/system/stateInfo', valid: true, nested: false, editor: false },
    { name: 'replay_033', path: 'pages/system/softwareUpdate', valid: true, nested: false, editor: false },
    { name: 'replay_034', path: 'pages/system/deviceInfo', valid: true, nested: false, editor: false },
    { name: 'replay_035', path: 'pages/links/links', valid: true, nested: false, editor: false },
    { name: 'replay_036', path: 'pages/links/screenExpansion/screenExpansion', valid: true, nested: true, editor: false },
    { name: 'replay_037', path: 'pages/links/screenExpansion/DefaultMainWindowPage', valid: true, nested: true, editor: false },
    { name: 'replay_038', path: 'pages/links/screenExpansion/application', valid: true, nested: true, editor: false },
    { name: 'replay_039', path: 'pages/hotspot/hotspot', valid: true, nested: false, editor: false },
    { name: 'replay_040', path: 'pages/hotspot/hotspotPWD', valid: true, nested: false, editor: true },
    { name: 'replay_041', path: 'pages/hotspot/deviceName', valid: true, nested: false, editor: false },
    { name: 'replay_042', path: 'pages/hotspot/ConnectedDeviceList', valid: true, nested: false, editor: false },
    { name: 'replay_043', path: 'pages/general/general', valid: true, nested: false, editor: false },
    { name: 'replay_044', path: 'pages/general/autoScreenOff', valid: true, nested: false, editor: false },
    { name: 'replay_045', path: 'pages/general/controllerCon', valid: true, nested: false, editor: false },
    { name: 'replay_046', path: 'pages/general/floatBall', valid: true, nested: false, editor: false },
    { name: 'replay_047', path: 'pages/general/HDMIIN', valid: true, nested: false, editor: false },
    { name: 'replay_048', path: 'pages/general/HDMIOUT', valid: true, nested: false, editor: false },
    { name: 'replay_049', path: 'pages/general/hdmi', valid: true, nested: false, editor: false },
    { name: 'replay_050', path: 'pages/general/ime', valid: true, nested: false, editor: false }
  ];

  describe('MegaRouteManifestReplayMatrixSuite', () => {
    it(addCase(casePrefix + 'RouteReplay_001'), 0, () => {
      for (let i = 0; i < scenarios.length; i++) {
        const item = scenarios[i];
        expect(isValid(item.path)).assertEqual(item.valid);
        expect(isNested(item.path)).assertEqual(item.nested);
        expect(isEditor(item.path)).assertEqual(item.editor);
      }
    });

    it(addCase(casePrefix + 'RouteReplayStress_002'), 0, () => {
      let okCount = 0;
      for (let i = 0; i < 1000; i++) {
        const item = scenarios[i % scenarios.length];
        if (isValid(item.path) === item.valid && isNested(item.path) === item.nested && isEditor(item.path) === item.editor) {
          okCount++;
        }
      }
      expect(okCount).assertEqual(1000);
    });

    it(addCase(casePrefix + 'CaseNaming_003'), 0, () => {
      const regex = /^Settings_MegaRouteManifestReplay_[A-Za-z0-9_]+_[0-9]{3}$/;
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

