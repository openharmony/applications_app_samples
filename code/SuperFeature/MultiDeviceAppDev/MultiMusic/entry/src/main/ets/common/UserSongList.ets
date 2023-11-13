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

import { OffsetDataType, SongType } from '../model/DataType';
import { MusicPlayer } from '../pages/Index';
import { BreakpointType } from './BreakpointSystem';

@Entry
@Component
export struct UserSongList {
  @LocalStorageProp("currentBreakpoint") currentBreakpoint: string = 'sm';
  @State songList: SongType[] = [
    new SongType($r('app.media.list4'), $r('app.string.emo'), 16),
    new SongType($r('app.media.list12'), $r('app.string.noSleep'), 16),
    new SongType($r('app.media.list11'), $r('app.string.noise'), 16),
    new SongType($r('app.media.list10'), $r('app.string.bluce'), 16),
    new SongType($r('app.media.list9'), $r('app.string.jazz'), 16),
    new SongType($r('app.media.list8'), $r('app.string.coffee'), 24),
    new SongType($r('app.media.list7'), $r('app.string.noon'), 30),
    new SongType($r('app.media.list6'), $r('app.string.sunshine'), 16),
    new SongType($r('app.media.list5'), $r('app.string.sleep'), 18),
    new SongType($r('app.media.list4'), $r('app.string.rock'), 25),
    new SongType($r('app.media.list3'), $r('app.string.pops'), 30),
    new SongType($r('app.media.list2'), $r('app.string.oldYear'), 48),
    new SongType($r('app.media.list1'), $r('app.string.bgm'), 16),
  ];

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {
        Row() {
          Text($r('app.string.mySongs'))
            .fontWeight(FontWeight.Medium)
            .fontSize(24)
            .lineHeight(33)
            .height(33)
          Blank()
          Image($r('app.media.ic_search')).width(24).height(24).margin({ right: 24 })
          Image($r('app.media.ic_more')).width(24).height(24)
        }.width('100%').height(56)

        Row() {
          Text() {
            Span($r('app.string.buildBySelf'))
            Span('50')
          }.fontSize(16).height(22).lineHeight(22)
        }.width('100%').height(48)

        Grid() {
          ForEach(this.songList, (item: SongType) => {
            GridItem() {
              Column() {
                Flex({ direction: new BreakpointType(
                  FlexDirection.Row,
                  FlexDirection.Column,
                  FlexDirection.Column,
                ).GetValue(this.currentBreakpoint) }) {
                  Stack({ alignContent: new BreakpointType(
                    Alignment.Center,
                    Alignment.BottomStart,
                    Alignment.BottomStart,
                  ).GetValue(this.currentBreakpoint) }) {
                    Image(item.imageSrc)
                      .width(new BreakpointType('48vp', '100%', '100%').GetValue(this.currentBreakpoint))
                      .aspectRatio(1)
                      .borderRadius(8)
                    Image($r('app.media.play')).height(20).width(20)
                      .offset(new BreakpointType(
                        new OffsetDataType(0, 0),
                        new OffsetDataType(11, -11),
                        new OffsetDataType(11, -11))
                        .GetValue(this.currentBreakpoint))
                  }

                  Column() {
                    Text(item.description).fontSize(16).lineHeight(22).height(22)
                    Text(item.count.toString()).fontSize(12).lineHeight(14).height(14).fontColor('#33000000')
                  }.margin({ left: new BreakpointType(16, 0, 0).GetValue(this.currentBreakpoint) })
                  .height(48)
                  .justifyContent(FlexAlign.Center)
                  .alignItems(HorizontalAlign.Start)

                  if (this.currentBreakpoint === 'sm') {
                    Blank()
                    Row() {
                      Image($r('app.media.ic_public_arrow_right')).width(12).height(24)
                    }.height(48)
                  }
                }.width('100%')

                if (this.currentBreakpoint === 'sm') {
                  Divider().width('100%').strokeWidth('1px').margin({ left: 64 })
                }
              }
            }
          })
        }
        .columnsTemplate(new BreakpointType(
          '1fr',
          '1fr 1fr 1fr 1fr 1fr',
          '1fr 1fr 1fr 1fr 1fr 1fr'
        ).GetValue(this.currentBreakpoint))
        .columnsGap(7)
        .rowsGap(12)
        .layoutWeight(1)
        .scrollBar(BarState.Off)
        .width('100%')
      }.width('100%').padding({ left: 16, right: 16 })

      if (this.currentBreakpoint !== 'lg') {
        MusicPlayer()
      }
    }
  }
}