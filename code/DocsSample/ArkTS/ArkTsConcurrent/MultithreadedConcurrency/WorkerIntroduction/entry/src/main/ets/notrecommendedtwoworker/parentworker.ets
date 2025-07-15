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

// [Start not_recommended_example]
import resource from '../util/resource';
import { ErrorEvent, MessageEvents, ThreadWorkerGlobalScope, worker } from '@kit.ArkTS';

const workerPort: ThreadWorkerGlobalScope = worker.workerPort;

workerPort.onmessage = (e: MessageEvents) => {
  console.info(resource.resourceToString($r('app.string.Not_two_parentworker_worker1')) + e.data);

  // 父Worker销毁后创建子Worker，行为不可预期
  workerPort.close();
  let childworker = new worker.ThreadWorker('entry/ets/notrecommendedtwoworker/childworker.ets');

  // 子Worker线程未确认创建成功前销毁父Worker，行为不可预期
  // let childworker = new worker.ThreadWorker('entry/ets/workers/childworker.ets');
  // workerPort.close();

  childworker.onmessage = (e: MessageEvents) => {
    console.info(resource.resourceToString($r('app.string.Not_two_parentworker_worker2')) + e.data);
  }

  childworker.onexit = () => {
    console.info(resource.resourceToString($r('app.string.Not_two_parentworker_worker3')));
    workerPort.postMessage(resource.resourceToString($r('app.string.Not_two_parentworker_worker4')));
  }

  childworker.onAllErrors = (err: ErrorEvent) => {
    console.error(resource.resourceToString($r('app.string.Not_two_parentworker_worker5')) + err);
  }

  childworker.postMessage(resource.resourceToString($r('app.string.Not_two_parentworker_worker6')));
}
// [End not_recommended_example]