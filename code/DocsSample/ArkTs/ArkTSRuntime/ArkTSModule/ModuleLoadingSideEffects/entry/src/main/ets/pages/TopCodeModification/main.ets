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

// [Start import_put_console_log]
import { data } from './topCodeModule'; // 导入时，module.ets中的console.log会执行，产生输出。
import { dataOptimizeOne } from './topCodeModuleOptimize';
import { dataOptimizeTwo } from './module';
// [End import_put_console_log]

@Entry
@Component
struct main {
  @State message1: string = 'sideEffect';
  @State message2: string = 'optimize one';
  @State message3: string = 'optimize two';

  build() {
    Column() {
      Button('Call top code')
        .width('50%')
        .margin({ bottom: 3 })
        .onClick(() => {
          console.log(data.toString());
          this.message1 = 'sideEffect: Module loaded!' + data.toString();
          console.log(dataOptimizeOne.toString());
          this.message2 = 'optimize one: ' + dataOptimizeOne.toString();
          console.log(dataOptimizeTwo.toString());
          this.message3 = 'optimize two: ' + dataOptimizeTwo.toString();
        })
      Row() {
        Text(this.message1)
          .height(22)
          .fontSize(15)
        Divider()
          .vertical(true)
          .height(22)
          .margin({ left: 8, right: 8 })
          .strokeWidth(2)
        Text(this.message2)
          .height(22)
          .fontSize(15)
        Divider()
          .vertical(true)
          .height(22)
          .margin({ left: 8, right: 8 })
          .strokeWidth(2)
        Text(this.message3)
          .height(22)
          .fontSize(15)
      }
    }
    .height('50%')
    .width('100%')
  }
}