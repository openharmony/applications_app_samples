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

workerPort.onmessage = async (e: MessageEvents) => {
  // [StartExclude create_worker_execute_multi_task]
  if (e.data === 'start') {
    try {
      // 调用方法
      let res: string = workerPort.callGlobalCallObjectMethod('testObj', 'getMessage', 0) as string;
      if (res === 'this is a message from TestObj') {
        workerPort.postMessage('run function success.');
      }
    } catch (error) {
      // 异常处理
      console.error('worker: error code is ' + error.code + ' error message is ' + error.message);
    }
  }

  // [StartExclude call_main_method]
  // [EndExclude create_worker_execute_multi_task]
  if (e.data === 'hello world') {
    workerPort.postMessage('success');
  }
  // [EndExclude call_main_method]
}
// [End create_worker_execute_multi_task]
// [End call_main_method]