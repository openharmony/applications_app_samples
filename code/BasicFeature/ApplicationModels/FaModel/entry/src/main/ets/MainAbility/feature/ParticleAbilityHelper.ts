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

import CommonEvent from '@ohos.commonEvent'
import Logger from '../util/Logger'

const TAG: string = 'ParticleAbilityHelper'

class ParticleAbilityHelper {
  // 发布启动Ability事件
  publishStartAbility = () => {
    CommonEvent.publish('startAbility', () => {
      Logger.info(TAG, `publish startAbility`)
    })
  }

  // 发布连接Ability事件
  publishConnectAbility = () => {
    CommonEvent.publish('connectAbility', () => {
      Logger.info(TAG, `publish connectAbility`)
    })
  }

  // 发布断开连接Ability事件
  publishDisconnectAbility = () => {
    CommonEvent.publish('disconnectAbility', () => {
      Logger.info(TAG, `publish disconnectAbility`)
    })
  }

  // 发布获取dataAbilityHelper事件
  publishAcquireDataAbilityHelper = () => {
    CommonEvent.publish('acquireDataAbilityHelper', () => {
      Logger.info(TAG, `publish acquireDataAbilityHelper`)
    })
  }

  // 发布终止Ability事件
  publishTerminateSelf = () => {
    CommonEvent.publish('terminateSelf', () => {
      Logger.info(TAG, `publish terminateSelf`)
    })
  }
}

export default new ParticleAbilityHelper()