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
 
// [Start parent_worker]
import { ErrorEvent, MessageEvents, ThreadWorkerGlobalScope, worker, collections, ArkTSUtils } from '@kit.ArkTS'
import { CopyEntry } from '../managers/CopyEntry'

const workerPort: ThreadWorkerGlobalScope = worker.workerPort;

// 计算worker1的任务数量
let count1 = 0;
// 计算worker2的任务数量
let count2 = 0;
// 计算总任务数量
let sum = 0;
// 异步锁
const asyncLock = new ArkTSUtils.locks.AsyncLock();
// 创建子Worker
const copyWorker1 = new worker.ThreadWorker('entry/ets/pages/ChildWorker');
const copyWorker2 = new worker.ThreadWorker('entry/ets/pages/ChildWorker');

workerPort.onmessage = (e : MessageEvents) => {
  let array = e.data as collections.Array<CopyEntry>;
  sum = array.length;
  for (let i = 0; i < array.length; i++) {
    let entry = array[i];
    if (entry.type === 'copy1') {
      count1++;
      // 如果是copy1类型，则将数据传递给 copyWorker1
      copyWorker1.postMessageWithSharedSendable(entry);
    } else if (entry.type === 'copy2') {
      count2++;
      // 如果是copy2类型，则将数据传递给 copyWorker2
      copyWorker2.postMessageWithSharedSendable(entry);
    }
  }
}

copyWorker1.onmessage = async (e : MessageEvents) => {
  console.info('copyWorker1 onmessage:' + e.data);
  await asyncLock.lockAsync(() => {
    count1--;
    if (count1 == 0) {
      // 如果copyWorker1的任务全部完成，则关闭copyWorker1
      console.info('copyWorker1 close');
      copyWorker1.terminate();
    }
    sum--;
    if (sum == 0) {
      // 如果所有任务全部完成，则关闭父Worker
      workerPort.close();
    }
  })
}

copyWorker2.onmessage = async (e : MessageEvents) => {
  console.info('copyWorker2 onmessage:' + e.data);
  await asyncLock.lockAsync(() => {
    count2--;
    sum--;
    if (count2 == 0) {
      // 如果copyWorker2的任务全部完成，则关闭copyWorker2
      console.info('copyWorker2 close')
      copyWorker2.terminate();
    }
    if (sum == 0) {
      // 如果所有任务全部完成，则关闭父Worker
      workerPort.close();
    }
  })
}

workerPort.onmessageerror = (e : MessageEvents) => {
  console.error('onmessageerror:' + e.data);
}

workerPort.onerror = (e : ErrorEvent) => {
  console.error('onerror:' + e.message);
}
// [End parent_worker]