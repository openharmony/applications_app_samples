/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import Home from '../common/home'
import TabBarItem from '../common/TabBarItem'
import BreakpointSystem from '../model/BreakpointSystem'

@Entry
@Component
struct Index {
  @State currentIndex: number = 0
  @StorageProp('currentBreakpoint') currentBreakpoint: string = 'md'
  private breakpointSystem: BreakpointSystem = new BreakpointSystem()
  private onTabChange = (index: number) => {
    this.currentIndex = index
  }

  aboutToAppear() {
    this.breakpointSystem.register()
  }

  aboutToDisappear() {
    this.breakpointSystem.unregister()
  }

  @Builder
  tabItem0() {
    TabBarItem({
      index: 0,
      currentIndex: this.currentIndex,
      title: $r('app.string.tabBar0'),
      icon: $r("app.media.ic_home_normal"),
      iconSelected: $r("app.media.ic_home_actived"),
    })
  }

  @Builder
  tabItem1() {
    TabBarItem({
      index: 1,
      currentIndex: this.currentIndex,
      title: $r('app.string.tabBar1'),
      icon: $r("app.media.ic_app_normal"),
      iconSelected: $r("app.media.ic_app_actived"),
    })
  }

  @Builder
  tabItem2() {
    TabBarItem({
      index: 2,
      currentIndex: this.currentIndex,
      title: $r('app.string.tabBar2'),
      icon: $r("app.media.ic_game_normal"),
      iconSelected: $r("app.media.ic_game_actived"),
    })
  }

  @Builder
  tabItem3() {
    TabBarItem({
      index: 3,
      currentIndex: this.currentIndex,
      title: $r('app.string.tabBar3'),
      icon: $r("app.media.ic_search_normal"),
      iconSelected: $r("app.media.ic_search_actived"),
    })
  }

  @Builder
  tabItem4() {
    TabBarItem({
      index: 4,
      currentIndex: this.currentIndex,
      title: $r('app.string.tabBar4'),
      icon: $r("app.media.ic_mine_normal"),
      iconSelected: $r("app.media.ic_mine_actived"),
    })
  }

  @Builder
  tabItem(index: number, title: Resource, icon: Resource, iconSelected: Resource) {
    TabBarItem({
      index: index,
      currentIndex: this.currentIndex,
      title: title,
      icon: icon,
      iconSelected: iconSelected,
    })
  }

  build() {
    Tabs({ barPosition: this.currentBreakpoint === 'lg' ? BarPosition.Start : BarPosition.End }) {
      TabContent() {
        Home()
      }.tabBar(this.tabItem0)

      TabContent() {
      }.tabBar(this.tabItem1)

      TabContent() {
      }.tabBar(this.tabItem2)

      TabContent() {
      }.tabBar(this.tabItem3)

      TabContent() {
      }.tabBar(this.tabItem4)
    }
    .barWidth(this.currentBreakpoint === 'lg' ? 96 : '100%')
    .barHeight(this.currentBreakpoint === 'lg' ? '60%' : 56)
    .vertical(this.currentBreakpoint === 'lg')
    .onChange(this.onTabChange)
    .backgroundColor('#F1F3F5')
  }
}
