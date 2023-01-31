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

import { SearchTextModel, FindTitleTextModel } from '../../model/homeModel'
import { findSearchTextData, findTitleTextData } from '../../data/homeData'
import { ImageItem } from './imageItem'

class ImageItems implements IDataSource {
  totalCount(): number {
    return this.num
  }

  getData(index: number): any {
    return index
  }

  registerDataChangeListener(listener: DataChangeListener) {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener)
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener) {
    const pos = this.listeners.indexOf(listener)
    if (pos >= 0) {
      this.listeners.splice(pos, 1)
    }
  }

  num: number = 10
  listeners: DataChangeListener[] = []
}
@Component
export struct FindPage {
  @Link bgColor: string
  @Link ratio: number
  imageItems: ImageItems = new ImageItems()
  @State searchText: Array<SearchTextModel> = findSearchTextData
  @State titleText: Array<FindTitleTextModel> = findTitleTextData

  build() {
    Column() {
      List() {
        ListItem() {
          Row() {
            Image('/resources/icon/search.png')
              .width(25 * this.ratio)
              .aspectRatio(1)
              .objectFit(ImageFit.Contain)
              .margin({ left: 10 })
            Divider()
              .vertical(true)
              .height('8%')
            Swiper() {
              Text(this.searchText[0].searchText)
                .fontSize(15 * this.ratio)
                .fontColor(Color.Grey)
              Text(this.searchText[1].searchText)
                .fontSize(15 * this.ratio)
                .fontColor(Color.Grey)
              Text(this.searchText[2].searchText)
                .fontSize(15 * this.ratio)
                .fontColor(Color.Grey)
            }
            .width('65%')
            .autoPlay(false)
            .loop(true)
            .vertical(true)
            .indicator(false)
            .interval(2000)

            Column() {
              Text('搜索')
                .fontSize(15 * this.ratio)
                .fontColor(Color.White)
                .lineHeight('100%')
                .height('100%')
            }
            .height('100%')
            .width('16%')
            .backgroundColor(Color.Orange)
            .padding(0)
          }
          .height('6%')
          .clip(true)
          .border({ width: 2, color: Color.Orange, radius: 20 })
          .width('100%')
          .backgroundColor(Color.White)
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)
        }
        .padding({ left: 10, right: 10 })
        .margin({ bottom: 10 })

        ListItem() {
          Row() {
            Text(this.titleText[0].titleText)
              .fontSize(15 * this.ratio)
            Text(this.titleText[1].titleText)
              .fontSize(15 * this.ratio)
            Text(this.titleText[2].titleText)
              .fontSize(15 * this.ratio)
            Text(this.titleText[3].titleText)
              .fontSize(15 * this.ratio)
            Text(this.titleText[4].titleText)
              .fontSize(15 * this.ratio)
            Text(this.titleText[5].titleText)
              .fontSize(15 * this.ratio)
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)
          .padding({ left: 15, right: 15 })
        }
        .sticky(Sticky.Normal)
        .backgroundColor(Color.White)
        .padding({ top: 10, bottom: 10 })
        .border({ radius: 10 * this.ratio })

        ListItem() {
          Column() {
            LazyForEach(this.imageItems, item => {
              Row() {
                Column() {
                  ImageItem({ ratio: this.ratio })
                }
                .padding({ right: 3 })

                Column() {
                  ImageItem({ ratio: this.ratio })
                }
                .padding({ right: 3 })
              }
              .width('100%')
              .aspectRatio(1.1)
              .margin({ top: 10 })
            }, item => item.toString())
          }
          .padding({ left: 10, right: 10 })
        }
        .width('100%')
        .backgroundColor(Color.White)
        .offset({ x: 0, y: -10 })
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#dfe5e3')
      .onScrollIndex((e) => {
        if (e != 0) {
          this.bgColor = '#FFFFFF'
        } else {
          this.bgColor = '#dfe5e3'
        }
      })
    }
    .padding({ top: 10, bottom: 10 })
  }
}