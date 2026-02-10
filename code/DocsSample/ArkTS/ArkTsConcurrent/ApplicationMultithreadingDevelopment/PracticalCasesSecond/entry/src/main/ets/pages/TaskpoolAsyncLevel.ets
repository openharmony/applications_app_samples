/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
import { GotoButton } from '../utils/MyButton';
// [Start taskpool_import]
// TaskpoolAsyncLevel.ets
import { taskpool } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';
import { PromptAction } from '@kit.ArkUI';
// [End taskpool_import]

// [Start collect_frame]
// TaskpoolAsyncLevel.ets
@Concurrent
function collectFrame() {
  // 采集数据，并且进行处理
  // 模拟处理过程，这里是个耗时任务，持续时间为30秒
  let t = new Date().getTime()
  while (new Date().getTime() - t < 30000) {
    continue;
  }
  console.info('collectFrame finished');
}
// [End collect_frame]

// [Start trigger_task]
// TaskpoolAsyncLevel.ets
@Entry
@Component
struct TaskpoolAsyncLevel {
  @State message: string = '触发采集任务';
  @State returnMessage: string = 'return...';
  @State promptAction: PromptAction = this.getUIContext().getPromptAction();
  
  build() {
    Row() {
      Column() {
        Button(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(async () => {
            // 创建并发度为5的异步队列，等待队列个数为5，当加入的任务数量超过5时，等待列表中处于队头的任务会被丢弃
            let asyncRunner: taskpool.AsyncRunner = new taskpool.AsyncRunner('async', 5, 5);
            // 触发采集任务
            for (let i = 0; i < 20; i++) {
              let task: taskpool.Task = new taskpool.Task(`async${i}`, collectFrame);
              asyncRunner.execute(task).then(() => {
                console.info('the current task name is ' + task.name);
              }).catch((e: BusinessError) => {
                console.error('async: error is ' + e);
              });
            }
            console.info('asyncRunner task finished');
            this.returnMessage = 'asyncRunner task finished';
            this.promptAction.showToast({ message: this.returnMessage });
          })
        // [StartExclude trigger_task]
        GotoButton({ text: '跳转回Index页面', dstUri: 'pages/Index'});
        // [EndExclude trigger_task]
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End trigger_task]