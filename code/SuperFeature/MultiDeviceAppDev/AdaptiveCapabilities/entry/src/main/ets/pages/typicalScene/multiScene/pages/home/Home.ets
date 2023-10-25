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

import { ArticlesData, Articles } from '../../data/home/Home'

@Component
export struct HomePage {
  private swiperController: SwiperController = new SwiperController()
  private bannerArr: Array<Resource> = [
  $r('app.media.banner1'),
  $r('app.media.banner2'),
  $r('app.media.banner3'),
  $r('app.media.banner4'),
  $r('app.media.banner5'),
  $r('app.media.banner6')
  ]
  @State imgHeight: number = 0
  @State textHeight: number = 0
  @State spaceBottom: number = 0
  @State currentBreakpoint: string = 'md'

  constructor() {
    super()
  }

  @Builder Item(article: Articles) {
    Flex() {
      Row() {
        Image(article.icon)
      }.width(43)
      .height(43)
      .borderRadius(12)

      Column() {
        Row() {
          Text(article.title)
            .fontColor('#182431')
            .fontSize(20)
        }
        .height(20)
        .width('80%')

        Row() {
          Text(article.disc)
            .fontSize(15)
            .fontColor('#182431')
            .opacity(0.4)
        }
        .height(15)
        .width('80%')
      }
      .height('100%')
      .margin({ left: 13 })
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.SpaceAround)
    }
    .padding({ top: 13, bottom: 13, left: 13, right: 13 })
    .height(70)
    .backgroundColor('#FFFFFF')
    .borderRadius(25)
  }

  build() {
    Column() {
      GridRow() {
        // Swiper
        GridCol({ span: { sm: 12, md: 6, lg: 6 } }) {
          Column() {
            Row() {
              Swiper(this.swiperController) {
                ForEach(this.bannerArr, (item: Resource) => {
                  Image(item)
                })
              }.width('100%')
            }
            .width('100%')
            .aspectRatio(1.5)
          }
          .margin({ bottom: this.spaceBottom })
          .width('100%')
          .justifyContent(FlexAlign.Center)
        }
        .onAreaChange((oldArea: Area, newArea: Area) => {
          this.imgHeight = newArea.height as number
          console.log(String(this.imgHeight))
        })

        GridCol({ span: { sm: 12, md: 6, lg: 6 } }) {
          Column() {
            List({ space: 10, initialIndex: 0 }) {
              ForEach(ArticlesData, (item : Articles) => {
                ListItem() {
                  this.Item(item)
                }
              })
            }
            .listDirection(Axis.Vertical) // 排列方向
            .edgeEffect(EdgeEffect.Spring) // 滑动到边缘无效果
            .onScrollIndex((firstIndex: number, lastIndex: number) => {
              console.info('first' + firstIndex)
              console.info('last' + lastIndex)
            })
            .width('100%')
          }
          .onAreaChange((oldArea: Area, newArea: Area) => {
            this.textHeight = newArea.height as number
          })
          .padding({ left: 15, right: 15 })
          .justifyContent(FlexAlign.Center)
        }
        .padding({ top: this.currentBreakpoint === 'sm' ? 0 : (this.imgHeight - this.textHeight) / 2 })

      }
      .onBreakpointChange((breakPoint: string) => {
        this.currentBreakpoint = breakPoint
        if (breakPoint === 'sm') {
          this.spaceBottom = 20
        } else {
          this.spaceBottom = 0
        }
      })

    }.width('100%')
  }
}