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

// [Start ability_create_template]
import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { TemplateManager } from '../manager/TemplateManager';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    console.info('onCreate');
    TemplateManager.getInstance().createTemplate();
  }

  // [StartExclude ability_create_template]
  onDestroy(): void {
    console.info('onDestroy');
    TemplateManager.getInstance().unregisterListener();
  }

  // [EndExclude ability_create_template]
  onForeground(): void {
    console.info('onForeground');
    this.startTemplateControllerAbility();
  }

  private startTemplateControllerAbility() {
    let want: Want = {
      bundleName: 'com.example.templatecontroller',
      abilityName: 'EntryAbility',
      parameters: {
        bundleName: 'com.example.templateprovider'
      }
    }
    this.context.startAbility(want).then(() => {
      console.info('startTemplateControllerAbility: startAbility success');
    }).catch((e: BusinessError) => {
      console.error(`startTemplateControllerAbility: startAbility: errCode: ${e?.code}}`);
    });
  }
}
// [End ability_create_template]