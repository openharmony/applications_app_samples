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

export default class MainAbility extends Ability {
  onCreate(want, launchParam) {
    console.log('[Sample_MusicAlbum] MainAbility onCreate')
  }

  onDestroy() {
    console.log('[Sample_MusicAlbum] MainAbility onDestroy')
  }

  onWindowStageCreate(windowStage) {
    // Main window is created, set main page for this ability
    console.log('[Sample_MusicAlbum] MainAbility onWindowStageCreate')

    windowStage.loadContent("pages/index", (err, data) => {
      if (err.code) {
        console.error('[Sample_MusicAlbum] Failed to load the content. Cause:' + JSON.stringify(err))
        return
      }
      console.info('[Sample_MusicAlbum] Succeeded in loading the content. Data: ' + JSON.stringify(data))
    })
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    console.log('[Sample_MusicAlbum] MainAbility onWindowStageDestroy')
  }

  onForeground() {
    // Ability has brought to foreground
    console.log('[Sample_MusicAlbum] MainAbility onForeground')
  }

  onBackground() {
    // Ability has back to background
    console.log('[Sample_MusicAlbum] MainAbility onBackground')
  }
};
