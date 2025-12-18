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


import { ComponentCard } from '../../common/Card';
import common from '@ohos.app.ability.common';
// [Start build_list_layouts_and_list_items]
import { ToDo } from './ToDo';
import { ToDoListItem } from './ToDoListItem';

@Entry
@Component
export struct AddListItem {
  @State toDoData: ToDo[] = [];
  @Watch('onEditModeChange') @State isEditMode: boolean = false;
  @State selectedItems: ToDo[] = [];
  private availableThings: string [] = [];

  aboutToAppear(): void {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    const reading = context.resourceManager.getStringByNameSync('Reading')
    this.availableThings.push(reading)
    const exercise = context.resourceManager.getStringByNameSync('Exercise')
    this.availableThings.push(exercise)
    const travel = context.resourceManager.getStringByNameSync('Travel')
    this.availableThings.push(travel)
    const listening = context.resourceManager.getStringByNameSync('Listening_Music')
    this.availableThings.push(listening)
    const watching = context.resourceManager.getStringByNameSync('Watching_Films')
    this.availableThings.push(watching)
    const singing = context.resourceManager.getStringByNameSync('Singing')
    this.availableThings.push(singing)
  }

  onEditModeChange() {
    if (!this.isEditMode) {
      this.selectedItems = [];
    }
  }

  build() {
    // [StartExclude build_list_layouts_and_list_items]
    NavDestination() {
      // [EndExclude build_list_layouts_and_list_items]
      Column(
        // [StartExclude build_list_layouts_and_list_items]
        { space: 12 }
        // [EndExclude build_list_layouts_and_list_items]
      ) {
        // [StartExclude build_list_layouts_and_list_items]
        // 请将$r('app.string.AddListItem_titleExample')替换为实际资源文件，在本示例中该资源文件的value值为"新增列表项示例"
        ComponentCard({ title: $r('app.string.AddListItem_titleExample') }) {
          Column({ space: 12 }) {
            // [EndExclude build_list_layouts_and_list_items]
            Row() {
              if (this.isEditMode) {
                Text('X')
                  .fontSize(20)
                  .onClick(() => {
                    this.isEditMode = false;
                  })
                  .margin({ left: 20, right: 20 })
              } else {
                // app.string.TodoItem 资源文件中的value值为'待办'
                Text($r('app.string.TodoItem'))
                  .fontSize(36)
                  .margin({ left: 40 })
                Blank()
                Text('+')// 提供新增列表项入口，即给新增按钮添加点击事件
                //  [StartExclude build_list_layouts_and_list_items]
                  .fontSize(36)
                  .margin({ right: 20 })
                  // [EndExclude build_list_layouts_and_list_items]
                  .onClick(() => {
                    this.getUIContext().showTextPickerDialog({
                      range: this.availableThings,
                      onAccept: (value: TextPickerResult) => {
                        let arr = Array.isArray(value.index) ? value.index : [value.index];
                        for (let i = 0; i < arr.length; i++) {
                          this.toDoData.push(new ToDo(this.availableThings[arr[i]])); // 新增列表项数据toDoData(可选事项)
                        }
                      },
                    })
                  })
              }
              // [StartExclude build_list_layouts_and_list_items]
            }
            .width('100%')
            .backgroundColor('#FFF1F3F5')
            .borderRadius(12)
            .height(45)

            // [EndExclude build_list_layouts_and_list_items]

            List({ space: 10 }) {
              ForEach(this.toDoData, (toDoItem: ToDo) => {
                ListItem() {
                  // 将toDoData的每个数据放入到以model的形式放进ListItem里
                  ToDoListItem({
                    isEditMode: this.isEditMode,
                    toDoItem: toDoItem,
                    selectedItems: this.selectedItems
                  })
                }
              }, (toDoItem: ToDo) => toDoItem.name.toString())
            }
          }
        }
        // [StartExclude build_list_layouts_and_list_items]
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    // 请将$r('app.string.AddListItem_title')替换为实际资源文件，在本示例中该资源文件的value值为"新增列表项"
    .title($r('app.string.AddListItem_title'))
    // [EndExclude build_list_layouts_and_list_items]
  }
}
// [End build_list_layouts_and_list_items]