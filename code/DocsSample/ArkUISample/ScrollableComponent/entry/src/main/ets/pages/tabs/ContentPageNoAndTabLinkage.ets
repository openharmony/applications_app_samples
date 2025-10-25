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
// [Start ContentPageNoAndTabLinkage]
import { ComponentCard } from '../../common/Card';
@Entry
@Component
export struct ContentPageNoAndTabLinkage {

  @State selectIndex: number = 0;
  @Builder tabBuilder(title: string, targetIndex: number) {
    Column() {
      Text(title)
        .fontColor(this.selectIndex === targetIndex ? '#1698CE' : '#6B6B6B')
    }
  }
  build() {
    NavDestination() {
      Column({ space: 12 }) {
        // $r('app.string.ContentWillChange_titleContentOnAndTabSync')需要替换为开发者所需的字符串（图像、数字等）资源文件
        ComponentCard({ title: $r('app.string.ContentWillChange_titleContentOnAndTabSync') }) {
          // [Start bottom_navigation]
          Tabs({ barPosition: BarPosition.End }) {
            TabContent() {
              Text($r('app.string.homepage_content')).width('100%').height('100%').backgroundColor('rgb(213,213,213)')
                .fontSize(40).fontColor(Color.Black).textAlign(TextAlign.Center)
            }.tabBar(this.tabBuilder($r('app.string.homepage'), 0))

            TabContent() {
              Text($r('app.string.discover_content')).width('100%').height('100%').backgroundColor('rgb(112,112,112)')
                .fontSize(40).fontColor(Color.Black).textAlign(TextAlign.Center)
            }.tabBar(this.tabBuilder($r('app.string.discover'), 1))

            TabContent() {
              Text($r('app.string.recommend')).width('100%').height('100%').backgroundColor('rgb(39,135,217)')
                .fontSize(40).fontColor(Color.Black).textAlign(TextAlign.Center)
            }.tabBar(this.tabBuilder($r('app.string.recommend_content'), 2))

            TabContent() {
              Text($r('app.string.mine_content')).width('100%').height('100%').backgroundColor('rgb(0,74,175)')
                .fontSize(40).fontColor(Color.Black).textAlign(TextAlign.Center)
            }.tabBar(this.tabBuilder($r('app.string.mine'), 3))
          }
          .animationDuration(0)
          .backgroundColor('#F1F3F5')
          .onSelected((index: number) => {
            this.selectIndex = index;
          })
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.ContentWillChange_titleContentOnAndTabSync'))
  }
}
// [End ContentPageNoAndTabLinkage]