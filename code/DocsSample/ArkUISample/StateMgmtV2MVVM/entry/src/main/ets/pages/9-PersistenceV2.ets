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

// src/main/ets/pages/9-PersistenceV2.ets

import { AppStorageV2, PersistenceV2, Type } from '@kit.ArkUI';
import { common, Want } from '@kit.AbilityKit';
import { Setting } from './SettingPage';
import util from '@ohos.util';
import { hilog } from '@kit.PerformanceAnalysisKit';

@ObservedV2
class Task {
  // 未实现构造函数，因为@Type当前不支持带参数的构造函数
  @Trace public taskName: string = 'Todo';
  @Trace public isFinish: boolean = false;
}

@ObservedV2
class TaskList {
  // 对于复杂对象需要@Type修饰，确保序列化成功
  @Type(Task)
  @Trace public tasks: Task[] = [];

  constructor(tasks: Task[]) {
    this.tasks = tasks;
  }

  async loadTasks(context: common.UIAbilityContext) {
    let getJson = await context.resourceManager.getRawFileContent('defaultTasks.json');
    let textDecoderOptions: util.TextDecoderOptions = { ignoreBOM : true };
    let textDecoder = util.TextDecoder.create('utf-8',textDecoderOptions);
    let result = textDecoder.decodeToString(getJson);
    this.tasks =JSON.parse(result).map((task: Task)=>{
      let newTask = new Task();
      newTask.taskName = task.taskName;
      newTask.isFinish = task.isFinish;
      return newTask;
    });
  }
}

@ComponentV2
struct TaskItem {
  @Param task: Task = new Task();
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
  @Local taskList: TaskList = PersistenceV2.connect(TaskList, 'TaskList', () => new TaskList([]))!;
  @Local newTaskName: string = '';
  @Local setting: Setting = AppStorageV2.connect(Setting, 'Setting', () => new Setting())!;
  private context = getContext(this) as common.UIAbilityContext;

  async aboutToAppear() {
    this.taskList = PersistenceV2.connect(TaskList, 'TaskList', () => new TaskList([]))!;
    if (this.taskList.tasks.length === 0) {
      await this.taskList.loadTasks(this.context);
    }
  }

  finishAll(ifFinish: boolean) {
    for (let task of this.taskList.tasks) {
      task.isFinish = ifFinish;
    }
  }

  @Computed
  get tasksUnfinished(): number {
    return this.taskList.tasks.filter(task => !task.isFinish).length;
  }

  build() {
    Column() {
      Text($r('app.string.TodoList_title'))
        .fontSize(40)
        .margin({ bottom: 10 })
      Text(`${this.context.resourceManager.getStringSync($r('app.string.Unfinish_count').id)}：${this.tasksUnfinished}`)
      Repeat<Task>(this.taskList.tasks.filter(task => this.setting.showCompletedTask || !task.isFinish))
        .each((obj: RepeatItem<Task>) => {
          TaskItem({
            task: obj.item,
            deleteTask: () => this.taskList.tasks.splice(this.taskList.tasks.indexOf(obj.item), 1)
          })
        })
      Row() {
        Button($r('app.string.Finish_all_tasks'))
          .onClick(() => this.finishAll(true))
        Button($r('app.string.Unfinish_all_tasks'))
          .onClick(() => this.finishAll(false))
        Button($r('app.string.Setting'))
          .onClick(() => {
            let wantInfo: Want = {
              deviceId: '', // deviceId为空表示本设备
              bundleName: 'com.samples.statemgmtv2mvvm', // 替换成AppScope/app.json5里的bundleName
              abilityName: 'SettingAbility',
            };
            this.context.startAbility(wantInfo);
          })
      }
      Row() {
        TextInput({ placeholder: $r('app.string.Add_new_task'), text: this.newTaskName })
          .onChange((value) => this.newTaskName = value)
          .width('70%')
        Button('+')
          .onClick(() => {
            let newTask = new Task();
            newTask.taskName = this.newTaskName;
            this.taskList.tasks.push(newTask);
            this.newTaskName = '';
          })
      }
    }
  }
}