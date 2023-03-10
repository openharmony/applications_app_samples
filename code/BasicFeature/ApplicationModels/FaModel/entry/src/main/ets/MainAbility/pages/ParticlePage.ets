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

import router from '@ohos.router'
import prompt from '@ohos.promptAction'
import CommonEvent from '@ohos.commonEvent'
import ParticleAbilityHelper from '../feature/ParticleAbilityHelper'
import Logger from '../util/Logger'

const TAG: string = 'ParticlePage'
//用于保存创建成功的订阅者对象，后续使用其完成订阅及退订的动作
let subscriber: any = null
let subscribeInfo: any = {
  events: [
    'startAbilitySuccess',
    'connectAbilitySuccess',
    'disconnectAbilitySuccess',
    'acquireDataAbilityHelperSuccess',
    'terminateSelfSuccess'
  ]
}

function showToast(message: Resource) {
  prompt.showToast({
    message: message
  })
}

//订阅公共事件回调
function subscribeCallBack(err, data) {
  if (err.code) {
    Logger.info(TAG, `subscribeCallBack failed ${JSON.stringify(err)}`)
  } else {
    Logger.info(TAG, `subscribeCallBack ${JSON.stringify(data)}`)
    switch (data.event) {
      case 'startAbilitySuccess':
        showToast($r('app.string.start_ability_success'))
        break
      case 'connectAbilitySuccess':
        showToast($r('app.string.connect_ability_success'))
        break
      case 'disconnectAbilitySuccess':
        showToast($r('app.string.disconnect_ability_success'))
        break
      case 'acquireDataAbilityHelperSuccess':
        showToast($r('app.string.acquire_data_ability_helper_success'))
        break
      case 'terminateSelfSuccess':
        showToast($r('app.string.terminate_self_success'))
        break
      default:
        Logger.info(TAG, `subscribeCallBack default`)
    }
  }
}

@Entry
@Component
struct ParticlePage {
  aboutToAppear() {
    //创建订阅者回调
    function CreateSubscriberCallBack(err, commonEventSubscriber) {
      if (err.code) {
        Logger.info(TAG, `createSubscriber failed ${JSON.stringify(err)}`)
      } else {
        Logger.info(TAG, `createSubscriber success`)
        subscriber = commonEventSubscriber
        //订阅公共事件
        CommonEvent.subscribe(subscriber, subscribeCallBack)
      }
    }

    //创建订阅者
    CommonEvent.createSubscriber(subscribeInfo, CreateSubscriberCallBack)
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.back'))
          .width(32)
          .height(32)
          .margin({ left: 32, right: 32 })
          .onClick(() => {
            router.back()
          })
        Text($r('app.string.particle_page'))
          .fontColor(Color.Black)
          .fontSize(30)
          .fontWeight(500)
          .layoutWeight(1)
      }
      .width('100%')
      .height('8%')

      Column() {
        this.ButtonStyle($r('app.string.start_ability'), ParticleAbilityHelper.publishStartAbility)
        this.ButtonStyle($r('app.string.connect_ability'), ParticleAbilityHelper.publishConnectAbility)
        this.ButtonStyle($r('app.string.disconnect_ability'), ParticleAbilityHelper.publishDisconnectAbility)
        this.ButtonStyle($r('app.string.acquire_data_ability_helper'), ParticleAbilityHelper.publishAcquireDataAbilityHelper)
        this.ButtonStyle($r('app.string.terminate_self'), ParticleAbilityHelper.publishTerminateSelf)
      }
      .width('100%')
    }
    .height('100%')
  }

  @Builder ButtonStyle(textStr: Resource, handleClick: () => void) {
    Button(textStr)
      .width('60%')
      .margin({ top: 30 })
      .onClick(() => {
        handleClick()
      })
  }
}