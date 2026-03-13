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

export {}
let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;
// [Start person_class_basic]
class Person {
  public name: string = '';
  public surname: string = '';
  constructor (n: string, sn: string) {
    this.name = n;
    this.surname = sn;
  }
  fullName(): string {
    return this.name + ' ' + this.surname;
  }
}
// [End person_class_basic]
function testClass() {
  // [Start create_person_instance]
  let p = new Person('John', 'Smith');
  console.info(p.fullName());
  // [End create_person_instance]
  let logMsg = p.fullName();
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}
// [Start object_literal_type]
class Point {
  public x: number = 0;
  public y: number = 0;
}
let p: Point = {x: 42, y: 42};
// [End object_literal_type]
// [Start instance_field_declaration]
class Person1 {
  public name: string = '';
  public age: number = 0;
  constructor(n: string, a: number) {
    this.name = n;
    this.age = a;
  }

  getName(): string {
    return this.name;
  }
}
  // [StartExclude instance_field_declaration]
function testInstanceField() {
  // [EndExclude instance_field_declaration]
  let p1 = new Person1('Alice', 25);
  p1.name; // Alice
  let p2 = new Person1('Bob', 28);
  p2.getName(); // Bob
  // [End instance_field_declaration]
  console.info(`p1.name: , ${p1.name}`);
  console.info(`p2.getName(): , ${p2.getName()}`);

  let logMsg = `p1.name: ${p1.name}\n` +
    `p2.getName(): ${p2.getName()}`;
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}
// [Start static_field_declaration]
class Person2 {
  public static numberOfPersons = 0;
  constructor() {
    // ...
    Person2.numberOfPersons++;
    // ...
  }
}

Person2.numberOfPersons;
// [End static_field_declaration]
// [Start non_nullable_field]
class Person3 {
  public name: string = '';

  setName(n: string): void {
    this.name = n;
  }

  // 类型为'string'，不可能为"null"或者"undefined"
  getName(): string {
    return this.name;
  }
}


let jack = new Person3();
// 假设代码中没有对name赋值，即没有调用"jack.setName('Jack')"
jack.getName().length; // 0，没有运行时异常
// [End non_nullable_field]
// [Start getter_setter_methods]
class Person4 {
  public name: string = '';
  private _age: number = 0;
  get age(): number { return this._age; }
  set age(x: number) {
    if (x < 0) {
      throw Error('Invalid age argument');
    }
    this._age = x;
  }
}
  // [StartExclude getter_setter_methods]
try {
  // [EndExclude getter_setter_methods]
  let p = new Person4();
  p.age; // 输出0
  p.age = -42; // 设置无效age值会抛出错误
  // [End getter_setter_methods]
} catch (e) {
  console.info('Invalid age argument');
  let logMsg = 'Invalid age argument (捕获到错误)';
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, true);
  }
}

function testClassSetterAge() {
  let p = new Person4();
  p.age; // 输出0
  console.info(`p.age: ${p.age}`);
  let logMsg = `p.age: ${p.age}`;
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

function testClassSetterAgeError() {
  try {
    let p = new Person4();
    p.age = -42; // 设置无效age值会抛出错误
  } catch (e) {
    console.info('Invalid age argument');
    let logMsg = 'Invalid age argument (捕获到错误)';
    if (globalLogUpdate) {
      globalLogUpdate(logMsg, true);
    }
  }
}
// [Start instance_method_declaration]
class RectangleSize {
  private height: number = 0;
  private width: number = 0;
  constructor(height: number, width: number) {
    this.height = height;
    this.width = width;
  }
  calculateArea(): number {
    return this.height * this.width;
  }
}
// [End instance_method_declaration]
function testInstanceFunction() {
  // [Start instance_method_usage]
  let square = new RectangleSize(10, 10);
  square.calculateArea(); // 输出：100
  // [End instance_method_usage]
  console.info(`square.calculateArea(): ${square.calculateArea()}`);

  let logMsg = `square.calculateArea(): ${square.calculateArea()}`;
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}
// [Start static_method_declaration]
class C2 {
  public static staticMethod(): string {
    return 'this is a static method.';
  }
}
  // [StartExclude static_method_declaration]
function testStaticMethod() {
  // [EndExclude static_method_declaration]
  console.info(C2.staticMethod());
  // [End static_method_declaration]
  let logMsg = C2.staticMethod();
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}
// [Start class_inheritance]
class Person5 {
  public name: string = '';
  public _age = 0;
  get age(): number {
    return this._age;
  }
}
class Employee extends Person5 {
  public salary: number = 0;
  calculateTaxes(): number {
    return this.salary * 0.42;
  }
}
// [End class_inheritance]
// [Start interface_implementation]
interface DateInterface {
  now(): string;
}
class MyDate implements DateInterface {
  now(): string {
    // 在此实现
    return 'now';
  }
}
// [End interface_implementation]
{
  // [Start super_call_in_inheritance]
  class RectangleSize {
    protected height: number = 0;
    protected width: number = 0;

    constructor (h: number, w: number) {
      this.height = h;
      this.width = w;
    }

    draw() {
      /* 绘制边界 */
    }
  }
  class FilledRectangle extends RectangleSize {
    public color = ''
    constructor (h: number, w: number, c: string) {
      super(h, w); // 父类构造函数的调用
      this.color = c;
    }

    draw() {
      super.draw(); // 父类方法的调用
      /* 填充矩形 */
    }
  }
  // [End super_call_in_inheritance]
}

{
  // [Start method_override]
  class RectangleSize {
    // ...
    area(): number {
      // 实现
      return 0;
    }
  }
  class Square extends RectangleSize {
    private side: number = 0;
    area(): number {
      return this.side * this.side;
    }
  }
  // [End method_override]
}
// [Start method_overload]
class C {
  foo(x: number): void;            /* 第一个签名 */
  foo(x: string): void;            /* 第二个签名 */
  foo(x: number | string): void {  /* 实现签名 */
  }
}
let c = new C();
c.foo(123);     // OK，使用第一个签名
c.foo('aa'); // OK，使用第二个签名
// [End method_overload]
{
  // [Start default_field_initialization]
  class Point {
    public x: number = 0;
    public y: number = 0;
  }
  let p = new Point();
  // [End default_field_initialization]
}

{
  // [Start constructor_in_inheritance]
  class RectangleSize {
    constructor(width: number, height: number) {
      // ...
    }
  }
  class Square extends RectangleSize {
    constructor(side: number) {
      super(side, side);
    }
  }
  // [End constructor_in_inheritance]
}

{
  // [Start constructor_overload]
  class C {
    constructor(x: number)             /* 第一个签名 */
    constructor(x: string)             /* 第二个签名 */
    constructor(x: number | string) {  /* 实现签名 */
    }
  }
  let c1 = new C(123);      // OK，使用第一个签名
  let c2 = new C('abc');    // OK，使用第二个签名
  // [End constructor_overload]
}

{
  // [Start object_literal_as_class_instance]
  class C {
    public n: number = 0;
    public s: string = '';
  }

  let c: C = {n: 42, s: 'foo'};
  // [End object_literal_as_class_instance]
}

// [Start structural_typing]
class C1 {
  public n: number = 0;
  public s: string = '';
}

function foo(c1: C1) {}

let c1: C1

c1 = {n: 42, s: 'foo'};  // 使用变量的类型
foo({n: 42, s: 'foo'}); // 使用参数的类型

function bar(): C1 {
  return {n: 42, s: 'foo'}; // 使用返回类型
}
// [End structural_typing]

{
  // [Start class_array_type]
  class C {
    public n: number = 0;
    public s: string = '';
  }
  let cc: C[] = [{n: 1, s: 'a'}, {n: 2, s: 'b'}];
  // [End class_array_type]
}
// [Start record_type_basic]
let map: Record<string, number> = {
  'John': 25,
  'Mary': 21
};
  // [StartExclude record_type_basic]
function testRecord() {
  // [EndExclude record_type_basic]
  map['John']; // 25
  // [End record_type_basic]
  console.info(`map['John']: ${map['John']}`);

  let logMsg = `map['John']: ${map['John']}`;
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

{
  // [Start record_type_complex]
  interface PersonInfo {
    age: number;
    salary: number;
  }
  let map: Record<string, PersonInfo> = {
    'John': { age: 25, salary: 10},
    'Mary': { age: 21, salary: 20}
  }
  // [End record_type_complex]
}
// [Start abstract_class]
abstract class Base {
  private field: number;
  constructor(p: number) {
    this.field = p;
  }
}

class Derived extends Base {
  constructor(p: number) {
    super(p);
  }
}

let x = new Derived(666);
// [End abstract_class]
@Entry
@Component
struct ClassDemoPage {
  @State currentState: string | ResourceStr = $r('app.string.Uninitialized');
  @State logMessages: string | ResourceStr = $r('app.string.No_log_information_available');

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
          Text($r('app.string.Realtime_status_information'))
            .fontSize(18)
            .fontWeight(600)
            .margin({ bottom: 12 })

          Column() {
            Text($r('app.string.Current_status'))
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
            Text($r('app.string.Log_information'))
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
          Text($r('app.string.Test_Class')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testClass();
          this.currentState = $r('app.string.Test_Class_finish');
        })

        Column() {
          Text($r('app.string.Test_InstanceField')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testInstanceField();
          this.currentState = $r('app.string.Test_InstanceField_finish');
        })

        Column() {
          Text($r('app.string.Test_ClassSetterAge')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testClassSetterAge();
          this.currentState = $r('app.string.Test_ClassSetterAge_finish');
        })

        Column() {
          Text($r('app.string.Test_ClassSetterAgeError')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testClassSetterAgeError();
          this.currentState = $r('app.string.Test_ClassSetterAgeError_finish');
        })

        Column() {
          Text($r('app.string.Test_InstanceFunction')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testInstanceFunction();
          this.currentState = $r('app.string.Test_InstanceFunction_finish');
        })

        Column() {
          Text($r('app.string.Test_StaticMethod')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testStaticMethod();
          this.currentState = $r('app.string.Test_StaticMethod_finish');
        })

        Column() {
          Text($r('app.string.Test_Record')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testRecord();
          this.currentState = $r('app.string.Test_Record_finish');
        })
      }
      .height('100%')
      .width('100%')
      .backgroundColor('#F1F3F5')
      .padding(16);
    }
  }
}