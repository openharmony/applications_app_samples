/*
* Copyright (C) 2024 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import Logger from '../logger/Logger';
import { window } from '@kit.ArkUI';


export default class EntryAbility extends UIAbility {
  private selectPage: string = '';
  private currentWindowStage: window.WindowStage | null = null;

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    // 获取router事件中传递的targetPage参数
    Logger.info( `Ability onCreate: ${JSON.stringify(want?.parameters)}`);
    if (want?.parameters?.params) {
      let params: Record<string, Object> = JSON.parse(want.parameters.params as string);
      this.selectPage = params.targetPage as string;
      Logger.info( `onCreate selectPage: ${this.selectPage}`);
    }
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    Logger.info(`Ability onNewWant: ${JSON.stringify(want?.parameters)}`);
    if (want?.parameters?.params) {
      let params: Record<string, Object> = JSON.parse(want.parameters.params as string);
      this.selectPage = params.targetPage as string;
      Logger.info( `onNewWant selectPage: ${this.selectPage}`);
    }
    if (this.currentWindowStage !== null) {
      this.onWindowStageCreate(this.currentWindowStage);
    }
  }

  onDestroy(): void {
    Logger.info('Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    let targetPage: string;
    // 根据传递的targetPage不同，选择拉起不同的页面
    switch (this.selectPage) {
      case 'PageA':
        targetPage = 'pages/PageA';
        break;
      default:
        targetPage = 'pages/Index';
    }
    if (this.currentWindowStage === null) {
      this.currentWindowStage = windowStage;
    }
    Logger.info('load targetPage: %{public}s', targetPage);
    windowStage.loadContent(targetPage, (err, data) => {
      if (err.code) {
        Logger.error(`Failed to load the content. Cause: ${JSON.stringify(err)}`);
        return;
      }
      Logger.info('Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    Logger.info('Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    Logger.info('Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    Logger.info('Ability onBackground');
  }
}
