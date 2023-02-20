/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import Window from '@ohos.window'
import { Logger } from '../utils/Logger'
import { WorkSchedulerSystem } from '../feature/WorkSchedulerSystem'

const VERSION: string = '1.0'
const BUNDLE_NAME = 'ohos.samples.workschedulerextensionability'
const PERMISSION = ['ohos.permission.INTERNET', 'ohos.permission.INSTALL_BUNDLE',
  'ohos.permission.NOTIFICATION_CONTROLLER']

export default class MainAbility extends Ability {
  onCreate(want, launchParam) {
    this.context.requestPermissionsFromUser(PERMISSION)
    AppStorage.SetOrCreate('filePath', this.context.filesDir)
  }

  onWindowStageCreate(windowStage: Window.WindowStage) {
    WorkSchedulerSystem.handleNotification(BUNDLE_NAME)
    WorkSchedulerSystem.startUpdateSample(VERSION, BUNDLE_NAME, this.context.filesDir)
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        Logger.error('Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '')
        return
      }
      Logger.info('Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '')
    })
  }
}