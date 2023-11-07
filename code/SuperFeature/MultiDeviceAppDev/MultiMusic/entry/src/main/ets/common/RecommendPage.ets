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

import { songsList } from '../model/DataSummary';
import { IconItem, PaddingDataType } from '../model/DataType';
import { MusicPlayer } from '../pages/Index';
import { BreakpointType } from './BreakpointSystem';
import TitleBar from './TitleBar';

@Entry
@Component
export default struct RecommendPage {
  @LocalStorageProp("currentBreakpoint") currentBreakpoint: string = 'md';
  @State bannerList: Resource[] = [
  $r('app.media.banner1'),
  $r('app.media.banner2'),
  $r('app.media.banner3'),
  ];

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {
        TitleBar()

        Column() {
          Scroll() {
            Column() {
              Row() {
                if (this.currentBreakpoint === 'lg') {
                  BannerColumn({ bannerList: $bannerList })
                } else {
                  BannerSwiper({ bannerList: $bannerList })
                }
              }.margin({ top: 8 })

              ListModule().margin({ top: 24 })

              SongList().margin({ top: 26 })
            }
          }.scrollBar(BarState.Off)
        }.layoutWeight(1)
      }.height('100%')
      .justifyContent(FlexAlign.Start)
      .padding(new BreakpointType(
        new PaddingDataType(16, 16),
        new PaddingDataType(16, 16),
        new PaddingDataType(24, 24)).GetValue(this.currentBreakpoint))

      if (this.currentBreakpoint !== 'lg') {
        MusicPlayer()
      }
    }.backgroundColor('#f1f3f5')
  }
}

@Component
struct BannerSwiper {
  @Link bannerList: Resource[];
  @LocalStorageProp("currentBreakpoint") currentBreakpoint: string = 'md';

  build() {
    Swiper() {
      ForEach(this.bannerList, (item: Resource) => {
        Image(item).width('100%').height('100%').borderRadius(10)
          .backgroundColor('#7fD8D8D8')
      })
    }
    .cachedCount(3)
    .itemSpace(8)
    .displayCount(new BreakpointType(1, 2, 3).GetValue(this.currentBreakpoint))
    .indicator(new BreakpointType(true, false, false).GetValue(this.currentBreakpoint))
    .indicatorStyle({ selectedColor: '#fff' })
    .loop(true)
    .height(191)
  }
}

@Component
struct  BannerColumn {
  @Link bannerList: Resource[];

  build() {
    Row({ space: 13 }) {
      Image(this.bannerList[0]).width('66%').height(249).borderRadius(12)
      Column({ space: 10 }) {
        Image(this.bannerList[1]).width('33%').height(120).borderRadius(12)
        Image(this.bannerList[2]).width('33%').height(120).borderRadius(12)
      }
    }.width('100%')
  }
}

@Component
struct ListModule {
  @LocalStorageProp("currentBreakpoint") currentBreakpoint: string = 'md';
  @State data: IconItem[] = [
    new IconItem($r('app.media.ic_music_privatefm'), $r('app.string.privacy')),
    new IconItem($r('app.media.ic_music_singer'), $r('app.string.singer')),
    new IconItem($r('app.media.ic_music_songsheet'), $r('app.string.singList')),
    new IconItem($r('app.media.ic_music_ranking'), $r('app.string.rank')),
    new IconItem($r('app.media.ic_music_musicfm'), $r('app.string.musicFM')),
    new IconItem($r('app.media.ic_music_hires'), $r('app.string.hiRes')),
    new IconItem($r('app.media.ic_music_children'), $r('app.string.child')),
    new IconItem($r('app.media.ic_music_Album'), $r('app.string.digital')),
  ];

  build() {
    List({ space: new BreakpointType(0, 35, 63).GetValue(this.currentBreakpoint) }) {
      ForEach(this.data, (item: IconItem) => {
        ListItem() {
          Column() {
            Image(item.imageSrc).width(40).height(40)
            Text(item.description).fontSize(12).margin({ top: 8 })
          }.width(64).height(64)
        }
      })
    }.listDirection(Axis.Horizontal)
    .height(64)
    .scrollBar(BarState.Off)
  }
}

@Component
struct SongList {
  @State data: IconItem[] = songsList;
  @LocalStorageProp("currentBreakpoint") currentBreakpoint: string = 'md';
  @State gridHeight: number = 900;

  build() {
    Column() {
      Row() {
        Text($r("app.string.singRecommend")).fontSize(16).fontWeight(FontWeight.Medium)
        Blank()
        Text('更多').fontSize(14).fontWeight(FontWeight.Regular)
          .fontColor($r('sys.color.ohos_id_color_text_secondary'))
        Image($r('app.media.ic_public_arrow_right')).width(12).height(24).opacity(0.3)
      }
      .width('100%')
      .height(48)

      Grid() {
        ForEach(this.data, (item: IconItem) => {
          GridItem() {
            Column() {
              Stack({ alignContent: Alignment.BottomStart }) {
                Image(item.imageSrc).width('100%').aspectRatio(1)
                Image($r('app.media.play')).height(20).aspectRatio(1)
                  .offset({ x: 6, y: -6 })
              }

              Text(item.description)
                .height(38)
                .margin({ top: 8 })
                .fontSize(14)
                .fontWeight(FontWeight.Regular)
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Clip })
            }.onAreaChange((oldArea: Area, newArea: Area) => {
              let value = new BreakpointType(3, 5, 6).GetValue(this.currentBreakpoint);
              if (value) {
                let rowNum = Math.ceil(this.data.length / value);
                let itemHeight = Number(newArea.height);
                let rowGap = 16;
                this.gridHeight = (rowGap + itemHeight) * rowNum - rowGap;
                if (this.currentBreakpoint !== 'lg') {
                  this.gridHeight += 48;
                }
              }
            })
          }.width('100%')
        })
      }
      .width('100%')
      .height(this.gridHeight)
      .columnsGap(8)
      .rowsGap(16)
      .columnsTemplate(new BreakpointType(
        '1fr 1fr 1fr',
        '1fr 1fr 1fr 1fr 1fr',
        '1fr 1fr 1fr 1fr 1fr 1fr',
      ).GetValue(this.currentBreakpoint))
    }
  }
}