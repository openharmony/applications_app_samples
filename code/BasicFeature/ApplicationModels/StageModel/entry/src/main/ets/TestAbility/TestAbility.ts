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

import UIAbility from '@ohos.app.ability.UIAbility'
import commonEvent from '@ohos.commonEvent'
import notification from '@ohos.notificationManager'
import Logger from '../util/Logger'

const TAG: string = '[SecondAbility]'
const windowCreateContent = {
  contentType: notification.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
  normal: {
    text: 'onWindowStageCreate',
    title: 'TestAbility'
  }
}

let request = {
  id: 3, // ID of the pulled ability
  content: windowCreateContent
}

export default class TestAbility extends UIAbility {
  onCreate(want, launchParam) {
    Logger.info(TAG, `onCreate, want is: ${JSON.stringify(want)}`)
  }

  onWindowStageCreate(windowStage) {
    // Main window is created, set main page for this ability
    Logger.info(TAG, 'onWindowStageCreate')
    commonEvent.publish('SecondAbility_onCreate_CommonEvent', () => {
      Logger.info(TAG, `onWindowStageCreate commonEvent publish SecondAbility_onCreate_CommonEvent`)
    })
    notification.publish(request, (err, data) => {
      if (err) {
        Logger.error(TAG, `onWindowStageCreate notification publish failed: ${err.code}`)
        return
      } else {
        Logger.info(TAG, `onWindowStageCreate notification publish success: ${JSON.stringify(data)}`)
      }
    })

    windowStage.setUIContent(this.context, 'pages/TestPage', null)
  }

  onForeground() {
    // Ability has brought to foreground
    Logger.info(TAG, 'onForeground')
  }

  onBackground() {
    // Ability has back to background
    Logger.info(TAG, 'onBackground')
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    Logger.info(TAG, 'onWindowStageDestroy')
  }

  onDestroy() {
    Logger.info(TAG, 'onDestroy')
  }
}
