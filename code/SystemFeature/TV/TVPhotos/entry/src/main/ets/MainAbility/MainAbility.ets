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
import Logger from '../common/Logger';
import { GlobalContext } from '../common/GlobalContext';
import Ability from '@ohos.app.ability.UIAbility';
import { AbilityConstant } from '@kit.AbilityKit';

const TAG = 'MainAbility: ';

export default class MainAbility extends Ability {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    console.info(TAG, 'ability on create ' + JSON.stringify(want))
    globalThis.startByFileMgr = false;
    this.handleWant(want);
  }

  onNewWant(want: Want, launchParams: AbilityConstant.LaunchParam): void {
    console.info(TAG, 'ability on newWant ' + JSON.stringify(want))
    this.handleWant(want)
  }

  onDestroy(): void {
    AppStorage.clear();
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    Logger.info(TAG, 'onWindowStageCreate')
    GlobalContext.getContext().setObject('photosWindowStage', windowStage);
    globalThis.abilityContext = this.context;
    windowStage.getMainWindow().then((win) => {
      globalThis.mainWindow = win;
      AppStorage.setOrCreate('window_width', win.getWindowProperties().windowRect.width);
      AppStorage.setOrCreate('window_height', win.getWindowProperties().windowRect.height);
      let loadContentUrl = 'pages/PhotoWatch';
      Logger.info(TAG, 'onWindowStageCreate loadContent')
      windowStage.loadContent(loadContentUrl, (err) => {
        if (err.code) {
          return;
        }
      })
    })
  }

  handleWant(want: Want) {
    let picUri: string = want?.parameters?.uri as string;
    let picType: string = want?.parameters?.type as string;
    let close: boolean = want?.parameters?.close as boolean
    if (close) {
      this.context.terminateSelf()
    } else if (picUri) {
      Logger.info(TAG, 'receive from file manager, picUri=' + picUri);
      globalThis.startByFileMgr = true;
      AppStorage.setOrCreate('directUri', picUri);
      AppStorage.setOrCreate('directType', picType);
      return;
    }
  }
}
