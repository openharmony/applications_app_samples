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

// {Start create_worker_object_register_callback_function]
import { ErrorEvent, MessageEvents, worker } from '@kit.ArkTS';

@Entry
@Component
struct Index {
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
          // 创建Worker对象
          let workerInstance = new worker.ThreadWorker('entry/ets/workers/worker.ets');

          // 注册onmessage回调，当宿主线程接收到来自其创建的Worker通过workerPort.postMessage接口发送的消息时被调用，在宿主线程执行
          workerInstance.onmessage = (e: MessageEvents) => {
            let data: string = e.data;
            console.info('workerInstance onmessage is: ', data);
          }

          // 注册onerror回调，当Worker在执行过程中发生异常时被调用，在宿主线程执行
          workerInstance.onerror = (err: ErrorEvent) => {
            console.error('workerInstance onerror message is: ' + err.message);
          }

          // 注册onmessageerror回调，当Worker对象接收到一条无法被序列化的消息时被调用，在宿主线程执行
          workerInstance.onmessageerror = () => {
            console.error('workerInstance onmessageerror');
          }

          // 注册onexit回调，当Worker销毁时被调用，在宿主线程执行
          workerInstance.onexit = (e: number) => {
            // 当Worker正常退出时code为0，异常退出时code为1
            console.info('workerInstance onexit code is: ', e);
          }

          // 向Worker线程发送消息
          workerInstance.postMessage('1');
          this.message = 'success';
        })
    }
    .height('100%')
    .width('100%')
  }
}
// {End create_worker_object_register_callback_function]
