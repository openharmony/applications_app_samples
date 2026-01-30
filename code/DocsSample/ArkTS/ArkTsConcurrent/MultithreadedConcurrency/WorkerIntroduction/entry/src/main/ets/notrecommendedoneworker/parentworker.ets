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
import { ErrorEvent, MessageEvents, ThreadWorkerGlobalScope, worker } from '@kit.ArkTS';

// 父Worker线程中与主线程通信的对象
const workerPort: ThreadWorkerGlobalScope = worker.workerPort;

workerPort.onmessage = (e: MessageEvents) => {
  console.info('父Worker收到主线程的信息 ' + e.data);

  // 收到主线程指令后，创建子Worker
  let childworker = new worker.ThreadWorker('entry/ets/notrecommendedoneworker/childworker.ets');

  // 接收子Worker的执行结果
  childworker.onmessage = (e: MessageEvents) => {
    console.info('父Worker收到子Worker的信息 ' + e.data);
  }

  // 子Worker正常退出后的回调
  childworker.onexit = () => {
    console.info('子Worker退出');
    // 父Worker已经或即将退出时，再次通过父Worker端口发送消息
    workerPort.postMessage('父Worker向主线程发送信息');
  }

  // 子Worker运行过程中发生未被捕获的异常或运行错误时的回调
  childworker.onAllErrors = (err: ErrorEvent) => {
    console.error('子Worker发生报错 ' + err);
  }

  // 向子Worker发送启动消息，用于触发其onmessage中的处理逻辑
  childworker.postMessage('父Worker向子Worker发送信息');

  // 创建子Worker后，销毁父Worker
  workerPort.close();
}
// [End not_recommended_example]