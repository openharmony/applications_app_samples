/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
import { MessageEvents, ThreadWorkerGlobalScope, worker, Priority } from '@kit.ArkTS';

const workerPort: ThreadWorkerGlobalScope = worker.workerPort;

workerPort.onmessage = (e: MessageEvents) => {
  // 发送多个消息，让消息排队起来
  for (let i = 0; i < 10; i++) {
    // 使用普通消息发送，按默认顺序排队处理
    workerPort.postMessage('normal message.');
  }
  // HIGH优先级：和普通消息相同优先级，插入到队列头部，让消息提前执行
  workerPort.postMessageAtFront?.('atFront high message', Priority.HIGH);
}
// [End child_worker]