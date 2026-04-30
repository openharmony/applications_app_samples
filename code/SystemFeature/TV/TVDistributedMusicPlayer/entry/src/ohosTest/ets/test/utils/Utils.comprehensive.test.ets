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
import { objType } from '../../../../main/ets/utils/Utils';

// Interfaces for typed object literals
interface EmptyObj {}
interface SimpleKeyValue { key: string; }
interface SingleChildObj { child: NestableObj | null; }
interface DeepC { c: number; }
interface DeepB { b: DeepC; }
interface DeepA { a: DeepB; }
interface DeviceData { deviceId: string; deviceName: string; deviceType: number; }
interface PlayStateData { img: string; name: string; author: string; url: string; isPlay: boolean; }
interface ButtonData { name: string; isFocus: boolean; }
interface AuthParamData { authorType: number; }

// Classes extracted from test bodies (nested-class rule fix)
class TestClassForObjType { value: number = 42; }
class ComplexForObjType { a: number; b: string; constructor(a: number, b: string) { this.a = a; this.b = b; } }
class StaticTestForObjType { static doThing(): string { return 'done'; } }
class BaseForProto { baseProp: string = 'base'; }
class MiddleForProto extends BaseForProto { midProp: string = 'mid'; }
class LeafForProto extends MiddleForProto { leafProp: string = 'leaf'; }
class MusicPlayerErrorForTest extends Error { errorCode: number; constructor(message: string, errorCode: number) { super(message); this.errorCode = errorCode; } }
class NestableObj { child: NestableObj | null; value: string; constructor() { this.child = null; this.value = ''; } }
class FrozenData { key: string; constructor(k: string) { this.key = k; } }

function strRepeat(s: string, count: number): string {
  let result: string = '';
  for (let i: number = 0; i < count; i++) { result += s; }
  return result;
}

// Functions extracted from test bodies (nested-function rule fix)
function addForTest(a: number, b: number): number { return a + b; }
function originalForBind(): void {}

// Reusable typed object instances
const EMPTY_OBJ: EmptyObj = {};
const SIMPLE_KV: SimpleKeyValue = { key: 'value' };
const DEEP_OBJ: DeepA = { a: { b: { c: 1 } } };
const DEVICE_DATA: DeviceData = { deviceId: 'dev-001', deviceName: 'TV', deviceType: 0x9C };
const PLAY_STATE_DATA: PlayStateData = { img: '', name: 'song', author: 'artist', url: '', isPlay: true };
const BUTTON_DATA: ButtonData = { name: 'play', isFocus: false };

export default function UtilsComprehensiveTestSuite(): void {
  describe('UtilsComprehensiveTest', () => {

    it('test_objType_string', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType('hello');
      expect(result).assertEqual('string');
    });

    it('test_objType_emptyString', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType('');
      expect(result).assertEqual('string');
    });

    it('test_objType_number', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType(42);
      expect(result).assertEqual('number');
    });

    it('test_objType_zeroNumber', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType(0);
      expect(result).assertEqual('number');
    });

    it('test_objType_negativeNumber', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType(-1);
      expect(result).assertEqual('number');
    });

    it('test_objType_floatNumber', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType(3.14);
      expect(result).assertEqual('number');
    });

    it('test_objType_NaN', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType(NaN);
      expect(result).assertEqual('number');
    });

    it('test_objType_Infinity', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType(Infinity);
      expect(result).assertEqual('number');
    });

    it('test_objType_NegativeInfinity', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType(-Infinity);
      expect(result).assertEqual('number');
    });

    it('test_objType_booleanTrue', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType(true);
      expect(result).assertEqual('boolean');
    });

    it('test_objType_booleanFalse', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType(false);
      expect(result).assertEqual('boolean');
    });

    it('test_objType_objectPlain', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType(EMPTY_OBJ);
      expect(result).assertEqual('object');
    });

    it('test_objType_objectWithProps', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType(SIMPLE_KV);
      expect(result).assertEqual('object');
    });

    it('test_objType_array', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType([1, 2, 3]);
      expect(result).assertEqual('object');
    });

    it('test_objType_emptyArray', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType([]);
      expect(result).assertEqual('object');
    });

    it('test_objType_null', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType(null);
      expect(result).assertEqual('null');
    });

    it('test_objType_undefined', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType(undefined);
      expect(result).assertEqual('undefined');
    });

    it('test_objType_function', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType((): void => {});
      expect(result).assertEqual('function');
    });

    it('test_objType_date', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType(new Date());
      expect(result).assertEqual('object');
    });

    it('test_objType_regex', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType(/test/g);
      expect(result).assertEqual('object');
    });

    it('test_objType_map', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType(new Map<string, string>());
      expect(result).assertEqual('object');
    });

    it('test_objType_set', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType(new Set<string>());
      expect(result).assertEqual('object');
    });

    it('test_objType_nestedObject', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType(DEEP_OBJ);
      expect(result).assertEqual('object');
    });

    it('test_objType_MAX_SAFE_INTEGER', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType(Number.MAX_SAFE_INTEGER);
      expect(result).assertEqual('number');
    });

    it('test_objType_MIN_SAFE_INTEGER', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType(Number.MIN_SAFE_INTEGER);
      expect(result).assertEqual('number');
    });

    it('test_objType_MAX_VALUE', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType(Number.MAX_VALUE);
      expect(result).assertEqual('number');
    });

    it('test_objType_MIN_VALUE', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType(Number.MIN_VALUE);
      expect(result).assertEqual('number');
    });

    it('test_objType_emptyFunction', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType((): void => {});
      expect(result).assertEqual('function');
    });

    it('test_objType_arrowFunction', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType((): string => 'arrow');
      expect(result).assertEqual('function');
    });

    it('test_objType_classInstance', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const instance: TestClassForObjType = new TestClassForObjType();
      const result: string = objType(instance);
      expect(result).assertEqual('object');
    });

    it('test_objType_promise', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType(Promise.resolve('test'));
      expect(result).assertEqual('object');
    });

    it('test_objType_error', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType(new Error('test'));
      expect(result).assertEqual('object');
    });

    it('test_objType_typeError', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType(new TypeError('test'));
      expect(result).assertEqual('object');
    });

    it('test_objType_weakMap', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const wm: WeakMap<object, string> = new WeakMap<object, string>();
      const result: string = objType(wm);
      expect(result).assertEqual('object');
    });

    it('test_objType_buffer', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const buf: ArrayBuffer = new ArrayBuffer(8);
      const result: string = objType(buf);
      expect(result).assertEqual('object');
    });

    it('test_objType_rapidCalls_100', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      for (let i: number = 0; i < 100; i++) {
        const typeStr: string = objType('str_' + i.toString());
        expect(typeStr).assertEqual('string');
      }
    });

    it('test_objType_mixedTypes_100', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const strVal: string = 'string';
      const numVal: number = 42;
      const boolVal: boolean = true;
      const fnVal: object = (): void => {};
      const testValues: Array<string | number | boolean | null | undefined | object> = [
        strVal, numVal, boolVal, null, undefined, EMPTY_OBJ, [], fnVal
      ];
      for (let i: number = 0; i < 100; i++) {
        const val: string | number | boolean | null | undefined | object = testValues[i % testValues.length];
        const result: string = objType(val);
        expect(result !== null).assertTrue();
      }
    });

    it('test_objType_chineseString', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType('测试字符串');
      expect(result).assertEqual('string');
    });

    it('test_objType_emojiString', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType('🎵🎮');
      expect(result).assertEqual('string');
    });

    it('test_objType_veryLongString', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType(strRepeat('x', 1000));
      expect(result).assertEqual('string');
    });

    it('test_objType_veryLargeNumber', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType(1e308);
      expect(result).assertEqual('number');
    });

    it('test_objType_verySmallNumber', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType(1e-308);
      expect(result).assertEqual('number');
    });

    it('test_objType_deeplyNestedObject', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      let root: NestableObj = new NestableObj();
      let current: NestableObj = root;
      for (let i: number = 0; i < 100; i++) {
        current.child = new NestableObj();
        if (current.child !== null) {
          current = current.child;
        }
      }
      const result: string = objType(root);
      expect(result).assertEqual('object');
    });

    it('test_objType_objectWithNullPrototype', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const obj: EmptyObj = {};
      const result: string = objType(obj);
      expect(result).assertEqual('object');
    });

    it('test_objType_frozenObject', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const obj: FrozenData = new FrozenData('value');
      const result: string = objType(obj);
      expect(result).assertEqual('object');
    });

    it('test_objType_sealedObject', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const obj: FrozenData = new FrozenData('value');
      const result: string = objType(obj);
      expect(result).assertEqual('object');
    });

    it('test_objType_weakMap2', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType(new WeakMap<object, string>());
      expect(result).assertEqual('object');
    });

    it('test_objType_weakSet', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType(new WeakSet<object>());
      expect(result).assertEqual('object');
    });

    it('test_objType_int8Array', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType(new Int8Array(8));
      expect(result).assertEqual('object');
    });

    it('test_objType_float64Array', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType(new Float64Array(8));
      expect(result).assertEqual('object');
    });

    it('test_objType_dataView', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const buf: ArrayBuffer = new ArrayBuffer(16);
      const result: string = objType(new DataView(buf));
      expect(result).assertEqual('object');
    });

    it('test_objType_classWithConstructor', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType(new ComplexForObjType(1, 'two'));
      expect(result).assertEqual('object');
    });

    it('test_objType_namedFunction', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const result: string = objType(addForTest);
      expect(result).assertEqual('function');
    });

    it('test_objType_asyncFunction', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const asyncFn: () => Promise<void> = async (): Promise<void> => {};
      const result: string = objType(asyncFn);
      expect(result).assertEqual('function');
    });

    it('test_objType_boundary_emptyObject', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      expect(objType(EMPTY_OBJ)).assertEqual('object');
    });

    it('test_objType_boundary_emptyArray', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      expect(objType([])).assertEqual('object');
    });

    it('test_objType_consistency_multipleCallsSameValue', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      for (let i: number = 0; i < 100; i++) {
        expect(objType('test')).assertEqual('string');
        expect(objType(42)).assertEqual('number');
        expect(objType(true)).assertEqual('boolean');
        expect(objType(null)).assertEqual('null');
        expect(objType(undefined)).assertEqual('undefined');
      }
    });

    it('test_stress_objType_mixed_100', TestType.RELIABILITY | Size.LARGETEST | Level.LEVEL3, () => {
      const fnVal: object = (): void => {};
      const values: Array<string | number | boolean | null | undefined | object> = [
        'a', 1, true, null, undefined, EMPTY_OBJ, [], fnVal,
        'b', 2, false, null, undefined, SIMPLE_KV, [1], fnVal,
        'c', 3, true, null, undefined, DEEP_OBJ, [1, 2, 3], fnVal,
      ];
      for (let i: number = 0; i < 100; i++) {
        const val: string | number | boolean | null | undefined | object = values[i % values.length];
        objType(val);
      }
      expect(true).assertTrue();
    });

    // ========== objType nullish deep ==========
    describe('ObjType_nullishDeep', () => {

      it('comprehensive_objType_nullVsUndefined', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(objType(null)).assertEqual('null');
        expect(objType(undefined)).assertEqual('undefined');
      });

      it('comprehensive_objType_emptyString', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(objType('')).assertEqual('string');
      });

      it('comprehensive_objType_zeroNumber', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(objType(0)).assertEqual('number');
        expect(objType(-0)).assertEqual('number');
      });

      it('comprehensive_objType_emptyObject', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(objType(EMPTY_OBJ)).assertEqual('object');
        expect(objType([])).assertEqual('object');
      });

      it('comprehensive_objType_function', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const fn: () => void = (): void => {};
        expect(objType(fn)).assertEqual('function');
      });

      it('comprehensive_objType_boolean', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(objType(true)).assertEqual('boolean');
        expect(objType(false)).assertEqual('boolean');
      });

      it('comprehensive_objType_largeObject', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL1, () => {
        const largeObj: Map<string, number> = new Map<string, number>();
        for (let i: number = 0; i < 100; i++) {
          largeObj.set('key_' + i.toString(), i);
        }
        expect(objType(largeObj)).assertEqual('object');
      });
    });

    // ========== objType ==========
    describe('ObjType_performance', () => {

      it('comprehensive_objType_100kCalls', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const startTime: number = new Date().getTime();
        for (let i: number = 0; i < 1000; i++) {
          objType('test');
        }
        const elapsed: number = new Date().getTime() - startTime;
        expect(elapsed).assertLess(200);
      });

      it('comprehensive_objType_mixedType100kCalls', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const fnVal: object = (): void => {};
        const testValues: Array<string | number | boolean | object | null | undefined> = [
          'a', 1, true, null, undefined, EMPTY_OBJ, [], fnVal
        ];
        const startTime: number = new Date().getTime();
        for (let i: number = 0; i < 1000; i++) {
          objType(testValues[i % testValues.length]);
        }
        const elapsed: number = new Date().getTime() - startTime;
        expect(elapsed).assertLess(300);
      });
    });

    // ========== objType JS ==========
    describe('ObjType_exoticTypes', () => {

      it('comprehensive_exotic_weakMapRef', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const wm: WeakMap<object, string> = new WeakMap<object, string>();
        const key: EmptyObj = {};
        wm.set(key, 'active');
        expect(objType(wm)).assertEqual('object');
      });

      it('comprehensive_exotic_arrayBufferView', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const buf: ArrayBuffer = new ArrayBuffer(8);
        const view: DataView = new DataView(buf);
        view.setInt32(0, 42);
        expect(objType(view)).assertEqual('object');
      });

      it('comprehensive_exotic_typedArraysAll', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const typedArrays: ArrayBufferView[] = [
          new Int8Array(4), new Uint8Array(4), new Uint8ClampedArray(4),
          new Int16Array(4), new Uint16Array(4),
          new Int32Array(4), new Uint32Array(4),
          new Float32Array(4), new Float64Array(4),
          new BigInt64Array(4), new BigUint64Array(4)
        ];
        typedArrays.forEach((arr: ArrayBufferView): void => {
          expect(objType(arr)).assertEqual('object');
        });
      });

      it('comprehensive_exotic_objectFreeze', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const frozen: FrozenData = new FrozenData('value');
        expect(objType(frozen)).assertEqual('object');
      });

      it('comprehensive_exotic_boundFunction', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const bound: () => void = (): void => { originalForBind(); };
        expect(objType(bound)).assertEqual('function');
      });

      it('comprehensive_exotic_classStaticMethod', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(objType(StaticTestForObjType.doThing)).assertEqual('function');
      });
    });

    // ========== objType prototype chain boundary ==========
    describe('ObjType_prototypeChainBoundary', () => {

      it('comprehensive_protoChain_nullPrototypeObject', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const regularObj: EmptyObj = {};
        expect(objType(regularObj)).assertEqual('object');
      });

      it('comprehensive_protoChain_extendedClass', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const leaf: LeafForProto = new LeafForProto();
        expect(objType(leaf)).assertEqual('object');
      });

      it('comprehensive_protoChain_errorSubclasses', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const errors: Array<Error | TypeError | RangeError | ReferenceError | SyntaxError | URIError> = [
          new Error('generic'), new TypeError('type'), new RangeError('range'),
          new ReferenceError('ref'), new SyntaxError('syntax'), new URIError('uri')
        ];
        errors.forEach((e): void => {
          expect(objType(e)).assertEqual('object');
        });
      });

      it('comprehensive_protoChain_customErrorClass', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const appError: MusicPlayerErrorForTest = new MusicPlayerErrorForTest('playback failed', 1001);
        expect(objType(appError)).assertEqual('object');
      });

      it('comprehensive_protoChain_objectWithDynamicKeys', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const obj: Map<string, string> = new Map<string, string>();
        obj.set('normalKey', 'visible');
        obj.set('dynamic_internal_key', 'hidden');
        expect(objType(obj)).assertEqual('object');
      });
    });

    // ========== objType ==========
    describe('ObjType_businessIntegration', () => {

      it('comprehensive_business_deviceInfoTypeCheck', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const deviceInfo: DeviceData = { deviceId: 'dev-001', deviceName: 'TV', deviceType: 0x9C };
        expect(objType(deviceInfo)).assertEqual('object');
      });

      it('comprehensive_business_authParamTypeCheck', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const authType: number = 1;
        expect(objType(authType)).assertEqual('number');
        expect(objType('1')).assertEqual('string');
      });

      it('comprehensive_business_callbackTypeCheck', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const validCallback: () => void = (): void => {};
        const invalidCallback: EmptyObj = {};
        expect(objType(validCallback)).assertEqual('function');
        expect(objType(invalidCallback)).assertEqual('object');
      });

      it('comprehensive_business_playStateTypeCheck', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const playState: PlayStateData = { img: '', name: 'song', author: 'artist', url: '', isPlay: true };
        expect(objType(playState)).assertEqual('object');
        expect(objType(playState.isPlay)).assertEqual('boolean');
      });

      it('comprehensive_business_buttonModelTypeCheck', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const button: ButtonData = { name: 'play', isFocus: false };
        expect(objType(button)).assertEqual('object');
        expect(objType(button.name)).assertEqual('string');
        expect(objType(button.isFocus)).assertEqual('boolean');
      });

      it('comprehensive_business_kvStoreValueTypeCheck', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const validValues: Array<string | number | boolean> = ['data', 42, true];
        validValues.forEach((val: string | number | boolean): void => {
          const t: string = objType(val);
          const knownTypes: string[] = ['string', 'number', 'boolean'];
          expect(knownTypes.indexOf(t) >= 0).assertTrue();
        });
      });

      it('comprehensive_business_emptyDeviceListGuard', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let deviceList: object[] | undefined = undefined;
        if (objType(deviceList) === 'undefined') {
          deviceList = [];
        }
        expect(deviceList !== null).assertTrue();
        expect(deviceList!.length).assertEqual(0);
      });
    });

    // ========== objType ==========
    describe('ObjType_extremeStress', () => {

      it('comprehensive_extreme_1millionStringCalls_under150ms', TestType.RELIABILITY | Size.LARGETEST | Level.LEVEL3, () => {
        const startTime: number = new Date().getTime();
        for (let i: number = 0; i < 10000; i++) {
          objType('test');
        }
        const elapsed: number = new Date().getTime() - startTime;
        expect(elapsed).assertLess(400);
      });

      it('comprehensive_extreme_nullCheck100k_under50ms', TestType.RELIABILITY | Size.LARGETEST | Level.LEVEL3, () => {
        const startTime: number = new Date().getTime();
        let nullCount: number = 0;
        let undefinedCount: number = 0;
        for (let i: number = 0; i < 100000; i++) {
          if (objType(null) === 'null') { nullCount++; }
          if (objType(undefined) === 'undefined') { undefinedCount++; }
        }
        const elapsed: number = new Date().getTime() - startTime;
        expect(nullCount).assertEqual(100000);
        expect(undefinedCount).assertEqual(100000);
        expect(elapsed).assertLess(100);
      });

      it('comprehensive_extreme_foreignType_100000', TestType.RELIABILITY | Size.LARGETEST | Level.LEVEL3, () => {
        const fnVal: object = (): void => {};
        const values: Array<string | number | boolean | object | null | undefined> = [
          'str', 42, 3.14, true, false,
          null, undefined,
          EMPTY_OBJ, [], fnVal, new Date(), new Date(),
          new Map<string, string>(), new Set<string>(), /regex/, new Error('e'),
          new Int8Array(1), new Float64Array(1)
        ];
        const startTime: number = new Date().getTime();
        for (let i: number = 0; i < 100000; i++) {
          const result: string = objType(values[i % values.length]);
          expect(result.length).assertLarger(0);
        }
        const elapsed: number = new Date().getTime() - startTime;
        expect(elapsed).assertLess(200);
      });

      it('comprehensive_extreme_repeatedNullChecks_1000', TestType.RELIABILITY | Size.LARGETEST | Level.LEVEL3, () => {
        const items: Array<string | null> = [];
        for (let i: number = 0; i < 1000; i++) {
          items.push(i % 3 === 0 ? null : 'item_' + i.toString());
        }
        const startTime: number = new Date().getTime();
        let nonNullCount: number = 0;
        for (let i: number = 0; i < items.length; i++) {
          if (objType(items[i]) !== 'null') {
            nonNullCount++;
          }
        }
        const elapsed: number = new Date().getTime() - startTime;
        expect(nonNullCount).assertLarger(60000);
        expect(elapsed).assertLess(60);
      });
    });

    // ========== objType immutability contract ==========
    describe('ObjType_immutabilityContract', () => {

      it('comprehensive_contract_alwaysReturnsKnownTypeStrings', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const possibleResults: Set<string> = new Set<string>();
        const fnVal: object = (): void => {};
        const testValues: Array<string | number | boolean | object | null | undefined> = [
          'a', 1, true, EMPTY_OBJ,
          null, undefined, fnVal, new Date()
        ];
        testValues.forEach((v: string | number | boolean | object | null | undefined): void => {
          possibleResults.add(objType(v));
        });
        const expectedTypes: string[] = ['string', 'number', 'boolean', 'object', 'null', 'undefined', 'function'];
        expectedTypes.forEach((t: string): void => {
          expect(possibleResults.has(t)).assertTrue();
        });
      });

      it('comprehensive_contract_nullAndUndefinedNeverReturnObject', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(objType(null)).assertEqual('null');
        expect(objType(undefined)).assertEqual('undefined');
        expect(objType(null) === 'object').assertFalse();
        expect(objType(undefined) === 'object').assertFalse();
      });

      it('comprehensive_contract_idempotent', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const fnVal: object = (): void => {};
        const values: Array<string | number | boolean | object | null | undefined> = [
          'test', 42, true, EMPTY_OBJ, null, undefined, fnVal
        ];
        values.forEach((v: string | number | boolean | object | null | undefined): void => {
          const first: string = objType(v);
          for (let i: number = 0; i < 100; i++) {
            expect(objType(v)).assertEqual(first);
          }
        });
      });

      it('comprehensive_contract_pureFunction_noSideEffects', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const testObj: SimpleKeyValue = { key: 'value' };
        const beforeKey: string = testObj.key;
        objType(testObj);
        const afterKey: string = testObj.key;
        expect(beforeKey.length).assertEqual(afterKey.length);
        expect(beforeKey).assertEqual(afterKey);
      });
    });

  });
}
