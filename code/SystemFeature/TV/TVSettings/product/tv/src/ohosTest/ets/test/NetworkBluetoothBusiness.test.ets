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
import BluetoothDevice from '../../../main/ets/model/bluetoothImpl/BluetoothDevice';
import { DeviceType, ProfileConnectionState } from '../../../main/ets/model/bluetoothImpl/BluetoothModel';
import { getDeviceIconPath } from '../../../main/ets/pages/bluetooth/BluetoothDeviceEntry';

interface RouteItem {
  name: string;
  pageUrl: string;
}

interface RouteDecision {
  allow: boolean;
  params: RouteParams | null;
}

interface WifiApInfo {
  ssid: string;
  bssid: string;
  rssi: number;
  band: number;
  frequency: number;
  timestamp: number;
  securityType: number;
}

interface ConnectedWifiSnapshot {
  settingTitle: string;
  settingArrow: string;
  apInfo: WifiApInfo;
}

interface RouteParams {
  isWifiEnable: boolean;
}

interface BluetoothOutputItem {
  id: string;
  selected: boolean;
}

interface BluetoothOutputFallback {
  output: string;
  outputId: string;
}

interface EthernetState {
  isEnable: boolean;
  linkWifiOff: boolean;
  wifiItemEnabled: boolean;
  wiredItemEnabled: boolean;
}

function decideNetworkRoute(item: RouteItem, enableEthernet: boolean, isWifiEnable: boolean): RouteDecision {
  if (item.name === '有线网络' && !enableEthernet) {
    return { allow: false, params: null };
  }
  if (item.name === '无线网络' && enableEthernet) {
    return { allow: false, params: null };
  }
  if (item.name === '网络检测') {
    return { allow: true, params: { isWifiEnable } };
  }
  if (item.name === '个人热点') {
    return { allow: true, params: null };
  }
  return { allow: true, params: null };
}

function mapConnectedBluetoothToOutputList(devices: Array<BluetoothDevice>, outputId: string): Array<BluetoothOutputItem> {
  return devices
    .filter((item) => item.connectionState === ProfileConnectionState.STATE_CONNECTED)
    .map((item) => {
      const nextItem: BluetoothOutputItem = {
        id: item.deviceId,
        selected: item.deviceId === outputId
      };
      return nextItem;
    });
}

function getBluetoothOutputStorageFallback(listLength: number): BluetoothOutputFallback {
  if (listLength <= 0) {
    return { output: '', outputId: '' };
  }
  return { output: 'KEEP', outputId: 'KEEP' };
}

function composeWifiArrowPath(signalLevel: number, securityType: number): string {
  const lockPrefix = securityType === 1 ? '' : 'lock_';
  return `/res/image/ic_wifi_${lockPrefix}signal_${signalLevel}_dark.svg`;
}

function buildEmptyConnectedWifiSnapshot(): ConnectedWifiSnapshot {
  const apInfo: WifiApInfo = {
    ssid: '',
    bssid: '',
    rssi: 0,
    band: 0,
    frequency: 0,
    timestamp: 0,
    securityType: 0
  };
  const snapshot: ConnectedWifiSnapshot = {
    settingTitle: '',
    settingArrow: '',
    apInfo
  };
  return snapshot;
}

function deriveEthernetState(activeIfaces: Array<string>): EthernetState {
  if (activeIfaces.length === 0) {
    return {
      isEnable: false,
      linkWifiOff: true,
      wifiItemEnabled: true,
      wiredItemEnabled: false
    };
  }
  return {
    isEnable: true,
    linkWifiOff: false,
    wifiItemEnabled: false,
    wiredItemEnabled: true
  };
}

function isWifiBearer(bearerTypes: Array<number>, wifiBearerConst: number): boolean {
  return bearerTypes.includes(wifiBearerConst);
}

export default function NetworkBluetoothBusinessTest() {
  const casePrefix = 'Settings_NetworkBluetooth_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('NetworkBluetoothBusinessSuite', () => {
    it(addCase(casePrefix + 'BluetoothIconPath_Mapping_001'), 0, () => {
      expect(getDeviceIconPath(DeviceType.HEADPHONE)).assertEqual('/res/image/ic_device_earphone_hero.svg');
      expect(getDeviceIconPath(DeviceType.PHONE)).assertEqual('/res/image/ic_public_devices_phone.svg');
      expect(getDeviceIconPath(DeviceType.WATCH)).assertEqual('/res/image/ic_device_watch.svg');
      expect(getDeviceIconPath(DeviceType.COMPUTER)).assertEqual('/res/image/ic_device_matebook.svg');
    });

    it(addCase(casePrefix + 'BluetoothIconPath_Default_002'), 0, () => {
      expect(getDeviceIconPath(DeviceType.BLUETOOTH)).assertEqual('/res/image/ic_bluetooth_device.svg');
      expect(getDeviceIconPath('unknown_type')).assertEqual('/res/image/ic_bluetooth_device.svg');
    });

    it(addCase(casePrefix + 'BluetoothOutput_FilterConnected_003'), 0, () => {
      const a = new BluetoothDevice();
      const b = new BluetoothDevice();
      const c = new BluetoothDevice();
      a.deviceId = 'a';
      b.deviceId = 'b';
      c.deviceId = 'c';
      a.connectionState = ProfileConnectionState.STATE_CONNECTED;
      b.connectionState = ProfileConnectionState.STATE_CONNECTING;
      c.connectionState = ProfileConnectionState.STATE_CONNECTED;
      const mapped = mapConnectedBluetoothToOutputList([a, b, c], 'c');
      expect(mapped.length).assertEqual(2);
      expect(mapped[0].id).assertEqual('a');
      expect(mapped[0].selected).assertEqual(false);
      expect(mapped[1].id).assertEqual('c');
      expect(mapped[1].selected).assertEqual(true);
    });

    it(addCase(casePrefix + 'BluetoothOutput_ClearStorageWhenEmpty_004'), 0, () => {
      const ret = getBluetoothOutputStorageFallback(0);
      expect(ret.output).assertEqual('');
      expect(ret.outputId).assertEqual('');
    });

    it(addCase(casePrefix + 'BluetoothOutput_KeepStorageWhenNonEmpty_005'), 0, () => {
      const ret = getBluetoothOutputStorageFallback(2);
      expect(ret.output).assertEqual('KEEP');
      expect(ret.outputId).assertEqual('KEEP');
    });

    it(addCase(casePrefix + 'NetworkRoute_WiredBlockedIfDisabled_006'), 0, () => {
      const dec = decideNetworkRoute({ name: '有线网络', pageUrl: 'pages/network/WiredNetwork' }, false, false);
      expect(dec.allow).assertEqual(false);
      expect(dec.params === null).assertEqual(true);
    });

    it(addCase(casePrefix + 'NetworkRoute_WirelessBlockedWhenEthernetOn_007'), 0, () => {
      const dec = decideNetworkRoute({ name: '无线网络', pageUrl: 'pages/network/Wifi' }, true, false);
      expect(dec.allow).assertEqual(false);
      expect(dec.params === null).assertEqual(true);
    });

    it(addCase(casePrefix + 'NetworkRoute_MonitorWithParam_008'), 0, () => {
      const dec = decideNetworkRoute({ name: '网络检测', pageUrl: 'pages/network/NetMonitor' }, true, true);
      expect(dec.allow).assertEqual(true);
      expect(dec.params !== null).assertEqual(true);
      if (dec.params !== null) {
        expect(dec.params.isWifiEnable).assertEqual(true);
      }
    });

    it(addCase(casePrefix + 'NetworkRoute_HotspotAllowed_009'), 0, () => {
      const dec = decideNetworkRoute({ name: '个人热点', pageUrl: 'pages/hotspot/Hotspot' }, false, false);
      expect(dec.allow).assertEqual(true);
      expect(dec.params === null).assertEqual(true);
    });

    it(addCase(casePrefix + 'NetworkRoute_NormalAllowed_010'), 0, () => {
      const dec = decideNetworkRoute({ name: '网络测速', pageUrl: 'pages/network/NetSpeed' }, true, false);
      expect(dec.allow).assertEqual(true);
      expect(dec.params === null).assertEqual(true);
    });

    it(addCase(casePrefix + 'WifiArrowPath_OpenNetwork_011'), 0, () => {
      const icon = composeWifiArrowPath(3, 1);
      expect(icon).assertEqual('/res/image/ic_wifi_signal_3_dark.svg');
    });

    it(addCase(casePrefix + 'WifiArrowPath_LockedNetwork_012'), 0, () => {
      const icon = composeWifiArrowPath(2, 2);
      expect(icon).assertEqual('/res/image/ic_wifi_lock_signal_2_dark.svg');
    });

    it(addCase(casePrefix + 'WifiSnapshot_EmptyFallback_013'), 0, () => {
      const snapshot = buildEmptyConnectedWifiSnapshot();
      expect(snapshot.settingTitle).assertEqual('');
      expect(snapshot.settingArrow).assertEqual('');
      expect(snapshot.apInfo.ssid).assertEqual('');
      expect(snapshot.apInfo.securityType).assertEqual(0);
    });

    it(addCase(casePrefix + 'EthernetState_NoIface_014'), 0, () => {
      const state = deriveEthernetState([]);
      expect(state.isEnable).assertEqual(false);
      expect(state.linkWifiOff).assertEqual(true);
      expect(state.wifiItemEnabled).assertEqual(true);
      expect(state.wiredItemEnabled).assertEqual(false);
    });

    it(addCase(casePrefix + 'EthernetState_WithIface_015'), 0, () => {
      const state = deriveEthernetState(['eth0']);
      expect(state.isEnable).assertEqual(true);
      expect(state.linkWifiOff).assertEqual(false);
      expect(state.wifiItemEnabled).assertEqual(false);
      expect(state.wiredItemEnabled).assertEqual(true);
    });

    it(addCase(casePrefix + 'NetCapabilities_WifiBearer_016'), 0, () => {
      const WIFI = 1;
      expect(isWifiBearer([0, 1, 3], WIFI)).assertEqual(true);
      expect(isWifiBearer([0, 3], WIFI)).assertEqual(false);
    });

    it(addCase(casePrefix + 'Stress_NetworkRouteDecision_017'), 0, () => {
      let allowedCount = 0;
      const names = ['有线网络', '无线网络', '网络检测', '个人热点', '网络测速'];
      for (let i = 0; i < 200; i++) {
        const itemName = names[i % names.length];
        const dec = decideNetworkRoute({ name: itemName, pageUrl: 'pages/any/any' }, i % 2 === 0, i % 3 === 0);
        if (dec.allow) {
          allowedCount++;
        }
      }
      expect(allowedCount > 0).assertEqual(true);
      expect(allowedCount < 200).assertEqual(true);
    });

    it(addCase(casePrefix + 'Contract_CaseNaming_018'), 0, () => {
      const regex = /^Settings_NetworkBluetooth_[A-Za-z0-9_]+_[0-9]{3}$/;
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

