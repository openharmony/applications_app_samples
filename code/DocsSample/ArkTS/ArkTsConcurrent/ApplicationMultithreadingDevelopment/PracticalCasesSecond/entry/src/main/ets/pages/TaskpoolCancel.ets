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
// [Start taskpool_cancel]
// TaskpoolCancel.ets
import { taskpool } from '@kit.ArkTS';
import { SendableTest } from '../utils/Sendable';
import { BusinessError } from '@kit.BasicServicesKit';
import { PromptAction } from '@kit.ArkUI';

@Concurrent
function cancel(send: SendableTest) {
  // 在多线程中通过任务ID取消任务。
  taskpool.cancel(send.getTaskId());
  console.info('cancel task finished');
}

@Concurrent
function delayed() {
  console.info('delayed task finished');
}

@Entry
@Component
struct TaskpoolCancel {
  @State message: string = 'CancelTaskpool';
  @State returnMessage: string = 'return...';
  @State promptAction: PromptAction = this.getUIContext().getPromptAction();

  build() {
    Row() {
      Column() {
        Button(this.message)
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
          .onClick(async () => {
            let task = new taskpool.Task(delayed);
            taskpool.executeDelayed(2000, task).catch((e: BusinessError) => {
              console.error(`taskpool execute error, message is: ${e.message}`);
              // taskpool execute error, message is: taskpool:: task has been canceled.
            });
            let send = new SendableTest(task.taskId);
            taskpool.execute(cancel, send);
            this.returnMessage = 'Taskpool canceled!';
            this.promptAction.showToast({ message: this.returnMessage });
          })
        // [StartExclude taskpool_cancel]
        GotoButton({ text: '跳转回Index页面', dstUri: 'pages/Index'});
        // [EndExclude taskpool_cancel]
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End taskpool_cancel]