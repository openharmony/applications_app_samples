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

import Home from '../common/Home'
import TabBarItem from '../common/TabBarItem'
import BreakpointSystem from '../common/BreakpointSystem'

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
  tabItem(index: number, title: Resource, icon: Resource, iconSelected: Resource) {
    TabBarItem({
      index: index,
      currentIndex: this.currentIndex,
      title: title,
      icon: icon,
      iconSelected: iconSelected
    })
  }

  build() {
    Tabs({ barPosition: this.currentBreakpoint === 'lg' ? BarPosition.Start : BarPosition.End }) {
      TabContent() {
        Home()
      }
      .tabBar(this.tabItem(0, $r('app.string.tabBar1'), $r('app.media.ic_home_normal'), $r('app.media.ic_home_actived')))

      TabContent() {
      }
      .tabBar(this.tabItem(1, $r('app.string.tabBar2'), $r('app.media.ic_app_normal'), $r('app.media.ic_app_actived')))

      TabContent() {
      }
      .tabBar(this.tabItem(2, $r('app.string.tabBar3'), $r('app.media.ic_game_normal'), $r('app.media.ic_mine_actived')))

      TabContent() {
      }
      .tabBar(this.tabItem(3, $r('app.string.tabBar4'), $r('app.media.ic_search_normal'), $r('app.media.ic_search_actived')))

      TabContent() {
      }
      .tabBar(this.tabItem(4, $r('app.string.tabBar4'), $r('app.media.ic_mine_normal'), $r('app.media.ic_mine_actived')))
    }
    .barWidth(this.currentBreakpoint === 'lg' ? 96 : '100%')
    .barHeight(this.currentBreakpoint === 'lg' ? '60%' : 56)
    .vertical(this.currentBreakpoint === 'lg')
    .onChange(this.onTabChange)
    .backgroundColor('#F1F3F5')
  }
}
