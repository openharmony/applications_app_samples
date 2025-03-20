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

// 并发函数返回Promise
// 并发函数中返回Promise的表现需关注，其中并发同步函数会处理返回该Promise并返回结果，如下例所示。
// [Start concurrent_taskpool_promise_return]
import { taskpool } from '@kit.ArkTS';

@Concurrent
function testPromise(args1: number, args2: number): Promise<number> {
  return new Promise<number>((testFuncA, testFuncB) => {
    testFuncA(args1 + args2);
  });
}

@Concurrent
async function testPromise1(args1: number, args2: number): Promise<number> {
  return new Promise<number>((testFuncA, testFuncB) => {
    testFuncA(args1 + args2);
  });
}

@Concurrent
async function testPromise2(args1: number, args2: number): Promise<number> {
  return await new Promise<number>((testFuncA, testFuncB) => {
    testFuncA(args1 + args2);
  });
}

@Concurrent
function testPromise3() {
  return Promise.resolve(1);
}

@Concurrent
async function testPromise4(): Promise<number> {
  return 1;
}

@Concurrent
async function testPromise5(): Promise<string> {
  return await new Promise((resolve) => {
    setTimeout(() => {
      resolve('Promise setTimeout after resolve');
    }, 1000)
  });
}

async function testConcurrentFunc() {
  let task1: taskpool.Task = new taskpool.Task(testPromise, 1, 2);
  let task2: taskpool.Task = new taskpool.Task(testPromise1, 1, 2);
  let task3: taskpool.Task = new taskpool.Task(testPromise2, 1, 2);
  let task4: taskpool.Task = new taskpool.Task(testPromise3);
  let task5: taskpool.Task = new taskpool.Task(testPromise4);
  let task6: taskpool.Task = new taskpool.Task(testPromise5);

  taskpool.execute(task1).then((d: object) => {
    console.info('task1 res is: ' + d);
  }).catch((e: object) => {
    console.info('task1 catch e: ' + e);
  })
  taskpool.execute(task2).then((d: object) => {
    console.info('task2 res is: ' + d);
  }).catch((e: object) => {
    console.info('task2 catch e: ' + e);
  })
  taskpool.execute(task3).then((d: object) => {
    console.info('task3 res is: ' + d);
  }).catch((e: object) => {
    console.info('task3 catch e: ' + e);
  })
  taskpool.execute(task4).then((d: object) => {
    console.info('task4 res is: ' + d);
  }).catch((e: object) => {
    console.info('task4 catch e: ' + e);
  })
  taskpool.execute(task5).then((d: object) => {
    console.info('task5 res is: ' + d);
  }).catch((e: object) => {
    console.info('task5 catch e: ' + e);
  })
  taskpool.execute(task6).then((d: object) => {
    console.info('task6 res is: ' + d);
  }).catch((e: object) => {
    console.info('task6 catch e: ' + e);
  })
}

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Row() {
      Column() {
        Button(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            testConcurrentFunc();
            // [StartExclude update_message_on_success]
            this.message = 'success';
            // [EndExclude update_message_on_success]
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End concurrent_taskpool_promise_return]
