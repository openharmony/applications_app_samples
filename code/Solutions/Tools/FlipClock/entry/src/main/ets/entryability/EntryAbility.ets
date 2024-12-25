/*
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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
import Window from '@ohos.window';
import Logger from '../model/Logger';
import Notification from '@ohos.notificationManager';
import { abilityAccessCtrl, common, PermissionRequestResult, Permissions } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { calendarManager } from '@kit.CalendarKit';

export let calendarMgr: calendarManager.CalendarManager | null = null;
export let mContext: common.UIAbilityContext | null = null;

export default class EntryAbility extends UIAbility {
  onWindowStageCreate(windowStage: Window.WindowStage) {
    // Main window is created, set main page for this ability
    AppStorage.setOrCreate('context', this.context);
    Notification.requestEnableNotification(() => {
      Logger.info(`requestEnableNotification success`);
    });
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        Logger.error(`Failed to load the content. Cause: ${JSON.stringify(err)}`);
        return;
      }
      Logger.info(`loadContent success`);
    });

    mContext = this.context;
    const permissions: Permissions[] = ['ohos.permission.READ_CALENDAR', 'ohos.permission.WRITE_CALENDAR'];
    let atManager = abilityAccessCtrl.createAtManager();
    atManager.requestPermissionsFromUser(mContext, permissions).then((result: PermissionRequestResult) => {
      Logger.info(`get Permission success, result: ${JSON.stringify(result)}`);
      calendarMgr = calendarManager.getCalendarManager(mContext);
    }).catch((error: BusinessError) => {
      Logger.error(`get Permission error. Code: ${error.code}, message: ${error.message}`);
    })

    let windowClass: Window.Window | undefined = undefined;
    try {
      Window.getLastWindow(this.context, (err, data) => {
        const errCode: number = err.code;
        if (errCode) {
          Logger.error(`Failed to obtain the top window. Cause code: ${err.code}, message: ${err.message}`);
          return;
        }
        windowClass = data;
        Logger.info('Succeeded in obtaining the top window. Data: ' + JSON.stringify(data));
        AppStorage.setOrCreate('windowClass', windowClass);
      });
    } catch (exception) {
      Logger.error(`Failed to obtain the top window. Cause code: ${exception.code}, message: ${exception.message}`);
    }
  }
}
