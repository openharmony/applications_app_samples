/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { TitleBar } from './TitleBar'
import { TrendsDetailView } from './TrendsDetailView';

@Component
export struct SquareView {
  @State currentIndex: number = 0;
  private controller: TabsController = new TabsController();

  @Builder
  TabBuilder(index: number, name: string | Resource) {
    Column() {
      Text(name)
        .fontFamily('HarmonyHeiTi-Medium')
        .fontSize($r('app.integer.layout_size_16'))
        .fontColor(this.currentIndex === index ? $r('app.color.font_color_007DFF') : $r('app.color.font_color_182431'))
        .lineHeight($r('app.integer.layout_size_22'))
        .fontWeight(this.currentIndex === index ? 500 : 400)
        .margin({ bottom: $r('app.integer.layout_size_7') })
        .opacity(this.currentIndex === index ? $r('app.integer.layout_size_1') : $r('app.float.opacity'))
      Divider()
        .strokeWidth(2)
        .width($r('app.integer.layout_size_48'))
        .borderRadius($r('app.integer.layout_size_1'))
        .color($r('app.color.font_color_007DFF'))
        .opacity(this.currentIndex === index ? $r('app.integer.layout_size_1') : $r('app.integer.layout_size_0'))
        .margin({ bottom: $r('app.integer.layout_size_8') })
    }
  }

  build() {
    Column() {

      TitleBar({ title: $r('app.string.explore') })

      Tabs({ barPosition: BarPosition.Start, controller: this.controller }) {
        TabContent() {
          //放包含同城按钮页面、微博热搜榜、广告页面等页面
          TrendsDetailView()
        }
        .tabBar(this.TabBuilder(0, $r('app.string.trend')))

        TabContent() {

        }.tabBar(this.TabBuilder(1, $r('app.string.hot_tab')))

      }
      .onChange((index: number) => {
        this.currentIndex = index
      })
      .barWidth($r('app.integer.layout_size_200'))
      .barHeight($r('app.integer.layout_size_40'))
    }.backgroundColor($r('app.color.tabbar_background'))
  }
}