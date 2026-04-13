/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import hilog from '@ohos.hilog';
import TestRunner from '@ohos.application.testRunner';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

const TAG = '[OpenHarmonyTestRunner]';
const DOMAIN = 0x0000;

let abilityDelegator: AbilityDelegatorRegistry.AbilityDelegator;
let abilityDelegatorArguments: AbilityDelegatorRegistry.AbilityDelegatorArgs;

async function onAbilityCreateCallback() {
  hilog.info(DOMAIN, TAG, 'onAbilityCreateCallback');
}

async function addAbilityMonitorCallback(err: any) {
  hilog.info(DOMAIN, TAG, 'addAbilityMonitorCallback : %{public}s', JSON.stringify(err) ?? '');
}

export default class OpenHarmonyTestRunner implements TestRunner {
  constructor() {
  }

  onPrepare() {
    hilog.info(DOMAIN, TAG, 'OpenHarmonyTestRunner OnPrepare');
  }

  async onRun() {
    hilog.info(DOMAIN, TAG, 'OpenHarmonyTestRunner onRun run');
    abilityDelegatorArguments = AbilityDelegatorRegistry.getArguments();
    abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
    let testAbilityName = abilityDelegatorArguments.bundleName + '.TestAbility';
    let lMonitor = {
      abilityName: testAbilityName,
      onAbilityCreate: onAbilityCreateCallback,
    };
    abilityDelegator.addAbilityMonitor(lMonitor, addAbilityMonitorCallback);
    let cmd = 'aa start -d 0 -a TestAbility' + ' -b ' + abilityDelegatorArguments.bundleName;
    let debug = abilityDelegatorArguments.parameters['-D'];
    if (debug == 'true') {
      cmd += ' -D';
    };
    hilog.info(DOMAIN, TAG, 'cmd : %{public}s', cmd);
    abilityDelegator.executeShellCommand(cmd,
      (err: any, d: any) => {
        hilog.info(DOMAIN, TAG, 'executeShellCommand : err : %{public}s', JSON.stringify(err) ?? '');
        hilog.info(DOMAIN, TAG, 'executeShellCommand : data : %{public}s', d.stdResult ?? '');
        hilog.info(DOMAIN, TAG, 'executeShellCommand : data : %{public}s', d.exitCode ?? '');
      });
    hilog.info(DOMAIN, TAG, 'OpenHarmonyTestRunner onRun end');
  }
}