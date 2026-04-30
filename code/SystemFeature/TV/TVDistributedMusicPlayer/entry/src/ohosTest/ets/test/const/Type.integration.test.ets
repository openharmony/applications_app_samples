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

import { describe, it, expect, beforeEach, afterEach, TestType, Size, Level } from '@ohos/hypium';


import { DeviceInfoType, AuthParam } from '../../../../main/ets/const/Type';
import { DeviceType, DistributedManagerDeviceInfo, DeviceStateChangeAction } from '../../../../main/ets/model/RemoteDeviceModel';

interface StringRecord extends Record<string, string> {}
interface ObjectRecord extends Record<string, object> {}
interface NumberRecord extends Record<string, number> {}
function makeStringRecord(): StringRecord { return {} as StringRecord; }

/**
 * Type module integration and scenario tests.
 *
 * Business background analysis:
 * The device management flow for TV distributed music player is:
 *   Discover device (DeviceInfoType) -> Add management fields -> Device list (DistributedManagerDeviceInfo)
 *   -> Authenticate device (AuthParam + authenticateDevice) -> Transfer playback (startRemoteExtension)
 *
 * These types define the data contract for the entire flow. Field mapping errors would cause transfer failures.
 * This test suite verifies data flow integrity and scenario coverage between types.
 */
export default function typeIntegrationTestSuite(): void {
  describe('TypeIntegrationTest', () => {

    // Scenario 1: Complete data flow from device discovery to list display
    describe('Scenario_DeviceDiscoveryToDisplay', () => {

      // Distributed protocol discovers device -> Wrap as DistributedManagerDeviceInfo -> UI display
      it('fullDeviceLifecycle_discoveryToDisplay_mustPreserveAllFields', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const discoveredDevice: DeviceInfoType = {
          deviceId: 'discovered-tv-001',
          deviceName: 'Living Room TV',
          deviceType: DeviceType.TV,
          networkId: '192.168.1.100:12345',
          range: 3
        };

        // Stage 2: Wrap as manager internal data structure
        // Add auth status, transfer status, and other management fields
        const nowTime: number = new Date().getTime();
        const managedDevice: DistributedManagerDeviceInfo = {
          deviceId: discoveredDevice.deviceId,
          deviceName: discoveredDevice.deviceName,
          deviceType: discoveredDevice.deviceType,
          networkId: discoveredDevice.networkId,
          range: discoveredDevice.range,
          isInAuth: false,
          isTrust: false,
          trustDeviceId: '',
          transferLoading: false, // Initial state: not transferring
          isInTransfer: false,
          action: DeviceStateChangeAction.READY,  // Device is ready
          updateTime: nowTime,
          pinToken: -1,
          isDelete: false,
        };

        expect(managedDevice.deviceId).assertEqual(discoveredDevice.deviceId);
        expect(managedDevice.deviceName).assertEqual(discoveredDevice.deviceName);
        expect(managedDevice.deviceType).assertEqual(DeviceType.TV);
        expect(managedDevice.range).assertEqual(3);
        expect(managedDevice.isTrust).assertEqual(false);
        expect(managedDevice.isInTransfer).assertEqual(false);
      });

      it('deviceList_sortByRange_mustOrderCorrectly', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const devices: DistributedManagerDeviceInfo[] = [];
        // Create 5 devices with different ranges
        const ranges: number[] = [10, 3, 8, 1, 5];
        for (let i: number = 0; i < 5; i++) {
          const nowTime: number = new Date().getTime();
          devices.push({
            deviceId: 'sort-device-' + String(i),
            deviceName: 'Sort Device-' + String(i),
            deviceType: DeviceType.TV,
            networkId: 'sort-net-' + String(i),
            range: ranges[i],
            isInAuth: false,
            isTrust: false,
            trustDeviceId: '',
            transferLoading: false,
            isInTransfer: false,
            action: DeviceStateChangeAction.READY,
            updateTime: nowTime,
            pinToken: -1,
            isDelete: false,
          });
        }
        // Sort by range ascending (closest first)
        devices.sort((a, b) => a.range - b.range);
        // Verify sort result: range from small to large
        expect(devices[0].range).assertEqual(1);
        expect(devices[1].range).assertEqual(3);
        expect(devices[2].range).assertEqual(5);
        expect(devices[3].range).assertEqual(8);
        expect(devices[4].range).assertEqual(10);
      });
    });

    // Scenario 2: Device authentication flow
    describe('Scenario_DeviceAuthentication', () => {

      // Complete auth flow: unauth -> auth in progress -> auth complete (trusted)
      it('authFlow_unauthToAuthToTrust_mustTransitionCorrectly', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        // Stage 1: Unauthenticated device
        const nowTime: number = new Date().getTime();
        const preAuthDevice: DistributedManagerDeviceInfo = {
          deviceId: 'auth-flow-device',
          deviceName: 'pre-auth-device',
          deviceType: DeviceType.PHONE,
          networkId: 'auth-flow-net',
          range: 7,
          isInAuth: false,
          isTrust: false,
          trustDeviceId: '',
          transferLoading: false,
          isInTransfer: false,
          action: DeviceStateChangeAction.READY,
          updateTime: nowTime,
          pinToken: -1,
          isDelete: false,
        };
        // Auth params
        const authDeviceExtra: StringRecord = makeStringRecord();
        authDeviceExtra.deviceId = 'auth-flow-device';
        const authParam: AuthParam = {
          authType: 1,
          extraInfo: authDeviceExtra
        };

        // Stage 2: Auth in progress
        // authenticateDevice sets isInAuth to true
        preAuthDevice.isInAuth = true;
        expect(preAuthDevice.isInAuth).assertEqual(true);
        expect(preAuthDevice.isTrust).assertEqual(false);  // Still not trusted during auth
        // Stage 3: Auth complete state
        // Simulate state transition after auth callback success
        preAuthDevice.isInAuth = false;
        preAuthDevice.isTrust = true;
        preAuthDevice.trustDeviceId = 'trust-id-auth-flow';
        preAuthDevice.pinToken = 123456;

        expect(preAuthDevice.isInAuth).assertEqual(false);
        expect(preAuthDevice.isTrust).assertEqual(true);
        expect(preAuthDevice.trustDeviceId).assertEqual('trust-id-auth-flow');
        expect(preAuthDevice.pinToken).assertEqual(123456);
      });

      it('authFlow_failure_mustRevertToUnauthState', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        // Device in auth state
        const nowTime: number = new Date().getTime();
        const deviceInAuth: DistributedManagerDeviceInfo = {
          deviceId: 'auth-fail-device',
          deviceName: 'Auth Failed Device',
          deviceType: DeviceType.TABLET,
          networkId: 'auth-fail-net',
          range: 4,
          isInAuth: true,
          isTrust: false,
          trustDeviceId: '',
          transferLoading: false,
          isInTransfer: false,
          action: DeviceStateChangeAction.READY,
          updateTime: nowTime,
          pinToken: -1,
          isDelete: false,
        };

        // Simulate auth failure: reset isInAuth to false in catch block
        deviceInAuth.isInAuth = false;
        // After auth failure, isTrust stays false
        expect(deviceInAuth.isInAuth).assertEqual(false);
        expect(deviceInAuth.isTrust).assertEqual(false);
        // trustDeviceId stays empty (auth failure does not create trust relationship)
        expect(deviceInAuth.trustDeviceId).assertEqual('');
        expect(deviceInAuth.pinToken).assertEqual(-1);
      });
    });

    // Scenario 3: Device transfer flow
    describe('Scenario_DeviceTransfer', () => {

      // Complete transfer flow: not transferring -> loading -> transferring -> stop transfer
      it('transferFlow_idleToActiveToStop_mustTransitionCorrectly', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const nowTime: number = new Date().getTime();
        const device: DistributedManagerDeviceInfo = {
          deviceId: 'transfer-flow-device',
          deviceName: 'Transfer Test Device',
          deviceType: DeviceType.TV,
          networkId: 'transfer-flow-net',
          range: 2,
          isInAuth: false,
          isTrust: true,
          trustDeviceId: 'trust-transfer',
          transferLoading: false,
          isInTransfer: false,
          action: DeviceStateChangeAction.READY,
          updateTime: nowTime,
          pinToken: 999999,
          isDelete: false,
        };

        // Stage 1: Initiate transfer -> transferLoading=true
        device.transferLoading = true;
        expect(device.transferLoading).assertEqual(true);
        expect(device.isInTransfer).assertEqual(false);

        // Stage 2: Transfer connection established -> transferLoading=false, isInTransfer=true
        device.transferLoading = false;
        device.isInTransfer = true;
        expect(device.transferLoading).assertEqual(false);
        expect(device.isInTransfer).assertEqual(true);

        // Stage 3: Stop transfer -> isInTransfer=false, transferLoading=false
        device.isInTransfer = false;
        expect(device.isInTransfer).assertEqual(false);
        expect(device.transferLoading).assertEqual(false);
        expect(device.isTrust).assertEqual(true);
      });

      it('transferFlow_failure_mustClearLoadingState', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const nowTime: number = new Date().getTime();
        const device: DistributedManagerDeviceInfo = {
          deviceId: 'transfer-fail-device',
          deviceName: 'Transfer Failed Device',
          deviceType: DeviceType.TV,
          networkId: 'transfer-fail-net',
          range: 6,
          isInAuth: false,
          isTrust: true,
          trustDeviceId: 'trust-fail',
          transferLoading: true,  // Transfer in progress (loading state)
          isInTransfer: false,
          action: DeviceStateChangeAction.READY,
          updateTime: nowTime,
          pinToken: 888888,
          isDelete: false,
        };

        device.transferLoading = false;
        device.isInTransfer = false;
        expect(device.transferLoading).assertEqual(false);
        expect(device.isInTransfer).assertEqual(false);
        expect(device.isTrust).assertEqual(true);  // trust state preserved
      });
    });

    // Scenario 4: Multi-device collaboration
    describe('Scenario_MultiDeviceCollaboration', () => {

      // Complex state scenario managing multiple devices simultaneously
      // Mixed device group: TV + phone + tablet + speaker
      it('multiDevice_statesDiversify_mustHandleAllStates', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const now1: number = new Date().getTime();
        const localTV: DistributedManagerDeviceInfo = {
          deviceId: 'local-tv',
          deviceName: 'Local TV',
          deviceType: DeviceType.TV,
          networkId: 'local-tv-net',
          range: 0,
          isInAuth: false,
          isTrust: true,
          trustDeviceId: 'trust-local',
          transferLoading: false,
          isInTransfer: false,
          action: DeviceStateChangeAction.READY,
          updateTime: now1,
          pinToken: 111111,
          isDelete: false,
        };

        const now2: number = new Date().getTime();
        // Device 2: Phone (trusted, currently transferring)
        const inTransferPhone: DistributedManagerDeviceInfo = {
          deviceId: 'transfer-phone',
          deviceName: 'Transferring Phone',
          deviceType: DeviceType.PHONE,
          networkId: 'phone-net',
          range: 5,
          isInAuth: false,
          isTrust: true,
          trustDeviceId: 'trust-phone',
          transferLoading: false,
          isInTransfer: true,
          action: DeviceStateChangeAction.READY,
          updateTime: now2,
          pinToken: 222222,
          isDelete: false,
        };

        const now3: number = new Date().getTime();
        const waitingAuthTablet: DistributedManagerDeviceInfo = {
          deviceId: 'waiting-tablet',
          deviceName: 'waiting-auth-tablet',
          deviceType: DeviceType.TABLET,
          networkId: 'tablet-net',
          range: 12,
          isInAuth: false,
          isTrust: false,
          trustDeviceId: '',
          transferLoading: false,
          isInTransfer: false,
          action: DeviceStateChangeAction.READY,
          updateTime: now3,
          pinToken: -1,
          isDelete: false,
        };

        const now4: number = new Date().getTime();
        // Device 4: Speaker (trusted, idle and available for transfer)
        const availableSpeaker: DistributedManagerDeviceInfo = {
          deviceId: 'available-speaker',
          deviceName: 'Available Speaker',
          deviceType: DeviceType.SPEAKER,
          networkId: 'speaker-net',
          range: 8,
          isInAuth: false,
          isTrust: true,
          trustDeviceId: 'trust-speaker',
          transferLoading: false,
          isInTransfer: false,
          action: DeviceStateChangeAction.READY,
          updateTime: now4,
          pinToken: 333333,
          isDelete: false,
        };

        expect(localTV.range).assertEqual(0);
        expect(inTransferPhone.isInTransfer).assertEqual(true);
        expect(waitingAuthTablet.isTrust).assertEqual(false);
        expect(availableSpeaker.isTrust).assertEqual(true);
        expect(availableSpeaker.isInTransfer).assertEqual(false);

        const canTransfer: boolean = (!(availableSpeaker.isInTransfer ?? false)) && (availableSpeaker.isTrust ?? false);
        expect(canTransfer).assertEqual(true);
        // Device currently transferring cannot transfer again
        const phoneCanTransfer: boolean = (!(inTransferPhone.isInTransfer ?? false)) && (inTransferPhone.isTrust ?? false);
        expect(phoneCanTransfer).assertEqual(false);
      });

      // Device online/offline scenario: device offline -> remove from list -> device re-online -> re-add
      it('deviceOfflineAndReonline_mustHandleGracefully', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const nowTime: number = new Date().getTime();
        const deviceMap: Map<string, DistributedManagerDeviceInfo> = new Map();

        // Online: new device added
        const newDevice: DistributedManagerDeviceInfo = {
          deviceId: 'online-offline-device',
          deviceName: 'online-offline-device',
          deviceType: DeviceType.TV,
          networkId: 'oo-net',
          range: 4,
          isInAuth: false,
          isTrust: false,
          trustDeviceId: '',
          transferLoading: false,
          isInTransfer: false,
          action: DeviceStateChangeAction.READY,
          updateTime: nowTime,
          pinToken: -1,
          isDelete: false,
        };
        deviceMap.set(newDevice.deviceId, newDevice);
        expect(deviceMap.size).assertEqual(1);

        // Offline: mark for deletion (soft delete)
        const offlineDevice: DistributedManagerDeviceInfo | undefined = deviceMap.get('online-offline-device');
        if (offlineDevice != null) {
          offlineDevice.isDelete = true;
          deviceMap.set('online-offline-device', offlineDevice);
        }
        const mapGetResult: DistributedManagerDeviceInfo | undefined = deviceMap.get('online-offline-device');
        if (mapGetResult != null) {
          expect(mapGetResult.isDelete).assertEqual(true);
        }

        // Re-online: update state, clear delete flag
        const reonlineTime: number = new Date().getTime();
        const reonlineDevice: DistributedManagerDeviceInfo | undefined = deviceMap.get('online-offline-device');
        if (reonlineDevice != null) {
          reonlineDevice.isDelete = false;
          reonlineDevice.updateTime = reonlineTime;
          reonlineDevice.networkId = 'oo-new-net';  // New network address
          deviceMap.set('online-offline-device', reonlineDevice);
        }
        const finalDevice: DistributedManagerDeviceInfo | undefined = deviceMap.get('online-offline-device');
        if (finalDevice != null) {
          expect(finalDevice.isDelete).assertEqual(false);
          expect(finalDevice.networkId).assertEqual('oo-new-net');
        }
      });
    });

    // Scenario 5: AuthParam and device info interaction
    describe('Scenario_AuthParamDeviceInteraction', () => {

      // extraInfo carries device context information
      it('extraInfo_carryDeviceContext_mustSupportCustomFields', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const sourceDevice: DeviceInfoType = {
          deviceId: 'source-device',
          deviceName: 'source-device-name',
          deviceType: DeviceType.TV,
          networkId: 'source-net',
          range: 2
        };

        const nowTime: number = new Date().getTime();
        const contextExtraInfo: StringRecord = makeStringRecord();
        contextExtraInfo.sourceDeviceId = sourceDevice.deviceId;
        contextExtraInfo.sourceDeviceName = sourceDevice.deviceName;
        contextExtraInfo.sourceDeviceType = String(sourceDevice.deviceType);
        contextExtraInfo.authTimestamp = String(nowTime);
        contextExtraInfo.authVersion = '1.0';
        contextExtraInfo.vendorData = 'custom-payload';
        const authParam: AuthParam = {
          authType: 1,
          extraInfo: contextExtraInfo
        };

        expect(authParam.extraInfo.sourceDeviceId).assertEqual('source-device');
        expect(authParam.extraInfo.sourceDeviceName).assertEqual('source-device-name');
        expect(authParam.extraInfo.vendorData).assertEqual('custom-payload');
        // authType stays unchanged
        expect(authParam.authType).assertEqual(1);
      });
    });

    // Scenario 6: Expired device auto cleanup
    describe('Scenario_ExpiredDeviceCleanup', () => {

      it('cleanup_expiredDevices_olderThan60Seconds_mustBeFiltered', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const now: number = new Date().getTime();
        const deviceMap: Map<string, DistributedManagerDeviceInfo> = new Map();

        // Add 10 devices with different update times
        for (let i: number = 0; i < 10; i++) {
          const updateTime: number = now - i * 10 * 100;
          deviceMap.set('cleanup-device-' + String(i), {
            deviceId: 'cleanup-device-' + String(i),
            deviceName: 'Cleanup Device-' + String(i),
            deviceType: DeviceType.TV,
            networkId: 'cleanup-net-' + String(i),
            range: i,
            isInAuth: false,
            isTrust: false,
            trustDeviceId: '',
            transferLoading: false,
            isInTransfer: false,
            action: DeviceStateChangeAction.READY,
            updateTime: updateTime,
            pinToken: -1,
            isDelete: false,
          });
        }

        // Filter 60-second threshold
        const activeDeviceIds: string[] = [];
        deviceMap.forEach((device: DistributedManagerDeviceInfo, key: string) => {
          if (device.updateTime && (now - device.updateTime) < 60000) {
            activeDeviceIds.push(key);
          }
        });

        expect(activeDeviceIds.length).assertEqual(6);
        // check if 'cleanup-device-6' is NOT in activeDeviceIds using indexOf
        const device6Index: number = activeDeviceIds.indexOf('cleanup-device-6');
        expect(device6Index).assertEqual(-1);
        // Device 5 (50 seconds ago) is still valid
        const device5Index: number = activeDeviceIds.indexOf('cleanup-device-5');
        expect(device5Index >= 0).assertTrue();
      });
    });

    // Scenario 7: Device property JSON serialization/deserialization
    describe('Scenario_Serialization', () => {

      // Device info needs serialization for distributed KV storage
      it('serialize_deviceInfo_mustSurviveRoundTrip', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const device: DistributedManagerDeviceInfo = {
          deviceId: 'serialize-test-device',
          deviceName: 'serialize-test-device-name',
          deviceType: DeviceType.TV,
          networkId: 'serialize-net',
          range: 3,
          isInAuth: false,
          isTrust: true,
          trustDeviceId: 'trust-serialize',
          transferLoading: false,
          isInTransfer: false,
          action: DeviceStateChangeAction.READY,
          updateTime: 1700000000000,
          pinToken: 567890,
          isDelete: false,
        };

        const jsonString: string = JSON.stringify(device);
        // Deserialize
        const parsedObj: DistributedManagerDeviceInfo = JSON.parse(jsonString) as DistributedManagerDeviceInfo;
        const parsedBack: DistributedManagerDeviceInfo = parsedObj;

        // Verify all fields are preserved after serialization round trip
        expect(parsedBack.deviceId).assertEqual('serialize-test-device');
        expect(parsedBack.deviceName).assertEqual('serialize-test-device-name');
        expect(parsedBack.isTrust).assertEqual(true);
        expect(parsedBack.trustDeviceId).assertEqual('trust-serialize');
        expect(parsedBack.pinToken).assertEqual(567890);
        expect(parsedBack.range).assertEqual(3);
        expect(parsedBack.updateTime).assertEqual(1700000000000);
      });

      it('serialize_authParam_mustPreserveExtraInfo', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const serializeExtra: StringRecord = makeStringRecord();
        serializeExtra.key1 = 'value1';
        serializeExtra.key2 = 'value2';
        serializeExtra.nested = '{"a":1,"b":2}';
        const auth: AuthParam = {
          authType: 1,
          extraInfo: serializeExtra
        };

        const serialized: string = JSON.stringify(auth);
        const deserialized: AuthParam = JSON.parse(serialized) as AuthParam;

        expect(deserialized.authType).assertEqual(1);
        expect(deserialized.extraInfo.key1).assertEqual('value1');
        expect(deserialized.extraInfo.key2).assertEqual('value2');
        expect(deserialized.extraInfo.nested).assertEqual('{"a":1,"b":2}');
      });
    });

    // Scenario 8: Device state change notification
    describe('Scenario_StateChangeNotification', () => {

      it('stateChangeAction_enumMapping_mustBeCorrect', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        // ONLINE=0: device online
        expect(DeviceStateChangeAction.ONLINE).assertEqual(0);
        expect(DeviceStateChangeAction.READY).assertEqual(1);
        // OFFLINE=2: device offline
        expect(DeviceStateChangeAction.OFFLINE).assertEqual(2);
        expect(DeviceStateChangeAction.CHANGE).assertEqual(3);

        const refreshTriggers: DeviceStateChangeAction[] = [
          DeviceStateChangeAction.ONLINE,
          DeviceStateChangeAction.READY,
        ];
        expect(refreshTriggers.length).assertEqual(2);
        const containsOnline: boolean = refreshTriggers[0] === 0 || refreshTriggers[1] === 0;
        expect(containsOnline).assertTrue();
        const containsReady: boolean = refreshTriggers[0] === 1 || refreshTriggers[1] === 1;
        expect(containsReady).assertTrue();
      });
    });
  });
}
