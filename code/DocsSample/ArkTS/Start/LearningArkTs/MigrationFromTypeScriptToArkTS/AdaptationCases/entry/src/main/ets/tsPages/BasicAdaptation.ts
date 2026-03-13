/*
 * Copyright (C) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// [Start ts_import_module]
import 'module'
// [End ts_import_module]
// [Start try_businessError]
// [Start ts_limited_throw]
import { BusinessError } from '@kit.BasicServicesKit'
// [StartExclude try_businessError]
function ThrowError(error: BusinessError) {
  throw error;
}
// [End ts_limited_throw]

{
  // [Start ts_identifiers_as_prop_names]
  interface W {
    bundleName: string
    action: string
    entities: string[]
  }

  let wantInfo: W = {
    'bundleName': 'com.huawei.hmos.browser',
    'action': 'ohos.want.action.viewData',
    'entities': ['entity.system.browsable']
  }
  // [End ts_identifiers_as_prop_names]
}

// [Start ts_no_any_unknown]
function printObj(obj: any) {
  console.info(obj);
}

printObj('abc'); // abc
// [End ts_no_any_unknown]

{
  // [Start ts_json_parser]
  class A {
    v: number = 0
    s: string = ''

    foo(str: string) {
      let tmpStr = JSON.parse(str);
      if (tmpStr.add != undefined) {
        this.v = tmpStr.v;
        this.s = tmpStr.s;
      }
    }
  }
  // [End ts_json_parser]
}

// [Start ts_record_type]
function printProperties(obj: any) {
  console.info(obj.name);
  console.info(obj.value);
}
// [End ts_record_type]

// [Start ts_no_call_signature]
interface I {
  (value: string): void;
}

function foo(fn: I) {
  fn('abc');
}

foo((value: string) => {
  console.info(value);
})
// [End ts_no_call_signature]

function testFoo() {
  foo((value: string) => {
    console.info(value);
  })
}

// [EndExclude try_businessError]
try {
  // ...
} catch (error) {
  let e: BusinessError = error as BusinessError;
  console.error(e.message, e.code);
}
// [End try_businessError]

{
  // [Start ts_no_ctor_signatures_type]
  class Controller {
    value: string = ''

    constructor(value: string) {
      this.value = value;
    }
  }

  type ControllerConstructor = {
    new (value: string): Controller;
  }

  class testMenu {
    controller: ControllerConstructor = Controller
    createController() {
      if (this.controller) {
        return new this.controller('123');
      }
      return null;
    }
  }

  let t = new testMenu();
  console.info(t.createController()!.value);
  // [End ts_no_ctor_signatures_type]
}

// [Start ts_no_indexed_signatures]
function foo1(data: { [key: string]: string }) {
  data['a'] = 'a';
  data['b'] = 'b';
  data['c'] = 'c';
}
// [End ts_no_indexed_signatures]

{
  // [Start ts_no_typing_with_this]
  class C {
    getInstance(): this {
      return this;
    }
  }
  // [End ts_no_typing_with_this]
}

{
  // [Start ts_no_ctor_prop_decls]
  class Person {
    constructor(readonly name: string) {}

    getName(): string {
      return this.name;
    }
  }
  // [End ts_no_ctor_prop_decls]
}

{
  // [Start ts_no_ctor_signatures_iface]
  class Controller {
    value: string = ''

    constructor(value: string) {
      this.value = value;
    }
  }

  interface ControllerConstructor {
    new (value: string): Controller;
  }

  class testMenu {
    controller: ControllerConstructor = Controller
    createController() {
      if (this.controller) {
        return new this.controller('abc');
      }
      return null;
    }
  }

  let t = new testMenu();
  console.info(t.createController()!.value);
  // [End ts_no_ctor_signatures_iface]
}

// [Start ts_no_props_by_index]
function foo2(params: Object) {
  let funNum: number = params['funNum'];
  let target: string = params['target'];
}
// [End ts_no_props_by_index]

{
  // [Start ts_no_inferred_generic_params]
  class A {
    str: string = ''
  }
  class B extends A {}
  class C extends A {}

  let arr: Array<A> = [];

  let originMenusMap:Map<string, C> = new Map(arr.map(item => [item.str, (item instanceof C) ? item: null]));
  // [End ts_no_inferred_generic_params]
}

{
  // [Start ts_no_regexp_literals]
  let regex: RegExp = /\s*/g;
  // [End ts_no_regexp_literals]
}

{
  // [Start ts_no_obj_literals_as_types]
  const area = { // 没有写明类型 不方便维护
    pixels: new ArrayBuffer(8),
    offset: 0,
    stride: 8,
    region: { size: { height: 1,width:2 }, x: 0, y: 0 }
  }
  // [End ts_no_obj_literals_as_types]
}

{
  // [Start ts_no_structural_typing_one]
  class Test {
    value: number = 1
    // 有构造函数
    constructor(value: number) {
      this.value = value;
    }
  }

  let t: Test = { value: 2 };
  // [End ts_no_structural_typing_one]
}

{
  // [Start ts_no_structural_typing_two]
  class C {
    value: number = 1

    constructor(n: number) {
      if (n < 0) {
        throw new Error('Negative');
      }
      this.value = n;
    }
  }

  let s: C = new C(-2);   // 抛出异常
  let t: C = { value: -2 }; // ArkTS不支持
  // [End ts_no_structural_typing_two]
}

{
  // [Start ts_no_nonInferrable_arr_literals]
  class Test {
    value: number = 0
  }

  let arr: Test[] = [
    {
      'value': 1
    },
    {
      'value': 2
    },
    {
      'value': 3
    }
  ]
  // [End ts_no_nonInferrable_arr_literals]
}

{
  // [Start ts_record_type_usage]
  let obj: Record<string, number | string> = {
    value: 123,
    name: 'abc'
  }
  // [End ts_record_type_usage]
}

// [Start ts_index_signature_usage]
function foo3(obj: { [key: string]: string}): string {
  if (obj != undefined && obj != null) {
    return obj.value1 + obj.value2;
  }
  return '';
}
// [End ts_index_signature_usage]

// [Start ts_anonymous_function]
(fn) => {
  fn({ value: 123, name:'' });
}
// [End ts_anonymous_function]

{
  // [Start ts_interface_method_signature]
  interface T {
    foo(value: number): number
  }

  let t:T = { foo: (value) => { return value } };
  // [End ts_interface_method_signature]
}

// [Start ts_export_default]
export default {
  onCreate() {
    // ...
  },
  onDestroy() {
    // ...
  }
}
// [End ts_export_default]

// [Start ts_rest_params]
function emit(event: string, ...args: Object[]): void {}

emit('', {
  'action': 11,
  'outers': false
});
// [End ts_rest_params]

// [Start ts_type_alias]
type Person = { name: string, age: number }
// [End ts_type_alias]

{
  // [Start ts_array_literal_inference]
  let permissionList = [
    { name: '设备信息', value: '用于分析设备的续航、通话、上网、SIM卡故障等' },
    { name: '麦克风', value: '用于反馈问题单时增加语音' },
    { name: '存储', value: '用于反馈问题单时增加本地文件附件' }
  ]
  // [End ts_array_literal_inference]
}

{
  // [Start ts_no_method_reassignment]
  class C {
    add(left: number, right: number): number {
      return left + right;
    }
  }

  function sub(left: number, right: number): number {
    return left - right;
  }

  let c1 = new C();
  c1.add = sub;
  // [End ts_no_method_reassignment]
}

{
  // [Start ts_no_polymorphic]
  let a = +'5'; // 使用操作符隐式转换
  let b = -'5';
  let c = ~'5';
  let d = +'string';
  // [End ts_no_polymorphic]
}

// [Start ts_object_keys]
function test(str: string, obj: Record<string, Object>) {
  return str in obj;
}
// [End ts_object_keys]

{
  // [Start ts_no_destruct_assignment]
  let map = new Map<string, string>([['a', 'a'], ['b', 'b']]);
  for (let [key, value] of map) {
    console.info(key);
    console.info(value);
  }
  // [End ts_no_destruct_assignment]
}

{
  // [Start ts_no_for_in]
  interface Person {
    [name: string]: string
  }
  let p: Person = {
    name: 'tom',
    age: '18'
  };

  for (let t in p) {
    console.info(p[t]);  // info: "tom", "18"
  }
  // [End ts_no_for_in]
}

{
  // [Start ts_no_mapped_types]
  class C {
    a: number = 0
    b: number = 0
    c: number = 0
  }
  type OptionsFlags = {
    [Property in keyof C]: string
  }
  // [End ts_no_mapped_types]
}

// [Start ts_no_standalone_this]
function foo4() {
  console.info(this.value);
}

let obj = { value: 'abc' };
foo.apply(obj);
// [End ts_no_standalone_this]

{
  // [Start ts_class_static_function_this]
  class Test {
    static value: number = 123
    static foo(): number {
      return this.value
    }
  }
  // [End ts_class_static_function_this]
}

{
  // [Start ts_no_ctor_signatures_funcs]
  class Controller {
    value: string = ''
    constructor(value: string) {
      this.value = value
    }
  }

  type ControllerConstructor = new (value: string) => Controller;

  class testMenu {
    controller: ControllerConstructor = Controller
    createController() {
      if (this.controller) {
        return new this.controller('abc');
      }
      return null;
    }
  }

  let t = new testMenu()
  console.info(t.createController()!.value)
  // [End ts_no_ctor_signatures_funcs]
}

{
  // [Start ts_no_func_apply_bind_call]
  let arr: number[] = [1, 2, 3, 4];
  let str = String.fromCharCode.apply(null, Array.from(arr));
  // [End ts_no_func_apply_bind_call]
}

{
  // [Start ts_bind_one]
  class A {
    value: string = ''
    foo: Function = () => {}
  }

  class Test {
    value: string = '1234'
    obj: A = {
      value: this.value,
      foo: this.foo.bind(this)
    }

    foo() {
      console.info(this.value);
    }
  }
  // [End ts_bind_one]
}

{
  // [Start ts_use_apply]
  class A {
    value: string;
    constructor (value: string) {
      this.value = value;
    }

    foo() {
      console.info(this.value);
    }
  }

  let a1 = new A('1');
  let a2 = new A('2');

  a1.foo();
  a1.foo.apply(a2);
  // [End ts_use_apply]
}

{
  // [Start ts_use_limited_stdlib]
  let entries = new Map([
    ['foo', 123],
    ['bar', 456]
  ]);

  let obj = Object.fromEntries(entries);
  // [End ts_use_limited_stdlib]
}

{
  // [Start ts_strict_typing_required]
  interface I {
    name:string
  }

  class A {}

  class Test {
    a: number;
    b: string;
    c: boolean;
    d: I;
    e: A;
  }
  // [End ts_strict_typing_required]
}

{
  // [Start ts_null_undefined_check_one]
  class A {
    bar() {}
  }
  function foo(n: number) {
    if (n === 0) {
      return null;
    }
    return new A();
  }
  function getNumber() {
    return 5;
  }
  let a:A = foo(getNumber());
  a.bar();
  // [End ts_null_undefined_check_one]
}

{
  // [Start ts_null_undefined_check_two]
  class Test {
    private value?: string;

    public printValue () {
      console.info(this.value.toLowerCase());
    }
  }

  let t = new Test();
  t.printValue();
  // [End ts_null_undefined_check_two]
}

{
  // [Start ts_null_undefined_check_three]
  class Test {
    handleClick: (action: string, externInfo?: string) => void | null = null;
  }
  // [End ts_null_undefined_check_three]
}

// [Start ts_null_undefined_check_four]
class A {
  value: number
  constructor(value: number) {
    this.value = value;
  }
}

function foo6(v: number): A | null {
  if (v > 0) {
    return new A(v);
  }
  return null;
}

let a1: A = foo6(1);
// [End ts_null_undefined_check_four]

{
  // [Start ts_null_undefined_check_five]
  interface A {
    foo?: () => void
  }

  let a:A = { foo: () => {} };
  a.foo();
  // [End ts_null_undefined_check_five]
}

{
  // [Start ts_null_undefined_check_six]
  class Test {
    value: number = 0
  }

  let a: Test
  try {
    a = { value: 1};
  } catch (e) {
    a.value;
  }
  a.value;
  // [End ts_null_undefined_check_six]
}

// [Start ts_function_return_type]
function foo7(a: number): number {
  if (a > 0) {
    return a;
  }
}
// [End ts_function_return_type]

{
  // [Start ts_ts_ignore]
  // @ts-ignore
  var a: any = 123;
  // [End ts_ts_ignore]
}

{
  // [Start ts_no_classes_as_obj]
  class Controller {
    value: string = ''
    constructor(value: string) {
      this.value = value
    }
  }

  interface ControllerConstructor {
    new (value: string): Controller;
  }

  class TestMenu {
    controller: ControllerConstructor = Controller
    createController() {
      if (this.controller) {
        return new this.controller('abc');
      }
      return null;
    }
  }

  let t = new TestMenu();
  console.info(t.createController()!.value);
  // [End ts_no_classes_as_obj]
}

{
  // [Start ts_static_attribute]
  class C1 {
    static value: string = 'abc'
  }

  class C2 {
    static value: string = 'def'
  }

  function getValue(obj: any) {
    return obj['value'];
  }

  console.info(getValue(C1));
  console.info(getValue(C2));
  // [End ts_static_attribute]
}

// [Start ts_no_func_props]
function foo8(value: number): void {
  console.info(value.toString());
}

foo8.add = (left: number, right: number) => {
  return left + right;
}

foo8.sub = (left: number, right: number) => {
  return left - right;
}
// [End ts_no_func_props]

// [Start ts_shallow_copy]
function shallowCopy(obj: object): object {
  let newObj = {};
  Object.assign(newObj, obj);
  return newObj;
}
// [End ts_shallow_copy]

// [Start ts_deep_copy]
function deepCopy(obj: object): object {
  let newObj = Array.isArray(obj) ? [] : {};
  for (let key in obj) {
    if (typeof obj[key] === 'object') {
      newObj[key] = deepCopy(obj[key]);
    } else {
      newObj[key] = obj[key];
    }
  }
  return newObj;
}
// [End ts_deep_copy]
