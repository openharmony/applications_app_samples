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

// [Start noESObject_app_incorrectExample]
import { getObject1 } from './lib'
// [StartExclude noESObject_app_incorrectExample]

// [Start noESObject_app_correctExample]
import { getObject2, I } from './lib'
// [StartExclude noESObject_app_correctExample]

let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;

// [Start Upper_Camel_Case]
// 类名
class User {
  username: string

  constructor(username: string) {
    this.username = username;
  }

  sayHi() {
    console.info('hi' + this.username);
  }
}

// 枚举名
enum UserType {
  TEACHER = 0,
  STUDENT = 1
};

// 命名空间
namespace Base64Utils {
  export function encrypt() {
    // todo encrypt
  }

  export function decrypt() {
    // todo decrypt
  }
};
// [End Upper_Camel_Case]

function testUpperCamelCase() {
  let a = new User('test');
  let res = a.sayHi();
  console.log(`class return ${res}`);
  let logMsg = 'class return ' + res;

  let result = UserType.TEACHER;
  console.log(`enum return ${result}`);
  logMsg = 'enum return ' + result;

  Base64Utils.encrypt();

  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

// [Start lower_Camel_Case]
let msg = 'Hello world';

function sendMsg(msg: string) {
  // todo send message
  // [StartExclude lower_Camel_Case]
  console.log(`send msg is ${msg}`);
  let logMsg = 'send msg is ' + msg;

  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
  // [EndExclude lower_Camel_Case]
}

let userName = 'Zhangsan';

function findUser(userName: string) {
  // todo find user by user name
  // [StartExclude lower_Camel_Case]
  console.log(`userName is ${userName}`);
  let logMsg = 'userName is ' + userName;

  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
  // [EndExclude lower_Camel_Case]
}
// [End lower_Camel_Case]

function testLowerCamelCase() {
  sendMsg(msg);
  findUser(userName);
}
// [Start Uppercase_Underline]
enum UserType1 {
  TEACHER = 0,
  STUDENT = 1
};

const MAX_USER_SIZE = 10000;
// [End Uppercase_Underline]

function testAllUpper() {
  console.log(`MAX_USER_SIZE is ${MAX_USER_SIZE}`);
  let logMsg = 'MAX_USER_SIZE is ' + MAX_USER_SIZE;

  let res = UserType.TEACHER;
  console.log(`enum is ${res}`);
  logMsg = 'enum is ' + res;

  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

// [Start boolean_guide_incorrectExample]
let isNoError = true;
let isNotFound = false;

function empty() {}
function next() {}
// [End boolean_guide_incorrectExample]

// [Start boolean_guide_correctExample]
let isError = false;
let isFound = true;

function isEmpty() {}
function hasNext() {}
// [End boolean_guide_correctExample]

function testBool() {
  empty();
  next();
  isEmpty();
  hasNext();
}

// [Start spaces_indentation]
class DataSource {
  id: number = 0
  title: string = ''
  content: string = ''
}

const dataSource: DataSource[] = [
  {
    id: 1,
    title: 'Title 1',
    content: 'Content 1'
  },
  {
    id: 2,
    title: 'Title 2',
    content: 'Content 2'
  }

];

function test(dataSource: DataSource[]) {
  if (!dataSource.length) {
    return;
  }

  for (let data of dataSource) {
    if (!data || !data.id || !data.title || !data.content) {
      continue;
    }
    // some code
  }

  // some code
}
// [End spaces_indentation]

function testNoTab() {
  test(dataSource);
}

function noCurlyBraces() {
  // [Start use_braces_incorrectExample]
  let condition = true;
  if (condition)
    console.info('success');
  for (let idx = 0; idx < 5; ++idx)
    console.info('', idx);
  // [End use_braces_incorrectExample]
}

function hasCurlyBraces() {
  // [Start use_braces_correctExample]
  let condition = true;
  if (condition) {
    console.info('success');
  }
  for (let idx = 0; idx < 5; ++idx) {
    console.info('', idx);
  }
  // [End use_braces_correctExample]
}

function testCurlyBraces() {
  noCurlyBraces();
  hasCurlyBraces();
}

function doSomething() {
  console.log('in doSomething');
}

function doOtherthing() {
  console.log('in doOtherthing');
}

function testSwitch(condition: number) {
  // [Start switch_guide]
  switch (condition) {
    case 0: {
      doSomething();
      break;
    }
    case 1: {
      doOtherthing();
      break;
    }
    default:
      break;
  }
  // [End switch_guide]
}

const MAX_USER_COUNT = 1000;
const MIN_USER_COUNT = 100;

function testOperator(userCount: number) {
  // [Start line_break_style]
  // 假设条件语句超出行宽
  if (userCount > MAX_USER_COUNT ||
    userCount < MIN_USER_COUNT) {
    doSomething();
  }
  // [End line_break_style]
}

function testDefineVariables(upOrDown: boolean) {
  if (!upOrDown) {
    // 错误示例: let maxCount = 10, isCompleted = false;
    // 错误示例: let pointX, pointY;
    // 错误示例: pointX = 10; pointY = 0;
  } else {
    // [Start variable_definitions_rule]
    let maxCount = 10;
    let isCompleted = false;
    let pointX = 0;
    let pointY = 0;
    // [End variable_definitions_rule]
  }
}

function testSpaceSpecification(isJedi: boolean) {
  // [Start highlight_keywords_incorrectExample]
  // if 和左括号 ( 之间没有加空格
  if(isJedi) {
    fight();
  }
  // [StartExclude highlight_keywords_incorrectExample]

  // [Start highlight_keywords_correctExample]
  // if 和左括号之间加一个空格
  if (isJedi) {
    fight();
  }
  // [StartExclude highlight_keywords_correctExample]

  let flag = true;

  // [Start highlight_else_incorrectExample]
  if (flag) {
    // ...
  }else { // else 与其前面的大括号 } 之间没有加空格
    // ...
  }
  // [End highlight_else_incorrectExample]

  // [Start highlight_else_correctExample]
  if (flag) {
    // ...
  } else { // else 与其前面的大括号 } 之间增加空格
    // ...
  }
  // [End highlight_else_correctExample]
}

  // [EndExclude highlight_keywords_incorrectExample]
// 函数名fight和左括号 ( 之间加了空格
function fightBad (): void {
  console.info('Swooosh!');
}
// [End highlight_keywords_incorrectExample]

  // [EndExclude highlight_keywords_correctExample]
// 函数名fight和左括号 ( 之间不加空格
function fight(): void {
  console.info('Swooosh!');
}
  // [End highlight_keywords_correctExample]

  // [Start highlight_brace_correctExample]
function foo() { // 函数声明时，左大括号 { 之前加个空格
  // ...
}
  // [StartExclude highlight_brace_correctExample]

interface BarOptions {
  age: string;
  sbreed: string;
}

function bar(str: string, options: BarOptions) {
 // ...
}

function myFunc(bar: string, foo: string, baz: string) {
  // ...
}

function testAll() {
  testSwitch(0);
  testOperator(500);
  testDefineVariables(true);
  testSpaceSpecification(true);
  foo();
  // [EndExclude highlight_brace_correctExample]
  bar('attr', { // 左大括号前加个空格
    age: '1 year',
    sbreed: 'Bernese Mountain Dog',
  });
  // [End highlight_brace_correctExample]

  let bar1 = 'bar1';
  let foo1 = 'foo1';
  let baz = 'baz';
  // [Start highlight_comma_correctExample]
  const arr = [1, 2, 3]; // 数组初始化中的逗号后面加个空格，逗号前面不加空格
  myFunc(bar1, foo1, baz); // 函数的多个参数之间的逗号后加个空格，逗号前面不加空格
  // [End highlight_comma_correctExample]

  // [Start single_quotation_incorrectExample]
  let message1 = 'world';
  console.info(message1);
  // [End single_quotation_incorrectExample]

  // [Start single_quotation_correctExample]
  let message2 = 'world';
  console.info(message2);
  // [End single_quotation_correctExample]
}

{
  // [Start many_properties_incorrectExample]
  // [Start many_properties_correctExample]
  interface I {
    name: string
    age: number
    value: number
    sum: number
    foo: boolean
    bar: boolean
  }

  // [StartExclude many_properties_correctExample]
  let obj1: I = { name: 'tom', age: 16, value: 1, sum: 2, foo: true, bar: false }
  // [End many_properties_incorrectExample]

  // [EndExclude many_properties_correctExample]
  let obj2: I = {
    name: 'tom',
    age: 16,
    value: 1,
    sum: 2,
    foo: true,
    bar: false
  }
  // [End many_properties_correctExample]
}

function doThing1() {
  // ...
}
function doThing2() {
  // ...
}
function doThing3() {
  // ...
}

let isOk = true;

// [Start put_else_incorrectExample]
if (isOk) {
  doThing1();
  doThing2();
}
else {
  doThing3();
}
// [End put_else_incorrectExample]

// [Start put_else_correctExample]
if (isOk) {
  doThing1();
  doThing2();
} else {
  doThing3();
}
// [End put_else_correctExample]

// [Start put_catch_incorrectExample]
try {
  doSomething();
}
catch (err) {
  // 处理错误。
}
// [End put_catch_incorrectExample]

// [Start put_catch_correctExample]
try {
  doSomething();
} catch (err) {
  // 处理错误。
}
// [End put_catch_correctExample]

// [Start put_brace_incorrectExample]
function foo1()
{
  // ...
}
// [End put_brace_incorrectExample]

// [Start put_brace_correctExample]
function foo2() {
  // ...
}
// [End put_brace_correctExample]

// [Start accessible_modifiers_incorrectExample]
class C1 {
  count: number = 0

  getCount(): number {
    return this.count
  }
}
// [End accessible_modifiers_incorrectExample]

// [Start accessible_modifiers_correctExample]
class C2 {
  private count: number = 0

  public getCount(): number {
    return this.count
  }
}
// [End accessible_modifiers_correctExample]

// [Start not_omit_incorrectExample]
const num1 = .5;
const num2 = 2.;
const num3 = -.7;
// [End not_omit_incorrectExample]

// [Start not_omit_correctExample]
const num4 = 0.5;
const num5 = 2.0;
const num6 = -0.7;
// [End not_omit_correctExample]

{
  let foo = Number.NaN;

  // [Start check_NaN_incorrectExample]
  if (foo == Number.NaN) {
    // ...
  }

  if (foo != Number.NaN) {
    // ...
  }
  // [End check_NaN_incorrectExample]

  // [Start check_NaN_correctExample]
  if (Number.isNaN(foo)) {
    // ...
  }

  if (!Number.isNaN(foo)) {
    // ...
  }
  // [End check_NaN_correctExample]
}

// [Start array_methods_incorrectExample]
// [Start array_methods_correctExample]
const numbers = [1, 2, 3, 4, 5];
// [StartExclude array_methods_correctExample]
// 依赖已有数组来创建新的数组时，通过for遍历，生成一个新数组
const increasedByOne1: number[] = [];
for (let i = 0; i < numbers.length; i++) {
  increasedByOne1.push(numbers[i] + 1);
}
// [End array_methods_incorrectExample]

// [EndExclude array_methods_correctExample]
// better: 使用map方法是更好的方式
const increasedByOne2: number[] = numbers.map(num => num + 1);
// [End array_methods_correctExample]

{
  let isFoo = true;
  // [Start assignValues_expressions_incorrectExample]
  // 在控制性判断中赋值不易理解
  if (isFoo = false) {
    // ...
  }
  // [End assignValues_expressions_incorrectExample]
}
{
  // [Start assignValues_expressions_correctExample]
  const isFoo = false; // 在上面赋值，if条件判断中直接使用
  if (isFoo) {
    // ...
  }
  // [End assignValues_expressions_correctExample]
}

// [Start finally_incorrectExample]
function foo4() {
  try {
    // ...
    return 1;
  } catch (err) {
    // ...
    return 2;
  } finally {
    return 3;
  }
}
// [End finally_incorrectExample]

// [Start finally_correctExample]
function foo5() {
  try {
    // ...
    return 1;
  } catch (err) {
    // ...
    return 2;
  } finally {
    console.info('XXX!');
  }
}
// [End finally_correctExample]

// [EndExclude noESObject_app_incorrectExample]
let obj1: I = getObject1(123);
// [End noESObject_app_incorrectExample]

// [EndExclude noESObject_app_correctExample]
let obj2: I = getObject2(123);
// [End noESObject_app_correctExample]

{
  // [Start use_T_incorrectExample]
  let x: Array<number> = [1, 2, 3];
  let y: Array<string> = ['a', 'b', 'c'];
  // [End use_T_incorrectExample]
}

{
  // [Start use_T_correctExample]
  // 统一使用T[]语法。
  let x: number[] = [1, 2, 3];
  let y: string[] = ['a', 'b', 'c'];
  // [End use_T_correctExample]
}

@Entry
@Component
struct IndexArkTs {
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
          Text($r('app.string.upper_camel_case')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testUpperCamelCase();
          this.currentState = $r('app.string.test_upper_camel_case_complete');
        })

        Column() {
          Text($r('app.string.lower_camel_case')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testLowerCamelCase();
          this.currentState = $r('app.string.test_lower_camel_case_complete');
        })

        Column() {
          Text($r('app.string.constant_naming_uppercase')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testAllUpper();
          this.currentState = $r('app.string.test_constant_naming_complete');
        })

        Column() {
          Text($r('app.string.boolean_naming')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testBool();
          this.currentState = $r('app.string.test_boolean_naming_complete');
        })

        Column() {
          Text($r('app.string.space_indentation')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testNoTab();
          this.currentState = $r('app.string.test_space_indentation_complete');
        })

        Column() {
          Text($r('app.string.use_braces')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testCurlyBraces();
          this.currentState = $r('app.string.test_use_braces_complete');
        })

        Column() {
          Text($r('app.string.comprehensive_test')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testAll();
          this.currentState = $r('app.string.test_comprehensive_complete');
        })
      }
      .height('100%')
      .width('100%')
      .backgroundColor('#F1F3F5')
      .padding(16);
    }
  }
}