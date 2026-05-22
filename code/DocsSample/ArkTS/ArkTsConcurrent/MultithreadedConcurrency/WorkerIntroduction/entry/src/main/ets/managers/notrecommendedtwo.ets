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
import { worker, MessageEvents, ErrorEvent } from '@kit.ArkTS';

// 宿主线程中创建父Worker对象
const parentWorker = new worker.ThreadWorker('entry/ets/workers/ParentWorker.ets');

// 接收父Worker返回的消息
parentWorker.onmessage = (e: MessageEvents) => {
  console.info('宿主线程收到父Worker信息' + e.data);
}

// 父Worker正常退出后的回调
parentWorker.onexit = () => {
  console.info('父Worker退出');
}

// 父Worker运行过程中发生未被捕获的异常或运行错误时的回调
parentWorker.onAllErrors = (err: ErrorEvent) => {
  console.error('宿主线程接收到父Worker报错 ' + err.message);
}

// 向父Worker发送启动消息，用于触发其onmessage中的处理逻辑
parentWorker.postMessage('宿主线程发送消息给父Worker');
// [End not_recommended_example]
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
          this.message = 'success';
        })
    }
    .height('100%')
    .width('100%')
  }
}