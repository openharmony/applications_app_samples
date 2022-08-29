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

const TAG: string = 'AbilityContextController'
const accountId = 100
const resultCode = 100
const connectionNumber = 0
const permissions = ['']

let want = {
  bundleName: 'ohos.samples.stagemodel',
  abilityName: 'TestAbility',
  moduleName: 'entry'
}

export default class AbilityContextController {
  private context: any

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

  // 启动Ability，对应FA的StartServiceAbility
  startAbility() {
    this.context.startAbility(want, (error) => {
      Logger.info(TAG, `error.code: ${JSON.stringify(error.code)}`)
    })
  }

  // 启动Ability并在结束的时候返回执行结果，对应FA的startAbilityForResult
  startAbilityForResult() {
    this.context.startAbilityForResult(
      {
        deviceId: '', bundleName: 'ohos.samples.stagemodel', abilityName: 'TestAbility'
      },
      (error, result) => {
        Logger.info(TAG, `startAbilityForResult AsyncCallback is called, error.code: ${JSON.stringify(error)}`)
        Logger.info(TAG, `startAbilityForResult AsyncCallback is called, result.resultCode: ${JSON.stringify(result.resultCode)}`)
      }
    )
  }

  // 启动一个Ability并在该Ability帐号销毁时返回执行结果，
  startAbilityForResultWithAccount() {
    this.context.startAbilityWithAccount(want, accountId, (err, data) => {
      Logger.info(TAG, `startAbilityWithAccount fail, err: ${JSON.stringify(err)}`)
      Logger.info(TAG, `startAbilityWithAccount success, data: ${JSON.stringify(data)}`)
    })
  }

  // 启动一个新的ServiceExtensionAbility，
  startServiceExtensionAbility() {
    this.context.startServiceExtensionAbility(want, (err) => {
      Logger.info(TAG, `startServiceExtensionAbility fail, err: ${JSON.stringify(err)}`)
      prompt.showToast({
        message: 'startServiceExtensionAbility success'
      })
    })
  }

  // 启动一个新的ServiceExtensionAbility，
  startServiceExtensionAbilityWithAccount() {
    this.context.startServiceExtensionAbilityWithAccount(want, accountId, (err) => {
      Logger.info(TAG, `startServiceExtensionAbilityWithAccount fail, err: ${JSON.stringify(err)}`)
      prompt.showToast({
        message: 'startServiceExtensionAbilityWithAccount success'
      })
    })
  }

  // 停止同一应用程序内的服务，
  stopServiceExtensionAbility() {
    this.context.stopServiceExtensionAbility(want, (err) => {
      Logger.info(TAG, `stopServiceExtensionAbility fail, err: ${JSON.stringify(err)}`)
      prompt.showToast({
        message: 'stopServiceExtensionAbility success'
      })
    })
  }

  // 使用帐户停止同一应用程序内的服务，
  stopServiceExtensionAbilityWithAccount() {
    this.context.stopServiceExtensionAbilityWithAccount(want, accountId, (err) => {
      Logger.info(TAG, `stopServiceExtensionAbilityWithAccount fail, err: ${JSON.stringify(err)}`)
      prompt.showToast({
        message: 'stopServiceExtensionAbilityWithAccount success'
      })
    })
  }

  // 停止Ability自身，对应FA的terminateSelf
  terminateSelf() {
    this.context.terminateSelf((err) => {
      Logger.info(TAG, `terminateSelf result: ${JSON.stringify(err)}`)
    })
  }

  // 停止Ability，配合startAbilityForResult使用，返回给接口调用方AbilityResult信息，对应FA的terminateSelfWithResult
  terminateSelfWithResult() {
    const abilityResult = {
      want,
      resultCode
    }
    this.context.terminateSelfWithResult(abilityResult, (error) => {
      Logger.info(TAG, `terminateSelfWithResult is called: ${JSON.stringify(error.code)}`)
    }
    )
  }

  // 使用AbilityInfo.AbilityType.SERVICE模板将当前Ability连接到一个Ability，对应FA的ConnectService
  connectAbility() {
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
        Logger.info(TAG, `onFailed`)
        prompt.showToast({
          message: 'onFailed'
        })
      }
    }
    const result = this.context.connectAbility(want, options)
    Logger.info(TAG, `connectAbilityResult: ${JSON.stringify(result)}`)
    prompt.showToast({
      message: `connectAbilityResult: ${JSON.stringify(result)}`
    })
  }

  // 使用AbilityInfo.AbilityType.SERVICE模板和account将当前Ability连接到一个Ability。
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
        Logger.info(TAG, `onFailed`)
        prompt.showToast({
          message: 'onFailed'
        })
      }
    }
    const result = this.context.connectAbility(want, options)
    Logger.info(TAG, `connectAbilityResult: ${JSON.stringify(result)}`)
    prompt.showToast({
      message: `connectAbilityResult: ${JSON.stringify(result)}`
    })
  }

  // 断开连接，对应FA模型的disconnectService
  disconnectAbility() {
    this.context.disconnectAbility(connectionNumber).then((data) => {
      Logger.info(TAG, `disconnectAbility success, data: ${JSON.stringify(data)}`)
      prompt.showToast({
        message: 'disconnectAbility success'
      })
    }).catch((err) => {
      Logger.info(TAG, `disconnectAbility fail, err: ${JSON.stringify(err)}`)
      prompt.showToast({
        message: 'disconnectAbility fail'
      })
    })
  }

  // 根据account启动Ability
  startAbilityWithAccount() {
    this.context.startAbilityWithAccount(want, accountId, (err) => {
      Logger.info(TAG, `startAbilityWithAccount fail, err: ${JSON.stringify(err)}`)
    })
  }

  // 拉起弹窗请求用户授权，对应FA模型的AppContext中的requestPermissionsFromUser
  requestPermissionsFromUser() {
    this.context.requestPermissionsFromUser(permissions, (result) => {
      Logger.info(TAG, `requestPermissionsFromUserresult: ${JSON.stringify(result)}`)
      prompt.showToast({
        message: 'requestPermissionsFromUserResult success'
      })
    })
  }

  // 设置ability在任务中显示的名称，
  setMissionLabel() {
    this.context.setMissionLabel('test', (result) => {
      Logger.info(TAG, `requestPermissionsFromUserresult: ${JSON.stringify(result)}`)
      prompt.showToast({
        message: 'requestPermissionsFromUserresult success'
      })
    })
  }

  // 查询ability是否在terminating状态。
  isTerminating() {
    const isTerminating = this.context.isTerminating()
    Logger.info(TAG, `ability state: ${JSON.stringify(isTerminating)}`)
  }
}

