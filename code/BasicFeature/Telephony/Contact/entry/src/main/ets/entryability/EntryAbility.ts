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

import UIAbility from '@ohos.app.ability.UIAbility'
import Window from '@ohos.window'
import contact from '@ohos.contact'
import Logger from '../data/Logger'
import abilityAccessCtrl from '@ohos.abilityAccessCtrl'

const TAG = 'EntryAbility'

export default class EntryAbility extends UIAbility {
  async onCreate(want, launchParam) {
    let atManager = abilityAccessCtrl.createAtManager()
    globalThis.abilityContext = this.context
    try {
      atManager.requestPermissionsFromUser(this.context, ['ohos.permission.WRITE_CONTACTS', 'ohos.permission.READ_CONTACTS']).then((data) => {
        // 监听是否获取到了权限
        if (!data.authResults.includes(-1)) {
          AppStorage.SetOrCreate('hasPermission', true)
        }
      }).catch((err) => {
        Logger.info(TAG, `err: ${JSON.stringify(err)}`)
      })
    } catch (err) {
      Logger.info(TAG, `catch err->${JSON.stringify(err)}`);
    }
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
