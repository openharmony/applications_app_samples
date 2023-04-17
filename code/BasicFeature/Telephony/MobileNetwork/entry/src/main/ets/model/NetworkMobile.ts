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

import Logger from './Logger'
import data from '@ohos.telephony.data'

const TAG: string = '[NetworkMobile]'

export class NetworkMobile {
  async getDefaultCellularDataSlotId() {
    let slotId: number = -1
    try {
      slotId = await data.getDefaultCellularDataSlotId()
      Logger.info(TAG, `getDefaultCellularDataSlotId slotId = ${slotId}`)
    } catch (err) {
      Logger.info(TAG, `getDefaultCellularDataSlotId failed err is ${JSON.stringify(err)}`)
    }
    return slotId
  }

  async isCellularDataEnabled() {
    let dataEnabled: boolean = false
    try {
      dataEnabled = await data.isCellularDataEnabled()
      Logger.info(TAG, `isCellularDataEnabled dataEnabled = ${dataEnabled}`)
    } catch (err) {
      Logger.info(TAG, `isCellularDataEnabled failed err is ${JSON.stringify(err)}`)
    }
    return dataEnabled
  }

  async isCellularDataRoamingEnabled(slotId: number) {
    let dataRoamingEnabled: boolean = false
    try {
      dataRoamingEnabled = await data.isCellularDataRoamingEnabled(slotId)
      Logger.info(TAG, `isCellularDataRoamingEnabled dataRoamingEnabled = ${dataRoamingEnabled}`)
    } catch (err) {
      Logger.info(TAG, `isCellularDataRoamingEnabled failed err is ${JSON.stringify(err)}`)
    }
    return dataRoamingEnabled
  }

  async getCellularDataFlowType() {
    let dataFlow: data.DataFlowType = data.DataFlowType.DATA_FLOW_TYPE_NONE
    let result: Resource = $r('app.string.none')
    try {
      dataFlow = await data.getCellularDataFlowType()
      Logger.info(TAG, `getCellularDataFlowType dataFlow = ${JSON.stringify(dataFlow)}`)
    } catch (err) {
      Logger.info(TAG, `getCellularDataFlowType failed err is ${JSON.stringify(err)}`)
    }
    switch (dataFlow) {
      case data.DataFlowType.DATA_FLOW_TYPE_NONE:
        result = $r('app.string.none')
        break
      case data.DataFlowType.DATA_FLOW_TYPE_DOWN:
        result = $r('app.string.down')
        break
      case data.DataFlowType.DATA_FLOW_TYPE_UP:
        result = $r('app.string.up')
        break
      case data.DataFlowType.DATA_FLOW_TYPE_UP_DOWN:
        result = $r('app.string.upDown')
        break
      case data.DataFlowType.DATA_FLOW_TYPE_DORMANT:
        result = $r('app.string.dormant')
        break
      default:
        result = $r('app.string.none')
        break
    }
    return result
  }

  async getCellularDataState() {
    let dataConnectState: data.DataConnectState = data.DataConnectState.DATA_STATE_UNKNOWN
    let result: Resource = $r('app.string.unknown')
    try {
      dataConnectState = await data.getCellularDataState()
      Logger.info(TAG, `getCellularDataState dataConnectState = ${JSON.stringify(dataConnectState)}`)
    } catch (err) {
      Logger.info(TAG, `getCellularDataState failed err is ${JSON.stringify(err)}`)
    }
    switch (dataConnectState) {
      case data.DataConnectState.DATA_STATE_UNKNOWN:
        result = $r('app.string.unknown')
        break
      case data.DataConnectState.DATA_STATE_DISCONNECTED:
        result = $r('app.string.disconnect')
        break
      case data.DataConnectState.DATA_STATE_CONNECTING:
        result = $r('app.string.connecting')
        break
      case data.DataConnectState.DATA_STATE_CONNECTED:
        result = $r('app.string.connect')
        break
      case data.DataConnectState.DATA_STATE_SUSPENDED:
        result = $r('app.string.suspended')
        break
      default:
        result = $r('app.string.unknown')
        break
    }
    return result
  }
}