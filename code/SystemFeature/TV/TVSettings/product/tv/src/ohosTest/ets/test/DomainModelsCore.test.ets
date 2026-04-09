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
import wifiManager from '@ohos.wifiManager';
import { ApScanResult } from '../../../main/ets/model/wifiImpl/WifiModel';
import BluetoothDevice from '../../../main/ets/model/bluetoothImpl/BluetoothDevice';
import { ProfileConnectionState } from '../../../main/ets/model/bluetoothImpl/BluetoothModel';
import LinkDevice from '../../../main/ets/model/linkImpl/linkDevice';

interface DeviceConfigLike {
  ssid: string;
  bssid: string;
  securityType: number;
}

function buildAp(ssid: string, rssi: number, securityType: number): ApScanResult {
  return new ApScanResult({
    ssid,
    bssid: `${ssid}_bssid`,
    rssi,
    band: 1,
    frequency: 2412,
    timestamp: 1,
    securityType
  });
}

export default function DomainModelsCoreTest() {
  const casePrefix = 'Settings_DomainModelCore_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('DomainModelsCoreTestSuite', () => {
    it(addCase(casePrefix + 'ApScanResult_DefaultCtor_001'), 0, () => {
      const ap = new ApScanResult();
      expect(ap.getApInfo().ssid).assertEqual('');
      expect(ap.getApInfo().rssi).assertEqual(-100);
      expect(ap.isSavedConfig()).assertEqual(false);
      expect(ap.isConnected()).assertEqual(false);
    });

    it(addCase(casePrefix + 'ApScanResult_FromDeviceConfig_002'), 0, () => {
      const cfg: DeviceConfigLike = {
        ssid: 'HomeWifi',
        bssid: 'AA:BB:CC:DD:EE:FF',
        securityType: 3
      };
      const ap = ApScanResult.fromDeviceConfig(cfg as wifiManager.WifiDeviceConfig);
      expect(ap.getApInfo().ssid).assertEqual('HomeWifi');
      expect(ap.getApInfo().bssid).assertEqual('AA:BB:CC:DD:EE:FF');
      expect(ap.getApInfo().securityType).assertEqual(3);
    });

    it(addCase(casePrefix + 'ApScanResult_ConnectionStatus_003'), 0, () => {
      const ap = buildAp('Cafe', -45, 3);
      ap.updateConnectStatus(wifiManager.ConnState.CONNECTED);
      expect(ap.isConnected()).assertEqual(true);
      ap.updateConnectStatus(wifiManager.ConnState.CONNECTING);
      expect(ap.isConnected()).assertEqual(false);
    });

    it(addCase(casePrefix + 'ApScanResult_SavedStatus_004'), 0, () => {
      const ap = buildAp('Office', -50, 3);
      expect(ap.isSavedConfig()).assertEqual(false);
      ap.updateSavedStatus(true);
      expect(ap.isSavedConfig()).assertEqual(true);
      ap.updateSavedStatus(false);
      expect(ap.isSavedConfig()).assertEqual(false);
    });

    it(addCase(casePrefix + 'ApScanResult_SecurityRule_005'), 0, () => {
      const openAp = buildAp('OpenNet', -55, 1);
      const encryptAp = buildAp('SecureNet', -55, 4);
      expect(openAp.isSecurityAp()).assertEqual(false);
      expect(encryptAp.isSecurityAp()).assertEqual(true);
    });

    it(addCase(casePrefix + 'ApScanResult_ValidRule_006'), 0, () => {
      const ap = buildAp('LabNet', -40, 2);
      expect(ap.isValidAp()).assertEqual(true);
      const emptySsid = buildAp('', -40, 2);
      expect(emptySsid.isValidAp()).assertEqual(false);
    });

    it(addCase(casePrefix + 'ApScanResult_ValidRule_ZeroSignal_007'), 0, () => {
      const ap = buildAp('WeakNet', -200, 2);
      expect(ap.isValidAp()).assertEqual(false);
    });

    it(addCase(casePrefix + 'ApScanResult_CompareOrder_008'), 0, () => {
      const strong = buildAp('Strong', -40, 2);
      const weak = buildAp('Weak', -80, 2);
      const same = buildAp('Same', -40, 2);
      expect(ApScanResult.compare(strong, weak) < 0).assertEqual(true);
      expect(ApScanResult.compare(weak, strong) > 0).assertEqual(true);
      expect(ApScanResult.compare(strong, same)).assertEqual(0);
    });

    it(addCase(casePrefix + 'ApScanResult_FilterBySsid_009'), 0, () => {
      const ap1 = buildAp('dup', -40, 2);
      const ap2 = buildAp('unique', -50, 2);
      const ap3 = buildAp('dup', -60, 2);
      const filtered = ApScanResult.filter([ap1, ap2, ap3]);
      expect(filtered.length).assertEqual(2);
      expect(filtered[0].getApInfo().ssid).assertEqual('dup');
      expect(filtered[1].getApInfo().ssid).assertEqual('unique');
    });

    it(addCase(casePrefix + 'ApScanResult_IndexBySsid_010'), 0, () => {
      const ap1 = buildAp('a', -40, 2);
      const ap2 = buildAp('b', -50, 2);
      const ap3 = buildAp('c', -60, 2);
      expect(ApScanResult.index([ap1, ap2, ap3], ap2)).assertEqual(1);
      expect(ApScanResult.index([ap1, ap2, ap3], buildAp('x', -10, 2))).assertEqual(-1);
    });

    it(addCase(casePrefix + 'ApScanResult_ToStringContract_011'), 0, () => {
      const ap = buildAp('DisplayNet', -42, 2);
      ap.updateConnectStatus(wifiManager.ConnState.CONNECTED);
      const text = ap.toString();
      expect(text.includes('ssid=DisplayNet')).assertEqual(true);
      expect(text.includes('signal=')).assertEqual(true);
      expect(text.includes('isConnected=true')).assertEqual(true);
    });

    it(addCase(casePrefix + 'BluetoothDevice_SetProfileIgnoreMismatch_012'), 0, () => {
      const device = new BluetoothDevice();
      device.deviceId = 'dev_1';
      device.setProfile({
        profileId: 1,
        deviceId: 'dev_2',
        profileConnectionState: ProfileConnectionState.STATE_CONNECTED
      });
      expect(device.profiles.size).assertEqual(0);
      expect(device.connectionState).assertEqual(0);
    });

    it(addCase(casePrefix + 'BluetoothDevice_ConnectedPriority_013'), 0, () => {
      const device = new BluetoothDevice();
      device.deviceId = 'd1';
      device.setProfile({
        profileId: 11,
        deviceId: 'd1',
        profileConnectionState: ProfileConnectionState.STATE_CONNECTING
      });
      device.setProfile({
        profileId: 12,
        deviceId: 'd1',
        profileConnectionState: ProfileConnectionState.STATE_CONNECTED
      });
      expect(device.profiles.size).assertEqual(2);
      expect(device.connectionState).assertEqual(ProfileConnectionState.STATE_CONNECTED);
    });

    it(addCase(casePrefix + 'BluetoothDevice_DisconnectingPriority_014'), 0, () => {
      const device = new BluetoothDevice();
      device.deviceId = 'd2';
      device.setProfile({
        profileId: 21,
        deviceId: 'd2',
        profileConnectionState: ProfileConnectionState.STATE_DISCONNECTING
      });
      device.setProfile({
        profileId: 22,
        deviceId: 'd2',
        profileConnectionState: ProfileConnectionState.STATE_DISCONNECTED
      });
      expect(device.connectionState).assertEqual(ProfileConnectionState.STATE_CONNECTED);
    });

    it(addCase(casePrefix + 'BluetoothDevice_ConnectingWhenNoConnected_015'), 0, () => {
      const device = new BluetoothDevice();
      device.deviceId = 'd3';
      device.setProfile({
        profileId: 31,
        deviceId: 'd3',
        profileConnectionState: ProfileConnectionState.STATE_CONNECTING
      });
      device.setProfile({
        profileId: 32,
        deviceId: 'd3',
        profileConnectionState: ProfileConnectionState.STATE_DISCONNECTED
      });
      expect(device.connectionState).assertEqual(ProfileConnectionState.STATE_CONNECTING);
    });

    it(addCase(casePrefix + 'BluetoothDevice_AllDisconnected_016'), 0, () => {
      const device = new BluetoothDevice();
      device.deviceId = 'd4';
      device.setProfile({
        profileId: 41,
        deviceId: 'd4',
        profileConnectionState: ProfileConnectionState.STATE_DISCONNECTED
      });
      device.setProfile({
        profileId: 42,
        deviceId: 'd4',
        profileConnectionState: ProfileConnectionState.STATE_DISCONNECTED
      });
      expect(device.connectionState).assertEqual(ProfileConnectionState.STATE_DISCONNECTED);
    });

    it(addCase(casePrefix + 'BluetoothDevice_SetProfilesBatch_017'), 0, () => {
      const device = new BluetoothDevice();
      device.deviceId = 'batch_1';
      device.setProfiles([
        { profileId: 100, profileConnectionState: ProfileConnectionState.STATE_CONNECTING },
        { profileId: 101, profileConnectionState: ProfileConnectionState.STATE_CONNECTED },
        { profileId: 102, profileConnectionState: ProfileConnectionState.STATE_DISCONNECTED }
      ]);
      expect(device.profiles.size).assertEqual(3);
      expect(device.connectionState).assertEqual(ProfileConnectionState.STATE_CONNECTED);
    });

    it(addCase(casePrefix + 'BluetoothDevice_ProfileOverwrite_018'), 0, () => {
      const device = new BluetoothDevice();
      device.deviceId = 'overwrite_1';
      device.setProfile({
        profileId: 200,
        deviceId: 'overwrite_1',
        profileConnectionState: ProfileConnectionState.STATE_CONNECTING
      });
      device.setProfile({
        profileId: 200,
        deviceId: 'overwrite_1',
        profileConnectionState: ProfileConnectionState.STATE_DISCONNECTED
      });
      expect(device.profiles.size).assertEqual(1);
      expect(device.connectionState).assertEqual(ProfileConnectionState.STATE_DISCONNECTED);
    });

    it(addCase(casePrefix + 'LinkDevice_DefaultContract_019'), 0, () => {
      const link = new LinkDevice();
      expect(link.deviceName).assertEqual('');
      expect(link.deviceId).assertEqual('');
      link.deviceName = 'LivingRoomTV';
      link.deviceId = 'dev-998';
      expect(link.deviceName).assertEqual('LivingRoomTV');
      expect(link.deviceId).assertEqual('dev-998');
    });

    it(addCase(casePrefix + 'Contract_CaseNaming_020'), 0, () => {
      const regex = /^Settings_DomainModelCore_[A-Za-z0-9_]+_[0-9]{3}$/;
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

