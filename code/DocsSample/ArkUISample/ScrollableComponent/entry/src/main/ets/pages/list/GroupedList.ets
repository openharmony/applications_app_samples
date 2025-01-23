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

@Entry
@Component
export struct GroupedList {
  @Builder
  itemHead(text: string) {
    // 列表分组的头部组件，对应联系人分组A、B等位置的组件
    Text(text)
      .fontSize(20)
      .backgroundColor('#fff1f3f5')
      .width('100%')
      .padding(5)
  }

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.GroupedList_titleExample') }) {
          List({ space: 12 }) {
            ListItemGroup({ header: this.itemHead('A') }) {
              // 循环渲染分组A的ListItem
              ListItem() {
                Text('ListItem A One')
              }

              ListItem() {
                Text('ListItem A Two')
              }
            }

            ListItemGroup({ header: this.itemHead('B') }) {
              // 循环渲染分组B的ListItem
              ListItem() {
                Text('ListItem B One')
              }

              ListItem() {
                Text('ListItem B Two')
              }
            }
          }
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.GroupedList_title'))
  }
}