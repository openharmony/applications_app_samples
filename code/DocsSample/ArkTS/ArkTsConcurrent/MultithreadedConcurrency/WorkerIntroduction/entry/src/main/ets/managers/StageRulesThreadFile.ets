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
// [Start import_worker]
import { worker } from '@kit.ArkTS';
// worker线程文件所在路径："entry/src/main/ets/workers/worker.ets"
const workerInstance1: worker.ThreadWorker = new worker.ThreadWorker('entry/ets/workers/worker.ets');
// worker线程文件所在路径："testworkers/src/main/ets/ThreadFile/workers/worker.ets"
const workerInstance2: worker.ThreadWorker = new worker.ThreadWorker('testworkers/ets/ThreadFile/workers/worker.ets');
// [End import_worker]
workerInstance1.onexit = () => {
  console.info('workerInstance1 退出');
}
workerInstance2.onexit = () => {
  console.info('workerInstance2 退出');
}
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