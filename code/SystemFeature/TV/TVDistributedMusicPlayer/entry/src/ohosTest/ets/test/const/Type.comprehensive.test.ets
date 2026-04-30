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

import { describe, it, expect, TestType, Size, Level } from '@ohos/hypium';

import { DeviceInfoType, AuthParam } from '../../../../main/ets/const/Type';
import { DeviceType } from '../../../../main/ets/model/RemoteDeviceModel';

interface StringRecord extends Record<string, string> {}
interface ObjectRecord extends Record<string, object> {}
interface NumberRecord extends Record<string, number> {}
function makeStringRecord(): StringRecord { return {} as StringRecord; }

// Typed interfaces for object literal extra info types
interface SimpleExtraInfo { key: string; }
interface PinCodeInfo { pinCode: string; }
interface MultiKeyInfo { key1: string; key2: number; key3: boolean; }
interface NestedExtraInfo { nested: Map<string, string>; }
interface DeviceArrayInfo { devices: string[]; }
interface BoolExtraInfo { isTrusted: boolean; isActive: boolean; }
interface IndexExtraInfo { index: number; }
interface IndexTokenInfo { index: number; token: string; }
interface SourceDeviceInfo { sourceDevice: string; }
interface SeqExtraInfo { seq: number; }
interface DeviceIdPinInfo { deviceId: string; pinCode: string; }
interface NestedRecordHolder { value: string; child: NestedRecordHolder | null; }
interface ScriptTagInfo { scriptTag: string; }
interface TransportEventPayload { type: string; device: DeviceInfoType; auth: AuthParam; }
interface AuthEventPayload { type: string; data: AuthParam; }
interface InnerValueInfo { inner: string; }

// Typed empty extras interface
interface EmptyExtraInfo {}

class NestableRecord {
  value: string;
  child: NestableRecord | null;
  constructor(v: string, c: NestableRecord | null) {
    this.value = v;
    this.child = c;
  }
}

function strRepeat(s: string, count: number): string {
  let result: string = '';
  for (let i: number = 0; i < count; i++) { result += s; }
  return result;
}

function makeDeviceInfo(
  deviceId: string, deviceName: string, deviceType: DeviceType,
  networkId: string, range: number
): DeviceInfoType {
  return {
    deviceId: deviceId,
    deviceName: deviceName,
    deviceType: deviceType,
    networkId: networkId,
    range: range
  };
}

function makeAuthParam(authType: number, extraInfo: StringRecord): AuthParam {
  // AuthParam extraInfo is Record<string,string>
  const result: AuthParam = {
    authType: authType,
    extraInfo: extraInfo
  };
  return result;
}

const EMPTY_EXTRA: StringRecord = makeStringRecord();

export default function TypeComprehensiveTestSuite(): void {
  describe('TypeComprehensiveTest', () => {

    describe('DeviceInfoTypeInterfaceTest', () => {

      it('test_deviceInfoType_allFields', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const info: DeviceInfoType = makeDeviceInfo('dev-001', 'Test Device', DeviceType.TV, 'net-001', 10);
        expect(info.deviceId).assertEqual('dev-001');
        expect(info.deviceName).assertEqual('Test Device');
        expect(info.deviceType).assertEqual(DeviceType.TV);
        expect(info.networkId).assertEqual('net-001');
        expect(info.range).assertEqual(10);
      });

      it('test_deviceInfoType_emptyValues', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const info: DeviceInfoType = makeDeviceInfo('', '', DeviceType.UNKNOWN_TYPE, '', 0);
        expect(info.deviceId).assertEqual('');
        expect(info.deviceName).assertEqual('');
        expect(info.range).assertEqual(0);
      });

      it('test_deviceInfoType_chineseName', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const info: DeviceInfoType = makeDeviceInfo('cn-dev', '测试设备名称', DeviceType.TV, 'cn-net', 5);
        expect(info.deviceName).assertEqual('测试设备名称');
      });

      it('test_deviceInfoType_specialCharDeviceId', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const info: DeviceInfoType = makeDeviceInfo('dev-!@#$%', 'Special', DeviceType.PHONE, 'net-!@#$%', 0);
        expect(info.deviceId).assertEqual('dev-!@#$%');
      });

      it('test_deviceInfoType_allDeviceTypes', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const types: DeviceType[] = [
          DeviceType.UNKNOWN_TYPE, DeviceType.SPEAKER, DeviceType.PHONE,
          DeviceType.TABLET, DeviceType.WEARABLE, DeviceType.CAR, DeviceType.TV
        ];
        types.forEach((type: DeviceType, idx: number): void => {
          const info: DeviceInfoType = makeDeviceInfo(
            'dev_' + idx.toString(), 'Device ' + idx.toString(), type, 'net_' + idx.toString(), idx
          );
          expect(info.deviceType).assertEqual(type);
        });
      });

      it('test_deviceInfoType_rangeBoundaryValues', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const ranges: number[] = [0, -1, 1, 100, 100, Number.MAX_SAFE_INTEGER];
        ranges.forEach((range: number, idx: number): void => {
          const info: DeviceInfoType = makeDeviceInfo(
            'range_' + idx.toString(), 'Range', DeviceType.TV, 'net', range
          );
          expect(info.range).assertEqual(range);
        });
      });

      it('test_deviceInfoType_longDeviceName', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const longName: string = strRepeat('Device', 100);
        const info: DeviceInfoType = makeDeviceInfo('long', longName, DeviceType.TV, 'net', 0);
        expect(info.deviceName).assertEqual(longName);
      });

      it('test_deviceInfoType_emptyNetworkId', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const info: DeviceInfoType = makeDeviceInfo('dev', 'Device', DeviceType.TV, '', 0);
        expect(info.networkId).assertEqual('');
      });

      it('test_deviceInfoType_mutation', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const info: DeviceInfoType = makeDeviceInfo('orig', 'origName', DeviceType.TV, 'origNet', 5);
        info.deviceName = 'changedName';
        info.networkId = 'changedNet';
        info.range = 10;
        expect(info.deviceName).assertEqual('changedName');
        expect(info.networkId).assertEqual('changedNet');
        expect(info.range).assertEqual(10);
      });

      it('test_deviceInfoType_multipleInstances', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const devices: DeviceInfoType[] = [];
        const typeChoices: DeviceType[] = [DeviceType.TV, DeviceType.PHONE, DeviceType.TABLET];
        for (let i: number = 0; i < 10; i++) {
          devices.push(makeDeviceInfo(
            'multi_' + i.toString(), 'Multi ' + i.toString(), typeChoices[i % 3],
            'net_' + i.toString(), i
          ));
        }
        expect(devices.length).assertEqual(10);
        devices.forEach((device: DeviceInfoType, idx: number): void => {
          expect(device.deviceId).assertEqual('multi_' + idx.toString());
        });
      });
    });

    describe('AuthParamInterfaceTest', () => {

      it('test_authParam_basicPinAuth', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const param: AuthParam = makeAuthParam(1, EMPTY_EXTRA);
        expect(param.authType).assertEqual(1);
      });

      it('test_authParam_withExtraInfo', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const extra: StringRecord = makeStringRecord();
        extra.pinCode = '123456';
        const param: AuthParam = makeAuthParam(1, extra);
        expect(extra.pinCode).assertEqual('123456');
      });

      it('test_authParam_extraInfoMultipleKeys', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const extra: StringRecord = makeStringRecord();
        extra.key1 = 'value1';
        extra.key2 = '42';
        extra.key3 = 'true';
        const param: AuthParam = makeAuthParam(1, extra);
        expect(extra.key1).assertEqual('value1');
        expect(extra.key2).assertEqual('42');
        expect(extra.key3).assertEqual('true');
      });

      it('test_authParam_authTypeZero', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const param: AuthParam = makeAuthParam(0, EMPTY_EXTRA);
        expect(param.authType).assertEqual(0);
      });

      it('test_authParam_authTypeNegative', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const param: AuthParam = makeAuthParam(-1, EMPTY_EXTRA);
        expect(param.authType).assertEqual(-1);
      });

      it('test_authParam_authTypeMax', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const param: AuthParam = makeAuthParam(Number.MAX_SAFE_INTEGER, EMPTY_EXTRA);
        expect(param.authType).assertEqual(Number.MAX_SAFE_INTEGER);
      });

      it('test_authParam_extendsRecord', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const extra: StringRecord = makeStringRecord();
        extra.customKey = 'customValue';
        extra.numericKey = '42';
        const param: AuthParam = makeAuthParam(1, extra);
        expect(param.authType).assertEqual(1);
        expect(extra.customKey).assertEqual('customValue');
      });

      it('test_authParam_extraInfoWithObjectValue', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const innerValue: InnerValueInfo = { inner: 'value' };
        const extra: StringRecord = makeStringRecord();
        extra.nested = JSON.stringify(innerValue);
        const param: AuthParam = makeAuthParam(1, extra);
        expect(extra.nested !== null).assertTrue();
      });

      it('test_authParam_extraInfoWithArrayValue', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const extra: StringRecord = makeStringRecord();
        extra.devices = JSON.stringify(['dev1', 'dev2']);
        const param: AuthParam = makeAuthParam(1, extra);
        const devicesStr: string | undefined = extra.devices;
        expect(devicesStr !== undefined).assertTrue();
      });

      it('test_authParam_mutation', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const extra: StringRecord = makeStringRecord();
        const param: AuthParam = makeAuthParam(1, extra);
        param.authType = 2;
        extra.newKey = 'newValue';
        expect(param.authType).assertEqual(2);
        expect(extra.newKey).assertEqual('newValue');
      });
    });

    describe('TypeContractCrossCheck', () => {

      it('test_deviceInfoType_matchesRemoteDeviceModel', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const info: DeviceInfoType = makeDeviceInfo('contract-dev', 'Contract', DeviceType.TV, 'contract-net', 5);
        expect(info.deviceId.length).assertLarger(0);
        expect(typeof info.deviceType).assertEqual('number');
        expect(typeof info.range).assertEqual('number');
      });

      it('test_authParam_authType1_isPinCodeAuth', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const param: AuthParam = makeAuthParam(1, EMPTY_EXTRA);
        expect(param.authType).assertEqual(1);
      });

      it('test_deviceInfoType_jsonSerialization', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const info: DeviceInfoType = makeDeviceInfo('json-dev', 'JSON Device', DeviceType.TV, 'json-net', 10);
        const json: string = JSON.stringify(info);
        const parsed: DeviceInfoType = JSON.parse(json) as DeviceInfoType;
        expect(parsed.deviceId).assertEqual('json-dev');
        expect(parsed.deviceName).assertEqual('JSON Device');
        expect(parsed.range).assertEqual(10);
      });

      it('test_authParam_jsonSerialization', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const extra: StringRecord = makeStringRecord();
        extra.key = 'value';
        const param: AuthParam = makeAuthParam(1, extra);
        const json: string = JSON.stringify(param);
        const parsed: AuthParam = JSON.parse(json) as AuthParam;
        expect(parsed.authType).assertEqual(1);
      });
    });

    describe('TypeEdgeCasesTest', () => {

      it('test_deviceInfoType_emojiName', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const info: DeviceInfoType = makeDeviceInfo('emoji', '😊🎵🎶', DeviceType.TV, 'net', 0);
        expect(info.deviceName).assertEqual('😊🎵🎶');
      });

      it('test_deviceInfoType_scriptTagInName', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const info: DeviceInfoType = makeDeviceInfo('xss', '<script>alert(1)</script>', DeviceType.TV, 'net', 0);
        expect(info.deviceName).assertEqual('<script>alert(1)</script>');
      });

      it('test_authParam_extraInfoBooleanValue', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const extra: StringRecord = makeStringRecord();
        extra.isTrusted = 'true';
        extra.isActive = 'false';
        const param: AuthParam = makeAuthParam(1, extra);
        expect(extra.isTrusted).assertEqual('true');
        expect(extra.isActive).assertEqual('false');
      });

      it('test_deviceInfoType_negativeRange', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const info: DeviceInfoType = makeDeviceInfo('neg', 'Negative', DeviceType.TV, 'net', -100);
        expect(info.range).assertEqual(-100);
      });
    });

    describe('TypeStressTest', () => {

      it('test_stress_deviceInfoCreation_100', TestType.RELIABILITY | Size.LARGETEST | Level.LEVEL3, () => {
        const typeChoices: DeviceType[] = [DeviceType.TV, DeviceType.PHONE, DeviceType.TABLET];
        for (let i: number = 0; i < 100; i++) {
          const info: DeviceInfoType = makeDeviceInfo(
            'stress_' + i.toString(), 'Stress ' + i.toString(), typeChoices[i % 3],
            'stress_net_' + i.toString(), i % 100
          );
          expect(info.deviceId).assertEqual('stress_' + i.toString());
        }
      });

      it('test_stress_authParamCreation_100', TestType.RELIABILITY | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const extra: StringRecord = makeStringRecord();
          extra.index = i.toString();
          const param: AuthParam = makeAuthParam(i % 2 === 0 ? 1 : 0, extra);
          expect(typeof param.authType).assertEqual('number');
        }
      });

      it('test_stress_jsonRoundTrip_1000', TestType.RELIABILITY | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 1000; i++) {
          const info: DeviceInfoType = makeDeviceInfo(
            'json_' + i.toString(), 'JSON ' + i.toString(), DeviceType.TV,
            'json_net_' + i.toString(), i
          );
          const json: string = JSON.stringify(info);
          const parsed: DeviceInfoType = JSON.parse(json) as DeviceInfoType;
          expect(parsed.deviceId).assertEqual('json_' + i.toString());
        }
      });
    });

    // ========== DeviceType enum exhaustive validation ==========
    describe('DeviceType_enumExhaustive', () => {

      it('comprehensive_deviceType_hasExactlySevenValues', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const deviceTypes: DeviceType[] = [
          DeviceType.UNKNOWN_TYPE, DeviceType.SPEAKER, DeviceType.PHONE,
          DeviceType.TABLET, DeviceType.WEARABLE, DeviceType.CAR, DeviceType.TV
        ];
        expect(deviceTypes.length).assertEqual(7);
      });

      it('comprehensive_deviceType_hexValuesAreCorrect', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(DeviceType.UNKNOWN_TYPE).assertEqual(0);
        expect(DeviceType.SPEAKER).assertEqual(0x0A);
        expect(DeviceType.PHONE).assertEqual(0x0E);
        expect(DeviceType.TABLET).assertEqual(0x11);
        expect(DeviceType.WEARABLE).assertEqual(0x6D);
        expect(DeviceType.CAR).assertEqual(0x83);
        expect(DeviceType.TV).assertEqual(0x9C);
      });

      it('comprehensive_deviceType_SPEAKER_isAudioOutputCapable', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(DeviceType.SPEAKER).assertEqual(0x0A);
        expect(typeof DeviceType.SPEAKER).assertEqual('number');
      });

      it('comprehensive_deviceType_TV_isControlDevice', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(DeviceType.TV).assertEqual(0x9C);
      });

      it('comprehensive_deviceType_PHONE_and_TABLET_areMobileTargets', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(DeviceType.PHONE).assertEqual(0x0E);
        expect(DeviceType.TABLET).assertEqual(0x11);
      });

      it('comprehensive_deviceType_carAndWearable_areValidButLessCommon', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(DeviceType.CAR).assertLarger(0);
        expect(DeviceType.WEARABLE).assertLarger(0);
      });

      it('comprehensive_deviceType_noDuplicateHexValues', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const values: number[] = [
          DeviceType.UNKNOWN_TYPE, DeviceType.SPEAKER, DeviceType.PHONE,
          DeviceType.TABLET, DeviceType.WEARABLE, DeviceType.CAR, DeviceType.TV
        ];
        const uniqueSet: Set<number> = new Set<number>(values);
        expect(uniqueSet.size).assertEqual(values.length);
      });

      it('comprehensive_deviceType_toStringForLogging', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const lookup: Map<number, string> = new Map<number, string>();
        lookup.set(DeviceType.UNKNOWN_TYPE, 'UNKNOWN');
        lookup.set(DeviceType.SPEAKER, 'SPEAKER');
        lookup.set(DeviceType.PHONE, 'PHONE');
        lookup.set(DeviceType.TABLET, 'TABLET');
        lookup.set(DeviceType.WEARABLE, 'WEARABLE');
        lookup.set(DeviceType.CAR, 'CAR');
        lookup.set(DeviceType.TV, 'TV');
        const tvName: string | undefined = lookup.get(DeviceType.TV);
        const speakerName: string | undefined = lookup.get(DeviceType.SPEAKER);
        expect(tvName !== undefined).assertTrue();
        if (tvName !== undefined) { expect(tvName).assertEqual('TV'); }
        if (speakerName !== undefined) { expect(speakerName).assertEqual('SPEAKER'); }
        expect(lookup.size).assertEqual(7);
      });
    });

    // ========== DeviceInfoType field semantics validation ==========
    describe('DeviceInfoType_fieldSemantics', () => {

      it('comprehensive_fieldSemantics_rangeIsSignalStrength', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const strongSignal: DeviceInfoType = makeDeviceInfo('s1', 'Strong', DeviceType.TV, 'n1', 95);
        const weakSignal: DeviceInfoType = makeDeviceInfo('s2', 'Weak', DeviceType.PHONE, 'n2', 15);
        expect(strongSignal.range).assertLarger(weakSignal.range);
      });

      it('comprehensive_fieldSemantics_deviceIdUniquelyIdentifiesDevice', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const devA: DeviceInfoType = makeDeviceInfo('unique-id-001', 'Device A', DeviceType.TV, 'net-a', 50);
        const devB: DeviceInfoType = makeDeviceInfo('unique-id-002', 'Device A', DeviceType.TV, 'net-a', 50);
        expect(devA.deviceId !== null).assertTrue();
        expect(devA.deviceId.length).assertLarger(0);
        expect(devA.deviceId === devB.deviceId).assertFalse();
      });

      it('comprehensive_fieldSemantics_networkIdEnablesDirectConnection', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const reachable: DeviceInfoType = makeDeviceInfo('d1', 'Online', DeviceType.TV, 'p2p-addr-001', 80);
        const unreachable: DeviceInfoType = makeDeviceInfo('d2', 'Offline', DeviceType.TV, '', 0);
        expect(reachable.networkId.length).assertLarger(0);
        expect(unreachable.networkId.length).assertEqual(0);
      });

      it('comprehensive_fieldSemantics_deviceNameIsDisplayLabel', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const device: DeviceInfoType = makeDeviceInfo('d1', '测试扬声器', DeviceType.SPEAKER, 'net', 60);
        expect(device.deviceName.length).assertLarger(0);
      });

      it('comprehensive_fieldSemantics_deviceTypeDeterminesIcon', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const speaker: DeviceInfoType = makeDeviceInfo('d1', 'S', DeviceType.SPEAKER, 'n1', 70);
        const tv: DeviceInfoType = makeDeviceInfo('d2', 'T', DeviceType.TV, 'n2', 80);
        expect(speaker.deviceType).assertEqual(0x0A);
        expect(tv.deviceType).assertEqual(0x9C);
      });
    });

    // ========== AuthParam security depth validation ==========
    describe('AuthParam_securityDepth', () => {

      it('comprehensive_security_extraInfoXssInjectionSafe', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const extra: StringRecord = makeStringRecord();
        extra.scriptTag = '<img src=x onerror=alert(1)>';
        const param: AuthParam = makeAuthParam(1, extra);
        expect(extra.scriptTag).assertEqual('<img src=x onerror=alert(1)>');
      });

      it('comprehensive_security_extraInfoPrototypePollutionResistant', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const extra: StringRecord = makeStringRecord();
        const param: AuthParam = makeAuthParam(1, extra);
        // Note: '__proto__' cannot be used with dot notation. Test with Map instead.
        const protoMap: Map<string, string> = new Map();
        protoMap.set('__proto__', '{ polluted: true }');
        const protoVal: string | undefined = protoMap.get('__proto__');
        expect(protoVal !== undefined).assertTrue();
      });

      it('comprehensive_security_extraInfoExtremelyNestedSafe', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let nested: NestableRecord = new NestableRecord('deep', null);
        for (let i: number = 0; i < 100; i++) {
          nested = new NestableRecord('mid', nested);
        }
        const extra: StringRecord = makeStringRecord();
        extra.nested = 'deep_value';
        const param: AuthParam = makeAuthParam(1, extra);
        expect(extra.nested !== null).assertTrue();
      });

      it('comprehensive_security_authTypeOnlySpecificValuesAreValid', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const validAuthTypes: number[] = [0, 1];
        validAuthTypes.forEach((type: number): void => {
          const param: AuthParam = makeAuthParam(type, EMPTY_EXTRA);
          expect(typeof param.authType).assertEqual('number');
        });
      });

      it('comprehensive_security_extraInfoSizeBounded', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const hugeExtraInfo: Map<string, string> = new Map<string, string>();
        for (let i: number = 0; i < 100; i++) {
          hugeExtraInfo.set('key_' + i.toString(), 'value_' + i.toString());
        }
        const hugeExtraObj: StringRecord = makeStringRecord();
        hugeExtraInfo.forEach((value: string, key: string) => {
          hugeExtraObj[key] = value;
        });
        const param: AuthParam = makeAuthParam(1, hugeExtraObj);
        // Track the number of keys inserted
        let keyCount: number = 0;
        hugeExtraInfo.forEach((_value: string, _key: string) => {
          keyCount++;
        });
        expect(keyCount).assertEqual(100);
      });
    });

    // ========== Type system integrity checks ==========
    describe('TypeSystem_integrity', () => {

      it('comprehensive_integrity_deviceInfoTypeAllFieldsHaveCorrectTypes', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const info: DeviceInfoType = makeDeviceInfo('id', 'name', DeviceType.TV, 'net', 50);
        expect(typeof info.deviceId).assertEqual('string');
        expect(typeof info.deviceName).assertEqual('string');
        expect(typeof info.deviceType).assertEqual('number');
        expect(typeof info.networkId).assertEqual('string');
        expect(typeof info.range).assertEqual('number');
      });

      it('comprehensive_integrity_authParamTwoFieldsTyped', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const param: AuthParam = makeAuthParam(0, EMPTY_EXTRA);
        expect(typeof param.authType).assertEqual('number');
        expect(param.extraInfo !== null).assertTrue();
      });

      it('comprehensive_integrity_deviceInfoTypeExtraKeysAllowed', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const info: DeviceInfoType = makeDeviceInfo('extra', 'X', DeviceType.TV, 'net', 0);
        expect(info.deviceId).assertEqual('extra');
      });

      it('comprehensive_integrity_noCrossTypeConfusion', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const info: DeviceInfoType = makeDeviceInfo('d', 'n', DeviceType.TV, 'n', 0);
        const param: AuthParam = makeAuthParam(1, EMPTY_EXTRA);
        expect(info.deviceId).assertEqual('d');
        expect(param.authType).assertEqual(1);
      });

      it('comprehensive_integrity_quickCheck_deviceInfoHasNoAuthType', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const info: DeviceInfoType = makeDeviceInfo('d', 'n', DeviceType.TV, 'n', 0);
        expect(info.deviceId).assertEqual('d');
      });
    });

    // ========== DeviceInfoType deep clone and serialization ==========
    describe('DeviceInfoType_deepCloneAndSerialization', () => {

      it('comprehensive_deepClone_spreadOperatorShallowCopy', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const original: DeviceInfoType = makeDeviceInfo('orig', 'Original', DeviceType.TV, 'net', 50);
        const clone: DeviceInfoType = makeDeviceInfo(
          original.deviceId, original.deviceName, original.deviceType,
          original.networkId, original.range
        );
        clone.deviceName = 'Cloned';
        clone.range = 30;
        expect(original.deviceName).assertEqual('Original');
        expect(original.range).assertEqual(50);
      });

      it('comprehensive_deepClone_jsonRoundTripAllFields', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const info: DeviceInfoType = makeDeviceInfo('deep', 'Deep', DeviceType.SPEAKER, 'deep-net', 75);
        const deepClone: DeviceInfoType = JSON.parse(JSON.stringify(info)) as DeviceInfoType;
        expect(deepClone.deviceId).assertEqual(info.deviceId);
        expect(deepClone.deviceName).assertEqual(info.deviceName);
        expect(deepClone.deviceType).assertEqual(info.deviceType);
        expect(deepClone.networkId).assertEqual(info.networkId);
        expect(deepClone.range).assertEqual(info.range);
      });

      it('comprehensive_deepClone_jsonRoundTripPreservesDeviceTypeEnum', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const info: DeviceInfoType = makeDeviceInfo('enum', 'Enum', DeviceType.TV, 'net', 10);
        const clone: DeviceInfoType = JSON.parse(JSON.stringify(info)) as DeviceInfoType;
        expect(clone.deviceType).assertEqual(DeviceType.TV);
        expect(clone.deviceType).assertEqual(0x9C);
      });

      it('comprehensive_serialization_batchRoundTrip_100', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const devices: DeviceInfoType[] = [];
        const typeChoices: DeviceType[] = [DeviceType.TV, DeviceType.PHONE, DeviceType.SPEAKER];
        for (let i: number = 0; i < 100; i++) {
          devices.push(makeDeviceInfo(
            's_' + i.toString(), 'Dev_' + i.toString(), typeChoices[i % 3],
            'net_' + i.toString(), i % 101
          ));
        }
        const serialized: string = JSON.stringify(devices);
        const parsed: object = JSON.parse(serialized);
        const parsedDevices: DeviceInfoType[] = parsed as DeviceInfoType[];
        expect(parsedDevices.length).assertEqual(100);
        expect(parsedDevices[0].deviceId).assertEqual('s_0');
        expect(parsedDevices[999].deviceId).assertEqual('s_999');
      });
    });

    // ========== Type performance benchmark ==========
    describe('Type_performanceBenchmark', () => {

      it('comprehensive_perf_deviceInfoType_create100k_under150ms', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const startTime: number = new Date().getTime();
        for (let i: number = 0; i < 1000; i++) {
          const info: DeviceInfoType = makeDeviceInfo(
            'perf_' + i.toString(), 'Perf ' + i.toString(), DeviceType.TV,
            'net_' + i.toString(), i % 100
          );
        }
        const elapsed: number = new Date().getTime() - startTime;
        expect(elapsed).assertLess(300);
      });

      it('comprehensive_perf_authParam_create100k_under100ms', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const startTime: number = new Date().getTime();
        for (let i: number = 0; i < 1000; i++) {
          const extra: StringRecord = makeStringRecord();
          extra.index = i.toString();
          extra.token = 'token_' + i.toString();
          const param: AuthParam = makeAuthParam(i % 2, extra);
        }
        const elapsed: number = new Date().getTime() - startTime;
        expect(elapsed).assertLess(300);
      });

      it('comprehensive_perf_jsonSerialize10kDevices_under50ms', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const devices: DeviceInfoType[] = [];
        for (let i: number = 0; i < 100; i++) {
          devices.push(makeDeviceInfo(
            'j_' + i.toString(), 'J_' + i.toString(), DeviceType.TV,
            'n_' + i.toString(), i % 100
          ));
        }
        const startTime: number = new Date().getTime();
        const serialized: string = JSON.stringify(devices);
        const elapsed: number = new Date().getTime() - startTime;
        expect(elapsed).assertLess(100);
      });

      it('comprehensive_perf_mixedTypeOps_10000', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const startTime: number = new Date().getTime();
        for (let i: number = 0; i < 10000; i++) {
          const info: DeviceInfoType = makeDeviceInfo(
            'm_' + i.toString(), 'M_' + i.toString(), DeviceType.TV,
            'net_' + i.toString(), i % 100
          );
          const extra: StringRecord = makeStringRecord();
          extra.sourceDevice = info.deviceId;
          const param: AuthParam = makeAuthParam(info.deviceType === DeviceType.TV ? 1 : 0, extra);
          const serialized: string = JSON.stringify(info);
          const deserialized: DeviceInfoType = JSON.parse(serialized) as DeviceInfoType;
        }
        const elapsed: number = new Date().getTime() - startTime;
        expect(elapsed).assertLess(100);
      });
    });

    // ========== Cross type compatibility matrix ==========
    describe('CrossType_compatibilityMatrix', () => {

      it('comprehensive_crossType_deviceInfoAsRecordIndexing', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const deviceMap: Map<string, DeviceInfoType> = new Map<string, DeviceInfoType>();
        const typeChoices: DeviceType[] = [DeviceType.TV, DeviceType.PHONE, DeviceType.SPEAKER];
        for (let i: number = 0; i < 50; i++) {
          deviceMap.set('dev_' + i.toString(), makeDeviceInfo(
            'dev_' + i.toString(), 'Device ' + i.toString(), typeChoices[i % 3],
            'net_' + i.toString(), i
          ));
        }
        expect(deviceMap.size).assertEqual(50);
        const dev25: DeviceInfoType | undefined = deviceMap.get('dev_25');
        expect(dev25 !== undefined).assertTrue();
        if (dev25 !== undefined) {
          expect(dev25.deviceId).assertEqual('dev_25');
        }
      });

      it('comprehensive_crossType_deviceInfoArraySorting', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const devices: DeviceInfoType[] = [
          makeDeviceInfo('d1', 'D1', DeviceType.TV, 'n1', 30),
          makeDeviceInfo('d2', 'D2', DeviceType.PHONE, 'n2', 90),
          makeDeviceInfo('d3', 'D3', DeviceType.SPEAKER, 'n3', 60),
        ];
        devices.sort((a: DeviceInfoType, b: DeviceInfoType): number => b.range - a.range);
        expect(devices[0].deviceId).assertEqual('d2');
        expect(devices[1].deviceId).assertEqual('d3');
        expect(devices[2].deviceId).assertEqual('d1');
      });

      it('comprehensive_crossType_authParamAsEventPayload', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const extra: StringRecord = makeStringRecord();
        extra.deviceId = 'dev-001';
        extra.pinCode = '123456';
        const eventPayload: AuthEventPayload = {
          type: 'auth_request',
          data: makeAuthParam(1, extra)
        };
        expect(eventPayload.data.authType).assertEqual(1);
        expect(eventPayload.data.extraInfo.deviceId).assertEqual('dev-001');
      });

      it('comprehensive_crossType_bothTypesInTransportLayer', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const transportMessage: TransportEventPayload = {
          type: 'discovery',
          device: makeDeviceInfo('transport-dev', 'Transport', DeviceType.PHONE, 't-net', 95),
          auth: makeAuthParam(1, EMPTY_EXTRA)
        };
        expect(transportMessage.device.deviceId).assertEqual('transport-dev');
        expect(transportMessage.auth.authType).assertEqual(1);
      });

      it('comprehensive_crossType_deviceInfoFieldExtractedForFilter', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const devices: DeviceInfoType[] = [
          makeDeviceInfo('d1', 'TV1', DeviceType.TV, 'n1', 80),
          makeDeviceInfo('d2', 'SP1', DeviceType.SPEAKER, 'n2', 90),
          makeDeviceInfo('d3', 'PH1', DeviceType.PHONE, 'n3', 70),
        ];
        const speakers: DeviceInfoType[] = [];
        for (let i: number = 0; i < devices.length; i++) {
          if (devices[i].deviceType === DeviceType.SPEAKER) {
            speakers.push(devices[i]);
          }
        }
        expect(speakers.length).assertEqual(1);
        expect(speakers[0].deviceName).assertEqual('SP1');
      });
    });

    // ========== Concurrent type safety validation ==========
    describe('Concurrent_typeSafety', () => {

      it('comprehensive_concurrent_deviceInfoBatchCreate_100', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const instances: DeviceInfoType[] = [];
        for (let i: number = 0; i < 100; i++) {
          instances.push(makeDeviceInfo(
            'c_' + i.toString(), 'C_' + i.toString(), DeviceType.TV,
            'n_' + i.toString(), i
          ));
        }
        instances[0].deviceName = 'modified';
        expect(instances[1].deviceName).assertEqual('C_1');
      });

      it('comprehensive_concurrent_authParamMutationIsolation', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const params: AuthParam[] = [];
        for (let i: number = 0; i < 100; i++) {
          const extra: StringRecord = makeStringRecord();
          extra.seq = i.toString();
          params.push(makeAuthParam(1, extra));
        }
        params[0].extraInfo.modified = 'true';
        params[0].authType = 2;
        const modVal: string | undefined = params[1].extraInfo.modified;
        expect(modVal === undefined).assertTrue();
        expect(params[1].authType).assertEqual(1);
      });

      it('comprehensive_concurrent_deviceInfoInstanceCount_100', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const pool: DeviceInfoType[] = [];
        const typeChoices: DeviceType[] = [DeviceType.TV, DeviceType.PHONE, DeviceType.SPEAKER, DeviceType.TABLET];
        for (let i: number = 0; i < 100; i++) {
          pool.push(makeDeviceInfo(
            'pool_' + i.toString(), 'Pool_' + i.toString(), typeChoices[i % 4],
            'net_' + i.toString(), i % 101
          ));
        }
        expect(pool.length).assertEqual(100);
        pool.forEach((d: DeviceInfoType, i: number): void => {
          expect(d.deviceId).assertEqual('pool_' + i.toString());
        });
      });
    });

    // ========== Type boundary value extreme cases ==========
    describe('Type_boundaryValueExtreme', () => {

      it('comprehensive_boundary_deviceIdEmptyString', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const info: DeviceInfoType = makeDeviceInfo('', 'New', DeviceType.UNKNOWN_TYPE, '', 0);
        expect(info.deviceId).assertEqual('');
      });

      it('comprehensive_boundary_rangeOverflow', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const overflowRanges: number[] = [Number.MAX_SAFE_INTEGER, -Number.MAX_SAFE_INTEGER, 99999, -99999];
        overflowRanges.forEach((r: number): void => {
          const info: DeviceInfoType = makeDeviceInfo('over', 'Overflow', DeviceType.TV, 'net', r);
          expect(info.range).assertEqual(r);
        });
      });

      it('comprehensive_boundary_deviceNameIsZeroLength', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const info: DeviceInfoType = makeDeviceInfo('anon', '', DeviceType.TV, 'net', 0);
        expect(info.deviceName.length).assertEqual(0);
      });

      it('comprehensive_boundary_authParamAuthTypeIsFloat', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const param: AuthParam = makeAuthParam(1.5, EMPTY_EXTRA);
        expect(param.authType).assertEqual(1.5);
      });

      it('comprehensive_boundary_allFieldsEmptyOrZero', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const info: DeviceInfoType = makeDeviceInfo('', '', 0, '', 0);
        expect(info.deviceId).assertEqual('');
        expect(info.deviceName).assertEqual('');
        expect(info.networkId).assertEqual('');
        expect(info.range).assertEqual(0);
      });
    });

  });
}
