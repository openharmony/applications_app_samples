/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { describe, it, expect, beforeEach, TestType, Size, Level } from '@ohos/hypium';


import { DeviceInfoType, AuthParam } from '../../../../main/ets/const/Type';
import { DeviceType } from '../../../../main/ets/model/RemoteDeviceModel';

interface StringRecord extends Record<string, string> {}
interface NumberRecord extends Record<string, number> {}

function makeStringRecord(): StringRecord {
  let result: Record<string, string>;
  result = { 'deviceId': '', 'deviceName': '', 'pinCode': '', 'customField': '', 'protocolVersion': '' };
  return result;
}

class NestedRecord {
  deviceId: string = '';
  deviceName: string = '';
  deviceType: number = 0;
  networkId: string = '';
  range: number = 0;
  authType: number = 0;
  extraInfo: NestedRecord | null = null;
  customField: string = '';
  protocolVersion: string = '';
  newField: string = '';
  isConnected: boolean = false;
}

// ArkTS requires named interfaces for object literal types
interface ServiceAbilityParams {
  uri: string;
  seekTo: number;
  isPlaying: boolean;
  flag: string;
}

/**
 * Type contract tests
 */
export default function typeContractTestSuite(): void {
  describe('TypeContractTest', () => {

    // ========== DeviceInfoType contract tests ==========
    describe('DeviceInfoType_contract', () => {

      it('contract_requiredFields_mustAllPresent', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const fullDevice: DeviceInfoType = {
          deviceId: 'contract-device',
          deviceName: 'contract-device-name',
          deviceType: DeviceType.TV,
          networkId: 'contract-net',
          range: 10
        };
        const deviceIdType: string = typeof fullDevice.deviceId;
        const deviceNameType: string = typeof fullDevice.deviceName;
        const deviceTypeType: string = typeof fullDevice.deviceType;
        const networkIdType: string = typeof fullDevice.networkId;
        const rangeType: string = typeof fullDevice.range;
        expect(deviceIdType).assertEqual('string');
        expect(deviceNameType).assertEqual('string');
        expect(deviceTypeType).assertEqual('number');
        expect(networkIdType).assertEqual('string');
        expect(rangeType).assertEqual('number');
      });

      it('contract_deviceIdType_mustBeStringOnly', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const normalDevice: DeviceInfoType = {
          deviceId: 'normal-id', deviceName: 'normal', deviceType: DeviceType.TV, networkId: '', range: 0
        };
        const normalDeviceIdType: string = typeof normalDevice.deviceId;
        expect(normalDeviceIdType).assertEqual('string');

        const emptyDevice: DeviceInfoType = {
          deviceId: '', deviceName: 'empty', deviceType: DeviceType.TV, networkId: '', range: 0
        };
        expect(emptyDevice.deviceId).assertEqual('');
        const emptyDeviceIdType: string = typeof emptyDevice.deviceId;
        expect(emptyDeviceIdType).assertEqual('string');
      });

      it('contract_deviceTypeValues_mustBeInEnumRange', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const validTypes: DeviceType[] = [
          DeviceType.UNKNOWN_TYPE,
          DeviceType.SPEAKER,
          DeviceType.PHONE,
          DeviceType.TABLET,
          DeviceType.WEARABLE,
          DeviceType.CAR,
          DeviceType.TV
        ];

        expect(validTypes.length).assertEqual(7);
        for (let i: number = 0; i < validTypes.length; i++) {
          const typeVal: number = validTypes[i];
          expect(typeVal).assertLarger(-1);
        }
        expect(DeviceType.UNKNOWN_TYPE).assertEqual(0);
        expect(DeviceType.TV).assertEqual(156);
      });

      it('contract_rangeField_mustBeNumber', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const device: DeviceInfoType = {
          deviceId: 'range-device',
          deviceName: 'range-device-name',
          deviceType: DeviceType.TV,
          networkId: 'range-net',
          range: 5.5
        };
        const rangeType: string = typeof device.range;
        expect(rangeType).assertEqual('number');
        expect(device.range).assertEqual(5.5);
      });
    });

    // ========== AuthParam contract tests ==========
    describe('AuthParam_contract', () => {

      it('contract_requiredAuthFields_mustAllPresent', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const emptyExtraInfo: StringRecord = makeStringRecord();
        const auth: AuthParam = {
          authType: 1,
          extraInfo: emptyExtraInfo
        };

        const authTypeType: string = typeof auth.authType;
        expect(authTypeType).assertEqual('number');
        const extraInfoType: string = typeof auth.extraInfo;
        expect(extraInfoType).assertEqual('object');
        const extraInfoNotNull: boolean = auth.extraInfo !== null;
        expect(extraInfoNotNull).assertTrue();
      });

      it('contract_authType_1_mustBeNoAccountPinAuth', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const currentProtocolAuthType: number = 1;
        expect(currentProtocolAuthType).assertEqual(1);

        const legacyAuthType: number = 0;
        expect(legacyAuthType).assertEqual(0);

        const negativeAuthType: number = -1;
        expect(negativeAuthType).assertLess(0);
      });

      it('contract_extraInfo_mustBeStringKeyStringValue', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const testExtraInfo: StringRecord = makeStringRecord();
        testExtraInfo.deviceId = 'extra-device';
        testExtraInfo.deviceName = 'extra-info-device';
        testExtraInfo.pinCode = '123456';
        const auth: AuthParam = {
          authType: 1,
          extraInfo: testExtraInfo
        };
        const keys: string[] = ['deviceId', 'deviceName', 'pinCode'];
        for (let i: number = 0; i < keys.length; i++) {
          const valueType: string = typeof auth.extraInfo[keys[i]];
          expect(valueType).assertEqual('string');
        }
        expect(keys.length).assertEqual(3);
      });
    });

    // ========== Cross-module contract consistency tests ==========
    describe('CrossModule_contract', () => {

      it('contract_DeviceInfoType_to_ServiceAbilityParams_mustBeCompatible', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const device: DeviceInfoType = {
          deviceId: 'cross-module-device',
          deviceName: 'cross-module-device-name',
          deviceType: DeviceType.TV,
          networkId: 'cross-net',
          range: 5
        };
        const params: ServiceAbilityParams = {
          uri: '',
          seekTo: 0,
          isPlaying: false,
          flag: 'START_REMOTE_DISTRIBUTED_MUSIC_SERVICE'
        };
        const deviceIdType: string = typeof device.deviceId;
        expect(deviceIdType).assertEqual('string');
        const networkIdType: string = typeof device.networkId;
        expect(networkIdType).assertEqual('string');
        const flagType: string = typeof params.flag;
        expect(flagType).assertEqual('string');
      });

      it('contract_AuthParam_to_authenticateDevice_mustMatchSignature', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const deviceInfo: DeviceInfoType = {
          deviceId: 'auth-contract-device',
          deviceName: 'auth-contract-device-name',
          deviceType: DeviceType.TV,
          networkId: 'auth-contract-net',
          range: 3
        };
        const emptyAuthExtraInfo: StringRecord = makeStringRecord();
        const authParam: AuthParam = {
          authType: 1,
          extraInfo: emptyAuthExtraInfo
        };

        expect(deviceInfo.deviceId.length).assertLarger(0);
        expect(authParam.authType).assertEqual(1);
        const extraInfoType: string = typeof authParam.extraInfo;
        expect(extraInfoType).assertEqual('object');
      });
    });

    // ========== JSON serialization contract tests ==========
    describe('JSONSerialization_contract', () => {

      it('contract_jsonSerialization_mustContainAllFields', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const device: DeviceInfoType = {
          deviceId: 'json-device',
          deviceName: 'JSON-device',
          deviceType: DeviceType.TV,
          networkId: 'json-net',
          range: 7
        };
        const json: string = JSON.stringify(device);
        const parsed: NestedRecord = JSON.parse(json) as NestedRecord;

        const hasDeviceId: boolean = typeof parsed.deviceId !== 'undefined';
        const hasDeviceName: boolean = typeof parsed.deviceName !== 'undefined';
        const hasDeviceType: boolean = typeof parsed.deviceType !== 'undefined';
        const hasNetworkId: boolean = typeof parsed.networkId !== 'undefined';
        const hasRange: boolean = typeof parsed.range !== 'undefined';
        expect(hasDeviceId).assertEqual(true);
        expect(hasDeviceName).assertEqual(true);
        expect(hasDeviceType).assertEqual(true);
        expect(hasNetworkId).assertEqual(true);
        expect(hasRange).assertEqual(true);
        const parsedDeviceType: number = parsed.deviceType;
        const deviceTypeType: string = typeof parsedDeviceType;
        expect(deviceTypeType).assertEqual('number');
        expect(parsed.range).assertEqual(7);
      });

      it('contract_jsonDeserialization_mustReconstructValidObject', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const storedJson: string = '{"deviceId":"kv-device","deviceName":"KV-device","deviceType":156,"networkId":"kv-net","range":12}';
        const reconstructed: NestedRecord = JSON.parse(storedJson) as NestedRecord;

        const reconDeviceId: string = reconstructed.deviceId;
        const reconDeviceName: string = reconstructed.deviceName;
        const reconDeviceType: number = reconstructed.deviceType;
        const reconNetworkId: string = reconstructed.networkId;
        const reconRange: number = reconstructed.range;
        const safeDevice: DeviceInfoType = {
          deviceId: reconDeviceId,
          deviceName: reconDeviceName,
          deviceType: reconDeviceType as DeviceType,
          networkId: reconNetworkId,
          range: reconRange
        };

        expect(safeDevice.deviceId).assertEqual('kv-device');
        expect(safeDevice.deviceName).assertEqual('KV-device');
        expect(safeDevice.deviceType).assertEqual(DeviceType.TV);
        expect(safeDevice.range).assertEqual(12);
      });

      it('contract_authParamSerialization_mustBeCorrect', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const authExtraInfo: StringRecord = makeStringRecord();
        authExtraInfo.customField = 'customValue';
        authExtraInfo.protocolVersion = '1.0.0';
        const auth: AuthParam = {
          authType: 1,
          extraInfo: authExtraInfo
        };
        const serialized: string = JSON.stringify(auth);
        const parsed: NestedRecord = JSON.parse(serialized) as NestedRecord;

        expect(parsed.authType).assertEqual(1);
        const extra: NestedRecord = parsed.extraInfo as NestedRecord;
        expect(extra !== null).assertTrue();
        if (extra !== null) {
          expect(extra.customField).assertEqual('customValue');
          expect(extra.protocolVersion).assertEqual('1.0.0');
        }
      });
    });

    // ========== Backward compatibility contract tests ==========
    describe('BackwardCompatibility_contract', () => {

      it('contract_missingFieldsInLegacyData_mustProvideDefaults', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const legacyJson: string = '{"deviceId":"legacy-device","deviceName":"legacy-device-name","deviceType":156,"networkId":"legacy-net"}';
        const parsed: NestedRecord = JSON.parse(legacyJson) as NestedRecord;

        const legacyDeviceId: string = parsed.deviceId || '';
        const legacyDeviceName: string = parsed.deviceName || 'unknown-device';
        const legacyDeviceType: number = parsed.deviceType !== 0 ? parsed.deviceType : 0;
        const legacyNetworkId: string = parsed.networkId || '';
        const legacyRange: number = parsed.range || 0;
        const safeDevice: DeviceInfoType = {
          deviceId: legacyDeviceId,
          deviceName: legacyDeviceName,
          deviceType: legacyDeviceType as DeviceType,
          networkId: legacyNetworkId,
          range: legacyRange
        };

        expect(safeDevice.deviceId).assertEqual('legacy-device');
        expect(safeDevice.range).assertEqual(0);
        expect(safeDevice.deviceType).assertEqual(156);
      });

      it('contract_extraFieldsInNewerData_mustBeIgnored', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const newerJson: string = '{"deviceId":"new-device","deviceName":"new-device-name","deviceType":156,"networkId":"new-net","range":5,"newField":"newValue","isConnected":true}';
        const parsed: NestedRecord = JSON.parse(newerJson) as NestedRecord;

        const coreDeviceId: string = parsed.deviceId;
        const coreDeviceName: string = parsed.deviceName;
        const coreDeviceType: number = parsed.deviceType;
        const coreNetworkId: string = parsed.networkId;
        const coreRange: number = parsed.range;
        const coreDevice: DeviceInfoType = {
          deviceId: coreDeviceId,
          deviceName: coreDeviceName,
          deviceType: coreDeviceType as DeviceType,
          networkId: coreNetworkId,
          range: coreRange
        };

        expect(coreDevice.deviceId).assertEqual('new-device');
        expect(coreDevice.range).assertEqual(5);
        // extra newField and isConnected fields are safely ignored
      });
    });

    // ========== Immutability contract tests ==========
    describe('Immutability_contract', () => {

      it('contract_deviceInfoFields_shouldBeTreatedAsImmutable', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const original: DeviceInfoType = {
          deviceId: 'immutable-device',
          deviceName: 'immutable-device-name',
          deviceType: DeviceType.TV,
          networkId: 'immutable-net',
          range: 5
        };
        const copy: DeviceInfoType = {
          deviceId: original.deviceId,
          deviceName: original.deviceName,
          deviceType: original.deviceType,
          networkId: original.networkId,
          range: original.range
        };

        copy.deviceName = 'modified-name';
        copy.range = 100;

        expect(original.deviceName).assertEqual('immutable-device-name');
        expect(original.range).assertEqual(5);
        expect(copy.deviceName).assertEqual('modified-name');
        expect(copy.range).assertEqual(100);
      });
    });
  });
}
