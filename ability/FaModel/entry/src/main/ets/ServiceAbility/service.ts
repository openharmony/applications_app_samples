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

import Notification from '@ohos.notification'
import rpc from '@ohos.rpc'
import Logger from '../MainAbility/util/Logger'

const TAG: string = 'service'
let notificationRequest = {
  content: {
    contentType: Notification.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
    normal: {
      title: 'start service',
      text: ''
    }
  },
  id: 1
}

class FirstServiceAbilityStub extends rpc.RemoteObject {
  constructor(des: any) {
    if (typeof des === 'string') {
      super(des)
    } else {
      return
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

// 对应stage模型中 ServiceExtAbility.ts
export default {
  onStart() {
    Logger.info(TAG, 'ServiceAbility onStart')
  },
  onStop() {
    Logger.info(TAG, 'ServiceAbility onStop')
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