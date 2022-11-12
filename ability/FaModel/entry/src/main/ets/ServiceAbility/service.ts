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
import Notification from '@ohos.notification'
import particleAbility from '@ohos.ability.particleAbility'
import prompt from '@ohos.prompt'
import rpc from '@ohos.rpc'
import Logger from '../MainAbility/util/Logger'
import { BUNDLE_NAME, SERVICE_ABILITY_NAME, TAST_ABILITY_NAME } from '../MainAbility/model/DaHelperConst'

const TAG: string = 'ServiceAbility.service'

let connId: number = -1
let subscriber: any = null //用于保存创建成功的订阅者对象，后续使用其完成订阅及退订的动作
//订阅者信息
let subscribeInfo: any = {
  events: [
    'startAbility',
    'connectAbility',
    'disconnectAbility',
    'acquireDataAbilityHelper',
    'terminateSelf'
  ]
}

let notificationRequest: any = {
  content: {
    contentType: Notification.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
    normal: {
      title: 'start service',
      text: ''
    }
  },
  id: 1
}

//订阅公共事件回调
function subscribeCallBack(err, data) {
  if (err.code) {
    Logger.info(TAG, `subscribeCallBack failed ${JSON.stringify(err)}`)
  } else {
    Logger.info(TAG, `subscribeCallBack ${JSON.stringify(data)}`)
    switch (data.event) {
      case 'startAbility':
        startAbility()
        break
      case 'connectAbility':
        connectAbility()
        break
      case 'disconnectAbility':
        disconnectAbility()
        break
      case 'acquireDataAbilityHelper':
        acquireDataAbilityHelper()
        break
      case 'terminateSelf':
        terminateSelf()
        break
      default:
        Logger.info(TAG, `subscribeCallBack default`)
    }
  }
}

function publishCallback(err) {
  if (err.code) {
    Logger.error(TAG, `publishCallback failed ${JSON.stringify(err)}`)
  } else {
    Logger.info(TAG, `publishCallback success`)
  }
}

//取消订阅公共事件回调
function unsubscribeCallBack(err) {
  if (err.code) {
    Logger.info(TAG, `unsubscribe failed ${JSON.stringify(err)}`)
  } else {
    Logger.info(TAG, `unsubscribe`)
  }
}

let faConnect: any = {
  onConnect: function (element, remote) {
    Logger.info(TAG, `ConnectAbility onConnect remote is proxy: ${remote instanceof rpc.RemoteProxy}`)
    prompt.showToast({
      message: $r('app.string.connect_success')
    })
  },
  onDisconnect: function (element) {
    Logger.info(TAG, `ConnectAbility onDisconnect element.deviceId : ${element.deviceId}`)
    prompt.showToast({
      message: $r('app.string.disconnect_success')
    })
  },
  onFailed: function (code) {
    Logger.info(TAG, `particleAbilityTest ConnectAbility onFailed errCode : ${code}`)
    prompt.showToast({
      message: $r('app.string.connect_fail')
    })
  }
}

class FirstServiceAbilityStub extends rpc.RemoteObject {
  constructor(des: any) {
    if (typeof des === 'string') {
      super(des)
    }
  }

  // 处理客户端传入的数据
  onRemoteRequest(code: number, data: any, reply: any, option: any) {
    Logger.info(TAG, `onRemoteRequest called`)
    if (code === 1) {
      let result = data.readString()
      Logger.info(TAG, `result=${result}`)
      reply.writeString(result)
    } else {
      Logger.info(TAG, `unknown request code`)
    }
    return true
  }
}

// 启动指定的particleAbility，Stage模型ServiceExtContextController的startAbility
function startAbility() {
  particleAbility.startAbility({
    want: {
      bundleName: BUNDLE_NAME,
      abilityName: TAST_ABILITY_NAME
    }
  }, () => {
    Logger.info(TAG, 'startAbility success')
    CommonEvent.publish('startAbilitySuccess', publishCallback)
  })
}

// 将当前ability连接到指定ServiceAbility，Stage模型ServiceExtContextController的connectAbility
function connectAbility() {
  connId = particleAbility.connectAbility({
    bundleName: BUNDLE_NAME,
    abilityName: SERVICE_ABILITY_NAME
  }, faConnect)
  if (connId >= 0) {
    Logger.info(TAG, 'connectAbility success')
    CommonEvent.publish('connectAbilitySuccess', publishCallback)
  } else {
    Logger.info(TAG, 'connectAbility fail')
  }
}

// 将功能与服务功能断开连接，Stage模型ServiceExtContextController的disconnectAbility
function disconnectAbility() {
  particleAbility.disconnectAbility(connId, (err) => {
    if (err.code !== 0) {
      Logger.info(TAG, `disconnectAbility error ${JSON.stringify(err)}}`)
      return
    }
    Logger.info(TAG, 'disconnectAbility success')
    CommonEvent.publish('disconnectAbilitySuccess', publishCallback)
  })
}

// 获取dataAbilityHelper
function acquireDataAbilityHelper() {
  particleAbility.acquireDataAbilityHelper('')
  Logger.info(TAG, 'acquireDataAbilityHelper success')
  CommonEvent.publish('acquireDataAbilityHelperSuccess', publishCallback)
}

// 终止particleAbility，Stage模型ServiceExtContextController的terminateSelf
function terminateSelf() {
  particleAbility.terminateSelf(() => {
    Logger.info(TAG, 'terminateSelf success')
    CommonEvent.publish('terminateSelfSuccess', publishCallback)
  })
}

// 对应stage模型中 ServiceExtAbility.ts
export default {
  onStart() {
    Logger.info(TAG, 'ServiceAbility onStart')
    //创建订阅者回调
    function createSubscriberCallBack(err, commonEventSubscriber) {
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
    CommonEvent.createSubscriber(subscribeInfo, createSubscriberCallBack)

  },
  onStop() {
    Logger.info(TAG, 'ServiceAbility onStop')
    //取消订阅公共事件
    CommonEvent.unsubscribe(subscriber, unsubscribeCallBack)
  },
  onCommand(want, startId) {
    Logger.info(TAG, `ServiceAbility onCommand, want = ${JSON.stringify(want)}`)
    notificationRequest.content.normal.text = want.parameters.service
    Notification.publish(notificationRequest).then(() => {
      Logger.info(TAG, `publishCallback success`)
    })
  },
  onConnect(want) {
    Logger.info(TAG, `onConnect, want:${JSON.stringify(want)}`)
    return new FirstServiceAbilityStub('first ts service stub')
  },
  onDisconnect() {
    Logger.info(TAG, `onDisconnect`)
  }
}