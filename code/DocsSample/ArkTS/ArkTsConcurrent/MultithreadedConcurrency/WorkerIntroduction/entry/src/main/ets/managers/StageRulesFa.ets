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

try {
  // 主要说明以下三种场景：
  // 场景1： Worker线程文件所在路径："{moduleName}/src/main/ets/MainAbility/workers/worker.ets"
  const workerFA1: worker.ThreadWorker =
    new worker.ThreadWorker('workers/worker.ets', { name: 'first worker in FA model' });

  // 场景2： Worker线程文件所在路径："{moduleName}/src/main/ets/workers/worker.ets"
  const workerFA2: worker.ThreadWorker = new worker.ThreadWorker('../workers/worker.ets');

  // 场景3： Worker线程文件所在路径："{moduleName}/src/main/ets/MainAbility/ThreadFile/workers/worker.ets"
  const workerFA3: worker.ThreadWorker = new worker.ThreadWorker('ThreadFile/workers/worker.ets');
  workerFA1.onexit = () => {
    console.info('父Worker退出');
  }
  workerFA2.onexit = () => {
    console.info('父Worker退出');
  }
  workerFA3.onexit = () => {
    console.info('父Worker退出');
  }
} catch (e) {
}


@Entry
@Component
struct stageRules {
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