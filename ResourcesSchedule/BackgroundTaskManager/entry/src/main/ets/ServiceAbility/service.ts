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

import wantAgent from '@ohos.wantAgent'
import backgroundTaskManager from '@ohos.backgroundTaskManager'
import featureAbility from '@ohos.ability.featureAbility'
import Notification from '@ohos.notification'
import Logger from '../MainAbility/mode/Logger'

const TAG = "serviceAbility"
let num: number = 0
let timerID: number = 0

let notificationRequest = {
  content: {
    contentType: Notification.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
    normal: {
      title: '文件名',
      text: ''
    }
  },
  id: 1
}

function callback(err, data) {
  if (err) {
    Logger.error(TAG, `Operation failed Cause: ${err}`)
    return
  }
  if (timerID !== 0) {
    clearInterval(timerID)
  }
  Logger.info(TAG, `Operation startBackgroundRunning succeeded`)
  timerID = setInterval(() => {
    notificationRequest.content.normal.text = `${num}%`
    Notification.publish(notificationRequest).then(() => {
      Logger.info(TAG, `==========================>publishCallback=======================>`);
    })
    num += 5
    if (num > 20) {
      clearInterval(timerID)
    }
  }, 5000)
}

function startContinuousTask() {
  Logger.info(TAG, `startBackground use new api`)
  let wantAgentInfo = {
    wants: [
      {
        bundleName: "ohos.samples.backgroundtaskmanager",
        abilityName: "ohos.samples.backgroundtaskmanager.MainAbility"
      }
    ],
    operationType: wantAgent.OperationType.START_ABILITIES,
    requestCode: 0,
    wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
  };

  wantAgent.getWantAgent(wantAgentInfo).then((data) => {
    Logger.info(TAG, `startBackground begin`)
    backgroundTaskManager.startBackgroundRunning(featureAbility.getContext(), backgroundTaskManager.BackgroundMode.DATA_TRANSFER, data, callback)
  })
}

export default {
  onStart() {
    Logger.info(TAG, 'ServiceAbility onStart')
    startContinuousTask()
  },
  onStop() {
    Logger.info(TAG, 'ServiceAbility onStop')
    backgroundTaskManager.stopBackgroundRunning(featureAbility.getContext())
  },
  onCommand(want, startId) {
    Logger.info(TAG, 'ServiceAbility onCommand')
  }
}