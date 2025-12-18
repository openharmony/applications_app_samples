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

// [Start Main_Builder]
// src/main/ets/pages/BuilderPage.ets
import { AppStorageV2, PersistenceV2, Type } from '@kit.ArkUI';
import { common, Want } from '@kit.AbilityKit';
import { Setting } from './SettingPage';
import { util } from '@kit.ArkTS';
import { hilog } from '@kit.PerformanceAnalysisKit';

@ObservedV2
class Task {
  // 未实现构造函数，因为@Type当前不支持带参数的构造函数。
  @Trace public taskName: string = 'Todo';
  @Trace public isFinish: boolean = false;
}

@Builder
function actionButton(text: string | Resource, onClick: () => void) {
  Button(text, { buttonStyle: ButtonStyleMode.NORMAL })
    .onClick(onClick)
    .margin({
      left: 10,
      right: 10,
      top: 5,
      bottom: 5
    })
}

@ObservedV2
class TaskList {
  // 对于复杂对象需要@Type修饰，确保序列化成功。
  @Type(Task)
  @Trace public tasks: Task[] = [];

  constructor(tasks: Task[]) {
    this.tasks = tasks;
  }

  async loadTasks(context: common.UIAbilityContext) {
    let getJson = await context.resourceManager.getRawFileContent('defaultTasks.json');
    let textDecoderOptions: util.TextDecoderOptions = { ignoreBOM: true };
    let textDecoder = util.TextDecoder.create('utf-8', textDecoderOptions);
    let result = textDecoder.decodeToString(getJson);
    this.tasks = JSON.parse(result).map((task: Task) => {
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
    hilog.info(0x0000, 'testTag', '%{public}s', 'task' + this.task.taskName + 'The completion status of the' + mon.value()?.before + 'has become' + mon.value()?.now);
  }

  build() {
    Row() {
      // 请开发者自行在src/main/resources/base/media路径下添加finished.png和unfinished.png两张图片，否则运行时会因资源缺失而报错。
      Image(this.task.isFinish ? $r('app.media.finished') : $r('app.media.unfinished'))
        .width(28)
        .height(28)
        .margin({ left: 15, right: 10 })
      Text(this.task.taskName)
        .decoration({ type: this.task.isFinish ? TextDecorationType.LineThrough : TextDecorationType.None })
        .fontSize(18)
      actionButton('Delete', () => {
        this.deleteTask();
      })
    }
    .height('7%')
    .width('90%')
    .backgroundColor('#90f1f3f5')
    .borderRadius(25)
    .onClick(() => {
      this.task.isFinish = !this.task.isFinish;
    })
  }
}

@Entry
@ComponentV2
struct TodoList {
  @Local taskList: TaskList = PersistenceV2.connect(TaskList, 'TaskList', () => new TaskList([]))!;
  @Local newTaskName: string = '';
  @Local setting: Setting = AppStorageV2.connect(Setting, 'Setting', () => new Setting())!;
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;

  async aboutToAppear() {
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
      Text('To do')
        .fontSize(40)
        .margin(10)
      Text('Unfinished task' + `：${this.tasksUnfinished}`)
        .margin({ left: 10, bottom: 10 })
      Repeat<Task>(this.taskList.tasks.filter(task => this.setting.showCompletedTask || !task.isFinish))
        .each((obj: RepeatItem<Task>) => {
          TaskItem({
            task: obj.item,
            deleteTask: () => {
              this.taskList.tasks.splice(this.taskList.tasks.indexOf(obj.item), 1);
            }
          })
            .margin(5)
        })
      Row() {
        actionButton('All Completed', (): void => this.finishAll(true))
        actionButton('All Not Completed', (): void => this.finishAll(false))
        actionButton('Setting', (): void => {
          let wantInfo: Want = {
            deviceId: '', // deviceId为空表示本设备。
            bundleName: 'com.samples.statemgmtv2mvvm', // 替换成AppScope/app.json5里的bundleName。
            abilityName: 'SettingAbility',
          };
          this.context.startAbility(wantInfo);
        })
      }
      .margin({ top: 10, bottom: 5 })
      Row() {
        TextInput({ placeholder: 'Add new tasks', text: this.newTaskName })
          .onChange((value) => {
            this.newTaskName = value;
          })
          .width('70%')
        actionButton('+', (): void => {
          let newTask = new Task();
          newTask.taskName = this.newTaskName;
          this.taskList.tasks.push(newTask);
          this.newTaskName = '';
        })
      }
    }
    .height('100%')
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .margin({ left: 15 })
  }
}
// [End Main_Builder]