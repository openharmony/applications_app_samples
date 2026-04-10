/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
 
import type window from '@ohos.window';
import type { Permissions } from '@ohos.abilityAccessCtrl';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import Logger from '../common/Logger';
import { GlobalContext } from '../common/GlobalContext';
import Ability from '@ohos.app.ability.UIAbility';
import { BusinessError } from '@ohos.base';
import { AbilityConstant } from '@kit.AbilityKit';
import photoManager from '../manager/PhotoManager';
import { getAllMediaItems } from '../manager/loader/MediaTasks';
import { rdbManager } from '../manager/RdbManager';
import nasSessionManager from '../smaba/NasSessionManager';

const TAG = 'EntryAbility: ';

export default class EntryAbility extends Ability {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    console.info(TAG, 'ability on create ' + JSON.stringify(want))
    photoManager.init(this.context)
    nasSessionManager.init(this.context)
  }

  onDestroy(): void {
    AppStorage.clear();
  }

  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    Logger.info(TAG, 'onWindowStageCreate')
    GlobalContext.getContext().setObject('photosWindowStage', windowStage);
    globalThis.abilityContext = this.context;
    await rdbManager.init(this.context);
    rdbManager.creatDfsDB();
    windowStage.getMainWindow().then((win) => {
      globalThis.mainWindow = win;
      AppStorage.setOrCreate('window_width', win.getWindowProperties().windowRect.width);
      AppStorage.setOrCreate('window_height', win.getWindowProperties().windowRect.height);
      let loadContentUrl = 'pages/Index';
      Logger.info(TAG, 'onWindowStageCreate loadContent')
      windowStage.loadContent(loadContentUrl, (err) => {
        if (err.code) {
          return;
        }
      })
    })
  }

}