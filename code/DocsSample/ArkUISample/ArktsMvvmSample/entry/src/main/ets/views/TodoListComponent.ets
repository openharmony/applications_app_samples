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

// [Start to_do_list_component_view]
import ThingViewModel from '../viewmodel/ThingViewModel';
import { ThingViewModelArray } from '../viewmodel/TodoListViewModel'
import { ThingComponent } from './ThingComponent';

@Component
export struct TodoListComponent {
  @ObjectLink thingViewModelArray: ThingViewModelArray;

  build() {
    Column() {
      List() {
        ForEach(this.thingViewModelArray, (item: ThingViewModel) => {
          // 待办事项
          ListItem() {
            ThingComponent({ thing: item })
              .margin(5)
          }
        }, (item: ThingViewModel) => {
          return item.thingName;
        })
      }
    }
  }
}
// [End to_do_list_component_view]