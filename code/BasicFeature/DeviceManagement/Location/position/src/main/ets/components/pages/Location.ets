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

import display from '@ohos.display'
import Logger from '../util/Logger'
import geolocation from '@ohos.geolocation'
import { listData, heatCity } from '../mock/LocationMock'
import { MyDataSource } from '../util/DataSource'
import httpRequestResponse from '../net/HttpRequestResponse'

const TAG: string = '[Location]'

@Entry
@Component
export struct Location {
  @State alphabetIndex: number = 0
  @State location: boolean = true
  @State isCity: string = ''
  @State currentLocation: string = ''
  @State @Watch('positionChange') latitude: number = 0
  @State @Watch('positionChange') longitude: number = 0
  @State city: string = ''
  @State isShow: boolean = true
  private controller: TabsController = new TabsController()
  private tabValue: string[] = ['A', 'B', 'C', 'F', 'G', 'H', 'J', 'L', 'N', 'Q', 'S', 'T', 'X', 'Y', 'Z']
  private scroller: Scroller = new Scroller()
  private mockUrl = 'https://gitee.com/openharmony/applications_app_samples/raw/OpenHarmony_4.X_Dev/DataMock/LocationCity/mock.json'

  async positionChange() {
    Logger.info(TAG, `latitude = ${this.latitude}, longitude = ${this.longitude}`)
    await this.requestResponse()
  }

  async aboutToDisappear() {
    await geolocation.off('locationChange')
  }

  async requestResponse() {
    Logger.info(TAG, `enter requestResponse`)
    try {
      let httpResponse = await httpRequestResponse.httpRequest(this.mockUrl, this.latitude, this.longitude)
      Logger.info(TAG, `http response = ${JSON.stringify(httpResponse)}`)
      let requestResponse = JSON.parse(httpResponse.result.toString())
      this.city = requestResponse.data
      Logger.info(TAG, `this.city = ${JSON.stringify(this.city)}`)
    } catch (error) {
      Logger.info(TAG, `http request error: ${JSON.stringify(error)}`)
    }
  }

  locationChange = async (location) => {
    Logger.info(TAG, `locationChange location =${JSON.stringify(location)}`)
    this.latitude = location.latitude
    this.longitude = location.longitude
  }

  async getLocation() {
    Logger.info(TAG, `enter getLocation`)
    let requestInfo: geolocation.LocationRequest = {
      priority: 0x203, // 快速获取位置优先，如果应用希望快速拿到1个位置，可以将优先级设置为该字段
      scenario: 0x300, // 未设置场景信息
      timeInterval: 0, // 上报位置信息的时间间隔
      distanceInterval: 100, // 上报位置信息的距离间隔
      maxAccuracy: 100 // 精度信息
    }
    Logger.info(TAG, `on locationChange before`)
    geolocation.on('locationChange', requestInfo, this.locationChange)
    Logger.info(TAG, `on locationChange end`)
  }

  build() {
    Panel(this.isShow) {
      Column() {
        Column() {
          Text($r('app.string.deliver_to'))
            .fontSize(25)
            .margin({ bottom: 30 })
            .alignSelf(ItemAlign.Start)
          if (this.currentLocation) {
            Text(`${this.currentLocation}` || $r('app.string.xian'))
              .fontSize(20)
              .alignSelf(ItemAlign.Start)
          } else {
            Text($r('app.string.current_positioning'))
              .fontSize(20)
              .opacity(0.6)
              .alignSelf(ItemAlign.Start)
          }
        }
        .width('100%')
        .height(100)
        .margin({ top: 20 })

        Row() {
          Image($r("app.media.location"))
            .width(22)
            .height(22)
            .aspectRatio(1)
            .padding({ left: 4 })
          Text(this.city === '' ? $r('app.string.xian') : this.city)
            .fontSize(20)
            .fontColor('#E92F4F')
            .margin({ left: 12 })
            .padding({ right: 3, top: 2 })
        }
        .alignSelf(ItemAlign.Start)
        .justifyContent(FlexAlign.Center)
        .width(90)
        .height(40)
        .borderRadius(20)
        .borderWidth(1)
        .borderColor('#E92F4F')
        .onClick(async () => {
          Logger.info(TAG, `enter getLocation onClick`)
          await this.getLocation()
        })

        Column() {
          Stack({ alignContent: Alignment.End }) {
            Column() {
              Row() {
                Text($r('app.string.domestic_hot_city'))
                  .fontSize(20)
                  .fontColor('#000000')
                  .opacity(0.6)
              }
              .alignSelf(ItemAlign.Start)
              .margin({ top: 10, bottom: 15 })

              Grid() {
                LazyForEach(new MyDataSource(heatCity), (item, index) => {
                  GridItem() {
                    Text(`${item}`)
                      .margin({ bottom: 20 })
                      .fontSize(20)
                      .maxLines(3)
                      .fontColor('#000000')
                      .onClick(() => {
                        this.currentLocation = item
                      })
                  }
                  .key("city" + (index + 1))

                })
              }
              .margin({ right: 60, top: 10 })
              .width('100%')
              .height(130)
              .columnsTemplate('1fr 1fr 1fr 1fr')

              List({ space: 15, initialIndex: 0, scroller: this.scroller }) {
                LazyForEach(new MyDataSource(listData), (firstItem) => {
                  ListItem() {
                    Column() {
                      Text(`${firstItem.name}`)
                        .height(30)
                        .fontSize(24)
                        .fontColor('#000000')
                        .width('100%')
                        .margin({ top: 10 })
                      Divider()
                        .strokeWidth(0.8)
                        .color('#000000')
                        .opacity(0.2)
                        .margin({ right: 10, top: 12 })

                      ForEach(firstItem.city, (item, index) => {
                        Text(`${item.name === undefined ? item : item.name}`)
                          .height(30)
                          .fontSize(20)
                          .width('100%')
                          .margin({ top: 16 })
                          .onClick(() => {
                            this.currentLocation = item.name === undefined ? item : item.name
                            if (this.isCity === item.name) {
                              Logger.info(TAG, `item.name = ${item.name === undefined ? item : item.name}`)
                              this.isCity = ''
                            } else {
                              this.isCity = item.name === undefined ? item : item.name
                            }
                          })
                          .key("city_ah")
                        if (this.isCity === item.name) {
                          List() {
                            ForEach(item.city, (secondCity) => {
                              ListItem() {
                                Column() {
                                  Text(`${secondCity}`)
                                    .width('100%')
                                    .height(30)
                                    .fontSize(18)
                                    .margin({ top: 4 })
                                    .key("region" + (index + 1))
                                    .onClick(() => {
                                      this.currentLocation = `${item.name}/${secondCity}`
                                    })
                                }
                              }
                            })
                          }
                          .height('9%')
                          .width('100%')
                        }
                      })
                    }
                  }
                })
              }
              .height(580)
              .width('100%')
              .edgeEffect(EdgeEffect.None)
              .listDirection(Axis.Vertical)
              .onScrollIndex((firstIndex: number) => {
                this.alphabetIndex = firstIndex
              })
            }

            Column() {
              AlphabetIndexer({ arrayValue: this.tabValue, selected: this.alphabetIndex })
                .height('100%')
                .font({ size: 16 })
                .popupColor('#FFFFFF') // 弹出框颜色
                .selectedBackgroundColor(0xCCCCCC) // 选中背景颜色
                .popupBackground(0xCCCCCC) // 弹出框背景颜色
                .usingPopup(true) // 是否显示弹出框
                .selectedFont({ size: 16, style: FontStyle.Normal }) // 选中的样式
                .selectedColor('#969494') // 选中颜色
                .popupFont({ size: 30, weight: FontWeight.Bolder }) // 弹出框的演示
                .alignStyle(this.location ? IndexerAlign.Right : IndexerAlign.Left)
                .onSelect((TabIndex: number) => {
                  this.scroller.scrollToIndex(TabIndex)
                })
            }
            .position({ x: '97%' })
            .margin({ top: 4 })
          }
        }
      }
      .width('100%')
      .padding({ left: '6.7%', right: '6.7%', top: 20 })
      .backgroundColor('#F1F3F5')
      .borderRadius({ topLeft: 40, topRight: 40 })
    }
    .dragBar(true)
    .mode(PanelMode.Full)
  }
}