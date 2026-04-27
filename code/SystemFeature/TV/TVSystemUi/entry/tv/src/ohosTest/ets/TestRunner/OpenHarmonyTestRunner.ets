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
import { abilityDelegatorRegistry, TestRunner } from '@kit.TestKit';

interface RunnerMonitor {
  abilityName: string;
  onAbilityCreate: () => Promise<void>;
}

interface AbilityDelegatorLike {
  addAbilityMonitor(monitor: RunnerMonitor, callback: (err: Object) => Promise<void>): void;
  executeShellCommand(cmd: string, callback: (err: Object, d: ShellCommandResult) => void): void;
}

interface AbilityDelegatorArgsLike {
  bundleName: string;
  parameters?: Object;
}

interface ShellCommandResult {
  stdResult?: string;
  exitCode?: number;
}

type RunnerParameters = Record<string, string>;

let abilityDelegator: AbilityDelegatorLike | undefined = undefined;
let abilityDelegatorArguments: AbilityDelegatorArgsLike | undefined = undefined;

function translateParamsToString(parameters: RunnerParameters): string {
  const keySet: Set<string> = new Set([
    '-s class', '-s notClass', '-s suite', '-s it',
    '-s level', '-s testType', '-s size', '-s timeout',
    '-s dryRun'
  ]);
  let targetParams: string = '';
  const keys: string[] = Object.keys(parameters);
  for (const key of keys) {
    if (keySet.has(key)) {
      targetParams = `${targetParams} ${key} ${parameters[key]}`;
    }
  }
  return targetParams.trim();
}

async function onAbilityCreateCallback() {
  hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
  hilog.info(0x0000, 'testTag', '%{public}s', 'onAbilityCreateCallback');
}

async function addAbilityMonitorCallback(err: Object): Promise<void> {
  hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
  hilog.info(0x0000, 'testTag', 'addAbilityMonitorCallback : %{public}s', JSON.stringify(err) ?? '');
}

export default class OpenHarmonyTestRunner implements TestRunner {
  constructor() {
  }

  onPrepare(): void {
    hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
    hilog.info(0x0000, 'testTag', '%{public}s', 'OpenHarmonyTestRunner OnPrepare ');
  }

  async onRun() {
    hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
    hilog.info(0x0000, 'testTag', '%{public}s', 'OpenHarmonyTestRunner onRun run');
    abilityDelegatorArguments = abilityDelegatorRegistry.getArguments() as AbilityDelegatorArgsLike;
    abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator() as AbilityDelegatorLike;
    if (!abilityDelegatorArguments || !abilityDelegator) {
      hilog.info(0x0000, 'testTag', '%{public}s', 'abilityDelegator is undefined');
      return;
    }
    let testAbilityName: string = abilityDelegatorArguments.bundleName + '.TestAbility';
    let lMonitor: RunnerMonitor = {
      abilityName: testAbilityName,
      onAbilityCreate: onAbilityCreateCallback,
    };
    abilityDelegator.addAbilityMonitor(lMonitor, addAbilityMonitorCallback);
    let cmd: string = 'aa start -d 0 -a TestAbility' + ' -b ' + abilityDelegatorArguments.bundleName;
    let parameters: RunnerParameters = abilityDelegatorArguments.parameters as RunnerParameters;
    let targetModule: string = parameters['-m'];
    if (targetModule) {
      cmd += ' -m ' + targetModule;
    }
    cmd += ' ' + translateParamsToString(parameters);
    let debug: string = parameters['-D'];
    if (debug === 'true') {
      cmd += ' -D';
    }
    hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
    hilog.info(0x0000, 'testTag', 'cmd : %{public}s', cmd);
    abilityDelegator.executeShellCommand(cmd,
      (err: Object, d: ShellCommandResult) => {
        hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
        hilog.info(0x0000, 'testTag', 'executeShellCommand : err : %{public}s', JSON.stringify(err) ?? '');
        hilog.info(0x0000, 'testTag', 'executeShellCommand : data : %{public}s', d.stdResult ?? '');
        hilog.info(0x0000, 'testTag', 'executeShellCommand : data : %{public}s', d.exitCode ?? '');
      });
    hilog.info(0x0000, 'testTag', '%{public}s', 'OpenHarmonyTestRunner onRun end');
  }
}
