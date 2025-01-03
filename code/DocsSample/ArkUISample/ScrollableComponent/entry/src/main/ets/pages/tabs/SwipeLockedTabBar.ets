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
export struct SwipeLockedTabBar {
  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.SwipeLockedTabBar_titleExample') }) {
          Tabs({ barPosition: BarPosition.End }) {
            TabContent() {
              Column() {
                Tabs() {
                  // 顶部导航栏内容
                  TabContent() {
                    Text($r('app.string.FocusOn_content'))
                      .fontSize(30)
                  }
                  .tabBar($r('app.string.FocusOn'))

                  TabContent() {
                    Text($r('app.string.video_content'))
                      .fontSize(30)
                  }
                  .tabBar($r('app.string.video'))

                  TabContent() {
                    Text($r('app.string.game_content'))
                      .fontSize(30)
                  }
                  .tabBar($r('app.string.game'))

                  TabContent() {
                    Text($r('app.string.digit_content'))
                      .fontSize(30)
                  }
                  .tabBar($r('app.string.digit'))

                  TabContent() {
                    Text($r('app.string.technology_content'))
                      .fontSize(30)
                  }
                  .tabBar($r('app.string.technology'))
                }
              }
              .backgroundColor('#ffffc6d1')
              .width('100%')
            }
            .tabBar($r('app.string.homepage'))

            TabContent() {
              Text($r('app.string.recommend_content'))
                .fontSize(30)
            }
            .backgroundColor(Color.Green)
            .tabBar($r('app.string.recommend'))

            TabContent() {
              Text($r('app.string.discover_content'))
                .fontSize(30)
            }
            .backgroundColor(Color.Yellow)
            .tabBar($r('app.string.discover'))

            TabContent() {
              Text($r('app.string.mine_content'))
                .fontSize(30)
            }
            .backgroundColor(Color.Orange)
            .tabBar($r('app.string.mine'))
          }
          .height(500)
          .scrollable(false)
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.SwipeLockedTabBar_title'))
  }
}