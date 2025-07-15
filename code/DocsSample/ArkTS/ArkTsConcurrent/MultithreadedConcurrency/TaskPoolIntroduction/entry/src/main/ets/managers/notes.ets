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

// [Start concurrent_taskpool_notes]
import { taskpool } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';

@Concurrent
function printArrayBuffer(buffer: ArrayBuffer) {
  return buffer;
}

function testArrayBuffer() {
  const buffer = new ArrayBuffer(1);
  const group = new taskpool.TaskGroup();
  const task = new taskpool.Task(printArrayBuffer, buffer);
  group.addTask(task);
  task.setCloneList([buffer]);
  for (let i = 0; i < 5; i++) {
    taskpool.execute(group).then(() => {
      console.info('execute group success');
    }).catch((e: BusinessError) => {
      console.error(`execute group error: ${e.message}`);
    })
  }
}

@Entry
@Component
struct Notes {
  @State message: string = 'Hello World';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Button() {
          Text('notes start')
        }.onClick(() => {
          testArrayBuffer();
          this.message = 'notes success';
        })
        .id('notes button')
        .width('20%')
        .height('10%')
      }
      .width('100%')
    }.height('100%')
  }
}
// [End concurrent_taskpool_notes]