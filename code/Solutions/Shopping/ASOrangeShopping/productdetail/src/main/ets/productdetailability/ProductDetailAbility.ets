/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import { GoodsInfo } from '../model/DetailMode';
import { logger } from '../utils/Logger';

let TAG = 'ProductDetailAbility';

export default class ProductDetailAbility extends UIAbility {
  private storage: LocalStorage = undefined;

  onCreate(want, launchParam) {
    logger.info(`Ability onCreate. want: ${JSON.stringify(want)}, launchParam: ${JSON.stringify(launchParam)}`);
    this.initGoodsInfo(want);
  }

  private initGoodsInfo(want) {
    let parameters = want['parameters'];
    logger.info(TAG, 'parameters: ' + JSON.stringify(parameters));
    let goodsInfo = parameters['goods'] as GoodsInfo;
    logger.info(TAG, 'goods: ' + JSON.stringify(goodsInfo));
    let goodsDataRoot = parameters['goodsDataRoot'];
    logger.info(TAG, 'goodsDataRoot: ' + JSON.stringify(goodsDataRoot));

    this.storage = new LocalStorage();
    this.storage.setOrCreate('goodsInfo', goodsInfo);
    this.storage.setOrCreate('goodsDataRoot', goodsDataRoot);
  }

  onDestroy() {
    logger.info(TAG, 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: Window.WindowStage) {
    // Main window is created, set main page for this ability

    logger.info(TAG, 'Ability onWindowStageCreate');
    windowStage.loadContent('pages/Index', this.storage, (err, data) => {
      if (err.code) {
        logger.error(`Failed to load the content. Cause: ${JSON.stringify(err)}`);
        return;
      }
      logger.info(`Succeeded in loading the content. Data: ${JSON.stringify(data)}`);
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    logger.info(TAG, 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    logger.info(TAG, 'Ability onForeground');
  }

  onBackground() {
    this.context.terminateSelf()
    // Ability has back to background
    logger.info(TAG, 'Ability onBackground');
  }
}
