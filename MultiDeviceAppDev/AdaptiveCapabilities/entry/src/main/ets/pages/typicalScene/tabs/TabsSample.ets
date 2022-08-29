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

import { BreakpointSystem, BreakPointType } from 'common/BreakpointSystem'

type TabBar = {
  name: string
  icon: Resource
  selectIcon: Resource
}

@Entry
@Component
struct Home {
  @State currentIndex: number = 0
  @State tabs: Array<TabBar> = [{
                                  name: '首页',
                                  icon: $r('app.media.ic_music_home'),
                                  selectIcon: $r('app.media.ic_music_home_selected')
                                }, {
                                  name: '排行榜',
                                  icon: $r('app.media.ic_music_ranking'),
                                  selectIcon: $r('app.media.ic_music_ranking_selected')
                                }, {
                                  name: '我的',
                                  icon: $r('app.media.ic_music_me_nor'),
                                  selectIcon: $r('app.media.ic_music_me_selected')
                                }]

  @Builder TabBarBuilder(index: number, tabBar: TabBar) {
    Flex({
      direction: new BreakPointType({
        sm: FlexDirection.Column,
        md: FlexDirection.Row,
        lg: FlexDirection.Column
      }).GetValue(this.currentBreakpoint),
      justifyContent: FlexAlign.Center,
      alignItems: ItemAlign.Center
    }) {
      Image(this.currentIndex === index ? tabBar.selectIcon : tabBar.icon)
        .size({ width: 36, height: 36 })
      Text(tabBar.name)
        .fontColor(this.currentIndex === index ? '#FF1948' : '#999')
        .margin(new BreakPointType({
          sm: { top: 4 },
          md: { left: 8 },
          lg: { top: 4 } }).GetValue(this.currentBreakpoint))
        .fontSize(16)
    }
    .width('100%')
    .height('100%')
  }

  @StorageLink('currentBreakpoint') currentBreakpoint: string = 'md'
  private breakpointSystem: BreakpointSystem = new BreakpointSystem()

  aboutToAppear() {
    this.breakpointSystem.register()
  }

  aboutToDisappear() {
    this.breakpointSystem.unregister()
  }

  build() {
    Tabs({
      barPosition: new BreakPointType({
        sm: BarPosition.End,
        md: BarPosition.End,
        lg: BarPosition.Start
      }).GetValue(this.currentBreakpoint)
    }) {
      ForEach(this.tabs, (item, index) => {
        TabContent() {
          Stack() {
            Text(item.name).fontSize(30)
          }.width('100%').height('100%')
        }.tabBar(this.TabBarBuilder(index, item))
      })
    }
    .vertical(new BreakPointType({ sm: false, md: false, lg: true }).GetValue(this.currentBreakpoint))
    .barWidth(new BreakPointType({ sm: '100%', md: '100%', lg: '96vp' }).GetValue(this.currentBreakpoint))
    .barHeight(new BreakPointType({ sm: '72vp', md: '56vp', lg: '60%' }).GetValue(this.currentBreakpoint))
    .animationDuration(0)
    .onChange((index: number) => {
      this.currentIndex = index
    })
  }
}