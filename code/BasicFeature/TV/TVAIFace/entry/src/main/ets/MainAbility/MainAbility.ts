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

import { hilog } from '@kit.PerformanceAnalysisKit';
import Ability from '@ohos.app.ability.UIAbility';
import { window as Window } from '@kit.ArkUI';
import { display } from '@kit.ArkUI';
import { deviceInfo } from '@kit.BasicServicesKit';
import { getAppWindowSize } from '../utils/utils';
import { userGrantPermission } from '../utils/permission';
import { globalThis } from '../common/globalThis';

export default class MainAbility extends Ability {
  onCreate(want, launchParam) {
    globalThis.get().setCameraSettingContext(this.context);
    globalThis.get().setObject("deviceType", 'default');
    let softwareModel: string = deviceInfo.softwareModel.toLowerCase();
    if (softwareModel.startsWith('tv')) {
      globalThis.get().setObject("deviceType", 'tv');
    }
  }

  onDestroy() {
    hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  async onWindowStageCreate(windowStage: Window.WindowStage) {
    // Main window is created, set main page for this ability
    hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    // 屏幕宽高
    globalThis.get().setObject("screenWidth", (await this.getWindowDisplayData()).width);
    globalThis.get().setObject("screenHeight", (await this.getWindowDisplayData()).height);
    windowStage.getMainWindow().then((win: Window.Window) => {
      globalThis.get().setObject("mainWindow", win);
      win.setWindowKeepScreenOn(true).then(() => {
      });
      getAppWindowSize(win).then((data) => {
        AppStorage.setOrCreate<number>('screen_px_w', data.pageW);
        AppStorage.setOrCreate<number>('screen_px_h', data.pageH);
        AppStorage.setOrCreate<number>('screen_lpx_w', data.width);
        AppStorage.setOrCreate<number>('screen_lpx_h', data.height);
        AppStorage.setOrCreate<number>('screen_dpi', data.dpi);
        AppStorage.setOrCreate<number>('screen_lpi', data.lpi);
        globalThis.get().setObject("lpi", data.lpi);
        globalThis.get().setObject('lpiPx', (num: number) => {
          return (globalThis.get().getObject("lpi") as number) * num + 'px';
        });

        windowStage.loadContent('pages/index', (err, data) => {
          if (err.code) {
            hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.ERROR);
            hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
            return;
          }
          hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
          hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s',
            JSON.stringify(data) ?? '');
        });
      });
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
    this.context.terminateSelf();
  }

  private async getWindowDisplayData() {
    let displayData: display.Display = null;
    try {
      displayData = display.getDefaultDisplaySync();
    } catch (err) {
      console.info(`getWindowDisplayData error: ${err}`);
    }
    return displayData;
  }
};
