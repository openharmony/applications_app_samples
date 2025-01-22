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
 *
*/

// src/main/ets/view/ListView.ets

import TaskViewModel from '../viewmodel/TaskViewModel';
import TaskListViewModel from '../viewmodel/TaskListViewModel';
import { Setting } from '../pages/SettingPage';
import { actionButton } from './BottomView';
import { hilog } from '@kit.PerformanceAnalysisKit';

@ComponentV2
struct TaskItem {
  @Param task: TaskViewModel = new TaskViewModel();
  @Event deleteTask: () => void = () => {};
  @Monitor('task.isFinish')
  onTaskFinished(mon: IMonitor) {
    hilog.debug(0x0000, 'testTag', '%{public}s', '任务' + this.task.taskName + '的完成状态从' + mon.value()?.before + '变为了' + mon.value()?.now);
  }

  build() {
    Row() {
      Image(this.task.isFinish ? $r('app.media.finished') : $r('app.media.unfinished'))
        .width(28)
        .height(28)
        .margin({ left: 15, right: 10 })
      Text(this.task.taskName)
        .decoration({ type: this.task.isFinish ? TextDecorationType.LineThrough : TextDecorationType.None })
        .fontSize(18)
      actionButton($r('app.string.Delete_task'), () => this.deleteTask());
    }
    .height('7%')
    .width('90%')
    .backgroundColor('#90f1f3f5')
    .borderRadius(25)
    .onClick(() => this.task.updateIsFinish())
  }
}

@ComponentV2
export default struct ListView {
  @Param taskList: TaskListViewModel = new TaskListViewModel();
  @Param setting: Setting = new Setting();

  build() {
    Repeat<TaskViewModel>(this.taskList.tasks.filter(task => this.setting.showCompletedTask || !task.isFinish))
      .each((obj: RepeatItem<TaskViewModel>) => {
        TaskItem({
          task: obj.item,
          deleteTask: () => this.taskList.removeTask(obj.item)
        }).margin(5)
      })
  }
}