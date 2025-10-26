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
 */

// [Start to_do_list_view_model]
import ThingViewModel from './ThingViewModel';
import { common } from '@kit.AbilityKit';
import TodoListModel from '../model/TodoListModel';

@Observed
export class ThingViewModelArray extends Array<ThingViewModel> {
}

@Observed
export default class TodoListViewModel {
  @Track public isChoosen: boolean = true;
  @Track public things: ThingViewModelArray = new ThingViewModelArray();

  async loadTasks(context: common.UIAbilityContext) {
    let todoList = new TodoListModel([]);
    await todoList.loadTasks(context);
    for (let thing of todoList.things) {
      let todoListViewModel = new ThingViewModel();
      todoListViewModel.updateTask(thing);
      this.things.push(todoListViewModel);
    }
  }

  chooseAll(): void {
    for (let thing of this.things) {
      thing.isFinish = this.isChoosen;
    }
    this.isChoosen = !this.isChoosen;
  }
}
// [End to_do_list_view_model]