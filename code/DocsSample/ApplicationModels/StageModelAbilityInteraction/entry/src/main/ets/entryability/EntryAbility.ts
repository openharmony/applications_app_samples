/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import type AbilityConstant from '@ohos.app.ability.AbilityConstant';
import hilog from '@ohos.hilog';
import type Want from '@ohos.app.ability.Want';
import UIAbility from '@ohos.app.ability.UIAbility';
import type window from '@ohos.window';

import type { Router, UIContext } from '@ohos.arkui.UIContext';
import type { BusinessError } from '@ohos.base';

const DOMAIN_NUMBER: number = 0xFF00;
const TAG: string = '[EntryAbility]';

export default class EntryAbility extends UIAbility {
  funcAbilityWant: Want | undefined = undefined;
  uiContext: UIContext | undefined = undefined;

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    // 接收调用方UIAbility传过来的参数
    this.funcAbilityWant = want;
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', 'Ability onWindowStageCreate');

    // Main window is created, set main page for this ability
    let url = 'pages/Index';
    if (this.funcAbilityWant?.parameters?.router && this.funcAbilityWant.parameters.router === 'funcA') {
      url = 'pages/Page_ColdStartUp';
    }

    windowStage.loadContent(url, (err, data) => {
      if (err.code) {
        return;
      }

      let windowClass: window.Window;
      windowStage.getMainWindow((err, data) => {
        if (err.code) {
          hilog.error(DOMAIN_NUMBER, TAG, `Failed to obtain the main window. Code is ${err.code}, message is ${err.message}`);
          return;
        }
        windowClass = data;
        this.uiContext = windowClass.getUIContext();
      });
      hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    if (want?.parameters?.router && want.parameters.router === 'funcB') {
      let funcAUrl = 'pages/Page_HotStartUp';
      if (this.uiContext) {
        let router: Router = this.uiContext.getRouter();
        router.pushUrl({
          url: funcAUrl
        }).catch((err: BusinessError) => {
          hilog.error(DOMAIN_NUMBER, TAG, `Failed to push url. Code is ${err.code}, message is ${err.message}`);
        });
      }
    }
  };
};
