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
 

import { display } from '@kit.ArkUI';
import { ServiceExtensionAbility as ServiceExtension } from '@kit.AbilityKit';
import Log from '../../../../../../../common/src/main/ets/default/Log';
import WindowManager, { WindowType } from '../../../../../../../common/src/main/ets/default/WindowManager';
import AbilityManager from '../../../../../../../common/src/main/ets/default/abilitymanager/AbilityManager';
import NavBarConfiguration from '../../../../../../../features/navigationservice/src/main/ets/com/ohos/navigationservice/common/NavBarConfiguration';
import { Want } from '@kit.AbilityKit';
import { commonEventManager } from '@kit.BasicServicesKit';

const TAG = 'NavigationBar_ServiceExtAbility';
let commonEventSubscribeInfo = {events:['common.event.SPLIT_SCREEN']};
const splitBarMode = 'SplitBarComponentMode'
const splitScreenEventData ={
  Show:'common.event.SPLIT_SCREEN.data.show.divider',
  Destory:'common.event.SPLIT_SCREEN.data.destroy.divider'
}

class ServiceExtAbility extends ServiceExtension {
  private direction :number;
  private subConfigInfo: any;
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

    commonEventManager.createSubscriber(commonEventSubscribeInfo).then((subscriber) => {
      commonEventManager.subscribe(subscriber, (err,data)=>{
        let eventData = data.parameters.windowMode.toString()
        if(eventData == splitScreenEventData.Show){
          Log.showInfo(TAG,`eventData is ${eventData}`)
          let splitBarRect = {
            left: this.subConfigInfo.realWidth/2 - 80,
            top: this.subConfigInfo.yCoordinate,
            width: 16,
            height: this.subConfigInfo.maxHeight,
          };
          WindowManager.createWindow(this.context, WindowType.SPLIT_BAR, splitBarRect, 'pages/SplitBarIndex').then(async () =>
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
          subscriber.finishCommonEvent();
          Log.showInfo(TAG,`eventData is ${eventData}`)
        }
      })
    })

    this.createNewWindow(true);
  }

  async createNewWindow (isNewWindow : boolean) {
    let defaultConfigInfo = await NavBarConfiguration.getConfiguration();
    let configInfo = NavBarConfiguration.setCustomConfiguration(defaultConfigInfo);
    this.subConfigInfo = configInfo;
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
    this.createPrivacyIndicatorWindow(isNewWindow,configInfo)
  }

  createPrivacyIndicatorWindow(isNewWindow : boolean, config : any){
    let privacyIndicatorRect = {
      left: 0,
      top: 0,
      width: config.realWidth,
      height: 32
    };
    // 创建状态栏窗口
    if (isNewWindow){
      WindowManager.createWindow(this.context, WindowType.PRIVACY_INDICATOR, privacyIndicatorRect, 'pages/PrivacyIndicatorComponent').then(() => {
        Log.showInfo(TAG, 'addPrivacyIndicator window has created');
        WindowManager.showWindow(WindowType.PRIVACY_INDICATOR).then(() => {
          WindowManager.setWindowBgColor(WindowType.PRIVACY_INDICATOR, '#00000000')
          WindowManager.setWindowTouchable(WindowType.PRIVACY_INDICATOR, false)
        })
        // 窗口透明
      })
        .catch((e) => {
          Log.showError(TAG, `addPrivacyIndicator create window error.`);
        });
    }else {
      WindowManager.resetSizeWindow(WindowType.PRIVACY_INDICATOR, privacyIndicatorRect)
    }

  }

  onDestroy(): void {
    Log.showInfo(TAG, 'onDestroy');
  }
}

export default ServiceExtAbility;
