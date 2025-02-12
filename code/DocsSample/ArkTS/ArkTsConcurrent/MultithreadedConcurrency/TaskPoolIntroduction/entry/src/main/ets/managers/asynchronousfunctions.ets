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

// 并发异步函数中使用Promise
// 并发异步函数中如果使用Promise，建议搭配await使用捕获Promise中可能发生的异常。推荐使用示例如下。
import { taskpool } from '@kit.ArkTS';

@Concurrent
async function testPromiseError() {
  await new Promise<number>((resolve, reject) => {
    resolve(1);
  }).then(()=>{
    throw new Error('testPromise Error');
  })
}

@Concurrent
async function testPromiseError1() {
  await new Promise<string>((resolve, reject) => {
    reject('testPromiseError1 Error msg');
  })
}

@Concurrent
function testPromiseError2() {
  return new Promise<string>((resolve, reject) => {
    reject('testPromiseError2 Error msg');
  })
}

async function testConcurrentFunc() {
  let task1: taskpool.Task = new taskpool.Task(testPromiseError);
  let task2: taskpool.Task = new taskpool.Task(testPromiseError1);
  let task3: taskpool.Task = new taskpool.Task(testPromiseError2);

  taskpool.execute(task1).then((d:object)=>{
    console.info('task1 res is: ' + d);
  }).catch((e:object)=>{
    console.info('task1 catch e: ' + e);
  })
  taskpool.execute(task2).then((d:object)=>{
    console.info('task2 res is: ' + d);
  }).catch((e:object)=>{
    console.info('task2 catch e: ' + e);
  })
  taskpool.execute(task3).then((d:object)=>{
    console.info('task3 res is: ' + d);
  }).catch((e:object)=>{
    console.info('task3 catch e: ' + e);
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
            this.message = 'success';
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
