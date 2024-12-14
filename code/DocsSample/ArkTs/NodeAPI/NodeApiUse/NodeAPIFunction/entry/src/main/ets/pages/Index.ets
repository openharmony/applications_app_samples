/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { hilog } from '@kit.PerformanceAnalysisKit';
import testNapi from 'libentry.so';

function summation(arr: Array<number>) {
  let sum: number = 0;
  for (let i = 0; i < arr.length; i++) {
    sum += arr[i];
  }
  return sum;
}

const str = 'message';
const arr = [0, 1, 2, 3, 4, 5];
const num = 526;

class Student {
  name: string;
  age: number;
  score: number;

  constructor(name: string, age: number, score: number) {
    this.name = name;
    this.age = age;
    this.score = score;
  }
}

function returnNumber() {
  return 10;
}

class Person {
  age(): number {
    return 11;
  }
}

@Entry
@Component
struct Index {
  @State result: string = ''
  private items: string[] = [
    'Reset Result Message',
    '1.napiGetCbInfo',
    '2.napiCallFunction',
    '3.napiCreateFunction'
  ]

  build() {
    Column() {
      Text('Result: ' + this.result)
        .fontSize(25)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 3 })
      List({ space: '10vp' }) {
        ForEach(this.items, (item: string) => {
          ListItem() {
            Text(item)
              .fontSize(16)
              .width('100%')
              .height(60)
              .textAlign(TextAlign.Center)
              .fontWeight(FontWeight.Bold)
              .borderRadius(30)
              .backgroundColor(Color.White)
              .onClick(() => {
                if (item === 'Reset Result Message') {
                  this.result = '';
                } else if (item === '1.napiGetCbInfo') {
                  // napi_get_cb_info
                  let student = new Student('Alice', 18, 100);
                  // 获取参数
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_get_cb_info get string arg:%{public}s',
                    testNapi.getCbArgs(str));
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_get_cb_info get array arg:%{public}s ',
                    testNapi.getCbArgs(arr).toString());
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_get_cb_info get num arg:%{public}d ',
                    testNapi.getCbArgs(num));
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_get_cb_info get undefined arg:%{public}s ',
                    testNapi.getCbArgs(undefined));
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_get_cb_info get object arg:%{public}s ',
                    JSON.stringify(testNapi.getCbArgs(student)));
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_get_cb_info get function arg:%{public}d ',
                    testNapi.getCbArgs(summation(arr)));
                  // 获取参数个数
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_get_cb_info get arg quantity:%{public}d ',
                    testNapi.getCbArgQuantity(str, num));
                  // 获取上下文
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_get_cb_info get thisArg:%{public}s ',
                    testNapi.getCbContext().toString());
                  this.result = 'napiGetCbInfoSuccess';
                } else if (item === '2.napiCallFunction') {
                  // napi_call_function
                  const person = new Person();
                  hilog.info(0x0000, 'testTag', 'Test Node-API call_function:%{public}d',
                    testNapi.callFunction(returnNumber));
                  hilog.info(0x0000, 'testTag', 'Test Node-API call_function:%{public}d',
                    testNapi.objCallFunction(person, person.age));
                  this.result = 'napiCallFunctionSuccess';
                } else if (item === '3.napiCreateFunction') {
                  // napi_create_function
                  hilog.info(0x0000, 'testTag', 'Test Node-API create_function:%{public}d ',
                    testNapi.calculateArea(1.2, 4));
                  this.result = 'napiCreateFunctionSuccess';
                }
              })
          }
        })
      }.scrollBar(BarState.Off)
      .width('90%')
    }.width('100%')
    .height('100%')
    .backgroundColor(0xDCDCDC)
    .padding({ top: 5 })
  }
}
