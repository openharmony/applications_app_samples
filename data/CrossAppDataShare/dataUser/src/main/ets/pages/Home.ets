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

import HomeContent from './Home/HomeContent'
import SettingsContent from './Home/SettingsContent'

@Entry
@Component
struct Home {
  private tabResource = [{
                           title: $r('app.string.contact'),
                           image: $r('app.media.contact'),
                           imageSelected: $r('app.media.contact_selected') },
                         {
                           title: $r('app.string.settings'),
                           image: $r('app.media.settings'),
                           imageSelected: $r('app.media.settings_selected') }]
  @State tabSelectedIndex: number = 0
  private tabController: TabsController = new TabsController()

  build() {
    Tabs({ barPosition: BarPosition.End, controller: this.tabController, index: this.tabSelectedIndex }) {
      TabContent() {
        Column() {
          HomeContent()
          Divider()
            .color($r('app.color.divider'))
            .strokeWidth('1px')
            .height(1)
        }
        .height('100%')
      }
      .tabBar(this.TabBar(0))

      TabContent() {
        Column() {
          SettingsContent()
          Divider()
            .color($r('app.color.divider'))
            .strokeWidth('1px')
            .height(1)
        }
        .height('100%')
      }
      .tabBar(this.TabBar(1))
    }
    .barHeight(70)
    .barMode(BarMode.Fixed)
    .backgroundColor($r('app.color.page_background'))
    .onChange((index: number) => {
      this.tabSelectedIndex = index
    })
  }

  @Builder
  TabBar(index: number) {
    Column() {
      Image(this.tabSelectedIndex === index ? this.tabResource[index].imageSelected : this.tabResource[index].image)
        .height(32)
        .width(32)
      Text(this.tabResource[index].title)
        .fontSize(18)
        .margin({ top: 4 })
        .fontColor(this.tabSelectedIndex === index ? '#007dff' : '#70000000')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.tabController.changeIndex(index)
    })
  }
}