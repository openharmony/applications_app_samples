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
  'pages/SettingList',
  'pages/volume/Volume',
  'pages/volume/OutPut',
  'pages/volume/Effects',
  'pages/volume/CustomEffects',
  'pages/volume/BluetoothOutput',
  'pages/display/Display',
  'pages/display/ScreenCalibration',
  'pages/display/PhotoSetting',
  'pages/display/NightLight',
  'pages/display/HighSetting',
  'pages/display/ColorSetting',
  'pages/display/ClaritySetting',
  'pages/display/BrightnessSetting',
  'pages/display/SourceIdentification',
  'pages/display/ColorSpace',
  'pages/network/Network',
  'pages/network/Wifi',
  'pages/network/WiredNetwork',
  'pages/network/WifiPsd',
  'pages/network/WifiInfoDetail',
  'pages/network/NetMonitor',
  'pages/network/NetSpeed',
  'pages/network/NetMaskUpdate',
  'pages/network/IpUpdate',
  'pages/network/GatewayUpdate',
  'pages/network/DnsUpdate',
  'pages/system/System',
  'pages/system/TimeAndDate',
  'pages/system/SystemInfo',
  'pages/system/StateInfo',
  'pages/system/SoftwareUpdate',
  'pages/system/DeviceInfo',
  'pages/links/Links',
  'pages/links/screenExpansion/ScreenExpansion',
  'pages/links/screenExpansion/DefaultMainWindowPage',
  'pages/links/screenExpansion/Application',
  'pages/hotspot/Hotspot',
  'pages/hotspot/HotspotPWD',
  'pages/hotspot/DeviceName',
  'pages/hotspot/ConnectedDeviceList',
  'pages/general/General',
  'pages/general/AutoScreenOff',
  'pages/general/ControllerCon',
  'pages/general/FloatBall',
  'pages/general/HDMIIN',
  'pages/general/HDMIOUT',
  'pages/general/Hdmi',
  'pages/general/Ime',
  'pages/general/InputSource',
  'pages/general/PairGuidance',
  'pages/general/RemoteController',
  'pages/general/ScreenRotation',
  'pages/general/Standby',
  'pages/general/StandbyMode',
  'pages/general/StartupMode',
  'pages/general/USB',
  'pages/general/WatchTvKeyPage',
  'pages/oneConnectShare/OneConnectShare',
  'pages/bluetooth/BluetoothDeviceEntry'
]);

function isNested(path: string): boolean {
  return path.split('/').length > 3;
}

function isEditor(path: string): boolean {
  const routeName = path.substring(path.lastIndexOf('/') + 1).toLowerCase();
  return routeName === 'netmaskupdate' ||
    routeName === 'ipupdate' ||
    routeName === 'gatewayupdate' ||
    routeName === 'dnsupdate' ||
    routeName === 'hotspotpwd';
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
    { name: 'replay_001', path: 'pages/SettingList', valid: true, nested: false, editor: false },
    { name: 'replay_002', path: 'pages/volume/Volume', valid: true, nested: false, editor: false },
    { name: 'replay_003', path: 'pages/volume/OutPut', valid: true, nested: false, editor: false },
    { name: 'replay_004', path: 'pages/volume/Effects', valid: true, nested: false, editor: false },
    { name: 'replay_005', path: 'pages/volume/Customizesounds', valid: false, nested: false, editor: false },
    { name: 'replay_006', path: 'pages/volume/CustomEffects', valid: true, nested: false, editor: false },
    { name: 'replay_007', path: 'pages/volume/BluetoothOutput', valid: true, nested: false, editor: false },
    { name: 'replay_008', path: 'pages/display/Display', valid: true, nested: false, editor: false },
    { name: 'replay_009', path: 'pages/display/ScreenCalibration', valid: true, nested: false, editor: false },
    { name: 'replay_010', path: 'pages/display/PhotoSetting', valid: true, nested: false, editor: false },
    { name: 'replay_011', path: 'pages/display/NightLight', valid: true, nested: false, editor: false },
    { name: 'replay_012', path: 'pages/display/HighSetting', valid: true, nested: false, editor: false },
    { name: 'replay_013', path: 'pages/display/ColorSetting', valid: true, nested: false, editor: false },
    { name: 'replay_014', path: 'pages/display/ClaritySetting', valid: true, nested: false, editor: false },
    { name: 'replay_015', path: 'pages/display/BrightnessSetting', valid: true, nested: false, editor: false },
    { name: 'replay_016', path: 'pages/display/SourceIdentification', valid: true, nested: false, editor: false },
    { name: 'replay_017', path: 'pages/display/ColorSpace', valid: true, nested: false, editor: false },
    { name: 'replay_018', path: 'pages/network/Network', valid: true, nested: false, editor: false },
    { name: 'replay_019', path: 'pages/network/Wifi', valid: true, nested: false, editor: false },
    { name: 'replay_020', path: 'pages/network/WiredNetwork', valid: true, nested: false, editor: false },
    { name: 'replay_021', path: 'pages/network/WifiPsd', valid: true, nested: false, editor: true },
    { name: 'replay_022', path: 'pages/network/WifiInfoDetail', valid: true, nested: false, editor: false },
    { name: 'replay_023', path: 'pages/network/NetMonitor', valid: true, nested: false, editor: false },
    { name: 'replay_024', path: 'pages/network/NetSpeed', valid: true, nested: false, editor: false },
    { name: 'replay_025', path: 'pages/network/NetMaskUpdate', valid: true, nested: false, editor: true },
    { name: 'replay_026', path: 'pages/network/IpUpdate', valid: true, nested: false, editor: true },
    { name: 'replay_027', path: 'pages/network/GatewayUpdate', valid: true, nested: false, editor: true },
    { name: 'replay_028', path: 'pages/network/DnsUpdate', valid: true, nested: false, editor: true },
    { name: 'replay_029', path: 'pages/system/System', valid: true, nested: false, editor: false },
    { name: 'replay_030', path: 'pages/system/TimeAndDate', valid: true, nested: false, editor: false },
    { name: 'replay_031', path: 'pages/system/SystemInfo', valid: true, nested: false, editor: false },
    { name: 'replay_032', path: 'pages/system/StateInfo', valid: true, nested: false, editor: false },
    { name: 'replay_033', path: 'pages/system/SoftwareUpdate', valid: true, nested: false, editor: false },
    { name: 'replay_034', path: 'pages/system/DeviceInfo', valid: true, nested: false, editor: false },
    { name: 'replay_035', path: 'pages/links/Links', valid: true, nested: false, editor: false },
    { name: 'replay_036', path: 'pages/links/screenExpansion/ScreenExpansion', valid: true, nested: true, editor: false },
    { name: 'replay_037', path: 'pages/links/screenExpansion/DefaultMainWindowPage', valid: true, nested: true, editor: false },
    { name: 'replay_038', path: 'pages/links/screenExpansion/Application', valid: true, nested: true, editor: false },
    { name: 'replay_039', path: 'pages/hotspot/Hotspot', valid: true, nested: false, editor: false },
    { name: 'replay_040', path: 'pages/hotspot/HotspotPWD', valid: true, nested: false, editor: true },
    { name: 'replay_041', path: 'pages/hotspot/DeviceName', valid: true, nested: false, editor: false },
    { name: 'replay_042', path: 'pages/hotspot/ConnectedDeviceList', valid: true, nested: false, editor: false },
    { name: 'replay_043', path: 'pages/general/General', valid: true, nested: false, editor: false },
    { name: 'replay_044', path: 'pages/general/AutoScreenOff', valid: true, nested: false, editor: false },
    { name: 'replay_045', path: 'pages/general/ControllerCon', valid: true, nested: false, editor: false },
    { name: 'replay_046', path: 'pages/general/FloatBall', valid: true, nested: false, editor: false },
    { name: 'replay_047', path: 'pages/general/HDMIIN', valid: true, nested: false, editor: false },
    { name: 'replay_048', path: 'pages/general/HDMIOUT', valid: true, nested: false, editor: false },
    { name: 'replay_049', path: 'pages/general/Hdmi', valid: true, nested: false, editor: false },
    { name: 'replay_050', path: 'pages/general/Ime', valid: true, nested: false, editor: false }
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

