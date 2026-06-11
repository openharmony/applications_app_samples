'use static'
/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// [Start entry_ability]
// src/main/ets/entryability/EntryAbility.ets

import UIAbility from '@ohos.app.ability.UIAbility';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import Want from '@ohos.app.ability.Want';
import window from '@ohos.window';
import { BusinessError, RecordData } from '@ohos.base'
import hilog from '@ohos.hilog'

const TAG: string = 'EntryAbility';
const DOMAIN_NUMBER: int = 0x0000;

class EntryAbility extends UIAbility {
  private selectPage: string = 'Index';
  private currentWindowStage: window.WindowStage | undefined = undefined;

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'entry onCreate');
    let params = want?.parameters;
    if (params !== undefined && params['targetPage'] !== undefined) {
      this.selectPage = params['targetPage'] as string;
      hilog.info(DOMAIN_NUMBER, TAG, `Ability onCreate, Want params: ${params['targetPage']}`);
    } else {
      this.selectPage = 'Index';
    }
  }

  // 如果UIAbility已在后台运行，在收到Router事件后会触发onNewWant生命周期回调
  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'Ability onNewWant');
    let params = want?.parameters;
    if (params !== undefined && params['targetPage'] !== undefined) {
      this.selectPage = params['targetPage'] as string;
      hilog.info(DOMAIN_NUMBER, TAG, `Ability onCreate, Want params: ${params['targetPage']}`);
    } else {
      this.selectPage = 'Index';
    }
    if (this.currentWindowStage !== undefined) {
      this.onWindowStageCreate(this.currentWindowStage);
    }
  }

  onWindowStageCreate(windowStage: window.WindowStage | undefined): void {
    hilog.info(DOMAIN_NUMBER, TAG, `onWindowStageCreate this.selectPage: ${this.selectPage}`);
    let targetPage: string = 'pages/Index';
    // 根据传递的targetPage不同，选择拉起不同的页面
    switch (this.selectPage) {
      case 'funA':
        targetPage = 'funpages/FunA';
        break;
      case 'funB':
        targetPage = 'funpages/FunB';
        break;
      default:
        targetPage = 'pages/Index';
    }
    if (windowStage) {
      this.currentWindowStage = windowStage;
    }
    try {
      windowStage?.loadContent(targetPage, (err: BusinessError<void> | null): void => {
        if (err && err.code) {
          hilog.error(DOMAIN_NUMBER, TAG,
            `Failed to load the content. error code: ${err.code}, error message: ${err.message}`);
          return;
        }
        hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in loading the content.');
      });
    } catch (e) {
      hilog.info(DOMAIN_NUMBER, TAG, `loadContent catch error, code: ${e.code}, message: ${e.message}`);
    }
  }
}

// [End entry_ability]