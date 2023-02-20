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

import { InformationModel } from '../../model/homeModel'
import { informationData } from '../../data/homeData'

class informationNum implements IDataSource {
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

  num: number = 16
  listeners: DataChangeListener[] = []
}
@Component
export struct Information {
  @State information: Array<InformationModel> = informationData
  informationNum: informationNum = new informationNum()
  @Prop ratio: number

  build() {
    Column() {
      Column() {
        Row() {
          Text('消息')
            .fontSize(20 * this.ratio)
            .fontWeight(FontWeight.Bolder)
          Row() {
            Image('/resources/icon/smile.png')
              .width(25 * this.ratio)
              .aspectRatio(1)
              .objectFit(ImageFit.Contain)
            Image('/resources/icon/smile.png')
              .width(25 * this.ratio)
              .aspectRatio(1)
              .objectFit(ImageFit.Contain)
              .margin({ left: 20 })
          }
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)
        .padding({ left: 10, right: 10 })
        .margin({ top: 10, bottom: 10 })
      }
      .backgroundColor('#dfe5e3')

      Row() {
        Column() {
          Row() {
            Row() {
              Text('@')
                .fontSize(15 * this.ratio)
                .fontColor('#40000000')
              Image('/resources/icon/ring.png')
                .width(20 * this.ratio)
                .aspectRatio(1)
                .objectFit(ImageFit.Contain)
              Image('/resources/icon/ring.png')
                .width(20 * this.ratio)
                .aspectRatio(1)
                .objectFit(ImageFit.Contain)
              Image('/resources/icon/ring.png')
                .width(20 * this.ratio)
                .aspectRatio(1)
                .objectFit(ImageFit.Contain)
            }
            .justifyContent(FlexAlign.SpaceBetween)
            .alignItems(VerticalAlign.Center)
            .width('40%')

            Image('/resources/icon/more.png')
              .width(20 * this.ratio)
              .aspectRatio(1)
              .objectFit(ImageFit.Contain)
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)
          .margin({ bottom: 10 })

          Grid() {
            LazyForEach(this.informationNum, item => {
              GridItem() {
                Row() {
                  Column() {
                    Image(this.information[item].uri)
                      .width(55 * this.ratio)
                      .aspectRatio(1)
                      .objectFit(ImageFit.Contain)
                      .border({ radius: 30 })
                  }

                  Column() {
                    Row() {
                      Text(this.information[item].title)
                        .fontSize(14 * this.ratio)
                      Text(item.time)
                        .fontSize(13 * this.ratio)
                        .fontColor(Color.Gray)
                    }
                    .justifyContent(FlexAlign.SpaceBetween)
                    .alignItems(VerticalAlign.Center)

                    Text(this.information[item].notice)
                      .fontSize(13 * this.ratio)
                      .fontColor(Color.Grey)
                      .margin({ top: 5, bottom: 10 })
                    Divider()
                      .strokeWidth(1)
                      .color('#10000000')
                      .margin({ top: 5 })
                  }
                  .padding({ left: 10, top: 10, bottom: 10 })
                  .alignItems(HorizontalAlign.Start)
                }
                .alignItems(VerticalAlign.Center)
              }
            }, item => item.toString())
          }
          .columnsTemplate('1fr')
        }
        .padding(10)
        .backgroundColor(Color.White)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
    }
    .width('100%')
  }
}