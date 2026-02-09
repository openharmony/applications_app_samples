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

// [Start optionExample_enableFilenameObfuscation]
// example.ts
// 混淆前：
import * as m from '../FilenameObfuscationTest/FilenameObfuscationTest';
import { foo } from '../FilenameObfuscationTest/FilenameObfuscationTest';
// [StartExclude optionExample_enableFilenameObfuscation]

// [Start optionExample_keepPropertyName3]
import jsonData from './ImportJson.json';
// [StartExclude optionExample_keepPropertyName3]

// [Start optionExample_keepPropertyName4]
import { ValuesBucket } from '@kit.ArkData';
// [StartExclude optionExample_keepPropertyName4]

// [Start example_limitation]
// 混淆前：
// example.ts
class A1 {
  prop1: string = '';
}

class A2 {
  prop1: string = '';
}

function test(input: A1) {
  console.info(input.prop1);
}

let a2 = new A2();
a2.prop1 = 'prop a2';
test(a2);
// [End example_limitation]

// [Start optionExample_enablePropertyObfuscation1]
// [Start optionExample_compact]
// 混淆前：
class TestA {
  static prop1: number = 0;
}
TestA.prop1;
// [End optionExample_enablePropertyObfuscation1]
// [End optionExample_compact]

// [Start optionExample_enablePropertyObfuscation2]
// example.ts
export class MyClass01 {
  data1: string;
}
// [End optionExample_enablePropertyObfuscation2]

// [Start optionExample_enablePropertyObfuscation3]
let person1 = {exampleName: "aaa"};
let name = person1.exampleName;
// [End optionExample_enablePropertyObfuscation3]

// [Start optionExample_enableStringPropertyObfuscation1]
// 混淆前：
// example.ts
let person = {"exampleName": "abc"};
person["exampleAge"] = 22;
// [End optionExample_enableStringPropertyObfuscation1]

// [Start optionExample_enableStringPropertyObfuscation2]
// SDK API文件@ohos.app.ability.wantConstant片段：
export enum Params {
  ACTION_HOME = 'ohos.want.action.home'
}

// 开发者源码示例：
const obj1: Record<string, string> = {
  'ohos.want.action.home': 'value'
}
let params = obj1['ohos.want.action.home'];
// [End optionExample_enableStringPropertyObfuscation2]

// [Start optionExample_enableToplevelObfuscation]
// 混淆前：
let count = 0;
// [End optionExample_enableToplevelObfuscation]

// [Start optionExample_enableExportObfuscation]
// 混淆前：
namespace ns {
  export type customT = string;
}
// [End optionExample_enableExportObfuscation]

// [EndExclude optionExample_enableFilenameObfuscation]
m.foo();
foo();
async function func1() {
  const modules = await import('../FilenameObfuscationTest/FilenameObfuscationTest');
  const result = modules.foo();
}
// [End optionExample_enableFilenameObfuscation]

// [Start optionExample_removeComments]
/**
 * @todo
 */
declare let count1: number;
// [End optionExample_removeComments]

// [Start optionExample_removeLog1]
// 混淆前：
function add(a: number, b: number) {
  console.info("result", a + b);
  return a + b;
}
// [End optionExample_removeLog1]

// [Start optionExample_removeLog2]
console.info("in tolevel");
// [End optionExample_removeLog2]

// [Start optionExample_removeLog3]
function foo1() {
  console.info('in block');
}
// [End optionExample_removeLog3]

// [Start optionExample_removeLog4]
// example.ts
namespace ns {
  console.info('in ns');
}
// [End optionExample_removeLog4]

// [Start optionExample_removeLog5]
function getDayName(day: number): string {
  switch (day) {
    case 1:
      console.info("Matched case 1: 星期一");
      return "星期一";
    case 2:
      console.info("Matched case 2: 星期二");
      return "星期二";
    default:
      console.error("No matching case for day:", day);
      return "无效的日期";
  }
}
// [End optionExample_removeLog5]

// [Start optionExample_printKeptNames1]
enum Test1 {
  member1,
  member2
}
// [End optionExample_printKeptNames1]

// [Start optionExample_printKeptNames2]
// example.ts
let outdoor = 1;
enum Test2 {
  member1,
  member2 = outdoor + member1 + 2
}
// [End optionExample_printKeptNames2]

// [Start optionExample_useKeepInSource1]
// 保留类名和所有成员名
// @KeepSymbol
class MyClass02 {
  prop01: string = "prop"; // MyClass02和prop01不会被混淆
}

// 通过构造函数保留类名
class MyClass03 {
  prop02: string = "prop";
  // @KeepSymbol
  constructor() {}; // MyClass03不会被混淆
}

// 保留类名和指定的字段名和方法，类中MyClass04，prop03_1，method03_2不会被混淆
class MyClass04 {
  // @KeepSymbol
  prop03_1: string = "prop";
  prop03_2: number = 1;
  constructor() {};

  method03_1(): void {};
  // @KeepSymbol
  method03_2(): void {};
}
// [End optionExample_useKeepInSource1]

// [Start optionExample_useKeepInSource2]
// 保留接口名和所有成员名，MyInterface01，name01，foo01不会被混淆
// @KeepSymbol
interface MyInterface01 {
  name01: string;
  foo01(): void;
}

// 保留接口名和指定的字段和方法名，MyInterface02，name02不会被混淆
interface MyInterface02 {
  // @KeepSymbol
  name02: string;
  foo02(): void;
}
// [End optionExample_useKeepInSource2]

// [Start optionExample_useKeepInSource3]
// 保留枚举名和所有成员名，Color01，RED01，BLUE01不会被混淆
// @KeepSymbol
enum Color01 {
  RED01,
  BLUE01
}

// 保留枚举名指定的枚举成员名
enum Color02 {
  RED02,
  // @KeepSymbol
  BLUE02 // Color02，BLUE02不会被混淆
}
// [End optionExample_useKeepInSource3]

// [Start optionExample_useKeepInSource4]
// 保留函数名，MyAdd不会被混淆
// @KeepSymbol
function MyAdd(a: number, b:number): number {
  return a + b;
}
// [End optionExample_useKeepInSource4]

// [Start optionExample_useKeepInSource5]
// 保留命名空间名以及内部直接导出的成员名称，MyNameSpace以及foo不会被混淆
// @KeepSymbol
namespace MyNameSpace {
  export function foo(){};
  function bar(){};
}
// [End optionExample_useKeepInSource5]

// [Start optionExample_useKeepInSource6]
// 保留被标记的变量名，myVal不会被混淆
// @KeepSymbol
const myVal = 1;
// [End optionExample_useKeepInSource6]

// [Start optionExample_useKeepInSource7]
// @KeepAsConsumer
export class MyClass05 {
  prop01: string = "prop";
}
// [End optionExample_useKeepInSource7]

// [Start optionExample_useKeepInSource8]
// example.ts
const myMethodName = "myMethod";

// 11，aa，myMethod不会被收集到白名单中
class MyClass06 {
  // @KeepSymbol
  11:11;
  // @KeepSymbol
  'aa':'aa';
  // @KeepSymbol
  [myMethodName](){}
}

// RED不会被收集到白名单中
enum MyEnum {
  // @KeepSymbol
  'RED',
  BLUE
}
// [End optionExample_useKeepInSource8]

// [Start optionExample_keepPropertyName1]
// 混淆配置：
// -enable-property-obfuscation
// -enable-string-property-obfuscation

// example.ts
var obj2 = {t:'1', m:'2'};
obj2.t = 'a';
console.info(obj2['t']); // 此时，'t'会被正确混淆，t可以选择性保留

obj2['m'] = 'b';
console.info(obj2['m']); // 此时，'m'会被正确混淆，m可以选择性保留
// [End optionExample_keepPropertyName1]

// [Start optionExample_keepPropertyName2]
// 间接导出MyClass07
class MyClass07 {
  greet() {}
}
let alias = new MyClass07();
export { alias };

// 直接导出MyClass08
export class MyClass08 {
  exampleName: 'jack'
  exampleAge: 100
}
// [End optionExample_keepPropertyName2]

// [EndExclude optionExample_keepPropertyName3]
let jsonProp = jsonData.jsonProperty; // jsonProperty应该被保留

class jsonTest {
  prop1: string = '';
  prop2: number = 0
}

let obj = new jsonTest();
const jsonStr = JSON.stringify(obj); // prop1 和 prop2 会被混淆，应该被保留
// [End optionExample_keepPropertyName3]

// [EndExclude optionExample_keepPropertyName4]
const valueBucket: ValuesBucket = {
  ID1: 'ID1', // ID1应该被保留
  NAME1: 'jack', // NAME1应该被保留
  AGE1: 20, // AGE1应该被保留
  SALARY1: 100 // SALARY1应该被保留
}
// [End optionExample_keepPropertyName4]

// [Start optionExample_keepPropertyName5]
function CustomDecorator(target: Object, propertyKey: string) {}
function MethodDecorator(target: Object, propertyKey: string, descriptor: PropertyDescriptor) {}
function ParamDecorator(target: Object, propertyKey: string, parameterIndex: number) {}

class A {
  // 1.成员变量装饰器
  @CustomDecorator
  propertyName1: string = ""   // propertyName1 需要被保留
  // 2.成员方法装饰器
  @MethodDecorator
  methodName1() {} // methodName1 需要被保留
  // 3.方法参数装饰器
  methodName2(@ParamDecorator param: string): void {} // methodName2 需要被保留
}
// [End optionExample_keepPropertyName5]

// [Start optionExample_keepGlobalName]
// example.ts
export namespace Ns {
  export const myAge = 18 // -keep-global-name myAge 保留变量myAge
  export function myFunc() {} // -keep-global-name myFunc 保留函数myFunc
}
// [End optionExample_keepGlobalName]

// [Start optionExample_keepFileName]
// main.ts
const moduleName = './DynamicImportFile'; // moduleName对应的路径名DynamicImportFile应该被保留
async function func2() {
  const modules = await import(moduleName);
  const result = modules.foo();
}
// [End optionExample_keepFileName]

// [Start optionExample_keepComments]
/**
 * @class exportClass
 */
export class exportClass {}
// [End optionExample_keepComments]

// [Start example_openObfuscation1]
// 静态定义，动态访问：属性名在对象定义时是静态的，但访问时通过动态构建属性名（通常使用字符串拼接）来访问
// example.ts
const obj001 = {
  staticName: 'value'  // 静态定义属性
};
const fieldName = 'static' + 'Name';  // 动态构建属性名，需使用-keep-property-name staticName来保留该属性名
console.info(obj001[fieldName]);  // 使用方括号语法动态访问属性
// [End example_openObfuscation1]

// [Start example_openObfuscation2]
// 动态定义，静态访问：属性名通过动态表达式在对象定义时确定，但访问时直接使用点语法（假设开发者知道属性名的结果）
// example.ts
const dynamicExpression = 'dynamicPropertyName';
const obj002 = {
  [dynamicExpression]: 'value'  // 动态定义属性
};
console.info(obj002.dynamicPropertyName);//使用点语法静态访问属性，需使用-keep-property-name dynamicPropertyName来保留该属性名
// [End example_openObfuscation2]