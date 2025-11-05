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

// [Start Main_TodoListPage]
// src/main/ets/pages/TodoListPage.ets
import TaskListViewModel from '../viewmodel/TaskListViewModel';
import { common } from '@kit.AbilityKit';
import { AppStorageV2, PersistenceV2, router } from '@kit.ArkUI';
import { Setting } from '../pages/SettingPage';
import TitleView from '../view/TitleView';
import ListView from '../view/ListView';
import BottomView from '../view/BottomView';

@Entry
@ComponentV2
struct TodoList {
  @Local taskList: TaskListViewModel = PersistenceV2.connect(TaskListViewModel, 'TaskList', () => new TaskListViewModel())!;
  @Local setting: Setting = AppStorageV2.connect(Setting, 'Setting', () => new Setting())!;
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;

  async aboutToAppear() {
    this.taskList = PersistenceV2.connect(TaskListViewModel, 'TaskList', () => new TaskListViewModel())!;
    if (this.taskList.tasks.length === 0) {
      await this.taskList.loadTasks(this.context);
    }
  }

  @Computed
  get tasksUnfinished(): number {
    return this.taskList.tasks.filter(task => !task.isFinish).length;
  }

  build() {
    Column() {
      TitleView({ tasksUnfinished: this.tasksUnfinished })
      ListView({ taskList: this.taskList, setting: this.setting });
      BottomView({ taskList: this.taskList });
      // [StartExclude Main_TodoListPage]
      Button('AppStorageV2', { stateEffect: true, type: ButtonType.Capsule })
        .width('80%')
        .height(40)
        .margin(20)
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({url:'pages/AppStorageV2'});
        })

      Button('Store data between two pages', { stateEffect: true, type: ButtonType.Capsule })
        .width('80%')
        .height(40)
        .margin(20)
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({url:'pages/PageOne'});
        })
      // [EndExclude Main_TodoListPage]
    }
    .height('100%')
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .margin({ left: 15 })
  }
}
// [End Main_TodoListPage]