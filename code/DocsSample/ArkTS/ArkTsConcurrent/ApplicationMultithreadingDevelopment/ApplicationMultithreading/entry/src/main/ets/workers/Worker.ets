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

// [Start worker_correspond_main_thread]
import { ErrorEvent, MessageEvents, ThreadWorkerGlobalScope, worker } from '@kit.ArkTS';
const workerPort: ThreadWorkerGlobalScope = worker.workerPort;
let isRunning = false;
workerPort.onmessage = (e: MessageEvents) => {
  const type = e.data.type as string;
  if (type === 'End') {
    if (!isRunning) {
      isRunning = true;
      // 开始常驻任务
      performTask();
    }
  } else if (type === 'stop') {
    isRunning = false;
    workerPort.close();  // 关闭Worker
  }
}
// 模拟常驻任务
function performTask() {
  if (isRunning) {
    // 模拟某个长期运行的任务
    workerPort.postMessage('Worker is performing a task');
    // 1秒后再次执行任务
    setTimeout(performTask, 1000);
  }
  workerPort.postMessage('Worker is stop performing a task');
}
// [End worker_correspond_main_thread]