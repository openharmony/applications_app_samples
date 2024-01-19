/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import worker, { MessageEvents, ThreadWorkerGlobalScope } from '@ohos.worker';

const workerPort: ThreadWorkerGlobalScope = worker.workerPort;
workerPort.onmessage = (e: MessageEvents): void => {
  if (typeof e.data === "string") {
    try {
      // 调用方法无入参
      let res: string = workerPort.callGlobalCallObjectMethod("picData", "setUp", 0) as string;
      console.error("worker: ", res);
    } catch (error) {
      // 异常处理
      console.error("worker: error code is " + error.code + " error message is " + error.message);
    }
  } else if (e.data instanceof Array) {
    workerPort.postMessage(e.data.slice(0, 4));
  }

}