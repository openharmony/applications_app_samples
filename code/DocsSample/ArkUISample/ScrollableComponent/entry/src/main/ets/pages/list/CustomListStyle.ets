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

// [Start set_the_divider]
class DividerTmp {
  public strokeWidth: Length = 1;
  public startMargin: Length = 60;
  public endMargin: Length = 10;
  public color: ResourceColor = '#ffe9f0f0';

  constructor(strokeWidth: Length, startMargin: Length, endMargin: Length, color: ResourceColor) {
    this.strokeWidth = strokeWidth;
    this.startMargin = startMargin;
    this.endMargin = endMargin;
    this.color = color;
  }
}

@Entry
@Component
export struct CustomListStyle {
  @State egDivider: DividerTmp = new DividerTmp(1, 60, 10, '#ffe9f0f0');

  build() {
    // [StartExclude set_the_divider]
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.CustomListStyle_titleContentSpacing') }) {
          // [Start set_space]
          List({ space: 10 }) {
            // [StartExclude set_space]
            ListItem() {
              Text('ListItem One')
            }

            ListItem() {
              Text('ListItem Two')
            }
            // [EndExclude set_space]
          }
          // [End set_space]
          .backgroundColor('#FFF1F3F5')
          .alignListItem(ListItemAlign.Center)
        }

        ComponentCard({ title: $r('app.string.CustomListStyle_titleDividerLines') }) {
          // [EndExclude set_the_divider]
          List(
            // [StartExclude set_the_divider]
            { space: 10 }
            // [EndExclude set_the_divider]
          ) {
            // [StartExclude set_the_divider]
            ListItem() {
              Text('ListItem One')
            }

            ListItem() {
              Text('ListItem Two')
            }
            // [EndExclude set_the_divider]
          }
          .divider(this.egDivider)
          // [StartExclude set_the_divider]
          .alignListItem(ListItemAlign.Center)
        }

        ComponentCard({ title: $r('app.string.CustomListStyle_titleScrollbars') }) {
          // [Start add_a_scrollbar]
          List(
            // [StartExclude add_a_scrollbar]
            { space: 10 }
            // [EndExclude add_a_scrollbar]
          ) {
            // [StartExclude add_a_scrollbar]
            ListItem() {
              Text('ListItem One')
            }.height(30)

            ListItem() {
              Text('ListItem Two')
            }.height(30)

            ListItem() {
              Text('ListItem Three')
            }.height(30)
            // [EndExclude add_a_scrollbar]
          }
          // [StartExclude add_a_scrollbar]
          .height(60)
          // [EndExclude add_a_scrollbar]
          .scrollBar(BarState.Auto)
          // [End add_a_scrollbar]
          .backgroundColor('#FFF1F3F5')
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.CustomListStyle_title'))
    // [EndExclude set_the_divider]
  }
}
// [End set_the_divider]