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
          List({ space: 8 }) {
            ListItem() {
              Text('ListItem one')
            }

            ListItem() {
              Text('ListItem two')
            }
          }
          .listDirection(Axis.Horizontal)
          .height(30)
        }

        ComponentCard({ title: $r('app.string.ListLayout_titleCrossAxisLanes') }) {
          List({ space: 8 }) {
            ListItem() {
              Text('ListItem one')
            }

            ListItem() {
              Text('ListItem two')
            }

            ListItem() {
              Text('ListItem tree')
            }
          }
          // 此处lanes设置主轴方向
          .lanes(this.egLanes)
        }

        ComponentCard({ title: $r('app.string.ListLayout_titleCrossAxisAlignment') }) {
          List({ space: 8 }) {
            ListItem() {
              Text('ListItem one')
            }

            ListItem() {
              Text('ListItem two')
            }

            ListItem() {
              Text('ListItem tree')
            }
          }
          // 此处alignListItem设置水平方向对齐
          .alignListItem(ListItemAlign.Center)
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