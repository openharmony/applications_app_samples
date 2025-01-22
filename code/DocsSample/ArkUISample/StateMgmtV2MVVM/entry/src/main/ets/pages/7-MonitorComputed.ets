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
import { hilog } from '@kit.PerformanceAnalysisKit';

// src/main/ets/pages/7-MonitorComputed.ets

@ObservedV2
class Task {
  public taskName: string = '';
  @Trace public isFinish: boolean = false;

  constructor (taskName: string, isFinish: boolean) {
    this.taskName = taskName;
    this.isFinish = isFinish;
  }
}

@ComponentV2
struct TaskItem {
  @Param task: Task = new Task('', false);
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
      Text(this.task.taskName)
        .decoration({ type: this.task.isFinish ? TextDecorationType.LineThrough : TextDecorationType.None })
      Button($r('app.string.Delete_task'))
        .onClick(() => this.deleteTask())
    }
    .onClick(() => this.task.isFinish = !this.task.isFinish)
  }
}

@Entry
@ComponentV2
struct TodoList {
  @Local tasks: Task[] = [
    new Task('task1', false),
    new Task('task2', false),
    new Task('task3', false),
  ];
  @Local newTaskName: string = '';

  finishAll(ifFinish: boolean) {
    for (let task of this.tasks) {
      task.isFinish = ifFinish;
    }
  }

  @Computed
  get tasksUnfinished(): number {
    return this.tasks.filter(task => !task.isFinish).length;
  }

  build() {
    Column() {
      Text($r('app.string.TodoList_title'))
        .fontSize(40)
        .margin({ bottom: 10 })
      Text(`${getContext(this).resourceManager.getStringSync($r('app.string.Unfinish_count').id)}：${this.tasksUnfinished}`)
      Repeat<Task>(this.tasks)
        .each((obj: RepeatItem<Task>) => {
          TaskItem({
            task: obj.item,
            deleteTask: () => this.tasks.splice(this.tasks.indexOf(obj.item), 1)
          })
        })
      Row() {
        Button($r('app.string.Finish_all_tasks'))
          .onClick(() => this.finishAll(true))
        Button($r('app.string.Unfinish_all_tasks'))
          .onClick(() => this.finishAll(false))
      }
      Row() {
        TextInput({ placeholder: $r('app.string.Add_new_task'), text: this.newTaskName })
          .onChange((value) => this.newTaskName = value)
          .width('70%')
        Button('+')
          .onClick(() => {
            this.tasks.push(new Task(this.newTaskName, false));
            this.newTaskName = '';
          })
      }
    }
  }
}