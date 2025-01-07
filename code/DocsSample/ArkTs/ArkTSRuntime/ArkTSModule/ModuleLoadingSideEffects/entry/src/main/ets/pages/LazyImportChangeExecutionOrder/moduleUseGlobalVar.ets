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

import lazy { data } from './module';
import lazy { dataOptimize, initialize } from './moduleOptimize';

@Entry
@Component
struct moduleUseGlobalVar {
  @State message1: string = 'SideEffect';
  @State message2: string = 'Optimize';

  build() {
    Column() {
      Row() {
        Button('LazyImportSideEffect')
          .width('40%')
          .height(30)
          .onClick(() => {
            console.log(globalThis.someGlobalVar); // 此时由于lazy特性，module模块还未执行，someGlobalVar的值为undefined
            this.message1 = 'SideEffect: ' + globalThis.someGlobalVar;
            console.log(data); // 使用到module模块的变量，此时module模块执行，someGlobalVar的值变为100
          })
        Divider()
          .vertical(true)
          .margin({ left: 8, right: 8 })
          .strokeWidth(3)
          .height(30)
        Button('LazyImportOptimize')
          .width('40%')
          .height(30)
          .onClick(() => {
            initialize(); // 执行初始化函数，初始化someGlobalVar
            console.log(globalThis.someGlobalVar); // 此时someGlobalVar一定为预期的值
            this.message2 = 'Optimize: ' + globalThis.someGlobalVar.toString();
            console.log(dataOptimize);
          })
      }

      Row() {
        Text(this.message1)
          .fontSize(20)
          .height(30)
        Divider()
          .vertical(true)
          .margin({ left: 8, right: 8 })
          .strokeWidth(3)
          .height(30)
        Text(this.message2)
          .fontSize(20)
          .height(30)
      }
    }
    .height('100%')
    .width('100%')
  }
}