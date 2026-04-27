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

// src/main/ets/model/TaskListModel.ets
// [Start Model_TaskListModel]
import { common } from '@kit.AbilityKit';
import { util } from '@kit.ArkTS';
import TaskModel from './TaskModel';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;

// Model层：TaskListModel负责加载任务列表
export default class TaskListModel {
  public tasks: TaskModel[] = [];

  constructor(tasks: TaskModel[]) {
    this.tasks = tasks;
  }

  async loadTasks(context: common.UIAbilityContext) {
    try {
      let getJson = await context.resourceManager.getRawFileContent('defaultTasks.json');
      let textDecoderOptions: util.TextDecoderOptions = { ignoreBOM: true };
      let textDecoder = util.TextDecoder.create('utf-8', textDecoderOptions);
      let result = textDecoder.decodeToString(getJson);
      this.tasks = JSON.parse(result).map((task: TaskModel) => {
        let newTask = new TaskModel();
        newTask.taskName = task.taskName;
        newTask.isFinish = task.isFinish;
        return newTask;
      });
    } catch (e) {
      hilog.error(DOMAIN, 'testTag', 'Failed to getRawFileContent', JSON.stringify(e) ?? '');
    }
  }
}
// [End Model_TaskListModel]