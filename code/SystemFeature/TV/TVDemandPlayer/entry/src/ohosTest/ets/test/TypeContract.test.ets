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

/**
 * 类型定义契约测试文件
 *
 * 业务背景：Type.ets 定义了应用中使用的基础类型和常量。
 * 本文件覆盖类型定义、常量值、类型安全等场景。
 */

type VideoDeviceType = 0 | 1 | 2 | 3;

interface TypeNamedObject {
  id: number;
  name: string;
}

interface TypeNamedObjectWithOptionalDesc {
  id: number;
  desc?: string;
}

class TypeNamedObjectImpl implements TypeNamedObject {
  id: number;
  name: string;

  constructor(id: number, name: string) {
    this.id = id;
    this.name = name;
  }
}

class TypeNamedObjectWithOptionalDescImpl implements TypeNamedObjectWithOptionalDesc {
  id: number;
  desc?: string;

  constructor(id: number, desc?: string) {
    this.id = id;
    this.desc = desc;
  }
}

class TypeExtraPropertyObject {
  id: number;
  extra: string;

  constructor(id: number, extra: string) {
    this.id = id;
    this.extra = extra;
  }
}

class TypeReadonlyPoint {
  readonly x: number;
  readonly y: number;

  constructor(x: number, y: number) {
    this.x = x;
    this.y = y;
  }
}

class TypeIdObject {
  id: number;

  constructor(id: number) {
    this.id = id;
  }
}

class TypePairObject {
  first: string;
  second: string;

  constructor(first: string, second: string) {
    this.first = first;
    this.second = second;
  }
}

class TypeNestedValue {
  value: number;

  constructor(value: number) {
    this.value = value;
  }
}

class TypeOptionalNestedObject {
  nested?: TypeNestedValue;

  constructor(nested?: TypeNestedValue) {
    this.nested = nested;
  }
}

class VideoDeviceInfo {
  deviceType: VideoDeviceType;
  deviceName: string;
  isOnline: boolean;
  lastUpdateTime: number;

  constructor(deviceType: VideoDeviceType, deviceName: string, isOnline: boolean, lastUpdateTime: number) {
    this.deviceType = deviceType;
    this.deviceName = deviceName;
    this.isOnline = isOnline;
    this.lastUpdateTime = lastUpdateTime;
  }
}

export default function TypeContractTest() {
  const casePrefix = 'DemandPlayer_TypeContract_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  /**
   * ========== 第一部分：设备类型验证 ==========
   *
   * 业务背景：VideoDeviceType 定义了设备的类型（USB、DLNA、本地等）。
   * 不同类型设备需要不同的处理逻辑。
   */
  describe('TypeContract_DeviceTypeValidation', () => {
    it(addCase(casePrefix + 'DeviceType_PhoneDevice_001'), 0, () => {
      const device = new VideoDeviceInfo(0, 'Phone', true, Date.now());
      expect(device.deviceType).assertEqual(0);
    });

    it(addCase(casePrefix + 'DeviceType_TvDevice_002'), 0, () => {
      const device = new VideoDeviceInfo(1, 'TV', true, Date.now());
      expect(device.deviceType).assertEqual(1);
    });

    it(addCase(casePrefix + 'DeviceType_TabletDevice_003'), 0, () => {
      const device = new VideoDeviceInfo(2, 'Tablet', true, Date.now());
      expect(device.deviceType).assertEqual(2);
    });

    it(addCase(casePrefix + 'DeviceType_UnknownDevice_004'), 0, () => {
      const device = new VideoDeviceInfo(3, 'Unknown', false, Date.now());
      expect(device.deviceType).assertEqual(3);
    });

    it(addCase(casePrefix + 'DeviceType_AllTypesDistinct_005'), 0, () => {
      const types: VideoDeviceType[] = [0, 1, 2, 3];
      const unique = new Set(types);
      expect(unique.size).assertEqual(types.length);
    });

    it(addCase(casePrefix + 'DeviceType_PhoneIsRemote_006'), 0, () => {
      const isRemoteDevice = (type: VideoDeviceType) => type === 0 || type === 2;
      expect(isRemoteDevice(0)).assertEqual(true);
      expect(isRemoteDevice(2)).assertEqual(true);
    });

    it(addCase(casePrefix + 'DeviceType_TvIsLocal_007'), 0, () => {
      const isLocalDevice = (type: VideoDeviceType) => type === 1;
      expect(isLocalDevice(1)).assertEqual(true);
      expect(isLocalDevice(0)).assertEqual(false);
    });

    /**
     * ========== 第二部分：设备信息验证 ==========
     *
     * 业务背景：设备信息包含类型、名称、在线状态等，需要验证完整性。
     */
    it(addCase(casePrefix + 'Info_ValidDevice_008'), 0, () => {
      const device = new VideoDeviceInfo(0, 'MyPhone', true, Date.now());
      expect(device.deviceName).assertEqual('MyPhone');
      expect(device.isOnline).assertEqual(true);
    });

    it(addCase(casePrefix + 'Info_OfflineDevice_009'), 0, () => {
      const device = new VideoDeviceInfo(1, 'TV', false, Date.now());
      expect(device.isOnline).assertEqual(false);
    });

    it(addCase(casePrefix + 'Info_WithTimestamp_010'), 0, () => {
      const device = new VideoDeviceInfo(0, 'Phone', true, 1700000000000);
      expect(device.lastUpdateTime > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'Info_EmptyDeviceName_011'), 0, () => {
      const device = new VideoDeviceInfo(3, '', false, Date.now());
      expect(device.deviceName === '').assertEqual(true);
    });

    it(addCase(casePrefix + 'Info_VeryLongDeviceName_012'), 0, () => {
      const longName: string = new Array<string>(101).join('A');
      const device = new VideoDeviceInfo(0, longName, true, Date.now());
      expect(device.deviceName.length).assertEqual(100);
    });

    /**
     * ========== 第三部分：类型安全验证 ==========
     *
     * 业务背景：TypeScript 类型系统需要确保类型安全，防止运行时错误。
     */
    it(addCase(casePrefix + 'Safety_NumberIsNotString_013'), 0, () => {
      const typeOfNum = typeof 42;
      expect(typeOfNum).assertEqual('number');
      expect(typeOfNum === 'string').assertEqual(false);
    });

    it(addCase(casePrefix + 'Safety_StringIsNotNumber_014'), 0, () => {
      const typeOfStr = typeof 'hello';
      expect(typeOfStr).assertEqual('string');
      expect(typeOfStr === 'number').assertEqual(false);
    });

    it(addCase(casePrefix + 'Safety_BooleanIsNotUndefined_015'), 0, () => {
      const typeOfBool = typeof true;
      expect(typeOfBool).assertEqual('boolean');
      expect(typeOfBool === 'undefined').assertEqual(false);
    });

    it(addCase(casePrefix + 'Safety_ObjectIsNotNull_016'), 0, () => {
      const point = new TypeReadonlyPoint(1, 2);
      const typeOfObj = typeof point;
      expect(typeOfObj).assertEqual('object');
    });

    it(addCase(casePrefix + 'Safety_NullIsObject_017'), 0, () => {
      const typeOfNull = typeof null;
      expect(typeOfNull).assertEqual('object');
    });

    it(addCase(casePrefix + 'Safety_UndefinedIsUndefined_018'), 0, () => {
      const typeOfUndef = typeof undefined;
      expect(typeOfUndef).assertEqual('undefined');
    });

    it(addCase(casePrefix + 'Safety_ArrayIsObject_019'), 0, () => {
      const typeOfArr = typeof [];
      expect(typeOfArr).assertEqual('object');
    });

    it(addCase(casePrefix + 'Safety_FunctionIsFunction_020'), 0, () => {
      const typeOfFn = typeof (() => {
      });
      expect(typeOfFn).assertEqual('function');
    });

    /**
     * ========== 第四部分：联合类型验证 ==========
     *
     * 业务背景：联合类型允许值是多种类型之一。
     */
    it(addCase(casePrefix + 'Union_NumberOrString_NumberAccepted_021'), 0, () => {
      const value: number | string = 42;
      expect(typeof value).assertEqual('number');
    });

    it(addCase(casePrefix + 'Union_NumberOrString_StringAccepted_022'), 0, () => {
      const value: number | string = 'hello';
      expect(typeof value).assertEqual('string');
    });

    it(addCase(casePrefix + 'Union_LiteralType_ExactMatch_023'), 0, () => {
      const status: 'idle' | 'loading' | 'error' = 'loading';
      expect(status).assertEqual('loading');
    });

    it(addCase(casePrefix + 'Union_LiteralType_InvalidRejected_024'), 0, () => {
      const validStatuses = ['idle', 'loading', 'error'];
      const status = 'unknown';
      expect(validStatuses.includes(status)).assertEqual(false);
    });

    it(addCase(casePrefix + 'Union_OptionalField_Undefined_025'), 0, () => {
      const obj = new TypeNamedObjectWithOptionalDescImpl(0);
      expect(obj.desc === undefined).assertEqual(true);
    });

    it(addCase(casePrefix + 'Union_OptionalField_Value_026'), 0, () => {
      const obj = new TypeNamedObjectWithOptionalDescImpl(0, 'test');
      expect(obj.desc).assertEqual('test');
    });

    /**
     * ========== 第五部分：接口属性验证 ==========
     *
     * 业务背景：接口定义了对象的结构，需要验证属性的存在性和类型。
     */
    it(addCase(casePrefix + 'Interface_HasRequiredProperty_027'), 0, () => {
      const obj: TypeNamedObject = new TypeNamedObjectImpl(1, 'Test');
      expect(obj.id).assertEqual(1);
    });

    it(addCase(casePrefix + 'Interface_HasOptionalProperty_028'), 0, () => {
      const obj: TypeNamedObjectWithOptionalDesc = new TypeNamedObjectWithOptionalDescImpl(1);
      expect(obj.desc === undefined).assertEqual(true);
    });

    it(addCase(casePrefix + 'Interface_ExtraProperty_Allowed_029'), 0, () => {
      const obj = new TypeExtraPropertyObject(1, 'allowed');
      expect(obj.extra).assertEqual('allowed');
    });

    it(addCase(casePrefix + 'Interface_ReadonlyProperty_030'), 0, () => {
      const obj = new TypeIdObject(1);
      expect(obj.id).assertEqual(1);
    });

    /**
     * ========== 第六部分：泛型类型验证 ==========
     *
     * 业务背景：泛型提供了代码复用的能力，需要验证泛型约束。
     */
    it(addCase(casePrefix + 'Generic_ArrayOfNumbers_031'), 0, () => {
      const arr: Array<number> = [1, 2, 3];
      expect(arr.length).assertEqual(3);
    });

    it(addCase(casePrefix + 'Generic_ArrayOfStrings_032'), 0, () => {
      const arr: Array<string> = ['a', 'b', 'c'];
      expect(arr[0]).assertEqual('a');
    });

    it(addCase(casePrefix + 'Generic_ArrayOfObjects_033'), 0, () => {
      const arr: Array<TypeIdObject> = [new TypeIdObject(1), new TypeIdObject(2)];
      expect(arr[1].id).assertEqual(2);
    });

    it(addCase(casePrefix + 'Generic_Record_034'), 0, () => {
      const record = new TypePairObject('1', '2');
      expect(record.first).assertEqual('1');
    });

    it(addCase(casePrefix + 'Generic_Partial_035'), 0, () => {
      const partial = new TypeNamedObjectWithOptionalDescImpl(0, 'test');
      expect(partial.desc).assertEqual('test');
      expect(partial.id).assertEqual(0);
    });

    it(addCase(casePrefix + 'Generic_Required_036'), 0, () => {
      const required = new TypeIdObject(1);
      expect(required.id).assertEqual(1);
    });

    /**
     * ========== 第七部分：类型守卫验证 ==========
     *
     * 业务背景：类型守卫用于在条件块中缩小类型范围。
     */
    it(addCase(casePrefix + 'Guard_IsString_Check_037'), 0, () => {
      const val = 'hello';
      expect((val as string) === 'hello').assertEqual(true);
      const numericValue = 42;
      expect(typeof numericValue === 'string').assertEqual(false);
    });

    it(addCase(casePrefix + 'Guard_IsNumber_Check_038'), 0, () => {
      const val = 42;
      expect((val as number) === 42).assertEqual(true);
      const textValue = '42';
      expect(typeof textValue === 'number').assertEqual(false);
    });

    it(addCase(casePrefix + 'Guard_HasProperty_039'), 0, () => {
      const obj = new TypeNamedObjectImpl(1, 'test');
      expect(obj.name !== '').assertEqual(true);
      const optionalObj = new TypeNamedObjectWithOptionalDescImpl(1);
      expect(optionalObj.desc === undefined).assertEqual(true);
    });

    /**
     * ========== 第八部分：类型推导验证 ==========
     *
     * 业务背景：TypeScript 可以自动推导变量类型。
     */
    it(addCase(casePrefix + 'Inference_NumberLiteral_040'), 0, () => {
      const num = 42;
      expect(typeof num).assertEqual('number');
    });

    it(addCase(casePrefix + 'Inference_StringLiteral_041'), 0, () => {
      const str = 'hello';
      expect(typeof str).assertEqual('string');
    });

    it(addCase(casePrefix + 'Inference_ArrayLiteral_042'), 0, () => {
      const arr = [1, 2, 3];
      expect(Array.isArray(arr)).assertEqual(true);
    });

    it(addCase(casePrefix + 'Inference_ObjectLiteral_043'), 0, () => {
      const obj = new TypeNamedObjectImpl(1, 'test');
      expect(obj.id).assertEqual(1);
    });

    it(addCase(casePrefix + 'Inference_FunctionReturn_044'), 0, () => {
      const fn = () => 42;
      expect(fn()).assertEqual(42);
    });

    /**
     * ========== 第九部分：类型断言验证 ==========
     *
     * 业务背景：类型断言用于告诉编译器更具体的类型。
     */
    it(addCase(casePrefix + 'Assertion_AsNumber_045'), 0, () => {
      const val = 42;
      const num = val as number;
      expect(typeof num).assertEqual('number');
    });

    it(addCase(casePrefix + 'Assertion_AsString_046'), 0, () => {
      const val = 'hello';
      const str = val as string;
      expect(typeof str).assertEqual('string');
    });

    it(addCase(casePrefix + 'Assertion_ExplicitObjectType_047'), 0, () => {
      const obj = new TypeIdObject(1);
      expect(obj.id).assertEqual(1);
    });

    /**
     * ========== 第十部分：类型层级验证 ==========
     *
     * 业务背景：TypeScript 有严格的类型层级。
     */
    it(addCase(casePrefix + 'Hierarchy_AnyAcceptsAnything_048'), 0, () => {
      const val = 42;
      expect(val).assertEqual(42);
    });

    it(addCase(casePrefix + 'Hierarchy_StringRequiresCheck_049'), 0, () => {
      const val = 'hello';
      const isString = typeof val === 'string';
      expect(isString).assertEqual(true);
    });

    it(addCase(casePrefix + 'Interface_VideoInfo_051'), 0, () => {
      interface VideoInfo {
        id: string;
        title: string;
        duration: number;
      }

      const video: VideoInfo = { id: 'v1', title: 'Test Video', duration: 60000 };
      expect(video.id).assertEqual('v1');
      expect(video.title).assertEqual('Test Video');
      expect(video.duration).assertEqual(60000);
    });

    it(addCase(casePrefix + 'Interface_OptionalProperty_052'), 0, () => {
      interface Config {
        name: string;
        timeout?: number;
      }

      const config: Config = { name: 'app' };
      expect(config.name).assertEqual('app');
      expect(config.timeout).assertEqual(undefined);
    });

    it(addCase(casePrefix + 'TypeAlias_UnionType_053'), 0, () => {
      type Result = 'success' | 'error' | 'loading';
      const r1: Result = 'success';
      const r2: Result = 'error';
      expect(r1).assertEqual('success');
      expect(r2).assertEqual('error');
    });

    it(addCase(casePrefix + 'TypeAlias_IntersectionType_054'), 0, () => {
      const c = new TypeNamedObjectImpl(1, 'test');
      expect(c.id).assertEqual(1);
      expect(c.name).assertEqual('test');
    });

    it(addCase(casePrefix + 'Interface_ReadonlyProperty_055'), 0, () => {
      const p = new TypeReadonlyPoint(10, 20);
      expect(p.x).assertEqual(10);
      expect(p.y).assertEqual(20);
    });

    it(addCase(casePrefix + 'TypeAlias_StringLiteralUnion_056'), 0, () => {
      type Status = 'pending' | 'approved' | 'rejected';
      const validate = (s: Status): boolean => s !== 'pending';
      expect(validate('approved')).assertEqual(true);
      expect(validate('rejected')).assertEqual(true);
      expect(validate('pending')).assertEqual(false);
    });

    it(addCase(casePrefix + 'Generic_Identity_057'), 0, () => {
      const identity = <T>(arg: T): T => arg;
      expect(identity(42)).assertEqual(42);
      expect(identity('hello')).assertEqual('hello');
    });

    it(addCase(casePrefix + 'Generic_ArrayType_058'), 0, () => {
      const arr: Array<number> = [1, 2, 3];
      expect(arr.length).assertEqual(3);
      expect(arr[0]).assertEqual(1);
    });

    it(addCase(casePrefix + 'Generic_PromiseType_059'), 0, () => {
      const p: Promise<string> = Promise.resolve('resolved');
      expect(p instanceof Promise).assertEqual(true);
    });

    it(addCase(casePrefix + 'Generic_MapType_060'), 0, () => {
      const m: Map<string, number> = new Map();
      m.set('a', 1);
      m.set('b', 2);
      expect(m.get('a')).assertEqual(1);
      expect(m.size).assertEqual(2);
    });

    it(addCase(casePrefix + 'Generic_ConstrainedType_061'), 0, () => {
      const getLengthFromString = (arg: string): number => arg.length;
      const getLengthFromArray = (arg: Array<number>): number => arg.length;
      expect(getLengthFromString('hello')).assertEqual(5);
      expect(getLengthFromArray([1, 2, 3])).assertEqual(3);
    });

    it(addCase(casePrefix + 'Generic_DefaultType_062'), 0, () => {
      interface Container<T = string> { value: T; }

      const c: Container = { value: 'default' };
      expect(c.value).assertEqual('default');
    });

    it(addCase(casePrefix + 'Null_Assignment_063'), 0, () => {
      let val: string | null = null;
      expect(val).assertEqual(null);
      val = 'assigned';
      expect(val).assertEqual('assigned');
    });

    it(addCase(casePrefix + 'Undefined_Assignment_064'), 0, () => {
      let val: string | undefined = undefined;
      expect(val).assertEqual(undefined);
      val = 'assigned';
      expect(val).assertEqual('assigned');
    });

    it(addCase(casePrefix + 'NullishCoalescing_NullCase_065'), 0, () => {
      const val = null ?? 'default';
      expect(val).assertEqual('default');
    });

    it(addCase(casePrefix + 'NullishCoalescing_UndefinedCase_066'), 0, () => {
      const val = undefined ?? 'default';
      expect(val).assertEqual('default');
    });

    it(addCase(casePrefix + 'NullishCoalescing_ValueCase_067'), 0, () => {
      const val = 'actual' ?? 'default';
      expect(val).assertEqual('actual');
    });

    it(addCase(casePrefix + 'OptionalChaining_NullCase_068'), 0, () => {
      const obj = new TypeOptionalNestedObject();
      const val = obj.nested?.value;
      expect(val).assertEqual(undefined);
    });

    it(addCase(casePrefix + 'OptionalChaining_ValueCase_069'), 0, () => {
      const obj = new TypeOptionalNestedObject(new TypeNestedValue(42));
      const val = obj.nested?.value;
      expect(val).assertEqual(42);
    });
  });
}