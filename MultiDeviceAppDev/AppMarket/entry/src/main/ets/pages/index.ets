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

import Home from "../components/home"
import TabBarItem from "../components/TabBarItem"
import mediaQuery from '@ohos.mediaquery'

@Entry
@Component
struct Index {
  @State currentIndex: number = 0
  @State currentBreakpoint: string = "sm"
  private smListener: any
  private mdListener: any
  private lgListener: any
  private onTabChange = (index: number) => {
    this.currentIndex = index
  }
  private isBreakpointSM = (mediaQueryResult: mediaQuery.MediaQueryResult) => {
    if (mediaQueryResult.matches) {
      this.currentBreakpoint = "sm"
    }
  }
  private isBreakpointMD = (mediaQueryResult: mediaQuery.MediaQueryResult) => {
    if (mediaQueryResult.matches) {
      this.currentBreakpoint = "md"
    }
  }
  private isBreakpointLG = (mediaQueryResult: mediaQuery.MediaQueryResult) => {
    if (mediaQueryResult.matches) {
      this.currentBreakpoint = "lg"
    }
  }

  aboutToAppear() {
    this.smListener = mediaQuery.matchMediaSync("(320vp<width<520vp)")
    this.smListener.on("change", this.isBreakpointSM)
    this.mdListener = mediaQuery.matchMediaSync("(520vp<width<840vp)")
    this.mdListener.on("change", this.isBreakpointMD)
    this.lgListener = mediaQuery.matchMediaSync("(840vp<width)")
    this.lgListener.on("change", this.isBreakpointLG)
  }

  aboutToDisappear() {
    this.smListener.off("change", this.isBreakpointSM)
    this.mdListener.off("change", this.isBreakpointMD)
    this.lgListener.off("change", this.isBreakpointLG)
  }

  @Builder
  tabItem(currentBreakpoint: any, isSelected: number, title: Resource, icon: Resource, iconSelected: Resource) {
    TabBarItem({
      currentBreakpoint: currentBreakpoint as string,
      isSelected: isSelected === 4,
      title: title,
      icon: icon,
      iconSelected: iconSelected,
    })
  }

  build() {
    Tabs({ barPosition: this.currentBreakpoint === "lg" ? BarPosition.Start : BarPosition.End }) {
      TabContent() {
        Home({ currentBreakpoint: this.currentBreakpoint })
      }
      .tabBar(this.tabItem(this.currentBreakpoint, this.currentIndex, $r('app.string.tabBar1'), $r("app.media.ic_home_normal"), $r("app.media.ic_home_actived")))

      TabContent() {
      }
      .tabBar(this.tabItem(this.currentBreakpoint, this.currentIndex, $r('app.string.tabBar2'), $r("app.media.ic_app_normal"), $r("app.media.ic_app_actived")))

      TabContent() {
      }
      .tabBar(this.tabItem(this.currentBreakpoint, this.currentIndex, $r('app.string.tabBar3'), $r("app.media.ic_game_normal"), $r("app.media.ic_mine_actived")))

      TabContent() {
      }
      .tabBar(this.tabItem(this.currentBreakpoint, this.currentIndex, $r('app.string.tabBar4'), $r("app.media.ic_search_normal"), $r("app.media.ic_search_actived")))

      TabContent() {
      }
      .tabBar(this.tabItem(this.currentBreakpoint, this.currentIndex, $r('app.string.tabBar5'), $r("app.media.ic_mine_normal"), $r("app.media.ic_mine_actived")))
    }
    .backgroundColor('#F1F3F5')
    .barMode(BarMode.Fixed)
    .barWidth(this.currentBreakpoint === "lg" ? 96 : '100%')
    .barHeight(this.currentBreakpoint === "lg" ? '60%' : 56)
    .animationDuration(600)
    .vertical(this.currentBreakpoint === "lg")
    .onChange(this.onTabChange)
  }
}
