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
export struct ScrollableTabBar {
  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.ScrollableTabBar_titleExample') }) {
          // [Start scrollable_tab_bar]
          Tabs({ barPosition: BarPosition.Start  }) {
            // [StartExclude scrollable_tab_bar]
            TabContent() {
              Text($r('app.string.FocusOn_content'))
                .fontSize(30)
            }
            .backgroundColor(Color.Blue)
            .tabBar($r('app.string.FocusOn'))

            TabContent() {
              Text($r('app.string.video_content'))
                .fontSize(30)
            }
            .backgroundColor(Color.Green)
            .tabBar($r('app.string.video'))

            TabContent() {
              Text($r('app.string.game_content'))
                .fontSize(30)
            }
            .backgroundColor(Color.Yellow)
            .tabBar($r('app.string.game'))

            TabContent() {
              Text($r('app.string.digit_content'))
                .fontSize(30)
            }
            .backgroundColor(Color.Orange)
            .tabBar($r('app.string.digit'))

            TabContent() {
              Text($r('app.string.technology_content'))
                .fontSize(30)
            }
            .backgroundColor(Color.Pink)
            .tabBar($r('app.string.technology'))

            TabContent() {
              Text($r('app.string.sport_content'))
                .fontSize(30)
            }
            .backgroundColor(Color.Gray)
            .tabBar($r('app.string.sport'))

            TabContent() {
              Text($r('app.string.film_content'))
                .fontSize(30)
            }
            .backgroundColor(Color.Brown)
            .tabBar($r('app.string.film'))

            TabContent() {
              Text($r('app.string.humanities_content'))
                .fontSize(30)
            }
            .backgroundColor(Color.Red)
            .tabBar($r('app.string.humanities'))
            // [EndExclude scrollable_tab_bar]
          }
          // [StartExclude scrollable_tab_bar]
          .barWidth(250)
          .height(500)
          // [EndExclude scrollable_tab_bar]
          .barMode(BarMode.Scrollable)
          // [End scrollable_tab_bar]
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.ScrollableTabBar_title'))
  }
}