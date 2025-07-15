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

// [End stage_rules]
// 导入模块
import { ErrorEvent, MessageEvents, worker } from '@kit.ArkTS';

/*
 * // API 9及之后版本使用：
 * const worker1: worker.ThreadWorker = new worker.ThreadWorker('entry/ets/workers/worker.ets');
 * // API 8及之前版本使用：
 * const worker2: worker.Worker = new worker.Worker('entry/ets/workers/worker.ets');
 */

// worker线程文件所在路径："entry/src/main/ets/workers/worker.ets"
const workerStage1: worker.ThreadWorker = new worker.ThreadWorker('entry/ets/workers/worker.ets');

if(!workerStage1){
  // worker线程文件所在路径："testworkers/src/main/ets/ThreadFile/workers/worker.ets"
  const workerStage2: worker.ThreadWorker = new worker.ThreadWorker('testworkers/ets/ThreadFile/workers/worker.ets');

  // worker线程文件所在路径： "hsp/src/main/ets/workers/worker.ets"
  const workerStage3: worker.ThreadWorker = new worker.ThreadWorker('hsp/ets/workers/worker.ets');

  // @标识路径加载形式：
  // worker线程文件所在路径: "har/src/main/ets/workers/worker.ets"
  const workerStage4: worker.ThreadWorker = new worker.ThreadWorker('@har/ets/workers/worker.ets');

  // 相对路径加载形式：
  // worker线程文件所在路径: "har/src/main/ets/workers/worker.ets"
  // 创建Worker对象的文件所在路径："har/src/main/ets/components/mainpage/MainPage.ets"
  const workerStage5: worker.ThreadWorker = new worker.ThreadWorker('../../workers/worker.ets');
}

@Entry
@Component
struct stageRules {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(() => {
          // 注册onmessage回调，当宿主线程接收到来自其创建的Worker通过workerPort.postMessage接口发送的消息时被调用，在宿主线程执行
          workerStage1.onmessage = (e: MessageEvents) => {
            let data: string = e.data;
            console.info('workerStage1 onmessage is: ', data);
          }

          // 注册onerror回调，当Worker在执行过程中发生异常时被调用，在宿主线程执行
          workerStage1.onerror = (err: ErrorEvent) => {
            console.info('workerStage1 onerror message is: ' + err.message);
          }

          // 注册onmessageerror回调，当Worker对象接收到一条无法被序列化的消息时被调用，在宿主线程执行
          workerStage1.onmessageerror = () => {
            console.info('workerStage1 onmessageerror');
          }

          // 注册onexit回调，当Worker销毁时被调用，在宿主线程执行
          workerStage1.onexit = (e: number) => {
            // 当Worker正常退出时code为0，异常退出时code为1
            console.info('workerStage1 onexit code is: ', e);
          }

          // 向Worker线程发送消息
          workerStage1.postMessage('1');
          this.message = 'success';
        })
    }
    .height('100%')
    .width('100%')
  }
}
// [End stage_rules]