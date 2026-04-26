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
 

import { display, window } from '@kit.ArkUI';
import { ServiceExtensionAbility, Want } from '@kit.AbilityKit';
import NavBarConfiguration from '../../../../../../../features/navigationservice/src/main/ets/com/ohos/navigationservice/common/NavBarConfiguration';
import { BusinessError, commonEventManager } from '@kit.BasicServicesKit';
import { inputConsumer, inputMonitor, KeyCode } from '@kit.InputKit';

import NavigationBarEventModel from '../viewmodel/NavigationBarEventModel'
import { inputMethodEngine } from '@kit.IMEKit';
import Log from '@ohos/common/src/main/ets/default/Log';
import WindowManager,{WindowType} from '@ohos/common/src/main/ets/default/WindowManager';
import AbilityManager from '@ohos/common/src/main/ets/default/abilitymanager/AbilityManager';
import { GlobalThis } from '@ohos/common/src/main/ets/util/GlobalThis';

const TAG = 'NavigationBar_ServiceExtAbility';
let commonEventSubscribeInfo = {events:['common.event.SPLIT_SCREEN']};
const splitBarMode = 'SplitBarComponentMode'
const splitScreenEventData ={
  Show:'common.event.SPLIT_SCREEN.data.show.divider',
  Destory:'common.event.SPLIT_SCREEN.data.destroy.divider'
}

class ServiceExtAbility extends ServiceExtensionAbility {
  private direction :number;

  async onCreate(want: Want): Promise<void> {
    Log.showInfo(TAG, `onCreate, want: ${JSON.stringify(want)}`);
    AbilityManager.setContext(AbilityManager.ABILITY_NAME_NAVIGATION_BAR, this.context);
    display.on('change', (id) => {
      Log.showInfo(TAG, 'display change, data: ' + JSON.stringify(id))
      display.getAllDisplay().then((arrayDisplay) => {
        Log.showInfo(TAG, 'getAllDisplay : ' + JSON.stringify(arrayDisplay))
        for (let display of arrayDisplay) {
          Log.showInfo(TAG, 'getAllDisplay start : ' + JSON.stringify(arrayDisplay));
          if (id == display.id) {
            let nowDirection = -1;
            if (display.width > display.height) {
              nowDirection = 1;
              let spilitBarDirection =AppStorage.setAndLink(splitBarMode, true)
              spilitBarDirection.set(true)
            } else {
              nowDirection = 2;
              let spilitBarDirection =AppStorage.setAndLink(splitBarMode, false)
              spilitBarDirection.set(false)
            }
            if (nowDirection != this.direction) {
              this.createNewWindow(false);
            }
          }
        }
      })
    })

    // 监听home按键，并返回主界面
    const homeKeyOptions: inputConsumer.KeyOptions = {
      preKeys: [],
      finalKey: KeyCode.KEYCODE_MOVE_HOME,
      isFinalKeyDown: true,
      finalKeyDownDuration: 0
    }
    const homeCb = (keyOptions: inputConsumer.KeyOptions) => {
      NavigationBarEventModel.homeEvent();
    }
    inputConsumer.on('key', homeKeyOptions, homeCb)

    this.createNewWindow(true);

    this.volumeCeListener()

    this.screenCeListener()
    // 默认Settings_Menu可以被弹出
    globalThis.isSettingsOnForeground = false
    // 接收Settings的通知，当Settings在前台时，禁止弹出Settings_Menu
    commonEventManager.createSubscriber({events: ['SETTINGS_FOREGROUND']})
      .then((commonEventSubscriber) => {
        console.log('=-= createSubscriber success, commonEventSubscriber: ' + JSON.stringify(commonEventSubscriber));
        commonEventManager.subscribe(commonEventSubscriber, (err, data) => {
          console.log('=-= createSubscriber success, commonEventSubscriber: ' + JSON.stringify(commonEventSubscriber));
          if(err?.code !== 0){
            console.log('=-= subscribe err, err: ' + JSON.stringify(err));
            return;
          }
          console.log('=-= PowerServiceExtAbility subscribe, data: ' + JSON.stringify(data.event));

          globalThis.isSettingsOnForeground = true
        })
      })
      .catch((err) => {
        console.log('=-= createSubscriber fail, err: '+ JSON.stringify(err));
      })

    // 接收Settings的通知，当Settings在后台时，可以弹出Settings_Menu
    commonEventManager.createSubscriber({events: ['SETTINGS_BACKGROUND']})
      .then((commonEventSubscriber) => {
        console.log('=-= createSubscriber success, commonEventSubscriber: ' + JSON.stringify(commonEventSubscriber));
        commonEventManager.subscribe(commonEventSubscriber, (err, data) => {
          console.log('=-= createSubscriber success, commonEventSubscriber: ' + JSON.stringify(commonEventSubscriber));
          if(err?.code !== 0){
            console.log('=-= subscribe err, err: ' + JSON.stringify(err));
            return;
          }
          console.log('=-= PowerServiceExtAbility subscribe, data: ' +JSON.stringify(data.event));

          globalThis.isSettingsOnForeground = false
        })
      })
      .catch((err) => {
        console.log('=-= createSubscriber fail, err: '+ JSON.stringify(err));
      })
  }

  // U盘热插拔事件监听
  volumeCeListener() {
    Log.showInfo(TAG, `volumeCeListener init`);
    commonEventManager.createSubscriber({events: [
      'usual.event.data.VOLUME_REMOVED',
      'usual.event.data.VOLUME_UNMOUNTED',
      'usual.event.data.VOLUME_MOUNTED',
      'usual.event.data.VOLUME_BAD_REMOVAL',
      'usual.event.data.VOLUME_EJECT'
    ]})
      .then((commonEventSubscriber) => {
        commonEventManager.subscribe(commonEventSubscriber, (err, data) => {
          if(err?.code !== 0){
            return;
          }
          Log.showInfo(TAG, `commonEvent: ${JSON.stringify(data.event)}`);

          if (data.event == 'usual.event.data.VOLUME_MOUNTED') {
            GlobalThis.setVolumeDialogText('U盘已插入');
          } else {
            GlobalThis.setVolumeDialogText('U盘已弹出');
          }
          this.initVolumeDialogWindow()
        })
      })
      .catch((err) => {
      })
  }

  private initVolumeDialogWindow() {
    if (globalThis.volumeDialogWindow != undefined) {
      globalThis.volumeDialogWindow.destroy();
      globalThis.volumeDialogWindow = undefined;
    }

    window.create(this.context, 'volume_dialog', 2117).then((win) => {
      globalThis.volumeDialogWindow = win

      win.loadContent('pages/volumeDialog').then(() => {
        win.setBackgroundColor('#00000000').then(() => {
          win.show().then(()=>{
            setTimeout(()=>{
              globalThis.volumeDialogWindow.destroy();
              globalThis.volumeDialogWindow = undefined;
            }, 2000)
          })
        })
      })
    })
  }

  // 亮灭屏状态监听用以判断是否通过创建销毁window来阻止用户交互
  screenCeListener() {
    Log.showInfo(TAG, `screenCeListener init`);
    commonEventManager.createSubscriber({events: [
      'usual.event.SCREEN_OFF',
      'usual.event.SCREEN_ON'
    ]})
      .then((commonEventSubscriber) => {
        commonEventManager.subscribe(commonEventSubscriber, (err, data) => {
          if(err?.code !== 0){
            Log.showError(TAG, `screenCeListener err: ${JSON.stringify(err)}`);
            return;
          }
          Log.showInfo(TAG, `screenCeListener data: ${JSON.stringify(data.event)}`);

          if (data.event == 'usual.event.SCREEN_OFF') {
            this.initEventInterceptionWindow()
          }else if (data.event == 'usual.event.SCREEN_ON') {
            this.destroyEventInterceptionWindow()
          }
        })
      })
      .catch((err) => {
      })
  }

  private initEventInterceptionWindow() {
    if (globalThis.eventInterceptionWindow != undefined) {
      globalThis.eventInterceptionWindow.destroy();
      globalThis.eventInterceptionWindow = undefined;
    }

    window.create(this.context, 'event_interception', 2106).then((win) => {
      globalThis.eventInterceptionWindow = win

      win.loadContent('pages/eventInterception').then(() => {
        win.setBackgroundColor('#00000000').then(() => {
          win.setLayoutFullScreen(true).then(() => {
            win.show().then(()=>{

            })
          })
        })
      })
    })
  }

  private destroyEventInterceptionWindow() {
    if (globalThis.eventInterceptionWindow != undefined) {
      globalThis.eventInterceptionWindow.destroy();
      globalThis.eventInterceptionWindow = undefined;
    }
  }

  async createNewWindow (isNewWindow : boolean) {
    let defaultConfigInfo = await NavBarConfiguration.getConfiguration();
    let configInfo = NavBarConfiguration.setCustomConfiguration(defaultConfigInfo);
    this.direction = configInfo.direction;
    AbilityManager.setAbilityData(AbilityManager.ABILITY_NAME_NAVIGATION_BAR, 'config', configInfo);
    Log.showDebug(TAG, `onCreate, configInfo: ${JSON.stringify(configInfo)}`);
    let navigationBarRect = {
      left: configInfo.xCoordinate,
      top: configInfo.yCoordinate,
      width: configInfo.realWidth,
      height: configInfo.realHeight
    };

    if (isNewWindow) {
      WindowManager.createWindow(this.context, WindowType.NAVIGATION_BAR, navigationBarRect, 'pages/index')
        .then(() => {
          Log.showInfo(TAG, 'onCreate, createWindow success.');
          WindowManager.showWindow(WindowType.NAVIGATION_BAR).then(() => {
          }).catch(e => {
          });
        })
        .catch((err) => Log.showError(TAG, `Can't create window, err:${err}`));
    } else {
      WindowManager.resetSizeWindow(WindowType.NAVIGATION_BAR, navigationBarRect);
    }
    commonEventManager.createSubscriber(commonEventSubscribeInfo).then((subscriber) => {
      commonEventManager.subscribe(subscriber, (err,data)=>{
        let eventData = data.parameters.windowMode.toString()
        if(eventData == splitScreenEventData.Show){
          Log.showInfo(TAG,`eventData is ${eventData}`)
          let splitBarRect = {
            left: configInfo.realWidth/2 - 80,
            top: configInfo.yCoordinate,
            width: 16,
            height: configInfo.maxHeight,
          };
          WindowManager.createWindow(this.context, WindowType.STATUS_BAR, splitBarRect, 'pages/SplitBarIndex').then(async () =>
          WindowManager.showWindow(WindowType.SPLIT_BAR)
          ).then(() => {
            subscriber.finishCommonEvent();
          }).catch((err) => {
          });
        }else if( eventData == splitScreenEventData.Destory){
          Log.showInfo(TAG,`eventData is ${eventData}`)
          WindowManager.destroyWindow(WindowType.SPLIT_BAR).then(() => {
            subscriber.finishCommonEvent();
          }).catch((err) => {
          });
        }else{
          Log.showInfo(TAG,`eventData is ${eventData}`)
        }
      })
    })
  }

  onDestroy(): void {
    Log.showInfo(TAG, 'onDestroy');
  }
}

export default ServiceExtAbility;
