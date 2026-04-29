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

let abilityDelegator: abilityDelegatorRegistry.AbilityDelegator | undefined = undefined;
let abilityDelegatorArguments: abilityDelegatorRegistry.AbilityDelegatorArgs | undefined = undefined;

function translateParamsToString(parameters: Record<string, string>): string {
  const supportKeys: Set<string> = new Set([
    '-s class', '-s notClass', '-s suite', '-s it',
    '-s level', '-s testType', '-s size', '-s timeout',
    '-s dryRun'
  ]);
  let targetParams: string = '';
  for (const key in parameters) {
    if (supportKeys.has(key)) {
      targetParams = `${targetParams} ${key} ${parameters[key]}`;
    }
  }
  return targetParams.trim();
}

async function onAbilityCreateCallback(): Promise<void> {
  hilog.info(0x0000, 'TVLauncherTest', '%{public}s', 'TestAbility create callback');
}

function addAbilityMonitorCallback(err: object): void {
  hilog.info(0x0000, 'TVLauncherTest', 'add monitor result %{public}s', JSON.stringify(err) ?? '');
}

export default class OpenHarmonyTestRunner implements TestRunner {
  onPrepare() {
    hilog.info(0x0000, 'TVLauncherTest', '%{public}s', 'OpenHarmonyTestRunner onPrepare');
  }

  async onRun() {
    abilityDelegatorArguments = abilityDelegatorRegistry.getArguments();
    abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();

    const testAbilityName: string = `${abilityDelegatorArguments.bundleName}.TestAbility`;
    const monitor: abilityDelegatorRegistry.AbilityMonitor = {
      abilityName: testAbilityName,
      onAbilityCreate: onAbilityCreateCallback
    };
    abilityDelegator.addAbilityMonitor(monitor, addAbilityMonitorCallback);

    let command: string = `aa start -d 0 -a TestAbility -b ${abilityDelegatorArguments.bundleName}`;
    command += ` ${translateParamsToString(abilityDelegatorArguments.parameters as Record<string, string>)}`;
    if (abilityDelegatorArguments.parameters['-D'] === 'true') {
      command += ' -D';
    }

    hilog.info(0x0000, 'TVLauncherTest', 'runner command %{public}s', command);
    abilityDelegator.executeShellCommand(command, (err: object, data: { stdResult?: string; exitCode?: number }) => {
      hilog.info(0x0000, 'TVLauncherTest', 'runner shell err %{public}s', JSON.stringify(err) ?? '');
      hilog.info(0x0000, 'TVLauncherTest', 'runner shell result %{public}s', data.stdResult ?? '');
      hilog.info(0x0000, 'TVLauncherTest', 'runner shell exitCode %{public}d', data.exitCode ?? -1);
    });
  }
}
