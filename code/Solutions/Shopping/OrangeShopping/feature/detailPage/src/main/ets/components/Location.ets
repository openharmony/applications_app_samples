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

import { CITY_DATA, HOT_CITY, TAB_VALUE } from '../mock/DetailData'

@Component
export struct Location {
  @Link isPanel: boolean
  private scroller: Scroller = new Scroller()
  @State stabIndex: number = 0
  @State location: boolean = true
  @Link currentLocation: string

  @Builder cityList(city: any) {
    if (this.currentLocation === city.name) {
      List() {
        ForEach(city.city, twoCity => {
          ListItem() {
            Column() {
              Text(`${twoCity}`)
                .width('100%')
                .height(30)
                .fontSize(14)
                .onClick(() => {
                  this.currentLocation = city.name + '/' + twoCity
                })
            }
          }
        })
      }
      .width('100%')
      .divider({ strokeWidth: 2, color: $r('app.color.divider'), startMargin: 0, endMargin: 20 })
    }
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.cancel'))
          .objectFit(ImageFit.Contain)
          .width(30)
          .height(6)
          .margin({ top: 10 })
          .onClick(() => {
            this.isPanel = !this.isPanel
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)

      Column() {
        Text($r('app.string.deliver_to'))
          .fontSize(18)
        if (this.currentLocation) {
          Text(`${this.currentLocation}` || $r('app.string.hangzhou'))
            .fontSize(14)
        } else {
          Text($r('app.string.current_positioning'))
            .fontSize(14)
            .opacity(0.6)
        }
      }
      .width('100%')
      .margin({ top: 24 })
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.SpaceBetween)

      Row() {
        Row() {
          Image($r('app.media.location'))
            .width(16)
            .aspectRatio(1)
            .padding({ left: 4 })
          Text($r('app.string.hangzhou'))
            .fontSize(14)
            .fontColor($r('app.color.red'))
            .padding({ right: 2, top: 2 })
        }
        .width(64)
        .height(26)
        .borderRadius(13)
        .borderWidth(1)
        .borderColor($r('app.color.red'))
        .justifyContent(FlexAlign.SpaceAround)
      }
      .margin({ top: 14 })

      Column() {
        Stack({ alignContent: Alignment.End }) {
          Column() {
            Row() {
              Text($r('app.string.domestic_hot_city'))
                .fontSize(14)
                .fontColor($r('app.color.blank'))
                .opacity(0.6)
            }
            .margin({ top: 14, bottom: 14 })

            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center, wrap: FlexWrap.Wrap }) {
              ForEach(HOT_CITY, (item) => {
                // 这里规定每行占四个城市，使用25%
                Text(`${item}`)
                  .margin({ bottom: 16 })
                  .width('25%')
                  .fontSize(14)
                  .maxLines(3)
                  .fontColor($r('app.color.blank'))
                  .onClick(() => {
                    this.currentLocation = item
                  })
              })
            }
            .width('100%')

            List({ space: 14, initialIndex: 0, scroller: this.scroller }) {
              ForEach(CITY_DATA, (index) => {
                ListItem() {
                  Column() {
                    Text(`${index.name}`)
                      .height(30)
                      .fontSize(16)
                      .fontColor($r('app.color.blank'))
                      .width('100%')

                    ForEach(index.city, item => {
                      Text(`${item.name === undefined ? item : item.name}`)
                        .height(30)
                        .fontSize(14)
                        .width('100%')
                        .onClick(() => {
                          if (item.name === undefined) {
                            this.currentLocation = item
                          } else {
                            this.currentLocation = item.name
                          }
                        })
                      this.cityList(item)
                    })
                  }
                }
              })
            }
            .width('100%')
            .layoutWeight(1)
            .edgeEffect(EdgeEffect.None)
            .divider({ strokeWidth: 2, color: $r('app.color.divider'), startMargin: 0, endMargin: 20 })
            .listDirection(Axis.Vertical)
            .onScrollIndex((firstIndex: number, lastIndex: number) => {
              this.stabIndex = firstIndex
            })
          }
          .alignItems(HorizontalAlign.Start)

          AlphabetIndexer({ arrayValue: TAB_VALUE, selected: this.stabIndex })
            .height('100%')
            .selectedColor($r('app.color.white'))
            .popupColor($r('app.color.white'))
            .selectedBackgroundColor($r('app.color.gray'))
            .popupBackground($r('app.color.gray'))
            .usingPopup(true)
            .selectedFont({ size: 16, weight: FontWeight.Bolder })
            .popupFont({ size: 30, weight: FontWeight.Bolder })
            .alignStyle(this.location ? IndexerAlign.Right : IndexerAlign.Left)
            .onSelected((tabIndex: number) => {
              this.scroller.scrollToIndex(tabIndex)
            })
        }
        .margin({ top: 20 })
      }
      .flexShrink(1)
      .flexGrow(1)
      .alignItems(HorizontalAlign.Start)
      .padding({ bottom: 10 })
    }
    .width('100%')
    .padding({ left: 10, right: 16 })
    .backgroundColor($r('app.color.white'))
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Start)
  }
}