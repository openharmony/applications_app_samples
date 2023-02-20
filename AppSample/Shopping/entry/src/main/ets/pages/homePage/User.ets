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

import router from '@ohos.router';
import { RecordModel, OrderModel, DiscountModel, ServiceModel } from '../../model/homeModel'
import { recordData, orderData, discountData, serviceData } from '../../data/homeData'
import { Core2 } from '../../pages/homePage/core2'

@Component
export struct User {
  @State signName: string = '点这里可以添加个性签名'
  @State cardName: string = '用户'
  @State url: string = '/resources/common/user.png'
  @State record: Array<RecordModel> = recordData
  @State orderData: Array<OrderModel> = orderData
  @State discountData: Array<DiscountModel> = discountData
  @State serviceData: Array<ServiceModel> = serviceData
  @Prop num: number
  @Prop ratio: number

  build() {
    Scroll() {
      Column() {
        Row() {
          Image(this.url)
            .width(90 * this.ratio)
            .aspectRatio(1)
            .objectFit(ImageFit.Contain)
            .border({ radius: 45 * this.ratio })
            .margin(10)
          Column() {
            Row() {
              Text(this.cardName)
                .fontSize(15 * this.ratio)
                .fontWeight(FontWeight.Bold)
                .margin({ top: 10, bottom: 5 })
              Row() {
                Image('/resources/icon/code.png')
                  .width(30 * this.ratio)
                  .aspectRatio(1)
                  .objectFit(ImageFit.Contain)
                  .margin({ right: 10 })
                Image('/resources/icon/setting.png')
                  .width(30 * this.ratio)
                  .aspectRatio(1)
                  .objectFit(ImageFit.Contain)
              }
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .alignItems(VerticalAlign.Center)
            .padding({ right: 20 })

            Row() {
              Text(this.signName)
                .fontSize(10 * this.ratio)
                .fontColor(Color.Grey)
                .margin({ right: 5 })
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
              Image('/resources/icon/setting.png')
                .width(10 * this.ratio)
                .aspectRatio(1)
                .objectFit(ImageFit.Contain)
            }
            .width('52%')
            .margin({ top: 5, bottom: 5 })

            Row() {
              Text($r('app.string.user1'))
                .fontSize(10 * this.ratio)
                .margin({ right: 10 })
              Text(' | ')
                .fontSize(10 * this.ratio)
                .fontColor(Color.Grey)
              Text($r('app.string.user2'))
                .fontSize(10 * this.ratio)
                .margin({ right: 10 })
            }
            .margin({ top: 5, bottom: 5 })
          }
          .alignItems(HorizontalAlign.Start)
          .width('70%')
        }

        Row() {
          Column() {
            Image(this.record[0].img)
              .width(30 * this.ratio)
              .aspectRatio(1)
              .objectFit(ImageFit.Contain)
              .margin({ bottom: 5 })
            Text(this.record[0].title)
              .fontSize(10 * this.ratio)
          }
          .onClick(() => {
            router.push({
              url: 'pages/collect/collected',
              params: {
                num: this.num,
                ratio: this.ratio
              }
            })
          })

          Column() {
            Image(this.record[1].img)
              .width(30 * this.ratio)
              .aspectRatio(1)
              .objectFit(ImageFit.Contain)
              .margin({ bottom: 5 })
            Text(this.record[1].title)
              .fontSize(10 * this.ratio)
          }

          Column() {
            Image(this.record[2].img)
              .width(30 * this.ratio)
              .aspectRatio(1)
              .objectFit(ImageFit.Contain)
              .margin({ bottom: 5 })
            Text(this.record[2].title)
              .fontSize(10 * this.ratio)
          }

          Column() {
            Image(this.record[3].img)
              .width(30 * this.ratio)
              .aspectRatio(1)
              .objectFit(ImageFit.Contain)
              .margin({ bottom: 5 })
            Text(this.record[3].title)
              .fontSize(10 * this.ratio)
          }
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceAround)
        .alignItems(VerticalAlign.Center)

        Row() {
          Row() {
            Text('活动')
              .fontSize(12 * this.ratio)
              .fontColor(Color.White)
              .backgroundColor(Color.Orange)
              .padding({ top: 2, bottom: 2, left: 5, right: 5 })
              .border({ radius: 4 * this.ratio })
              .margin({ right: 5 })
            Text('限时充50元送优惠券30元')
              .fontSize(13 * this.ratio)
          }

          Row() {
            Text('去看看')
              .fontSize(14 * this.ratio)
              .fontColor(Color.Grey)
            Image('/resources/icon/arrow_right.png')
              .width(20 * this.ratio)
              .aspectRatio(1)
              .objectFit(ImageFit.Contain)
          }
        }
        .width('100%')
        .margin({ top: 10 })
        .padding(10)
        .backgroundColor(Color.White)
        .border({ radius: 10 * this.ratio })
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)

        Column() {
          Row() {
            Text('我的订单')
              .fontSize(14 * this.ratio)
              .fontWeight(FontWeight.Bolder)
            Row() {
              Text('全部')
                .fontSize(14 * this.ratio)
                .fontColor(Color.Grey)
              Image('/resources/icon/arrow_right.png')
                .width(20 * this.ratio)
                .aspectRatio(1)
                .objectFit(ImageFit.Contain)
            }
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)

          Row() {
            Column() {
              Image(this.orderData[0].img)
                .width(30 * this.ratio)
                .aspectRatio(1)
                .objectFit(ImageFit.Contain)
                .margin({ bottom: 5 })
              Text(this.orderData[0].title)
                .fontSize(12 * this.ratio)
            }

            Column() {
              Image(this.orderData[1].img)
                .width(30 * this.ratio)
                .aspectRatio(1)
                .objectFit(ImageFit.Contain)
                .margin({ bottom: 5 })
              Text(this.orderData[1].title)
                .fontSize(12 * this.ratio)
            }

            Column() {
              Image(this.orderData[2].img)
                .width(30 * this.ratio)
                .aspectRatio(1)
                .objectFit(ImageFit.Contain)
                .margin({ bottom: 5 })
              Text(this.orderData[2].title)
                .fontSize(12 * this.ratio)
            }

            Column() {
              Image(this.orderData[3].img)
                .width(30 * this.ratio)
                .aspectRatio(1)
                .objectFit(ImageFit.Contain)
                .margin({ bottom: 5 })
              Text(this.orderData[3].title)
                .fontSize(12 * this.ratio)
            }

            Column() {
              Image(this.orderData[4].img)
                .width(30 * this.ratio)
                .aspectRatio(1)
                .objectFit(ImageFit.Contain)
                .margin({ bottom: 5 })
              Text(this.orderData[4].title)
                .fontSize(12 * this.ratio)
            }
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)
          .margin({ top: 10 })

          Row() {
            Image('/resources/homeImg/imgLoads/product006.png')
              .width(55 * this.ratio)
              .aspectRatio(1)
              .objectFit(ImageFit.Cover)
              .border({ radius: 5 * this.ratio })
            Column() {
              Row() {
                Text('已签收')
                  .fontSize(13 * this.ratio)
                Text('12-17')
                  .fontSize(12 * this.ratio)
                  .fontColor(Color.Grey)
              }
              .width('90%')
              .justifyContent(FlexAlign.SpaceBetween)
              .alignItems(VerticalAlign.Center)
              .margin({ left: 8 })

              Text('派送成功')
                .fontSize(12 * this.ratio)
                .fontColor(Color.Grey)
                .margin({ left: 8 })
            }
            .height(55 * this.ratio)
            .justifyContent(FlexAlign.SpaceAround)
            .alignItems(HorizontalAlign.Start)
            .backgroundColor('#f8f8fa')
            .width('85%')
            .padding({ right: 10 })
            .border({ radius: 10 })
          }
          .height(55 * this.ratio)
          .width('100%')
          .margin({ top: 10 })
          .alignItems(VerticalAlign.Center)
        }
        .margin({ top: 10 })
        .padding(10)
        .backgroundColor(Color.White)
        .border({ radius: 10 * this.ratio })

        Column() {
          Row() {
            Column() {
              Image(this.discountData[0].img)
                .width(35 * this.ratio)
                .aspectRatio(1)
                .objectFit(ImageFit.Contain)
                .margin({ bottom: 5 })
              Text(this.discountData[0].name)
                .fontSize(12 * this.ratio)
                .margin(5)
              Text(this.discountData[0].text)
                .fontSize(12 * this.ratio)
                .fontColor(Color.Grey)
            }

            Column() {
              Image(this.discountData[1].img)
                .width(35 * this.ratio)
                .aspectRatio(1)
                .objectFit(ImageFit.Contain)
                .margin({ bottom: 5 })
              Text(this.discountData[1].name)
                .fontSize(12 * this.ratio)
                .margin(5)
              Text(this.discountData[1].text)
                .fontSize(12 * this.ratio)
                .fontColor(Color.Grey)
            }

            Column() {
              Image(this.discountData[2].img)
                .width(35 * this.ratio)
                .aspectRatio(1)
                .objectFit(ImageFit.Contain)
                .margin({ bottom: 5 })
              Text(this.discountData[2].name)
                .fontSize(12 * this.ratio)
                .margin(5)
              Text(this.discountData[2].text)
                .fontSize(12 * this.ratio)
                .fontColor(Color.Grey)
            }

            Column() {
              Image(this.discountData[3].img)
                .width(35 * this.ratio)
                .aspectRatio(1)
                .objectFit(ImageFit.Contain)
                .margin({ bottom: 5 })
              Text(this.discountData[3].name)
                .fontSize(12 * this.ratio)
                .margin(5)
              Text(this.discountData[3].text)
                .fontSize(12 * this.ratio)
                .fontColor(Color.Grey)
            }
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)
          .margin({ top: 10 })
        }
        .margin({ top: 10 })
        .padding(10)
        .backgroundColor(Color.White)
        .border({ radius: 10 * this.ratio })

        Column() {
          Row() {
            Column() {
              Image(this.serviceData[0].img)
                .width(30 * this.ratio)
                .aspectRatio(1)
                .objectFit(ImageFit.Contain)
                .margin({ bottom: 5 })
              Text(this.serviceData[0].title)
                .fontSize(12 * this.ratio)
            }

            Column() {
              Image(this.serviceData[1].img)
                .width(30 * this.ratio)
                .aspectRatio(1)
                .objectFit(ImageFit.Contain)
                .margin({ bottom: 5 })
              Text(this.serviceData[1].title)
                .fontSize(12 * this.ratio)
            }

            Column() {
              Image(this.serviceData[2].img)
                .width(30 * this.ratio)
                .aspectRatio(1)
                .objectFit(ImageFit.Contain)
                .margin({ bottom: 5 })
              Text(this.serviceData[2].title)
                .fontSize(12 * this.ratio)
            }

            Column() {
              Image(this.serviceData[3].img)
                .width(30 * this.ratio)
                .aspectRatio(1)
                .objectFit(ImageFit.Contain)
                .margin({ bottom: 5 })
              Text(this.serviceData[3].title)
                .fontSize(12 * this.ratio)
            }
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceAround)
          .alignItems(VerticalAlign.Center)
          .margin({ top: 10 })
        }
        .margin({ top: 10 })
        .padding(10)
        .backgroundColor(Color.White)
        .border({ radius: 10 * this.ratio })

        Column() {
          Core2({ ratio: this.ratio })
        }
        .margin({ top: 10 })
        .padding(10)
        .backgroundColor(Color.White)
        .border({ radius: 10 * this.ratio })
      }
      .padding(10)
      .backgroundColor('#dfe5e3')
    }
    .scrollBar(BarState.Off)
  }
}