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
        .width(24).height(24)
      Text(this.tabBarList[index].description)
        .fontSize(10)
        .lineHeight(14)
        .height(14)
        .margin({ top: 4 })
        .fontColor(this.currentIndex === index ? '#ff1949' : '#000')
    }.width('100%').height(56).justifyContent(FlexAlign.Center).id('tabs' + index)
  }

  build() {
    GridRow({ columns: { sm: 4, md: 8, lg: 12 } }) {
      GridCol({ span: { sm: 4, md: 8, lg: 12 } }) {
        Column() {
          Tabs({
            barPosition: new BreakpointType(BarPosition.End, BarPosition.End, BarPosition.Start).GetValue(this.currentBreakpoint),
            controller: this.controller,
            index: this.currentIndex
          }) {
            TabContent() {
              Column() {
                RecommendPage()
              }.width('100%').height('100%')
            }.tabBar(this.TabBuilder(0))

            TabContent() {
              Column().width('100%').height('100%').backgroundColor('#007DFF')
            }.tabBar(this.TabBuilder(1))

            TabContent() {
              Column().width('100%').height('100%').backgroundColor('#FFBF00')
            }.tabBar(this.TabBuilder(2))

            TabContent() {
              Column() {
                UserSongList()
              }.width('100%').height('100%')
            }.tabBar(this.TabBuilder(3))
          }
          .vertical(new BreakpointType(false, false, true).GetValue(this.currentBreakpoint))
          .backgroundColor($r("sys.color.ohos_id_color_toolbar_sub_bg"))
          .layoutWeight(1)
          .scrollable(false)
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
      Image($r('app.media.list1')).width(32).height(32)
      Column() {
        Text('Witness').fontSize(14).fontWeight(FontWeight.Regular).fontColor('#1818a')
        Text('Katy').fontSize(10).fontWeight(FontWeight.Regular).opacity(0.6)
      }.margin({ left: 12 })
      .alignItems(HorizontalAlign.Start)

      Blank()
      Image($r('app.media.icon_play')).width(26).height(26)
      Image($r('app.media.ic_play')).width(26).height(26).margin({ left: 20 })
      Image($r('app.media.ic_playList')).width(26).height(26).margin({ left: 20 })
    }.width('100%')
    .backgroundColor('#f7ffffff')
    .padding({ left: 16, right: 16 })
    .height(48)
  }
}