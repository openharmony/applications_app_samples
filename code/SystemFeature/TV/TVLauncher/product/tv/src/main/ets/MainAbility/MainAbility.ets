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
 
import { ServiceExtensionAbility, Want } from '@kit.AbilityKit';
import { display } from '@kit.ArkUI';
import { Log } from '../../../../../../common/src/main/ets/default/utils/Log';
import { windowManager } from '../../../../../../common/src/main/ets/default/manager/WindowManager';
import { systemDateTime } from '@kit.BasicServicesKit';
import PreferenceUtils from '../common/baseUtil/PreferenceUtil';

export interface commonEventParma<T> {
  event: string;
  bundleName: string;
  code: number;
  data: string;
  parameters: eventParma<T>
}

export interface eventParma<T> {
  T: boolean;
  moduleName: string;
}


const TAG = 'LauncherMainAbility';

interface ScreenDisplayData {
  width: number;
  height: number;
}

let isSetup = true
let isSetupIncomplete = true

export default class MainAbility extends ServiceExtensionAbility {
  async onCreate(want: Want): Promise<void> {
    Log.showInfo(TAG, 'onCreate start');
    this.initLauncher();

    // 是否为开机状态
    const isReboot = this.checkReboot()
    AppStorage.setOrCreate('isReboot', isReboot)

    this.initSetup()
  }

  initSetup() {
    let preInstance = new PreferenceUtils<boolean>(this.context, true)
    // 是否为首次开机
    let storedIsFirstSetup = preInstance.getPreValue('isFirstSetup')
    isSetup = storedIsFirstSetup===undefined ? true : storedIsFirstSetup
    // 是否未完成开机向导
    let storedSetupComplete = preInstance.getPreValue('setupWizardComplete')
    isSetupIncomplete = storedSetupComplete === undefined ? true : storedSetupComplete

    console.log('是否为首次开机,isSetup:' + isSetup)
    console.log('是否未完成开机向导,isSetupIncomplete:' + isSetupIncomplete)

    if (isSetup || isSetupIncomplete) {
      try {
        this.liftUpApp('com.ohos.setupwizard');
        preInstance.setPreValue('isFirstSetup', false)
      } catch (e) {
        Log.showInfo(TAG, 'fail to openAppLink' + `${e}`);
      }
    }
  }

  liftUpApp(appBundleName: string) {
    let want: Want = {
      deviceId: '',
      bundleName: appBundleName,
      abilityName: 'EntryAbility',
      parameters: {}
    };
    try {
        this.context.startAbility(want, (error) => {
          Log.showError(TAG, `start openAppLink catch error ${JSON.stringify(error)}+${appBundleName}`);
      })
    } catch (e) {
      console.error(TAG, `start openAppLink fail+${appBundleName}`, JSON.stringify(e));
    }
  }

  getSystemStartTime(): number {
    let openGetUptime = systemDateTime.getUptime(systemDateTime.TimeType.ACTIVE)
    const time = new Date()
    const curTime = time.getTime()
    const systemStartTime = curTime - openGetUptime
    return systemStartTime
  }

  checkReboot(): boolean {
    let prefer = new PreferenceUtils<number | boolean>(this.context, false)
    const currentUptime = this.getSystemStartTime();
    const lastUptime = prefer.getPreValue('lastBootTime') as number;
    const hasHandled = prefer.getPreValue('hasHandledAfterReboot') as boolean;

    if ((currentUptime != lastUptime) || !hasHandled) {
      prefer.setPreValue('lastBootTime', currentUptime);
      prefer.setPreValue('hasHandledAfterReboot', false);
      return true;
    }
    return false;
  }

  async initLauncher(): Promise<void> {
    globalThis.desktopContext = this.context;
    const displayData = await this.getWindowDisplayData();
    if (displayData != null) {
      globalThis.screenWidth = displayData.width
      globalThis.screenHeight = displayData.height
    } else {
      globalThis.screenWidth = 0
      globalThis.screenHeight = 0
    }
    Log.showInfo(TAG, 'screenWidth: ' + globalThis.screenWidth + ' screenHeight: ' + globalThis.screenHeight);

    this.initGlobalConst();

    AppStorage.setOrCreate('firstActivate', true);

    windowManager.registerWindowEvent();
    windowManager.createWindow(globalThis.desktopContext, windowManager.DESKTOP_WINDOW_NAME,
      windowManager.DESKTOP_RANK, 'pages/' + windowManager.DESKTOP_WINDOW_NAME, true);
    this.listenDisplayOrientationChange()
  }

  private listenDisplayOrientationChange() {
    display.on('change', async (number) => {
      const displayData = await this.getWindowDisplayData();
      if (displayData != null) {
        globalThis.screenWidth = displayData.width
        globalThis.screenHeight = displayData.height
        AppStorage.setOrCreate<number>('screenWidth', displayData.width);
        AppStorage.setOrCreate<number>('screenHeight', displayData.height);
      }

      Log.showInfo(TAG,
        `listenDisplayOrientationChange change number: ${number}, screenWidth: ${globalThis.screenWidth}, screenHeight: ${globalThis.screenHeight}`);
    })
  }

  private initGlobalConst(): void {
    globalThis.createWindowWithName = ((windowName: string, windowRank: number): void => {
      Log.showInfo(TAG, `createWindowWithName begin windowName: ${windowName}`);
      if (windowName !== windowManager.RECENT_WINDOW_NAME) {
        windowManager.createWindowIfAbsent(globalThis.desktopContext, windowName, windowRank, 'pages/' + windowName);
      }
    });
  }

  onDestroy(): void {
    Log.showInfo('HmLog-->', 'onDestroy success');
    windowManager.unregisterWindowEvent();
    windowManager.destroyWindow(windowManager.DESKTOP_WINDOW_NAME);
    windowManager.destroyRecentWindow();
    Log.showInfo(TAG, 'onDestroy success');
  }

  onRequest(want: Want, startId: number): void {
    console.log('HmLog-->onRequest');
    Log.showInfo(TAG, `onRequest, want:${want.abilityName}`);

    let preInstance = new PreferenceUtils<boolean>(this.context, true)
    isSetup = preInstance.getPreValue('isFirstSetup')
    isSetupIncomplete = preInstance.getPreValue('setupWizardComplete')
    Log.showInfo(TAG, 'minimizeAllApps', 'isSetup:', `${isSetup}`, 'isSetupIncomplete:', `${isSetupIncomplete}`);
    AppStorage.setOrCreate('isNoCompleteHomePress', isSetupIncomplete)
    AppStorage.setOrCreate('isSetupHomePress', isSetup)

    if (!(isSetup || isSetupIncomplete)) {
      windowManager.minimizeAllApps();
    }
  }


  private async getWindowDisplayData(): Promise<ScreenDisplayData | null> {
    let displayData: ScreenDisplayData | null = null;
    await display.getDefaultDisplay()
      .then((res: ScreenDisplayData) => {
        displayData = {
          width: res.width,
          height: res.height
        };
      }).catch((_err: Error) => {

      });
    return displayData;
  }
}
