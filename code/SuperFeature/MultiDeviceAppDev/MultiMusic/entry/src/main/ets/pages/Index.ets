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

import { BreakpointType } from '../common/BreakpointSystem';
import RecommendPage from '../common/RecommendPage';
import { UserSongList } from '../common/UserSongList';
import { IconItem } from '../model/DataType';

@Entry
@Component
struct Index {
  tabBarList: IconItem[] = [
    new IconItem($r('app.media.ic_public_home'), $r('app.string.index')),
    new IconItem($r('app.media.ic_radio'), $r('app.string.radio')),
    new IconItem($r('app.media.ic_find'), $r('app.string.discovery')),
    new IconItem($r('app.media.ic_mine'), $r('app.string.mine')),
  ];
  @LocalStorageLink("currentBreakpoint") currentBreakpoint: string = 'sm';
  private controller: TabsController = new TabsController();
  @State currentIndex: number = 0;
  @State selectIconList: Resource[] = [
  $r('app.media.ic_public_home_filled'),
  $r('app.media.ic_radio_h'),
  $r('app.media.ic_find_h'),
  $r('app.media.ic_mine_h'),
  ];

  @Builder
  TabBuilder(index: number) {
    Column() {
      Image(this.currentIndex === index ? this.selectIconList[index] : this.tabBarList[index].imageSrc)
        .height(24).width(24)
      Text(this.tabBarList[index].description)
        .fontColor(this.currentIndex === index ? '#ff1949' : '#000')
        .margin({ top: 4 })
        .height(14)
        .fontSize(10)
        .lineHeight(14)
    }
    .justifyContent(FlexAlign.Center)
    .height(56)
    .width('100%')
    .id('tabs' + index)
  }

  build() {
    GridRow({ columns: { sm: 4, md: 8, lg: 12 } }) {
      GridCol({ span: { sm: 4, md: 8, lg: 12 } }) {
        Column() {
          Tabs({
            controller: this.controller,
            barPosition: new BreakpointType(BarPosition.End, BarPosition.End, BarPosition.Start).GetValue(this.currentBreakpoint),
            index: this.currentIndex
          }) {
            TabContent() {
              Column() {
                RecommendPage()
              }.height('100%').width('100%')
            }.tabBar(this.TabBuilder(0))

            TabContent() {
              Column()
                .backgroundColor('#007DFF')
                .height('100%')
                .width('100%')
            }.tabBar(this.TabBuilder(1))

            TabContent() {
              Column()
                .backgroundColor('#FFBF00')
                .height('100%')
                .width('100%')
            }.tabBar(this.TabBuilder(2))

            TabContent() {
              Column() {
                UserSongList()
              }.width('100%').height('100%')
            }.tabBar(this.TabBuilder(3))
          }
          .vertical(new BreakpointType(false, false, true).GetValue(this.currentBreakpoint))
          .scrollable(false)
          .layoutWeight(1)
          .backgroundColor($r("sys.color.ohos_id_color_toolbar_sub_bg"))
          .onChange((index: number) => {
            this.currentIndex = index;
          })

          if (this.currentBreakpoint === 'lg') {
            MusicPlayer()
          }
        }
      }
    }.onBreakpointChange((breakpoint: string) => {
      animateTo({ duration: 600, curve: Curve.Smooth }, () => {
        this.currentBreakpoint = breakpoint;
      })
    })
  }
}

@Component
export struct MusicPlayer {
  build() {
    Row() {
      Image($r('app.media.list1')).height(32).width(32)
      Column() {
        Text('Witness')
          .fontColor('#1818a')
          .fontWeight(FontWeight.Regular)
          .fontSize(14)
        Text('Katy')
          .opacity(0.6)
          .fontWeight(FontWeight.Regular)
          .fontSize(10)
      }.margin({ left: 12 }).alignItems(HorizontalAlign.Start)

      Blank()
      Image($r('app.media.icon_play')).height(26).width(26)
      Image($r('app.media.ic_play'))
        .margin({ left: 20 })
        .height(26)
        .width(26)
      Image($r('app.media.ic_playList'))
        .margin({ left: 20 })
        .height(26)
        .width(26)
    }.width('100%')
    .backgroundColor('#f7ffffff')
    .padding({ left: 16, right: 16 })
    .height(48)
  }
}