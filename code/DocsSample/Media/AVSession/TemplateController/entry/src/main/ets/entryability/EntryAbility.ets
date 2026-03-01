/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
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
/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { ControllerManager } from '../manager/ControllerManager';

const TAG: string = 'EntryAbility';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    console.info(TAG, 'onCreate');
    this.createAvMusicTemplateController(want);
    ControllerManager.getInstance().registerAVMusicTemplateListener();
  }

  onDestroy(): void {
    console.info(TAG, 'onDestroy');
    ControllerManager.getInstance().unregisterAVMusicTemplateListener();
    ControllerManager.getInstance().unregisterListener();
    ControllerManager.getInstance().destroyController();
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        console.info(TAG, `onWindowStageCreate: loadContent: errCode: ${err.code}`);
        return;
      }
      console.info(TAG, `onWindowStageCreate: loadContent success`);
    });
  }

  private createAvMusicTemplateController(want: Want) {
    let bundleName: object | undefined = want?.parameters?.bundleName;
    if (typeof bundleName !== 'string') {
      console.warn(TAG, 'createAvMusicTemplateController: no bundleName');
      return;
    }
    console.warn(TAG, `createAvMusicTemplateController: bundleName: ${bundleName}`);
    ControllerManager.getInstance().createAvMusicTemplateController(bundleName);
  }
}