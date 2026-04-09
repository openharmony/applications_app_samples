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

import { hilog } from '@kit.PerformanceAnalysisKit';
import TestRunner from '@ohos.application.testRunner';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

var abilityDelegator: AbilityDelegatorRegistry.AbilityDelegator = undefined;
var abilityDelegatorArguments: AbilityDelegatorRegistry.AbilityDelegatorArgs = undefined;
const MAX_TEST_TIMEOUT_MS = 90000;

function normalizeTimeoutValue(value: string): string {
  const parsedValue = Number(value);
  if (!Number.isFinite(parsedValue) || parsedValue <= 0) {
    return String(MAX_TEST_TIMEOUT_MS);
  }
  return String(Math.min(Math.floor(parsedValue), MAX_TEST_TIMEOUT_MS));
}

function translateParamsToString(parameters) {
  if (parameters === undefined || parameters === null) {
    return '-s timeout ' + String(MAX_TEST_TIMEOUT_MS);
  }
  const keySet: Set<string> = new Set([
    '-s notClass', '-s it',
    '-s level', '-s testType', '-s size', '-s timeout',
    '-s rawClass', '-s rawSuite', '-s rawIt',
    '-s atlasBatch', '-s coreBatch', '-s uiCaseBatch',
    '-s dryRun'
  ]);
  const targetParams: Array<string> = [];
  let hasTimeout = false;
  for (const key in parameters) {
    const value = parameters[key];
    if (typeof value !== 'string' || value.length === 0) {
      continue;
    }
    if (key === '-s class') {
      targetParams.push('-s rawClass', value);
      targetParams.push(key, value);
      continue;
    }
    if (key === '-s suite') {
      targetParams.push('-s rawSuite', value);
      targetParams.push(key, value);
      continue;
    }
    if (key === '-s it') {
      targetParams.push('-s rawIt', value);
      targetParams.push(key, value);
      continue;
    }
    if (keySet.has(key)) {
      if (key === '-s timeout') {
        hasTimeout = true;
        targetParams.push(key, normalizeTimeoutValue(value));
        continue;
      }
      targetParams.push(key, value);
    }
  }
  if (!hasTimeout) {
    targetParams.push('-s timeout', String(MAX_TEST_TIMEOUT_MS));
  }
  return targetParams.join(' ').trim();
}

async function onAbilityCreateCallback() {
  hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
  hilog.info(0x0000, 'testTag', '%{public}s', 'onAbilityCreateCallback');
}

async function addAbilityMonitorCallback(err: any) {
  hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
  hilog.info(0x0000, 'testTag', 'addAbilityMonitorCallback : %{public}s', JSON.stringify(err) ?? '');
}

export default class OpenHarmonyTestRunner implements TestRunner {
  constructor() {
  }

  onPrepare() {
    hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
    hilog.info(0x0000, 'testTag', '%{public}s', 'OpenHarmonyTestRunner OnPrepare ');
  }

  async onRun() {
    hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
    hilog.info(0x0000, 'testTag', '%{public}s', 'OpenHarmonyTestRunner onRun run');
    abilityDelegatorArguments = AbilityDelegatorRegistry.getArguments();
    abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
    const parameters = abilityDelegatorArguments.parameters ?? {};
    var testAbilityName: string = abilityDelegatorArguments.bundleName + '.TestAbility';
    let lMonitor: AbilityDelegatorRegistry.AbilityMonitor = {
      abilityName: testAbilityName,
      onAbilityCreate: onAbilityCreateCallback,
    };
    abilityDelegator.addAbilityMonitor(lMonitor, addAbilityMonitorCallback);
    var cmd: string = 'aa start -d 0 -a TestAbility' + ' -b ' + abilityDelegatorArguments.bundleName;
    cmd += ' ' + translateParamsToString(parameters);
    var debug: string = parameters['-D'];
    if (debug === 'true') {
      cmd += ' -D';
    }
    hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
    hilog.info(0x0000, 'testTag', 'cmd : %{public}s', cmd);
    abilityDelegator.executeShellCommand(cmd,
      (err: any, d: any) => {
        hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
        hilog.info(0x0000, 'testTag', 'executeShellCommand : err : %{public}s', JSON.stringify(err) ?? '');
        hilog.info(0x0000, 'testTag', 'executeShellCommand : data : %{public}s', d.stdResult ?? '');
        hilog.info(0x0000, 'testTag', 'executeShellCommand : data : %{public}s', d.exitCode ?? '');
      });
    hilog.info(0x0000, 'testTag', '%{public}s', 'OpenHarmonyTestRunner onRun end');
  }
};
