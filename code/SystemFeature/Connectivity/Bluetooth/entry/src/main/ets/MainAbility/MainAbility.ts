/*
 * Copyright (c) 2022-2025 Huawei Device Co., Ltd.
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
import logger from '../Model/Logger';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import connection from '@ohos.bluetooth.connection';
import UIAbility from '@ohos.app.ability.UIAbility';
import Want from '@ohos.app.ability.Want';
import { BusinessError } from '@ohos.base';
import type { Permissions } from '@ohos.abilityAccessCtrl';

const TAG: string = 'MainAbility';
const TIME: number = 0;

export default class MainAbility extends UIAbility {
  async onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    logger.info(TAG, `[Demo] MainAbility onCreate`);

    const PERMISSIONS: Array<Permissions> = [
      'ohos.permission.ACCESS_BLUETOOTH',
      'ohos.permission.USE_BLUETOOTH',
      'ohos.permission.DISCOVER_BLUETOOTH',
      'ohos.permission.LOCATION',
      'ohos.permission.MANAGE_BLUETOOTH',
      'ohos.permission.APPROXIMATELY_LOCATION'
    ]

    let atManager = abilityAccessCtrl.createAtManager();
    try {
      atManager.requestPermissionsFromUser(this.context, PERMISSIONS).then((data) => {
        try {
          connection.startBluetoothDiscovery();
        } catch (err) {
          const errCode = (err as BusinessError).code;
          const errMessage = (err as BusinessError).message;
          logger.error(TAG, 'startBluetoothDiscovery failed' + errCode + ', errMessage: ' + errMessage);
        }
        try {
          connection.setBluetoothScanMode(connection.ScanMode.SCAN_MODE_CONNECTABLE_GENERAL_DISCOVERABLE, TIME);
        } catch (err) {
          const errCode = (err as BusinessError).code;
          const errMessage = (err as BusinessError).message;
          logger.error(TAG, 'setBluetoothScanMode failed' + errCode + ', errMessage: ' + errMessage);
        }
        logger.info(TAG, `data: ${JSON.stringify(data)}`);
      }).catch((err) => {
        logger.error(TAG, `err: ${JSON.stringify(err)}`);
      })
    } catch (err) {
      logger.error(TAG, `catch err->${JSON.stringify(err)}`);
    }
  }

  onDestroy() {
    logger.info(TAG, `[Demo] MainAbility onDestroy`);
  }

  onWindowStageCreate(windowStage) {
    logger.info(TAG, `[Demo] MainAbility onWindowStageCreate`);
    windowStage.setUIContent(this.context, "pages/Index", null);
  }

  onWindowStageDestroy() {
    logger.info(TAG, `[Demo] MainAbility onWindowStageDestroy`);
  }

  onForeground() {
    logger.info(TAG, `[Demo] MainAbility onForeground`);
  }

  onBackground() {
    logger.info(TAG, `[Demo] MainAbility onBackground`);
  }
}
