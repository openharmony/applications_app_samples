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

// 父Worker线程中与主线程通信的对象
const workerPort: ThreadWorkerGlobalScope = worker.workerPort;

workerPort.onmessage = (e: MessageEvents) => {
  console.info(resource.resourceToString($r('app.string.Not_two_parentworker_worker1')) + e.data);

  // 父Worker销毁后创建子Worker
  workerPort.close();
  let childworker = new worker.ThreadWorker('entry/ets/notrecommendedtwoworker/childworker.ets');

  // 子Worker线程未确认创建成功前销毁父Worker
  // let childworker = new worker.ThreadWorker('entry/ets/workers/childworker.ets');
  // workerPort.close();

  // 接收子Worker返回的消息
  childworker.onmessage = (e: MessageEvents) => {
    console.info(resource.resourceToString($r('app.string.Not_two_parentworker_worker2')) + e.data);
  }

  // 子Worker正常退出后的回调
  childworker.onexit = () => {
    console.info(resource.resourceToString($r('app.string.Not_two_parentworker_worker3')));
    // 父Worker已经或即将退出时，再次通过父Worker端口发送消息
    workerPort.postMessage(resource.resourceToString($r('app.string.Not_two_parentworker_worker4')));
  }

  // 子Worker运行过程中发生未被捕获的异常或运行错误时的回调
  childworker.onAllErrors = (err: ErrorEvent) => {
    console.error(resource.resourceToString($r('app.string.Not_two_parentworker_worker5')) + err);
  }

  // 向子Worker发送启动消息
  childworker.postMessage(resource.resourceToString($r('app.string.Not_two_parentworker_worker6')));
}
// [End not_recommended_example]