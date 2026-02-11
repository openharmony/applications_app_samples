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

let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;
// [Start variable_reassignment]
let hi: string = 'hello';
hi = 'hello, world';
// [End variable_reassignment]
// [Start const_declaration]
const hello: string = 'hello';
// [End const_declaration]
// [Start type_inference]
let hi1: string = 'hello';
let hi2 = 'hello, world';
// [End type_inference]
// [Start float_type_factorial]
let n1 = 3.14;
let n2 = 3.141592;
let n3 = 0.5;
let n4 = 1e2;

function factorial(n: number): number {
  if (n <= 1) {
    return 1;
  }
  return n * factorial(n - 1);
}
  // [StartExclude float_type_factorial]
function testFloatType() {
  // [EndExclude float_type_factorial]
  factorial(n1) //  7.660344000000002
  factorial(n2) //  7.680640444893748
  factorial(n3) //  1
  factorial(n4) //  9.33262154439441e+157
  // [End float_type_factorial]

  console.info('factorial(n1): ' + factorial(n1));
  console.info('factorial(n2): ' + factorial(n2));
  console.info('factorial(n3): ' + factorial(n3));
  console.info('factorial(n4): ' + factorial(n4));

  let logMsg = 'factorial(n1): ' + factorial(n1) + '\n' +
    'factorial(n2): ' + factorial(n2) + '\n' +
    'factorial(n3): ' + factorial(n3) + '\n' +
    'factorial(n4): ' + factorial(n4);
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

function tesBigIntType() {
  // [Start big_int_type]
  let bigInt: bigint = 999999999999999999999999999999999999999999999999999999999999n;
  console.info('bigInt:' + bigInt.toString());
  // [End big_int_type]
  let logMsg = 'bigInt: ' + bigInt.toString();
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

function tesBoolType() {
  // [Start bool_type]
  let isDone: boolean = false;

  // ...

  if (isDone) {
    console.info('Done!');
  }
  // [End bool_type]
  let logMsg = 'isDone: ' + isDone + '\n(未打印Done!因为isDone为false)';
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}
// [Start string_examples]
let s1 = 'Hello, world!\n';
let s2 = 'this is a string';
let a = 'Success';
let s3 = `The result is ${a}`;
// [End string_examples]
// [Start generic_class]
class Class<T> {
  //...
}
let instance: Class<void>;
// [End generic_class]
// [Start object_types]
let o1: Object = 'Alice';
let o2: Object = ['a', 'b'];
let o3: Object = 1;
let o4: object = [1, 2, 3];
// [End object_types]
// [Start string_array]
let names: string[] = ['Alice', 'Bob', 'Carol'];
// [End string_array]
// [Start enum_color_set]
enum ColorSet { Red, Green, Blue }
let c: ColorSet = ColorSet.Red;
// [End enum_color_set]
{
  // [Start enum_with_values]
  enum ColorSet { White = 0xFF, Grey = 0x7F, Black = 0x00 }
  let c: ColorSet = ColorSet.Black;
  // [End enum_with_values]
}

{
  // [Start union_type_animal]
  class Cat {
    public name: string = 'cat';
    // ...
  }

  class Dog {
    public name: string = 'dog';
    // ...
  }

  class Frog {
    public name: string = 'frog';
    // ...
  }

  type Animal = Cat | Dog | Frog | number | string | null | undefined;
  // Cat、Dog、Frog是一些类型（类或接口）

  let animal: Animal = new Cat();
  animal = new Frog();
  animal = 42;
  animal = 'dog';
  animal = undefined;
  // 可以将类型为联合类型的变量赋值为任何组成类型的有效值
  // [End union_type_animal]
}
// [Start type_narrowing_animal]
class Cat { sleep () {}; meow () {} }
class Dog { sleep () {}; bark () {} }
class Frog { sleep () {}; leap () {} }

type Animal = Cat | Dog | Frog;

function foo(animal: Animal) {
  if (animal instanceof Frog) {  // 判断animal是否是Frog类型
    animal.leap();  // animal在这里是Frog类型
  }
  animal.sleep(); // Animal具有sleep方法
}
// [End type_narrowing_animal]
function testAliasesType() {
  // [Start type_aliases]
  // 二维数组类型
  type Matrix = number[][];
  const gameBoard: Matrix = [
    [1, 0],
    [0, 1]
  ];

  // 函数类型
  type Handler = (s: string, no: number) => string;
  const repeatString: Handler = (str, times) => {
    return str.repeat(times);
  };
  console.info(repeatString('abc', 3)); // 'abcabcabc'
  // [StartExclude type_aliases]
  let logMsg = 'repeatString(\'abc\', 3): ' + repeatString('abc', 3);
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

{
  // [EndExclude type_aliases]
  // 泛型函数类型
  type Predicate<T> = (x: T) => boolean;
  const isEven: Predicate<number> = (num) => num % 2 === 0;

  // 可为空的对象类型
  type NullableObject = Object | null;

  class Cat {
  }

  let animalData: NullableObject = new Cat();
  let emptyData: NullableObject = null;
  // [End type_aliases]
}

function testOperator() {
  // [Start comparison_operators]
  // ==只比较目标的值相等
  console.info(String(null == undefined)); // true
  // ===比较目标的值和类型都相等
  console.info(String(null === undefined)); // false
  // [End comparison_operators]
  let logMsg = 'null == undefined: ' + String(null == undefined) + '\n' +
    'null === undefined: ' + String(null === undefined);
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

function testInstanceOf() {
  // [Start instanceof_operator]
  class Person {}
  const person = new Person();
  if ((person instanceof Person)) {
    console.info('true'); // true
  }

  class Animal {}
  class Bird extends Animal {}
  const bird = new Bird();
  if (bird instanceof Animal) {
    console.info('true'); // true
  }
  // [End instanceof_operator]

  let logMsg = 'person instanceof Person: true\n' +
    'bird instanceof Animal: true';
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

function testIfElse() {
  // [Start if_else_statement]
  let s1 = 'Hello';
  if (s1) {
    console.info(s1); // 打印“Hello”
  }

  let s2 = 'World';
  if (s2.length != 0) {
    console.info(s2); // 打印“World”
  }
  // [End if_else_statement]

  let logMsg = 's1: ' + s1 + '\n' +
    's2: ' + s2;
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

let expression = 1;
let label1 = 1;
let label2 = 2;
let label3 = 3;
// [Start switch_statement]
switch (expression) {
  case label1: // 如果label1匹配，则执行
    // ...
    // 语句1
    // ...
    break; // 可省略
  case label2:
  case label3: // 如果label2或label3匹配，则执行
    // ...
    // 语句23
    // ...
    break; // 可省略
  default:
  // 默认语句
}
// [End switch_statement]
// [Start conditional_expression]
let message = Math.random() > 0.5 ? 'Valid' : 'Failed';
// [End conditional_expression]
function testConditionalExpression() {
  // [Start conditional_expression_results]
  console.info('a' ? 'true' : 'false'); // true
  console.info('' ? 'true' : 'false'); // false
  console.info(1 ? 'true' : 'false'); // true
  console.info(0 ? 'true' : 'false'); // false
  console.info(null ? 'true' : 'false'); // false
  console.info(undefined ? 'true' : 'false'); // false
  // [End conditional_expression_results]
  let logMsg = 'a: true\n' +
    ' : false\n' +
    '1: true\n' +
    '0: false\n' +
    'null: false\n' +
    'undefined: false';
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}
// [Start for_loop]
let sum = 0;
for (let i = 0; i < 10; i += 2) {
  sum += i;
}
// [End for_loop]
function testForOf() {
  let result = '';
  // [Start for_of_loop]
  for (let ch of 'a string object') {
    console.info(ch);
    // [StartExclude for_of_loop]
    result += ch + ' ';
    // [EndExclude for_of_loop]
  }
  // [End for_of_loop]
  let logMsg = '遍历字符: ' + result;
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}
// [Start while_loop]
let n = 0;
let x = 0;
while (n < 3) {
  n++;
  x += n;
}
// [End while_loop]
// [Start do_while_loop]
let i = 0;
do {
  i += 1;
} while (i < 10)
// [End do_while_loop]
{
  // [Start break_statement]
  let x = 0;
  while (true) {
    x++;
    if (x > 5) {
      break;
    }
  }
  // [End break_statement]
}

{
  // [Start labeled_break]
  let x = 1;
  label: while (true) {
    switch (x) {
      case 1:
        // statements
        break label; // 中断while语句
    }
  }
  // [End labeled_break]
}

{
  // [Start continue_statement]
  let sum = 0;
  for (let x = 0; x < 100; x++) {
    if (x % 2 == 0) {
      continue;
    }
    sum += x;
  }
  // [End continue_statement]
}
// [Start try_catch]
try {
  // 可能发生异常的语句块
  // [StartExclude try_catch]
  let result = 1;
  // [EndExclude try_catch]
} catch (e) {
  // 异常处理
  // [StartExclude try_catch]
  // [Start throw_error]
  throw new Error('this error')
  // [End throw_error]
  // [EndExclude try_catch]
}
// [End try_catch]
// [Start error_handling_divide]
class ZeroDivisor extends Error {}

function divide (a: number, b: number): number {
  if (b == 0) {
    throw new ZeroDivisor();
  }
  return a / b;
}

function process(a: number, b: number) {
  try {
    let res = divide(a, b);
    console.info('result: ' + res);
  } catch (x) {
    console.error('some error');
  }
}
// [End error_handling_divide]
// [Start try_catch_finally]
function processData(s: string) {
  let error: Error | null = null;

  try {
    console.info('Data processed: ' + s);
    // ...
    // 可能发生异常的语句
    // ...
  } catch (e) {
    error = e as Error;
    // ...
    // 异常处理
    // ...
  } finally {
    // 无论是否发生异常都会执行的代码
    if (error != null) {
      console.error(`Error caught: input='${s}', message='${error.message}'`);
    }
  }
}
// [End try_catch_finally]
function testProcessNormal() {
  try {
    process(10, 2);
    let logMsg = 'result: 5';
    if (globalLogUpdate) {
      globalLogUpdate(logMsg, false);
    }
  } catch (e) {
    if (globalLogUpdate) {
      globalLogUpdate('执行出错', true);
    }
  }
}

function testProcessError() {
  try {
    process(10, 0);
    let logMsg = 'some error (捕获了除零错误)';
    if (globalLogUpdate) {
      globalLogUpdate(logMsg, true);
    }
  } catch (e) {
    if (globalLogUpdate) {
      globalLogUpdate('异常: ' + e, true);
    }
  }
}

function testProcessData() {
  processData('test data');
  let logMsg = 'Data processed: test data';
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

@Entry
@Component
struct BasicKnowledgePage {
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
          Text($r('app.string.Test_float_data_type')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(22)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testFloatType();
          this.currentState = $r('app.string.Test_float_data_type_finish');
        })

        Column() {
          Text($r('app.string.Test_BigInt_data_type')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(22)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          tesBigIntType();
          this.currentState = $r('app.string.Test_BigInt_data_type_finish');
        })

        Column() {
          Text($r('app.string.Test_Bool_data_type')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(22)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          tesBoolType();
          this.currentState = $r('app.string.Test_Bool_data_type_finish');
        })

        Column() {
          Text($r('app.string.Test_Operator')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(22)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testOperator();
          this.currentState = $r('app.string.Test_Operator_finish');
        })

        Column() {
          Text($r('app.string.Test_Instanceof')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(22)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testInstanceOf();
          this.currentState = $r('app.string.Test_Instanceof_finish');
        })

        Column() {
          Text($r('app.string.Test_if_else')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(22)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testIfElse();
          this.currentState = $r('app.string.Test_if_else_finish');
        })

        Column() {
          Text($r('app.string.Test_ConditionalExpression')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(22)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testConditionalExpression();
          this.currentState = $r('app.string.Test_ConditionalExpression_finish');
        })

        Column() {
          Text($r('app.string.Test_ForOf')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(22)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testForOf();
          this.currentState = $r('app.string.Test_ForOf_finish');
        })

        Column() {
          Text($r('app.string.Test_AliasesType')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(22)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testAliasesType();
          this.currentState = $r('app.string.Test_AliasesType_finish');
        })

        Column() {
          Text($r('app.string.Test_ProcessNormal')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(22)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testProcessNormal();
          this.currentState = $r('app.string.Test_ProcessNormal_finish');
        })

        Column() {
          Text($r('app.string.Test_ProcessError')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(22)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testProcessError();
          this.currentState = $r('app.string.Test_ProcessError_finish');
        })

        Column() {
          Text($r('app.string.Test_ProcessData')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(22)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testProcessData();
          this.currentState = $r('app.string.Test_ProcessData_finish');
        })
      }
      .height('100%')
      .width('100%')
      .backgroundColor('#F1F3F5')
      .padding(16);
    }
  }
}