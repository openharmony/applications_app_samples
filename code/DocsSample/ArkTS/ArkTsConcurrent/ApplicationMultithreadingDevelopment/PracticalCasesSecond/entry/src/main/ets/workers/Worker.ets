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
// [Start define_worker]
// Worker.ets
import { MessageEvents, ThreadWorkerGlobalScope, worker } from '@kit.ArkTS';
import { taskpool } from '@kit.ArkTS';

const workerPort: ThreadWorkerGlobalScope = worker.workerPort;
workerPort.onmessage = async (e: MessageEvents) => {
  if (e.data.type === 'start') {
    // 模拟Worker数据处理。
    const processedData = heavyComputation(e.data.data);

    // 调用TaskPool执行并发任务。
    const task = new taskpool.Task(parallelTask, processedData);
    const result = await taskpool.execute(task);
    console.info('Worker线程返回结果: ', result);

    // 将最终结果返回主线程。
    workerPort.postMessage({
      status: 'success',
      result: result
    });
  }
}

function heavyComputation(base: number): number {
  let sum = 0;
  for (let i = 0; i < base * 10; i++) {
    sum += Math.sqrt(i);
  }
  return sum;
}

@Concurrent
function parallelTask(base: number): number {
  let total = 0;
  for (let i = 0; i < base; i++) {
    total += i % 2 === 0 ? i : -i;
  }
  console.info('TaskPool线程计算结果: ', total);
  return total;
}
// [End define_worker]