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
import { logger } from '@ohos/details-page-component';
import { notificationUtil } from '@ohos/notification';
import { QRCodeScanConst } from '@ohos/scan-component';
import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';
import  Want from '@ohos.app.ability.Want';

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
    this.context.eventHub.on(EVENT, (data: ESObject) => {
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
    await notificationUtil.enableNotification();
  }

  onDestroy(): void {
    logger.info(TAG, 'onDestroy');
  }

  onWindowStageCreate(windowStage: ESObject): void {
    // Main window is created, set main page for this ability
    logger.info(TAG, 'onWindowStageCreate');

    windowStage.setUIContent(this.context, INDEX_UIL, null);
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
}