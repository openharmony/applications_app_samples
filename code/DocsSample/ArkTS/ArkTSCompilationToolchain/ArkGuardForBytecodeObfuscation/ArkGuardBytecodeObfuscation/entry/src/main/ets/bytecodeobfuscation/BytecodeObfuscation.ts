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
// 混淆前：
import * as m from '../test1/test2';
import { foo } from '../test1/test2';
// [StartExclude optionExample_enableFilenameObfuscation]

// [Start optionExample_keepPropertyName3]
// 示例JSON文件结构(test.json)：
/*
{
  "jsonProperty": "value",
  "otherProperty": "value2"
}
 */
import jsonData from './test.json';
// [StartExclude optionExample_keepPropertyName3]

import { ValuesBucket } from '@kit.ArkData';

// [Start example_limitation]
// example.ts
// 混淆前：
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
// test.ts
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
// [Start optionExample_enableStringPropertyObfuscation1]
// 混淆前：
let person = {'firstName': 'abc'};
person['personAge'] = 22;
// [End optionExample_enablePropertyObfuscation3]
// [End optionExample_enableStringPropertyObfuscation1]

const obj1: Record<string, string> = {
  'ohos.want.action.home': 'value'
};

// [Start optionExample_enableStringPropertyObfuscation2]
// SDK API文件@ohos.app.ability.wantConstant片段：
export enum Params {
  ACTION_HOME = 'ohos.want.action.home'
}
// 开发者源码示例：
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
const module = import('../test1/test2');
// [End optionExample_enableFilenameObfuscation]

let flag = 1;

// [Start optionExample_removeLog1]
// 混淆前：
if (flag) {
  console.info('hello');
}
// [End optionExample_removeLog1]

// [Start optionExample_removeLog2]
console.info('in tolevel');
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

function getValue(value: number): void {
  // [Start optionExample_removeLog5]
  switch (value) {
    case 1:
      console.info('in switch case');
      break;
    default:
      console.info('default');
  }
  // [End optionExample_removeLog5]
}

let obj2 = {t:'1', v:'2'};

// [Start optionExample_keepPropertyName1]
// 混淆配置：
// -enable-property-obfuscation
// -enable-string-property-obfuscation
obj2.t = '0';
console.info(obj2['t']); // 此时，'t'会被正确混淆，t可以选择性保留

obj2['v'] = '0';
console.info(obj2['v']); // 此时，'v'会被正确混淆，v可以选择性保留
// [End optionExample_keepPropertyName1]

// [Start optionExample_keepPropertyName2]
// myclass.ts
export class MyClass02 {
  person = {firstName: '123', personAge: 100};
}
// [End optionExample_keepPropertyName2]

// [EndExclude optionExample_keepPropertyName3]
let jsonProp = jsonData.jsonProperty; // jsonProperty应该被保留

class jsonTest {
  prop1: string = '';
  prop2: number = 0;
}

let obj = new jsonTest();
const jsonStr = JSON.stringify(obj); // prop1 和 prop2 会被混淆，应该被保留
// [End optionExample_keepPropertyName3]

// [Start optionExample_keepPropertyName4]
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
  propertyName1: string = "";   // propertyName1 需要被保留
  // 2.成员方法装饰器
  @MethodDecorator
  methodName1() {} // methodName1 需要被保留
  // 3.方法参数装饰器
  methodName2(@ParamDecorator param: string): void {} // methodName2 需要被保留
}
// [End optionExample_keepPropertyName5]

// [Start optionExample_keepGlobalName1]
// example.ts
export namespace Ns {
  export const myAge = 18; // -keep-global-name myAge 保留变量myAge
  export function myFunc() {} // -keep-global-name myFunc 保留函数myFunc
}
// [End optionExample_keepGlobalName1]

// [Start optionExample_keepGlobalName2]
var a = 0;
console.info(globalThis.a);  // a 应该被保留
function foo2(){}
globalThis.foo2();           // foo2 应该被保留
var c = '0';
console.info(c);             // c 可以被正确地混淆
function bar(){}
bar();                      // bar 可以被正确地混淆
class MyClass {}
let d = new MyClass();      // MyClass 可以被正确地混淆
// [End optionExample_keepGlobalName2]

// [Start optionExample_keepFileName]
// main.ts
const moduleName = './file2';         // moduleName对应的路径名file2应该被保留
const module2 = import(moduleName);
// [End optionExample_keepFileName]

// [Start example_openObfuscation1]
// file.ts
// 静态定义，动态访问：属性名在对象定义时是静态的，但访问时通过动态构建属性名（通常使用字符串拼接）来访问
const obj001 = {
  staticName: 5  // 静态定义属性
};
const fieldName = 'static' + 'Name';  // 动态构建属性名
console.info(obj001[fieldName]);  // 使用方括号语法动态访问属性
// [End example_openObfuscation1]

// [Start example_openObfuscation2]
// file.ts
// 动态定义，静态访问：属性名通过动态表达式在对象定义时确定，但访问时直接使用点语法（假设开发者知道属性名的结果）
const obj002 = {
  ['dynamic' + 'Name']: 5  // 动态定义属性
};
console.info(obj002.dynamicName + ''); // 使用点语法静态访问属性
// [End example_openObfuscation2]