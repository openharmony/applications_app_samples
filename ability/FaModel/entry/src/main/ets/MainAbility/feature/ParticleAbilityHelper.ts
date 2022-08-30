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

import particleAbility from '@ohos.ability.particleAbility'
import rpc from '@ohos.rpc'
import prompt from '@ohos.prompt'
import Logger from '../util/Logger'
import { BUNDLE_NAME, SERVICE_ABILITY_NAME, TAST_ABILITY_NAME } from '../model/DaHelperConst'

const TAG: string = 'ParticleAbilityHelper'

class ParticleAbilityHelper {
  private connId: number = -1

  // 启动指定的particleAbility，Stage模型ServiceExtContextController的startAbility
  startAbility() {
    particleAbility.startAbility({
      want: {
        bundleName: BUNDLE_NAME,
        abilityName: TAST_ABILITY_NAME
      }
    }, () => {
      Logger.info(TAG, 'startAbility success')
      prompt.showToast({
        message: 'particleAbility startAbility success'
      })
    })
  }

  // 终止particleAbility，Stage模型ServiceExtContextController的terminateSelf
  terminateSelf() {
    particleAbility.terminateSelf(() => {
      Logger.info(TAG, 'terminateSelf success')
      prompt.showToast({
        message: 'particleAbility terminateSelf success'
      })
    })
  }

  // 获取dataAbilityHelper
  acquireDataAbilityHelper() {
    particleAbility.acquireDataAbilityHelper('')
    Logger.info(TAG, 'terminateSelf success')
    prompt.showToast({
      message: 'particleAbility acquireDataAbilityHelper success'
    })
  }

  onConnectCallback(element, remote) {
    Logger.info(TAG, `ConnectAbility onConnect remote is proxy: ${remote instanceof rpc.RemoteProxy}`)
    prompt.showToast({
      message: 'particleAbility connectAbility success'
    })
  }

  onDisconnectCallback(element) {
    Logger.info(TAG, `ConnectAbility onDisconnect element.deviceId : ${element.deviceId}`)
    prompt.showToast({
      message: 'particleAbility disconnectAbility success'
    })
  }

  onFailedCallback(code) {
    Logger.info(TAG, `particleAbilityTest ConnectAbility onFailed errCode : ${code}`)
    prompt.showToast({
      message: `particleAbility Failed ${code}`
    })
  }

  // 将当前ability连接到指定ServiceAbility，Stage模型ServiceExtContextController的connectAbility
  connectAbility() {
    this.connId = particleAbility.connectAbility({
      bundleName: BUNDLE_NAME,
      abilityName: SERVICE_ABILITY_NAME,
    },
      {
        onConnect: this.onConnectCallback,
        onDisconnect: this.onDisconnectCallback,
        onFailed: this.onFailedCallback,
      })
  }

  // 将功能与服务功能断开连接，Stage模型ServiceExtContextController的disconnectAbility
  disconnectAbility() {
    particleAbility.disconnectAbility(this.connId, () => {
      Logger.info(TAG, 'disconnectAbility success')
    })
  }
}

export default new ParticleAbilityHelper()
