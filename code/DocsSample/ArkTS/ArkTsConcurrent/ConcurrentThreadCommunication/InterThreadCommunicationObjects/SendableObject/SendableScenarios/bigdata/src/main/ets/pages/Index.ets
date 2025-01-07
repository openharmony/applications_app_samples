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

import { taskpool } from '@kit.ArkTS';
import { TestTypeA, TestTypeB, Test } from './sendable';
import { BusinessError, emitter } from '@kit.BasicServicesKit';

// 在并发函数中模拟数据处理
@Concurrent
async function taskFunc(obj: Test) {
  console.info('test task res1 is: ' + obj.data1.name + ' res2 is: ' + obj.data2.name);
}

async function test() {
  // 使用taskpool传递数据
  let a: TestTypeA = new TestTypeA('testTypeA');
  let b: TestTypeB = new TestTypeB('testTypeB');
  let obj: Test = new Test(a, b);
  let task: taskpool.Task = new taskpool.Task(taskFunc, obj);
  await taskpool.execute(task);
}

@Concurrent
function sensorListener() {
  // 监听逻辑
  // ...
  console.info('Monitoring logic');
}

@Entry
@Component
struct Index {
  @State listenerTask: string = 'Listener task';
  @State dataProcessingTask: string = 'Data processing task';

  build() {
    Column() {
      Text(this.listenerTask)
        .id('Listener task')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          let sensorTask = new taskpool.LongTask(sensorListener);
          emitter.on({ eventId: 0 }, (data) => {
            // Do something here
            console.info(`Receive ACCELEROMETER data: {${data.data?.x}, ${data.data?.y}, ${data.data?.z}`);
          });
          taskpool.execute(sensorTask).then(() => {
            console.info('Add listener of ACCELEROMETER success');
          }).catch((e: BusinessError) => {
            // Process error
          })
          this.listenerTask = 'success';
        })
      Text(this.dataProcessingTask)
        .id('Data processing task')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          test();
          this.dataProcessingTask = 'success';
        })
    }
    .height('100%')
    .width('100%')
  }
}