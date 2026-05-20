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

import { AbilityConstant, UIAbility, Want, bundleManager } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { MLog } from '../common/utils/MLog';

type SystemBarKeys = 'status' | 'navigation';
const TAG = 'EntryAbility';
export default class EntryAbility extends UIAbility {

  private mWindowStage: window.WindowStage | undefined = undefined;

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    MLog.info(TAG,'Ability onCreate ' + want.parameters?.isFromShare);
    let bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_REQUESTED_PERMISSION;
    let info = bundleManager.getBundleInfoSync(this.context.abilityInfo.bundleName,bundleFlags);
    MLog.info(TAG,`Ability BundleInfo: ${JSON.stringify(info)}`);
    if (want.parameters) {
      AppStorage.setOrCreate('isFromShare', want.parameters?.isFromShare);
    }
  }

  onDestroy(): void {
   MLog.info(TAG, 'Ability onDestroy');
  }


  onWindowStageCreate(windowStage: window.WindowStage): void {
   AppStorage.setAndLink('Tindex',0);
    // Main window is created, set main page for this ability
   MLog.info(TAG, 'Ability onWindowStageCreate');
    this.mWindowStage = windowStage;
    let names: Array<SystemBarKeys> = new Array<SystemBarKeys>('navigation');
    windowStage.getMainWindow().then((window: window.Window) => {
      window.setWindowSystemBarEnable(names);
      window.setWindowSystemBarProperties({navigationBarColor: '#1f2e4d', navigationBarContentColor: '#ffffff'});
      windowStage.loadContent('pages/Index', (err) => {
        if (err.code) {
          MLog.error(TAG,'Failed to load the content. Cause: '+ JSON.stringify(err) ?? '');
          return;
        }
       MLog.info(TAG,'Succeeded in loading the content.');
      });
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
   MLog.info(TAG, 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    MLog.info(TAG, 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
   MLog.info(TAG,'Ability onBackground');
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
   MLog.info(TAG, 'Ability onNewWant '+ JSON.stringify(want.parameters));
    if (want.parameters) {
      AppStorage.setOrCreate('isFromShare', want.parameters?.isFromShare);
    }
    // if(this.mWindowStage) {
    //   this.mWindowStage.loadContent('pages/Index', (err) => {
    //     if (err.code) {
    //       MLog.error('Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
    //       return;
    //     }
    //    MLog.info(TAG,'Succeeded in loading the content.');
    //   });
    // }
  }

}
