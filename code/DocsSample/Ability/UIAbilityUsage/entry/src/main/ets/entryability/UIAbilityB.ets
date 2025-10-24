/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

// [Start UIAbilityB]
import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;

export default class UIAbilityB extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    // 调用方无需手动传递parameters参数，系统会自动向Want对象中传递调用方信息。
    hilog.info(DOMAIN, 'UIAbilityB', `onCreate, callerPid: ${want.parameters?.['ohos.aafwk.param.callerPid']}.`);
    hilog.info(DOMAIN, 'UIAbilityB', `onCreate, callerBundleName: ${want.parameters?.['ohos.aafwk.param.callerBundleName']}.`);
    hilog.info(DOMAIN, 'UIAbilityB', `onCreate, callerAbilityName: ${want.parameters?.['ohos.aafwk.param.callerAbilityName']}.`);
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'UIAbilityB', `UIAbilityB onDestroy.`);
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(DOMAIN, 'UIAbilityB', `Ability onWindowStageCreate.`);

    windowStage.loadContent('context/BasicUsage', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'UIAbilityB', `Failed to load the content, error code: ${err.code}, error msg: ${err.message}.`);
        return;
      }
      hilog.info(DOMAIN, 'UIAbilityB', `Succeeded in loading the content.`);
    });
  }
}
// [End UIAbilityB]