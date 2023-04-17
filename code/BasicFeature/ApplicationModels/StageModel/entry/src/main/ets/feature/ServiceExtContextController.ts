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

import prompt from '@ohos.prompt'
import Logger from '../util/Logger'
import common from '@ohos.app.ability.common'

const TAG: string = 'ServiceExtContextController'
const accountId = 100

let caller = undefined
let connection = 1
let wantAccount = {
  'bundleName': 'ohos.samples.stagemodel',
  'abilityName': 'TestAbility'
}
let want = {
  bundleName: 'ohos.samples.stagemodel',
  abilityName: 'TestAbility',
  moduleName: 'entry'
}

export default class ServiceExtContextController {
  private context: common.UIAbilityContext

  constructor(context) {
    this.context = context
  }

  private regOnRelease(caller) {
    try {
      caller.onRelease((msg) => {
        Logger.info(TAG, `caller onRelease is called ${msg}`)
      })
      Logger.info(TAG, 'caller register OnRelease succeed')
    } catch (error) {
      Logger.error(TAG, `caller register OnRelease failed with ${error}`)
    }
  }

  // 启动Ability,对应FA的ParticleAbilityTest中的startAbility()
  startAbility() {
    this.context.startAbility(wantAccount, (error) => {
      Logger.info(TAG, `startAbility result: ${JSON.stringify(error)}`)
    })
  }

  // 根据account启动Ability
  startAbilityWithAccount() {
    this.context.startAbilityWithAccount(wantAccount, accountId, (err) => {
      Logger.info(TAG, `startAbilityWithAccount fail, err: ${JSON.stringify(err)}`)
    })
  }

  // 启动一个新的ServiceExtensionAbility
  startServiceExtensionAbility() {
    this.context.startServiceExtensionAbility(wantAccount)
      .then((data) => {
        Logger.info(TAG, `startServiceExtensionAbility success, data: ${JSON.stringify(data)}`)
        prompt.showToast({
          message: 'startServiceExtensionAbility success'
        })
      })
      .catch((error) => {
        Logger.error(TAG, `startServiceExtensionAbility fail, error: ${JSON.stringify(error)}`)
        prompt.showToast({
          message: 'startServiceExtensionAbility'
        })
      })
  }

  // 启动一个新的ServiceExtensionAbility
  startServiceExtensionAbilityWithAccount() {
    this.context.startServiceExtensionAbilityWithAccount(wantAccount,accountId)
      .then((data) => {
        Logger.info(TAG, `startServiceExtensionAbilityWithAccount success: ${JSON.stringify(data)}`)
        prompt.showToast({
          message: 'startServiceExtensionAbilityWithAccount success'
        })
      })
      .catch((error) => {
        Logger.error(TAG, `startServiceExtensionAbilityWithAccount fail, error: ${JSON.stringify(error)}`)
        prompt.showToast({
          message: 'startServiceExtensionAbilityWithAccount'
        })
      })
  }

  // 停止同一应用程序内的服务
  stopServiceExtensionAbility() {
    this.context.stopServiceExtensionAbility(wantAccount)
      .then((data) => {
        Logger.info(TAG, `stopServiceExtensionAbility ${JSON.stringify(data)}`)
        prompt.showToast({
          message: `stopServiceExtensionAbility ${JSON.stringify(data)}`
        })
      })
      .catch((error) => {
        Logger.error(TAG, `stopServiceExtensionAbility fail, err: ${JSON.stringify(error)}`)
        prompt.showToast({
          message: 'stopServiceExtensionAbility'
        })
      })
  }

  // 使用帐户停止同一应用程序内的服务
  stopServiceExtensionAbilityWithAccount() {
    this.context.stopServiceExtensionAbilityWithAccount(want,accountId)
      .then((data) => {
        Logger.info(TAG, `stopServiceExtensionAbilityWithAccount: ${JSON.stringify(data)}`)
        prompt.showToast({
          message: `stopServiceExtensionAbilityWithAccount: ${JSON.stringify(data)}`
        })
      })
      .catch((error) => {
        Logger.error(TAG, `stopServiceExtensionAbilityWithAccount: ${JSON.stringify(error)}`)
        prompt.showToast({
          message: 'stopServiceExtensionAbilityWithAccount'
        })
      })
  }

  // 停止Ability自身。对应FA的ParticleAbilityTest中的terminateSelf()
  terminateSelf() {
    this.context.terminateSelf((error) => {
      Logger.info(TAG, `terminateSelf result: ${JSON.stringify(error)}`)
    })
  }

  // 将一个Ability与服务类型的Ability绑定。对应FA的ParticleAbilityTest中的connectAbility()
  connectAbility() {
    let options = {
      onConnect(elementName, remote) {
        Logger.info(TAG, `connection: ${JSON.stringify(elementName)}`)
        prompt.showToast({
          message: `connection: ${JSON.stringify(elementName)}`
        })
      },
      onDisconnect(elementName) {
        Logger.info(TAG, `onDisconnect: ${JSON.stringify(elementName)}`)
        prompt.showToast({
          message: `onDisconnect: ${JSON.stringify(elementName)}`
        })
      },
      onFailed(code) {
        Logger.info(TAG, `connectAbility: ${JSON.stringify(code)}`)
        prompt.showToast({
          message: `connectAbility: ${JSON.stringify(code)}`
        })
      }
    }
    let connection = this.context.connectServiceExtensionAbility(want, options)
    Logger.info(TAG, `connection: ${JSON.stringify(connection)}`)
    prompt.showToast({
      message: `connection: ${JSON.stringify(connection)}`
    })
  }

  // 使用AbilityInfo.AbilityType.SERVICE模板和account将当前能力连接到一个能力。
  connectAbilityWithAccount() {
    const options = {
      onConnect(elementName, remote) {
        Logger.info(TAG, `onConnect`)
        prompt.showToast({
          message: 'onConnect'
        })
      },
      onDisconnect(elementName) {
        Logger.info(TAG, `onDisconnect`)
        prompt.showToast({
          message: 'onDisconnect'
        })
      },
      onFailed(code) {
        Logger.info(TAG, `connectAbilityWithAccount: ${JSON.stringify(code)}`)
        prompt.showToast({
          message: `connectAbilityWithAccount: ${JSON.stringify(code)}`
        })
      }
    }
    const result = this.context.connectServiceExtensionAbility(want, options)
    Logger.info(TAG, `connectAbilityResult: ${JSON.stringify(result)}`)
    prompt.showToast({
      message: `connectAbilityResult: ${JSON.stringify(result)}`
    })
  }

  // 将一个Ability与绑定的服务类型的Ability解绑。对应FA的ParticleAbilityTest中的disconnectAbility
  disconnectAbility() {
    this.context.disconnectServiceExtensionAbility(connection, (error) => {
      // connection为connectAbility中的返回值
      if (error) {
        Logger.info(TAG, `disconnectAbility result error: ${JSON.stringify(error)}`)
      }
      Logger.info(TAG, `disconnectAbility result success`)
      prompt.showToast({
        message: `disconnectAbility result success`
      })
    })
  }

  // 启动指定Ability至前台或后台，同时获取其Caller通信接口，调用方可使用Caller与被启动的Ability进行通信。
  startAbilityByCall() {
    this.context.startAbilityByCall({
      bundleName: 'ohos.samples.stagemodel',
      abilityName: 'TestAbility',
      moduleName: 'entry'
    }).then((obj) => {
      caller = obj
      Logger.info(TAG, `Caller GetCaller Get: ${JSON.stringify(caller)}`)
      prompt.showToast({
        message: `Caller GetCaller Get:${JSON.stringify(caller)}`
      })
    }).catch((error) => {
      Logger.error(TAG, `Caller GetCaller error: ${JSON.stringify(error)}`)
      prompt.showToast({
        message: `Caller GetCaller error:${JSON.stringify(error)}`
      })
    })
  }
}