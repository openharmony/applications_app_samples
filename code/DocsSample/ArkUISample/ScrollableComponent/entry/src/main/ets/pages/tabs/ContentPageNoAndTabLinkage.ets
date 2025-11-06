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
// [Start content_page_tab_linkage]
@Entry
@Component
export struct ContentPageNoAndTabLinkage {

  @State selectIndex: number = 0;
  @Builder tabBuilder(title: Resource, targetIndex: number) {
    Column() {
      Text(title)
        .fontColor(this.selectIndex === targetIndex ? '#1698CE' : '#6B6B6B')
    }
  }
  build() {
    NavDestination() {
      Column({ space: 12 }) {
        // [StartExclude content_page_tab_linkage]
        ComponentCard({ title: $r('app.string.ContentWillChange_titleContentOnAndTabSync') }) {
        // [EndExclude content_page_tab_linkage]
          Tabs({ barPosition: BarPosition.End }) {
            TabContent() {
              // app.string.homepage_content资源文件中的value值为‘首页内容’
              Text($r('app.string.homepage_content')).width('100%').height('100%').backgroundColor('rgb(213,213,213)')
                .fontSize(40).fontColor(Color.Black).textAlign(TextAlign.Center)
            //app.string.homepage资源文件中的value值为‘首页’
            }.tabBar(this.tabBuilder($r('app.string.homepage'), 0))

            TabContent() {
              // app.string.discover_content资源文件中的value值为‘发现内容’
              Text($r('app.string.discover_content')).width('100%').height('100%').backgroundColor('rgb(112,112,112)')
                .fontSize(40).fontColor(Color.Black).textAlign(TextAlign.Center)
            // app.string.discover资源文件中的value值为‘发现’
            }.tabBar(this.tabBuilder($r('app.string.discover'), 1))

            TabContent() {
              // app.string.recommend_content资源文件中的value值为‘推荐内容’
              Text($r('app.string.recommend_content')).width('100%').height('100%').backgroundColor('rgb(39,135,217)')
                .fontSize(40).fontColor(Color.Black).textAlign(TextAlign.Center)
            // app.string.recommend资源文件中的value值为‘推荐’
            }.tabBar(this.tabBuilder($r('app.string.recommend'), 2))

            // [Start set_custom_tab_bar_style]
            TabContent() {
              // app.string.mine_content资源文件中的value值为‘我的内容’
              Text($r('app.string.mine_content')).width('100%').height('100%').backgroundColor('rgb(0,74,175)')
                // [StartExclude set_custom_tab_bar_style]
                .fontSize(40).fontColor(Color.Black).textAlign(TextAlign.Center)
                // [EndExclude set_custom_tab_bar_style]
            // app.string.mine资源文件中的value值为‘我的’
            }.tabBar(this.tabBuilder($r('app.string.mine'), 3))
            // [End set_custom_tab_bar_style]
          }
          .animationDuration(0)
          .backgroundColor('#F1F3F5')
          .onSelected((index: number) => {
            this.selectIndex = index;
          })
        // [StartExclude content_page_tab_linkage]
        }
        // [EndExclude content_page_tab_linkage]
      }
      .width('100%')
      // [StartExclude content_page_tab_linkage]
      .height('100%')
      .padding({ left: 12, right: 12 })
      // [EndExclude content_page_tab_linkage]
    }
    // [StartExclude content_page_tab_linkage]
    .backgroundColor('#f1f2f3')
    .title($r('app.string.ContentWillChange_titleContentOnAndTabSync'))
    // [EndExclude content_page_tab_linkage]
  }
}
// [End content_page_tab_linkage]