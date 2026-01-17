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
// [Start catch_error]
import { taskpool } from '@kit.ArkTS';

@Concurrent
function createTask(a: number, b:number): number {
  let sum = a + b;
  return sum;
}

@Entry
@Component
struct Index {
  @State message: string | ResourceStr = $r('app.string.Button_label');

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            console.info('test start');
            // 其他业务逻辑。
            // ...
            let task: taskpool.Task = new taskpool.Task(createTask, 1, 2);
            taskpool.execute(task).then((res: object)=>{
              // 任务执行完处理结果。
              this.message = '任务执行结果:'+ res;
              // ...
            }).catch((e: Error)=>{
              // 任务发生异常后处理异常。
              // ...
            })
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}

// 如果test start在控制台打印，但是并未出现Task Allocation: taskId:的日志，则taskpool.execute没有执行，应用需要排查其他业务逻辑。
// [End catch_error]