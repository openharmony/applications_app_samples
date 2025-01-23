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
export struct TaggedListItems {
  @State arr: number[] = [0, 1, 2, 3];

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.TaggedListItems_titleExample') }) {
          List() {
            ForEach(this.arr, (item: number) => {
              ListItem() {
                // Badge组件实现消息右上角添加标记功能
                Badge({
                  count: 1,
                  position: BadgePosition.RightTop,
                  style: { badgeSize: 16, badgeColor: '#FA2A2D' }
                }) {
                  Text('消息' + item)
                    .width('95%')
                    .height(50)
                    .fontSize(16)
                    .textAlign(TextAlign.Center)
                    .borderRadius(10)
                    .backgroundColor('#FFF1F3F5')
                }
              }.margin({ top: 12 })
            }, (item: number) => item.toString())
          }
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.TaggedListItems_title'))
  }
}