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

// EntryAbility.ets

// import ability from '@ohos.ability.ability';
// import dataUriUtils from '@ohos.ability.dataUriUtils';
// import errorCode from '@ohos.ability.errorCode';
// import featureAbility from '@ohos.ability.featureAbility';
// import particleAbility from '@ohos.ability.particleAbility';
// import wantConstant from '@ohos.ability.wantConstant';
// import common from '@ohos.app.ability.common';
// import Configuration from '@ohos.app.ability.Configuration';
// import contextConstant from '@ohos.app.ability.contextConstant';
// import ConfigurationConstant from '@ohos.app.ability.ConfigurationConstant';
// import FormExtensionAbility from '@ohos.app.form.FormExtensionAbility';
// import GesturePath from '@ohos.accessibility.GesturePath';
// import GesturePoint from '@ohos.accessibility.GesturePoint';
// import distributedAccount from '@ohos.account.distributedAccount';
// import osAccount from '@ohos.account.osAccount';

import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import UIAbility from '@ohos.app.ability.UIAbility';
import Want from '@ohos.app.ability.Want';
import window from '@ohos.window';
import logger from '../common/Logger';

const LARGE_NUMBER = 10000000;
const DELAYED_TIME = 1000;

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    logger.info('Ability onCreate');
    // 耗时操作
    // this.computeTask();
    this.computeTaskAsync(); // 异步任务
  }

  onDestroy(): void {
    logger.info('Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    logger.info('Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        logger.error('Failed to load the content. Cause: ' + JSON.stringify(err) ?? '');
        return;
      }
      logger.info('Succeeded in loading the content. Data: ' + JSON.stringify(data) ?? '');
    });

    // 耗时操作
    // this.computeTask();
    this.computeTaskAsync(); // 异步任务
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    logger.info('Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    logger.info('Ability onForeground');
    // 耗时操作
    // this.computeTask();
    this.computeTaskAsync(); // 异步任务
  }

  onBackground(): void {
    // Ability has back to background
    logger.info('Ability onBackground');
  }

  computeTask(): void {
    let count = 0;
    while (count < LARGE_NUMBER) {
      count++;
    }
  }

  private computeTaskAsync(): void {
    setTimeout(() => { // 这里使用setTimeout来实现异步延迟运行
      this.computeTask();
    }, DELAYED_TIME);
  }
}
