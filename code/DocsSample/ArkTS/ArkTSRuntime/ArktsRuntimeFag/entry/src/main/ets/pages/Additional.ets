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

// Int32Array的map方法在内联缓存优化下的问题。
function testInt32ArrayMapIssue() {
  // [Start test_int32ArrayMapIssue]
  for(let i = 0; i < 1000; i++) {} // 触发内联缓存优化

  let arr = new Int32Array([1, 2, 3, 4, 5]);
  let result = arr.map(val => {
    let res = (Math.pow(val, 1)) * 100;
    return res;
  })

  console.info('result[0]:', result[0]);
  // 期望输出: result[0]:100
  // 实际输出: result[0]:104
  // [End test_int32ArrayMapIssue]

  let logMsg = 'result[0]: ' + result[0];
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

// Int32Array转换为普通数组后使用map方法的规避方案。
function testInt32ArrayMapWorkaround() {
  // [Start test_int32ArrayMapWorkaround]
  let arr = new Int32Array([1, 2, 3, 4, 5]);

  let normalArr = Array.from(arr);
  let result = normalArr.map(val => {
    let res = (Math.pow(val, 1)) * 100;
    return res;
  });

  console.info('result[0]:', result[0]);
  // 输出: result[0]:100
  // [End test_int32ArrayMapWorkaround]

  let logMsg = 'result[0]: ' + result[0];
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

// parseFloat处理极小数的问题。
function testParseFloatTinyNumber() {
  // [Start test_parseFloatTinyNumber]
  let result = parseFloat('5e-324');
  console.info('testcase: ', result);
  // 期望输出: testcase: 5e-324
  // 实际输出: testcase: 0
  // [End test_parseFloatTinyNumber]

  let logMsg = 'testcase: ' + result;
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

// Set配合Array.from使用时的问题。
function testSetArrayFrom() {
  // [Start test_setArrayFrom]
  const arr1: number[] = [1, 2];
  const arr2: number[] = [3, 4];
  const set = new Set<number[]>([arr1, arr2]);
  let result = JSON.stringify(Array.from(set));
  console.info('res: ', result);
  // 期望输出: res: [[1,2],[3,4]]
  // 实际输出: res: [2,4]
  // [End test_setArrayFrom]

  let logMsg = 'res: ' + result;
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

@Entry
@Component
struct AdditionalTests {
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
          Text($r('app.string.test_int32array_map_issue')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testInt32ArrayMapIssue();
          this.currentState = $r('app.string.test_int32array_map_issue_complete');
        })

        Column() {
          Text($r('app.string.test_int32array_map_workaround')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testInt32ArrayMapWorkaround();
          this.currentState = $r('app.string.test_int32array_map_workaround_complete');
        })

        Column() {
          Text($r('app.string.test_parsefloat_tiny_number')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testParseFloatTinyNumber();
          this.currentState = $r('app.string.test_parsefloat_tiny_number_complete');
        })

        Column() {
          Text($r('app.string.test_set_array_from')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testSetArrayFrom();
          this.currentState = $r('app.string.test_set_array_from_complete');
        })
      }
      .height('100%')
      .width('100%')
      .backgroundColor('#F1F3F5')
      .padding(16);
    }
  }
}
