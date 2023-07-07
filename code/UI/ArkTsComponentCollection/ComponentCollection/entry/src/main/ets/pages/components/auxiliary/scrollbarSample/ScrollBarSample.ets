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

import { TitleBar } from '../../../../common/TitleBar'

@Extend(Text) function leftTitleStyle() {
  .fontColor($r('app.color.sub_title_color'))
  .fontSize(14)
  .height(22)
  .alignSelf(ItemAlign.Start)
  .margin({ left: 12, top: 12 })
}

@Entry
@Component
struct ScrollBarSample {
  private vscroller: Scroller = new Scroller()
  private hscroller: Scroller = new Scroller()
  private dataArray: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  private ItemHeight: number = 300

  build() {
    Column() {
      TitleBar({ title: $r('app.string.scroll_bar') })
      Text($r('app.string.scroll_vertical_title'))
        .leftTitleStyle()
      Row() {
        Column() {
          Scroll(this.vscroller) {
            Column() {
              ForEach(this.dataArray, (item) => {
                Stack() {
                  Text(item.toString())
                    .fontSize(20)
                }.width('100%')
                .height(60)
                .backgroundColor($r('app.color.white'))
                .borderRadius(10)

                Blank(6)
              })
            }.width('80%')
          }.height('100%')
          .padding(12)
          .scrollBar(BarState.Off)
        }.height(this.ItemHeight)
        .alignSelf(ItemAlign.Start)

        Blank()
        ScrollBar({ scroller: this.vscroller, direction: ScrollBarDirection.Vertical, state: BarState.Auto }) {
          Column()
            .width(10)
            .height(100)
            .borderRadius(10)
            .backgroundColor($r('app.color.contentArea_background_color'))
        }.width(10)
        .height(this.ItemHeight)
        .backgroundColor($r('app.color.scrollbar_background_color'))
      }.width('100%')
      .padding(12)

      Text($r('app.string.scroll_horizontal_title'))
        .leftTitleStyle()
      Column() {
        Column() {
          Scroll(this.hscroller) {
            Row() {
              ForEach(this.dataArray, (item) => {
                Stack() {
                  Text(item.toString())
                    .fontSize(20)
                }.width(60)
                .height('100%')
                .backgroundColor($r('app.color.white'))
                .borderRadius(10)

                Blank(6)
              })
            }
          }
          .width('100%')
          .clip(true)
          .height(this.ItemHeight)
          .padding(12)
          .scrollable(ScrollDirection.Horizontal)
          .scrollBar(BarState.Off)
        }.height(this.ItemHeight)
        .width('100%')
        .alignSelf(ItemAlign.Start)

        Blank()
        ScrollBar({ scroller: this.hscroller, direction: ScrollBarDirection.Horizontal, state: BarState.Auto }) {
          Column()
            .width(100)
            .height(10)
            .borderRadius(10)
            .backgroundColor($r('app.color.contentArea_background_color'))
        }.width('100%')
        .height(10)
        .backgroundColor($r('app.color.scrollbar_background_color'))
      }.width('100%')
      .padding(12)
    }
    .backgroundColor($r('app.color.background_light_gray'))
    .height('100%')
  }
}