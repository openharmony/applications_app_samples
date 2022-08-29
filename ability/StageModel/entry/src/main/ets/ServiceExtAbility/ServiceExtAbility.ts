/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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

import Extension from '@ohos.application.ServiceExtensionAbility'
import Notification from '@ohos.notification'
import rpc from '@ohos.rpc'
import Logger from '../util/Logger'

const TAG: string = 'ServiceExtAbility'
let notificationRequest = {
  content: {
    contentType: Notification.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
    normal: {
      title: 'data insert',
      text: ''
    }
  },
  id: 1 //ID of the notification request
}

class FirstServiceAbilityStub extends rpc.RemoteObject {
  constructor(des: any) {
    if (typeof des === 'string') {
      super(des)
    } else {
      return
    }
  }

  onRemoteRequest(code: number, data: any, reply: any, option: any) {
    Logger.info(TAG, `onRemoteRequest calledt`)
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

export default class ServiceExtAbility extends Extension {
  onCreate(want) {
    Logger.info(TAG, `onCreate, want: ${want.abilityName}`)
    Logger.info(TAG, `parameters, want: ${want.parameters}`)
  }

  onRequest(want, startId) {
    Logger.info(TAG, `onRequest, want: ${want.abilityName}`)
    notificationRequest.content.normal.text = want.parameters.isInsert
    Notification.publish(notificationRequest).then(() => {
      Logger.info(TAG, `publishCallback success`)
    })
  }
  //用于和客户端进行通信
  onConnect(want) {
    Logger.info(TAG, `onConnect , want: ${want.abilityName}`)
    return new FirstServiceAbilityStub('first ts service stub')
  }
  //当新客户端在所有以前的客户端连接之后尝试连接到服务扩展时调用
  onReconnect(want) {
    Logger.info(TAG, `onReconnect, want: ${want.abilityName}`)
  }
  //断开服务连接时回调
  onDisconnect(want) {
    Logger.info(TAG, `onDisconnect, want: ${want.abilityName}`)
  }

  onDestroy() {
    Logger.info(TAG, `onDestroy`)
  }
}