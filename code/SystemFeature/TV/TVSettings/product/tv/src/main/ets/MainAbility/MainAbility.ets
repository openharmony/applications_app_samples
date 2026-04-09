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

import ConfigData from '../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import LogUtil from '../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';

import display from '@ohos.display';
import screen from '@ohos.screen';
import CommonEvent from '@ohos.commonEvent';
import settings from '@ohos.settings';
import { AbilityConstant, common, missionManager, UIAbility, Want } from '@kit.AbilityKit';
import PreferenceUtils, { BooleanPreferences } from '../common/UserStorageManager';
import { commonEventManager } from '@kit.BasicServicesKit';
import { window } from '@kit.ArkUI';
import audioSetting from '@ohos.tvservice.audioSetting';
import { inputConsumer, KeyCode } from '@kit.InputKit';
import { JSON } from '@kit.ArkTS';

class PageRouteMap {
  public ETH: string = 'pages/network/WiredNetwork';
  public BLUETOOTH: string = 'pages/bluetooth/BluetoothDeviceEntry';
  public WIFI: string = 'pages/network/Wifi';
  public MIRACAST: string = 'pages/links/Links';
  public NET: string = 'pages/network/Network';
}

class MainAbilityParams {
  public pageUrl: string = '';
  public callerBundleName: string = '';
}

class MainAbilityWant {
  public parameters: MainAbilityParams = new MainAbilityParams();
}

class ServiceAbilityWant {
  public bundleName: string = '';
  public abilityName: string = '';
}

class AbilityError {
  public code: number = 0;
  public message: string = '';
}

AppStorage.setOrCreate('defaultInputSource', false)
AppStorage.setOrCreate('defaultFloatBall', true)

export function commonEventDataFunc(defaultInputSource: boolean) {
  let commonEventData: commonEventManager.CommonEventPublishData = {
    parameters: {
      defaultInputSource: defaultInputSource,
    }
  };
  commonEventManager.publish('defaultInputSource', commonEventData, (err) => {
  });
}

export function commonEventFloatBallDataFunc(defaultFloatBall: boolean) {
  let commonEventData: commonEventManager.CommonEventPublishData = {
    parameters: {
      defaultFloatBall: defaultFloatBall,
    }
  };
  commonEventManager.publish('defaultFloatBall', commonEventData, (err) => {
    if (err) {
      console.error(`float ball publish error: ${err.code}, ${err.message}`);
      return;
    } else {
      console.info(`float ball push defaultFloatBall msg success:`, `${JSON.stringify(commonEventData)}`);
    }
  });
}

export function commonEvents(inputSourceType: string) {
  let commonEvents: commonEventManager.CommonEventPublishData = {
    parameters: {
      InputSourceType: inputSourceType,
    }
  };
  try {
    commonEventManager.publish('InputSourceType', commonEvents, (err) => {
      console.log('=-= commonEventFunc: ' + JSON.stringify(err));
    });
  } catch (err) {
    LogUtil.error(ConfigData.TAG + 'commonEventFunc: ' + JSON.stringify(err));
  }
}

export function commonEventScreenOffTimeDataFunc(screenOffTimeBoolean: boolean) {
  let commonEventData: commonEventManager.CommonEventPublishData = {
    parameters: {
      screenOffTimeBoolean: screenOffTimeBoolean,
    }
  };
  try {
    commonEventManager.publish('screenOffTimeBoolean', commonEventData, (err) => {
      console.log('onSystemEvent screenOffTimeBoolean Err:' + JSON.stringify(err));
    });
  } catch (err) {
    LogUtil.error(ConfigData.TAG + 'onSystemEvent screenOffTimeBoolean Catch Err:' + JSON.stringify(err));
  }
}

export function commonScreenOffTimeEvents(screenOffTime: string) {
  let commonEvents: commonEventManager.CommonEventPublishData = {
    parameters: {
      screenOffTime: screenOffTime,
    }
  };
  try {
    commonEventManager.publish('screenOffTime', commonEvents, (err) => {
      console.log('onSystemEvent commonScreenOffTime Err:' + JSON.stringify(err));
    });
  } catch (err) {
    LogUtil.error(ConfigData.TAG + 'commonScreenOffTime Catch Err:' + JSON.stringify(err));
  }
}

//HDMI
const SETTINGS_RESOLUTION = 'settings.resolution';
const TARGET_BUNDLE_NAME = 'com.ohos.applicationmanager';
const PAGE_ROUTE_MAP = new PageRouteMap();

function getTargetPage(pageUrl: string): string {
  if (pageUrl === 'ETH') {
    return PAGE_ROUTE_MAP.ETH;
  }
  if (pageUrl === 'BLUETOOTH') {
    return PAGE_ROUTE_MAP.BLUETOOTH;
  }
  if (pageUrl === 'WIFI') {
    return PAGE_ROUTE_MAP.WIFI;
  }
  if (pageUrl === 'MIRACAST') {
    return PAGE_ROUTE_MAP.MIRACAST;
  }
  if (pageUrl === 'NET') {
    return PAGE_ROUTE_MAP.NET;
  }
  return '';
}

function getCallerBundleName(want: Want): string {
  const wantString = JSON.stringify(want);
  const matches = wantString.match(/"ohos\.aafwk\.param\.callerBundleName"\s*:\s*"([^"]*)"/);
  if (!matches || matches.length < 2) {
    return '';
  }
  return matches[1];
}

export default class MainAbility extends UIAbility {
  private preDataFlush: BooleanPreferences | null = null;

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    LogUtil.info(ConfigData.TAG + 'Application onCreate ===> want: ' + JSON.stringify(want))
    if (want) {
      const callerBundleName = getCallerBundleName(want);
      AppStorage.setOrCreate('isPull', callerBundleName === TARGET_BUNDLE_NAME)
    }
    globalThis.abilityWant = want;
    globalThis.AbilityLauncherParam = launchParam
    globalThis.settingsAbilityContext = this.context
    let inputSourceInfo: string =
      settings.getValueSync(this.context, ConfigData.SETTINGSDATA_HDMISELECT, '', settings.domainName.DEVICE_SHARED);
    let inputSourceItem: string = (inputSourceInfo !== '') ? inputSourceInfo : 'HDMI1'
    AppStorage.setOrCreate('inputSourceItem', inputSourceItem)
    commonEvents(inputSourceItem)
    this.preDataFlush = new BooleanPreferences(this.context);
    this.preDataFlush.initialize().catch((error: Error) => {
      LogUtil.error(ConfigData.TAG + 'preDataFlush initialize error: ' + JSON.stringify(error));
    });

    globalThis.resolution =
      settings.getValueSync(globalThis.settingsAbilityContext as common.UIAbilityContext, SETTINGS_RESOLUTION, 'err');
    console.log('=-= get curResolution: ' + JSON.stringify(globalThis.curResolution));
  }

  onNewWant(want: Want, launchParams: AbilityConstant.LaunchParam): void {
    LogUtil.info(ConfigData.TAG +
      `onNewWant. want: ${JSON.stringify(want)}, launchParams: ${JSON.stringify(launchParams)}`)
    const callerBundleName = getCallerBundleName(want);
    AppStorage.setOrCreate('isPull', callerBundleName === TARGET_BUNDLE_NAME)
    globalThis.abilityWant = want;
    globalThis.AbilityLauncherParam = launchParams

    let param: MainAbilityParams = globalThis.abilityWant.parameters as MainAbilityParams
    LogUtil.info(ConfigData.TAG + 'onNewWant ===> param: ' + JSON.stringify(param))

    if (globalThis.windowStage) {
      const pageUrl = param.pageUrl;
      const targetPage = getTargetPage(pageUrl);
      if (targetPage) {
        AppStorage.setOrCreate<boolean>('isFromOther',true)
        globalThis.windowStage.setUIContent(this.context, targetPage);
      } else {
        LogUtil.warn(`未匹配到pageUrl对应的页面，当前pageUrl: ${pageUrl}`);
      }
    }
  }

  onDestroy() {
    try {
      AppStorage.setOrCreate('settingsList', []);
      LogUtil.info(ConfigData.TAG + 'Application onDestroy')
    } catch (error) {
      LogUtil.info(ConfigData.TAG + 'Application onDestroy error' + JSON.stringify(error));
    }
  }

  async onWindowStageCreate(windowStage: window.WindowStage) {
    try {
      let getKeyToneEnable: boolean = await audioSetting.getKeyToneEnable();
      LogUtil.info(ConfigData.TAG + 'getKeyToneEnableSucess===' + getKeyToneEnable);
      if (getKeyToneEnable) {
        AppStorage.setOrCreate('isVolumeOn', true)
      } else {
        AppStorage.setOrCreate('isVolumeOn', false)
      }
    } catch (error) {
      LogUtil.info(ConfigData.TAG + 'getKeyToneEnableFailed=' + JSON.stringify(error));
      AppStorage.setOrCreate('isVolumeOn', false)
    }
    LogUtil.log('[Main] MainAbility onWindowStageCreate')
    globalThis.windowStage = windowStage
    globalThis.screenWidth = (await this.getWindowDisplayData()).width
    globalThis.screenHeight = (await this.getWindowDisplayData()).height
    LogUtil.info(ConfigData.TAG + 'screenWidth: ' + globalThis.screenWidth + ' screenHeight: ' +
    globalThis.screenHeight);
    let param: MainAbilityParams = globalThis.abilityWant.parameters as MainAbilityParams
   if(param.pageUrl && param.pageUrl != 'SETTINGS') {
     AppStorage.setOrCreate<boolean>('isFromOther',true)
   }
    LogUtil.info(ConfigData.TAG + 'onWindowStageCreate ===> param: ' + JSON.stringify(param))
    let window = windowStage.getMainWindowSync()
    AppStorage.setOrCreate('windowId', window.getWindowProperties().id)
    if (param.pageUrl == 'ETH') {
      window.setUIContent('pages/network/WiredNetwork')
    } else if (param.pageUrl == 'BLUETOOTH') {
      window.setUIContent('pages/bluetooth/BluetoothDeviceEntry')
    } else if (param.pageUrl == 'WIFI') {
      window.setUIContent('pages/network/Wifi')
    } else if (param.pageUrl == 'MIRACAST') {
      window.setUIContent('pages/links/Links')
    } else if (param.pageUrl == 'NET') {
      globalThis.windowStage.setUIContent(this.context, 'pages/network/Network')
    } else {
      window.setUIContent('pages/SettingList', () => {
        windowStage.getMainWindow().then((win) => {
          try {
            win.setWindowBackgroundColor('#18181A')
            console.log('setWindowBackgroundColor success')
          } catch (err) {
            console.log('setWindowBackgroundColor err: ', JSON.stringify(err))
          }
        })
      })
    }

    //监听横竖屏切换
    screen.on('change', async (code) => {
      globalThis.screenWidth = (await this.getWindowDisplayData()).width
      globalThis.screenHeight = (await this.getWindowDisplayData()).height
      console.info(`SettingScreen:width=>${globalThis.screenWidth},height==>${globalThis.screenHeight}`)
      AppStorage.setOrCreate('IsVertical', globalThis.screenWidth < globalThis.screenHeight)

    })
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    LogUtil.log('[Main] MainAbility onWindowStageDestroy')
  }

  async onForeground() {
    // Ability has brought to foreground
    LogUtil.log('[Main] MainAbility onForeground')

    CommonEvent.publish('SETTINGS_FOREGROUND', (err) => {
      if (err.code) {
        LogUtil.info(ConfigData.TAG + 'onForeground publish SETTINGS_FOREGROUND err: ' + JSON.stringify(err));
      } else {
        LogUtil.info(ConfigData.TAG + 'onForeground publish SETTINGS_FOREGROUND success')
      }
    });

    this.keyOn(KeyCode.KEYCODE_MOVE_HOME)
    this.keyOn(KeyCode.KEYCODE_HOME)

    globalThis.inSwitchForegrounding = true;
    setTimeout(() => {
      globalThis.inSwitchForegrounding = false
    }, 400)
    // 当Settings在前台时，销毁Settings_Menu
    let want = new ServiceAbilityWant();
    want.bundleName = 'com.ohos.settings';
    want.abilityName = 'com.ohos.settings.menu.ServiceAbility';
    globalThis.settingsAbilityContext.stopServiceExtensionAbility(want, (error: AbilityError) => {
      if (error.code) {
        // 处理业务逻辑错误
        LogUtil.info(ConfigData.TAG + 'onForeground stopServiceExtensionAbility err: ' + JSON.stringify(error));
        return;
      }
      // 执行正常业务
      console.log('stopServiceExtensionAbility succeed');
    });

    // 获取默认输入源开关Status
    // 读取值
    const defaultInputSource = await this.preDataFlush?.getBoolean('defaultInputSource') ?? false
    console.log('MainAbility defaultInputSource', defaultInputSource); // 输出: true
    AppStorage.setOrCreate('defaultInputSource', defaultInputSource)

    const defaultFloatBall = await this.preDataFlush?.getBoolean('defaultFloatBall') ?? false
    console.log('MainAbility defaultFloatBall', defaultFloatBall); // 输出: true
    AppStorage.setOrCreate('defaultFloatBall', defaultFloatBall)
  }

  async pullUpApp() {

    try {
      const missionInfos = await missionManager.getMissionInfos('', 20);
      LogUtil.info(`getMissionInfos successfully. Data: ${JSON.stringify(missionInfos)}`);

      const targetMission = missionInfos.find(item => {
        return item.want?.bundleName === TARGET_BUNDLE_NAME;
      });

      if (targetMission) {
        await missionManager.moveMissionToFront(targetMission.missionId);
      } else {
        LogUtil.warn('未找到指定包名的任务：' + TARGET_BUNDLE_NAME);
      }
    } catch (error) {
      LogUtil.error('getMissionInfos 操作任务失败：' + error);
    }

  }

  keyOn(keyCode: KeyCode) {
    let keyOptions: inputConsumer.KeyOptions = {
      preKeys: [],
      finalKey: keyCode,
      isFinalKeyDown: true,
      finalKeyDownDuration: 500
    };
    let callback = (keyOptions: inputConsumer.KeyOptions) => {
      AppStorage.setOrCreate('isPull', false)
      console.log(`keyOptions: ${JSON.stringify(keyOptions)}`);
    }
    try {
      inputConsumer.on('key', keyOptions, callback);
    } catch (error) {
      console.log(`Subscribe failed, error: ${JSON.stringify(error, [`code`, `message`])}`);
    }
  }

  keyOff(keyCode: KeyCode) {
    let callback = (keyOptions: inputConsumer.KeyOptions) => {
      console.log(`keyOptions: ${JSON.stringify(keyOptions)}`);
    }
    let keyOption: inputConsumer.KeyOptions = {
      preKeys: [],
      finalKey: keyCode,
      isFinalKeyDown: true,
      finalKeyDownDuration: 500
    };
    try {
      inputConsumer.on('key', keyOption, callback);
      inputConsumer.off('key', keyOption, callback);
      console.log(`Unsubscribe`);
    } catch (error) {
      console.log(`Execute failed, error: ${JSON.stringify(error, [`code`, `message`])}`);
    }
  }

  onBackground() {
    if (AppStorage.get<boolean>('isFromOther')) {
      if (this.context && this.context.terminateSelf) {
        this.context.terminateSelf()
      }
    }
    // Ability has back to background
    LogUtil.log('[Main] MainAbility onBackground')

    CommonEvent.publish('SETTINGS_BACKGROUND', (err) => {
      if (err?.code) {
        LogUtil.info(ConfigData.TAG + 'onForeground publish SETTINGS_BACKGROUND err: ' + JSON.stringify(err));
      } else {
        LogUtil.info(ConfigData.TAG + 'onForeground publish SETTINGS_BACKGROUND success')
      }
    });
    console.log('===== , isPull ===', AppStorage.get('isPull'))
    if (AppStorage.get('isPull')) {
      this.pullUpApp()
    }
    AppStorage.setOrCreate('isPull', false)
    this.keyOff(KeyCode.KEYCODE_MOVE_HOME)
    this.keyOff(KeyCode.KEYCODE_HOME)
  }

  private async getWindowDisplayData(): Promise<display.Display> {
    let displayData: display.Display = display.getDefaultDisplaySync()

    return displayData;
  }
};
