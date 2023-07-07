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

import UIAbility from '@ohos.app.ability.UIAbility';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import { logger } from '../../../../../photomodify/src/main/ets/components/util/Logger';

const TAG: string = '[Sample_MainAbility]';

export default class MainAbility extends UIAbility {
  onCreate(want, launchParam): void {
    globalThis.mainContext = this.context;
    logger.info(TAG, '[Demo] MainAbility onCreate');
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    try {
      atManager.requestPermissionsFromUser(this.context,
        ['ohos.permission.READ_MEDIA', 'ohos.permission.WRITE_MEDIA', 'ohos.permission.MEDIA_LOCATION'])
        .then((data) => {
          logger.info(TAG, `data: ${JSON.stringify(data)}`);
        }).catch((err) => {
          logger.info(TAG, `err: ${JSON.stringify(err)}`);
      })
    } catch (err) {
      logger.info(TAG, `catch err->${JSON.stringify(err)}`);
    }
  }

  onDestroy(): void {
    logger.info(TAG, '[Demo] MainAbility onDestroy');
  }

  onWindowStageCreate(windowStage): void {
    // Main window is created, set main page for this ability
    logger.info(TAG, '[Demo] MainAbility onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        logger.info(TAG, `Failed to load the content. Cause: ${JSON.stringify(err)}`);
        return;
      }
      logger.info(TAG, `Succeeded in loading the content. Data: ${JSON.stringify(data)}`);
    })
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    logger.info(TAG, '[Demo] MainAbility onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    logger.info(TAG, '[Demo] MainAbility onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    logger.info(TAG, '[Demo] MainAbility onBackground');
  }
}
