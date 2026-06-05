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
// [Start parent_worker]
import { MessageEvents, worker } from '@kit.ArkTS';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State workerObject: worker.ThreadWorker | null = null;
  aboutToAppear(): void {
    this.workerObject = new worker.ThreadWorker("entry/ets/workers/Worker.ets");
    this.workerObject.onmessage = (e: MessageEvents): void => {
      // 模拟耗时操作，每个接收到的消息处理100ms，让消息排队起来
      let start = new Date().getTime();
      while (new Date().getTime() - start < 100) {
        continue;
      }
      let res: string = e.data as string;
      console.info('result is: ' + JSON.stringify(res));
    }
  }
  build() {
    Row() {
      Column({space: 20}) {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Button('触发消息发送')
          .fontSize(50)
          .onClick(()=>{
            if (this.workerObject != null) {
              this.workerObject.postMessage('normal');
            }
          })
        Button('释放worker')
          .fontSize(50)
          .onClick(()=>{
            if (this.workerObject != null) {
              this.workerObject.terminate();
              this.workerObject = null;
            }
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End parent_worker]