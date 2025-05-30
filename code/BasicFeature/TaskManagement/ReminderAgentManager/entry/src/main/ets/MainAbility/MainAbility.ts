/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import UIAbility from '@ohos.app.ability.UIAbility'
import notification from '@ohos.notificationManager'
import window from '@ohos.window'
import Logger from '../util/Logger'
import common from '@ohos.app.ability.common';
import { calendarManager } from '@kit.CalendarKit';
import { abilityAccessCtrl, PermissionRequestResult, Permissions } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { deviceInfo } from '@kit.BasicServicesKit';

const TAG: string = 'MainAbility';
let deviceTypeInfo: string = deviceInfo.deviceType;

export let calendarMgr: calendarManager.CalendarManager | null = null;

export let mContext: common.UIAbilityContext | null = null;

export default class MainAbility extends UIAbility {
  onCreate(want, launchParam) {
    Logger.info(TAG, 'onCreate')
  }

  onDestroy() {
    Logger.info(TAG, 'onDestroy')
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    Logger.info(TAG, 'onWindowStageCreate')
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        Logger.error(TAG, `Failed to load the content. Cause: ${JSON.stringify(err)}`)
        return
      }
      Logger.info(TAG, `Succeeded in loading the content. Data: ${JSON.stringify(data)}`)
      mContext = this.context;
      notification.requestEnableNotification(mContext).then(() => {
        Logger.info(TAG, `requestEnableNotification success`);
      }).catch((err) => {
        Logger.error(TAG, `requestEnableNotification fail: ${JSON.stringify(err)}`);
      });
      if (deviceTypeInfo !== 'default') {
        const permissions: Permissions[] = ['ohos.permission.READ_CALENDAR', 'ohos.permission.WRITE_CALENDAR'];
        let atManager = abilityAccessCtrl.createAtManager();
        atManager.requestPermissionsFromUser(mContext, permissions).then((result: PermissionRequestResult) => {
          Logger.info(TAG, `get Permission success, result: ${JSON.stringify(result)}`);
          calendarMgr = calendarManager.getCalendarManager(mContext);
        }).catch((error: BusinessError) => {
          Logger.error(TAG, `get Permission error, error. Code: ${error.code}, message: ${error.message}`);
        })
      }
    })
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    Logger.info(TAG, 'onWindowStageDestroy')
  }

  onForeground() {
    // Ability has brought to foreground
    Logger.info(TAG, 'onForeground')
  }

  onBackground() {
    // Ability has back to background
    Logger.info(TAG, 'onBackground')
  }
}
