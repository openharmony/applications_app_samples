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

// [Start recommended_example]
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
          // 主线程中创建父worker对象
          const parentworker = new worker.ThreadWorker('entry/ets/recommendworkers/parentworker.ets');

          parentworker.onmessage = (e: MessageEvents) => {
            console.info(resource.resourceToString($r('app.string.recommend1')) + e.data);
          }

          parentworker.onexit = () => {
            console.info(resource.resourceToString($r('app.string.recommend2')));
          }

          parentworker.onerror = (err: ErrorEvent) => {
            console.error(resource.resourceToString($r('app.string.recommend3')) + err);
          }

          parentworker.postMessage(resource.resourceToString($r('app.string.recommend4')));
          this.message = 'success';
        })
    }
    .height('100%')
    .width('100%')
  }
}
// [End recommended_example]
