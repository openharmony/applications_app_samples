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
// [Start load_share]
// Index.ets
import testNapi from 'libentry.so';
import { taskpool } from '@kit.ArkTS';

@Concurrent
function getAddress() {
  let address: number = testNapi.getAddress();
  console.info('taskpool:: address is ' + address);
}

@Concurrent
function store(a:number, b:number, c:number) {
  let size:number = testNapi.getSetSize();
  console.info('set size is ' + size + ' before store');
  testNapi.store(a);
  testNapi.store(b);
  testNapi.store(c);
  size = testNapi.getSetSize();
  console.info('set size is ' + size + ' after store');
}

@Concurrent
function erase(a:number) {
  let size:number = testNapi.getSetSize();
  console.info('set size is ' + size + ' before erase');
  testNapi.erase(a);
  size = testNapi.getSetSize();
  console.info('set size is ' + size + ' after erase');
}

@Concurrent
function clear() {
  let size:number = testNapi.getSetSize();
  console.info('set size is ' + size + ' before clear');
  testNapi.clear();
  size = testNapi.getSetSize();
  console.info('set size is ' + size + ' after clear');
}

// 共享模式
async function test(): Promise<void> {
  let address:number = testNapi.getAddress();
  console.info('host thread address is ' + address);

  let task1 = new taskpool.Task(getAddress, testNapi);
  await taskpool.execute(task1);

  let task2 = new taskpool.Task(store, 1, 2, 3);
  await taskpool.execute(task2);

  let task3 = new taskpool.Task(store, 4, 5, 6);
  await taskpool.execute(task3);

  // 由于默认的传输模式为共享模式，testNapi跨线程传递后，主线程可以继续访问Native对象的值
  let size:number = testNapi.getSetSize();
  // 输出的日志为“host thread size is 6”
  console.info('host thread size is ' + size);

  let task4 = new taskpool.Task(erase, 3);
  await taskpool.execute(task4);

  let task5 = new taskpool.Task(erase, 5);
  await taskpool.execute(task5);

  let task6 = new taskpool.Task(clear);
  await taskpool.execute(task6);
}

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize($r('app.float.page_text_font_size'))
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            test();
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End load_share]