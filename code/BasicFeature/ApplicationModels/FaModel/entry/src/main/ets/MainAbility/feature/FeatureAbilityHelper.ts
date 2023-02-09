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

import featureAbility from '@ohos.ability.featureAbility'
import prompt from '@ohos.prompt'
import rpc from '@ohos.rpc'
import Logger from '../util/Logger'
import { BASE_URI, BUNDLE_NAME, SERVICE_ABILITY_NAME, TAST_ABILITY_NAME } from '../model/DaHelperConst'

const TAG: string = 'FeatureAbilityHelper'
const localDeviceId: string = ''
let rpcRemote: rpc.IRemoteObject = null
let connectId: number = -1

class FeatureAbilityHelper {

  // 获取从Ability发送的Want,Stage模型在MainAbility的onCreate生命周期函数中获取
  async getWant() {
    let want = await featureAbility.getWant()
    Logger.info(TAG, `want = ${JSON.stringify(want)}`)
    prompt.showToast({
      message: 'getWant success'
    })
  }

  // 启动一个ability，并在该ability被销毁时返回执行结果，对应stage模型startAbilityForResult
  startAbilityForResult() {
    featureAbility.startAbilityForResult({
      want: {
        bundleName: BUNDLE_NAME,
        abilityName: TAST_ABILITY_NAME
      }
    }, (data) => {
      Logger.info(TAG, `${JSON.stringify(data)}`)
      prompt.showToast({
        message: 'startAbilityForResult success'
      })
    })
  }

  // 获取dataAbilityHelper, 对应stage模型中DataShareHelper.ts中createDataShareHelper
  acquireDataAbilityHelper() {
    let DAHelper = featureAbility.acquireDataAbilityHelper(BASE_URI)
    Logger.info(TAG, 'get acquireDataAbilityHelper success')
    prompt.showToast({
      message: 'get acquireDataAbilityHelper success'
    })
    return DAHelper
  }

  // 返回给调用者的结果代码和数据并破坏此Page Ability,对应stage模型terminateSelfWithResult
  terminateSelfWithResult() {
    featureAbility.terminateSelfWithResult({
      resultCode: 1, // 错误返回码
      want:
      {
        type: 'MIMETYPE',
        deviceId: '',
        bundleName: BUNDLE_NAME,
        abilityName: TAST_ABILITY_NAME,
        uri: '',
        parameters: {
          mykey0: 2222,
          mykey1: [1, 2, 3],
          mykey2: '[1, 2, 3]'
        }
      }
    },
      () => {
        Logger.info(TAG, 'terminateSelfWithResult success')
        prompt.showToast({
          message: 'terminateSelfWithResult success'
        })
      })
  }

  // 检查Ability的主窗口是否具有窗口焦点，Stage模型不支持
  async hasWindowFocus() {
    let isNo = await featureAbility.hasWindowFocus()
    Logger.info(TAG, `hasWindowFocus = ${isNo}`)
    prompt.showToast({
      message: isNo ? 'Ability currently has a window focus' : 'Ability currently has no window focus'
    })
  }

  // 销毁ability，对应stage模型terminateSelf
  terminateSelf() {
    featureAbility.terminateSelf(() => {
      Logger.info(TAG, 'terminateSelf success')
      prompt.showToast({
        message: 'terminateSelf success'
      })
    })
  }

  // 获取当前Ability对应的窗口,
  getWindow() {
    featureAbility.getWindow((err, data) => {
      Logger.info(TAG, `getWindow = ${JSON.stringify(data)}`)
      prompt.showToast({
        message: 'getWindow success'
      })
    })
  }

  // 连接service回调,对应stage模型connectCallback
  connectCallback(element, remote) {
    Logger.info(TAG, `ConnectLocalService ConnectDone element: ${element}, remote: ${remote}`)
    rpcRemote = remote
    if (rpcRemote === null) {
      return 'ConnectLocalService not connected yet'
    }
    prompt.showToast({
      message: 'Connect service success'
    })
  }

  // 断开service回调,对应stage模型disconnectCallback
  disconnectCallback(element) {
    Logger.info(TAG, `ConnectLocalService DisconnectDone element: ${element}`)
  }

  // 连接service失败的回调,对应stage模型failedCallback
  failedCallback(code) {
    Logger.info(TAG, `ConnectLocalService Failed errCode: ${code}`)
    prompt.showToast({
      message: `ConnectLocalService Failed: ${code}`
    })
  }

  // 启动service,对应Stage模型中startServiceAbility
  async startServiceAbility(parameter) {
    Logger.info(TAG, 'startAbility start')
    let startNum = await featureAbility.startAbility(parameter)
    Logger.info(TAG, `startAbility end ${startNum}`)
  }

  // 连接service,对应stage模型connectService
  connectService() {
    Logger.info(TAG, `connectService begin`)

    // 对应stage模型Options
    let connectOptions = {
      onConnect: this.connectCallback,
      onDisconnect: this.disconnectCallback,
      onFailed: this.failedCallback
    }
    connectId = featureAbility.connectAbility(
      {
        deviceId: localDeviceId,
        bundleName: BUNDLE_NAME,
        abilityName: SERVICE_ABILITY_NAME
      },
      connectOptions
    )
    Logger.info(TAG, `connectService connectId = ${connectId}`)
    if (connectId >= 0) {
      prompt.showToast({
        message: $r('app.string.connect_success')
      })
    } else {
      prompt.showToast({
        message: $r('app.string.connect_fail')
      })
    }
  }

  // 断开service连接,对应stage模型disconnectService
  disconnectService() {
    Logger.info(TAG, `disconnectService begin`)
    rpcRemote = null
    if (connectId === -1) {
      prompt.showToast({
        message: $r('app.string.not_connect_yet')
      })
      return
    }
    featureAbility.disconnectAbility(connectId)
    connectId = -1
    prompt.showToast({
      message: $r('app.string.disconnect_success')
    })
  }
}

export default new FeatureAbilityHelper()