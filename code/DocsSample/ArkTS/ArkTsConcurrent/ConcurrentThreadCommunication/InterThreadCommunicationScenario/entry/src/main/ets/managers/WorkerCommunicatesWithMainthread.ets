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

import { worker } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';

function promiseCase() {
  let p: Promise<void> = new Promise<void>((resolve: Function, reject: Function) => {
    setTimeout(() => {
      resolve(1);
    }, 100)
  }).then(undefined, (error: BusinessError) => {
  })
  return p;
}

async function postMessageTest() {
  let ss = new worker.ThreadWorker('entry/ets/workers/Worker.ets');
  let res = undefined;
  let flag = false;
  let isTerminate = false;
  ss.onexit = () => {
    isTerminate = true;
  }
  // 接收Worker线程发送的消息
  ss.onmessage = (e) => {
    res = e.data;
    flag = true;
    console.info('worker:: res is  ' + res);
  }
  // 给Worker线程发送消息
  ss.postMessage('hello world');
  while (!flag) {
    await promiseCase();
  }

  ss.terminate();
  while (!isTerminate) {
    await promiseCase();
  }
}

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            postMessageTest();
            this.message = 'success';
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
