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

import Logger from '../model/Logger'
import { RadioStatus } from '../model/RadioStatus'
import { ResultModel } from '../model/ResultModel'

const TAG = '[PanelView]'

@Component
export struct PanelView {
  @Link show: boolean
  @Link slotId: number
  @Link title: string
  @State statusArray: Array<ResultModel> = []
  @State radioStatus: RadioStatus = new RadioStatus()
  @State slotIdArray: Array<number> = [0, 1]
  @State statusFirstArray: Array<ResultModel> = []
  @State statusSecondArray: Array<ResultModel> = []

  async aboutToAppear() {
    this.slotIdArray.forEach((slotId) => {
      this.radioStatus.getRadioTech(slotId).then((radioTech) => {
        Logger.info(`${TAG}, aboutToAppear radioTech = ${JSON.stringify(radioTech)}`)
        let result = new ResultModel('RadioTech', JSON.stringify(radioTech))
        if (slotId === 0) {
          this.statusFirstArray.push(result)
        } else if (slotId === 1) {
          this.statusSecondArray.push(result)
        }
      })

      this.radioStatus.getSignalInformation(slotId).then((signalInformation) => {
        Logger.info(`${TAG}, aboutToAppear signalInformation = ${JSON.stringify(signalInformation)}`)
        let result = new ResultModel('SignalInformation', JSON.stringify(signalInformation))
        if (slotId === 0) {
          this.statusFirstArray.push(result)
        } else if (slotId === 1) {
          this.statusSecondArray.push(result)
        }
      })

      this.radioStatus.getNetworkSelectionMode(slotId).then((networkSelectionMode) => {
        Logger.info(`${TAG}, aboutToAppear networkSelectionMode = ${JSON.stringify(networkSelectionMode)}`)
        let result = new ResultModel('NetworkSelectionMode', JSON.stringify(networkSelectionMode))
        if (slotId === 0) {
          this.statusFirstArray.push(result)
        } else if (slotId === 1) {
          this.statusSecondArray.push(result)
        }
      })

      this.radioStatus.getISOCountryCodeForNetwork(slotId).then((iSOCountryCode) => {
        Logger.info(`${TAG}, aboutToAppear iSOCountryCode = ${JSON.stringify(iSOCountryCode)}`)
        let result = new ResultModel('ISOCountryCodeForNetwork', JSON.stringify(iSOCountryCode))
        if (slotId === 0) {
          this.statusFirstArray.push(result)
        } else if (slotId === 1) {
          this.statusSecondArray.push(result)
        }
      })
    })
  }

  build() {
    Panel(this.show) {
      Column() {
        Text(this.title)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 10 })
        Divider()
        ForEach(this.slotId === 0 ? this.statusFirstArray : this.statusSecondArray, item => {
          Column() {
            Text(item.title)
              .fontSize(20)
              .fontColor(Color.Grey)
              .margin({ top: 10 })
            Text(item.value)
              .fontSize(20)
          }
        }, item => JSON.stringify(item)
        )
      }
    }
    .type(PanelType.Foldable)
    .mode(PanelMode.Half)
    .dragBar(true)
    .halfHeight(500)
    .onChange((value: any) => {
      Logger.info(`${TAG}, onChange`)
    })
    .onClick(() => {
      this.show = false
    })
  }
}