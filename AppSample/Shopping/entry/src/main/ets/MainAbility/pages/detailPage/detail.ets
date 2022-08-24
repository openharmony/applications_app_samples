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

import mediaQuery from '@ohos.mediaquery';
import router from '@ohos.router';
import { SwiperModel, PhoneTypeModel, ShowImgModel, RecommendDataModel, GoodsInfoModel, ListDataModel
} from "../../model/detailModel"
import { swiperData, phoneTypeData, showImgData, recommendData, goodsInfoData, listData } from '../../data/detailData'

let portraitDetail = null

class DataSourceDetail1 implements IDataSource {
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

  num: number = 23
  listeners: DataChangeListener[] = []
}

class DataSourceDetail2 implements IDataSource {
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

  num: number = 23
  listeners: DataChangeListener[] = []
}

@Entry
@Component
struct Detail {
  @State width: number = router.getParams()['num']
  @State ratio: number = router.getParams()['ratio']
  @State active: boolean = false
  dataSourceDetail1: DataSourceDetail1 = new DataSourceDetail1()
  dataSourceDetail2: DataSourceDetail2 = new DataSourceDetail2()
  @State swiper: Array<SwiperModel> = swiperData
  @State phoneType: Array<PhoneTypeModel> = phoneTypeData
  @State showImg: Array<ShowImgModel> = showImgData
  @State recommendData: Array<RecommendDataModel> = recommendData
  @State goodsList: Array<GoodsInfoModel> = goodsInfoData
  @State listImg: Array<ListDataModel> = listData
  @State collected: boolean = false
  @State opacity: number= 1
  listener= mediaQuery.matchMediaSync('(orientation:landscape)');

  aboutToAppear() {
    portraitDetail = this.onPortrait.bind(this);
    this.listener.on('change', portraitDetail);
  }

  async onPortrait(mediaQueryResult) {
    let result = mediaQueryResult.matches
    if (result) {
      this.width = 45
    } else {
      this.width = 100
    }
  }

  build() {
    Column() {
      List() {
        ListItem() {
          Row() {
            Row() {
              Navigator() {
                Image('/resources/icon/back.png')
                  .key('leftDetailPageBtn')
                  .objectFit(ImageFit.Contain)
                  .width(25 * this.ratio)
                  .aspectRatio(1)
              }
              .active(this.active)
              .onClick(() => {
                this.active = true
              })
            }

            Row() {
              Image('/resources/icon/search.png')
                .objectFit(ImageFit.Contain)
                .width(50 * this.ratio)
                .height(30 * this.ratio)
              Image('/resources/icon/attention.png')
                .objectFit(ImageFit.Contain)
                .width(50 * this.ratio)
                .height(30 * this.ratio)
              Image('/resources/icon/more.png')
                .objectFit(ImageFit.Contain)
                .width(50 * this.ratio)
                .height(30 * this.ratio)
            }
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)
          .height(40 * this.ratio)
          .backgroundColor(Color.White)
        }

        ListItem() {
          Swiper() {
            Image(this.swiper[0].src)
              .objectFit(ImageFit.Contain)
            Image(this.swiper[1].src)
              .objectFit(ImageFit.Contain)
            Image(this.swiper[2].src)
              .objectFit(ImageFit.Contain)
          }
          .index(0)
          .width('100%')
          .height('40%')
        }

        ListItem() {
          Column() {
            Text('卖家促销')
              .fontSize(12 * this.ratio)
              .fontColor(Color.Red)
              .margin({ top: 10, bottom: 5 })
            Text() {
              Span('￥')
                .fontSize(10 * this.ratio)
                .fontColor(Color.Red)
              Span('4500')
                .fontSize(13 * this.ratio)
                .fontColor(Color.Red)
            }
            .margin({ top: 5, bottom: 5 })
          }
          .alignItems(HorizontalAlign.Start)
          .width('100%')
        }

        ListItem() {
          Row() {
            Text('购物金币可抵56.60元')
              .fontSize(15 * this.ratio)
              .fontColor('#d2691e')
              .backgroundColor('#10d2691e')
              .border({ radius: 10 * this.ratio })
              .padding({ left: 3, right: 3 })
            Text('商品券满500减50')
              .fontSize(15 * this.ratio)
              .fontColor('#d2691e')
              .backgroundColor('#10d2691e')
              .border({ radius: 10 * this.ratio })
              .padding({ left: 3, right: 3 })

            Row() {
              Text('领券>')
                .fontSize(15 * this.ratio)
                .fontColor('#d2691e')
            }
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)
          .margin({ top: 5, bottom: 5 })
        }

        ListItem() {
          Column() {
            Row() {
              Text('【首降600+12期免息】XX/XXMate 40 Pro 5G 全网通 (亮黑色) 超大内存 极快网速 全球n多人的选择，你值得拥有')
                .fontSize(14 * this.ratio)
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .width('83%')
              Image('/resources/icon/arrow_right.png')
                .objectFit(ImageFit.Contain)
                .width(20 * this.ratio)
                .height(15 * this.ratio)
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .alignItems(VerticalAlign.Center)

            Row() {
              Text('Mate 40')
                .fontSize(12 * this.ratio)
              Text('|')
                .fontSize(12)
                .fontColor(Color.Grey)
                .margin({ left: 5, right: 5 })
              Text('内存:256G')
                .fontSize(12 * this.ratio)
              Text('|')
                .fontSize(12)
                .fontColor(Color.Grey)
                .margin({ left: 5, right: 5 })
              Text('多功能')
                .fontSize(12 * this.ratio)
              Text('|')
                .fontSize(12)
                .fontColor(Color.Grey)
                .margin({ left: 5, right: 5 })
              Text('性价比高')
                .fontSize(12 * this.ratio)

            }
            .margin({ top: 10, bottom: 5 })
            .width('100%')

          }
          .alignItems(HorizontalAlign.Start)
          .margin({ top: 10 })
        }

        ListItem() {
          Row() {
            Row() {
              Column() {
                Image('/resources/icon/attention.png')
                  .width(25 * this.ratio)
                  .aspectRatio(1)
                  .objectFit(ImageFit.Contain)
                Text('进店')
                  .fontSize(12 * this.ratio)
              }

              Column() {
                Image(`${this.collected ? '/resources/icon/hearted.png' : '/resources/icon/heart.png'}`)
                  .width(25 * this.ratio)
                  .aspectRatio(1)
                  .objectFit(ImageFit.Contain)
                Text('收藏')
                  .fontSize(12 * this.ratio)
              }.onClick(() => {
                this.collected = !this.collected
              })

              Column() {
                Image('/resources/icon/comments.png')
                  .width(25 * this.ratio)
                  .aspectRatio(1)
                  .objectFit(ImageFit.Contain)
                Text('评价')
                  .fontSize(12 * this.ratio)
              }

              Column() {
                Image('/resources/icon/share.png')
                  .width(25 * this.ratio)
                  .aspectRatio(1)
                  .objectFit(ImageFit.Contain)
                Text('分享')
                  .fontSize(12 * this.ratio)
              }
            }
            .width('55%')
            .justifyContent(FlexAlign.SpaceBetween)
            .alignItems(VerticalAlign.Center)

            Row() {
              Row() {
                Image('/resources/icon/highlight.png')
                  .width(30 * this.ratio)
                  .aspectRatio(1)
                  .objectFit(ImageFit.Contain)
                  .padding(3)
              }
              .backgroundColor('#f4af08')
              .padding({ left: 7, right: 7 })

              Row() {
                Text('购买')
                  .fontSize(15 * this.ratio)
                  .fontColor(Color.White)
              }
              .backgroundColor('#ed4704')
              .height(30 * this.ratio)
              .padding({ left: 13, right: 23 })
            }
            .height(30 * this.ratio)
            .clip(true)
            .border({ radius: 20 * this.ratio })
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)
          .margin({ top: 10, bottom: 5 })
        }

        ListItem() {
          Row() {
            Text('发货')
              .fontSize(15 * this.ratio)
            Row() {
              Row() {
                Image('/resources/icon/local.png')
                  .objectFit(ImageFit.Contain)
                  .width(25 * this.ratio)
                  .aspectRatio(1)
                  .margin({ right: 5 })
                Text('广东深圳')
                  .fontSize(15 * this.ratio)

              }

              Row() {
                Text('快递:')
                  .fontSize(15 * this.ratio)
                Text('0.00')
                  .fontSize(15 * this.ratio)
              }

              Text('月销2.0万+')
                .fontSize(15 * this.ratio)

            }
            .justifyContent(FlexAlign.SpaceBetween)
            .alignItems(VerticalAlign.Center)
            .width('85%')
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)
          .margin({ top: 10, bottom: 5 })
        }

        ListItem() {
          Row() {
            Text('活动')
              .fontSize(15 * this.ratio)
            Column() {
              Row() {
                Row() {
                  Image('/resources/detailImg/deliver/deliver_logo3.png')
                    .objectFit(ImageFit.Contain)
                    .height('35%')
                    .width('30%')
                    .margin({ right: 10 })
                  Text('旧机回收，以旧换新')
                    .fontSize(15 * this.ratio)
                }

                Image('/resources/icon/arrow_right.png')
                  .objectFit(ImageFit.Contain)
                  .width(20 * this.ratio)
                  .height(15 * this.ratio)
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceBetween)
              .alignItems(VerticalAlign.Center)

              Row() {
                Row() {
                  Image('/resources/detailImg/deliver/deliver_logo3.png')
                    .objectFit(ImageFit.Contain)
                    .height('35%')
                    .width('30%')
                    .margin({ right: 10 })
                  Text('下单送私房红包最高99元')
                    .fontSize(15 * this.ratio)

                }

                Image('/resources/icon/arrow_right.png')
                  .objectFit(ImageFit.Contain)
                  .width(20 * this.ratio)
                  .height(15 * this.ratio)
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceBetween)
              .alignItems(VerticalAlign.Center)
            }
            .width('85%')
            .height(70 * this.ratio)
            .justifyContent(FlexAlign.SpaceAround)
            .alignItems(HorizontalAlign.Center)
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)
          .margin({ top: 5 })
        }

        ListItem() {
          Row() {
            Text('保障')
              .fontSize(15 * this.ratio)
            Row() {
              Text('假一赔十·免举证退换货·全国联保·极速退款')
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .width('70%')
                .fontSize(15 * this.ratio)
              Image('/resources/icon/arrow_right.png')
                .objectFit(ImageFit.Contain)
                .width(20 * this.ratio)
                .height(15 * this.ratio)
            }
            .width('85%')
            .justifyContent(FlexAlign.SpaceBetween)
            .alignItems(VerticalAlign.Center)
          }
          .width('100%')
          .margin({ top: 5, bottom: 10 })
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)
        }

        ListItem() {
          Column() {
            Row() {
              Text('选择')
                .fontSize(15 * this.ratio)
              Column() {
                Row() {
                  Text('配送至：昌平区，选择，存储量，机身颜色，网络')
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .width('70%')
                    .fontSize(15 * this.ratio)
                  Image('/resources/icon/arrow_right.png')
                    .objectFit(ImageFit.Contain)
                    .width(20 * this.ratio)
                    .height(15 * this.ratio)
                }
                .width('85%')
                .justifyContent(FlexAlign.SpaceBetween)
                .alignItems(VerticalAlign.Center)
              }
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .alignItems(VerticalAlign.Center)
            .margin({ top: 5, bottom: 5 })

            Row() {
              Text()
              Row() {
                Image(this.phoneType[0].uri)
                  .objectFit(ImageFit.Contain)
                  .width(35 * this.ratio)
                Image(this.phoneType[1].uri)
                  .objectFit(ImageFit.Contain)
                  .width(35 * this.ratio)
                Image(this.phoneType[2].uri)
                  .objectFit(ImageFit.Contain)
                  .width(35 * this.ratio)
                Image(this.phoneType[3].uri)
                  .objectFit(ImageFit.Contain)
                  .width(35 * this.ratio)
                Image(this.phoneType[4].uri)
                  .objectFit(ImageFit.Contain)
                  .width(35 * this.ratio)
                Text('共5种机身颜色可选')
                  .fontSize(13 * this.ratio)
              }
              .justifyContent(FlexAlign.SpaceBetween)
              .alignItems(VerticalAlign.Center)
              .width('95%')

            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .alignItems(VerticalAlign.Center)
            .height(50 * this.ratio)
          }
        }

        ListItem() {
          Column() {
            Row() {
              Text('宝贝评价(48088)')
                .fontSize(15 * this.ratio)
              Row() {
                Text('查看全部')
                  .fontSize(15 * this.ratio)
                  .fontColor('#d2691e')
                Image('/resources/icon/arrow_right.png')
                  .objectFit(ImageFit.Contain)
                  .width(20 * this.ratio)
                  .height(15 * this.ratio)
                  .margin({ left: 10 })
              }
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .alignItems(VerticalAlign.Center)
            .margin({ top: 5, bottom: 10 })

            Text('购买过该商品的用户认为')
              .fontSize(15 * this.ratio)
              .margin({ bottom: 10 })

            Column() {
              Row() {
                Image('/resources/common/user.png')
                  .objectFit(ImageFit.Contain)
                  .width(30 * this.ratio)
                  .aspectRatio(1)
                  .margin({ right: 10 })
                  .border({ radius: 50 * this.ratio })
                Text('user')
                  .fontSize(15 * this.ratio)
              }
              .width('100%')

              Text('相对而言，XX手机有着更高的网速，更高的内存，更清晰的画质以及更少的耗电量')
                .fontSize(15 * this.ratio)

            }
            .width('100%')
            .padding({ left: 10, right: 10 })

          }
          .alignItems(HorizontalAlign.Start)
          .margin({ top: 3, bottom: 3 })
        }

        ListItem() {
          Row() {
            Text('参数')
              .fontSize(15 * this.ratio)
            Row() {
              Text('网络类型 XX型号种类')
                .fontSize(15 * this.ratio)
              Image('/resources/icon/arrow_right.png')
                .objectFit(ImageFit.Contain)
                .width(20 * this.ratio)
                .height(15 * this.ratio)
            }
            .justifyContent(FlexAlign.SpaceBetween)
            .alignItems(VerticalAlign.Center)
            .width('85%')
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)
          .margin({ top: 5, bottom: 5 })
        }

        ListItem() {
          Column() {
            Row() {
              Text('XX手机买家秀(91)')
                .fontSize(15 * this.ratio)
              Row() {
                Text('查看全部')
                  .fontSize(15 * this.ratio)
                  .fontColor('#d2691e')
                Image('/resources/icon/arrow_right.png')
                  .objectFit(ImageFit.Contain)
                  .width(20 * this.ratio)
                  .height(15 * this.ratio)
                  .margin({ left: 10 })
              }
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .alignItems(VerticalAlign.Center)
            .margin({ top: 10, bottom: 10 })

            Row() {
              Image(this.showImg[0].uri)
                .objectFit(ImageFit.Cover)
                .width('25%')
                .height(100 * this.ratio)
              Image(this.showImg[1].uri)
                .objectFit(ImageFit.Cover)
                .width('25%')
                .height(100 * this.ratio)
              Image(this.showImg[2].uri)
                .objectFit(ImageFit.Cover)
                .width('25%')
                .height(100 * this.ratio)
              Image(this.showImg[3].uri)
                .objectFit(ImageFit.Cover)
                .width('25%')
                .height(100 * this.ratio)

            }
          }
        }

        ListItem() {
          Column() {
            Row() {
              Text('购机回访(1643)')
                .fontSize(15 * this.ratio)
              Row() {
                Text('查看全部')
                  .fontSize(15 * this.ratio)
                  .fontColor('#d2691e')
                Image('/resources/icon/arrow_right.png')
                  .objectFit(ImageFit.Contain)
                  .width(20 * this.ratio)
                  .height(15 * this.ratio)
                  .margin({ left: 10 })
              }
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .alignItems(VerticalAlign.Center)
            .margin({ top: 10, bottom: 10 })

            Row() {
              Image('/resources/icon/phoneCall.png')
                .objectFit(ImageFit.Contain)
                .width(20 * this.ratio)
                .height(20 * this.ratio)
                .margin({ right: 5 })

              Row() {
                Text('5G手机是双卡吗，5G手机可以用一张...')
                  .fontSize(15 * this.ratio)
                Text('3个回答')
                  .fontSize(15 * this.ratio)
              }
              .flexGrow(1)
              .justifyContent(FlexAlign.SpaceBetween)
              .alignItems(VerticalAlign.Center)
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .alignItems(VerticalAlign.Center)
            .margin({ top: 5, bottom: 5 })

            Row() {
              Image('/resources/icon/phoneCall.png')
                .objectFit(ImageFit.Contain)
                .width(20 * this.ratio)
                .aspectRatio(1)
                .margin({ right: 5 })
              Row() {
                Text('有没有用5G套餐的 一个月最低...')
                  .fontSize(15 * this.ratio)
                Text('1个回答')
                  .fontSize(15 * this.ratio)
              }
              .flexGrow(1)
              .justifyContent(FlexAlign.SpaceBetween)
              .alignItems(VerticalAlign.Center)
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .alignItems(VerticalAlign.Center)
            .margin({ top: 5, bottom: 5 })
          }
          .margin({ top: 10 })
        }

        ListItem() {
          Column() {
            Row() {
              Row() {
                Image('/resources/detailImg/evaluation/evaluation_logo.jpg')
                  .objectFit(ImageFit.Contain)
                  .width(40 * this.ratio)
                  .aspectRatio(1)
                  .margin({ right: 10 })
                Column() {
                  Text('XX官方旗舰店')
                    .fontSize(17 * this.ratio)
                  Row() {
                    Image('/resources/detailImg/evaluation/evaluation_logo2.png')
                      .objectFit(ImageFit.Contain)
                      .width('20%')
                      .height(15 * this.ratio)
                    Image('/resources/detailImg/evaluation/evaluation_logo3.png')
                      .objectFit(ImageFit.Contain)
                      .width('20%')
                      .height(15 * this.ratio)
                  }
                }
                .alignItems(HorizontalAlign.Start)
                .margin({ top: 5, bottom: 5 })
              }

              Row() {
                Image('/resources/detailImg/evaluation/evaluation_logo3.png')
                  .objectFit(ImageFit.Contain)
                  .width('45%')
                  .margin({ right: 10 })

                Image('/resources/detailImg/evaluation/evaluation_logo3.png')
                  .objectFit(ImageFit.Contain)
                  .width('45%')
              }
              .width('45%')
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .alignItems(VerticalAlign.Center)

            Row() {
              Text('宝贝描述 4.8 高')
                .fontSize(15 * this.ratio)
              Text('宝贝描述 4.8 高')
                .fontSize(15 * this.ratio)
              Text('宝贝描述 4.8 高')
                .fontSize(15 * this.ratio)
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .alignItems(VerticalAlign.Center)
            .margin({ top: 5 })
          }
        }

        ListItem() {
          Column() {
            Row() {
              Text('店铺推荐(48088)')
                .fontSize(15 * this.ratio)
              Row() {
                Text('查看全部')
                  .fontSize(15)
                  .fontColor('#d2691e')
                Image('/resources/icon/arrow_right.png')
                  .objectFit(ImageFit.Contain)
                  .width(20 * this.ratio)
                  .height(15 * this.ratio)
                  .margin({ left: 10 })

              }
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .alignItems(VerticalAlign.Center)
            .margin({ top: 10, bottom: 10 })

            Column() {
              Row() {
                Column() {
                  Image(this.recommendData[0].img)
                    .objectFit(ImageFit.Contain)
                    .width('100%')
                    .height('55%')
                    .margin({ bottom: 5 })

                  Text(this.recommendData[0].title)
                    .fontSize(15 * this.ratio)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .maxLines(2)
                  Text(this.recommendData[0].price)
                    .fontSize(15 * this.ratio)
                    .fontColor(Color.Red)
                }
                .width('33%')
                .height('48%')
                .alignItems(HorizontalAlign.Start)

                Column() {
                  Image(this.recommendData[1].img)
                    .objectFit(ImageFit.Contain)
                    .width('100%')
                    .height('55%')
                    .margin({ bottom: 5 })

                  Text(this.recommendData[1].title)
                    .fontSize(15 * this.ratio)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .maxLines(2)
                  Text(this.recommendData[1].price)
                    .fontSize(15 * this.ratio)
                    .fontColor(Color.Red)
                }
                .width('33%')
                .height('48%')
                .alignItems(HorizontalAlign.Start)

                Column() {
                  Image(this.recommendData[2].img)
                    .objectFit(ImageFit.Contain)
                    .width('100%')
                    .height('55%')
                    .margin({ bottom: 5 })

                  Text(this.recommendData[2].title)
                    .fontSize(15 * this.ratio)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .maxLines(2)
                  Text(this.recommendData[2].price)
                    .fontSize(15 * this.ratio)
                    .fontColor(Color.Red)
                }
                .width('33%')
                .height('48%')
                .alignItems(HorizontalAlign.Start)
              }

              Row() {
                Column() {
                  Image(this.recommendData[3].img)
                    .objectFit(ImageFit.Contain)
                    .width('100%')
                    .height('55%')
                    .margin({ bottom: 5 })

                  Text(this.recommendData[3].title)
                    .fontSize(15 * this.ratio)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .maxLines(2)
                  Text(this.recommendData[3].price)
                    .fontSize(15 * this.ratio)
                    .fontColor(Color.Red)
                }
                .width('33%')
                .height('48%')
                .alignItems(HorizontalAlign.Start)

                Column() {
                  Image(this.recommendData[4].img)
                    .objectFit(ImageFit.Contain)
                    .width('100%')
                    .height('55%')
                    .margin({ bottom: 5 })

                  Text(this.recommendData[4].title)
                    .fontSize(15 * this.ratio)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .maxLines(2)
                  Text(this.recommendData[4].price)
                    .fontSize(15 * this.ratio)
                    .fontColor(Color.Red)
                }
                .width('33%')
                .height('48%')
                .alignItems(HorizontalAlign.Start)

                Column() {
                  Image(this.recommendData[5].img)
                    .objectFit(ImageFit.Contain)
                    .width('100%')
                    .height('55%')
                    .margin({ bottom: 5 })

                  Text(this.recommendData[5].title)
                    .fontSize(15 * this.ratio)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .maxLines(2)
                  Text(this.recommendData[5].price)
                    .fontSize(15 * this.ratio)
                    .fontColor(Color.Red)
                }
                .width('33%')
                .height('48%')
                .alignItems(HorizontalAlign.Start)
              }
            }
            .justifyContent(FlexAlign.Center)
            .height('45%')
          }
          .margin({ top: 10 })
        }

        ListItem() {
          Column() {
            List() {
              LazyForEach(this.dataSourceDetail1, item => {
                ListItem() {
                  Image(this.goodsList[item].img)
                    .width('100%')
                    .objectFit(ImageFit.Cover)
                }
              }, item => item.img.toString())
            }
            .width('100%')
          }
        }
      }
      .padding({ bottom: 10, left: 10, right: 10 })
      .width(`${this.width}%`)
      .backgroundColor(Color.White)
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
  }

  PageTransition() {
    PageTransitionEnter({ duration: 0 })
      .opacity(1)
    PageTransitionExit({ duration: 0 })
      .opacity(1)
  }
}