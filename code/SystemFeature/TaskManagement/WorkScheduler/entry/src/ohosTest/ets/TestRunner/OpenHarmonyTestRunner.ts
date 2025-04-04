/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import TestRunner from '@ohos.application.testRunner';
import { Logger } from '../utils/Logger';

let abilityDelegator: AbilityDelegatorRegistry.AbilityDelegator;
let abilityDelegatorArguments: AbilityDelegatorRegistry.AbilityDelegatorArgs;

async function onAbilityCreateCallback() {
  Logger.info('onAbilityCreateCallback');
}

async function addAbilityMonitorCallback(err) {
  Logger.info('addAbilityMonitorCallback :', JSON.stringify(err));
}

export default class OpenHarmonyTestRunner implements TestRunner {
  constructor() {
  }

  onPrepare() {
    Logger.info('OpenHarmonyTestRunner OnPrepare ');
  }

  async onRun() {
    Logger.info('OpenHarmonyTestRunner onRun run');
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
    }
    Logger.info('cmd : %{public}s', cmd)
    abilityDelegator.executeShellCommand(cmd, (err, d) => {
      Logger.info('executeShellCommand : err :', JSON.stringify(err));
      Logger.info('executeShellCommand : data :', d.stdResult);
    })
    Logger.info('OpenHarmonyTestRunner onRun end');
  }
}