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
import contact from '@ohos.contact'
import Logger from '../data/Logger'

export default class EntryAbility extends Ability {
  async onCreate(want, launchParam) {
    globalThis.abilityContext = this.context
    await this.context.requestPermissionsFromUser(['ohos.permission.WRITE_CONTACTS', 'ohos.permission.READ_CONTACTS'])
    contact.queryContacts((err, data) => {
      if (err) {
        Logger.info(`queryContacts callback: err->${JSON.stringify(err)}`)
        return
      }
      Logger.info(`queryContacts callback: success data->${JSON.stringify(data)}`)
    })
  }

  onWindowStageCreate(windowStage: Window.WindowStage) {
    // Main window is created, set main page for this ability
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        Logger.error(`Failed to load the content. Cause: ${JSON.stringify(err)}`)
        return
      }
      Logger.error(`Succeeded in loading the content. Data: ${JSON.stringify(data)}`)
    })
  }
}
