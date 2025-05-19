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
// [Start create_worker_execute_multi_task]
// [Start call_main_method]
import { ErrorEvent, MessageEvents, ThreadWorkerGlobalScope, worker } from '@kit.ArkTS';

const workerPort: ThreadWorkerGlobalScope = worker.workerPort;

// [StartExclude create_worker_execute_multi_task]
try {
  // 调用方法无入参
  let res: string = workerPort.callGlobalCallObjectMethod('picData', 'setUp', 0) as string;
  console.error('worker: ', res);
} catch (error) {
  // 异常处理
  console.error('worker: error code is ' + error.code + ' error message is ' + error.message);
}
// [End call_main_method]
// [EndExclude create_worker_execute_multi_task]

// Worker接收宿主线程的消息，做相应的处理
workerPort.onmessage = (e: MessageEvents): void => {
  if (e.data === 'hello world') {
    workerPort.postMessage('success');
  }
}
// [End create_worker_execute_multi_task]