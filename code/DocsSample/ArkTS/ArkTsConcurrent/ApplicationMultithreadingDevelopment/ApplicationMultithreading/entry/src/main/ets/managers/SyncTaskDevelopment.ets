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

// [Start taskpool_handle_sync_task]
import { worker } from '@kit.ArkTS';
import { taskpool } from '@kit.ArkTS';

// 步骤1: 定义并发函数，实现业务逻辑
@Concurrent
async function taskpoolFunc(num: number): Promise<number> {
  // 根据业务逻辑实现相应的功能
  let tmpNum: number = num + 100;
  return tmpNum;
}

async function mainFunc(): Promise<void> {
  // 步骤2: 创建任务并执行
  let task1: taskpool.Task = new taskpool.Task(taskpoolFunc, 1);
  let res1: number = await taskpool.execute(task1) as number;
  let task2: taskpool.Task = new taskpool.Task(taskpoolFunc, res1);
  let res2: number = await taskpool.execute(task2) as number;
  // 步骤3: 对任务返回的结果进行操作
  console.info('taskpool: task res1 is: ' + res1);
  console.info('taskpool: task res2 is: ' + res2);
}

// [Start worker_handle_associated_sync_task]
@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(async () => {
            mainFunc();
            let w: worker.ThreadWorker = new worker.ThreadWorker('entry/ets/workers/MyWorker2.ts');
            w.onmessage = (): void => {
              // 接收Worker子线程的结果
            }
            w.onerror = (): void => {
              // 接收Worker子线程的错误信息
            }
            // 向Worker子线程发送Set消息
            w.postMessage({ 'type': 0, 'data': 'data' });
            // 向Worker子线程发送Get消息
            w.postMessage({ 'type': 1 });
            // ...
            // 根据实际业务，选择时机以销毁线程
            w.terminate();
            this.message = 'success';
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End worker_handle_associated_sync_task]
// [End taskpool_handle_sync_task]