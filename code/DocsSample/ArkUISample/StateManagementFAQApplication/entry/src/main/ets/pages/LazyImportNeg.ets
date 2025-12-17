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

// [Start lazy_import_negative]
// src/main/ets/pages/LazyImportNeg.ets
import { ErrorEvent, worker, MessageEvents } from '@kit.ArkTS';

@Entry
@Component
struct Index {
  build() {
    Button('New Worker')
      .onClick(() => {
        // 创建Worker对象。
        const newWorker = new worker.ThreadWorker('../workers/LazyImportWorkerNeg.ets');

        // 注册onmessage回调，捕获宿主线程接收到来自其创建的Worker通过workerPort.postMessage接口发送的消息。该回调在宿主线程执行。
        newWorker.onmessage = (e: MessageEvents) => {
          let data: string = e.data;
          console.info('newWorker onmessage is: ', data);
        };

        // 注册onAllErrors回调，捕获Worker线程的onmessage回调、timer回调以及文件执行等流程产生的全局异常。该回调在宿主线程执行。
        newWorker.onAllErrors = (err: ErrorEvent) => {
          console.error('workerInstance onAllErrors message is: ' + err.message);
        };

        // 注册onmessageerror回调，当Worker对象接收到无法序列化的消息时被调用，在宿主线程执行。
        newWorker.onmessageerror = () => {
          console.error('workerInstance onmessageerror');
        };

        // 注册onexit回调，当Worker销毁时被调用，在宿主线程执行。
        newWorker.onexit = (e: number) => {
          // Worker正常退出时，code为0；异常退出时，code为1。
          console.info('workerInstance onexit code is: ', e);
        };

        // 发送消息给Worker线程。
        newWorker.postMessage('[Main] message from the main thread');
      })
  }
}
// [End lazy_import_negative]

@Builder
export function lazyImportNeg() {
  NavDestination() {
    Index()
  }
  .backgroundColor('#f1f2f3')
  .title($r('app.string.lazy_import_negative'))
}