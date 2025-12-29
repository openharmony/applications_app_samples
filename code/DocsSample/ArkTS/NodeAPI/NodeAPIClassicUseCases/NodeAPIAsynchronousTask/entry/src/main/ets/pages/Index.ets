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
import { ErrorEvent, worker, taskpool } from '@kit.ArkTS';
import testNapi from 'libentry.so';
import nativeModule from 'libentry1.so';

@Concurrent
function nativeCall(num1 : number, num2 : number): void {
  console.info('Taskpool thread received data:', + num1 + '、' + num2);
  nativeModule.asyncWork(num1, num2, (result) => {
    hilog.info(0x0000, 'XXX', 'result is: %{public}d', result);
  });
}

async function testTaskpool() : Promise<void> {
  try {
    const task = new taskpool.Task(nativeCall, num1, num2);
    await taskpool.execute(task);
  } catch (e) {
    console.error('Taskpool execute error: ${e}');
  }
}

let num1: number = 123;
let num2: number = 456;

@Entry
@Component
struct Index {
  @State message: string = 'AsyncWork';

  build() {
      Column({space: 5}) {
        Text(this.message)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
        Button($r('app.string.AsyncWorkPromise'))
          .margin(3)
          .onClick(() => {
            // [Start promise_call_interface]
            testNapi.asyncWork(1024).then((result) => {
              hilog.info(0x0000, 'XXX', 'result is %{public}d', result);
            });
            // [End promise_call_interface]
            this.message = 'AsyncWorkPromise success';
          })
        Button($r('app.string.AsyncWorkCallback'))
          .margin(3)
          .onClick(() => {
            // [Start callback_call_interface]
            nativeModule.asyncWork(num1, num2, (result) => {
              hilog.info(0x0000, 'XXX', 'result is %{public}d', result);
            });
            // [End callback_call_interface]
            this.message = 'AsyncWorkCallback success';
          })
        Button($r('app.string.AsyncWorkCallbackWorker'))
          .margin(3)
          .onClick(() => {
            // [Start AsyncWorkCallbackWorker]
            const wk = new worker.ThreadWorker('entry/ets/worker/worker.ets');
            wk.postMessage({num1, num2});
            wk.onmessage = (msg) => {
              console.info('result is:', msg.data);
              wk.terminate();
            }
            // [End AsyncWorkCallbackWorker]
            this.message = 'WorkerTest success';
          })
        Button($r('app.string.AsyncWorkCallbackTaskPool'))
          .margin(3)
          .onClick(() => {
            // [Start AsyncWorkCallbackTaskPool]
            testTaskpool();
            // [End AsyncWorkCallbackTaskPool]
            this.message = 'TaskpoolTest success';
          })
      }
      .width('100%')
    .height('100%')
  }
}