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
import resource from '../util/resource';
import { worker, MessageEvents, ErrorEvent } from '@kit.ArkTS';

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
          // 主线程中创建父Worker对象
          const parentworker = new worker.ThreadWorker('entry/ets/notrecommendedtwoworker/parentworker.ets');

          // 接收父Worker返回的消息
          parentworker.onmessage = (e: MessageEvents) => {
            console.info(resource.resourceToString($r('app.string.Not_recommended1')) + e.data);
          }

          // 父Worker正常退出后的回调
          parentworker.onexit = () => {
            console.info(resource.resourceToString($r('app.string.Not_recommended2')));
          }

          // 父Worker运行过程中发生未被捕获的异常或运行错误时的回调
          parentworker.onAllErrors = (err: ErrorEvent) => {
            console.error(resource.resourceToString($r('app.string.Not_recommended3')) + err);
          }

          // 向父Worker发送启动消息，用于触发其onmessage中的处理逻辑
          parentworker.postMessage(resource.resourceToString($r('app.string.Not_recommended4')));
          this.message = 'success';
        })
    }
    .height('100%')
    .width('100%')
  }
}
// [End not_recommended_example]
