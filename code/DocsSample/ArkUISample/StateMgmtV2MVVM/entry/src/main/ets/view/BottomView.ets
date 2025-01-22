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

// src/main/ets/view/BottomView.ets

import { common, Want } from '@kit.AbilityKit';
import TaskViewModel from '../viewmodel/TaskViewModel';
import TaskListViewModel from '../viewmodel/TaskListViewModel';

@Builder export function actionButton(text: string|Resource, onClick:() => void) {
  Button(text, { buttonStyle: ButtonStyleMode.NORMAL })
    .onClick(onClick)
    .margin({ left: 10, right: 10, top: 5, bottom: 5 })
}

@ComponentV2
export default struct BottomView {
  @Param taskList: TaskListViewModel = new TaskListViewModel();
  @Local newTaskName: string = '';
  private context = getContext() as common.UIAbilityContext;

  build() {
    Column() {
      Row() {
        actionButton($r('app.string.Finish_all_tasks'), (): void => this.taskList.finishAll(true))
        actionButton($r('app.string.Unfinish_all_tasks'), (): void => this.taskList.finishAll(false))
        actionButton($r('app.string.Setting'), (): void => {
          let wantInfo: Want = {
            deviceId: '', // deviceId为空表示本设备
            bundleName: 'com.samples.statemgmtv2mvvm', // 替换成AppScope/app.json5里的bundleName
            abilityName: 'SettingAbility',
          };
          this.context.startAbility(wantInfo);
        })
      }
      .margin({ top: 10, bottom: 5 })
      Row() {
        TextInput({ placeholder: $r('app.string.Add_new_task'), text: this.newTaskName })
          .onChange((value) => this.newTaskName = value)
          .width('70%')
        actionButton('+', (): void => {
          let newTask = new TaskViewModel();
          newTask.taskName = this.newTaskName;
          this.taskList.addTask(newTask);
          this.newTaskName = '';
        })
      }
    }
  }
}