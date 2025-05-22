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
export struct ListLayout {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.ListLayout_titleMainAxis') }) {
          // [Start build_a_horizontal_scrolling_list]
          List({ space: 8 }) {
            // [StartExclude build_a_horizontal_scrolling_list]
            ListItem() {
              Text('ListItem one')
            }

            ListItem() {
              Text('ListItem two')
            }
            // [EndExclude build_a_horizontal_scrolling_list]
          }
          .listDirection(Axis.Horizontal)
          // [End build_a_horizontal_scrolling_list]
          .height(30)
        }

        ComponentCard({ title: $r('app.string.ListLayout_titleCrossAxisLanes') }) {
          // [Start build_list_by_size]
          List({ space: 8 }) {
            ListItem() {
              // [StartExclude build_list_by_size]
              Text('ListItem one')
            }

            ListItem() {
              Text('ListItem two')
            }

            ListItem() {
              Text('ListItem tree')
            }
            // [EndExclude build_list_by_size]
          }
          // 此处lanes设置主轴方向
          .lanes(this.egLanes)
          // [End build_list_by_size]
        }

        ComponentCard({ title: $r('app.string.ListLayout_titleCrossAxisAlignment') }) {
          // [Start build_list_with_align_horizontally_in_the_center]
          List({ space: 8 }) {
            // [StartExclude build_list_with_align_horizontally_in_the_center]
            ListItem() {
              Text('ListItem one')
            }

            ListItem() {
              Text('ListItem two')
            }

            ListItem() {
              Text('ListItem tree')
            }
            // [EndExclude build_list_with_align_horizontally_in_the_center]
          }
          // 此处alignListItem设置水平方向对齐
          .alignListItem(ListItemAlign.Center)
          // [End build_list_with_align_horizontally_in_the_center]
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.ListLayout_title'))
  }
}