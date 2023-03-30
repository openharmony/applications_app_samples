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

import CommonEvent from '@ohos.commonEventManager'
import Logger from '../util/Logger'
import prompt from '@ohos.promptAction'

const TAG: string = 'ParticleAbilityHelper'

class ParticleAbilityHelper {
  // 发布启动Ability事件
  publishStartAbility = () => {
    CommonEvent.publish('startAbility', (err) => {
      if (err) {
        Logger.info(TAG, `publish startAbility error : ${JSON.stringify(err)}`)
      } else {
        Logger.info(TAG, 'publish startAbility success')
        prompt.showToast({
          message: 'publish startAbility success'
        })
      }
    })
  }

  // 发布连接Ability事件
  publishConnectAbility = () => {
    CommonEvent.publish('connectAbility', (err) => {
      if (err) {
        Logger.info(TAG, `publish connectAbility error : ${JSON.stringify(err)}`)
      } else {
        Logger.info(TAG, 'publish connectAbility success')
        prompt.showToast({
          message: 'publish connectAbility success'
        })
      }
    })
  }

  // 发布断开连接Ability事件
  publishDisconnectAbility = () => {
    CommonEvent.publish('disconnectAbility', (err) => {
      if (err) {
        Logger.info(TAG, `publish disconnectAbility error : ${JSON.stringify(err)}`)
      } else {
        Logger.info(TAG, 'publish disconnectAbility success')
        prompt.showToast({
          message: 'publish disconnectAbility success'
        })
      }
    })
  }

  // 发布获取dataAbilityHelper事件
  publishAcquireDataAbilityHelper = () => {
    CommonEvent.publish('acquireDataAbilityHelper', (err) => {
      if (err) {
        Logger.info(TAG, `publish acquireDataAbilityHelper error : ${JSON.stringify(err)}`)
      } else {
        Logger.info(TAG, 'publish acquireDataAbilityHelper success')
        prompt.showToast({
          message: 'publish acquireDataAbilityHelper success'
        })
      }
    })
  }

  // 发布终止Ability事件
  publishTerminateSelf = () => {
    CommonEvent.publish('terminateSelf', (err) => {
      if (err) {
        Logger.info(TAG, `publish terminateSelf error : ${JSON.stringify(err)}`)
      } else {
        Logger.info(TAG, 'publish terminateSelf success')
        prompt.showToast({
          message: 'publish terminateSelf success'
        })
      }
    })
  }
}

export default new ParticleAbilityHelper()