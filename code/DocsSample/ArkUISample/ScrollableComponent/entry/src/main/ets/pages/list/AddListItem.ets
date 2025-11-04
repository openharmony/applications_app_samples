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
// [Start define_the_data_to_be_done]
import { util } from '@kit.ArkTS';
import { UIContext } from '@kit.ArkUI';
// [Start build_list_layouts_and_list_items]
import common from '@ohos.app.ability.common';

// [StartExclude build_list_layouts_and_list_items]
// [Start build_the_overall_list_layout_and_list_items]
export class ToDo {
  public key: string = util.generateRandomUUID(true);
  public name: string;

  constructor(name: string) {
    this.name = name;
  }
}
// [End define_the_data_to_be_done]

@Component
export struct ToDoListItem {
  @Link isEditMode: boolean;
  @Link selectedItems: ToDo[];
  private toDoItem: ToDo = new ToDo('');

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      // [StartExclude build_the_overall_list_layout_and_list_items]
      Text(this.toDoItem.name)
        .fontSize(16)
        .width('80%')
        .margin({ left: 20 })
      // [EndExclude build_the_overall_list_layout_and_list_items]
    }
    .backgroundColor('#FFF1F3F5')
    .width('100%')
    .height(40)
    // .padding() 根据具体使用场景设置
    .borderRadius(12)
    // .linearGradient() 根据具体使用场景设置
    .gesture(
      // [StartExclude build_the_overall_list_layout_and_list_items]
      GestureGroup(GestureMode.Exclusive,
        LongPressGesture()
        // [EndExclude build_the_overall_list_layout_and_list_items]
          .onAction(() => {
          })
      )
    )
  }
}

// [End build_the_overall_list_layout_and_list_items]
// [EndExclude build_list_layouts_and_list_items]
@Entry
@Component
export struct AddListItem {
  private l1 = 0;
  private l2 = 0;
  // [StartExclude build_list_layouts_and_list_items]
  @State arr: number[] = [0, 1, 2, 3]
  @State toDoData: ToDo[] = []
  // [EndExclude build_list_layouts_and_list_items]
  @Watch('onEditModeChange') @State isEditMode: boolean = false
  @State selectedItems: ToDo[] = []
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
      Column({ space: 12 }) {
        // [StartExclude build_list_layouts_and_list_items]
        // $r('app.string.AddListItem_titleExample')需要替换为开发者所需的资源文件
        ComponentCard({ title: $r('app.string.AddListItem_titleExample') }) {
          // [EndExclude build_list_layouts_and_list_items]
          Column({ space: 12 }) {
            Row() {
              if (this.isEditMode) {
                Text('X')
                  .fontSize(20)
                  .onClick(() => {
                    this.isEditMode = false;
                  })
                  .margin({ left: 20, right: 20 })
              } else {
                // $r('app.string.TodoItem')需要替换为开发者所需的资源文件
                Text($r('app.string.TodoItem'))
                  .fontSize(30)
                  .margin({ left: 20 })
                Blank()
                Text('+')// 提供新增列表项入口，即给新增按钮添加点击事件
                  .fontSize(36)
                  .margin({ right: 20 })
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
            }
            // [StartExclude build_list_layouts_and_list_items]
            .width('100%')
            .backgroundColor('#FFF1F3F5')
            .borderRadius(12)
            .height(45)

            // [EndExclude build_list_layouts_and_list_items]

            List({ space: 12 }) {
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
      }
      // [End build_list_layouts_and_list_items]
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.AddListItem_title'))
  }
}