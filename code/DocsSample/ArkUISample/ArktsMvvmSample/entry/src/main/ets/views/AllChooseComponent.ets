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

// [Start all_choose_component_view]
import TodoListViewModel from '../viewModel/TodoListViewModel';
import { common } from '@kit.AbilityKit';

@Component
export struct AllChooseComponent {
  context1 = this.getUIContext().getHostContext() as common.UIAbilityContext;
  // $r('app.string.check_all')需要替换为开发者所需的资源文件
  @State titleName: ResourceStr = this.context1.resourceManager.getStringSync($r('app.string.check_all').id);
  @Link todoListViewModel: TodoListViewModel;

  build() {
    Row() {
      Button(`${this.titleName}`, { type: ButtonType.Capsule })
        .onClick(() => {
          this.todoListViewModel.chooseAll(); // View层点击事件发生时，调用ViewModel层方法chooseAll处理逻辑
          // $r('app.string.xxx')需要替换为开发者所需的资源文件
          this.titleName = this.todoListViewModel.isChoosen ?
            this.context1.resourceManager.getStringSync($r('app.string.check_all').id)
            : this.context1.resourceManager.getStringSync($r('app.string.deselect_all').id);
        })
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .backgroundColor('#f7f6cc74')
    }
    .padding({ left: this.todoListViewModel.isChoosen ? 15 : 0 })
    .width('100%')
    .margin({ top: 10, bottom: 10 })
  }
}
// [End all_choose_component_view]