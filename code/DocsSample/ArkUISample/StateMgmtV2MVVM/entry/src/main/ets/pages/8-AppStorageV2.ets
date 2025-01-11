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

// src/main/ets/pages/8-AppStorageV2.ets

import { AppStorageV2 } from '@kit.ArkUI';
import { common, Want } from '@kit.AbilityKit';
import { Setting } from './SettingPage';
import { hilog } from '@kit.PerformanceAnalysisKit';

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
  @Local setting: Setting = AppStorageV2.connect(Setting, 'Setting', () => new Setting())!;
  private context = getContext(this) as common.UIAbilityContext;

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
      Text(`${this.context.resourceManager.getStringSync($r('app.string.Unfinish_count').id)}：${this.tasksUnfinished}`)
      Repeat<Task>(this.tasks.filter(task => this.setting.showCompletedTask || !task.isFinish))
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
            this.tasks.push(new Task(this.newTaskName, false));
            this.newTaskName = '';
          })
      }
    }
  }
}