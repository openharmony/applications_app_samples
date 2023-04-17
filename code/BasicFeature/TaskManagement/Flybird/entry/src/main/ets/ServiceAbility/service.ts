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

import rpc from "@ohos.rpc"
import wantAgent from '@ohos.wantAgent'
import ServiceExtension from '@ohos.app.ability.ServiceExtensionAbility'
import Logger from '../model/Logger'

const TAG: string = 'ServiceAbility'

class FirstServiceAbilityStub extends rpc.RemoteObject {
  constructor(des: string) {
    if (typeof des === 'string') {
      super(des)
    } else {
      return
    }
  }

  onRemoteRequest(code: number, data: rpc.MessageParcel, reply: rpc.MessageParcel, option: rpc.MessageOption) {
    Logger.info(`${TAG}onRemoteRequest called`)
    if (code === 1) {
      let dataStr = data.readString()
      Logger.info(`${TAG} string=${dataStr}`)
      if (dataStr === 'start_game') {
        this.startContinousTask();
        let result = 'ok start game'
        Logger.info(`${TAG} result=${result}`)
        reply.writeString(result)
      } else if (dataStr === 'disconnect_service') {
        let result = 'ok disconnect service'
        Logger.info(`${TAG} result=${result}`)
        reply.writeString(result)
      }
      else {
        Logger.info(`${TAG} error string}`)
      }
    } else {
      Logger.info(`${TAG} unknown request code`)
    }
    return true
  }

  startContinousTask() {
    Logger.info(TAG, 'start background continousTask api')
    let wantAgentInfo = {
      wants: [
        {
          bundleName: 'ohos.samples.flybird',
          abilityName: 'EntryAbility'
        }
      ],
      operationType: wantAgent.OperationType.START_ABILITY,
      requestCode: 0,
      wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
    };

  }

  callback(err, data) {
    if (err) {
      Logger.error(TAG, `Operation failed Cause: ${err}`)
    } else {
      Logger.info(TAG, "Operation succeeded")
    }
  }
}

export default class ServiceExtAbility extends ServiceExtension {
  onCreate(want) {
    Logger.info(`${TAG} onCreate, want: ${want.abilityName}`)
  }

  onRequest(want, startId) {
    Logger.info(`${TAG} onRequest, want: ${want.abilityName}`)
  }

  onConnect(want) {
    Logger.info(`${TAG} onConnect, want: ${want.abilityName}`)
    return new FirstServiceAbilityStub("first ts service stub")
  }

  onDisconnect(want) {
    Logger.info(`${TAG} onDisconnect, want: ${want.abilityName}`)
  }

  onDestroy() {
    Logger.info(`${TAG} onDestroy`)
  }
}