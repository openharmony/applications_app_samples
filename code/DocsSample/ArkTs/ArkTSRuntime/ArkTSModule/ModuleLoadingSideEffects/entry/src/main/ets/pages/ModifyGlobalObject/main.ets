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

import { data1 } from './module'; // 将全局变量someGlobalVar的值改为100
import { data2 } from './sideEffectModule'; // 又将全局变量someGlobalVar的值改为200
import { useGlobalVar } from './moduleUseGlobalVar';
import { dataOptimize1 } from './moduleOptimize';
import { dataOptimize2 } from './sideEffectModuleOptimize';
import { useGlobalVarOptimize } from './moduleUseGlobalVarOptimize';

function maybeNotCalledAtAll() {
  console.log(data1);
  console.log(data2);
}

function maybeNotCalledAtAllOptimize() {
  console.log(dataOptimize1);
  console.log(dataOptimize2);
}

@Entry
@Component
struct main {
  @State message1: string = 'sideEffect';
  @State message2: string = 'optimize';

  build() {
    Column() {
      Button('SideEffect')
        .width('50%')
        .margin({ bottom: 3 })
        .onClick(() => {
          useGlobalVar();
          this.message1 = 'sideEffect result: ' + globalThis.someGlobalVar;
        })
      Button('Optimize')
        .width('50%')
        .margin({ bottom: 3 })
        .onClick(() => {
          useGlobalVarOptimize();
          this.message2 = 'optimize result: ' + globalThis.someGlobalVar;
        })
      Row() {
        Text(this.message1)
          .height(30)
          .fontSize(20)
        Divider()
          .vertical(true)
          .height(30)
          .margin({ left: 8, right: 8 })
          .strokeWidth(2)
        Text(this.message2)
          .height(30)
          .fontSize(20)
      }
    }
    .height('50%')
    .width('100%')
  }
}