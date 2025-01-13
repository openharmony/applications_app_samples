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

import { freezeObj } from './helper';
import { worker } from '@kit.ArkTS';

@Sendable
export class GlobalConfig {
  // 一些配置属性与方法
  init() {
    // 初始化相关逻辑
    freezeObj(this); // 初始化完成后冻结当前对象
  }
}

@Entry
@Component
struct Index {
  @State message: string = 'Sendable freezeObj Test';

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
          let gConifg = new GlobalConfig();
          gConifg.init();
          const workerInstance = new worker.ThreadWorker('entry/ets/workers/Worker.ets', { name: 'Worker1' });
          workerInstance.postMessage(gConifg);
          this.message = 'success';
        })
    }
    .height('100%')
    .width('100%')
  }
}
