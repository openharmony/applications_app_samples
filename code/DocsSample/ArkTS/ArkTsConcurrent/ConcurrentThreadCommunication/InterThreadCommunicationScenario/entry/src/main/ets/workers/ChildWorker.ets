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
 
// [Start child_worker]
import { ErrorEvent, MessageEvents, ThreadWorkerGlobalScope, worker} from '@kit.ArkTS'
import { CopyEntry } from '../managers/CopyEntry'

const workerPort: ThreadWorkerGlobalScope = worker.workerPort;

workerPort.onmessage = (e : MessageEvents) => {
  let data = e.data as CopyEntry;
  // 中间copy操作省略
  console.info(data.filePath);
  workerPort.postMessageWithSharedSendable('done');
}

workerPort.onmessageerror = (e : MessageEvents) => {
  console.error('onmessageerror:' + e.data);
}

workerPort.onerror = (e : ErrorEvent) => {
  console.error('onerror:' + e.message);
}
// [End child_worker]