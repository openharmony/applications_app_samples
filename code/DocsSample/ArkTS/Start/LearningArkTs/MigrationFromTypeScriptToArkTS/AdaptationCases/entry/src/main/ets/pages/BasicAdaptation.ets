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

// [Start no_types_in_catch]
// [Start limited_throw]
import { BusinessError } from '@kit.BasicServicesKit'
// [StartExclude no_types_in_catch]

function throwError(error: BusinessError) {
  throw error as Error;
}
// [End limited_throw]
let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;
// [EndExclude no_types_in_catch]
try {
  // ...
} catch (error) {
  let e: BusinessError = error as BusinessError;
  console.error(e.message, e.code);
}
// [End no_types_in_catch]
// [Start identifiers_as_prop_names]
interface W {
  bundleName: string
  action: string
  entities: string[]
}

let wantInfo: W = {
  bundleName: 'com.huawei.hmos.browser',
  action: 'ohos.want.action.viewData',
  entities: ['entity.system.browsable']
}
// [End identifiers_as_prop_names]
// [Start no_any_unknown]
function printObj(obj: string) {
  console.info(obj);
  // [StartExclude no_any_unknown]
  if (globalLogUpdate) {
    globalLogUpdate(`printObj: ${obj}`, false);
  }
  // [EndExclude no_any_unknown]
}
  // [StartExclude no_any_unknown]
// [Start json_parser]
class A {
  public v: number = 0
  public s: string = ''

  foo(str: string) {
    let tmpStr: Record<string, Object> = JSON.parse(str);
    if (tmpStr.add != undefined) {
      this.v = tmpStr.v as number;
      this.s = tmpStr.s as string;
    }
  }
}
// [End json_parser]
// [Start record_type]
function printProperties(obj: Record<string, Object>) {
  console.info(obj.name as string);
  console.info(obj.value as string);
  // [StartExclude record_type]
  if (globalLogUpdate) {
    globalLogUpdate(`printProperties - name: ${obj.name as string}, value: ${obj.value as string}`, false);
  }
  // [EndExclude record_type]
}
// [End record_type]
  // [Start no_call_signature]
type I = (value: string) => void

function foo(fn: I) {
  fn('abc');
}
  // [StartExclude no_call_signature]
function testFooCallback() {
  // [EndExclude no_call_signature]
  foo((value: string) => {
    console.info(value);
    // [StartExclude no_call_signature]
    if (globalLogUpdate) {
      globalLogUpdate(`foo callback: ${value}`, false);
    }
    // [EndExclude no_call_signature]
  })
  // [End no_call_signature]
}
// [Start no_ctor_signatures_type]
class Controller {
  public value: string = ''

  constructor(value: string) {
    this.value = value;
  }
}

type ControllerConstructor = () => Controller;

class TestMenu {
  public controller: ControllerConstructor = () => {
    return new Controller('abc');
  }

  createController() {
    if (this.controller) {
      return this.controller();
    }
    return null;
  }
}
  // [StartExclude no_ctor_signatures_type]
function testControllerValue() {
  // [EndExclude no_ctor_signatures_type]
  let t: TestMenu = new TestMenu();
  console.info(t.createController()!.value);
  // [End no_ctor_signatures_type]
  let result = t.createController()!.value;
  if (globalLogUpdate) {
    globalLogUpdate(`testMenu controller value: ${result}`, false);
  }
}
// [Start no_indexed_signatures]
function foo1(data: Record<string, string>) {
  data['a'] = 'a';
  data['b'] = 'b';
  data['c'] = 'c';
}
// [End no_indexed_signatures]
// [Start no_typing_with_this]
class C {
  getInstance(): C {
    return this;
  }
}
// [End no_typing_with_this]
// [Start no_ctor_prop_decls]
class Person {
  public name: string
  constructor(name: string) {
    this.name = name;
  }

  getName(): string {
    return this.name;
  }
}
// [End no_ctor_prop_decls]
function testNoCtorSignatures() {
  // [Start no_ctor_signatures_iface]
  class Controller {
    public value: string = ''

    constructor(value: string) {
      this.value = value;
    }
  }

  type ControllerConstructor = () => Controller;

  class TestMenu {
    public controller: ControllerConstructor = () => {
      return new Controller('abc');
    }

    createController() {
      if (this.controller) {
        return this.controller();
      }
      return null;
    }
  }

  let t: TestMenu = new TestMenu();
  console.info(t.createController()!.value);
  // [End no_ctor_signatures_iface]
  let result = t.createController()!.value;
  if (globalLogUpdate) {
    globalLogUpdate(`test no-ctor-signatures-iface: ${result}`, false);
  }
}
// [Start no_props_by_index]
function foo2(params: Record<string, string | number>) {
  let funNum: number = params['funNum'] as number;
  let target: string = params['target'] as string;
}
// [End no_props_by_index]
{
  // [Start no_inferred_generic_params]
  class A {
    public str: string = ''
  }
  class B extends A {}
  class C extends A {}

  let arr: A[] = [];

  let originMenusMap: Map<string, C | null> = new Map<string, C | null>
  (arr.map<[string, C | null]>(item => [item.str, (item instanceof C) ? item: null]));
  // [End no_inferred_generic_params]
}
// [Start no_regexp_literals]
let regexp: RegExp = new RegExp('\\s*','g');
// [End no_regexp_literals]
{
  // [Start no_obj_literals_as_types]
  interface Person {
    name: string,
    age: number
  }
  // [End no_obj_literals_as_types]
}

{
  // [Start no_nonInferrable_arr_literals]
  class PermissionItem {
    public name?: string
    public value?: string
  }

  let permissionList: PermissionItem[] = [
    { name: '设备信息', value: '用于分析设备的续航、通话、上网、SIM卡故障等' },
    { name: '麦克风', value: '用于反馈问题单时增加语音' },
    { name: '存储', value: '用于反馈问题单时增加本地文件附件' }
  ]
  // [End no_nonInferrable_arr_literals]
}

// [Start no_method_reassignment]
class C3 {
  public add: (left: number, right: number) => number =
    (left: number, right: number) => {
      return left + right;
    }
}

function sub(left: number, right: number): number {
  return left - right;
}

let c1 = new C3();
c1.add = sub;
// [End no_method_reassignment]

{
  // [Start no_polymorphic]
  let a = Number.parseInt('5'); // 使用Number.parseInt显示转换
  let b = -Number.parseInt('5');
  let c = ~Number.parseInt('5');
  let d = new Number('123');
  // [End no_polymorphic]
}
// [Start object_keys]
function test(str: string, obj: Record<string, Object>) {
  for (let i of Object.keys(obj)) {
    if (i == str) {
      return true;
    }
  }
  return false;
}
// [End object_keys]
function testMapIteration() {
  // [Start no_destruct_assignment]
  let map = new Map<string, string>([['a', 'a'], ['b', 'b']]);
  // [StartExclude no_destruct_assignment]
  let results: string[] = [];
  // [EndExclude no_destruct_assignment]
  for (let arr of map) {
    let key = arr[0];
    let value = arr[1];
    console.info(key);
    console.info(value);
    // [StartExclude no_destruct_assignment]
    results.push(`key:${key}, value:${value}`);
    // [EndExclude no_destruct_assignment]
  }
  // [End no_destruct_assignment]
  if (globalLogUpdate) {
    globalLogUpdate(`Map遍历结果: ${results.join('; ')}`, false);
  }
}

function testObjectEntries() {
  // [Start no_for_in]
  let p: Record<string, string> = {
    'name': 'tom',
    'age': '18'
  };
  // [StartExclude no_for_in]
  let results: string[] = [];
  // [EndExclude no_for_in]
  for (let ele of Object.entries(p)) {
    console.info(ele[1]); // info: "tom", "18"
    // [StartExclude no_for_in]
    results.push(ele[1]);
    // [EndExclude no_for_in]
  }
  // [End no_for_in]
  if (globalLogUpdate) {
    globalLogUpdate(`Object.entries结果: ${results.join(', ')}`, false);
  }
}

{
  // [Start no_mapped_types]
  class C {
    public a: number = 0
    public b: number = 0
    public c: number = 0
  }

  type OptionsFlags = Record<keyof C, string>
  // [End no_mapped_types]
}

function testTestClassFoo() {
  // [Start no_standalone_this_one]
  class Test {
    public value: string = ''
    constructor (value: string) {
      this.value = value
    }

    foo() {
      console.info(this.value);
      // [StartExclude no_standalone_this_one]
      if (globalLogUpdate) {
        globalLogUpdate(`Test.foo value: ${this.value}`, false);
      }
      // [EndExclude no_standalone_this_one]
    }
  }

  let obj: Test = new Test('abc');
  obj.foo();
  // [End no_standalone_this_one]
}
// [Start no_standalone_this_two]
function foo3(obj: Test) {
  console.info(obj.value);
  // [StartExclude no_standalone_this_two]
  if (globalLogUpdate) {
    globalLogUpdate(`foo3 obj.value: ${obj.value}`, false);
  }
  // [EndExclude no_standalone_this_two]
}
// [StartExclude no_standalone_this_two]
function foo4(value: string) {
  console.info(value);
  if (globalLogUpdate) {
    globalLogUpdate(`foo4 value: ${value}`, false);
  }
}
// [EndExclude no_standalone_this_two]
class Test {
  public value: string = ''
}
let obj1: Test = { value: 'abc' };
foo3(obj1);
// [End no_standalone_this_two]
{
  let obj: Test = { value: 'abc' };
  foo4(obj.value);
}

// [Start no_standalone_this_three]
function foo5(value: string) {
  console.info(value);
}

class Test1 {
  value: string = ''
}

let obj2: Test1 = { value: 'abc' };
foo5(obj2.value);
// [End no_standalone_this_three]

{
  // [Start class_static_function_this]
  class Test {
    public static value: number = 123
    public static foo(): number {
      return Test.value
    }
  }
  // [End class_static_function_this]
}

function testControllerInBlock() {
  // [Start no_ctor_signatures_funcs]
  class Controller {
    public value: string = ''
    constructor(value: string) {
      this.value = value;
    }
  }

  type ControllerConstructor = () => Controller;

  class TestMenu {
    public controller: ControllerConstructor = () => { return new Controller('abc') }
    createController() {
      if (this.controller) {
        return this.controller();
      }
      return null;
    }
  }

  let t: TestMenu = new TestMenu();
  console.info(t.createController()!.value);
  // [End no_ctor_signatures_funcs]
  let result = t.createController()!.value;
  if (globalLogUpdate) {
    globalLogUpdate(`Controller in block value: ${result}`, false);
  }
}

{
  // [Start no_func_apply_bind_call]
  let arr: number[] = [1, 2, 3, 4];
  let str = String.fromCharCode(...Array.from(arr));
  // [End no_func_apply_bind_call]
}

{
  // [Start bind_one]
  class A {
    public value: string = ''
    public foo: Function = () => {}
  }

  class Test {
    public value: string = '1234'
    public obj: A = {
      value: this.value,
      foo: (): void => this.foo()
    }

    foo() {
      console.info(this.value);
    }
  }
  // [End bind_one]
}

{
  // [Start bind_two]
  class A {
    public value: string = ''
    public foo: Function = () => {}
  }

  class Test {
    public value: string = '1234'
    public foo: () => void = () => {
      console.info(this.value);
    }
    public obj: A = {
      value: this.value,
      foo: this.foo
    }
  }
  // [End bind_two]
}

function testClassAFooApply() {
  // [Start use_apply]
  class A {
    public value: string;
    constructor (value: string) {
      this.value = value;
    }

    foo() {
      this.fooApply(this);
    }

    fooApply(a: A) {
      console.info(a.value);
      // [StartExclude use_apply]
      if (globalLogUpdate) {
        globalLogUpdate(`A.fooApply value: ${a.value}`, false);
      }
      // [EndExclude use_apply]
    }
  }

  let a1 = new A('1');
  let a2 = new A('2');

  a1.foo();
  a1.fooApply(a2);
  // [End use_apply]
}

{
  // [Start use_limited_stdlib]
  let entries = new Map([
    ['foo', 123],
    ['bar', 456]
  ]);

  let obj: Record<string, Object> = {};
  entries.forEach((key, value) => {
    if (key != undefined && key != null) {
      obj[key] = value;
    }
  })
  // [End use_limited_stdlib]
}

{
  // [Start strict_typing_required]
  let a: number = 123;
  // [End strict_typing_required]
}

function testTestMenuController() {
  // [Start no_classes_as_obj]
  class Controller {
    public value: string = ''

    constructor(value: string) {
      this.value = value;
    }
  }

  type ControllerConstructor = () => Controller;

  class TestMenu {
    public controller: ControllerConstructor = () => {
      return new Controller('abc');
    }

    createController() {
      if (this.controller) {
        return this.controller();
      }
      return null;
    }
  }

  let t: TestMenu = new TestMenu();
  console.info(t.createController()!.value);
  // [End no_classes_as_obj]
  let result = t.createController()!.value;
  if (globalLogUpdate) {
    globalLogUpdate(`TestMenu controller value: ${result}`, false);
  }
}
// [Start static_attribute]
class C1 {
  public static value: string = 'abc'
}

class C2 {
  public static value: string = 'def'
}

function getC1Value(): string {
  return C1.value;
}

function getC2Value(): string {
  return C2.value;
}

console.info(getC1Value());
console.info(getC2Value());
// [End static_attribute]

function testGetC1C2Values() {
  let c1Val = getC1Value();
  let c2Val = getC2Value();
  if (globalLogUpdate) {
    globalLogUpdate(`C1 value: ${c1Val}, C2 value: ${c2Val}`, false);
  }
}

function testFooStaticMethod() {
  // [Start no_func_props]
  class Foo {
    static foo(value: number): void {
      console.info(value.toString());
      // [StartExclude no_func_props]
      if (globalLogUpdate) {
        globalLogUpdate(`Foo.foo value: ${value.toString()}`, false);
      }
      // [EndExclude no_func_props]
    }

    static add(left: number, right: number): number {
      return left + right;
    }

    static sub(left: number, right: number): number {
      return left - right;
    }
  }
  // [End no_func_props]
  Foo.foo(123);
}
// [Start shallow_copy]
function shallowCopy(obj: object): object {
  let newObj: Record<string, Object> = {};
  for (let key of Object.keys(obj)) {
    newObj[key] = obj[key];
  }
  return newObj;
}
// [End shallow_copy]
// [Start deep_copy]
function deepCopy(obj: object): object {
  let newObj: Record<string, Object> | Object[] = Array.isArray(obj) ? [] : {};
  for (let key of Object.keys(obj)) {
    if (typeof obj[key] === 'object') {
      newObj[key] = deepCopy(obj[key]);
    } else {
      newObj[key] = obj[key];
    }
  }
  return newObj;
}
// [End deep_copy]
@Entry
@Component
struct BasicAdaptationPage {
  @State currentState: string | ResourceStr = $r('app.string.state_not_initialized');
  @State logMessages: string | ResourceStr = $r('app.string.log_no_info');

  aboutToAppear(): void {
    globalLogUpdate = (msg, isError) => this.updateLogInfo(msg, isError);
  }

  updateLogInfo(msg: string, isError: boolean): void {
    const timestamp = new Date().toLocaleTimeString();
    const prefix = isError ? '[ERROR]' : '[INFO]';
    this.logMessages = `[${timestamp}] ${prefix} ${msg}`;
  }

  build() {
    Scroll() {
      Column() {
        Column() {
          Text($r('app.string.real_time_status'))
            .fontSize(18)
            .fontWeight(600)
            .margin({ bottom: 12 })

          Column() {
            Text($r('app.string.current_state'))
              .fontSize(14)
              .fontWeight(600)
              .margin({ bottom: 8 })
            Text(this.currentState)
              .fontSize(14)
              .fontColor('#007DFF')
              .width('100%')
              .padding(10)
              .backgroundColor('#F0F0F0')
              .borderRadius(8)
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .margin({ bottom: 12 })

          Column() {
            Text($r('app.string.log_info'))
              .fontSize(14)
              .fontWeight(600)
              .margin({ bottom: 8 })
            Scroll() {
              Text(this.logMessages)
                .fontSize(12)
                .fontColor('#52C41A')
                .width('100%')
                .padding(10)
                .backgroundColor('#F0F0F0')
                .borderRadius(8)
            }
            .width('100%')
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .margin({ bottom: 10 })
        }
        .width('100%')
        .padding(18)
        .backgroundColor(Color.White)
        .borderRadius(8)
        .margin({ bottom: 16 })

        Column() {
          Text($r('app.string.test_foo_callback')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testFooCallback();
          this.currentState = $r('app.string.test_foo_callback_complete');
        })

        Column() {
          Text($r('app.string.test_print_obj')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          // [EndExclude no_any_unknown]
          printObj('abc'); // abc
          // [End no_any_unknown]
          this.currentState = $r('app.string.test_print_obj_complete');
        })

        Column() {
          Text($r('app.string.test_controller')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testControllerValue();
          this.currentState = $r('app.string.test_controller_complete');
        })

        Column() {
          Text($r('app.string.test_no_ctor_signatures')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testNoCtorSignatures();
          this.currentState = $r('app.string.test_no_ctor_signatures_complete');
        })

        Column() {
          Text($r('app.string.test_map_iteration')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testMapIteration();
          this.currentState = $r('app.string.test_map_iteration_complete');
        })

        Column() {
          Text($r('app.string.test_object_entries')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testObjectEntries();
          this.currentState = $r('app.string.test_object_entries_complete');
        })

        Column() {
          Text($r('app.string.test_class_foo')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testTestClassFoo();
          this.currentState = $r('app.string.test_class_foo_complete');
        })

        Column() {
          Text($r('app.string.test_controller_in_block')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testControllerInBlock();
          this.currentState = $r('app.string.test_controller_in_block_complete');
        })

        Column() {
          Text($r('app.string.test_class_a_foo_apply')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testClassAFooApply();
          this.currentState = $r('app.string.test_class_a_foo_apply_complete');
        })

        Column() {
          Text($r('app.string.test_menu_controller')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testTestMenuController();
          this.currentState = $r('app.string.test_menu_controller_complete');
        })

        Column() {
          Text($r('app.string.test_c1_c2_values')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testGetC1C2Values();
          this.currentState = $r('app.string.test_c1_c2_values_complete');
        })

        Column() {
          Text($r('app.string.test_foo_static_method')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testFooStaticMethod();
          this.currentState = $r('app.string.test_foo_static_method_complete');
        })
      }
      .height('100%')
      .width('100%')
      .backgroundColor('#F1F3F5')
      .padding(16);
    }
  }
}

export {}