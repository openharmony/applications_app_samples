/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
import { logger } from '@ohos/details-page-hsp';
import notification from '@ohos.notificationManager';
import { QRCodeScanConst } from '@ohos/scan-component';
import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';
import Want from '@ohos.app.ability.Want';
import window from '@ohos.window';
import common from '@ohos.app.ability.common';
import { EventData } from '../utils/TypeClass';
import display from '@ohos.display';

const TAG: string = 'MainAbility';
const EVENT: string = 'getAbilityData';
const PERMISSIONS: Array<Permissions> = [
  'ohos.permission.CAMERA',
  'ohos.permission.MICROPHONE',
  'ohos.permission.READ_MEDIA',
  'ohos.permission.WRITE_MEDIA',
  'ohos.permission.MEDIA_LOCATION',
  'ohos.permission.INTERNET'
];
const CONTEXT: string = 'context';
const INDEX_UIL: string = 'pages/Index';
const CAMERA_STATUS_STR: string = 'cameraStatus';

export default class MainAbility extends UIAbility {
  onCreate(want: Want): void {
    logger.info(TAG, 'onCreate');

    AppStorage.setOrCreate('context', this.context);
    window.getLastWindow(this.context, (err, data) => {
      if (data && data.getWindowProperties()) {
        let windowWidth = data.getWindowProperties().windowRect.width;
        this.screenBreakPoints(windowWidth);
      }
    })

    this.context.eventHub.on(EVENT, (data: EventData) => {
      data.context = this.context;
      data.launchWant = want;
    });
    this.requestPermission();
    AppStorage.setOrCreate(CONTEXT, this.context);
  }

  requestPermission = async (): Promise<void> => {
    let permissionRequestResult = await abilityAccessCtrl.createAtManager().requestPermissionsFromUser(this.context,
      PERMISSIONS);
    // 如果权限列表中有-1，说明用户拒绝了授权
    if (permissionRequestResult.authResults[0] === 0) {
      // 控制相机是否打开
      AppStorage.setOrCreate(QRCodeScanConst.HAS_CAMERA_PERMISSION, true);
      logger.info('MainAbility permissionRequestResult success');
    }
    // 应用请求通知使能
    try {
      await notification.requestEnableNotification(this.context);
      logger.info(`requestEnableNotification success`);
    } catch (e) {
      logger.error(`requestEnableNotification error ${JSON.stringify(e)}`);
    }
  }

  onDestroy(): void {
    logger.info(TAG, 'onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    logger.info(TAG, 'onWindowStageCreate');
    windowStage.getMainWindow((err, data) => {
      let windowClass = data;
      try {
        windowClass.on('windowSizeChange', (data) => {
          this.screenBreakPoints(data.width);
        })
      } catch (exception) {
        logger.info(TAG, 'onWindowStageCreateFail');
      }
    })

    windowStage.loadContent(INDEX_UIL);
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    logger.info(TAG, 'onWindowStageDestroy');

  }

  onForeground(): void {
    // Ability has brought to foreground
    logger.info(TAG, 'MainAbility onForeground');
    AppStorage.setOrCreate(CAMERA_STATUS_STR,!AppStorage.get<boolean>(CAMERA_STATUS_STR));
  }

  onBackground(): void {
    // Ability has back to background
    logger.info(TAG, 'onBackground');
  }

  screenBreakPoints(data: number) {
    let displayClass: display.Display | undefined = undefined;
    let screenDpi: number = 0;
    displayClass = display.getDefaultDisplaySync();
    screenDpi = displayClass.densityDPI;
    AppStorage.setOrCreate('dpi', screenDpi);
    let windowWidth = data / (screenDpi / 160);
    if (windowWidth >= 320 && windowWidth < 520 || windowWidth < 320) {
      AppStorage.setOrCreate('breakPoint', 'sm');
    } else if (windowWidth >= 520 && windowWidth < 840) {
      AppStorage.setOrCreate('breakPoint', 'md');
    } else if (windowWidth >= 840) {
      AppStorage.setOrCreate('breakPoint', 'lg');
    }
  }
}