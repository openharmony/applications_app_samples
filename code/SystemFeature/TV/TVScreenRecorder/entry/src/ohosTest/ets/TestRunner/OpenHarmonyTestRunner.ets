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

import { abilityDelegatorRegistry, TestRunner } from '@kit.TestKit';

interface RunnerArgumentsLike {
    bundleName: string
}

interface AbilityMonitorLike {
    abilityName: string
    onAbilityCreate: () => Promise<void>
}

interface ShellCommandErrorLike {
    code?: number
    message?: string
}

interface ShellCommandResultLike {
    stdResult: string
    exitCode: number
}

async function onAbilityCreateCallback(): Promise<void> {
    console.log('onAbilityCreateCallback');
}

async function addAbilityMonitorCallback(err: ShellCommandErrorLike): Promise<void> {
    console.info('addAbilityMonitorCallback : ' + JSON.stringify(err));
}

export default class OpenHarmonyTestRunner implements TestRunner {
    constructor() {
    }

    onPrepare(): void {
        console.info('OpenHarmonyTestRunner OnPrepare ');
    }

    async onRun(): Promise<void> {
        console.log('OpenHarmonyTestRunner onRun run');
        const abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
        const abilityDelegatorArguments = abilityDelegatorRegistry.getArguments() as RunnerArgumentsLike;
        const testAbilityName = abilityDelegatorArguments.bundleName + '.TestAbility';
        const lMonitor: AbilityMonitorLike = {
            abilityName: testAbilityName,
            onAbilityCreate: onAbilityCreateCallback,
        }
        abilityDelegator.addAbilityMonitor(lMonitor, addAbilityMonitorCallback);
        let cmd = 'aa start -d 0 -a TestAbility' + ' -b ' + abilityDelegatorArguments.bundleName;
        console.info('cmd : ' + cmd);
        abilityDelegator.executeShellCommand(cmd,
            (err: ShellCommandErrorLike, d: ShellCommandResultLike) => {
                console.info('executeShellCommand : err : ' + JSON.stringify(err));
                console.info('executeShellCommand : data : ' + d.stdResult);
                console.info('executeShellCommand : data : ' + d.exitCode);
            });
        console.info('OpenHarmonyTestRunner onRun end');
    }
}
