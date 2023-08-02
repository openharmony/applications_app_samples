/*
 * Copyright (c) 2023 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import type { Permissions } from '@ohos.abilityAccessCtrl';

let myContext = null;

export default class EntryAbility extends UIAbility {
  onCreate(want, launchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    let applicationContext = this.context.getApplicationContext();
    let filesDir = applicationContext.filesDir;
    myContext = this.context;

    AppStorage.SetOrCreate('filesDir', filesDir);
    this.getResourceStr();
    try {
      this.getPermission();
    } catch (err) {
      hilog.info(0x0000, 'testTag', '%{public}s', 'err is ' + err);
    }
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err, data) => {
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

  getResourceStr(): void {
    try {
      myContext.resourceManager.getStringValue($r('app.string.fileContent1').id)
        .then(value => {
          AppStorage.SetOrCreate('fileContent1', value);
          hilog.info(0x0000, 'testTag', '%{public}s', 'getStringValue value' + value);
        })
        .catch(error => {
          hilog.error(0x0000, 'testTag', 'Failed to getStringValue. Cause: %{public}s', error ?? '');
        });

      myContext.resourceManager.getStringValue($r('app.string.fileContent2').id)
        .then(value => {
          AppStorage.SetOrCreate('fileContent2', value);
          hilog.info(0x0000, 'testTag', '%{public}s', 'getStringValue value' + value);
        })
        .catch(error => {
          hilog.error(0x0000, 'testTag', 'Failed to getStringValue. Cause: %{public}s', error ?? '');
        });

      myContext.resourceManager.getStringValue($r('app.string.fileContent3').id)
        .then(value => {
          AppStorage.SetOrCreate('fileContent3', value);
          hilog.info(0x0000, 'testTag', '%{public}s', 'getStringValue value' + value);
        })
        .catch(error => {
          hilog.error(0x0000, 'testTag', 'Failed to getStringValue. Cause: %{public}s', error ?? '');
        });

      myContext.resourceManager.getStringValue($r('app.string.fileContent4').id)
        .then(value => {
          AppStorage.SetOrCreate('fileContent4', value);
          hilog.info(0x0000, 'testTag', '%{public}s', 'getStringValue value' + value);
        })
        .catch(error => {
          hilog.error(0x0000, 'testTag', 'Failed to getStringValue. Cause: %{public}s', error ?? '');
        });

      myContext.resourceManager.getStringValue($r('app.string.subFilenames').id)
        .then(value => {
          AppStorage.SetOrCreate('subFilenames', value);
          hilog.info(0x0000, 'testTag', '%{public}s', 'getStringValue value' + value);
        })
        .catch(error => {
          hilog.error(0x0000, 'testTag', 'Failed to getStringValue. Cause: %{public}s', error ?? '');
        });
    } catch (error) {
      hilog.error(0x0000, 'testTag', 'callback getStringValue failed. Cause: %{public}s', error.message ?? '');
    }
  }

  getPermission(): void {
    let array: Array<Permissions> = [
      'ohos.permission.READ_MEDIA',
      'ohos.permission.WRITE_MEDIA',
      'ohos.permission.MEDIA_LOCATION',
      'ohos.permission.GET_BUNDLE_INFO',
      'ohos.permission.DISTRIBUTED_DATASYNC',
      'ohos.permission.START_ABILITIES_FROM_BACKGROUND',
      'ohos.permission.START_INVISIBLE_ABILITY',
      'ohos.permission.GRANT_SENSITIVE_PERMISSIONS',
      'ohos.permission.GET_DISTRIBUTED_ACCOUNTS',
      'ohos.permission.MANAGE_LOCAL_ACCOUNTS'
    ];

    let atManager = abilityAccessCtrl.createAtManager();

    // requestPermissionsFromUser会判断权限的授权状态来决定是否唤起弹窗
    atManager.requestPermissionsFromUser(this.context, array).then(function (data) {
      hilog.info(0x0000, 'testTag', '%{public}s', 'data type:' + typeof (data));
      hilog.info(0x0000, 'testTag', '%{public}s', 'data:' + data);
      hilog.info(0x0000, 'testTag', '%{public}s', 'data permissions:' + data.permissions);
      hilog.info(0x0000, 'testTag', '%{public}s', 'data result:' + data.authResults);
    }, (err) => {
      hilog.error(0x0000, 'Failed to start ability', err.code);
    });
  }
}
