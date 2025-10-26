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

// [Start mvvm_model_main_index]
import { common } from '@kit.AbilityKit';
// import ViewModel
import TodoListViewModel from '../viewModel/TodoListViewModel';

// import View
import { TodoComponent } from '../views/TodoComponent';
import { AllChooseComponent } from '../views/AllChooseComponent';
import { TodoListComponent } from '../views/TodoListComponent';

@Entry
@Component
struct TodoList {
  @State todoListViewModel: TodoListViewModel = new TodoListViewModel(); // View绑定ViewModel的数据
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;

  async aboutToAppear() {
    await this.todoListViewModel.loadTasks(this.context);
  }

  build() {
    Column() {
      Row({ space: 40 }) {
        // 全部待办
        TodoComponent()
        // 全选
        AllChooseComponent({ todoListViewModel: this.todoListViewModel })
      }

      Column() {
        TodoListComponent({ thingViewModelArray: this.todoListViewModel.things })
      }
    }
    .height('100%')
    .width('100%')
    .margin({ top: 5, bottom: 5 })
    .backgroundColor('#90f1f3f5')
  }
}
// [End mvvm_model_main_index]