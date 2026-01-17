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

let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;

// [Start const_variable]
const index = 10000; // 该变量在后续过程中未发生改变，建议声明成常量。
// [End const_variable]

function testVariable() {
// [Start number_int_float]
  let intNum = 1;
  intNum = 1.1;  // 该变量在声明时为整型数据，建议后续不要赋值浮点型数据。

  let doubleNum = 1.1;
  doubleNum = 1;  // 该变量在声明时为浮点型数据，建议后续不要赋值整型数据。
// [End number_int_float]

  console.info(`const index = ${index}`);
  let logMsg = 'const index = ' + index;

  console.info(`const intNum = ${intNum}`);
  logMsg = 'const intNum = ' + intNum;

  console.info(`const doubleNum = ${doubleNum}`);
  logMsg = 'const doubleNum = ' + doubleNum;

  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

// [Start constant_in_loop_poor]
class Time {
  static start: number = 0;
  static info: number[] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
}

function getNum(num: number): number {
  let total: number = 348;
  for (let index: number = 0x8000; index > 0x8; index >>= 1) {
    // 此处会多次对Time的info及start进行查找，并且每次查找出来的值是相同的。
    total += ((Time.info[num - Time.start] & index) !== 0) ? 1 : 0;
  }
  return total;
}
// [End constant_in_loop_poor]

// [Start constant_in_loop_batter]
class TimeBetter {
  static start: number = 0;
  static info: number[] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
}

function getNumBetter(num: number): number {
  let total: number = 348;
  const info = TimeBetter.info[num - TimeBetter.start];  // 从循环中提取不变量。
  for (let index: number = 0x8000; index > 0x8; index >>= 1) {
    if ((info & index) != 0) {
      total++;
    }
  }
  return total;
}
// [End constant_in_loop_batter]

function testGetNum() {
  let res = getNum(1);

  console.log(`getNum return ${res}`);
  let logMsg = 'getNum return ' + res;

  let result = getNumBetter(2);
  console.log(`getNumBetter return ${result}`);
  logMsg = 'getNumBetter return ' + result;

  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

// [Start outside_variable_poor]
let arr = [0, 1, 2];

function fooWithout(): number {
  return arr[0] + arr[1];
}

fooWithout();
// [End outside_variable_poor]

// [Start outside_variable_batter]
let arr_ = [0, 1, 2];

function fooWithArray(array: number[]): number {
  return array[0] + array[1];
}

fooWithArray(arr_);
// [End outside_variable_batter]

function testArrayUse() {
  let res = fooWithout();
  console.log(`fooWithout return ${res}`);
  let logMsg = 'fooWithout return ' + res;

  let result = fooWithArray(arr_);
  console.log(`fooWithArray return ${result}`);
  logMsg = 'fooWithArray return ' + result;

  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

// [Start avoid_optional_parameters_poor]
function add(left?: number, right?: number): number | undefined {
  if (left != undefined && right != undefined) {
    return left + right;
  }
  return undefined;
}
// [End avoid_optional_parameters_poor]

// [Start avoid_optional_parameters_batter]
function addWithParams(left: number = 0, right: number = 0): number {
  return left + right;
}
// [End avoid_optional_parameters_batter]

function testParameter() {
  let res = add();
  console.log(`add return ${res}`);
  let logMsg = `add return ${res}`;

  let result = addWithParams();
  console.log(`addWithParams return ${result}`);
  logMsg = `addWithParams return ${result}`;

  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

// [Start use_typearray_poor]
const arr1 = new Array<number>(1, 2, 3);
const arr2 = new Array<number>(4, 5, 6);
let res = new Array<number>(3);
for (let i = 0; i < 3; i++) {
  res[i] = arr1[i] + arr2[i];
}
// [End use_typearray_poor]

// [Start use_typearray_batter]
const typedArray1 = Int8Array.from([1, 2, 3]);
const typedArray2 = Int8Array.from([4, 5, 6]);
let res1 = new Array<number>(3);
for (let i = 0; i < 3; i++) {
  res1[i] = typedArray1[i] + typedArray2[i];
}
// [End use_typearray_batter]

function testTypeArray() {
  let res = new Array<number>(3);
  for (let i = 0; i < 3; i++) {
    res[i] = arr1[i] + arr2[i];
  }
  console.log(`res is ${res}`);
  let logMsg = `res is ${res}`;

  let result = new Int8Array(3);
  for (let i = 0; i < 3; i++) {
    result[i] = typedArray1[i] + typedArray2[i];
  }
  console.log(`result is ${result}`);
  logMsg = `result is ${result}`;

  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

function testBigArray() {
  // [Start avoid_sparse_array]
  // 直接分配100000大小的数组，运行时会处理成用hash表来存储元素。
  let count = 100000;
  let res: number[] = new Array(count).fill(0);

  // 创建数组后，直接在9999处赋值，会变成稀疏数组。
  let result: number[] = [];
  result[9999] = 0;
  // [End avoid_sparse_array]
  console.log(`res size is ${res.length}`);
  let logMsg = `res size is ${res.length}`;
  console.log(`result size is ${result.length}`);
  logMsg = `result size is ${result.length}`;

  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

function testUnionTypeArray() {
  // [Start avoid_joint_type_poor]
  let arrNum: number[] = [1, 1.1, 2]; // 数值数组中混合使用整型数据和浮点型数据。
  let arrUnion: (number | string)[] = [1, 'hello']; // 联合类型数组。
  // [End avoid_joint_type_poor]
  // [Start avoid_joint_type_batter]
  let arrInt: number[] = [1, 2, 3];
  let arrDouble: number[] = [0.1, 0.2, 0.3];
  let arrString: string[] = ['hello', 'world'];
  // [End avoid_joint_type_batter]

  console.log(`arrNum size is ${typeof arrNum[0]}`);
  console.log(`arrNum size is ${typeof arrNum[1]}`);
  let logMsg = `arrNum size is ${typeof arrNum[0]}`;
  logMsg = `arrNum size is ${typeof arrNum[1]}`;

  console.log(`arrUnion size is ${typeof arrUnion[0]}`);
  console.log(`arrUnion size is ${typeof arrUnion[1]}`);
  logMsg = `arrUnion size is ${typeof arrUnion[0]}`;
  logMsg = `arrUnion size is ${typeof arrUnion[1]}`;

  console.log(`arrInt size is ${typeof arrInt[0]}`);
  logMsg = `arrInt size is ${typeof arrInt[0]}`;

  console.log(`arrDouble size is ${typeof arrDouble[0]}`);
  logMsg = `arrDouble size is ${typeof arrDouble[0]}`;

  console.log(`arrString size is ${typeof arrString[0]}`);
  logMsg = `arrString size is ${typeof arrString[0]}`;

  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

// [Start exception_handling_poor]
function div(a: number, b: number): number {
  if (a <= 0 || b <= 0) {
    throw new Error('Invalid numbers.');
  }
  return a / b;
}

function sum(num: number): number {
  let sum = 0;
  try {
    for (let t = 1; t < 100; t++) {
      sum += div(t, num);
    }
  } catch (e) {
    console.info(e.message);
  }
  return sum;
}
// [End exception_handling_poor]

function divBetter(a: number, b: number): number {
  if (a <= 0 || b <= 0) {
    return NaN;
  }
  return a / b;
}

// [Start exception_handling_batter]
function sumBetter(num: number): number {
  let sum = 0;
  for (let t = 1; t < 100; t++) {
    // 直接拦截异常场景，避免频繁抛出异常
    if (num <= 0) {
      console.info('Invalid numbers.');
    }
    sum += divBetter(t, num);
  }
  return sum;
}
// [End exception_handling_batter]

function testExceptionAvoidance() {
  let res = sum(-1);
  console.log(`res is ${res}`);
  let logMsg = 'res is ' + res;

  let result = sumBetter(-1);
  console.log(`result is ${result}`);
  logMsg = 'result is ' + result;

  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
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
          Text($r('app.string.high_perf_declaration_expression')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testVariable();
          this.currentState = $r('app.string.test_declaration_expression_complete');
        })

        Column() {
          Text($r('app.string.high_perf_constant_in_loop')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testGetNum();
          this.currentState = $r('app.string.test_constant_in_loop_complete');
        })

        Column() {
          Text($r('app.string.high_perf_outside_variable')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testArrayUse();
          this.currentState = $r('app.string.test_outside_variable_complete');
        })

        Column() {
          Text($r('app.string.high_perf_optional_parameter')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testParameter();
          this.currentState = $r('app.string.test_optional_parameter_complete');
        })

        Column() {
          Text($r('app.string.high_perf_type_array')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testTypeArray();
          this.currentState = $r('app.string.test_type_array_complete');
        })

        Column() {
          Text($r('app.string.high_perf_sparse_array')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testBigArray();
          this.currentState = $r('app.string.test_sparse_array_complete');
        })

        Column() {
          Text($r('app.string.high_perf_union_type_array')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testUnionTypeArray();
          this.currentState = $r('app.string.test_union_type_array_complete');
        })

        Column() {
          Text($r('app.string.high_perf_avoid_exception')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testExceptionAvoidance();
          this.currentState = $r('app.string.test_avoid_exception_complete');
        })
      }
      .height('100%')
      .width('100%')
      .backgroundColor('#F1F3F5')
      .padding(16);
    }
  }
}