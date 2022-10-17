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

import Ability from '@ohos.application.Ability'
import { logger } from '@ohos/details-page-component'
import { notificationUtil } from '@ohos/notification'

const TAG: string = 'MainAbility'
const PERMISSIONS: Array<string> = [
  'ohos.permission.CAMERA',
  'ohos.permission.MICROPHONE',
  'ohos.permission.READ_MEDIA',
  'ohos.permission.WRITE_MEDIA',
  'ohos.permission.MEDIA_LOCATION',
  'ohos.permission.INTERNET'
]

export default class MainAbility extends Ability {
  onCreate(want, launchParam) {
    logger.info(TAG, 'onCreate')
    const that = this
    this.context.eventHub.on("getAbilityData", (data) => {
      data.context = that.context
      data.launchWant = want
    })
    this.requestPermission()
  }

  requestPermission = async () => {
    await this.context.requestPermissionsFromUser(PERMISSIONS)
    await notificationUtil.enableNotification()
  }

  onDestroy() {
    logger.info(TAG, 'onDestroy')
  }

  onWindowStageCreate(windowStage) {
    // Main window is created, set main page for this ability
    logger.info(TAG, 'onWindowStageCreate')

    windowStage.setUIContent(this.context, 'pages/Index', null)
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    logger.info(TAG, 'onWindowStageDestroy')
  }

  onForeground() {
    // Ability has brought to foreground
    logger.info(TAG, 'MainAbility onForeground')
  }

  onBackground() {
    // Ability has back to background
    logger.info(TAG, 'onBackground')
  }
}