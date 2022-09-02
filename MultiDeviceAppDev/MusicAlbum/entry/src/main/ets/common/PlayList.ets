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

import { songList } from '../model/SongList'
import MyDataSource from '../model/SongModule'

@Component
export default struct PlayList {
  @Consume('height') coverImgHeight: number
  @Consume('font') fontSize: number
  @Consume('breakPoint') currentBreakPoint: string
  @Consume('margin') listCoverMargin: number
  @Consume('coverHeight') PlayListCoverHeight: number

  @Builder
  PlayAll() {
    Row() {
      Row() {
        Image($r('app.media.ic_detail_play_all')).height(23).width(23)
        Text($r('app.string.play_all'))
          .maxLines(1)
          .padding({ left: 10 })
          .fontColor('#000000')
          .fontSize(this.fontSize)
        Blank()
        Image($r('app.media.ic_order_play'))
          .width(24)
          .height(24)
          .margin({ right: 16 })
        Image($r('app.media.ic_sort_list')).height(24).width(24)
      }
      .height(60)
      .width('100%')
      .backgroundColor('#fff')
      .padding({ left: 12, right: 12 })
      .borderRadius({ topRight: 20, topLeft: 20 })
    }
    .backgroundColor(this.currentBreakPoint === 'sm' ? '#e4ecf7' : '#f6f9fc')
    .position({ x: 0, y: 0 })
  }

  @Builder
  SongItem(title: string, label: Resource, singer: string) {
    Row() {
      Column() {
        Text(title)
          .fontColor('#000000')
          .fontSize(this.fontSize)
          .margin({ bottom: 4 })
        Row() {
          Image(label)
            .width(16)
            .height(16)
            .margin({ right: 4 })
          Text(singer)
            .opacity(0.38)
            .fontColor('#000000')
            .fontSize(this.fontSize - 4)
        }
      }
      .alignItems(HorizontalAlign.Start)

      Blank()
      Image($r('app.media.ic_list_more')).height(24).width(24)
    }
    .height(60)
    .width('100%')
  }

  build() {
    Column() {
      this.PlayAll()
      Scroll() {
        List() {
          LazyForEach(new MyDataSource(songList), item => {
            ListItem() {
              Column() {
                this.SongItem(item.title, item.label, item.singer)
                Divider()
                  .strokeWidth(0.5)
                  .color('#000')
                  .opacity(0.1)
              }.padding({ left: 14, right: 14 })
            }
          }, item => item.id)
        }
        .width('100%')
        .height('100%')
        .lanes(this.currentBreakPoint === 'lg' ? 2 : 1)
      }
      .margin({ top: 50, bottom: this.currentBreakPoint === 'sm' ? this.PlayListCoverHeight : 0 })
    }
  }
}