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
import { ErrorEvent, MessageEvents, worker } from '@kit.ArkTS'
import { SendableObject } from '../util/SendableObject';
import { common, sendableContextManager } from '@kit.AbilityKit';


@Entry
@Component
struct Index {
  private workerInstance?: worker.ThreadWorker;
  private context: Context | undefined;
  @State currentProgress: number = 0;

  build() {
    RelativeContainer() {
      Column() {
        Button($r('app.string.StartTranscoder'))
          .onClick(async () => {
            console.info(`Button put`);
            await this.startWorker();
          })
          .id('AsyncAVTranscoderButton')
        Progress({ value: 0, total: 100, type: ProgressType.Linear }).value(this.currentProgress)
          .height(50)
          .width('80%')
      }
      .alignRules({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        middle: { anchor: '__container__', align: HorizontalAlign.Center }
      })
    }
    .height('100%')
    .width('100%')
  }


  async startWorker() {
    // 创建Worker对象
    this.workerInstance = new worker.ThreadWorker('entry/ets/workers/task.ets');


    // 注册onmessage回调，当宿主线程接收到来自其创建的Worker通过workerPort.postMessage接口发送的消息时被调用，
    // 在宿主线程执行
    this.workerInstance.onmessage = (e: MessageEvents) => {
      let data: string | number = e.data;
      if (typeof data === 'string') {
        console.info('workerInstance onmessage is: ', data);
        if (data === 'complete') {
          console.info('complete: ', data);
          this.workerInstance?.terminate();
        }
      } else if (typeof data === 'number') {
        this.currentProgress = data;
      }
    }


    // 注册onErrors回调，可以捕获Worker线程的onmessage回调、timer回调以及文件执行等流程产生的全局异常，
    // 在宿主线程执行
    this.workerInstance.onerror = (err: ErrorEvent) => {
      console.error('workerInstance onerror message is: ' + err.message);
    }


    // 注册onmessageerror回调，当Worker对象接收到一条无法被序列化的消息时被调用，在宿主线程执行
    this.workerInstance.onmessageerror = () => {
      console.error('workerInstance onmessageerror');
    }


    // 注册onexit回调，当Worker销毁时被调用，在宿主线程执行
    this.workerInstance.onexit = (e: number) => {
      // 当Worker正常退出时code为0，异常退出时code为1
      console.info('workerInstance onexit code is: ', e);
    }


    // 向Worker线程发送消息
    this.context = this.getUIContext().getHostContext();
    if (this.context != undefined) {
      const sendableContext: sendableContextManager.SendableContext =sendableContextManager.convertFromContext(
        this.context);
      const sendableObject: SendableObject = new SendableObject(sendableContext, 'some information');
      this.workerInstance.postMessageWithSharedSendable(sendableObject);
    }
  }
}
