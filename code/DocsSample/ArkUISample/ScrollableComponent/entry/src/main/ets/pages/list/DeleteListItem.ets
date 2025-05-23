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

import { util } from '@kit.ArkTS';

// [Start structural_references]
export class ToDo {
  public key: string = util.generateRandomUUID(true);
  public name: string;

  constructor(name: string) {
    this.name = name;
  }
}
// [End structural_references]

@Component
export struct ToDoListItem {
  @Link isEditMode: boolean;
  @Link selectedItems: ToDo[];
  private toDoItem: ToDo = new ToDo('');

  build() {
    // [Start enter_edit_mode]
    Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      // [StartExclude enter_edit_mode]
      Text(this.toDoItem.name)
        .fontSize(16)
        .width('80%')
        .margin({ left: 20 })
      if (this.isEditMode) {
        Checkbox()
          .onChange((value: boolean) => {
            if (value) {
              this.selectedItems.push(new ToDo(this.toDoItem.name));
              this.isEditMode = true;
            }
          })
      }
    }
    .backgroundColor('#FFF1F3F5')
    .width('100%')
    .height(40)
    .borderRadius(12)
    // [EndExclude enter_edit_mode]
    .gesture(
      GestureGroup(GestureMode.Exclusive,
        LongPressGesture()
          .onAction(() => {
            this.isEditMode = true;
          })
      )
    )
  }
}
// [End enter_edit_mode]

@Entry
@Component
export struct DeleteListItem {
  @State arr: number[] = [0, 1, 2, 3];
  @State toDoData: ToDo[] = [];
  @Watch('onEditModeChange') @State isEditMode: boolean = false;
  @State selectedItems: ToDo[] = [];
  private availableThings: string[] = ['Reading', 'Exercise', 'Travel', 'Listening Music', 'Watching Films', 'Singing'];

  public deleteToDoData() {
    this.toDoData = [];
  }

  onEditModeChange() {
    if (!this.isEditMode) {
      this.selectedItems = [];
    }
  }

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        Column({ space: 8 }) {
          Text($r('app.string.DeleteListItem_titleExample'))
            .fontSize(14)
            .fontColor('#666')
          Column({ space: 10 }) {
            Row() {
              if (this.isEditMode) {
                Text('X')
                  .fontSize(20)
                  .onClick(() => {
                    this.isEditMode = false;
                  })
                  .margin({ left: 20, right: 20 })
              } else {
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
            .width('100%')
            .backgroundColor('#FFF1F3F5')
            .borderRadius(12)
            .height(45)

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
        .alignItems(HorizontalAlign.Start)
        .backgroundColor('#fff')
        .borderRadius(12)
        .padding(12)
        .width('100%')

        if (this.isEditMode) {
          Column({ space: 8 }) {
            // [Start implement_deletion]
            Button('delete')
              .width('90%')
              .backgroundColor(Color.Red)
              .onClick(() => {
                this.toDoData = this.toDoData.filter(toDoItem =>
                !this.selectedItems.some(selectedItem => selectedItem.name === toDoItem.name));
                this.isEditMode = false;
              })
          }
        }
      }
      // [End implement_deletion]
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.DeleteListItem_title'))
  }
}