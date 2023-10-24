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

import mediaquery from '@ohos.mediaquery'
import { HomePage } from './home/Home'
import { Applications } from './applications/Applications'
import { Play } from './player/Player'

@Entry
@Component
struct DiversionSample {
  @State isVertical: boolean = true
  @State barWidth: number = -1
  @State barHeight: number = -1
  @State currentIndex: number = 0
  private listener = mediaquery.matchMediaSync('(orientation: landscape)')

  // 监听横竖屏
  onPortrait(mediaQueryResult: mediaquery.MediaQueryResult) {
    if (mediaQueryResult.matches) { // 若设备为横屏状态，更改相应的页面布局
      this.isVertical = true
      this.barWidth = 100
      this.barHeight = 200
    } else {
      this.isVertical = false
      this.barWidth = -1
      this.barHeight = -1
    }
  }

  aboutToAppear() {
    this.listener.on('change', (mediaQueryResult:mediaquery.MediaQueryResult) => {
      this.onPortrait(mediaQueryResult);
    }) //绑定回调函数
  }

  @Builder NavigationTitle() {
    Column() {
      Text($r('app.string.multiScene_header_title'))
        .fontColor('#182431')
        .fontSize(30)
        .lineHeight(41)
        .fontWeight(700)
      Text($r('app.string.multiScene_header_subtitle'))
        .fontColor('#182431')
        .fontSize(14)
        .lineHeight(19)
        .opacity(0.4)
        .margin({ top: 2, bottom: 20 })
    }.alignItems(HorizontalAlign.Start)
  }

  @Builder TabBuilder(title: Resource, targetIndex: number, selectedImg: Resource, normalImg: Resource) {
    Column() {
      Image(this.currentIndex === targetIndex ? selectedImg : normalImg)
        .size({ width: 25, height: 25 })
      Text(title)
        .fontColor(this.currentIndex === targetIndex ? '#1698CE' : '#6B6B6B')
        .fontSize(10)
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Scroll() {
      Column() {
        // Navigation
        Navigation() {
          Tabs({ barPosition: this.isVertical ? BarPosition.Start : BarPosition.End }) {
            // 首页
            TabContent() {
              HomePage()
            }
            .tabBar(this.TabBuilder($r('app.string.multiScene_tabs_home'), 0, $r('app.media.ic_public_home_select'), $r('app.media.ic_public_home')))

            // 应用
            TabContent() {
              Applications()
            }
            .tabBar(this.TabBuilder($r('app.string.multiScene_tabs_app'), 1, $r('app.media.ic_public_albums_select'), $r('app.media.ic_public_albums')))

            // 播放
            TabContent() {
              Play()
            }
            .tabBar(this.TabBuilder($r('app.string.multiScene_tabs_play'), 2, $r('app.media.ic_gallery_template_select'), $r('app.media.ic_gallery_template')))

            // 我的
            TabContent() {
              Text($r('app.string.multiScene_my_content')).fontSize(30)
            }
            .tabBar(this.TabBuilder($r('app.string.multiScene_tabs_me'), 3, $r('app.media.ic_public_contacts_select'), $r('app.media.ic_public_contacts')))
          }
          .vertical(this.isVertical)
          .barWidth(this.barWidth)
          .barHeight(this.barHeight)
          .onChange((index: number) => {
            this.currentIndex = index
          })
        }.mode(NavigationMode.Stack)
        .title(this.NavigationTitle())
        .titleMode(NavigationTitleMode.Full)
      }
      .height('100%')
      .backgroundColor('#F1F3f5')
    }
  }
}