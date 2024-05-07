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

import prompt from '@ohos.prompt'
import common from '@ohos.app.ability.common'
import rpc from "@ohos.rpc"
import Logger from '../model/Logger'

const localDeviceId: string = ''
let mRemote: rpc.IRemoteObject = null
let connection: number = -1
const TAG = 'ServiceModel'

export class ServiceModel {
  private sendMessage: string = ''

  onConnectCallback(element, remote) {
    Logger.info(`${TAG}onConnectLocalService onConnectDone element:${element}`)
    Logger.info(`${TAG}onConnectLocalService onConnectDone remote:${remote}`)
    mRemote = remote
    if (mRemote === null) {
      prompt.showToast({
        message: 'onConnectLocalService not connected yet'
      })
      return
    }
    prompt.showToast({
      message: 'connect service success',
    })
  }

  onDisconnectCallback(element) {
    Logger.info(`${TAG}onConnectLocalService onDisconnectDone element:${element}`)
  }

  onFailedCallback(code) {
    Logger.info(`${TAG}onConnectLocalService onFailed errCode:${code}`)
    prompt.showToast({
      message: `onConnectLocalService onFailed:${code}`
    })
  }

  connectService() {
    Logger.info(`${TAG} onCconnectService begin`)
    let context = getContext(this) as common.UIAbilityContext
    connection = context.connectServiceExtensionAbility(
      {
        deviceId: localDeviceId,
        bundleName: 'ohos.samples.flybird',
        abilityName: 'ServiceExtAbility',
      },
      {
        onConnect: this.onConnectCallback,
        onDisconnect: this.onDisconnectCallback,
        onFailed: this.onFailedCallback,
      },
    )
  }

  disconnectService() {
    Logger.info(`${TAG} onDisconnectService begin`)
    mRemote = null
    if (connection === -1) {
      prompt.showToast({
        message: 'onDisconnectService not connected yet'
      })
      return
    }
    let context = getContext(this) as common.UIAbilityContext
    context.disconnectServiceExtensionAbility(connection)
    connection = -1 // 连接状态值设置为-1
    prompt.showToast({
      message: 'onDisconnectService disconnect done'
    })
  }

  getRemoteObject() {
    return mRemote
  }
}