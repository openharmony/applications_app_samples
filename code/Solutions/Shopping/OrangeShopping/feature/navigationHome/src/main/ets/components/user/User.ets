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

import router from '@ohos.router'
import { FAVOR_LIVE_LIST_DATA } from '../../mock/ProductsData'
import { MyOrderComponent } from '../user/MyOrders'
import { RewardSectionComponent } from '../user/RrewardSection'
import { ServiceSectionComponent } from '../user/ServiceSection'

@Component
export struct User {
  @StorageProp('curBp') curBp: string = 'sm'

  build() {
    Column() {
      Scroll() {
        GridRow({ columns: { sm: 4, md: 8, lg: 12 }, gutter: { x: vp2px(8), y: vp2px(12) } }) {
          GridCol({ span: { sm: 4, md: 8, lg: 12 } }) {
            Column() {
              Row() {
                Image($r('app.media.setting'))
                  .width(24)
                  .aspectRatio(1)
                  .objectFit(ImageFit.Contain)
                  .margin({ right: 16 })
                  .onClick(() => {
                    router.replace({
                      url: 'pages/Setting'
                    })
                  })
                Image($r('app.media.scan_code'))
                  .width(24)
                  .aspectRatio(1)
                  .objectFit(ImageFit.Contain)
              }
              .width('100%')
              .padding(12)
              .justifyContent(FlexAlign.End)

              Row() {
                Image($r('app.media.usname'))
                  .width(48)
                  .height(48)
                  .objectFit(ImageFit.Contain)
                Column() {
                  Text($r('app.string.user_name'))
                    .fontSize(16)
                    .fontWeight(500)
                    .fontColor($r('app.color.white'))
                    .margin({ bottom: 12 })
                  Row() {
                    Row() {
                      Text($r('app.string.sign_Info'))
                        .fontColor($r('app.color.white'))
                        .fontSize(10)
                    }
                    .padding(4)
                    .borderRadius(10)
                    .backgroundColor($r('app.color.point_selected'))

                    Row() {
                      Text($r('app.string.sign_info_address'))
                        .fontColor($r('app.color.white'))
                        .fontSize(10)
                    }
                    .padding(4)
                    .borderRadius(10)
                    .backgroundColor($r('app.color.point_selected'))
                    .margin({ left: 4 })
                  }
                }
                .alignItems(HorizontalAlign.Start)
                .padding({ left: 12 })
              }
              .width('100%')
              .padding({ left: 12 })

              MyOrderComponent()
            }
          }

          GridCol({ span: { sm: 4, md: 4, lg: 6 } }) {
            RewardSectionComponent()
          }

          GridCol({ span: { sm: 4, md: 4, lg: 6 } }) {
            ServiceSectionComponent()
          }

          GridCol({ span: { sm: 4, md: 8, lg: 12 } }) {
            Row() {
              Text($r('app.string.often_see_live'))
                .fontSize(16)
                .fontWeight(500)
                .margin({ left: 12 })
              Blank()
              Row() {
                Text($r('app.string.read_more'))
                  .fontSize(14)
                  .opacity(0.6)
                Image($r('app.media.arrows_right'))
                  .width(this.curBp === 'sm' ? 12 : this.curBp === 'md' ? 14 : 16)
                  .aspectRatio(1)
                  .objectFit(ImageFit.Contain)
              }
            }
            .width('100%')
            .padding({ top: 4 })
          }

          ForEach(FAVOR_LIVE_LIST_DATA, item => {
            GridCol({ span: { sm: 2, md: 4, lg: 4 } }) {
              Stack({ alignContent: Alignment.TopStart }) {
                Image(item.imgSrc)
                  .objectFit(ImageFit.Cover)
                Row() {
                  Row() {
                    Text(item.title)
                      .fontSize(10)
                      .fontColor($r('app.color.white'))
                  }
                  .backgroundColor($r('app.color.red'))
                  .borderRadius(10)
                  .padding({ left: 6, right: 6, bottom: 2, top: 2 })

                  Text(item.viewsInfo)
                    .fontSize(10)
                    .fontColor($r('app.color.white'))
                    .margin({ left: 6 })
                }
                .borderRadius(10)
                .padding({ right: 6 })
                .backgroundColor($r('app.color.point'))
                .margin({ left: 12, top: 12 })
              }
              .width('100%')
            }
          }, item => item.toString())
        }
        .padding({ left: 12, right: 12, bottom: 12 })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .backgroundImageSize({ width: '100%', height: '25%' })
      .backgroundImage($r('app.media.home_mask'), ImageRepeat.NoRepeat)

      Divider()
        .color($r('app.color.divider2'))
        .height(0.5)
    }
    .width('100%')
    .height('100%')
  }
}