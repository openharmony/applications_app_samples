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

// [Start import_package]
// 引入ArkTS标准库中的ArkTS容器集。

import { collections } from '@kit.ArkTS';
// [End import_package]
// [Start class_this]
class A {
  bar: string = 'I am A';

  foo() {
    console.info(this.bar);
  }
}

class B {
  bar: string = 'I am B';

  callFunction(fn: () => void) {
    fn();
  }
}

function callFunction(fn: () => void) {
  fn();
}
// [StartExclude class_this]

// [Start function_declaration]
// 常规函数定义。
function add(x: number, y: number): number {
  return x + y;
}
// [StartExclude function_declaration]

// [Start function_overloading]
function foo(x: number): void;            /* 第一个函数定义 */
function foo(x: string): void;            /* 第二个函数定义 */
function foo(x: number | string): void {  /* 函数实现 */
}
// [StartExclude function_overloading]
// [Start namespace_models]
namespace Models {
  export class User {
    // 实现细节。
    // [StartExclude namespace_models]
    name: string = 'DefaultUser';
    // [EndExclude namespace_models]
  }

  export interface Repository {
    // 接口定义。
  }
}
// [End namespace_models]

let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;

function testTypeAnnotation() {
  // [Start variable_declaration]
  // 类型注解（类似Java）。
  let age: number = 20;
  const program: string = 'ArkTS';

  // 类型推断（类似Java的局部变量类型推断）。
  let version = 5.0;
  // [End variable_declaration]

  console.info(`age: ${age}, program: ${program}, version: ${version}`);
  let logMsg = `age: ${age}, program: ${program}, version: ${version}`;
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

function testFunctionDefinition() {
  // [EndExclude function_declaration]
  // 简洁的箭头函数形式。
  const multiply = (a: number, b: number): number => a * b;
  // [End function_declaration]
  console.info(`add(2, 3) = ${add(2, 3)}`);
  console.info(`multiply(4, 5) = ${multiply(4, 5)}`);
  let logMsg = `add(2, 3) = ${add(2, 3)}\nmultiply(4, 5) = ${multiply(4, 5)}`;

  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

function testFunctionOverload() {
  // [EndExclude function_overloading]
  foo(123);     //  OK，使用第一个定义。
  foo('aa'); // OK，使用第二个定义。
  // [End function_overloading]
  let logMsg = `foo success`;

  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

function testImportCollections() {
  let arrayList = new collections.Array(1);
  console.info(`ArrayList: ${arrayList.length} elements`);
  let logMsg = `ArrayList: ${arrayList.length} elements`;
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

function testNamespace() {
  let user = new Models.User();
  console.info(`User created: ${user.name}`);
  let logMsg = `User created: ${user.name}`;
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

function testThisContext() {
  // [EndExclude class_this]
  let a: A = new A();
  let b: B = new B();

  // callFunction(a.foo); // 程序crash。this的上下文发生了变化。
  // b.callFunction(a.foo); // 程序crash。this的上下文发生了变化。
  b.callFunction(a.foo.bind(b)) // 输出'I am B'。
  // [End class_this]

  let logMsg = `b.callFunction: ${b.callFunction(a.foo.bind(b))}`;
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

function testTypeInference() {
  // [Start type_interface]
  let num = 10; // 编译器自动推断num为number类型。
  // [End type_interface]

  console.info(`num = ${num}, type: number`);
  let logMsg = `num = ${num}, type: number`;
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

function testOptionalProperty() {
  // [Start optional_type]
  interface Person {
    name: string;
    age?: number;  // age 是可选属性。
  }

  const person: Person = {
    name: 'Alice',
  };
  // [End optional_type]

  console.info(`person.name = ${person.name}, person.age = ${person.age}`);
  let logMsg = `person.name = ${person.name}, person.age = ${person.age}`;
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

function testUnionType() {
  // [Start unite_type]
  // 联合类型示例。

  let value: string | number;
  value = 'hello';
  value = 123;
  // [End unite_type]

  console.info(`value (string) = ${value}`);
  let logMsg = `value (string) = ${value}\n`;

  console.info(`value (number) = ${value}`);
  logMsg += `value (number) = ${value}`;

  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

@Entry
@Component
struct IndexArkTs {
  @State currentState: string | ResourceStr = $r('app.string.index_notInitialized');
  @State logMessages: string | ResourceStr = $r('app.string.index_noLogMessages');

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
          Text($r('app.string.index_realTimeStatusInformation'))
            .fontSize(18)
            .fontWeight(600)
            .margin({ bottom: 12 })

          Column() {
            Text($r('app.string.index_currentState'))
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
            Text($r('app.string.index_logMessages'))
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
          Text($r('app.string.index_testTypeAnnotation')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testTypeAnnotation();
          this.currentState = $r('app.string.index_typeAnnotationTestCompleted');
        })

        Column() {
          Text($r('app.string.index_testFunctionDefinition')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testFunctionDefinition();
          this.currentState = $r('app.string.index_functionDefinitionTestCompleted');
        })

        Column() {
          Text($r('app.string.index_testFunctionOverload')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testFunctionOverload();
          this.currentState = $r('app.string.index_functionOverloadTestCompleted');
        })

        Column() {
          Text($r('app.string.index_testImportingContainerCollections')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testImportCollections();
          this.currentState = $r('app.string.index_containerCollectionsImportTestCompleted');
        })

        Column() {
          Text($r('app.string.index_testNamespace')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testNamespace();
          this.currentState = $r('app.string.index_namespaceTestCompleted');
        })

        Column() {
          Text($r('app.string.index_testThisContext')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testThisContext();
          this.currentState = $r('app.string.index_thisContextTestCompleted');
        })

        Column() {
          Text($r('app.string.index_testTypeInference')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testTypeInference();
          this.currentState = $r('app.string.index_typeInferenceTestCompleted');
        })

        Column() {
          Text($r('app.string.index_testOptionalProperties')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testOptionalProperty();
          this.currentState = $r('app.string.index_optionalPropertiesTestCompleted');
        })

        Column() {
          Text($r('app.string.index_testUnionTypes')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testUnionType();
          this.currentState = $r('app.string.index_unionTypesTestCompleted');
        })
      }
      .height('100%')
      .width('100%')
      .backgroundColor('#F1F3F5')
      .padding(16);
    }
  }
}