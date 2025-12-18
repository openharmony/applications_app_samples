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
// [Start Main_MonitorComputed]
// src/main/ets/pages/MonitorComputedPage.ets
import { hilog } from '@kit.PerformanceAnalysisKit';

@ObservedV2
class Task {
  public taskName: string = '';
  @Trace public isFinish: boolean = false;

  constructor(taskName: string, isFinish: boolean) {
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
    hilog.info(0x0000, 'testTag', '%{public}s', 'task' + this.task.taskName + 'The completion status of the' + mon.value()?.before + 'has become' + mon.value()?.now);
  }

  build() {
    Row() {
      // 请开发者自行在src/main/resources/base/media路径下添加finished.png和unfinished.png两张图片，否则运行时会因资源缺失而报错。
      Image(this.task.isFinish ? $r('app.media.finished') : $r('app.media.unfinished'))
        .width(28)
        .height(28)
      Text(this.task.taskName)
        .decoration({ type: this.task.isFinish ? TextDecorationType.LineThrough : TextDecorationType.None })
      Button('Delete')
        .onClick(() => {
          this.deleteTask();
        })
    }
    .onClick(() => {
      this.task.isFinish = !this.task.isFinish;
    })
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
      Text('To do')
        .fontSize(40)
        .margin({ bottom: 10 })
      Text('Unfinished task' + `：${this.tasksUnfinished}`)
      Repeat<Task>(this.tasks)
        .each((obj: RepeatItem<Task>) => {
          TaskItem({
            task: obj.item,
            deleteTask: () => {
              this.tasks.splice(this.tasks.indexOf(obj.item), 1);
            }
          })
        })
      Row() {
        Button('All Completed')
          .onClick(() => {
            this.finishAll(true);
          })
        Button('All Not Completed')
          .onClick(() => {
            this.finishAll(false);
          })
      }
      Row() {
        TextInput({ placeholder: 'Add new tasks', text: this.newTaskName })
          .onChange((value) => {
            this.newTaskName = value;
          })
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
// [End Main_MonitorComputed]