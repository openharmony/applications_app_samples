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

// [Start worker_handle_associated_sync_task]
import { worker, ThreadWorkerGlobalScope, MessageEvents } from '@kit.ArkTS';
import Handle from './handle'; // 返回句柄

let workerPort: ThreadWorkerGlobalScope = worker.workerPort;

// 无法传输的句柄，所有操作依赖此句柄
let handler: Handle = new Handle()

// Worker线程的onmessage逻辑
workerPort.onmessage = (e: MessageEvents): void => {
  switch (e.data.type as number) {
    case 0:
      handler.syncSet(e.data.data);
      workerPort.postMessage('success set');
      break;
    case 1:
      handler.syncGet();
      workerPort.postMessage('success get');
      break;
  }
}
// [End worker_handle_associated_sync_task]