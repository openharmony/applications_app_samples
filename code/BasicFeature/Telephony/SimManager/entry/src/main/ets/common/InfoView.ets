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

import sim from '@ohos.telephony.sim'
import Logger from '../model/Logger'
import { SimView } from '../common/SimView'
import { CallView } from '../common/CallView'
import { Show } from '../common/Show'

const TAG = '[InfoView]'
const card1 = 0
const card2 = 1

@Component
export struct InfoView {
  @State data: string = ''
  @State slotId: number = 0
  @State flag: boolean = false
  @State sim1Color: string = '#FFFFFF'
  @State sim2Color: string = '#FFFFFF'
  private sim1Text: Resource = undefined
  private sim2Text: Resource = undefined
  private firstName: string = 'card1'
  private secondNAme: string = 'card2'

  async getColor(slotId: number) {
    let color: string = ''
    try {
      let result = await sim.hasSimCard(slotId)
      Logger.info(TAG, `color result is ${result}`)
      color = result ? '#0D9FFB' : '#FFFFFF'
    } catch (err) {
      color = '#FFFFFF'
      Logger.info(TAG, `err is ${JSON.stringify(err)}`)
    }
    Logger.info(TAG, `color is ${JSON.stringify(color)}`)
    return color
  }

  async getTextData(slotId: number) {
    let flagText: Resource
    try {
      let result = await sim.getSimState(slotId)
      Logger.info(TAG, `getSimState is ${result}`)
      switch (result) {
        case sim.SimState.SIM_STATE_UNKNOWN:
          flagText = $r('app.string.unknown')
          break
        case sim.SimState.SIM_STATE_NOT_PRESENT:
          flagText = $r('app.string.not_present')
          break
        case sim.SimState.SIM_STATE_LOCKED:
          flagText = $r('app.string.locked')
          break
        case sim.SimState.SIM_STATE_NOT_READY:
          flagText = $r('app.string.not_ready')
          break
        case sim.SimState.SIM_STATE_READY:
          flagText = $r('app.string.ready')
          break
        case sim.SimState.SIM_STATE_LOADED:
          flagText = $r('app.string.loaded')
          break
      }
      Logger.info(TAG, `flagText is ${JSON.stringify(flagText)}`)
    } catch (err) {
      flagText = $r('app.string.err')
      Logger.info(TAG, `err is ${JSON.stringify(err)} flagText is ${JSON.stringify(flagText)}`)
    }
    return flagText
  }

  async aboutToAppear() {
    this.sim1Text = await this.getTextData(card1)
    this.sim2Text = await this.getTextData(card2)
    this.sim1Color = await this.getColor(card1)
    this.sim2Color = await this.getColor(card2)
    this.flag = true
    Logger.info(TAG, `sim1Text is ${JSON.stringify(this.sim1Text)} sim2Text is ${JSON.stringify(this.sim2Text)}`)
  }

  build() {
    Scroll() {
      Column() {
        if (this.flag) {
          Show({
            slotId: card1,
            simText: this.sim1Text,
            simColor: this.sim1Color,
            simTitle: $r('app.string.sim1_id'),
            simCard: $r('app.string.sim1_card'),
            idName: this.firstName
          })

          Show({
            slotId: card2,
            simText: this.sim2Text,
            simColor: this.sim2Color,
            simTitle: $r('app.string.sim2_id'),
            simCard: $r('app.string.sim2_card'),
            idName: this.secondNAme
          })
        }
        SimView()
        CallView()
      }
    }
    .layoutWeight(1)
  }
}