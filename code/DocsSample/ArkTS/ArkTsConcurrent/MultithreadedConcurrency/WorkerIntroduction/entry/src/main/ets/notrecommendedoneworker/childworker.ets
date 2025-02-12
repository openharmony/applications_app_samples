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

import resource from '../util/resource';
import { ErrorEvent, MessageEvents, ThreadWorkerGlobalScope, worker } from '@kit.ArkTS';

const workerPort: ThreadWorkerGlobalScope = worker.workerPort;

workerPort.onmessage = (e: MessageEvents) => {
  console.info(resource.resourceToString($r('app.string.Not_one_childworker_worker1')) + e.data);

  // 父Worker销毁后，子Worker向父Worker发送信息，行为不可预期
  workerPort.postMessage(resource.resourceToString($r('app.string.Not_one_childworker_worker2')));
  setTimeout(() => {
    workerPort.postMessage(resource.resourceToString($r('app.string.Not_one_childworker_worker2')));
  }, 1000);
}
