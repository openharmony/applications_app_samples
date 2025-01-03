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
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.CustomListStyle_titleContentSpacing') }) {
          List({ space: 10 }) {
            ListItem() {
              Text('ListItem One')
            }

            ListItem() {
              Text('ListItem Two')
            }
          }
          .backgroundColor('#FFF1F3F5')
          .alignListItem(ListItemAlign.Center)
        }

        ComponentCard({ title: $r('app.string.CustomListStyle_titleDividerLines') }) {
          List({ space: 10 }) {
            ListItem() {
              Text('ListItem One')
            }

            ListItem() {
              Text('ListItem Two')
            }
          }
          .divider(this.egDivider)
          .alignListItem(ListItemAlign.Center)
        }

        ComponentCard({ title: $r('app.string.CustomListStyle_titleScrollbars') }) {
          List({ space: 10 }) {
            ListItem() {
              Text('ListItem One')
            }.height(30)

            ListItem() {
              Text('ListItem Two')
            }.height(30)

            ListItem() {
              Text('ListItem Three')
            }.height(30)
          }
          .height(60)
          .scrollBar(BarState.Auto)
          .backgroundColor('#FFF1F3F5')
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.CustomListStyle_title'))
  }
}