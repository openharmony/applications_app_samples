/*
 * Copyright (c) 2024-2025 Huawei Device Co., Ltd.
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

// [Start actor_model]
import { taskpool } from '@kit.ArkTS';
import { Main } from './Cale'

// 跨线程并发任务
@Concurrent
async function produce(): Promise<number> {
  // 添加生产相关逻辑
  console.info('producing...');
  return Math.random();
}

class Consumer {
  public consume(value: Object) {
    // 添加消费相关逻辑
    console.info('consuming value: ' + value);
  }
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
        Button() {
          Text('Actor start')
        }.onClick(() => {
          let produceTask: taskpool.Task = new taskpool.Task(produce);
          let consumer: Consumer = new Consumer();
          for (let index: number = 0; index < 10; index++) {
            // 执行生产异步并发任务
            taskpool.execute(produceTask).then((res: Object) => {
              consumer.consume(res);
            }).catch((e: Error) => {
              console.error(e.message);
            })
          }
          // [StartExclude update_message_on_success]
          this.message = 'success';
          // [EndExclude update_message_on_success]
        })
        // [StartExclude set_button_id]
        .id('button')
        // [EndExclude set_button_id]
        .width('20%')
        .height('20%')

        Button() {
          Text('Actor start2')
        }.onClick(async () => {
          let dataArray: number[] = [];
          let produceTask: taskpool.Task = new taskpool.Task(produce);
          let consumer: Consumer = new Consumer();
          for (let index: number = 0; index < 10; index++) {
            // 执行生产异步并发任务
            let result = await taskpool.execute(produceTask) as number;
            dataArray.push(result);
          }
          for (let index: number = 0; index < dataArray.length; index++) {
            consumer.consume(dataArray[index]);
          }
          // [StartExclude update_message_on_success]
          this.message = 'success2';
          // [EndExclude update_message_on_success]
        })
        // [StartExclude set_button_id]
        .id('button2')
        // [EndExclude set_button_id]
        .width('20%')
        .height('20%')

        Button() {
          Text('cale start')
        }.onClick(async () => {
          Main();
          this.message = 'cale success';
        })
        // [StartExclude set_button_id]
        .id('button3')
        // [EndExclude set_button_id]
        .width('20%')
        .height('20%')
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End actor_model]
