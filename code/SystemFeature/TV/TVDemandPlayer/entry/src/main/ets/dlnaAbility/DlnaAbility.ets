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
import { AbilityConstant } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { UIAbility } from '@kit.AbilityKit';
import { Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import dmrnapi from '@ohos.dmrnapi';
import { systemParameterEnhance } from '@kit.BasicServicesKit';
import { getAppWindowSize } from '@ohos/utilslibrary';

export default class DlnaAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    let parameters = want.parameters
    console.log(`EntryAbility onCreate Want_Parameters : ${JSON.stringify(parameters)}`);
    let ip :string= JSON.stringify(want.parameters?.clientIp)
    console.log(`EntryAbility onCreate Want_IP : ${JSON.stringify(ip)}`);
    AppStorage.setOrCreate('IP', ip);
    AppStorage.setOrCreate('IsTrust', false);
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy and dlnaplayer stop');
    dmrnapi.Stop();
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    AppStorage.setOrCreate('window', windowStage);
    let windowClass: window.Window | null = null;
    windowStage.getMainWindow((err: BusinessError, data) => {
      data.setWindowLayoutFullScreen(true)
      getAppWindowSize(data).then((winSize)=>{
        AppStorage.setOrCreate<number>('screen_px_w', winSize.pageW)
        AppStorage.setOrCreate<number>('screen_px_h', winSize.pageH)
        AppStorage.setOrCreate<number>('screen_lpx_w', winSize.width)
        AppStorage.setOrCreate<number>('screen_lpx_h', winSize.height)
        AppStorage.setOrCreate<number>('screen_dpi', winSize.dpi)
        AppStorage.setOrCreate<number>('screen_lpi', winSize.lpi)
      })
      let errCode: number = err.code;
      if (errCode) {
        console.error('Failed to obtain the main window. Cause: ' + JSON.stringify(err));
        return;
      }
      windowClass = data;
      console.info('Succeeded in obtaining the main window. Data: ' + JSON.stringify(data));
      try {
        let properties: window.WindowProperties = windowClass.getWindowProperties();
        console.info('Succeeded to obtain the window properties. windowRect: ' + JSON.stringify(properties.windowRect));
        AppStorage.setOrCreate('windowsize', properties);

      } catch (exception) {
        console.error('Failed to obtain the window properties. Cause: ' + JSON.stringify(exception));
      }
    })
    windowStage.loadContent('pages/DlnaPlayer', (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }

}
