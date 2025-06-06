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

// [Start example_pass_obj]
import { taskpool } from '@kit.ArkTS';

@Concurrent
function transferAtomics(arg1: Int32Array) {
  console.info('wait begin::');
  // 使用Atomics进行操作
  let res = Atomics.wait(arg1, 0, 0, 3000);
  return res;
}

@Entry
@Component
struct sharedArrayBuffer {
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
          // 定义可共享对象
          let sab: SharedArrayBuffer = new SharedArrayBuffer(20);
          let int32 = new Int32Array(sab);
          let task: taskpool.Task = new taskpool.Task(transferAtomics, int32);
          taskpool.execute(task).then((res) => {
            console.info('this res is: ' + res);
          });
          setTimeout(() => {
            Atomics.notify(int32, 0, 1);
          }, 1000);
          this.message = 'success';
        })
    }
    .height('100%')
    .width('100%')
  }
}
// [End example_pass_obj]
