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
import commonEvent from '@ohos.commonEvent'
import consts from '../module/Consts'
import dataPreferences from '@ohos.data.preferences'
import surveillanceEventsManager from '../module/SurveillanceEventsManager'
import Logger from '../module/Logger'

export default class LauncherAbility extends Ability {
  onCreate(want) {
    globalThis.abilityWant = want
    let settings: Map<string, number> = new Map()
    surveillanceEventsManager.surveillanceEvents.forEach((element: string) => {
      settings.set(element, consts.ENABLE_STATE_ALWAYS)
    })
    globalThis.settings = settings
  }

  async onDestroy() {
    Logger.info("LauncherAbility onDestroy")
    globalThis.settings.forEach((value: number, key: string) => {
      if (value == consts.ENABLE_STATE_ONCE) {
        globalThis.settings.set(key, consts.ENABLE_STATE_NEVER)
      }
    })
    let thisPref = null
    await dataPreferences.getPreferences(this.context, consts.DATA_BASE_NAME).then((pref) => {
      thisPref = pref
    })
    for (let element of surveillanceEventsManager.surveillanceEvents) {
      await thisPref.put(element, globalThis.settings.get(element))
    }
    await thisPref.flush()
    let options = {
      isSticky: true,
      parameters: surveillanceEventsManager.getSurveillanceEventStates()
    }
    await commonEvent.publish(consts.COMMON_EVENT_SETTING_UPDATE, options, () => {
      Logger.info("success to publish once enable event")
    })
  }

  onWindowStageCreate(windowStage) {
    // Main window is created, set main page for this ability
    windowStage.loadContent("pages/Launch", (err, data) => {
      if (err.code) {
        Logger.error('Failed to load the content. Cause:' + JSON.stringify(err));
        return;
      }
      Logger.info('Succeeded in loading the content. Data: ' + JSON.stringify(data))
    })
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    Logger.info("LauncherAbility onWindowStageDestroy")
  }

  onForeground() {
    // Ability has brought to foreground
    Logger.info("LauncherAbility onForeground")
  }

  onBackground() {
    // Ability has back to background
    Logger.info("LauncherAbility onBackground")
  }
}
