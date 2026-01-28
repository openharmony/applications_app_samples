/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
import { GotoButton } from '../utils/MyButton';
// [Start worker_taskpool]
// workerAndTaskpool.ets
import { MessageEvents, worker } from '@kit.ArkTS';
import { PromptAction } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State message: string = '在主线程中创建Worker线程并发送消息';
  @State returnMessage: string = 'return...';
  @State promptAction: PromptAction = this.getUIContext().getPromptAction();

  build() {
    RelativeContainer() {
      Button(this.message)
        .fontSize(25)
        .id('HelloWorld')
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(() => {
          // 1. 创建Worker实例
          const myWorker = new worker.ThreadWorker('entry/ets/workers/Worker.ets');

          // 2. 注册onmessage回调函数，以处理Worker发送到主线程的消息
          myWorker.onmessage = (e: MessageEvents) => {
            console.info('主线程收到最终结果:', e.data.result);
            this.returnMessage = '主线程收到最终结果:' + e.data.result;
            this.promptAction.showToast({ message: this.returnMessage });
            myWorker.terminate(); // 选择合适的时机销毁Worker
          };

          // 3. 向Worker发送启动指令
          myWorker.postMessage({ type: 'start', data: 10 });
        })
      // [StartExclude worker_taskpool]
      GotoButton({ text: '跳转回Index页面', dstUri: 'pages/Index'});
      // [EndExclude worker_taskpool]
    }
    .height('100%')
    .width('100%')
  }
}
// [End worker_taskpool]