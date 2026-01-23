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

// [Start multi_worker_high_performance_communication]
// Index.ets
import { worker, collections } from '@kit.ArkTS';
import { CopyEntry } from '../Sendable/CopyEntry'

function promiseCase() {
  let p: Promise<void> = new Promise<void>((resolve: Function, reject: Function) => {
    setTimeout(() => {
      resolve();
    }, 100);
  });
  return p;
}

async function postMessageTest() {
  let ss = new worker.ThreadWorker('entry/ets/workers/ParentWorker.ets');
  let isTerminate = false;
  ss.onexit = () => {
    isTerminate = true;
  }
  let array = new collections.Array<CopyEntry>();
  // 准备数据
  for (let i = 0; i < 4; i++) {
    if (i % 2 == 0) {
      array.push(new CopyEntry('copy1', 'file://copy1.txt'));
    } else {
      array.push(new CopyEntry('copy2', 'file://copy2.txt'));
    }
  }
  // 给Worker线程发送消息
  ss.postMessageWithSharedSendable(array);
  while (!isTerminate) {
    await promiseCase();
  }
  console.info('Worker线程已退出');
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
            // [StartExclude multi_worker_high_performance_communication]
            this.message = 'success';
            // [EndExclude multi_worker_high_performance_communication]
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End multi_worker_high_performance_communication]
