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

// [Start build_the_overall_list_layout_and_list_items]
import { ToDo } from './ToDo';

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
    // [StartExclude build_the_overall_list_layout_and_list_items]
    .backgroundColor('#FFF1F3F5')
    // [EndExclude build_the_overall_list_layout_and_list_items]
    .width('100%')
    .height(80)
    // .padding() 根据具体使用场景设置
    .borderRadius(24)
    // .linearGradient() 根据具体使用场景设置
    .gesture(
      GestureGroup(GestureMode.Exclusive,
        LongPressGesture()
          .onAction(() => {
          })
      )
    )
  }
}
// [End build_the_overall_list_layout_and_list_items]