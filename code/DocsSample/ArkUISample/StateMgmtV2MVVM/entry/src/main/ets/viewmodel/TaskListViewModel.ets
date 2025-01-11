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

// src/main/ets/viewmodel/TaskListViewModel.ets

import { common } from '@kit.AbilityKit';
import { Type } from '@kit.ArkUI';
import TaskListModel from '../model/TaskListModel';
import TaskViewModel from'./TaskViewModel';

@ObservedV2
export default class TaskListViewModel {
  @Type(TaskViewModel)
  @Trace public tasks: TaskViewModel[] = [];

  async loadTasks(context: common.UIAbilityContext) {
    let taskList = new TaskListModel([]);
    await taskList.loadTasks(context);
    for(let task of taskList.tasks){
      let taskViewModel = new TaskViewModel();
      taskViewModel.updateTask(task);
      this.tasks.push(taskViewModel);
    }
  }

  finishAll(ifFinish: boolean): void {
    for(let task of this.tasks){
      task.isFinish = ifFinish;
    }
  }

  addTask(newTask: TaskViewModel): void {
    this.tasks.push(newTask);
  }

  removeTask(removedTask: TaskViewModel): void {
    this.tasks.splice(this.tasks.indexOf(removedTask), 1);
  }
}