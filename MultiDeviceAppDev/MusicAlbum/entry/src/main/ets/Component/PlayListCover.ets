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

import { optionList } from '../Module/SongList'
import MyOptionSource from '../Module/OptionModule'

@Component
export default struct PlayListCover {
  @Consume('height') coverImgHeight: number
  @Consume('font') fontSize: number
  @Consume('breakPoint') currentBreakPoint: string
  @Consume('margin') listCoverMargin: number
  @State coverHeight: number = 0

  build() {
    Column() {
      GridRow({
        columns: 12,
        breakpoints: { value: ['320vp', '520vp', '840vp'], reference: BreakpointsReference.WindowSize }
      }) {
        // 歌单图片
        GridCol({ span: { sm: 4, md: 10, lg: 10 }, offset: { sm: 0, md: 1, lg: 1 } }) {
          Row() {
            Stack() {
              Image($r('app.media.pic_album'))
                .width('100%')
                .aspectRatio(1)
                .borderRadius(8)
                .onAreaChange((oldArea: Area, newArea: Area) => {
                  this.coverImgHeight = newArea.height as number
                })
              // 收藏人数
              Text('12.5万')
                .letterSpacing(1)
                .fontColor('#fff')
                .fontSize(this.fontSize - 4)
                .position({ x: 0, y: '100%' })
                .translate({ x: '10', y: '-200%' })
            }.width('100%').height('100%')
          }
          .width('100%')
          .aspectRatio(1)
        }
        // 歌单介绍
        GridCol({ span: { sm: 8, md: 10, lg: 10 }, offset: { sm: 0, md: 2, lg: 2 } }) {
          Column() {
            Row() {
              Text($r('app.string.list_name'))
                .opacity(0.9)
                .fontWeight(500)
                .fontColor('#556B89')
                .fontSize(this.fontSize + 2)
            }.margin({ bottom: 10 })

            Text($r('app.string.playlist_Introduction'))
              .opacity(0.6)
              .width('100%')
              .fontWeight(400)
              .fontColor('#556B89')
              .fontSize(this.fontSize - 2)
          }
          .width('100%')
          .height(this.currentBreakPoint === 'sm' ? this.coverImgHeight : 70)
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Center)
          .padding({ left: this.currentBreakPoint === 'sm' ? 20 : 0 })
          .margin({
            top: this.currentBreakPoint === 'sm' ? 0 : 30,
            bottom: this.currentBreakPoint === 'sm' ? 0 : 20
          })
        }
        // 按钮
        GridCol({ span: { sm: 12, md: 10, lg: 10 }, offset: { sm: 0, md: 2, lg: 2 } }) {
          Row() {
            LazyForEach(new MyOptionSource(optionList), (item) => {
              Row() {
                Column({ space: 4 }) {
                  Image(item.image).height('30vp').width('30vp')
                  Text(item.text)
                    .fontWeight(400)
                    .fontColor('#556B89')
                    .fontSize(this.fontSize - 1)
                }
              }
            }, item => item.id)
          }
          .width('100%')
          .height('70vp')
          .padding({
            left: this.currentBreakPoint === 'sm' ? 20 : 0,
            right: this.currentBreakPoint === 'sm' ? 20 : 0
          })
          .justifyContent(FlexAlign.SpaceBetween)
        }.margin({
          top: this.currentBreakPoint === 'sm' ? 15 : 0,
          bottom: this.currentBreakPoint === 'sm' ? 15 : 0
        })
      }
      .margin({ left: this.listCoverMargin, right: this.listCoverMargin })
      .onAreaChange((oldArea: Area, newArea: Area) => {
        this.coverHeight = newArea.height as number
      })
    }
    .justifyContent(FlexAlign.Start)
    .height(this.currentBreakPoint === 'sm' ? this.coverHeight : '100%')
    .padding({ top: this.currentBreakPoint === 'sm' ? 0 : 20 })
  }
}