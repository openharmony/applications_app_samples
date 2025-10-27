/*
 * Copyright (C) 2023-2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { BusinessError } from '@kit.BasicServicesKit';
import { abilityAccessCtrl, AbilityConstant, Permissions,
  UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';

/**
 * Lift cycle management of Ability.
 */
// [Start request_permissions]
export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    console.info('Sample_VideoRecorder', 'Ability onCreate,requestPermissionsFromUser');
    let permissionNames: Array<Permissions> = ['ohos.permission.MEDIA_LOCATION', 'ohos.permission.READ_MEDIA',
      'ohos.permission.WRITE_MEDIA', 'ohos.permission.CAMERA', 'ohos.permission.MICROPHONE', 'ohos.permission.DISTRIBUTED_DATASYNC'];
    abilityAccessCtrl.createAtManager().requestPermissionsFromUser(this.context, permissionNames).then((data)=> {
      console.info('testTag', data);
    })
      .catch((err : BusinessError) => {
        console.error('testTag', err.message);
      });
  }
  // [StartExclude request_permissions]
  onDestroy() {
    console.info('Sample_VideoRecorder', 'Ability onDestroy');
  }

  async onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    console.info('Sample_VideoRecorder', 'Ability onWindowStageCreate');
    windowStage.loadContent('recorder/VideoRecorder', (err, data) => {
      if (err.code) {
        console.error('Sample_VideoRecorder', 'Failed to load the content. Cause: ' + JSON.stringify(err));
        return;
      }
      console.info('Sample_VideoRecorder', 'Succeeded in loading the content. Data: ' + JSON.stringify(data));
      windowStage.getMainWindow().then((win: window.Window) => {
        win.setWindowKeepScreenOn(true);
      })
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    console.info('Sample_VideoRecorder', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    console.info('Sample_VideoRecorder', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    console.info('Sample_VideoRecorder', 'Ability onBackground');
  }
  // [EndExclude request_permissions]
}
// [End request_permissions]