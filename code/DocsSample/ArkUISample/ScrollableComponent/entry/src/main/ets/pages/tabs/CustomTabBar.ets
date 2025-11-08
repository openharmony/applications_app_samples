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
export struct CustomTabBar {
  // [Start custom_tab_bar_style]
  @State currentIndex: number = 0;

  @Builder
  tabBuilder(title: ResourceStr, targetIndex: number, selectedImg: Resource, normalImg: Resource) {
    Column() {
      Image(this.currentIndex === targetIndex ? selectedImg : normalImg)
        .size({ width: 25, height: 25 })
      Text(title)
        .fontColor(this.currentIndex === targetIndex ? '#1698CE' : '#6B6B6B')
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
  }
  // [End custom_tab_bar_style]

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.CustomTabBar_titleExample') }) {
          Tabs({ barPosition: BarPosition.End }) {
            // [Start set_custom_tab_bar_style]
            TabContent() {
              Column() {
                // app.string.mine_content资源文件中的value值为“我的内容”
                Text($r('app.string.mine_content'))  
              }
              .width('100%')
              .height('100%')
              .backgroundColor('#007DFF')
            }
            // app.string.mine资源文件中的value值为“我的”
            .tabBar(this.tabBuilder($r('app.string.mine'), 0, $r('app.media.mine_selected'), $r('app.media.mine_normal')))
            // [End set_custom_tab_bar_style]
            TabContent() {
              Text($r('app.string.internet_content'))
                .fontSize(30)
            }
            .backgroundColor(Color.Blue)
            .tabBar(this.tabBuilder($r('app.string.internet'),
              1,
              $r('sys.media.ohos_ic_public_web'),
              $r('sys.media.ohos_ic_public_web')))

            TabContent() {
              Text($r('app.string.album_content'))
                .fontSize(30)
            }
            .backgroundColor(Color.Green)
            .tabBar(this.tabBuilder($r('app.string.album'),
              2,
              $r('sys.media.ohos_ic_public_albums'),
              $r('sys.media.ohos_ic_public_albums')))

            TabContent() {
              Text($r('app.string.video_content'))
                .fontSize(30)
            }
            .backgroundColor(Color.Yellow)
            .tabBar(this.tabBuilder($r('app.string.video'),
              3,
              $r('sys.media.ohos_ic_public_video'),
              $r('sys.media.ohos_ic_public_video')))

            TabContent() {
              Text($r('app.string.more_content'))
                .fontSize(30)
            }
            .backgroundColor(Color.Orange)
            .tabBar(this.tabBuilder($r('app.string.more'),
              4,
              $r('sys.media.ohos_ic_public_drawer_open'),
              $r('sys.media.ohos_ic_public_drawer_open')))
          }
          .height(500)
          .onChange((index: number) => {
            this.currentIndex = index; // 监听索引index的变化，实现页签内容的切换。
          })
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.CustomTabBar_title'))
  }
}