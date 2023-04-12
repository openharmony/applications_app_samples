/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import { NetworkMobile } from '../model/NetworkMobile'

@Component
export struct NetWork {
  @State slotId: number = -1
  @State cellularData: boolean = false
  @State cellularDataRoaming: boolean = false
  @State flowState: Resource = $r('app.string.none')
  @State mobileDataState: Resource = $r('app.string.unknown')
  private netWorkMobile: NetworkMobile = new NetworkMobile()

  async aboutToAppear() {
    this.slotId = await this.netWorkMobile.getDefaultCellularDataSlotId()
    this.cellularData = await this.netWorkMobile.isCellularDataEnabled()
    this.cellularDataRoaming = await this.netWorkMobile.isCellularDataRoamingEnabled(this.slotId)
    this.flowState = await this.netWorkMobile.getCellularDataFlowType()
    this.mobileDataState = await this.netWorkMobile.getCellularDataState()
  }

  @Builder dataState($$: {text: Resource, flag: boolean}) {
    Row() {
      Text($$.text)
        .margin({ left: 10 })
        .fontSize(20)
        .width('55%')
        .textAlign(TextAlign.Start)

      Text($$.flag === true ? $r('app.string.start') : $r('app.string.end'))
        .fontSize(20)
        .margin({ left: 10, right: 6 })
        .textAlign(TextAlign.Center)
        .layoutWeight(1)
    }
    .margin(10)
    .height('8%')
  }

  @Builder netWorkState($$: {info: Resource, result: Resource}) {
    Column() {
      Row() {
        Text($$.info)
          .margin({ left: 10 })
          .fontSize(20)
          .width('55%')
          .textAlign(TextAlign.Start)
          .layoutWeight(1)

        Blank()
      }

      Row() {
        Text($$.result)
          .margin({ left: 10 })
          .fontSize(18)
          .width('55%')
          .textAlign(TextAlign.Start)
          .layoutWeight(1)

        Blank()
      }
    }
    .margin(10)
    .height('8%')
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.sim'))
          .margin({ left: 10 })
          .fontSize(20)
          .width('60%')
          .textAlign(TextAlign.Start)
        Row() {
          Text($r('app.string.simOne'))
            .margin(5)
            .fontSize(20)
            .width('40%')
            .borderRadius(10)
            .textAlign(TextAlign.Center)
            .backgroundColor(this.slotId === 0 ? '#0D9FFB' : undefined)

          Text($r('app.string.simTwo'))
            .margin(5)
            .fontSize(20)
            .width('40%')
            .borderRadius(10)
            .textAlign(TextAlign.Center)
            .backgroundColor(this.slotId === 1 ? '#0D9FFB' : undefined)
        }
        .width('35%')
        .borderRadius(10)
        .backgroundColor('#fff5f5f5')
      }
      .height('8%')
      .margin({ right: 10, bottom: 10 })

      Divider()

      this.dataState({text: $r('app.string.mobile'), flag: this.cellularData})

      Divider()

      this.dataState({text: $r('app.string.roaming'), flag: this.cellularDataRoaming})

      Divider()

      this.netWorkState({info: $r('app.string.flow'), result: this.flowState})

      Divider()

      this.netWorkState({info: $r('app.string.connectData'), result: this.mobileDataState})
    }
    .width('100%')
    .height('100%')
  }
}