/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

var abilityDelegator = undefined;
var abilityDelegatorArguments = undefined;
const DOMAIN = 0x0000;
const TAG = 'testTag';
function translateParamsToString(parameters) {
  const keySet = new Set([
    '-s class', '-s notClass', '-s suite', '-s it',
    '-s level', '-s testType', '-s size', '-s timeout',
    '-s dryRun'
  ]);
  let targetParams = '';
  for (const key in parameters) {
    if (keySet.has(key)) {
      targetParams = `${targetParams} ${key} ${parameters[key]}`;
    }
  }
  return targetParams.trim();
}

async function onAbilityCreateCallback() {
  hilog.isLoggable(DOMAIN, TAG, hilog.LogLevel.INFO);
  hilog.info(DOMAIN, TAG, '%{public}s', 'onAbilityCreateCallback');
}

async function addAbilityMonitorCallback(err: any) {
  hilog.isLoggable(DOMAIN, TAG, hilog.LogLevel.INFO);
  hilog.info(DOMAIN, TAG, 'addAbilityMonitorCallback : %{public}s', JSON.stringify(err) ?? '');
}

export default class OpenHarmonyTestRunner implements TestRunner {
  onPrepare() {
    hilog.isLoggable(DOMAIN, TAG, hilog.LogLevel.INFO);
    hilog.info(DOMAIN, TAG, '%{public}s', 'OpenHarmonyTestRunner OnPrepare ');
  }

  async onRun() {
    hilog.isLoggable(DOMAIN, TAG, hilog.LogLevel.INFO);
    hilog.info(DOMAIN, TAG, '%{public}s', 'OpenHarmonyTestRunner onRun run');
    abilityDelegatorArguments = AbilityDelegatorRegistry.getArguments();
    abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
    var testAbilityName = abilityDelegatorArguments.bundleName + '.TestAbility';
    let lMonitor = {
      abilityName: testAbilityName,
      onAbilityCreate: onAbilityCreateCallback,
    };
    abilityDelegator.addAbilityMonitor(lMonitor, addAbilityMonitorCallback);
    var cmd = 'aa start -d 0 -a TestAbility' + ' -b ' + abilityDelegatorArguments.bundleName;
    cmd += ' ' + translateParamsToString(abilityDelegatorArguments.parameters);
    var debug = abilityDelegatorArguments.parameters['-D'];
    if (debug == 'true') {
      cmd += ' -D';
    }
    hilog.isLoggable(DOMAIN, TAG, hilog.LogLevel.INFO);
    hilog.info(DOMAIN, TAG, 'cmd : %{public}s', cmd);
    abilityDelegator.executeShellCommand(cmd,
      (err: any, d: any) => {
        hilog.isLoggable(DOMAIN, TAG, hilog.LogLevel.INFO);
        hilog.info(DOMAIN, TAG, 'executeShellCommand : err : %{public}s', JSON.stringify(err) ?? '');
        hilog.info(DOMAIN, TAG, 'executeShellCommand : data : %{public}s', d.stdResult ?? '');
        hilog.info(DOMAIN, TAG, 'executeShellCommand : data : %{public}s', d.exitCode ?? '');
      });
    hilog.info(DOMAIN, TAG, '%{public}s', 'OpenHarmonyTestRunner onRun end');
  }
}