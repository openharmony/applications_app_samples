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

const TAG: string = '[Sample_HealthyDiet]'

export default class MainAbility extends Ability {
  onCreate(want, launchParam) {
    console.log(TAG, "MainAbility onCreate")
  }

  onDestroy() {
    console.log(TAG, "MainAbility onDestroy")
  }

  onWindowStageCreate(windowStage) {
    console.log(TAG, "MainAbility onWindowStageCreate")
    windowStage.loadContent("pages/Logo", (err, data) => {
      if (err.code) {
        console.error('Failed to load the content. Cause:' + JSON.stringify(err))
        return
      }
      console.info('Succeeded in loading the content. Data: ' + JSON.stringify(data))
    })
  }

  onWindowStageDestroy() {
    console.log(TAG, "MainAbility onWindowStageDestroy")
  }

  onForeground() {
    console.log(TAG, "MainAbility onForeground")
  }

  onBackground() {
    console.log(TAG, "MainAbility onBackground")
  }
}
