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
import resource from '../util/resource';

const workerInstance: worker.ThreadWorker = new worker.ThreadWorker('entry/ets/workers/Worker.ets');

@Entry
@Component
struct Index {
  @State message: string = 'Listener task';

  build() {
    Column() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          workerInstance.postMessage({ type: 'start' });
          workerInstance.onmessage = (event) => {
            console.info(resource.resourceToString($r('app.string.Information')), event.data);
          }
          // 10秒后停止worker
          setTimeout(() => {
            workerInstance.postMessage({ type: 'stop' });
          }, 10000);
          this.message = 'success';
        })
    }
    .height('100%')
    .width('100%')
  }
}