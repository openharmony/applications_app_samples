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

// [Start receive_json_data]
import { MessageEvents, worker } from '@kit.ArkTS';
import { Layout } from '../layout/Layout';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize($r('app.float.page_text_font_size'))
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(() => {
          // 1. 创建Worker实例
          const myWorker = new worker.ThreadWorker('entry/ets/workers/Worker.ets');
          // 2. 接收Worker返回的结果
          myWorker.onmessage = (e: MessageEvents) => {
            if (e.data?.status === 'success') {
              const layout: Layout = e.data.result;
              if (layout.type === 'Text') {
                this.message = layout.type; // 更新UI
              }
            }
            myWorker.terminate();
          };
          // 3. 向Worker发送启动指令
          myWorker.postMessage({});
        })
    }
    .height('100%')
    .width('100%')
  }
}
// [End receive_json_data]