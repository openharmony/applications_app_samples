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

export {};
// [Start function_declaration]
function add(x: string, y: string): string {
  let z: string = `${x} ${y}`;
  return z;
}
// [End function_declaration]
let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;
// [Start optional_parameter_function]
function hello(name?: string) {
  if (name == undefined) {
    console.info('Hello!');
  } else {
    console.info(`Hello, ${name}!`);
  }
}
// [End optional_parameter_function]
function testHelloWithoutParam() {
  hello();
  let logMsg = 'Hello!';
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

function testHelloWithParam() {
  hello('ArkTS');
  let logMsg = 'Hello, ArkTS!';
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}
// [Start default_parameter_function]
function multiply(n: number, coeff: number = 2): number {
  return n * coeff;
}
  // [StartExclude default_parameter_function]
function testOptionalFunction() {
  // [EndExclude default_parameter_function]
  multiply(2);  // 返回2*2
  multiply(2, 3); // 返回2*3
  // [End default_parameter_function]
  console.info(`multiply(2), ${multiply(2)}`);
  console.info(`multiply(2, 3), ${multiply(2, 3)}`);

  let logMsg = `multiply(2): ${multiply(2)}\n` +
    `multiply(2, 3): ${multiply(2, 3)}`;
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}
// [Start rest_parameter_function]
function sum(...numbers: number[]): number {
  let res = 0;
  for (let n of numbers) {
    res += n;
  }
  return res;
}
  // [StartExclude rest_parameter_function]
function testRestParameter() {
  // [EndExclude rest_parameter_function]
  sum(); // 返回0
  sum(1, 2, 3); // 返回6
  // [End rest_parameter_function]
  console.info(`sum(), ${sum()}`);
  console.info(`sum(1, 2, 3), ${sum(1, 2, 3)}`);

  let logMsg = `sum(): ${sum()}\n` +
    `sum(1, 2, 3): ${sum(1, 2, 3)}`;
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}
// [Start return_type_declaration]
// 显式指定返回类型
function foo(): string { return 'foo'; }

// 推断返回类型为string
function goo() { return 'goo'; }
// [End return_type_declaration]
// [Start void_return_type]
function hi1() { console.info('hi'); }
function hi2(): void { console.info('hi'); }
// [End void_return_type]
function testHi1() {
  hi1();
  let logMsg = 'hi';
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

function testHi2() {
  hi2();
  let logMsg = 'hi';
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}
// [Start variable_scope]
let outerVar = 'I am outer ';

function func() {
  let outerVar = 'I am inside';
  console.info(outerVar); // 输出: I am inside
}
  // [StartExclude variable_scope]
function testFunc() {
  // [EndExclude variable_scope]
  func();
  // [End variable_scope]
  let logMsg = 'I am inside';
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}
// [Start function_join_declaration]
function join(x: string, y: string): string {
  let z: string = `${x} ${y}`;
  return z;
}
// [End function_join_declaration]
function testFunctionInvoke() {
  // [Start function_invocation]
  let x = join('hello', 'world');
  console.info(x); // 输出: hello world
  // [End function_invocation]
  let logMsg = x;
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}
// [Start function_as_parameter]
type trigFunc = (x: number) => number // 这是一个函数类型

function doAction(f: trigFunc) {
  f(3.141592653589); // 调用函数
}

doAction(Math.sin); // 将函数作为参数传入
// [End function_as_parameter]
{
  // [Start arrow_function_full]
  let sum = (x: number, y: number): number => {
    return x + y;
  }
  // [End arrow_function_full]
}
// [Start arrow_function_short]
let sum1 = (x: number, y: number) => { return x + y; }
let sum2 = (x: number, y: number) => x + y
// [End arrow_function_short]
// [Start closure_function]
function f(): () => number {
  let count = 0;
  let g = (): number => { count++; return count; };
  return g;
}
  // [StartExclude closure_function]
function testClosure() {
  // [EndExclude closure_function]
  let z = f();
  z(); // 返回：1
  z(); // 返回：2
  // [End closure_function]
  console.info(`one z(), ${z()}`);
  console.info(`two z(), ${z()}`);

  let logMsg = `one z(): ${z()}\n` +
    `two z(): ${z()}`;
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}
// [Start function_overload]
function foo1(x: number): void;            /* 第一个函数定义 */
function foo1(x: string): void;            /* 第二个函数定义 */
function foo1(x: number | string): void {  /* 函数实现 */
}

foo1(123);     //  OK，使用第一个定义
foo1('aa'); // OK，使用第二个定义
// [End function_overload]
@Entry
@Component
struct FunctionDemoPage {
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
          Text($r('app.string.Test_HelloWithoutParam')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testHelloWithoutParam();
          this.currentState = $r('app.string.Test_HelloWithoutParam_finish');
        })

        Column() {
          Text($r('app.string.Test_HelloWithParam')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testHelloWithParam();
          this.currentState = $r('app.string.Test_HelloWithParam_finish');
        })

        Column() {
          Text($r('app.string.Test_OptionalFunction')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testOptionalFunction();
          this.currentState = $r('app.string.Test_OptionalFunction_finish');
        })

        Column() {
          Text($r('app.string.Test_RestParameter')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testRestParameter();
          this.currentState = $r('app.string.Test_RestParameter_finish');
        })

        Column() {
          Text($r('app.string.Test_Hi1')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testHi1();
          this.currentState = $r('app.string.Test_Hi1_finish');
        })

        Column() {
          Text($r('app.string.Test_Hi2')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testHi2();
          this.currentState = $r('app.string.Test_Hi2_finish');
        })

        Column() {
          Text($r('app.string.Test_Func')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testFunc();
          this.currentState = $r('app.string.Test_Func_finish');
        })

        Column() {
          Text($r('app.string.Test_FunctionInvoke')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testFunctionInvoke();
          this.currentState = $r('app.string.Test_FunctionInvoke_finish');
        })

        Column() {
          Text($r('app.string.Test_Closure')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testClosure();
          this.currentState = $r('app.string.Test_Closure_finish');
        })
      }
      .height('100%')
      .width('100%')
      .backgroundColor('#F1F3F5')
      .padding(16);
    }
  }
}