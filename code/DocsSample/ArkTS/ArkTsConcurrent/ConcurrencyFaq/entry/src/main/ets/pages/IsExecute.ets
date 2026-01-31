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
// [Start is_execute]
import { taskpool } from '@kit.ArkTS';

@Concurrent
function createTask(a: number, b:number): number {
  let sum = a + b;
  return sum;
}

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            console.info('test start');
            // 其他业务逻辑
            // ...
            let task: taskpool.Task = new taskpool.Task(createTask, 1, 2);
            taskpool.execute(task);
            // ...
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}

// 如果test start在控制台打印，但是并未出现Task Allocation: taskId:的日志，则taskpool.execute没有执行，应用需要排查其他业务逻辑
// [End is_execute]